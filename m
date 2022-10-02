Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E625F21F7
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJBIRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJBIR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:17:29 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520E13F1E2
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:17:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C1EA7200AC;
        Sun,  2 Oct 2022 10:17:25 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4LpuC70KSuXo; Sun,  2 Oct 2022 10:17:25 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 69A7E2055E;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 5BE2180004A;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:17:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:17:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id F12293182A0D; Sun,  2 Oct 2022 10:17:21 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 05/24] xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode
Date:   Sun, 2 Oct 2022 10:16:53 +0200
Message-ID: <20221002081712.757515-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

Allow specifying the xfrm interface if_id and link as part of a route
metadata using the lwtunnel infrastructure.

This allows for example using a single xfrm interface in collect_md
mode as the target of multiple routes each specifying a different if_id.

With the appropriate changes to iproute2, considering an xfrm device
ipsec1 in collect_md mode one can for example add a route specifying
an if_id like so:

ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1

In which case traffic routed to the device via this route would use
if_id in the xfrm interface policy lookup.

Or in the context of vrf, one can also specify the "link" property:

ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1 link_dev eth15

Note: LWT_XFRM_LINK uses NLA_U32 similar to IFLA_XFRM_LINK even though
internally "link" is signed. This is consistent with other _LINK
attributes in other devices as well as in bpf and should not have an
effect as device indexes can't be negative.

Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/dst_metadata.h    | 11 +++++
 include/uapi/linux/lwtunnel.h | 10 +++++
 net/core/lwtunnel.c           |  1 +
 net/xfrm/xfrm_interface.c     | 85 +++++++++++++++++++++++++++++++++++
 4 files changed, 107 insertions(+)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index e4b059908cc7..57f75960fa28 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -60,13 +60,24 @@ skb_tunnel_info(const struct sk_buff *skb)
 	return NULL;
 }
 
+static inline struct xfrm_md_info *lwt_xfrm_info(struct lwtunnel_state *lwt)
+{
+	return (struct xfrm_md_info *)lwt->data;
+}
+
 static inline struct xfrm_md_info *skb_xfrm_md_info(const struct sk_buff *skb)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+	struct dst_entry *dst;
 
 	if (md_dst && md_dst->type == METADATA_XFRM)
 		return &md_dst->u.xfrm_info;
 
+	dst = skb_dst(skb);
+	if (dst && dst->lwtstate &&
+	    dst->lwtstate->type == LWTUNNEL_ENCAP_XFRM)
+		return lwt_xfrm_info(dst->lwtstate);
+
 	return NULL;
 }
 
diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index 2e206919125c..229655ef792f 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -15,6 +15,7 @@ enum lwtunnel_encap_types {
 	LWTUNNEL_ENCAP_SEG6_LOCAL,
 	LWTUNNEL_ENCAP_RPL,
 	LWTUNNEL_ENCAP_IOAM6,
+	LWTUNNEL_ENCAP_XFRM,
 	__LWTUNNEL_ENCAP_MAX,
 };
 
