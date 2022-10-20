Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6257F6059BC
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 10:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJTI3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 04:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiJTI3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 04:29:07 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::71f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F1218B765
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 01:29:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4gyEBz6BVZg1aP+7hNEd5bB73dtr7AyMA8ug1HMIdWGmc1tIxoUlzpD3Dqyk9Z+zaUDjfGHNrvtu92W0LcC9SsjWgDRJ8ara9osOJdQI/4D+5k1aa8KGOsALFOWZpXOR6I+9XFS4onfOHFsuz0HLGWUv1GTHC5+v4TC5isVfOBGBaAmEfu3cCLC1G8zUEVu/kRlf/qra0Ul3ksBs7IxDs2fT8hQBRJQSCLQihfYXZMVrgzRlB5rr6Ag9GSKc8oF/U3OXjY8/Zz6GcUuGIcIEC2RTdwKjuCJpD4lbhRuYADSMqKrs35CigAhwJkjdCbJIIwevHrif1LMybS27c0FyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ah+uiF3aWWo1pHSSJbbPbReY4/qFnVezkEAH0Mx1GSI=;
 b=aO/LCYRT8Huts4idqxL/UTkl44Mvhl5dYL52/y+d+/kmaPpfzYxsnZKYOk+pxXXlYPc1oupwpdNNnZyiUSXdtWK2J4hIR3S3OyXf7YjhN/Y5nzfGxsljM8qJAgwako3v9nghalyCW/7Z6X9gPIhKtKbrkuEzWnW193DGD16KLZ6rUmdwQ7ArQ+1Kc8ycwbH5E0fmnKcaLpcdk3YuQwMoLSIkmXCWhqQ9kB2RXqi5cDsqJUNWGiQFfZ+IhthBzNfdpdkmdLqi0zb9TlZ53UUg+dANDfkyPksghkf6Nufsp/jVVmbskd/P2NPjEF1IV1gbcSMoXz193FxvFRBrhQbutQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah+uiF3aWWo1pHSSJbbPbReY4/qFnVezkEAH0Mx1GSI=;
 b=ilKfSLf0QAMuzxu3w68ie1xkSXpOb1qs6mHKrFQtFJn90DoHMcrjWX/UgO/lwrdktI8NHO/HK6TACaLTFHLblNIHwLGwz+XEBvTPwpj/EuUc2Qbe+sZx+ouhzKpPjfwvmIyrFI6kCgEYvgYaaSG97u0pw1wh6EN0zSTsIshE8oU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4712.namprd13.prod.outlook.com (2603:10b6:408:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.20; Thu, 20 Oct
 2022 08:28:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161%6]) with mapi id 15.20.5746.016; Thu, 20 Oct 2022
 08:28:57 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yanguo Li <yanguo.li@corigine.com>
