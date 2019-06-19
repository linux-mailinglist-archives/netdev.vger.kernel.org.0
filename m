Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED064B244
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbfFSGlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:41:49 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35619 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbfFSGls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:41:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B52E4222E7;
        Wed, 19 Jun 2019 02:41:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 02:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=k1+Cnx4hvFABqBG8HEbbUu5BdAJ74+640iItA8WybLQ=; b=Q4s7xbNK
        dKaIgXkg6Kn1wOvUN5scGmmOphEo7G5Bp72p06ncwxdCpEr4xbY1IzsykOltqCAI
        AifTmP3CrmoRj0pp2AWJ0wEfpDXvFCa0YWBgLrApdaLN93JOYe4lIXPbYpIy6EHJ
        3uOS4vH9sIhx060JgZjlkFDI1kn2RXJc2GdK+yju/r5ktsfhi8pPNQYVpGD9/NjW
        lEr2udwLOg/85XyCd1/L0jz/hXNoawteNPn3bDQZTjHvUk2HK+CFjvB1ZpYmFupx
        Weik1uTGUGw+jbvlJXP4XD5QdA674cYxP4wAWb5yYQz4hjErxDdy3QSSpNOJHNY/
        FIaNVvIODUxeTQ==
X-ME-Sender: <xms:K9kJXaZvIthaQfjCOW40NfcGgHhUFBkh0gqBejKf4WASbVM3d6gSew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddugdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:K9kJXXcNTirdNxgx2awa9Y4kH16oM6VnAWMBLD9yGqWB0aUfM2oOVw>
    <xmx:K9kJXU0B4zL-2kneRjkR137SNgrU3KUf6nA7kTLZxrm1JZzpQWyubg>
    <xmx:K9kJXeK2NyVCUHrjwk75IKa6J3mj44c8OsvKdmkVw0ND4ev3B3Ey1Q>
    <xmx:K9kJXeTry6CXE8fwEUSBrfh6L5k0UOIBtUipS9j1ioVkV8D0FmZ80g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3DBA80060;
        Wed, 19 Jun 2019 02:41:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, jakub.kicinski@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/8] flow_dissector: add support for ingress ifindex dissection
Date:   Wed, 19 Jun 2019 09:41:02 +0300
Message-Id: <20190619064109.849-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619064109.849-1-idosch@idosch.org>
References: <20190619064109.849-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add new key meta that contains ingress ifindex value and add a function
to dissect this from skb. The key and function is prepared to cover
other potential skb metadata values dissection.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/linux/skbuff.h       |  4 ++++
 include/net/flow_dissector.h |  9 +++++++++
 net/core/flow_dissector.c    | 16 ++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 28bdaf978e72..b5d427b149c9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1320,6 +1320,10 @@ skb_flow_dissect_flow_keys_basic(const struct net *net,
 				  data, proto, nhoff, hlen, flags);
 }
 
+void skb_flow_dissect_meta(const struct sk_buff *skb,
+			   struct flow_dissector *flow_dissector,
+			   void *target_container);
+
 void
 skb_flow_dissect_tunnel_info(const struct sk_buff *skb,
 			     struct flow_dissector *flow_dissector,
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index d7ce647a8ca9..02478e48fae4 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -200,6 +200,14 @@ struct flow_dissector_key_ip {
 	__u8	ttl;
 };
 
+/**
+ * struct flow_dissector_key_meta:
+ * @ingress_ifindex: ingress ifindex
+ */
+struct flow_dissector_key_meta {
+	int ingress_ifindex;
+};
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -225,6 +233,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CVLAN, /* struct flow_dissector_key_vlan */
 	FLOW_DISSECTOR_KEY_ENC_IP, /* struct flow_dissector_key_ip */
 	FLOW_DISSECTOR_KEY_ENC_OPTS, /* struct flow_dissector_key_enc_opts */
+	FLOW_DISSECTOR_KEY_META, /* struct flow_dissector_key_meta */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index c0559af9e5e5..01ad60b5aa75 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -199,6 +199,22 @@ __be32 __skb_flow_get_ports(const struct sk_buff *skb, int thoff, u8 ip_proto,
 }
 EXPORT_SYMBOL(__skb_flow_get_ports);
 
+void skb_flow_dissect_meta(const struct sk_buff *skb,
+			   struct flow_dissector *flow_dissector,
+			   void *target_container)
+{
+	struct flow_dissector_key_meta *meta;
+
+	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_META))
+		return;
+
+	meta = skb_flow_dissector_target(flow_dissector,
+					 FLOW_DISSECTOR_KEY_META,
+					 target_container);
+	meta->ingress_ifindex = skb->skb_iif;
+}
+EXPORT_SYMBOL(skb_flow_dissect_meta);
+
 static void
 skb_flow_dissect_set_enc_addr_type(enum flow_dissector_key_id type,
 				   struct flow_dissector *flow_dissector,
-- 
2.20.1

