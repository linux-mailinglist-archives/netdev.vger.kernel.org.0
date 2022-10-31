Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC53613A2C
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiJaPgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiJaPgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:36:18 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EC0646B
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:36:16 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id z6so7624390qtv.5
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4YmlNYEB3JeDa5v2K6AcmxLWdhWECZzgqJmgiGN8h1Y=;
        b=qx8BkJ/Jc57hMOfRo7UE2OGMNlDaa26KEvwCMOPzI07G1bqWPN9NCf3xoUo57oO7Ll
         y4vh1OuQK3CzTCano7EibDM3pSX5Bjth+23O3UMVn3uYYN6Xs7rsGVT5dUruFudJH3Eu
         dIOQj5LT9Wjv5icHblER+ANMnDXMogTQngpepS58zAYzQhE7+GK44iPVOa4fULPQlMkp
         HQI89LhTqdHYdUtOCnH8NTyg9BXD4TrIdiKhuxv2eORdrE/gblbn79y6/X/vFzHxybHe
         +akJweAKElxXBj6o4hHuJdSch3MuD2C+xYdPBi8zD0nqcOyK4zfCa4modq64A2WVkjgt
         A7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4YmlNYEB3JeDa5v2K6AcmxLWdhWECZzgqJmgiGN8h1Y=;
        b=tILCV4JbTrB/T6MpEMBdAhMxc197bpFk2lSeTt8ckgE1Zr+58Gq4IgFWhYVEAdcqqG
         kM/EteKf1m0ucdgOGZQqGvvRuBcudjmDHCuRajR92LGBSDjqxjo8TbYbbG12RBvyf9lR
         Lo3BaiUtVn/2/FvSPwylRBX1KdOFAOYQwXgZpQa62QnyZAa+0h4PXMDrtNfoeokJBz4r
         4AAVuprIJZJfi2q/D2BsqUV6WqTDYEYgR3+F8xklpqjbtlttLQafNY0ffl/aLyfIcvA3
         /vznyXFstiPd4aYGpYBchLFbZsi3qTYVYY5u4pgOPScBeZEeln3D5Z0EK82EW8XUKVhR
         VrZw==
X-Gm-Message-State: ACrzQf0C4nsJyGUY7/WVkKQlpxBBFH2FQuYjIpzizaPOSh4qIZbLt/mV
        22sEHO2MgIPjQOF97CAri7iwM1QZF6OKWw==
X-Google-Smtp-Source: AMsMyM7ynVjWObxjaMTvHE3iy7IHEPHrp86mXU5M/ubLSDw5LsHtaGpjRaWwLNjtYd/QNgrpThV8MQ==
X-Received: by 2002:a05:622a:44:b0:3a4:fee9:1260 with SMTP id y4-20020a05622a004400b003a4fee91260mr10904677qtw.143.1667230575018;
        Mon, 31 Oct 2022 08:36:15 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bi29-20020a05620a319d00b006f956766f76sm4957924qkb.1.2022.10.31.08.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 08:36:14 -0700 (PDT)
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
Subject: [PATCHv3 net-next 2/4] net: move add ct helper function to nf_conntrack_helper for ovs and tc
Date:   Mon, 31 Oct 2022 11:36:08 -0400
Message-Id: <9dbf71e653fb1b00f50ca71a8921b733cdbd8cfd.1667230381.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1667230381.git.lucien.xin@gmail.com>
References: <cover.1667230381.git.lucien.xin@gmail.com>
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

Move ovs_ct_add_helper from openvswitch to nf_conntrack_helper and
rename as nf_ct_add_helper, so that it can be used in TC act_ct in
the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h |  2 +
 net/netfilter/nf_conntrack_helper.c         | 31 +++++++++++++++
 net/openvswitch/conntrack.c                 | 44 +++------------------
 3 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 6c32e59fc16f..ad1adbfbeee2 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -116,6 +116,8 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags);
 
 int nf_ct_helper(struct sk_buff *skb, u16 proto);
+int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
+		     u8 proto, bool nat, struct nf_conntrack_helper **hp);
 
 void nf_ct_helper_destroy(struct nf_conn *ct);
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 83615e479f87..1a2ab77d1bd7 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -311,6 +311,37 @@ int nf_ct_helper(struct sk_buff *skb, u16 proto)
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper);
 
+int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
+		     u8 proto, bool nat, struct nf_conntrack_helper **hp)
+{
+	struct nf_conntrack_helper *helper;
+	struct nf_conn_help *help;
+	int ret = 0;
+
+	helper = nf_conntrack_helper_try_module_get(name, family, proto);
+	if (!helper)
+		return -EINVAL;
+
+	help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+	if (!help) {
+		nf_conntrack_helper_put(helper);
+		return -ENOMEM;
+	}
+#if IS_ENABLED(CONFIG_NF_NAT)
+	if (nat) {
+		ret = nf_nat_helper_try_module_get(name, family, proto);
+		if (ret) {
+			nf_conntrack_helper_put(helper);
+			return ret;
+		}
+	}
+#endif
+	rcu_assign_pointer(help->helper, helper);
+	*hp = helper;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_add_helper);
+
 /* appropriate ct lock protecting must be taken by caller */
 static int unhelp(struct nf_conn *ct, void *me)
 {
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 19b5c54615c8..d37011e678c2 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1291,43 +1291,6 @@ int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 	return 0;
 }
 
-static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
-			     const struct sw_flow_key *key, bool log)
-{
-	struct nf_conntrack_helper *helper;
-	struct nf_conn_help *help;
-	int ret = 0;
-
-	helper = nf_conntrack_helper_try_module_get(name, info->family,
-						    key->ip.proto);
-	if (!helper) {
-		OVS_NLERR(log, "Unknown helper \"%s\"", name);
-		return -EINVAL;
-	}
-
-	help = nf_ct_helper_ext_add(info->ct, GFP_KERNEL);
-	if (!help) {
-		nf_conntrack_helper_put(helper);
-		return -ENOMEM;
-	}
-
-#if IS_ENABLED(CONFIG_NF_NAT)
-	if (info->nat) {
-		ret = nf_nat_helper_try_module_get(name, info->family,
-						   key->ip.proto);
-		if (ret) {
-			nf_conntrack_helper_put(helper);
-			OVS_NLERR(log, "Failed to load \"%s\" NAT helper, error: %d",
-				  name, ret);
-			return ret;
-		}
-	}
-#endif
-	rcu_assign_pointer(help->helper, helper);
-	info->helper = helper;
-	return ret;
-}
-
 #if IS_ENABLED(CONFIG_NF_NAT)
 static int parse_nat(const struct nlattr *attr,
 		     struct ovs_conntrack_info *info, bool log)
@@ -1661,9 +1624,12 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 	}
 
 	if (helper) {
-		err = ovs_ct_add_helper(&ct_info, helper, key, log);
-		if (err)
+		err = nf_ct_add_helper(ct_info.ct, helper, ct_info.family,
+				       key->ip.proto, ct_info.nat, &ct_info.helper);
+		if (err) {
+			OVS_NLERR(log, "Failed to add %s helper %d", helper, err);
 			goto err_free_ct;
+		}
 	}
 
 	err = ovs_nla_add_action(sfa, OVS_ACTION_ATTR_CT, &ct_info,
-- 
2.31.1

