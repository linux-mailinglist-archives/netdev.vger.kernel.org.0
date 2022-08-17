Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57B6597068
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbiHQOCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239974AbiHQOBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:01:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1E598D2E;
        Wed, 17 Aug 2022 07:01:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oOJbf-0008Pi-29; Wed, 17 Aug 2022 16:01:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 06/17] netfilter: nf_ct_ftp: prefer skb_linearize
Date:   Wed, 17 Aug 2022 16:00:04 +0200
Message-Id: <20220817140015.25843-7-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220817140015.25843-1-fw@strlen.de>
References: <20220817140015.25843-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This uses a pseudo-linearization scheme with a 64k global buffer,
but BIG TCP arrival means IPv6 TCP stack can generate skbs
that exceed this size.

Use skb_linearize.  It should be possible to rewrite this to properly
deal with segmented skbs (i.e., only do small chunk-wise accesses),
but this is going to be a lot more intrusive than this because every
helper function needs to get the sk_buff instead of a pointer to a raw
data buffer.

In practice, provided we're really looking at FTP control channel packets,
there should never be a case where we deal with huge packets.

Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ftp.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index a414274338cf..0d9332e9cf71 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -34,11 +34,6 @@ MODULE_DESCRIPTION("ftp connection tracking helper");
 MODULE_ALIAS("ip_conntrack_ftp");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-/* This is slow, but it's simple. --RR */
-static char *ftp_buffer;
-
-static DEFINE_SPINLOCK(nf_ftp_lock);
-
 #define MAX_PORTS 8
 static u_int16_t ports[MAX_PORTS];
 static unsigned int ports_c;
@@ -398,6 +393,9 @@ static int help(struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	if (unlikely(skb_linearize(skb)))
+		return NF_DROP;
+
 	th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
 	if (th == NULL)
 		return NF_ACCEPT;
@@ -411,12 +409,8 @@ static int help(struct sk_buff *skb,
 	}
 	datalen = skb->len - dataoff;
 
-	spin_lock_bh(&nf_ftp_lock);
-	fb_ptr = skb_header_pointer(skb, dataoff, datalen, ftp_buffer);
-	if (!fb_ptr) {
-		spin_unlock_bh(&nf_ftp_lock);
-		return NF_ACCEPT;
-	}
+	spin_lock_bh(&ct->lock);
+	fb_ptr = skb->data + dataoff;
 
 	ends_in_nl = (fb_ptr[datalen - 1] == '\n');
 	seq = ntohl(th->seq) + datalen;
@@ -544,7 +538,7 @@ static int help(struct sk_buff *skb,
 	if (ends_in_nl)
 		update_nl_seq(ct, seq, ct_ftp_info, dir, skb);
  out:
-	spin_unlock_bh(&nf_ftp_lock);
+	spin_unlock_bh(&ct->lock);
 	return ret;
 }
 
@@ -571,7 +565,6 @@ static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 static void __exit nf_conntrack_ftp_fini(void)
 {
 	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
-	kfree(ftp_buffer);
 }
 
 static int __init nf_conntrack_ftp_init(void)
@@ -580,10 +573,6 @@ static int __init nf_conntrack_ftp_init(void)
 
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_ftp_master));
 
-	ftp_buffer = kmalloc(65536, GFP_KERNEL);
-	if (!ftp_buffer)
-		return -ENOMEM;
-
 	if (ports_c == 0)
 		ports[ports_c++] = FTP_PORT;
 
@@ -603,7 +592,6 @@ static int __init nf_conntrack_ftp_init(void)
 	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
-		kfree(ftp_buffer);
 		return ret;
 	}
 
-- 
2.35.1

