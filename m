Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D854267CB6C
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbjAZM5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbjAZM5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:57:43 -0500
Received: from mail.linogate.de (mail.linogate.de [213.179.141.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D19F3C2E
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:57:41 -0800 (PST)
Received: from riab.mowin.de (support.linogate.de [213.179.141.14] (may be forged))
        by mail.linogate.de with ESMTPS id 30QD0gLn018577
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 26 Jan 2023 14:00:42 +0100
Received: from riab.mowin.de (localhost [127.0.0.1])
        (authenticated bits=128)
        by riab.mowin.de with ESMTPSA id 30QCvZak013433
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 13:57:35 +0100
X-Virus-Scanned: by amavisd-new at 
Received: from wolfi.linogate.intern ([192.168.0.163])
        by riab.mowin.de with ESMTP id 30QCvYYf013364;
        Thu, 26 Jan 2023 13:57:34 +0100
From:   wolfgang@linogate.de
To:     steffen.klassert@secunet.com
Cc:     netdev@vger.kernel.org, Wolfgang Nothdurft <wolfgang@linogate.de>
Subject: [PATCH net] xfrm: remove inherited bridge info from skb
Date:   Thu, 26 Jan 2023 13:56:37 +0100
Message-Id: <20230126125637.91969-1-wolfgang@linogate.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 213.179.141.2
X-Scanned-By: MIMEDefang 2.78
X-Greylist: Recipient e-mail whitelisted, not delayed by milter-greylist-4.6.2 (mail.linogate.de [213.179.141.2]); Thu, 26 Jan 2023 14:00:42 +0100 (CET)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wolfgang Nothdurft <wolfgang@linogate.de>

When using a xfrm interface in a bridged setup (the outgoing device is
bridged), the incoming packets in the xfrm interface inherit the bridge
info an confuses the netfilter connection tracking.

brctl show
bridge name     bridge id               STP enabled     interfaces
br_eth1         8000.000c29fe9646       no              eth1

This messes up the connection tracking so that only the outgoing packets
show up and the connections through the xfrm interface are UNREPLIED.
When using stateful netfilter rules, the response packet will be blocked
as state invalid.

telnet 192.168.12.1 7
Trying 192.168.12.1...

conntrack -L
tcp      6 115 SYN_SENT src=192.168.11.1 dst=192.168.12.1 sport=52476
dport=7 packets=2 bytes=104 [UNREPLIED] src=192.168.12.1
dst=192.168.11.1 sport=7 dport=52476 packets=0 bytes=0 mark=0
secctx=system_u:object_r:unlabeled_t:s0 use=1

Chain INPUT (policy DROP 0 packets, 0 bytes)
    2   104 DROP_invalid all -- * * 0.0.0.0/0 0.0.0.0/0  state INVALID

Jan 26 09:28:12 defendo kernel: fw-chk drop [STATE=invalid] IN=ipsec0
OUT= PHYSIN=eth1 MAC= SRC=192.168.12.1 DST=192.168.11.1 LEN=52 TOS=0x00
PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=7 DPT=52476 WINDOW=64240 RES=0x00
ACK SYN URGP=0 MARK=0x1000000

This patch removes the bridge info from the incoming packets on the xfrm
interface, so the packet can be properly assigned to the connection.

Signed-off-by: Wolfgang Nothdurft <wolfgang@linogate.de>
---
 net/xfrm/xfrm_input.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index c06e54a10540..e2c43a5c6c4c 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -541,6 +541,10 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		goto lock;
 	}
 
+	/* strip bridge info from skb */
+	if (skb_ext_exist(skb, SKB_EXT_BRIDGE_NF))
+		skb_ext_del(skb, SKB_EXT_BRIDGE_NF);
+
 	family = XFRM_SPI_SKB_CB(skb)->family;
 
 	/* if tunnel is present override skb->mark value with tunnel i_key */
-- 
2.39.1

