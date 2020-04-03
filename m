Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7385219CDBD
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 02:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390317AbgDCAMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 20:12:40 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:47015 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390235AbgDCAMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 20:12:40 -0400
Received: by mail-qk1-f193.google.com with SMTP id u4so6218534qkj.13;
        Thu, 02 Apr 2020 17:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aWmkjsHgC2Mb/1FGC/6TX9gaFt65nfjoT/5opdlfIXI=;
        b=cA95/rqNKt4GJ8TqL9VvKamVwGntNFDkakTaFHbn+ZscON5wgxCacDzuKVup+ik6To
         a3ReYx3HVggglTWzA2pYjhQVb3ZGFHsnLUusDge30JXUUF9tmGe8H91OXDF5HtvfFmxB
         cjAITp1Tn9iOrBTNSVlm8Ae0UazaIIhH9Wie1Ir9K+f2r5Jl7x6gqWO1RqUIYXDRCQtO
         i03UaL0C7+XOAaE/ASe6J7hIFfIaf2JgTp626UWJGjA5m9YOaZ0cWaOeSKluL4eyf57r
         I37XKhi/X44sq2u3RcP7ppmUxgdaKFKdUWpyo1ymFXRhdxUD67TIEDFyIuoYt7hcMgnd
         zGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aWmkjsHgC2Mb/1FGC/6TX9gaFt65nfjoT/5opdlfIXI=;
        b=D+w/I0fYSFvz289xjbFHX6m1Slz7MdP1ByuR0BTQMK1+5JGhZOgpGdg6koiubegInK
         TcJ32OOTOG6bcaurS/UyRg4Q3ug7/8uNFVOMhAhOoqvm9xuteom5osTrvyJ97GqxTZep
         dq39kXDKXsANywg1XnAIvq73V5XukbcaCwvcwiCbhSvE1kyQWBBpZFbbpHMNU0gSF+7K
         lrls2Pmfa3vboA9BHOgz1rlzNDojYY2H232nRvGPHbPv4tytpr6Ra9dLRvkH1cqrby2e
         3AVgCEGFYtGujTMQoy/fFf75HirUa6MYqoJz6w1gDOmyWJMuluStODJ2k6ZCqD+IA+i7
         mhlA==
X-Gm-Message-State: AGi0Pua6aZua3hYY/je+oIeADvXt/iJs+Ojm5vEe/OdsCOZd04L+9tUj
        /5MGRrA1JNGysCsAO5nnePY=
X-Google-Smtp-Source: APiQypIlDxIGCC/U+zxp4VQPLayYZgf9BhozwSlBtIIe8yyKbpL95gt7C+q0TTOdfeabAeG5+IYOCQ==
X-Received: by 2002:a37:a0d6:: with SMTP id j205mr2243608qke.455.1585872758562;
        Thu, 02 Apr 2020 17:12:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:e706:e019:95fc:6441:c82])
        by smtp.gmail.com with ESMTPSA id n190sm4668547qkb.93.2020.04.02.17.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 17:12:37 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 8D495C0EBA; Thu,  2 Apr 2020 21:12:35 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        marcelo.leitner@gmail.com
Subject: [PATCH net] net/mlx5e: limit log messages due to (ovs) probing to _once
Date:   Thu,  2 Apr 2020 21:11:54 -0300
Message-Id: <d57b95462cccf0f67089c91d3dfd3d1f4c46e9bf.1585872570.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OVS will keep adding such flows, no matter what. They will usually be
handled by tc software (or ovs datapath, if skip_sw is used). But the
driver is logging these messages for each and every attempt, despite the
extack. Note that they weren't rate limited, and a broadcast storm could
trigger system console flooding.

Switch these to be _once. It's enough to tell the sysadmin what is
happenning, and if anything, the OVS log will have all the errors.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 61 ++++++++++---------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 438128dde187d7ec58892c2879c6037f807f576f..1182fba3edbb8cf7bd59557b7ece18765c704186 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1828,8 +1828,8 @@ enc_opts_is_dont_care_or_full_match(struct mlx5e_priv *priv,
 				       opt->length * 4)) {
 				NL_SET_ERR_MSG(extack,
 					       "Partial match of tunnel options in chain > 0 isn't supported");
-				netdev_warn(priv->netdev,
-					    "Partial match of tunnel options in chain > 0 isn't supported");
+				netdev_warn_once(priv->netdev,
+						 "Partial match of tunnel options in chain > 0 isn't supported");
 				return -EOPNOTSUPP;
 			}
 		}
@@ -1988,8 +1988,8 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 	    !mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
 		NL_SET_ERR_MSG(extack,
 			       "Chains on tunnel devices isn't supported without register loopback support");
-		netdev_warn(priv->netdev,
-			    "Chains on tunnel devices isn't supported without register loopback support");
+		netdev_warn_once(priv->netdev,
+				 "Chains on tunnel devices isn't supported without register loopback support");
 		return -EOPNOTSUPP;
 	}
 
