Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D3B597727
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241523AbiHQTzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbiHQTzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:55:11 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36D4A2867;
        Wed, 17 Aug 2022 12:55:10 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id y18so11208491qtv.5;
        Wed, 17 Aug 2022 12:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=cfEviQvOb+Hzink1RvRDWrUEAbW7YSnM/8+Nl08rM2o=;
        b=YODif775bmpYr/VHWWMQS+c0fu31clwcFQyQMrjjg6WNb8ilBVqEYpBuhC1K2DHM4B
         BPRB+TSEjCF5peJ2QW+HPJwCMG+NeLrbPYcA9Sua6IdyujU/db9oq/kphxVs9dTOVNjE
         N+oXokeDYXXQNgb8EvlBE+yYQ/tJdPvMFmF2wzxQ4GJaHypIP3baGvjx3PQYnlTvjLJc
         PGsLAqL2enxFrjf53GrwASVDKmiRO+TEn6D0uGKTE7COt5ctxegVUi5zVsfnDBLIVENr
         F3U5HYWj5QKHD1Pq5j9xMFtkaM83GzKCslRO+0oGqjOJg7HRjidTxRc6xvVaMmL/Ju9S
         hEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=cfEviQvOb+Hzink1RvRDWrUEAbW7YSnM/8+Nl08rM2o=;
        b=1SqxdcVqZ69/wOGqCoL+4vOBCM3fLrl4PXavCuBUH7f8O2aRCGbV8j4sPjbEb7k2yf
         praMp74YiyOPzCNfdHJsko8H9WcbDH0hT57zUPd423UMjEO25OPytD3qNjGn3Q2BIABU
         cbFs313Ot+vyEXkoQ1SJjbONPXN3cnDVPnf3JnfXNoQ1kS5lzIowcSOKrqA+/5PCHeOi
         9kANlCPAFIa0xfgl9SqGLuvfCP+TID2aY0wb1CoH0M5DSKaDh0ukF+Duh8yb5z98Mv6N
         2sf1B/EvXJ2tLbx+x0gqoBak/qj5pbPRFug3RY9Lf8L7C0HGVAZoK019gM12SHi7Mgx/
         lEug==
X-Gm-Message-State: ACgBeo2HgWzcKOhzdTRLfQ3zG13GI1oyyrYlMom7WHLkr6Lp/0+uYSFS
        iucL7k0S61nuUDx4Jytfout+nr48YAk=
X-Google-Smtp-Source: AA6agR4eN760fBXj2TRamUKxjsoTUS+8rirz94W/wh75N8pts1+vxVH4RGGGcExKlSad5bS4RdfHZw==
X-Received: by 2002:ac8:5dd1:0:b0:343:7ddc:8d0a with SMTP id e17-20020ac85dd1000000b003437ddc8d0amr20938152qtx.615.1660766109502;
        Wed, 17 Aug 2022 12:55:09 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:b87a:4308:21ec:d026])
        by smtp.gmail.com with ESMTPSA id az30-20020a05620a171e00b006bb8b5b79efsm2225473qkb.129.2022.08.17.12.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:55:08 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net v3 0/4] tcp: some bug fixes for tcp_read_skb()
Date:   Wed, 17 Aug 2022 12:54:41 -0700
Message-Id: <20220817195445.151609-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset contains 3 bug fixes and 1 minor refactor patch for
tcp_read_skb(). V1 only had the first patch, as Eric prefers to fix all
of them together, I have to group them together. Please see each patch
description for more details.

---
v2: add more patches
v3: simplify empty receive queue case

Cong Wang (4):
  tcp: fix sock skb accounting in tcp_read_skb()
  tcp: fix tcp_cleanup_rbuf() for tcp_read_skb()
  tcp: refactor tcp_read_skb() a bit
  tcp: handle pure FIN case correctly

 net/core/skmsg.c |  5 +++--
 net/ipv4/tcp.c   | 49 +++++++++++++++++++++++-------------------------
 2 files changed, 26 insertions(+), 28 deletions(-)

-- 
2.34.1

