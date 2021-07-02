Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642A63B99EA
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 02:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbhGBAOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 20:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbhGBAOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 20:14:11 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AA1C061762;
        Thu,  1 Jul 2021 17:11:40 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id g22so9753366iom.1;
        Thu, 01 Jul 2021 17:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Froo3pVmxBy9Mm0Ff8X2esM20Aq/ijCeG8TIGmQDoSU=;
        b=IHgEqonbR2j0/ZGvfBLx6tjXgYoAcJ2QIYnXMIhjF2q+Yw1GD8ntk7d0c1X382pH3U
         5iI2U0TauS4lxyE8Euvh4ZUQRstaT+tg0CRLa+/y+/UO8Coin+9YADcccsm8oUa1T4xp
         T7mY8HMrQ+ly2wRcXGW8cK4KToo7Uf+SoV9PsVgCb5vz4jI09jzMB1PYg1oRRrZ29vRI
         u2+qbqrk4c5+JnXrY9LGaeqEYnhzkTT3Z53KMsbHd4b9wFyPnXXCJteyChcuS5cMadiC
         JWaxcDnW7YRNi57bLxyxPWvnSwrS5RQRQ4KbFxuxLADePKPLfMdJMKdC9+MKnHc/+uF9
         ZJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Froo3pVmxBy9Mm0Ff8X2esM20Aq/ijCeG8TIGmQDoSU=;
        b=GpSWRgDW0uZfZ9lxyuzkUwykd/UU3cZR68C0plFj2bvuDw/QARsqCdhiEW3gYd7l1a
         vbFNgk1rj5eSQalWUby7AEW7mN3sb8wIU2NtpXzI3a/VIkQR2PMn/ZSaX0orhQIwfVuf
         Y51WSZJT9mu021Nkbuk33Y8wnMT6a+1bG4knL1vJ5561948lkRSKHiD2XsoNWfv8TNEq
         idD9Jy8evqwjuGBht8gcHwJG4q5KKjX5083fPzZNXOWhH5C04Uv9S5eLfWaDztVfSjVw
         MY9znMXVM3BmFb1lCZC8Qs5VQSJDNsyWsDDO4nQYSPo2KPnUrbvBxjDDO6+gbTLvY4Hk
         hVig==
X-Gm-Message-State: AOAM533X4jPp6uEf5vp+zKVCO9MwCTwSFag3xXfNiZQf28JI+fnMM8/L
        rdC8/QsKzRwX2a7YfarBrdU=
X-Google-Smtp-Source: ABdhPJwDsbOwFyW+CdRtb0UKNRjt0rQZFISHqObDnVpGiHg+odgCkpEHG36p/ZsvPIoWpbVMPF4EfA==
X-Received: by 2002:a02:caad:: with SMTP id e13mr1980990jap.129.1625184699318;
        Thu, 01 Jul 2021 17:11:39 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id c23sm704010ioz.42.2021.07.01.17.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 17:11:38 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH v2 bpf 0/2] potential sockmap memleak and proc stats fix
Date:   Thu,  1 Jul 2021 17:11:21 -0700
Message-Id: <20210702001123.728035-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While investigating a memleak in sockmap I found these two issues. Patch
1 found doing code review, I wasn't able to get KASAN to trigger a
memleak here, but should be necessary. Patch 2 fixes proc stats so when
we use sockstats for debugging we get correct values.

The fix for observered memleak will come after these, but requires some
more discussion and potentially patch revert so I'll try to get the set
here going now.

John Fastabend (2):
  bpf, sockmap: fix potential memory leak on unlikely error case
  bpf, sockmap: sk_prot needs inuse_idx set for proc stats

 net/core/skmsg.c    | 4 +++-
 net/core/sock_map.c | 9 +++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

-- 
2.25.1

