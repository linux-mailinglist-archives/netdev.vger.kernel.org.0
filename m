Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3296562CDA0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiKPW20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiKPW2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:28:23 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE1B5F846;
        Wed, 16 Nov 2022 14:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668637702; x=1700173702;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O1lmThy+D/8RfnclBR7idkTa1ROFlFnTH9Scs49ahps=;
  b=ssZ5dJW84j2Gkz2PBfHIL0REj2mk6NdHDP+xe/ZOsyw131/TJSHGd0bz
   PjckOZPh95w0rJCoWwpJkAineITPZDHWrcoL9ktjmiVvVMVzW41bHvXo0
   J4tgb/V9ge3LGMhz08482hghpSmJrVTQnV97o4F/hjyJyKLS0OcspriL0
   4=;
X-IronPort-AV: E=Sophos;i="5.96,169,1665446400"; 
   d="scan'208";a="151530449"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 22:28:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com (Postfix) with ESMTPS id 5A3C1A2B16;
        Wed, 16 Nov 2022 22:28:19 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 16 Nov 2022 22:28:18 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 16 Nov 2022 22:28:15 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Arnaldo Carvalho de Melo <acme@mandriva.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "Mat Martineau" <mathew.j.martineau@linux.intel.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <dccp@vger.kernel.org>
Subject: [PATCH v2 net 0/4] dccp/tcp: Fix bhash2 issues related to WARN_ON() in inet_csk_get_port().
Date:   Wed, 16 Nov 2022 14:28:01 -0800
Message-ID: <20221116222805.64734-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D24UWB004.ant.amazon.com (10.43.161.4) To
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

syzkaller was hitting a WARN_ON() in inet_csk_get_port() in the 4th patch,
which was because we forgot to fix up bhash2 bucket when connect() for a
socket bound to a wildcard address fails in __inet_stream_connect().

There was a similar report [0], but its repro does not fire the WARN_ON() due
to inconsistent error handling.

When connect() for a socket bound to a wildcard address fails, saddr may or
may not be reset depending on where the failure happens.  When we fail in
__inet_stream_connect(), sk->sk_prot->disconnect() resets saddr.  OTOH, in
(dccp|tcp)_v[46]_connect(), if we fail after inet_hash6?_connect(), we
forget to reset saddr.

We fix this inconsistent error handling in the 1st patch, and then we'll
fix the bhash2 WARN_ON() issue.

Note that there is still an issue in that we reset saddr without checking
if there are conflicting sockets in bhash and bhash2, but this should be
another series.

See [1][2] for the previous discussion.

[0]: https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/
[1]: https://lore.kernel.org/netdev/20221029001249.86337-1-kuniyu@amazon.com/
[2]: https://lore.kernel.org/netdev/20221103172419.20977-1-kuniyu@amazon.com/


Changes:
  v2:
    * Add patch 2-4

  v1: [2]


Kuniyuki Iwashima (4):
  dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
  dccp/tcp: Remove NULL check for prev_saddr in
    inet_bhash2_update_saddr().
  dccp/tcp: Don't update saddr before unlinking sk from the old bucket
  dccp/tcp: Fixup bhash2 bucket when connect() fails.

 include/net/inet_hashtables.h |  3 +-
 net/dccp/ipv4.c               | 23 +++---------
 net/dccp/ipv6.c               | 24 +++---------
 net/dccp/proto.c              |  3 +-
 net/ipv4/af_inet.c            | 11 +-----
 net/ipv4/inet_hashtables.c    | 70 ++++++++++++++++++++++++++++++-----
 net/ipv4/tcp.c                |  3 +-
 net/ipv4/tcp_ipv4.c           | 21 +++--------
 net/ipv6/tcp_ipv6.c           | 20 ++--------
 9 files changed, 85 insertions(+), 93 deletions(-)

-- 
2.30.2

