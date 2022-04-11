Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA1D4FB995
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345514AbiDKKaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345483AbiDKKaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:06 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E34E43EF35;
        Mon, 11 Apr 2022 03:27:52 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C32ED63046;
        Mon, 11 Apr 2022 12:23:51 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/11] netfilter: nf_log_syslog: Don't ignore unknown protocols
Date:   Mon, 11 Apr 2022 12:27:39 +0200
Message-Id: <20220411102744.282101-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220411102744.282101-1-pablo@netfilter.org>
References: <20220411102744.282101-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

With netdev and bridge nfprotos, loggers may see arbitrary ethernet
frames. Print at least basic info like interfaces and MAC header data.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log_syslog.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index d1dcf36545d7..a7ff6fdbafc9 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -894,6 +894,33 @@ static struct nf_logger nf_ip6_logger __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
+static void nf_log_unknown_packet(struct net *net, u_int8_t pf,
+				  unsigned int hooknum,
+				  const struct sk_buff *skb,
+				  const struct net_device *in,
+				  const struct net_device *out,
+				  const struct nf_loginfo *loginfo,
+				  const char *prefix)
+{
+	struct nf_log_buf *m;
+
+	/* FIXME: Disabled from containers until syslog ns is supported */
+	if (!net_eq(net, &init_net) && !sysctl_nf_log_all_netns)
+		return;
+
+	m = nf_log_buf_open();
+
+	if (!loginfo)
+		loginfo = &default_loginfo;
+
+	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out, loginfo,
+				  prefix);
+
+	dump_mac_header(m, loginfo, skb);
+
+	nf_log_buf_close(m);
+}
+
 static void nf_log_netdev_packet(struct net *net, u_int8_t pf,
 				 unsigned int hooknum,
 				 const struct sk_buff *skb,
@@ -913,6 +940,10 @@ static void nf_log_netdev_packet(struct net *net, u_int8_t pf,
 	case htons(ETH_P_RARP):
 		nf_log_arp_packet(net, pf, hooknum, skb, in, out, loginfo, prefix);
 		break;
+	default:
+		nf_log_unknown_packet(net, pf, hooknum, skb,
+				      in, out, loginfo, prefix);
+		break;
 	}
 }
 
-- 
2.30.2

