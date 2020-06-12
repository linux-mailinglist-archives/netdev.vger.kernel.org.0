Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE9C1F7480
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 09:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgFLHRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 03:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgFLHRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 03:17:05 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02150C03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 00:17:04 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 23so3871658pfw.10
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 00:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w55rsvJaZ+hDzoGKRPuFNtqms7c1RTN3yNwMVXMrMaE=;
        b=Ng1FVAYiyUSRim/Hf89iBCjDQRYH3cJV3I/2OkSQ1ALUqQEeyNvYM0cS2e0JkSqVE2
         aoiM8B/asQ2gaM5ncOtAHVdkjDPfiZHEZe2seHCgDNrUfjEsvPCPOoPdHsx9n/cIp9Cx
         oQSSD77DbyRQ7jBUAYNW5m8wFiTKadMCN/nyi87bR/yYd1JG4QnXmDTcyd/+4nBtAXa6
         MP+WYhO4Dqymhe5bErYVUME5WyfKmoklYVRpPCmtDht4GYm6b2E7v/CNViyylz/xXTNs
         tgyt2zrM19YD7re239l55pv2jTaU3Xw10G8LdcaL9gB2AA8IoHfzQsTAq03TFUueGcl9
         gl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w55rsvJaZ+hDzoGKRPuFNtqms7c1RTN3yNwMVXMrMaE=;
        b=Xpc/TkwckvOxwCYi8sDILxg1c28plrDavlG4No+jGMKq8EzXCb6ZWDLDn9O3PuPRD+
         QmnizJfyC8di2j1P53B1dKTn/vuiKh+IT7Nwc7YiV/xWgyVzR3xloRmcLpCm0efqNakR
         GQ7owC/G0XlfZjXAZm4QwGivwLZlhVQfdNDCNRHt2haAqnijzUt/ruvS+i6TqBYXrgXh
         6r0RPUFGg3s6IebTvoiW/LPOQCNmtZDdlZ+jOpunJpnTCkt66W1POu2enQU5pXqJ4z7Y
         V+DkagwbqYICKsuFPYb7FadfRb/R0URPTqyoyYkv931vJxU5HXTILmu3DpVhW6k6Ndo1
         g4jg==
X-Gm-Message-State: AOAM530WnglEP6a+g6+bFZv3GAgG4VQSd2Wk+rZp/Gxv/R+RPLLvVqZ5
        Jq6gitR3FD6xZM4PDeJoR8x4wblv
X-Google-Smtp-Source: ABdhPJwa9vXv2waFkjjFojVRRxtuW1gvoD0QErXGfw1tSuLs6O4cAUBDr4eV3bqulFw/QITiGuslXQ==
X-Received: by 2002:aa7:8141:: with SMTP id d1mr11036350pfn.209.1591946224075;
        Fri, 12 Jun 2020 00:17:04 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id dw17sm4461325pjb.40.2020.06.12.00.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 00:17:03 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [Patch net] genetlink: clean up family attributes allocations
Date:   Fri, 12 Jun 2020 00:16:55 -0700
Message-Id: <20200612071655.8009-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

genl_family_rcv_msg_attrs_parse() and genl_family_rcv_msg_attrs_free()
take a boolean parameter to determine whether allocate/free the family
attrs. This is unnecessary as we can just check family->parallel_ops.
More importantly, callers would not need to worry about pairing these
parameters correctly after this patch.

And this fixes a memory leak, as after commit c36f05559104
("genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()")
we call genl_family_rcv_msg_attrs_parse() for both parallel and
non-parallel cases.

Fixes: c36f05559104 ("genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netlink/genetlink.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 6c19b91bbb86..55ee680e9db1 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -474,8 +474,7 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 				struct netlink_ext_ack *extack,
 				const struct genl_ops *ops,
 				int hdrlen,
-				enum genl_validate_flags no_strict_flag,
-				bool parallel)
+				enum genl_validate_flags no_strict_flag)
 {
 	enum netlink_validation validate = ops->validate & no_strict_flag ?
 					   NL_VALIDATE_LIBERAL :
@@ -486,7 +485,7 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 	if (!family->maxattr)
 		return NULL;
 
-	if (parallel) {
+	if (family->parallel_ops) {
 		attrbuf = kmalloc_array(family->maxattr + 1,
 					sizeof(struct nlattr *), GFP_KERNEL);
 		if (!attrbuf)
@@ -498,7 +497,7 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 	err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
 			    family->policy, validate, extack);
 	if (err) {
-		if (parallel)
+		if (family->parallel_ops)
 			kfree(attrbuf);
 		return ERR_PTR(err);
 	}
@@ -506,10 +505,9 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 }
 
 static void genl_family_rcv_msg_attrs_free(const struct genl_family *family,
-					   struct nlattr **attrbuf,
-					   bool parallel)
+					   struct nlattr **attrbuf)
 {
-	if (parallel)
+	if (family->parallel_ops)
 		kfree(attrbuf);
 }
 
@@ -537,15 +535,14 @@ static int genl_start(struct netlink_callback *cb)
 
 	attrs = genl_family_rcv_msg_attrs_parse(ctx->family, ctx->nlh, ctx->extack,
 						ops, ctx->hdrlen,
-						GENL_DONT_VALIDATE_DUMP_STRICT,
-						true);
+						GENL_DONT_VALIDATE_DUMP_STRICT);
 	if (IS_ERR(attrs))
 		return PTR_ERR(attrs);
 
 no_attrs:
 	info = genl_dumpit_info_alloc();
 	if (!info) {
-		kfree(attrs);
+		genl_family_rcv_msg_attrs_free(ctx->family, attrs);
 		return -ENOMEM;
 	}
 	info->family = ctx->family;
@@ -562,7 +559,7 @@ static int genl_start(struct netlink_callback *cb)
 	}
 
 	if (rc) {
-		kfree(attrs);
+		genl_family_rcv_msg_attrs_free(info->family, info->attrs);
 		genl_dumpit_info_free(info);
 		cb->data = NULL;
 	}
@@ -591,7 +588,7 @@ static int genl_lock_done(struct netlink_callback *cb)
 		rc = ops->done(cb);
 		genl_unlock();
 	}
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs, false);
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -604,7 +601,7 @@ static int genl_parallel_done(struct netlink_callback *cb)
 
 	if (ops->done)
 		rc = ops->done(cb);
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -671,8 +668,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 
 	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
 						  ops, hdrlen,
-						  GENL_DONT_VALIDATE_STRICT,
-						  family->parallel_ops);
+						  GENL_DONT_VALIDATE_STRICT);
 	if (IS_ERR(attrbuf))
 		return PTR_ERR(attrbuf);
 
@@ -698,7 +694,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 		family->post_doit(ops, skb, &info);
 
 out:
-	genl_family_rcv_msg_attrs_free(family, attrbuf, family->parallel_ops);
+	genl_family_rcv_msg_attrs_free(family, attrbuf);
 
 	return err;
 }
-- 
2.26.2

