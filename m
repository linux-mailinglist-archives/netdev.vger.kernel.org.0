Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA224DA282
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 19:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351107AbiCOSkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 14:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351102AbiCOSkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 14:40:42 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F6A340FD
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 11:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647369571; x=1678905571;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ju2zyBaU+zxGG/rTFfKx+CIrxexwUeDO/qTa3W66qVM=;
  b=IXgp/Ki+EyScwZDH0wD7PgVGO5q9Y9CTXR2t5mVxSSR9h+0eVDpsSBl6
   cxklZTrOXzpQ4cQA5lUtUsOO+ZLfnOtheEB6XosucLMg2AWEigwrI81Es
   j2gaKitdE+O/Rwbb2DKAH1hm6vuLu0OCfTv4OP83JGQjoNZHBRLzB9pim
   0=;
X-IronPort-AV: E=Sophos;i="5.90,184,1643673600"; 
   d="scan'208";a="186243672"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-ccb3efe0.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 15 Mar 2022 18:39:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-ccb3efe0.us-east-1.amazon.com (Postfix) with ESMTPS id C7B83C083A;
        Tue, 15 Mar 2022 18:39:27 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Tue, 15 Mar 2022 18:39:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 15 Mar 2022 18:39:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rao Shoaib <Rao.Shoaib@oracle.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net 0/2] af_unix: Fix some OOB implementation.
Date:   Wed, 16 Mar 2022 03:38:53 +0900
Message-ID: <20220315183855.15190-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.124]
X-ClientProxiedBy: EX13D19UWA003.ant.amazon.com (10.43.160.170) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some data-races and adds a missing feature around the
commit 314001f0bf92 ("af_unix: Add OOB support").

Changelog:
  - v3:
    - Add the first patch

  - v2: https://lore.kernel.org/netdev/20220315054801.72035-1-kuniyu@amazon.co.jp/
    - Add READ_ONCE() to avoid a race reported by KCSAN (Eric)
    - Add IS_ENABLED(CONFIG_AF_UNIX_OOB) (Shoaib)

  - v1: https://lore.kernel.org/netdev/20220314052110.53634-1-kuniyu@amazon.co.jp/

Kuniyuki Iwashima (2):
  af_unix: Fix some data-races around unix_sk(sk)->oob_skb.
  af_unix: Support POLLPRI for OOB.

 net/unix/af_unix.c                            | 22 ++++++++++---------
 .../selftests/net/af_unix/test_unix_oob.c     |  6 ++---
 2 files changed, 15 insertions(+), 13 deletions(-)

-- 
2.30.2

