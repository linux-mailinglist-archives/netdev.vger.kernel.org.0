Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C335A2713
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343507AbiHZLrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245749AbiHZLrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:47:24 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BB5B275F;
        Fri, 26 Aug 2022 04:47:23 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id az27so1510832wrb.6;
        Fri, 26 Aug 2022 04:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=W6FRq8jCV4bd44pcJI4dgMwS3Avtz/s1q6Q5bpJPprQ=;
        b=CcfMcwAZioHvcygQd81ksSxSJ2pLitKQg+K2cQJhgvgtyg4a7Q3GgH9Ddo+0z7Us62
         bi35e2kEDoo/Sl/2eeAZpQ2Xnn5CUupI4cRSzjhdgvvrxBTU6yl98WchdMVCdrnAv/9O
         BjZmBVjYeufTmXIu80o7bJX7s47VGCSkmNWldubA/nMNhmG6nSE6g5oCezWcVsZWSLn+
         MqJktXgWvrWWyceEt5Jq47C7UbSt0XiPzkT2wTfbFJkHXg1dorPMVpsrOJ92/EufZkZ0
         Z2HrnBRIeu1WYflVtAv0IheiEnifFHidriYbHGPrkQrOEzOFjUZ5UY3jXuh+nIwMI5IW
         qKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=W6FRq8jCV4bd44pcJI4dgMwS3Avtz/s1q6Q5bpJPprQ=;
        b=iYitIdBxdwDHAuGaEPLkwNGt08a1ggAp9gC4CrSnZCSENCg61SN0mrOlt9YPvbOssH
         N6XdO94Wj6WqoO5XGVg3/m5SswhMey0fwPQPVmRoC8jX1phSHsL0eYNqioewCKT3gR3R
         4r11zsyGHh8iD8izyoP3KGhzpJYzbseIlUhZuROh4G5M4mqGFVeoHDfe2cJjsGiQW3S8
         rr60UDHdJNrjdSpsMGXIvpj6W32uKOo0TkihaAZ38Z9EEDLRieYe61Xj1nfr5NFUY9oi
         9lIWsgqns3FnAmhD9Yz3gaJ0uj23PRbOguujB9VHC9XRrXcDyIfk4/sO0o25gyoDHClu
         S1xA==
X-Gm-Message-State: ACgBeo0zsCV4c3eATz7/LB/T/+omylMtG/zE5LKjQK7oKbCiVvZPbGWi
        fMO4Q+tA+2vmsdwfX7mUOLI=
X-Google-Smtp-Source: AA6agR6UctwR1hSwHqHzZFrlRckxVe5ou7jQudN15SIexKB2ZmocYPXlK62/bxRUDxJSpYGIFFWZWQ==
X-Received: by 2002:a5d:6d0d:0:b0:225:2df4:1f51 with SMTP id e13-20020a5d6d0d000000b002252df41f51mr4745436wrq.398.1661514441906;
        Fri, 26 Aug 2022 04:47:21 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id w11-20020adfee4b000000b002254880c049sm1811322wro.31.2022.08.26.04.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 04:47:21 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, razor@blackwall.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next,v4 3/3] xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode
Date:   Fri, 26 Aug 2022 14:47:00 +0300
Message-Id: <20220826114700.2272645-4-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220826114700.2272645-1-eyal.birger@gmail.com>
References: <20220826114700.2272645-1-eyal.birger@gmail.com>
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

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

----

v4: use NLA_U32 for LWT_XFRM_LINK as suggested by Nicolas Dichtel

v3: netlink improvements as suggested by Nikolay Aleksandrov and
    Nicolas Dichtel

v2:
  - move lwt_xfrm_info() helper to dst_metadata.h
  - add "link" property as suggested by Nicolas Dichtel
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
2.34.1