@@ -111,4 +112,13 @@ enum {
 
 #define LWT_BPF_MAX_HEADROOM 256
 
+enum {
+	LWT_XFRM_UNSPEC,
+	LWT_XFRM_IF_ID,
+	LWT_XFRM_LINK,
+	__LWT_XFRM_MAX,
+};
+
+#define LWT_XFRM_MAX (__LWT_XFRM_MAX - 1)
+
 #endif /* _UAPI_LWTUNNEL_H_ */
diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 9ccd64e8a666..6fac2f0ef074 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -50,6 +50,7 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
 		return "IOAM6";
 	case LWTUNNEL_ENCAP_IP6:
 	case LWTUNNEL_ENCAP_IP:
+	case LWTUNNEL_ENCAP_XFRM:
 	case LWTUNNEL_ENCAP_NONE:
 	case __LWTUNNEL_ENCAP_MAX:
 		/* should not have got here */
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index e9a355047468..5a67b120c4db 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -60,6 +60,88 @@ struct xfrmi_net {
 	struct xfrm_if __rcu *collect_md_xfrmi;
 };
 
+static const struct nla_policy xfrm_lwt_policy[LWT_XFRM_MAX + 1] = {
+	[LWT_XFRM_IF_ID]	= NLA_POLICY_MIN(NLA_U32, 1),
+	[LWT_XFRM_LINK]		= NLA_POLICY_MIN(NLA_U32, 1),
+};
+
+static void xfrmi_destroy_state(struct lwtunnel_state *lwt)
+{
+}
+
+static int xfrmi_build_state(struct net *net, struct nlattr *nla,
+			     unsigned int family, const void *cfg,
+			     struct lwtunnel_state **ts,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[LWT_XFRM_MAX + 1];
+	struct lwtunnel_state *new_state;
+	struct xfrm_md_info *info;
+	int ret;
+
+	ret = nla_parse_nested(tb, LWT_XFRM_MAX, nla, xfrm_lwt_policy, extack);
+	if (ret < 0)
+		return ret;
+
+	if (!tb[LWT_XFRM_IF_ID]) {
+		NL_SET_ERR_MSG(extack, "if_id must be set");
+		return -EINVAL;
+	}
+
+	new_state = lwtunnel_state_alloc(sizeof(*info));
+	if (!new_state) {
+		NL_SET_ERR_MSG(extack, "failed to create encap info");
+		return -ENOMEM;
+	}
+
+	new_state->type = LWTUNNEL_ENCAP_XFRM;
+
+	info = lwt_xfrm_info(new_state);
+
+	info->if_id = nla_get_u32(tb[LWT_XFRM_IF_ID]);
+
+	if (tb[LWT_XFRM_LINK])
+		info->link = nla_get_u32(tb[LWT_XFRM_LINK]);
+
+	*ts = new_state;
+	return 0;
+}
+
+static int xfrmi_fill_encap_info(struct sk_buff *skb,
+				 struct lwtunnel_state *lwt)
+{
+	struct xfrm_md_info *info = lwt_xfrm_info(lwt);
+
+	if (nla_put_u32(skb, LWT_XFRM_IF_ID, info->if_id) ||
+	    (info->link && nla_put_u32(skb, LWT_XFRM_LINK, info->link)))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int xfrmi_encap_nlsize(struct lwtunnel_state *lwtstate)
+{
+	return nla_total_size(sizeof(u32)) + /* LWT_XFRM_IF_ID */
+		nla_total_size(sizeof(u32)); /* LWT_XFRM_LINK */
+}
+
+static int xfrmi_encap_cmp(struct lwtunnel_state *a, struct lwtunnel_state *b)
+{
+	struct xfrm_md_info *a_info = lwt_xfrm_info(a);
+	struct xfrm_md_info *b_info = lwt_xfrm_info(b);
+
+	return memcmp(a_info, b_info, sizeof(*a_info));
+}
+
+static const struct lwtunnel_encap_ops xfrmi_encap_ops = {
+	.build_state	= xfrmi_build_state,
+	.destroy_state	= xfrmi_destroy_state,
+	.fill_encap	= xfrmi_fill_encap_info,
+	.get_encap_size = xfrmi_encap_nlsize,
+	.cmp_encap	= xfrmi_encap_cmp,
+	.owner		= THIS_MODULE,
+};
+
 #define for_each_xfrmi_rcu(start, xi) \
 	for (xi = rcu_dereference(start); xi; xi = rcu_dereference(xi->next))
 
@@ -1080,6 +1162,8 @@ static int __init xfrmi_init(void)
 	if (err < 0)
 		goto rtnl_link_failed;
 
+	lwtunnel_encap_add_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
+
 	xfrm_if_register_cb(&xfrm_if_cb);
 
 	return err;
@@ -1098,6 +1182,7 @@ static int __init xfrmi_init(void)
 static void __exit xfrmi_fini(void)
 {
 	xfrm_if_unregister_cb();
+	lwtunnel_encap_del_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
 	rtnl_link_unregister(&xfrmi_link_ops);
 	xfrmi4_fini();
 	xfrmi6_fini();
-- 
2.25.1

