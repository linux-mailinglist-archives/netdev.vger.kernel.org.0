Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA25359EA3A
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiHWRta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiHWRsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:48:40 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD205558A;
        Tue, 23 Aug 2022 08:46:24 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id d5so7408661wms.5;
        Tue, 23 Aug 2022 08:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=aGpZ22pjo1td/ZEvELwJO1izwL3afks4DDd4sKgSdh0=;
        b=pQjPk4V1UFc7H9inSC+nUAbnANveDxjDK/p7rfSf5FqdnW/amrV26MdIrQG6ykLVWd
         w7qXMSlLwjl2yF+yz9JNTnAuOWNT84z6Tx/wvDNDWIo51g8iw80zxtl0EjMp0ODFCWSx
         Pws4wPeua8zMBFkZpGjXXWZlMxQKTVCn4bXWBy7nF10emqPtd3rwAqROyBEScpAYzCsf
         E0hgMVPvZ+kl2ZCh6ofck2y2P9SkK119MN7O/cFqgd2gL1brZ0s9C4WqVgxjHM3ntgok
         02tbQIWSens/zR4GF21vOlgynU6MKXrBnjCSYAPSZlmggdqQ2++wwOPQhlmS0B1Y3v6C
         jqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=aGpZ22pjo1td/ZEvELwJO1izwL3afks4DDd4sKgSdh0=;
        b=AMjKvHayzQhGJno842I4JYko7tm8IItKmHmzLCdDrb3mHBmSq6HDrgaTbpoVcH8U50
         cVQTJJylcgkPy5rkP+GRFVVGevoidw2QuRQnlF2TPZDPiddl2eM2MnvIUL6NszpGF0k8
         OaRy0St32ehcncDJh5rqoPaaaAj00xd1v2xGd4as0QooT+ti8BU5/44l7d4lqUwhECDh
         dLnvpohLWuRUzp6ee12Fe4ffxlqvmMBwyERN536vl/LoowBa5wfqGt2C0flYBdNQaLub
         b/C4LvbI9CiaR8j0kKVDjdlvnUBwnPHqCEqxAGaA0JZS+4a31XEfQHVlzOssuSTfqylj
         0iJA==
X-Gm-Message-State: ACgBeo3V9Tjk5V+Sl3x5vWOxfzewaBej+EANeZiilKY8PX7y9H8046yS
        TuDqWSI8QbetKHhggHcmZeQ=
X-Google-Smtp-Source: AA6agR7/zEQCAiTvNgtM65VBilQ613il1fHwesCaJaUx24CR/3VFse6mvsXWNsGbGCVT/IXO3h65Mw==
X-Received: by 2002:a05:600c:4f05:b0:3a5:ffec:b6b with SMTP id l5-20020a05600c4f0500b003a5ffec0b6bmr2571865wmq.199.1661269583108;
        Tue, 23 Aug 2022 08:46:23 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id i26-20020a1c541a000000b003a64f684704sm11341211wmb.40.2022.08.23.08.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 08:46:22 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, pablo@netfilter.org,
        contact@proelbtn.com, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, devel@linux-ipsec.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next 3/3] xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode
Date:   Tue, 23 Aug 2022 18:45:57 +0300
Message-Id: <20220823154557.1400380-4-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220823154557.1400380-1-eyal.birger@gmail.com>
References: <20220823154557.1400380-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow specifying the xfrm interface if_id as part of a route metadata
using the lwtunnel infrastructure.

This allows for example using a single xfrm interface in collect_md
mode as the target of multiple routes each specifying a different if_id.

With the appropriate changes to iproute2, considering an xfrm device
ipsec1 in collect_md mode one can for example add a route specifying
an if_id like so:

ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1

In which case traffic routed to the device via this route would use
if_id in the xfrm interface policy lookup.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 include/net/dst_metadata.h    |  6 +++
 include/uapi/linux/lwtunnel.h |  9 ++++
 net/core/lwtunnel.c           |  1 +
 net/xfrm/xfrm_interface.c     | 88 +++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 7e13210b868f..122066595966 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -62,10 +62,16 @@ skb_tunnel_info(const struct sk_buff *skb)
 static inline struct xfrm_md_info *skb_xfrm_md_info(const struct sk_buff *skb)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+	struct dst_entry *dst;
 
 	if (md_dst && md_dst->type == METADATA_XFRM)
 		return &md_dst->u.xfrm_info;
 