Subject: [PATCH net-next] nfp: flower: tunnel neigh support bond offload
Date:   Thu, 20 Oct 2022 09:28:34 +0100
Message-Id: <20221020082834.81724-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0017.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4712:EE_
X-MS-Office365-Filtering-Correlation-Id: 11ef94ed-dabd-4ad6-d386-08dab27521df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJ3BYVB+L+HUejryGWKrkbSNmBK09OrCHD5b9C27bSUZN9YbvivFvXd3z/UCzNZ04RTOVkuvNWdpUe6671n8Ixd7tB7oL7UMy7g7qNLTXLIEPmSsT1OxJLqqPSW0ffJXIn7VKLtJAgSr0Pjpogi1J97llP0YrVcvMJ/66Uoe6iEiqaXnlWCUsGtPTdUrbQxIg44m8YCnVMLyuGf5Bp5+ncMU9msooE3CgLYxUSxpXI+Mc/3I2cG8oLWLSOQ7MaTcjXKjYzxC3kmTF4+zoABpWJXD91lQqcKlUJJum5MBHLPknLrdloP5Th5vkimCxW2WTPmNKIdC3m1ggVMomGu0Ej7qdSap1ApZIWlHdSx1NABgrggZSKXxHwjwkX/A8MZc5lo+pZS6700EP1vkGavGEYXvlk1duQD40xKwlPxAojBvxeRFtqdHAXWc6bEe/vdoXzPxVMtd14DVR/afWApQEMM3SnchYy0kL7BBsxfKvDXAhN1IvuJjl0EDej5Lfu1m4giRrbK2YPP3L3gsImxWSZzHSC+5392DQuOf9z94KXukR902vV1VZwrue7G+M3jufGjF3Fm0np9hbkeI04G+Kn7ELzKALSCnxFQWjBg4mXreR+/MgMnUKanulrO3tpoiJqY3qoKMSoPsRW3jNAOugkdCyyiQ9bfsJ730KmENa2kZXkvhOzTgJ/qT6gWeULxesk+koYMgsF6HAZ62smni+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(366004)(39840400004)(396003)(451199015)(6512007)(478600001)(66556008)(1076003)(6506007)(30864003)(36756003)(8936002)(6666004)(8676002)(107886003)(4326008)(66946007)(66476007)(5660300002)(83380400001)(2906002)(52116002)(86362001)(38100700002)(44832011)(186003)(2616005)(6486002)(316002)(41300700001)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F+8k3l4p/c39IYlHMShJddlnJqnCF6rw7uPmpnxUoi2udRDJbBEqWd5pHdlz?=
 =?us-ascii?Q?iJcJH5cFD/a1L+8c/OiBY0O0kB//NkutGeewia3shVI+PycxUf1gSl+s6LNm?=
 =?us-ascii?Q?lt3bf9aAXDVxUn6m7J2emIjnUv5w8Tb1+kktNYIDLITH1+cpznZiBo2FNJxG?=
 =?us-ascii?Q?xIRo1m4WzcZlW9rLrpclyU+pxK0WZ7APSZsCFcuw79FPgT8v49gZA0u4my0Z?=
 =?us-ascii?Q?d2Ps4uS1KtYw+0tVgREHt8X1Fux/AiF0YXGch90oTDF06gW3YbAwVq47TQVq?=
 =?us-ascii?Q?aNbh2arxtbqSy+BRYHhv5JU56N0ridMI9Eny6W+C1TpYUfMjhOXMRHl0XmUf?=
 =?us-ascii?Q?fTTfOtJKPQjgv33s9++evOriEQ4Py4QOt3ikVagG4QVbFPR1n9OAxTQlBdL7?=
 =?us-ascii?Q?E6ObND7eMFsR2jrrsrzxQSJ5kcYhN3Vv/vqDPR7hbhj53VvoX6XWHsab6QoK?=
 =?us-ascii?Q?xr95N+zsu985EtoYzosAGegoTHxRK5psz+Dcr/O0ua6cmZ0Fe6Zfvr9T1Gts?=
 =?us-ascii?Q?gHbptT7nHn8wikVTzzffhIfj5ivt2hTjxIZ1KvMeCmFGqJeB3VWY7W+/xqO9?=
 =?us-ascii?Q?VBrU44fmFBx41Yogf5GW98QzaO15bRpDYsxCbKxyPpHGsP6sO0mcUDoIx4Wd?=
 =?us-ascii?Q?rD68MWLDl1KTXrSicx+il88qPfdFKqc97ztTBBNV5Zg9YSyuO4zlC+A9B5bW?=
 =?us-ascii?Q?+JZmYhecFvAciLn4NxNHoCnQoHz0OVsT/QcKdu1dpHA1d6y4wU204mkFzYYw?=
 =?us-ascii?Q?vkDPdH8bDVyxoXAfeGH+9n04J+wTsC1ka55DQBfgwwbg0hYPFz8D6UnCRUZr?=
 =?us-ascii?Q?uvd1oe2jxUaOXah6g3egcbrchjah5WeJU3X5qX1s708AI/NF+w2cX2YUr7W7?=
 =?us-ascii?Q?1zVRIUsyR10T0rsuO1zuSNL/+9RYlz9JN2Re7HK47u+p07GSmmrvVCK+nkjj?=
 =?us-ascii?Q?tGc6jNrRPfzGnePFiLLL09zCb9NO6jE3wacU0CdxpaGBqZqQMe+BRFEb+11e?=
 =?us-ascii?Q?bXsCR8+Et/Y5BnumEhwl7RdLTYhtN5C+uw8DN3I6H3CqDjYwMbmv3j/El8me?=
 =?us-ascii?Q?yKCsibuJ5up3Zhzk4WTSUdgIxUN2JJq1qxdtth7ikqoVSb61Hp00NjsOxKQ7?=
 =?us-ascii?Q?kM7WwENYVffC1nizUQnImUo7COyYSq/xrLaT9YreC3v9Isl0OPCMld1AZqFQ?=
 =?us-ascii?Q?yxVcWH7lAV8jLofEzZlFwyzUhz3M8XM9oVhfkwA4/BcypgkEoVf9vOUDn3D9?=
 =?us-ascii?Q?SJ7+rbw6fWI7nySshtbl+GRkR+G7823BbEH2WLrBrjrmNOb9fPMQ28CUfXeA?=
 =?us-ascii?Q?nttc0eMeK2qllxXQcKf1xgy0FExn7jHkqGpS5qudq/hF8jFQQ5O38dX34i07?=
 =?us-ascii?Q?CwzwW7lJw4WfL/t5RZ7dVkuTiqlH8JEd6BKGDAJ0eEnuNCDMf949UWX3wzud?=
 =?us-ascii?Q?Cx5JwseYXuM69RWEOvE1jSXeehhGTryfYbNp47GBPw8yRSanrkB3uh8TJLU+?=
 =?us-ascii?Q?XCpWwpW1eNRIac+pIxcH5FqC/RiT+LNYQPQ0tvhHr3kg0WBqAgUExK4ZCMV2?=
 =?us-ascii?Q?Puk651U0HhhQh6JRrKIqV40P1lC4wifz7FJ7c71iwg8qqK+PsY42c0i76pKn?=
 =?us-ascii?Q?Yw66ITuI59UmhciCMCucgq+z7gDp+5tSYhxtjK4SuxggkzNIxB7DcqnlKilW?=
 =?us-ascii?Q?PBlWOg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ef94ed-dabd-4ad6-d386-08dab27521df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 08:28:57.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JiAA0+sEHwR9ADY5k64ieA5gLOzsDXPSccVOvJRhpWDzVZ+s3Rjj20p0Mfv6ZUPVNGz6tTyb5pwAkwUiBPUvP4bNVdgD0qzZI8bY1obGKV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4712
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yanguo Li <yanguo.li@corigine.com>

