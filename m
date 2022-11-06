Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9961C61E5EE
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 21:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiKFUe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 15:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiKFUeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 15:34:25 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4091145E
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 12:34:24 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id hh9so5950630qtb.13
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 12:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5SAVHI2PokHsTs3+GXMivo8gDzDMbo6/PQrZsTLdF0M=;
        b=LfgX5WTIAKemDh8DOb0j+KkF+IixmjgdnqAgcQ4g/XV7TV/boMB/rs7IoDoYTkRT7d
         EE76WthFw+Vc07RmMfDiNfFWMnYdY4RCFA48PA46uQs67iXuuRFJeppPj4v8L2Gd3dna
         sJbrPQ2RBbsHtl81mZV0gzM0rOpE+JYKAp8rdVk8PXEEDuP9tVFkggNEx+h6OIW3IE06
         QhXBEO66mWtVhwxdxytq1K2+Y7wTwbzT6P90YS0EawVstCst7k8WX/7TLazT9+MpXNcP
         UXUtKHpOIJOMUTOOrBU3E3V4HN6TG4RMA6VGmSj2pt79+oeooSX/TcYBVUcRbpT745xV
         PbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5SAVHI2PokHsTs3+GXMivo8gDzDMbo6/PQrZsTLdF0M=;
        b=xYCXQYMp/WXNavdA8Atp9fv47sqse/duAc4MzofW1eNB+qIDOcKEWIKv+c+EnrGeaL
         gcBveawL1775DgRmbAl7z/SWFpSPyXhaRrX5u1uQqyavAM5Y2iMtHP+exOiP5pe8zVmp
         TCrOn7JI3uHm6N0bNSPr6cWOhxSHz+G9opbpx4v2tnUDAv/uDEsS7OhBfZgJzqLXNrRZ
         CCHwvyBumCEBBIMXmfQFzSyAR4Q2R8mCVyX9sW9toqRCDmP6XoQOVfax34XY8whoayeD
         YEDT2DinO0wy7v4kvTzKc9GZO3YE7INlQXVCNm2U0iXWn25SDtvgFYyHjuSi5inxR5Aq
         PrCw==
X-Gm-Message-State: ACrzQf1dsdOfS4eABxPoLGrTwSynq1u/rwfQY8SpZhnKaSqPTxgASZko
        iIUZjvt8B5Spv56UiuEieOI7vYSG/79mDQ==
X-Google-Smtp-Source: AMsMyM7FxsTb5/Vv8vc23BOzPrIRofeYzkp7fsEjfVlbWo20Pki0rLlOU+ehFelChN+NMGuLADbxmQ==
X-Received: by 2002:ac8:5ec8:0:b0:3a5:3136:6c0e with SMTP id s8-20020ac85ec8000000b003a531366c0emr27209727qtx.663.1667766863550;
        Sun, 06 Nov 2022 12:34:23 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t31-20020a05622a181f00b003a540320070sm4703551qtc.6.2022.11.06.12.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 12:34:23 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv4 net-next 1/4] net: move the ct helper function to nf_conntrack_helper for ovs and tc
Date:   Sun,  6 Nov 2022 15:34:14 -0500
Message-Id: <e51de1fe776ec5e43bb2f07181924a6d0efac9b1.1667766782.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1667766782.git.lucien.xin@gmail.com>
References: <cover.1667766782.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ovs_ct_helper from openvswitch to nf_conntrack_helper and rename
as nf_ct_helper so that it can be used in TC act_ct in the next patch.
Note that it also adds the checks for the family and proto, as in TC
act_ct, the packets with correct family and proto are not guaranteed.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h |  3 +
 net/netfilter/nf_conntrack_helper.c         | 69 +++++++++++++++++++++
 net/openvswitch/conntrack.c                 | 61 +-----------------
 3 files changed, 73 insertions(+), 60 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 9939c366f720..b6676249eeeb 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -115,6 +115,9 @@ struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags);
 
+int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
+		 enum ip_conntrack_info ctinfo, u16 proto);
+
 void nf_ct_helper_destroy(struct nf_conn *ct);
 
 static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ff737a76052e..88039eedadea 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -26,7 +26,9 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_log.h>
