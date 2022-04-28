Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D575136BB
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348258AbiD1OYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345885AbiD1OY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:24:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 462E0AFB22;
        Thu, 28 Apr 2022 07:21:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/3] netfilter: conntrack: fix udp offload timeout sysctl
Date:   Thu, 28 Apr 2022 16:21:08 +0200
Message-Id: <20220428142109.38726-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220428142109.38726-1-pablo@netfilter.org>
References: <20220428142109.38726-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>

`nf_flowtable_udp_timeout` sysctl option is available only
if CONFIG_NFT_FLOW_OFFLOAD enabled. But infra for this flow
offload UDP timeout was added under CONFIG_NF_FLOW_TABLE
config option. So, if you have CONFIG_NFT_FLOW_OFFLOAD
disabled and CONFIG_NF_FLOW_TABLE enabled, the
`nf_flowtable_udp_timeout` is not present in sysfs.
Please note, that TCP flow offload timeout sysctl option
is present even CONFIG_NFT_FLOW_OFFLOAD is disabled.

I suppose it was a typo in commit that adds UDP flow offload
timeout and CONFIG_NF_FLOW_TABLE should be used instead.

Fixes: 975c57504da1 ("netfilter: conntrack: Introduce udp offload timeout configuration")
Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3e1afd10a9b6..55aa55b252b2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -823,7 +823,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-#if IS_ENABLED(CONFIG_NFT_FLOW_OFFLOAD)
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD] = {
 		.procname	= "nf_flowtable_udp_timeout",
 		.maxlen		= sizeof(unsigned int),
-- 
2.30.2

