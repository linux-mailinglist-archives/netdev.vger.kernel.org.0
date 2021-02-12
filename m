Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0DC31A841
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhBLXXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBLXXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 18:23:01 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D21C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:22:20 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gx20so499478pjb.1
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KXFnznE5FVws9+sJal3HSEQZnFJ0Ou0tSrN9gBeSsa4=;
        b=tSsaTdf5Df5WqvsQnOVKUCC9FjPOACV0tKxG3+NkQW3ED3PL6enaj4yFbE8w3Lj3EA
         frX2Ptp3SkWDxuJSbPwkjqlWAPvre9hdhM9yjyloxHHOYyVo+SdWeD0eDLPARdD2RKoJ
         W8qe6QhI3pjdPx1aKJnw1c947NQEkudHU3xqv3qSKhZ8MzNqrrXMSJHY43xyAc9AUYpy
         5bQCSUenLk67wSURyumCLBmY/LnM4WBSMej9o9MZZsCcwvQcwN99VJaXg87FJ35Ov26S
         vnzF1U3KWTqSp7q+V1cuqgpSqu9NxiTDF3w8cGKEWCEFJHBJ3hf7Jonip99B/JcM6SJJ
         H2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KXFnznE5FVws9+sJal3HSEQZnFJ0Ou0tSrN9gBeSsa4=;
        b=pcb/MxIl8xFcHUBFu8r9MA+VJIHKtjNGhkF1hl1GT0RnDNNYNzLyIznbGUOZwYCzvr
         hZjt2kLV6suU2EvCcHcmqUXjTz32P0+3uFerYgX/vRyCxgt0f17HoScO2FksS4aMq4JC
         QBaFZP2QQVb+smG8sJjTQEuq5fBfB1rD+ikOcL4P/l+PUV/uzyYPuWSYmHVV9L9ke6Jq
         78Rx8kcuBjNsMMChq8NqdSceE87fma7fE52bo3Ah9kdhQsJEoc/9/5bsHd+KsQQlMgB6
         YuQWT5SzYD9ZUB4v9JKc4bwiqjBBCI+5VQ+LjUEKiXYps6KKS4hPZx8LkeVeSfyZnzDK
         tuEQ==
X-Gm-Message-State: AOAM532wY3DU+XbFxl6OBHMlsQDf0e3jVPrlSR7M/wETt1XElsJa1k05
        dHJIlM6pfnStbG/5ebpBnbc=
X-Google-Smtp-Source: ABdhPJyVSqD4ORSiIPAWuHbN0Qra0gMbh4rVCbzWrJ19I0kHvAPc0p1yaSYQt3jEhsY5gxkGREJaVw==
X-Received: by 2002:a17:90a:4888:: with SMTP id b8mr4760533pjh.106.1613172139493;
        Fri, 12 Feb 2021 15:22:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:449f:1ef7:3640:824a])
        by smtp.gmail.com with ESMTPSA id f7sm9160614pjh.45.2021.02.12.15.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 15:22:18 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] tcp: mem pressure vs SO_RCVLOWAT
Date:   Fri, 12 Feb 2021 15:22:12 -0800
Message-Id: <20210212232214.2869897-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

First patch fixes an issue for applications using SO_RCVLOWAT
to reduce context switches.

Second patch is a cleanup.

Eric Dumazet (2):
  tcp: fix SO_RCVLOWAT related hangs under mem pressure
  tcp: factorize logic into tcp_epollin_ready()

 include/net/tcp.h    | 21 +++++++++++++++++++--
 net/ipv4/tcp.c       | 16 ++++------------
 net/ipv4/tcp_input.c | 11 ++---------
 3 files changed, 25 insertions(+), 23 deletions(-)

-- 
2.30.0.478.g8a0d178c01-goog

