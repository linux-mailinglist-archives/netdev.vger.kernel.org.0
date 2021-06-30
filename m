Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1C33B8A3C
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 23:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhF3V4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 17:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhF3V4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 17:56:34 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960D8C061756;
        Wed, 30 Jun 2021 14:54:04 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id t12so4368712ile.13;
        Wed, 30 Jun 2021 14:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zg3zYu9th953ZZZfYt4B4Lq8akk/DU1lhnXvVC0eQ3g=;
        b=i+kdAJgf+t1mlYZj3laa4uG/iBuFbx1bYl8Ok+7ZEeQUpK3PpIm0WyZESqHndLSy+B
         4B/jQoZGn5vMAjhV98rB8yGo8sL/9Q852mlaHv7Qg8yhNLIoIYCu/V5AWbeuVkOoQMkt
         3stS6Q1/QdtFQNjp67Q3J1HQM4jVQrOJgkKwMD3VE4mHZEeEkNpUsRcariSyG4IKjwYD
         ZJ5z2/X5GhmVVOPtO3YVu6ufBTBExcjSdYL21WQJW9MOapgde8WEPillemneLcGXC32V
         4kgS+zZ8LpbyqqE1e0QpLSa3xZCC0OqKHLofZG5MKIH6nJSGf14wsUEf8FXFkf81GnYy
         5dEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zg3zYu9th953ZZZfYt4B4Lq8akk/DU1lhnXvVC0eQ3g=;
        b=jzNR0U/eQKbc3e+hVQp9gbFu8GEbcfRw2ZmaDbW1nUwypA4gR2Zu2AKYlg2YuQ5fhP
         uxmTAfAb0No9zMRo09LSFk7GCWad+SoLI5ofGujHJFhQHsLeJR5+K6/aS8HRm1bqVENs
         EvFakAW3jjIktJPzShp9PMoyeIO8cWZskNgh5leUExUMmScpK7Udqkr7ERPhqfv76nps
         0AfQkdUgh2pCnloEHDB+/YMn9JLGdnt1bVKo9Up87cPoD/wofAgHwrIAhnYslRFcPUo+
         z0ZC+WdXGpsR0zqpKY4zr5etYmWU24skBP9uKr2mKu5Zbpvwh5gWemlFKzemOoOzoSDG
         qCzQ==
X-Gm-Message-State: AOAM5318YAwb/+74xPI3DwKtQzM5nv5Dy5G3jOZ6ww7RfmrW6/PsUq/V
        10SoeigB7gDDPU24dscnNK4=
X-Google-Smtp-Source: ABdhPJw+QZ48RZpUtyWwiHnRHjNbnX0scTr4YfGsDTmyodlOjPbbTn4N2CJLdpXJ5jLyx5UrTbdWzA==
X-Received: by 2002:a05:6e02:ee4:: with SMTP id j4mr2963985ilk.284.1625090043991;
        Wed, 30 Jun 2021 14:54:03 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id b3sm5541210ilm.73.2021.06.30.14.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 14:54:03 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf, sockmap 0/2] potential memleak and proc stats fix
Date:   Wed, 30 Jun 2021 14:53:47 -0700
Message-Id: <20210630215349.73263-1-john.fastabend@gmail.com>
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
 net/core/sock_map.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.25.1

