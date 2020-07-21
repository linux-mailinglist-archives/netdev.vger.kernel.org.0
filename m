Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1992278BC
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgGUGQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:16:11 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:38701 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGUGQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 02:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1595312170; x=1626848170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=4ax9dUz/9KARBIsD3Uui1dbm+83QHlDTiJb2No+LukU=;
  b=dPJek6+0/f3uP1IWWN/gJLvm1FBQvZZ6XBO/TpXIG+q3rnlEpQXvVzH6
   1fL1A/QICnsZ6PyLebGXrAfxiulPvp7SvBBJybRC1YEDi2rvSiNMxNwKJ
   5mC2nfVHfxqdkZBrHqI9vSfe4wxfPmKUYD1XKBsP2GryVKi0vUBjzEWyu
   I=;
IronPort-SDR: Nb7ldkCZZBcJ1F1O2zXV4otnUM5dx7efLnua0UVTvbPAx2i4oxMfzNFyq4Uw/JYXMU7Srx+njT
 vpdbfVTudMaA==
X-IronPort-AV: E=Sophos;i="5.75,377,1589241600"; 
   d="scan'208";a="53266692"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 21 Jul 2020 06:16:09 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 27F36A409E;
        Tue, 21 Jul 2020 06:16:09 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 06:16:08 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.34) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 06:16:04 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Craig Gallek <kraig@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "Kuniyuki Iwashima" <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <osa-contribution-log@amazon.com>
Subject: [PATCH net 1/2] udp: Copy has_conns in reuseport_grow().
Date:   Tue, 21 Jul 2020 15:15:30 +0900
Message-ID: <20200721061531.94236-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200721061531.94236-1-kuniyu@amazon.co.jp>
References: <20200721061531.94236-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D46UWB001.ant.amazon.com (10.43.161.16) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an unconnected socket in a UDP reuseport group connect()s, has_conns is
set to 1. Then, when a packet is received, udp[46]_lib_lookup2() scans all
sockets in udp_hslot looking for the connected socket with the highest
score.

However, when the number of sockets bound to the port exceeds max_socks,
reuseport_grow() resets has_conns to 0. It can cause udp[46]_lib_lookup2()
to return without scanning all sockets, resulting in that packets sent to
connected sockets may be distributed to unconnected sockets.

Therefore, reuseport_grow() should copy has_conns.

Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
CC: Willem de Bruijn <willemb@google.com>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/core/sock_reuseport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index adcb3aea576d..bbdd3c7b6cb5 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -101,6 +101,7 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
 	more_reuse->prog = reuse->prog;
 	more_reuse->reuseport_id = reuse->reuseport_id;
 	more_reuse->bind_inany = reuse->bind_inany;
+	more_reuse->has_conns = reuse->has_conns;
 
 	memcpy(more_reuse->socks, reuse->socks,
 	       reuse->num_socks * sizeof(struct sock *));
-- 
2.17.2 (Apple Git-113)

