Return-Path: <netdev+bounces-3556-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 591AC707DA0
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 157C72818CF
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBC5E11CB9;
	Thu, 18 May 2023 10:08:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2171125D3
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:08:27 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4350D1BD2;
	Thu, 18 May 2023 03:08:24 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1pzaYT-0005pC-4L; Thu, 18 May 2023 12:08:17 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Faicker Mo <faicker.mo@ucloud.cn>
Subject: [PATCH net-next 6/9] netfilter: conntrack: allow insertion clash of gre protocol
Date: Thu, 18 May 2023 12:07:56 +0200
Message-Id: <20230518100759.84858-7-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518100759.84858-1-fw@strlen.de>
References: <20230518100759.84858-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Faicker Mo <faicker.mo@ucloud.cn>

NVGRE tunnel is used in the VM-to-VM communications. The VM packets
are encapsulated in NVGRE and sent from the host. For NVGRE
there are two tuples(outer sip and outer dip) in the host conntrack item.
Insertion clashes are more likely to happen if the concurrent connections
are sent from the VM.

Signed-off-by: Faicker Mo <faicker.mo@ucloud.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_gre.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 728eeb0aea87..ad6f0ca40cd2 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -296,6 +296,7 @@ void nf_conntrack_gre_init_net(struct net *net)
 /* protocol helper struct */
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre = {
 	.l4proto	 = IPPROTO_GRE,
+	.allow_clash	 = true,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack = gre_print_conntrack,
 #endif
-- 
2.40.1


