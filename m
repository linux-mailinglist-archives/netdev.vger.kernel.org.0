Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9142000D6
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbgFSDdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:33:55 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:57212
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729570AbgFSDdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 23:33:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dg6zfRMBXsLwE7UmR4675cUIX2J9nyjhAo+2iZQBytKIbwVAz6BH3rkeatP6RokXyo7gD91+XefCx/7SRrCeqSWfGPNSVlyF5DJiWhRBPFpFJciCxsw5QcWf0e/H5KbuJyZGNHS2Vt4VFJ24RP8a6TyqytTfJOGk8A1lxn9IWMjayabE3KUcDjaDxMMuc2cTwXFywB4MDr1KQhCULnOecYMh0fP2GTumK2VW+cCpA60DU6FsSudM06Uxz9UpKa7TJ2iE8543DBXj3FxhP5yf4rEl9JwxX2U9ElqCAqZe5hh+gHJ6JrppcY5pV9qhnuCoRdtG7zEOukC8lCzhh/Shrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEYRV2HQdbkIMUscgJ3Hot+jiakxgF+1mF5OSTtx1zk=;
 b=WX0G4yuFuJIYoeHKW7368cLmMmEAEPU9RfyQn4AJzu5NsFoZWTQprD/b00UJ2suKMqpVkG5XR3RJXbj3ZBKyHkbTnAK5Rk0jwSFBbPx/kyQvr3KhFPJpQuHISkOyA43StJ2jxUDQ3niWBMlO/QyLMisi+u/hNPz4c0VtqloLcKlG5NZZNRobOTpl93uRfiQlze+klongq1N2dVdGNKe4tq4YCtqRVs+kpPbKjeVh1XDjc9xQNp0CeOfdA+sz/nY9q02eEr1uc4ePqDnPssd0lul9BADurFrSGh8PwK2yvgeQ0TK7npPHP/tjXu+z9qcgyxMUeKEsLpy5eig04Ose/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEYRV2HQdbkIMUscgJ3Hot+jiakxgF+1mF5OSTtx1zk=;
 b=UINHxrCcOh8B73N3Ws/VacHJPBEUoQc03TuQ/k2xeaXFffUkk2Chtipd03FkwNRUjlEpld7wme47frg1YigFrSdwpySRx3bl4Wpvwc3CXTyih8pePtqiTJ40wrgVoek3DH6xoZ4xDBoyhOz1DllkbSL/2Kfq+zFTs/g0WUk8QlI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6804.eurprd05.prod.outlook.com (2603:10a6:20b:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 03:33:35 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 03:33:35 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 9/9] net/mlx5: E-switch, Supporting setting devlink port function mac address
Date:   Fri, 19 Jun 2020 03:32:55 +0000
Message-Id: <20200619033255.163-10-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200619033255.163-1-parav@mellanox.com>
References: <20200619033255.163-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0019.namprd04.prod.outlook.com
 (2603:10b6:803:21::29) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 03:33:33 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1d19a17-6a67-4ffb-9d88-08d814018bfe
X-MS-TrafficTypeDiagnostic: AM0PR05MB6804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB680406811E71B4FF5B5C73DAD1980@AM0PR05MB6804.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9eDHot7zBQmfBv959/+9fwxdAZYuxLTSBEZC4bi6iJ+zaUyYmO4bp8JocYeRlaqWaPjHK8UE5PIvZUq3JNuZIrAaj99KpwuyW5e82nDclRDtF24wtxgr3oXPuH5PrAQAFO2NO7LGmKYlgysu/m6Ngqg7CdXvmxMFnasrWWV1vIca82nW0CHUHNJfr4njCrJPx4Te0FIoArJ5UlNNaFGMthC02xiYEenujueqQ6q8FVv3X+fCgpjzCM0hdTZnSTuD5NOc0+4ge/ibydwxyXuIW8mSIvkgdLbyuT7+S/YYLks4t5wPY226NecxRtmhltTJ4t3dLUcWv5kLvxuo6yrvWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(2616005)(2906002)(4326008)(107886003)(6486002)(478600001)(8936002)(6512007)(5660300002)(6916009)(956004)(6666004)(26005)(66476007)(16526019)(186003)(66556008)(66946007)(83380400001)(316002)(6506007)(54906003)(86362001)(52116002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: phAN6Q6TP2vRfgrJq0DMguu8+3OjV5rsp+XxVdqbcZbaDrD0jJPmL/iy4FdyUyWlmLpkXhyx+8B5pfNhvWqEoRcWhCuZrojm//SaRTA9xJvn2A+QXRHZ09MAGeZqDQyRfXY1+/FdlL6Ct0NnJtlss5S+s6OGmv/E0/+QKTH6wOAHi6LpK3EYcrIdNAxRguWFwy8ISejjrkGn4W85oMVINRne65QfsrZapgcSpivACtxJTbcso04Gq+NEGm2/QHpNgjCrX4myn8vA0E3bWYWzSIZEvq0pcsdMyi9jy+A/QJPeLQc0decjRdIu3QUrsp5TL1P+RFsq2VgdkA6i+DaFI+QqNblCn2x57Tdh2JWkwA/Ic+17t37kodazSpZc6FQAQDXJ7PQCTVaMZZYUVKdpzbDyDVZ5MqeOj2BABg4XfUkKbjwWz3Zg8U/yiGh1ZYLWSq4fpDr0UdyE+eI7OEEw/Mo7beHVXpXNUMTFHKsBtgKCRwWtKM24CMF/sXDu0AUD
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d19a17-6a67-4ffb-9d88-08d814018bfe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 03:33:35.1166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u/IYJh313M6wZuvawvuDsTBTUd4a32/mgHEG9I6887hrPfieli+BYFB0XKcs2rq6+blPqSxClBOzFdMhn79gAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable user to set mac address of the PCI PF and VF port function.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 36 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  4 +++
 3 files changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 3177d2458fa5..c709e9a385f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -114,6 +114,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.eswitch_encap_mode_set = mlx5_devlink_eswitch_encap_mode_set,
 	.eswitch_encap_mode_get = mlx5_devlink_eswitch_encap_mode_get,
 	.port_function_hw_addr_get = mlx5_devlink_port_function_hw_addr_get,
+	.port_function_hw_addr_set = mlx5_devlink_port_function_hw_addr_set,
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 2c08411e34ee..c656c9f081c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1898,6 +1898,42 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
 	return err;
 }
 
+int mlx5_devlink_port_function_hw_addr_set(struct devlink *devlink,
+					   struct devlink_port *port,
+					   const u8 *hw_addr, int hw_addr_len,
+					   struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+	u16 vport_num;
+
+	esw = mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw)) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch doesn't support set hw_addr");
+		return PTR_ERR(esw);
+	}
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num)) {
+		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support set hw_addr");
+		return -EINVAL;
+	}
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	mutex_lock(&esw->state_lock);
+	if (vport->enabled)
+		err = mlx5_esw_set_vport_mac_locked(esw, vport, hw_addr);
+	else
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch vport is disabled");
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 				 u16 vport, int link_state)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 19cd0af7afda..67e09902bd88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -454,6 +454,10 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
 					   struct devlink_port *port,
 					   u8 *hw_addr, int *hw_addr_len,
 					   struct netlink_ext_ack *extack);
+int mlx5_devlink_port_function_hw_addr_set(struct devlink *devlink,
+					   struct devlink_port *port,
+					   const u8 *hw_addr, int hw_addr_len,
+					   struct netlink_ext_ack *extack);
 
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
-- 
2.19.2