Support hardware offload when tunnel neigh out port is bond.
These feature work with the nfp firmware. If the firmware
supports the NFP_FL_FEATS_TUNNEL_NEIGH_LAG feature, nfp driver
write the bond information to the firmware neighbor table or
do nothing for bond. when neighbor MAC changes, nfp driver
need to update the neighbor information too.

Signed-off-by: Yanguo Li <yanguo.li@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/lag_conf.c  | 52 ++++++++++++++----
 .../net/ethernet/netronome/nfp/flower/main.c  |  9 ++++
 .../net/ethernet/netronome/nfp/flower/main.h  | 21 +++++++-
 .../netronome/nfp/flower/tunnel_conf.c        | 53 +++++++++++++++----
 4 files changed, 114 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
index e92860e20a24..88d6d992e7d0 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
@@ -154,10 +154,11 @@ nfp_fl_lag_find_group_for_master_with_lag(struct nfp_fl_lag *lag,
 	return NULL;
 }
 
-int nfp_flower_lag_populate_pre_action(struct nfp_app *app,
-				       struct net_device *master,
-				       struct nfp_fl_pre_lag *pre_act,
-				       struct netlink_ext_ack *extack)
+static int nfp_fl_lag_get_group_info(struct nfp_app *app,
+				     struct net_device *netdev,
+				     __be16 *group_id,
+				     u8 *batch_ver,
+				     u8 *group_inst)
 {
 	struct nfp_flower_priv *priv = app->priv;
 	struct nfp_fl_lag_group *group = NULL;
@@ -165,23 +166,52 @@ int nfp_flower_lag_populate_pre_action(struct nfp_app *app,
 
 	mutex_lock(&priv->nfp_lag.lock);
 	group = nfp_fl_lag_find_group_for_master_with_lag(&priv->nfp_lag,
-							  master);
+							  netdev);
 	if (!group) {
 		mutex_unlock(&priv->nfp_lag.lock);
-		NL_SET_ERR_MSG_MOD(extack, "invalid entry: group does not exist for LAG action");
 		return -ENOENT;
 	}
 
-	pre_act->group_id = cpu_to_be16(group->group_id);
-	temp_vers = cpu_to_be32(priv->nfp_lag.batch_ver <<
-				NFP_FL_PRE_LAG_VER_OFF);
-	memcpy(pre_act->lag_version, &temp_vers, 3);
-	pre_act->instance = group->group_inst;
+	if (group_id)
+		*group_id = cpu_to_be16(group->group_id);
+
+	if (batch_ver) {
+		temp_vers = cpu_to_be32(priv->nfp_lag.batch_ver <<
+					NFP_FL_PRE_LAG_VER_OFF);
+		memcpy(batch_ver, &temp_vers, 3);
+	}
+
+	if (group_inst)
+		*group_inst = group->group_inst;
+
 	mutex_unlock(&priv->nfp_lag.lock);
 
 	return 0;
 }
 
