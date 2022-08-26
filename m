Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFB95A2712
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245728AbiHZLrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiHZLrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:47:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C8AB275F;
        Fri, 26 Aug 2022 04:47:18 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id bq11so1485351wrb.12;
        Fri, 26 Aug 2022 04:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Q3+//r2gh6flOf+0/FrHwBMmtHjXuS4o/XdsyBOadUU=;
        b=NKmgf5seR35ZkBBnnVHVDeknAE1UcJg9Tno8hkkacJKD+qpRwguzBRefa2BrA5jfWR
         +Bq6NT0F+rPybC/XItI2BvZfy4xa3AnGnMwQlebRBaDeHaSrSlYEZnjrhmElvWjwVAuw
         zD2RkED0lcigZi4D6GQIcmjesw38Xgnbwig3FQRMtZVMpSprbJAvhV7kcBC/v2g3xMus
         N8B49NsHAHwj/wrwV7YPDN2RAST31DD/sHvlwlXrJuzZX+Rxs99jQ076Baq1gopFfxjQ
         P8p+ZEs1GAF6d268bPyZ5RJ7+Ccztb34wJjuNB0nNFo8BYucjE9K9EAVuZLCZkYQjMLN
         gBlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Q3+//r2gh6flOf+0/FrHwBMmtHjXuS4o/XdsyBOadUU=;
        b=tFg9kXZK+CC9FHtDIdMwju/SSj2dQFtHLfHxr/IhZZwCqj0yHArIfbiN5H+ALE37/Y
         7DPs2itNIejHmaeL67Qd7ujCkbqufov9/Ftr8OxTJqnrtVCQ4T1UflwOeOt35evSGEP4
         U2bMQm02UolDLyqZEZqnWPFW+UscHumv6gceWfAxxT4oSL0D7sJAkKIJ1PucApmO5QkA
         q2N4Qxw/v6bQWIZdRji2MKB4ZXBaTvogPeWHhOAY85+BE2JoZVCoij6hmLrD1QIb140R
         Bfr9NHCWjFBCd1WRERhGitdQ32oM4VXqFs3mxsWenvegch8ZVQB7TFG1nmdZxDrD17mI
         Qjzg==
X-Gm-Message-State: ACgBeo0dsI5+4Y9DHAiIEsM7Am+1tNkz9qwaYOovd+RJbA98Ktq1kymY
        l0jUkZLZCSlhO3lzR+sOW6Y=
X-Google-Smtp-Source: AA6agR4unAfyT17Kn09oIqorLJ6Onj5xqCZnBz4zl1JvVvlHMYkH+zrFpVDmxFLQVEdu9Tm8JbcfYQ==
X-Received: by 2002:a05:6000:1e1e:b0:226:cf36:6f1d with SMTP id bj30-20020a0560001e1e00b00226cf366f1dmr292271wrb.355.1661514436883;
        Fri, 26 Aug 2022 04:47:16 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id w11-20020adfee4b000000b002254880c049sm1811322wro.31.2022.08.26.04.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 04:47:16 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, razor@blackwall.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next,v4 1/3] net: allow storing xfrm interface metadata in metadata_dst
Date:   Fri, 26 Aug 2022 14:46:58 +0300
Message-Id: <20220826114700.2272645-2-eyal.birger@gmail.com>
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

XFRM interfaces provide the association of various XFRM transformations
to a netdevice using an 'if_id' identifier common to both the XFRM data
structures (polcies, states) and the interface. The if_id is configured by
the controlling entity (usually the IKE daemon) and can be used by the
administrator to define logical relations between different connections.

For example, different connections can share the if_id identifier so
that they pass through the same interface, . However, currently it is
not possible for connections using a different if_id to use the same
interface while retaining the logical separation between them, without
using additional criteria such as skb marks or different traffic
selectors.

When having a large number of connections, it is useful to have a the
logical separation offered by the if_id identifier but use a single
network interface. Similar to the way collect_md mode is used in IP
tunnels.

This patch attempts to enable different configuration mechanisms - such
as ebpf programs, LWT encapsulations, and TC - to attach metadata
to skbs which would carry the if_id. This way a single xfrm interface in
collect_md mode can demux traffic based on this configuration on tx and
provide this metadata on rx.

The XFRM metadata is somewhat similar to ip tunnel metadata in that it
has an "id", and shares similar configuration entities (bpf, tc, ...),
however, it does not necessarily represent an IP tunnel or use other
ip tunnel information, and also has an optional "link" property which
can be used for affecting underlying routing decisions.

Additional xfrm related criteria may also be added in the future.

Therefore, a new metadata type is introduced, to be used in subsequent
patches in the xfrm interface and configuration entities.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

----

v2: add "link" property as suggested by Nicolas Dichtel
---
 include/net/dst_metadata.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index adab27ba1ecb..e4b059908cc7 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -9,6 +9,7 @@
 enum metadata_type {
 	METADATA_IP_TUNNEL,
 	METADATA_HW_PORT_MUX,
+	METADATA_XFRM,
 };
 
 struct hw_port_info {
@@ -16,12 +17,18 @@ struct hw_port_info {
 	u32 port_id;
 };
 
+struct xfrm_md_info {
+	u32 if_id;
+	int link;
+};
+
 struct metadata_dst {
 	struct dst_entry		dst;
 	enum metadata_type		type;
 	union {
 		struct ip_tunnel_info	tun_info;
 		struct hw_port_info	port_info;
+		struct xfrm_md_info	xfrm_info;
 	} u;
 };
 
@@ -53,6 +60,16 @@ skb_tunnel_info(const struct sk_buff *skb)
 	return NULL;
 }
 
+static inline struct xfrm_md_info *skb_xfrm_md_info(const struct sk_buff *skb)
+{
+	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+
+	if (md_dst && md_dst->type == METADATA_XFRM)
+		return &md_dst->u.xfrm_info;
+
+	return NULL;
+}
+
 static inline bool skb_valid_dst(const struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
@@ -82,6 +99,9 @@ static inline int skb_metadata_dst_cmp(const struct sk_buff *skb_a,
 		return memcmp(&a->u.tun_info, &b->u.tun_info,
 			      sizeof(a->u.tun_info) +
 					 a->u.tun_info.options_len);
+	case METADATA_XFRM:
+		return memcmp(&a->u.xfrm_info, &b->u.xfrm_info,
+			      sizeof(a->u.xfrm_info));
 	default:
 		return 1;
 	}
-- 
2.34.1