@@ -2133,8 +2133,8 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS))) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported key");
-		netdev_warn(priv->netdev, "Unsupported key used: 0x%x\n",
-			    dissector->used_keys);
+		netdev_warn_once(priv->netdev, "Unsupported key used: 0x%x\n",
+				 dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
@@ -2484,8 +2484,8 @@ static int parse_cls_flower(struct mlx5e_priv *priv,
 		    esw->offloads.inline_mode < non_tunnel_match_level)) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Flow is not offloaded due to min inline setting");
-			netdev_warn(priv->netdev,
-				    "Flow is not offloaded due to min inline setting, required %d actual %d\n",
+			netdev_warn_once(priv->netdev,
+					 "Flow is not offloaded due to min inline setting, required %d actual %d\n",
 				    non_tunnel_match_level, esw->offloads.inline_mode);
 			return -EOPNOTSUPP;
 		}
@@ -2885,7 +2885,9 @@ static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
 		if (memcmp(cmd_masks, &zero_masks, sizeof(zero_masks))) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "attempt to offload an unsupported field");
-			netdev_warn(priv->netdev, "attempt to offload an unsupported field (cmd %d)\n", cmd);
+			netdev_warn_once(priv->netdev,
+					 "attempt to offload an unsupported field (cmd %d)\n",
+					 cmd);
 			print_hex_dump(KERN_WARNING, "mask: ", DUMP_PREFIX_ADDRESS,
 				       16, 1, cmd_masks, sizeof(zero_masks), true);
 			err = -EOPNOTSUPP;
@@ -2912,17 +2914,17 @@ static bool csum_offload_supported(struct mlx5e_priv *priv,
 	if (!(action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "TC csum action is only offloaded with pedit");
-		netdev_warn(priv->netdev,
-			    "TC csum action is only offloaded with pedit\n");
+		netdev_warn_once(priv->netdev,
+				 "TC csum action is only offloaded with pedit\n");
 		return false;
 	}
 
 	if (update_flags & ~prot_flags) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "can't offload TC csum action for some header/s");
-		netdev_warn(priv->netdev,
-			    "can't offload TC csum action for some header/s - flags %#x\n",
-			    update_flags);
+		netdev_warn_once(priv->netdev,
+				 "can't offload TC csum action for some header/s - flags %#x\n",
+				 update_flags);
 		return false;
 	}
 
@@ -3224,8 +3226,9 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 			} else {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "device is not on same HW, can't offload");
-				netdev_warn(priv->netdev, "device %s not on same HW, can't offload\n",
-					    peer_dev->name);
+				netdev_warn_once(priv->netdev,
+						 "device %s not on same HW, can't offload\n",
+						 peer_dev->name);
 				return -EINVAL;
 			}
 			}
@@ -3754,9 +3757,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			if (attr->out_count >= MLX5_MAX_FLOW_FWD_VPORTS) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "can't support more output ports, can't offload forwarding");
-				netdev_warn(priv->netdev,
-					    "can't support more than %d output ports, can't offload forwarding\n",
-					    attr->out_count);
+				netdev_warn_once(priv->netdev,
+						 "can't support more than %d output ports, can't offload forwarding\n",
+						 attr->out_count);
 				return -EOPNOTSUPP;
 			}
 
@@ -3821,10 +3824,10 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
 					NL_SET_ERR_MSG_MOD(extack,
 							   "devices are not on same switch HW, can't offload forwarding");
-					netdev_warn(priv->netdev,
-						    "devices %s %s not on same switch HW, can't offload forwarding\n",
-						    priv->netdev->name,
-						    out_dev->name);
+					netdev_warn_once(priv->netdev,
+							 "devices %s %s not on same switch HW, can't offload forwarding\n",
+							 priv->netdev->name,
+							 out_dev->name);
 					return -EOPNOTSUPP;
 				}
 
@@ -3843,10 +3846,10 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			} else {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "devices are not on same switch HW, can't offload forwarding");
-				netdev_warn(priv->netdev,
-					    "devices %s %s not on same switch HW, can't offload forwarding\n",
-					    priv->netdev->name,
-					    out_dev->name);
+				netdev_warn_once(priv->netdev,
+						 "devices %s %s not on same switch HW, can't offload forwarding\n",
+						 priv->netdev->name,
+						 out_dev->name);
 				return -EINVAL;
 			}
 			}
@@ -3959,8 +3962,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 			NL_SET_ERR_MSG(extack,
 				       "Decap with goto isn't supported");
-			netdev_warn(priv->netdev,
-				    "Decap with goto isn't supported");
+			netdev_warn_once(priv->netdev,
+					 "Decap with goto isn't supported");
 			return -EOPNOTSUPP;
 		}
 
-- 
2.25.1