+int nfp_flower_lag_populate_pre_action(struct nfp_app *app,
+				       struct net_device *master,
+				       struct nfp_fl_pre_lag *pre_act,
+				       struct netlink_ext_ack *extack)
+{
+	if (nfp_fl_lag_get_group_info(app, master, &pre_act->group_id,
+				      pre_act->lag_version,
+				      &pre_act->instance)) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid entry: group does not exist for LAG action");
+		return -ENOENT;
+	}
+
+	return 0;
+}
+
+void nfp_flower_lag_get_info_from_netdev(struct nfp_app *app,
+					 struct net_device *netdev,
+					 struct nfp_tun_neigh_lag *lag)
+{
+	nfp_fl_lag_get_group_info(app, netdev, NULL,
+				  lag->lag_version, &lag->lag_instance);
+}
+
 int nfp_flower_lag_get_output_id(struct nfp_app *app, struct net_device *master)
 {
 	struct nfp_flower_priv *priv = app->priv;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index 4d960a9641b3..83eaa5ae3cd4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -76,7 +76,9 @@ nfp_flower_get_internal_port_id(struct nfp_app *app, struct net_device *netdev)
 u32 nfp_flower_get_port_id_from_netdev(struct nfp_app *app,
 				       struct net_device *netdev)
 {
+	struct nfp_flower_priv *priv = app->priv;
 	int ext_port;
+	int gid;
 
 	if (nfp_netdev_is_nfp_repr(netdev)) {
 		return nfp_repr_get_port_id(netdev);
@@ -86,6 +88,13 @@ u32 nfp_flower_get_port_id_from_netdev(struct nfp_app *app,
 			return 0;
 
 		return nfp_flower_internal_port_get_port_id(ext_port);
+	} else if (netif_is_lag_master(netdev) &&
+		   priv->flower_ext_feats & NFP_FL_FEATS_TUNNEL_NEIGH_LAG) {
+		gid = nfp_flower_lag_get_output_id(app, netdev);
+		if (gid < 0)
+			return 0;
+
+		return (NFP_FL_LAG_OUT | gid);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index cb799d18682d..40372545148e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -52,6 +52,7 @@ struct nfp_app;
 #define NFP_FL_FEATS_QOS_PPS		BIT(9)
 #define NFP_FL_FEATS_QOS_METER		BIT(10)
 #define NFP_FL_FEATS_DECAP_V2		BIT(11)
+#define NFP_FL_FEATS_TUNNEL_NEIGH_LAG	BIT(12)
 #define NFP_FL_FEATS_HOST_ACK		BIT(31)
 
 #define NFP_FL_ENABLE_FLOW_MERGE	BIT(0)
@@ -69,7 +70,8 @@ struct nfp_app;
 	NFP_FL_FEATS_VLAN_QINQ | \
 	NFP_FL_FEATS_QOS_PPS | \
 	NFP_FL_FEATS_QOS_METER | \
-	NFP_FL_FEATS_DECAP_V2)
+	NFP_FL_FEATS_DECAP_V2 | \
+	NFP_FL_FEATS_TUNNEL_NEIGH_LAG)
 
 struct nfp_fl_mask_id {
 	struct circ_buf mask_id_free_list;
@@ -103,6 +105,16 @@ struct nfp_fl_tunnel_offloads {
 	struct notifier_block neigh_nb;
 };
 
+/**
+ * struct nfp_tun_neigh_lag - lag info
+ * @lag_version:	lag version
+ * @lag_instance:	lag instance
+ */
+struct nfp_tun_neigh_lag {
+	u8 lag_version[3];
+	u8 lag_instance;
+};
+
 /**
  * struct nfp_tun_neigh - basic neighbour data
  * @dst_addr:	Destination MAC address
@@ -133,12 +145,14 @@ struct nfp_tun_neigh_ext {
  * @src_ipv4:	Source IPv4 address
  * @common:	Neighbour/route common info
  * @ext:	Neighbour/route extended info
+ * @lag:	lag port info
  */
 struct nfp_tun_neigh_v4 {
 	__be32 dst_ipv4;
 	__be32 src_ipv4;
 	struct nfp_tun_neigh common;
 	struct nfp_tun_neigh_ext ext;
+	struct nfp_tun_neigh_lag lag;
 };
 
 /**
@@ -147,12 +161,14 @@ struct nfp_tun_neigh_v4 {
  * @src_ipv6:	Source IPv6 address
  * @common:	Neighbour/route common info
  * @ext:	Neighbour/route extended info
+ * @lag:	lag port info
  */
 struct nfp_tun_neigh_v6 {
 	struct in6_addr dst_ipv6;
 	struct in6_addr src_ipv6;
 	struct nfp_tun_neigh common;
 	struct nfp_tun_neigh_ext ext;
+	struct nfp_tun_neigh_lag lag;
 };
 
 /**
@@ -647,6 +663,9 @@ int nfp_flower_lag_populate_pre_action(struct nfp_app *app,
 				       struct netlink_ext_ack *extack);
 int nfp_flower_lag_get_output_id(struct nfp_app *app,
 				 struct net_device *master);
+void nfp_flower_lag_get_info_from_netdev(struct nfp_app *app,
+					 struct net_device *netdev,
+					 struct nfp_tun_neigh_lag *lag);
 void nfp_flower_qos_init(struct nfp_app *app);
 void nfp_flower_qos_cleanup(struct nfp_app *app);
 int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 52f67157bd0f..a8678d5612ee 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -290,6 +290,11 @@ nfp_flower_xmit_tun_conf(struct nfp_app *app, u8 mtype, u16 plen, void *pdata,
 	     mtype == NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6))
 		plen -= sizeof(struct nfp_tun_neigh_ext);
 
+	if (!(priv->flower_ext_feats & NFP_FL_FEATS_TUNNEL_NEIGH_LAG) &&
+	    (mtype == NFP_FLOWER_CMSG_TYPE_TUN_NEIGH ||
+	     mtype == NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6))
+		plen -= sizeof(struct nfp_tun_neigh_lag);
+
 	skb = nfp_flower_cmsg_alloc(app, plen, mtype, flag);
 	if (!skb)
 		return -ENOMEM;
@@ -468,6 +473,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 					  neigh_table_params);
 	if (!nn_entry && !neigh_invalid) {
 		struct nfp_tun_neigh_ext *ext;
+		struct nfp_tun_neigh_lag *lag;
 		struct nfp_tun_neigh *common;
 
 		nn_entry = kzalloc(sizeof(*nn_entry) + neigh_size,
@@ -488,6 +494,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 			payload->dst_ipv6 = flowi6->daddr;
 			common = &payload->common;
 			ext = &payload->ext;
+			lag = &payload->lag;
 			mtype = NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6;
 		} else {
 			struct flowi4 *flowi4 = (struct flowi4 *)flow;
@@ -498,6 +505,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 			payload->dst_ipv4 = flowi4->daddr;
 			common = &payload->common;
 			ext = &payload->ext;
+			lag = &payload->lag;
 			mtype = NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
 		}
 		ext->host_ctx = cpu_to_be32(U32_MAX);
@@ -505,6 +513,9 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 		ext->vlan_tci = cpu_to_be16(U16_MAX);
 		ether_addr_copy(common->src_addr, netdev->dev_addr);
 		neigh_ha_snapshot(common->dst_addr, neigh, netdev);
+
+		if ((port_id & NFP_FL_LAG_OUT) == NFP_FL_LAG_OUT)
+			nfp_flower_lag_get_info_from_netdev(app, netdev, lag);
 		common->port_id = cpu_to_be32(port_id);
 
 		if (rhashtable_insert_fast(&priv->neigh_table,
@@ -547,13 +558,38 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 		if (nn_entry->flow)
 			list_del(&nn_entry->list_head);
 		kfree(nn_entry);
-	} else if (nn_entry && !neigh_invalid && override) {
-		mtype = is_ipv6 ? NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6 :
-				NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
-		nfp_tun_link_predt_entries(app, nn_entry);
-		nfp_flower_xmit_tun_conf(app, mtype, neigh_size,
-					 nn_entry->payload,
-					 GFP_ATOMIC);
+	} else if (nn_entry && !neigh_invalid) {
+		struct nfp_tun_neigh *common;
+		u8 dst_addr[ETH_ALEN];
+		bool is_mac_change;
+
+		if (is_ipv6) {
+			struct nfp_tun_neigh_v6 *payload;
+
+			payload = (struct nfp_tun_neigh_v6 *)nn_entry->payload;
+			common = &payload->common;
+			mtype = NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6;
+		} else {
+			struct nfp_tun_neigh_v4 *payload;
+
+			payload = (struct nfp_tun_neigh_v4 *)nn_entry->payload;
+			common = &payload->common;
+			mtype = NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
+		}
+
+		ether_addr_copy(dst_addr, common->dst_addr);
+		neigh_ha_snapshot(common->dst_addr, neigh, netdev);
+		is_mac_change = !ether_addr_equal(dst_addr, common->dst_addr);
+		if (override || is_mac_change) {
+			if (is_mac_change && nn_entry->flow) {
+				list_del(&nn_entry->list_head);
+				nn_entry->flow = NULL;
+			}
+			nfp_tun_link_predt_entries(app, nn_entry);
+			nfp_flower_xmit_tun_conf(app, mtype, neigh_size,
+						 nn_entry->payload,
+						 GFP_ATOMIC);
+		}
 	}
 
 	spin_unlock_bh(&priv->predt_lock);
@@ -593,8 +629,7 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 	app_priv = container_of(nb, struct nfp_flower_priv, tun.neigh_nb);
 	app = app_priv->app;
 
-	if (!nfp_netdev_is_nfp_repr(n->dev) &&
-	    !nfp_flower_internal_port_can_offload(app, n->dev))
+	if (!nfp_flower_get_port_id_from_netdev(app, n->dev))
 		return NOTIFY_DONE;
 
 #if IS_ENABLED(CONFIG_INET)
-- 
2.30.2

