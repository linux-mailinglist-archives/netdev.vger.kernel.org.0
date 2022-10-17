Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763D76017B2
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiJQTbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiJQTbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:31:09 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C1E79689
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:30:08 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id z30so7300693qkz.13
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q965G7dHtW4+bS94YxuVuI6y6VAD4TqrD/zOV7SuO/M=;
        b=Cog/dYbqiLoMNpEL3ExhtOvXbx6jm/eRWNlYt50tNO0XiIDuWD1nD6O9DeBGE8oGdk
         YSPB9gbq1EFjhLUq3NwhglXTeQrjmesmzUjaoyn8z7g8OWevrGDPIoYaSI0hfNVcApqn
         f/IcHLE79knfPf+eAwy34gRG4h6UE0es6SyUKnB3GhSWiygyolw5gXi/AHudiv++DEbY
         ari3VFQqJdglD7Hw+uKvFEyW+VbVCwuc5MxiKOtU7ggbmvv5IE0u251kXmQLTQS1BlyC
         mVcA7/AyI4XluNDrjNkFkn4GnMGNlFcd1CGVj8/2U7t6abGj17f+zIk2fxjia6oSjz50
         l/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q965G7dHtW4+bS94YxuVuI6y6VAD4TqrD/zOV7SuO/M=;
        b=RnROHB5ZevYcj9tNhOHZ09mfgvIRbNV7Zfe11x/pfRYWsHHRXmasvqjdFKeWl0Q63/
         0mhgonoNyUSfMtGeobO7SiX0BwzyRL0lacxVtdhV84jIOaKr+/rweKLR2ZjFfUK7/8+s
         WDsLdvrEdtvmXtd87HJluoryO72GhDCBGpjFWjkSY0MIY9TLEuSfYO5qoUqViNHKAnpT
         lr/0ABvdbOLyRK1Vg7zRQXwLiDOcjgxGRvRB9HuiaWexxLPx+h2xcCypmxNEUC73AWgO
         IPZxKf7KHSimv3n0M+sOkCoqff/Ag8C49baJ+yt1aiSYVj4wl3tj+VuxCj1ik5dl9F9H
         N8dQ==
X-Gm-Message-State: ACrzQf1jgLpLeHj2ppsBnvTcIfgBxL1mv8Pp43L4uy8swPdefGrlUNbr
        l+B7iIKzw1M4jJ7lmMekTh6ccPd19ButPQ==
X-Google-Smtp-Source: AMsMyM7UT+UTIkf+WAbFT7pelchhlEqAXW1Alu3AcuzAkQp8ld+v8jjX24paU+oKb5RXwq5ehsVWew==
X-Received: by 2002:a37:513:0:b0:6ee:8af5:58a with SMTP id 19-20020a370513000000b006ee8af5058amr8743096qkf.677.1666034973886;
        Mon, 17 Oct 2022 12:29:33 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b0035ba48c032asm423831qts.25.2022.10.17.12.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 12:29:33 -0700 (PDT)
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
Subject: [PATCH net-next 2/4] net: move add ct helper function to nf_conntrack_helper for ovs and tc
Date:   Mon, 17 Oct 2022 15:29:26 -0400
Message-Id: <5957a293eadac6403657d079ddc6e360cd3f0895.1666034595.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1666034595.git.lucien.xin@gmail.com>
References: <cover.1666034595.git.lucien.xin@gmail.com>
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
index 83615e479f87..ee22b8a059cd 100644
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
+	int err;
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
+		err = nf_nat_helper_try_module_get(name, family, proto);
+		if (err) {
+			nf_conntrack_helper_put(helper);
+			return err;
+		}
+	}
+#endif
+	rcu_assign_pointer(help->helper, helper);
+	*hp = helper;
+	return 0;
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

