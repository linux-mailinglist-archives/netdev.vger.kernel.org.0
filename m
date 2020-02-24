Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A9E169F57
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgBXHgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:10 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55625 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgBXHgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:08 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so7876742wmj.5
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4UvBqqQ/D2sNGYfPTpBOECLVkCu9+CqUOaFbVj/CESY=;
        b=cldGyIm0xiO9ZQ21ak2BGWkEUHu/PRRxzJ7JE/zrlMmbHowXmoA+Cgj9vDWZ0Tm0T6
         sSRwCxM2OBUYj05Vo5bw6A5679RcEHZMuLjRRPv5a2i5oanAzRPtSSzTENTw0YnD38j2
         N2X7VUDoZWJ7K3Tk2iHjuCkgAwvubj0YQRNXoimCt5L45CKTZGVobcmxtGX08Oo4GI1X
         Pi7JoE9Re+RdYtjJvzKpmysNCCsSValSW397Q5ULhOJJB26RxiPgrVtRqkh9Uwie6fqv
         VFTt9R4IeGOkTsEBLf0D4GmR7cYI8Kfy5/Yy2hZExWdZNtlfA9U+SMYcfoh0BtdOOWql
         FJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4UvBqqQ/D2sNGYfPTpBOECLVkCu9+CqUOaFbVj/CESY=;
        b=Oe9Yyi7r3MAh09jvLqVXAAlXsH6xvVMZVU+JXngdwglp4Bylw89mnPECplRiXwfmWH
         6/IwDxNQQFWyY2fHY4+ULqxLQjuw1JKHWBerLZQd2hb+POk651UG7MmfcHPuRPR1Vqrp
         b2ihsqtUJJ/QUmD1h4wQ7bMMFsOOYVTYrf0juSYmXsWCzjgoDfHor41AS85BWv8H0A04
         u1sGs0ji+cWHT2ngBWCSv/TeRPx/hQUdOX+nIRjACGV5YzHEbWCTmJLN+CrcioEv4BRq
         XIynvWOnDM9QgtLeVYkz1RvrHhax+l4uwIPSWUMjfjhMQRMz3a/OOA33FYruw8TY4Q0n
         62NA==
X-Gm-Message-State: APjAAAVTbdBiHCjukMn5Og9gKVp3wA0zZTRu1d/R4fHRb7UqAo5kMP7U
        BJeIocNA6YVzc7A/Mt3HE94wZ5wd7Z4=
X-Google-Smtp-Source: APXvYqy/6GnQ9bj5iprbxrOjLILu1chQt5VEM+p/lCnPKYIjqhLXIAntl/oByzAIJBH/iDkb/+wACA==
X-Received: by 2002:a7b:c389:: with SMTP id s9mr19661040wmj.7.1582529766740;
        Sun, 23 Feb 2020 23:36:06 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id j15sm17748035wrp.9.2020.02.23.23.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:06 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 06/16] mlxsw: spectrum_acl: Track ingress and egress block bindings
Date:   Mon, 24 Feb 2020 08:35:48 +0100
Message-Id: <20200224073558.26500-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Count the number of ingress and egress block bindings. Use the egress
counter in "is_egress_bound" helper. Add couple of helpers to check
ingress and mixed bound.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +++
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 25 ++++++++++++++-----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 9335f6a01b87..79dc7b5947c4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -665,6 +665,8 @@ struct mlxsw_sp_acl_block {
 	unsigned int rule_count;
 	unsigned int disable_count;
 	unsigned int egress_blocker_rule_count;
+	unsigned int ingress_binding_count;
+	unsigned int egress_binding_count;
 	struct net *net;
 };
 
@@ -688,6 +690,8 @@ int mlxsw_sp_acl_block_unbind(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_port *mlxsw_sp_port,
 			      bool ingress);
 bool mlxsw_sp_acl_block_is_egress_bound(const struct mlxsw_sp_acl_block *block);
+bool mlxsw_sp_acl_block_is_ingress_bound(const struct mlxsw_sp_acl_block *block);
+bool mlxsw_sp_acl_block_is_mixed_bound(const struct mlxsw_sp_acl_block *block);
 struct mlxsw_sp_acl_ruleset *
 mlxsw_sp_acl_ruleset_lookup(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_acl_block *block, u32 chain_index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 7b460c08f779..3b455c629f6d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -124,13 +124,17 @@ bool mlxsw_sp_acl_block_disabled(const struct mlxsw_sp_acl_block *block)
 
 bool mlxsw_sp_acl_block_is_egress_bound(const struct mlxsw_sp_acl_block *block)
 {
-	struct mlxsw_sp_acl_block_binding *binding;
+	return block->egress_binding_count;
+}
 
-	list_for_each_entry(binding, &block->binding_list, list) {
-		if (!binding->ingress)
-			return true;
-	}
-	return false;
+bool mlxsw_sp_acl_block_is_ingress_bound(const struct mlxsw_sp_acl_block *block)
+{
+	return block->ingress_binding_count;
+}
+
+bool mlxsw_sp_acl_block_is_mixed_bound(const struct mlxsw_sp_acl_block *block)
+{
+	return block->ingress_binding_count && block->egress_binding_count;
 }
 
 static bool
@@ -269,6 +273,10 @@ int mlxsw_sp_acl_block_bind(struct mlxsw_sp *mlxsw_sp,
 			goto err_ruleset_bind;
 	}
 
+	if (ingress)
+		block->ingress_binding_count++;
+	else
+		block->egress_binding_count++;
 	list_add(&binding->list, &block->binding_list);
 	return 0;
 
@@ -290,6 +298,11 @@ int mlxsw_sp_acl_block_unbind(struct mlxsw_sp *mlxsw_sp,
 
 	list_del(&binding->list);
 
+	if (ingress)
+		block->ingress_binding_count--;
+	else
+		block->egress_binding_count--;
+
 	if (mlxsw_sp_acl_ruleset_block_bound(block))
 		mlxsw_sp_acl_ruleset_unbind(mlxsw_sp, block, binding);
 
-- 
2.21.1