+	dst = skb_dst(skb);
+	if (dst && dst->lwtstate &&
+	    dst->lwtstate->type == LWTUNNEL_ENCAP_XFRM)
+		return (struct xfrm_md_info *)dst->lwtstate->data;
+
 	return NULL;
 }
 
diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index 2e206919125c..d26bace86332 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -15,6 +15,7 @@ enum lwtunnel_encap_types {
 	LWTUNNEL_ENCAP_SEG6_LOCAL,
 	LWTUNNEL_ENCAP_RPL,
 	LWTUNNEL_ENCAP_IOAM6,
+	LWTUNNEL_ENCAP_XFRM,
 	__LWTUNNEL_ENCAP_MAX,
 };
 
@@ -111,4 +112,12 @@ enum {
 
 #define LWT_BPF_MAX_HEADROOM 256
 
+enum {
+	LWT_XFRM_UNSPEC,
+	LWT_XFRM_IF_ID,
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
index efb8263e1c22..9f0a5cc2895d 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -60,6 +60,91 @@ struct xfrmi_net {
 	struct xfrm_if __rcu *collect_md_xfrmi;
 };
 
+static inline struct xfrm_md_info *xfrm_lwt(struct lwtunnel_state *lwt)
+{
+	return (struct xfrm_md_info *)lwt->data;
+}
+
+static const struct nla_policy xfrm_lwt_policy[LWT_XFRM_MAX + 1] = {
+	[LWT_XFRM_UNSPEC]	= { .type = NLA_REJECT },
+	[LWT_XFRM_IF_ID]	= { .type = NLA_U32 },
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
+	if (!tb[LWT_XFRM_IF_ID])
+		return -EINVAL;
+
+	new_state = lwtunnel_state_alloc(sizeof(*info));
+	if (!new_state)
+		return -ENOMEM;
+
+	new_state->type = LWTUNNEL_ENCAP_XFRM;
+
+	info = xfrm_lwt(new_state);
+	info->if_id = nla_get_u32(tb[LWT_XFRM_IF_ID]);
+	if (!info->if_id) {
+		ret = -EINVAL;
+		goto errout;
+	}
+	*ts = new_state;
+	return 0;
+
+errout:
+	xfrmi_destroy_state(new_state);
+	kfree(new_state);
+	return ret;
+}
+
+static int xfrmi_fill_encap_info(struct sk_buff *skb,
+				 struct lwtunnel_state *lwt)
+{
+	struct xfrm_md_info *info = xfrm_lwt(lwt);
+
+	if (nla_put_u32(skb, LWT_XFRM_IF_ID, info->if_id))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int xfrmi_encap_nlsize(struct lwtunnel_state *lwtstate)
+{
+	return nla_total_size(4); /* LWT_XFRM_IF_ID */
+}
+
+static int xfrmi_encap_cmp(struct lwtunnel_state *a, struct lwtunnel_state *b)
+{
+	struct xfrm_md_info *a_info = xfrm_lwt(a);
+	struct xfrm_md_info *b_info = xfrm_lwt(b);
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
 
@@ -1076,6 +1161,8 @@ static int __init xfrmi_init(void)
 	if (err < 0)
 		goto rtnl_link_failed;
 
+	lwtunnel_encap_add_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
+
 	xfrm_if_register_cb(&xfrm_if_cb);
 
 	return err;
@@ -1094,6 +1181,7 @@ static int __init xfrmi_init(void)
 static void __exit xfrmi_fini(void)
 {
 	xfrm_if_unregister_cb();
+	lwtunnel_encap_del_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
 	rtnl_link_unregister(&xfrmi_link_ops);
 	xfrmi4_fini();
 	xfrmi6_fini();
-- 
2.34.1

