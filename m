Return-Path: <netdev+bounces-6190-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B97487152CA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B22B280FDA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F114D7EC;
	Tue, 30 May 2023 01:04:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF86A636
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:04:18 +0000 (UTC)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5769D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408657; x=1716944657;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cCSZBa6ZYPdz5a4aOdvIGQvvRY/EdsC2HtLOeSlJg3A=;
  b=eJk5+H5qsa6Bgw5lzhIfKaDdJRTSjdVjaA9tSSjNMdNv8WHxOtczdUkn
   zpOrEtWrrIlzSq+zb0KxHU2qkDyW0AHSHZUsz4gvlzDWfoAwLZUHhcSm5
   eIF6pTaLEK3//XAl4jr5Lk4xcUYDRE83qIn/o14iZP08Kwmsbsjvs/JuY
   Y=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="288204765"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:04:11 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com (Postfix) with ESMTPS id 3277840D73;
	Tue, 30 May 2023 01:04:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:04:08 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Tue, 30 May 2023 01:04:05 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 00/14] udp: Farewell to UDP-Lite.
Date: Mon, 29 May 2023 18:03:34 -0700
Message-ID: <20230530010348.21425-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.39]
X-ClientProxiedBy: EX19D037UWB001.ant.amazon.com (10.13.138.123) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Recently syzkaller reported a 7-year-old null-ptr-deref [0] that occurs
when a UDP-Lite socket tries to allocate a buffer under memory pressure.

Someone should have stumbled on the bug much earlier if UDP-Lite had been
used in a real app.  Additionally, we do not always need a large UDP-Lite
workload to hit the bug since UDP and UDP-Lite share the same memory
accounting limit.

Given no one uses UDP-Lite, we can drop it and simplify UDP code by
removing a bunch of conditionals.

This series removes UDP-Lite support from the core networking stack first
and incrementally removes the dead code.

[0]: https://lore.kernel.org/netdev/20230523163305.66466-1-kuniyu@amazon.com/


Kuniyuki Iwashima (14):
  udp: Random clenaup.
  udplite: Retire UDP-Lite for IPv6.
  ipv6: Remove IPV6_ADDRFORM support for IPPROTO_UDPLITE.
  udplite: Retire UDP-Lite for IPv4.
  udp: Remove UDP-Lite SNMP stats.
  udp: Remove UDPLITE_SEND_CSCOV and UDPLITE_RECV_CSCOV.
  udp: Remove pcslen, pcrlen, and pcflag in struct udp_sock.
  udp: Remove csum branch for UDP-Lite.
  udp: Don't pass proto to udp[46]_csum_init().
  udp: Don't pass proto to __udp[46]_lib_rcv().
  udp: Optimise ulen tests in __udp[46]_lib_rcv().
  udp: Remove udp_table in struct proto.
  udp: Remove udp_table in struct udp_seq_afinfo.
  udp: Don't pass udp_table to __udp[46]_lib_lookup().

 include/linux/udp.h        |  14 +-
 include/net/ip6_checksum.h |   1 -
 include/net/ipv6.h         |   2 -
 include/net/ipv6_stubs.h   |   3 +-
 include/net/netns/mib.h    |   5 -
 include/net/sock.h         |   5 +-
 include/net/transp_v6.h    |   3 -
 include/net/udp.h          |  71 +++----
 include/net/udplite.h      |  86 --------
 net/core/filter.c          |   5 +-
 net/ipv4/Makefile          |   2 +-
 net/ipv4/af_inet.c         |  10 -
 net/ipv4/proc.c            |  15 --
 net/ipv4/udp.c             | 421 ++++++++++++-------------------------
 net/ipv4/udp_bpf.c         |   2 -
 net/ipv4/udp_diag.c        |  84 ++------
 net/ipv4/udp_impl.h        |  29 ---
 net/ipv4/udp_offload.c     |   5 +-
 net/ipv4/udplite.c         | 136 ------------
 net/ipv6/Makefile          |   2 +-
 net/ipv6/af_inet6.c        |  25 +--
 net/ipv6/ip6_checksum.c    |  49 +----
 net/ipv6/ipv6_sockglue.c   |  17 +-
 net/ipv6/proc.c            |  16 --
 net/ipv6/udp.c             | 294 ++++++++++++--------------
 net/ipv6/udp_impl.h        |  31 ---
 net/ipv6/udp_offload.c     |   5 +-
 net/ipv6/udplite.c         | 136 ------------
 28 files changed, 330 insertions(+), 1144 deletions(-)
 delete mode 100644 include/net/udplite.h
 delete mode 100644 net/ipv4/udp_impl.h
 delete mode 100644 net/ipv4/udplite.c
 delete mode 100644 net/ipv6/udp_impl.h
 delete mode 100644 net/ipv6/udplite.c

-- 
2.30.2


