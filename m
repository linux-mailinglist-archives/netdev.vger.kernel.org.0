Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABE754CE80
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354891AbiFOQUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345297AbiFOQUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:20:23 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B52BC32;
        Wed, 15 Jun 2022 09:20:22 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id g15so7710158qke.4;
        Wed, 15 Jun 2022 09:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KhvJQk/lpoD/UxhfBs2bUQk+p0iUesfdHs09WQNMZk8=;
        b=QzKC//nwlzuhrZS8xzqybRnSlywBKSAwLI42YlQ8S3fr28sQ0ktHURafbUswPJHsgb
         ZdxqMSVLeDNG8n1axgRstKPgppnktikvN3Kd0HFFGReAoVTU/nQCdyenZmqHsOwek40z
         aMNvR1ecSn9go1fIv6X8eN4Bx+E+/fGDZGoP2urB5PFZ38bD1j/pFHQ4QkQR7/ZrUZdv
         VQ6D4oHnlccqOk6/Nn9lNsrbyiqqz8ZLuG+WXUHMNoqNEV8YtYLrJ5A3HkKnPvC3SQG3
         bUdbexUzn0dC5ZQbJJDu/Iw5RXcJdW5SPiSxH4+1BSTftiLiUMkjsI9d66GkII/cXYhr
         Uk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KhvJQk/lpoD/UxhfBs2bUQk+p0iUesfdHs09WQNMZk8=;
        b=yIPZvxX++fxQhDlBDSSKVMFFt9FM9z1bLyIDKyDOm2ffySzqUElz1ioAtf6f5tm3VM
         F2akfRoY++Hj1yeTXq3ZyD9ArllPGfgpAv/kNBiGw7Xyb7/z/sXsO6NRzUeKmGSjyEUy
         57r/Qp9/o3ysos7a/pK247nS2qASlDhhFtsMn/O07iYIP6+pf6iTbsMeb3XJZ2oOSikC
         TE0Bh0wSNbTMCdqMe252DVTus//U2He+3z24AnB/yutEdc0xxa5Oe19clERDpPJ10YnL
         njotZJ81G99w7DQVCw/18B9/g+dCVvEeTI07Shv8qa2NIUtIkXNdr+iilY4MZmuWyA4P
         oLFQ==
X-Gm-Message-State: AJIora8VzV0UL3LNjJm9qcVIKa6zMfqUXNtEizyB8CkUYtIXRfmoQeG/
        zwOG3EqZuRdXRU1j2wOuMEpyjs82N94=
X-Google-Smtp-Source: AGRyM1to2c0Hg2aCq9Z7CCtBEDn/oLgaYEj30rnhs+GN55e3bTsQda2nGF69Oqavi+GCH0l8uTVDKw==
X-Received: by 2002:a05:620a:4899:b0:6a7:8ca8:acf3 with SMTP id ea25-20020a05620a489900b006a78ca8acf3mr384675qkb.548.1655310020868;
        Wed, 15 Jun 2022 09:20:20 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:a62b:b216:9d84:9f87])
        by smtp.gmail.com with ESMTPSA id az7-20020a05620a170700b006a69ee117b6sm11893918qkb.97.2022.06.15.09.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:20:20 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v4 0/4] sockmap: some performance optimizations
Date:   Wed, 15 Jun 2022 09:20:10 -0700
Message-Id: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
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

This patchset contains two optimizations for sockmap. The first one
eliminates a skb_clone() and the second one eliminates a memset(). With
this patchset, the throughput of UDP transmission via sockmap gets
improved by 61%.

v4: replace kfree_skb() with consume_skb()

v3: avoid touching tcp_recv_skb()

v2: clean up coding style for tcp_read_skb()
    get rid of some redundant variables
    add a comment for ->read_skb()
---
Cong Wang (4):
  tcp: introduce tcp_read_skb()
  net: introduce a new proto_ops ->read_skb()
  skmsg: get rid of skb_clone()
  skmsg: get rid of unncessary memset()

 include/linux/net.h |  4 ++++
 include/net/tcp.h   |  1 +
 include/net/udp.h   |  3 +--
 net/core/skmsg.c    | 48 +++++++++++++++++----------------------------
 net/ipv4/af_inet.c  |  3 ++-
 net/ipv4/tcp.c      | 44 +++++++++++++++++++++++++++++++++++++++++
 net/ipv4/udp.c      | 11 +++++------
 net/ipv6/af_inet6.c |  3 ++-
 net/unix/af_unix.c  | 23 +++++++++-------------
 9 files changed, 86 insertions(+), 54 deletions(-)

-- 
2.34.1