+#include <net/ip.h>
 
 static DEFINE_MUTEX(nf_ct_helper_mutex);
 struct hlist_head *nf_ct_helper_hash __read_mostly;
@@ -240,6 +242,73 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 }
 EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
 
+/* 'skb' should already be pulled to nh_ofs. */
+int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
+		 enum ip_conntrack_info ctinfo, u16 proto)
+{
+	const struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	unsigned int protoff;
+	int err;
+
+	if (ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
+
+	help = nfct_help(ct);
+	if (!help)
+		return NF_ACCEPT;
+
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return NF_ACCEPT;
+
+	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
+	    helper->tuple.src.l3num != proto)
+		return NF_ACCEPT;
+
+	switch (proto) {
+	case NFPROTO_IPV4:
+		protoff = ip_hdrlen(skb);
+		proto = ip_hdr(skb)->protocol;
+		break;
+	case NFPROTO_IPV6: {
+		u8 nexthdr = ipv6_hdr(skb)->nexthdr;
+		__be16 frag_off;
+		int ofs;
+
+		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
+				       &frag_off);
+		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
+			pr_debug("proto header not found\n");
+			return NF_ACCEPT;
+		}
+		protoff = ofs;
+		proto = nexthdr;
+		break;
+	}
+	default:
+		WARN_ONCE(1, "helper invoked on non-IP family!");
+		return NF_DROP;
+	}
+
+	if (helper->tuple.dst.protonum != proto)
+		return NF_ACCEPT;
+
+	err = helper->help(skb, protoff, ct, ctinfo);
+	if (err != NF_ACCEPT)
+		return err;
+
+	/* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
+	 * FTP with NAT) adusting the TCP payload size when mangling IP
+	 * addresses and/or port numbers in the text-based control connection.
+	 */
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
+		return NF_DROP;
+	return NF_ACCEPT;
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper);
+
 /* appropriate ct lock protecting must be taken by caller */
 static int unhelp(struct nf_conn *ct, void *me)
 {
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index c7b10234cf7c..18f54fa38e8f 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -434,65 +434,6 @@ static int ovs_ct_set_labels(struct nf_conn *ct, struct sw_flow_key *key,
 	return 0;
 }
 
-/* 'skb' should already be pulled to nh_ofs. */
-static int ovs_ct_helper(struct sk_buff *skb, u16 proto)
-{
-	const struct nf_conntrack_helper *helper;
-	const struct nf_conn_help *help;
-	enum ip_conntrack_info ctinfo;
-	unsigned int protoff;
-	struct nf_conn *ct;
-	int err;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return NF_ACCEPT;
-
-	help = nfct_help(ct);
-	if (!help)
-		return NF_ACCEPT;
-
-	helper = rcu_dereference(help->helper);
-	if (!helper)
-		return NF_ACCEPT;
-
-	switch (proto) {
-	case NFPROTO_IPV4:
-		protoff = ip_hdrlen(skb);
-		break;
-	case NFPROTO_IPV6: {
-		u8 nexthdr = ipv6_hdr(skb)->nexthdr;
-		__be16 frag_off;
-		int ofs;
-
-		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
-				       &frag_off);
-		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
-			pr_debug("proto header not found\n");
-			return NF_ACCEPT;
-		}
-		protoff = ofs;
-		break;
-	}
-	default:
-		WARN_ONCE(1, "helper invoked on non-IP family!");
-		return NF_DROP;
-	}
-
-	err = helper->help(skb, protoff, ct, ctinfo);
-	if (err != NF_ACCEPT)
-		return err;
-
-	/* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
-	 * FTP with NAT) adusting the TCP payload size when mangling IP
-	 * addresses and/or port numbers in the text-based control connection.
-	 */
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
-		return NF_DROP;
-	return NF_ACCEPT;
-}
-
 /* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
  * value if 'skb' is freed.
  */
@@ -1038,7 +979,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		 */
 		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
 					      info->commit) &&
-		    ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
+		    nf_ct_helper(skb, ct, ctinfo, info->family) != NF_ACCEPT) {
 			return -EINVAL;
 		}
 
-- 
2.31.1

