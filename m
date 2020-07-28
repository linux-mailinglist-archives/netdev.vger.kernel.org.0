Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650802306C3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgG1Joz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:44:55 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:30084
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728461AbgG1Joy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:44:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZx4F0aRzGcBXUNp07dZslOdKWC1CPx/8YjF4JoN14qHkl3/BQRHpu95rBgnI5dZ70tcLApIyYCFc0Qz3HdtGEMuYZpFLJez+Mx/uqRzO7g2uyOD+4IuQavAgcLnV1c3Po7bQnkJjEXdTdd9DyS6SkCoFEVMcoDQWE8tI8JeadtFChLDvhPdIOQUfg7oOntDiza3aWBGv3Hcz9IZwEzwnVcJBV25nHJnjXwZ9sj2hbSnE+C/vudWtMULifm3X3am3M3Mv/UAfK1SypN+M8PfR+2Y9cxAu3uJ3wqZx2lImbIORnRvbbesL31zHbZC/xDtk/MUaVg7oVw+efI6RGuRKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jb0/IHpU/F28X8RQw11JfKMiCTLK03jWYMnmEcflMgw=;
 b=DQo2/uy88L5NzBg9XQIB3bJzk9QCe4PodD+aq8bgpivuusVAGKl+z02tludBP+zNykGYpmQ68iHtQsrFyNzEdnA7V/o6aLpBd3CT/vV1VmEvMBwhzEDDMzjheR3RZxafwV6OU66Z74zEfj/3QxCpxbvreQgxzdlt4DMw+JRzcAni7gT3sN2TwvTGjB/838153b+rxusrlYVWQfUZKMa7Hzwcce4tMACeKBFwgdqZc5OAmUWncDCchY9tHxn/PiMZB/EsX/gQ5U56o4kk+heXLey/EwwE+5sNwNbfKGOWqcvR1jMAY3GKYHUT4QcuboLzZXIipqFEe7FXR5Kr5lh8NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jb0/IHpU/F28X8RQw11JfKMiCTLK03jWYMnmEcflMgw=;
 b=OGCUv/7iTehis0ZBNXh+KHKNZZnztrRLcOnnrom5dsm0gPg78SRBStVV+4wyGOgsnmlauFs895RcKtJrHNhcZOvysrn33VBq/UYxy1Um+OtiP7IvASIwVv1X0S1XE01OzxvxwU0/lv+HSCrv8kz9tV7Ss1uvbchVPeD41yKtMPg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/13] net/mlx5e: Link non uplink representors to PCI device
Date:   Tue, 28 Jul 2020 02:44:04 -0700
Message-Id: <20200728094411.116386-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 728dcebd-0d3a-41e0-d5de-08d832dadcd4
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7117DB39AF91E348D3DEB332BE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eKt+fwTIjxhiMw6iA8/GlEheNGmVtsGLMRvSzNYHX/jAEXYpiVJLnLMyqW5T1Q/+GAZaFMPUEdc2GKt7Mn298Qresn0mDYWrdERqlrGUSj7asOvBhPAvaQsoot5KEOQ9x1wHJDLzz3WbE9ucPGcWCgzJrYJdKbjMwplwaFO2ZBz09h7/LgAK+omSFCXQahnUYAl0JaD/RXIhOxkC8gW5dEq/V0qdFLLdBh4iS88VWj1S6WFc4bL5oIBuvEKblJAyRjIpNf+xkjjbaBgwxDu1eugwJ/cKPu4pJM6komor9BfiKkr6NIuMSzOKmdMWzIEiXWNPFRjLXUpeY/ypaLhysY0pa5qvvJpvtsgseS73K9E01ZuakShGesraqUeMTGp4fsaa4S7x/A4Yk7mLOd1GX4TDOn16h30nhdSzcSD4yVZ1mStyM5RF0RWf5n9JuWirj1Lv9I/n7Deeuphu5jNVoXEcs9era49pFnigQuh+Vxg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(966005)(478600001)(316002)(1076003)(86362001)(54420400002)(6606295002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: a18sIUVyJ0A2IKte82c4NDkmfNB/UlYeApyIhfKXlArRGxY9CbrkXCl5nWFdAtVnquE72q5rg1XDhi5pgQ/udicIhM8+pq3LC00Vo1gtdRhYVsCATqLVxDXLrKhUNuLvAfnRhER3YYfEpH6BsEM9H7kStPBY4QKVK4juo6tM78DLnniIxw7Yx5jZWmjLFtQsfaYFm92AknYFsHStC9W2tN/mlqzc3Wa63fQz7rGN8MA3MGXNObNEOGEAMdNMT0TTo1wcC282TuAzIXwnDp/WtSmKiqDN7AMZypJ+hSVX4uE76lwpXp5Qun2G8WUIv/A9QWLSo7cdAbU6Ntv/0Rkij9XCsTwystgA5wT5dLkYA+Hd+LwonOyycw6Id5Q0dTj62uHidz9XOIlZojNAiJlJ0vcwDw55yVg44a4m1rgmBn35MLY5k7SJiWw9CyPB4DZkOmzGWgyz0Z1Dp7AK5mDF9qcYIvOwLDF8swK0qKPBCDM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 728dcebd-0d3a-41e0-d5de-08d832dadcd4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:47.2156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrb6w3H/++HPv+FmCIEjorNxa5QS9CyEScCizFuILVcc/bsWpHbErR4JrXw5AxSCyXK2zwv3qODn5wLqM6etJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Currently PF and VF representors are exposed as virtual device.
They are not linked to its parent PCI device like how uplink
representor is linked.
Due to this, PF and VF representors cannot benefit of the
systemd defined naming scheme. This requires special handling
by the users.

Hence, link the PF and VF representors to their parent PCI device
similar to existing uplink representor netdevice.

Example:
udevadm output before linking to PCI device:
$ udevadm test-builtin net_id  /sys/class/net/eth6
Load module index
Network interface NamePolicy= disabled on kernel command line, ignoring.
Parsed configuration file /usr/lib/systemd/network/99-default.link
Created link configuration context.
Using default interface naming scheme 'v243'.
ID_NET_NAMING_SCHEME=v243
Unload module index
Unloaded link configuration context.

udevadm output after linking to PCI device:
$ udevadm test-builtin net_id /sys/class/net/eth6
Load module index
Network interface NamePolicy= disabled on kernel command line, ignoring.
Parsed configuration file /usr/lib/systemd/network/99-default.link
Created link configuration context.
Using default interface naming scheme 'v243'.
ID_NET_NAMING_SCHEME=v243
ID_NET_NAME_PATH=enp0s8f0npf0vf0
Unload module index
Unloaded link configuration context.

In past there was little concern over seeing 10,000 lines output
showing up at thread [1] is not applicable as ndo ops for VF
handling is not exposed for all the 100 repesentors for mlx5 devices.

Additionally alternative device naming [2] to overcome shorter device
naming is also part of the latest systemd release v245.

[1] https://marc.info/?l=linux-netdev&m=152657949117904&w=2
[2] https://lwn.net/Articles/814068/

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c300729fb498e..a7a74748c9484 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -699,8 +699,8 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
+	SET_NETDEV_DEV(netdev, mdev->device);
 	if (rep->vport == MLX5_VPORT_UPLINK) {
-		SET_NETDEV_DEV(netdev, mdev->device);
 		netdev->netdev_ops = &mlx5e_netdev_ops_uplink_rep;
 		/* we want a persistent mac for the uplink rep */
 		mlx5_query_mac_address(mdev, netdev->dev_addr);
-- 
2.26.2

