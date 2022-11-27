Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B3863991F
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 02:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiK0BYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 20:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiK0BYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 20:24:34 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B6F1582D
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 17:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669512273; x=1701048273;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DzChjuEM7ExahJpYAezcaXTl6ZmFK3iNLJhLn/ZNAGA=;
  b=YZM3ThrVxR8gNf+scT+8d4S5S31kU3bndo9rQ7SPCspKa7jUSwPskxDl
   nhL5bAEm0hJXzj4++yuhucpSVJgYai2n4CSHWBLDqZn6KmgpJK4g1jxMM
   TUnI8g77Er/4BDmkXF7vBnH1FGkfkSmpq3SWpQF5H39omBkc013FDAxGe
   0=;
X-IronPort-AV: E=Sophos;i="5.96,197,1665446400"; 
   d="scan'208";a="1077725348"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2022 01:24:28 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com (Postfix) with ESMTPS id 37E1660B13;
        Sun, 27 Nov 2022 01:24:28 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 27 Nov 2022 01:24:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Sun, 27 Nov 2022 01:24:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Felipe Gasper <felipe@felipegasper.com>,
        Wei Chen <harperchen1110@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "Kuniyuki Iwashima" <kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v2 net 0/2] af_unix: Fix a NULL deref in sk_diag_dump_uid().
Date:   Sun, 27 Nov 2022 10:24:10 +0900
Message-ID: <20221127012412.37969-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D27UWB002.ant.amazon.com (10.43.161.167) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixes a NULL deref when we dump a AF_UNIX socket's UID,
and the second patch adds a repro/test for such a case.


Changes:
  v2:
    * Get user_ns from NETLINK_CB(in_skb).sk.
    * Add test.

  v1: https://lore.kernel.org/netdev/20221122205811.20910-1-kuniyu@amazon.com/


Kuniyuki Iwashima (2):
  af_unix: Get user_ns from in_skb in unix_diag_get_exact().
  af_unix: Add test for sock_diag and UDIAG_SHOW_UID.

 net/unix/diag.c                               |  20 +-
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   2 +-
 .../testing/selftests/net/af_unix/diag_uid.c  | 178 ++++++++++++++++++
 4 files changed, 192 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/diag_uid.c

-- 
2.30.2

