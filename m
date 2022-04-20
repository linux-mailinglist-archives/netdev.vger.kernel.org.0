Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D84A507E7E
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 03:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358828AbiDTCCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358725AbiDTCC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:02:28 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECB3FD07
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 18:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1650419985; x=1681955985;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9RE48sxGgg2es9soBMkmwNszWYao5FelgfCQUnSaA+s=;
  b=RTDf7M5tO77Gxwu5afXj2jxJcYtqEzPGkLApJpLXoNgDyGKq6yl4kNcT
   jOyxcd4SfHnwN/CKMHUZpnfuYazdKYsCcIaa6yYau96GnX4s63gA5TGOk
   Fjtd+PvhC9gvnoQrlL0QBmtxad0rZwp7XZnSqKNQRDCgeSkjZ+biMcIUF
   o=;
X-IronPort-AV: E=Sophos;i="5.90,274,1643673600"; 
   d="scan'208";a="81252197"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 20 Apr 2022 01:59:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id 8271041721;
        Wed, 20 Apr 2022 01:59:42 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Wed, 20 Apr 2022 01:59:40 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.236) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Wed, 20 Apr 2022 01:59:38 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] ipv6: Use ipv6_only_sock helper function.
Date:   Wed, 20 Apr 2022 10:58:49 +0900
Message-ID: <20220420015851.50237-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.236]
X-ClientProxiedBy: EX13D49UWB001.ant.amazon.com (10.43.163.72) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch removes __ipv6_only_sock(), and the second replaces
ipv6only tests with ipv6_only_sock().


Kuniyuki Iwashima (2):
  ipv6: Remove __ipv6_only_sock().
  ipv6: Use ipv6_only_sock() helper in condition.

 drivers/net/bonding/bond_main.c                               | 2 +-
 .../net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c     | 2 +-
 drivers/net/ethernet/netronome/nfp/crypto/tls.c               | 2 +-
 include/linux/ipv6.h                                          | 4 +---
 net/core/filter.c                                             | 2 +-
 net/dccp/ipv6.c                                               | 2 +-
 net/ipv6/af_inet6.c                                           | 2 +-
 net/ipv6/datagram.c                                           | 4 ++--
 net/ipv6/tcp_ipv6.c                                           | 2 +-
 net/ipv6/udp.c                                                | 4 ++--
 net/sctp/ipv6.c                                               | 4 ++--
 12 files changed, 15 insertions(+), 17 deletions(-)

-- 
2.30.2

