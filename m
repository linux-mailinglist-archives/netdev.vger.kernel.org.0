Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7313FAEDE
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbhH2WRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 18:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbhH2WRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 18:17:12 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24823C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 15:16:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id d3-20020a17090ae28300b0019629c96f25so5779775pjz.2
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 15:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kPIoMNa6+GkON0uEih9TeTwj2vQOxnrHJ7OzD3wZxNU=;
        b=DfGULPXK6lotazfD3Vgkwt3mNV5Myn0Ug9BpqE1/tykIn9ODTl8a9kTEAnMxfhcF7j
         rg3P3Z5xBivcppfhOww/5P4hxhEks0MQzogqPpEO45lqV4ns4iU57odiB71VVqF6L6gb
         LrsqUQdKE1OuEz8sda5sk6VgX9koz8EZj+dWQ+E8A6JaYSywDinhKfxh/2kinpy0ygW+
         EPC3Oc+atEq6B/1ji7Ll2Dtb68HUHfjydLCYfCwjSkjKdfwo5Jps08tUmINdykshYEw0
         Kq/kF2iW9Hp0Cv8MLIotn8j9uv3Ses+w/xYrtPMiXVC6rzlLmiPaUGuxOKkITos7zi+Z
         Q+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kPIoMNa6+GkON0uEih9TeTwj2vQOxnrHJ7OzD3wZxNU=;
        b=UhXcvZgsnaENY9EYcmPQ8G03alXk/vSqHoJqiXJug+WpOQ2ndPppjR6LwQgqJcVoxi
         VFc/VpLkkY2Es2Kc9s7bEWS1+T1b4YMXP6UW/NpolWdRQFDAAfZMUFB5EKDu4IXS4NHZ
         4ChwOO43Wu0bvSWDQJAmP0dzKECfrNUu8huBZnf984fu9HMFT0fLDSA/7ah3F8t0OpuQ
         bFUbdI4noPVY/n4cms8UnFiKWzKtN8Iy6jgiVSPaTHeNlvJ+VJ/Hl6mvhm3LwfzoBtMF
         NmsdB4VbIo1+A/CeSYaLzaTOrlblTsAfRI6kyFuMtlK3ytQ7eflL5lSuIGVm6onoTzqZ
         7jLA==
X-Gm-Message-State: AOAM531WhDEMlt5MLXPGGyoYglNC2XAd8y9cF2Gr2oWlVKLQLzQS6PO1
        H+hBV0lJHgZEfUyYP5sfRLQ=
X-Google-Smtp-Source: ABdhPJweS+P2taMSdYRDT5/e+a1uNKCe6tVZIg9G6S0tBFMkggQvyiEJPBVcIF7uqTEGrJ+1ncUBIQ==
X-Received: by 2002:a17:902:bd07:b029:12c:f4d5:fc6b with SMTP id p7-20020a170902bd07b029012cf4d5fc6bmr18731938pls.31.1630275379677;
        Sun, 29 Aug 2021 15:16:19 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3934:d27b:77de:86b7])
        by smtp.gmail.com with ESMTPSA id o15sm1162735pjr.0.2021.08.29.15.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 15:16:19 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net 0/2] inet: make exception handling less predictible
Date:   Sun, 29 Aug 2021 15:16:13 -0700
Message-Id: <20210829221615.2057201-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This second round of patches is addressing Keyu Man recommendations
to make linux hosts more robust against a class of brute force attacks.

Eric Dumazet (2):
  ipv6: make exception cache less predictible
  ipv4: make exception cache less predictible

 net/ipv4/route.c | 44 +++++++++++++++++++++++++++++---------------
 net/ipv6/route.c |  5 ++++-
 2 files changed, 33 insertions(+), 16 deletions(-)

-- 
2.33.0.259.gc128427fd7-goog

