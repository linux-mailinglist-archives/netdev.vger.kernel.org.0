Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8234D3C2B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbiCIVjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiCIVjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4079A6D944
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEB7661B0D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAB5C340EC;
        Wed,  9 Mar 2022 21:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861885;
        bh=gvrovV5AbgeMbvQIuUpkTKfRH+1xowEtCWXuHmyRC50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNsh4Raze4AI933HJwHrhb99cH9NDzGSgEcKVFYjWOnIkrR1u9miwgXIwXX+9Oakx
         b4UZBnsEOK1OWNetbHbi9sYwWNzAAgsezNT+2bAvaJq6V0epqBgAevtnP/+XT6KJeP
         gIaZ+PacGyyL4ODQ/qBG4W5Baev6+/zzS24375Z5g3WAYsosuQYtPksgInlF7umSvc
         VXVmRdGV3zK9WkP//kfWy3jxmkhurbIUf9uwlFn1DVp21yCczyrbrH45R2VR3u0WBu
         4B2qX2Uera82ZEjp5ysbdzuPl+Z84xGEfQ88HsCvIVOCfzZoXlXPt6WEdPop1obag0
         YnoT7orzbs4JA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/16] net/mlx5e: TC, Fix use after free in mlx5e_clone_flow_attr_for_post_act()
Date:   Wed,  9 Mar 2022 13:37:40 -0800
Message-Id: <20220309213755.610202-2-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This returns freed memory leading to a use after free.  It's supposed to
return NULL.

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 40416e0a8bb1..e3fc15ae7bb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3410,7 +3410,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	if (!attr2 || !parse_attr) {
 		kvfree(parse_attr);
 		kfree(attr2);
-		return attr2;
+		return NULL;
 	}
 
 	memcpy(attr2, attr, attr_sz);
-- 
2.35.1

