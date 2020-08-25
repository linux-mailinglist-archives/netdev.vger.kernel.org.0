Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC56251A64
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 16:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgHYOBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 10:01:52 -0400
Received: from mail-db8eur05on2088.outbound.protection.outlook.com ([40.107.20.88]:29408
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726578AbgHYN77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 09:59:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFG696tWOnkVCaQgGQGJo/UdCHhT5W3P8gvCrqgh7dCCOtSXT6OKerStI29WrZGsNStOVux61BoNaBcATHPqn1kuevzZ5p2PqKaJJdoaH4Bwy1efcsXKWtOHni2hHPFMt+fiRpPOXaUSRmAwCMfDxZbCQSBMSktqzFjr4wj29izA97CM8aeBIdO7JbQCp8FVaGZrpwYK3MhyC0grwk2a57RnVwLeqa5WQI23McQHsUpkvd4KLzhcB4M7eySJaqy8XcClHo7LpHfAoW34r5m11JMbQhQFvyu+NnHBaRpS5Y9I4/HjfyBPyPpd+/gvAXUxk2+LM3t2UrFffiGgyGmJKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+wKe8tCDxP/yn/NxPVg+1s9/aG+ZBIVjbrZ/Qr7LnY=;
 b=OTeiTl1pJ3fbkuL11YIApQtDoP0cohF+wAZnzgr9M0Uwsi9awzF1d/cknnT7bp8gCqAFonejzLS/EsMDGlQ364HSXPqkx4Kc6KvZTOhdXxf3F5CSnZfSRN6szf3X1CURCCvY0goIQWA9oVxJXbtr7P7qZZIzt1IRYB7/eIRfGGIHoLI2g4Cm3jv/EMQVWhFB5o11qxYd7Qw9w8hNvNbbpd2ST2sHKQJLVMTfcWb1jUabVoXa4GDYdI0vZe40zOihYornV8sjCOyNyOUypDyCfZt7hmdSc7VeygC5jZr4r2TQT/zvzxrEppHD0a4GWBghjM5FLtmhr9dKT17bzQ75rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+wKe8tCDxP/yn/NxPVg+1s9/aG+ZBIVjbrZ/Qr7LnY=;
 b=MrnDsKfIz2gQ419xnNYaITqWm5XHmYr/YZDFlVFjmlKklvaW9lcY3UPVrh1ymB7GvezzKTSWE6KUpYj5RelnQk3np21fuJOZSCOKeWOcYMGkxLovH2775nn6XacvooN9Vlm/Itc1JLUcK9LCQw+5dN7eq31LcBzy4LdKNLVtlsM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR0502MB3649.eurprd05.prod.outlook.com (2603:10a6:208:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Tue, 25 Aug
 2020 13:59:00 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5038:5c70:6fef:90a6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5038:5c70:6fef:90a6%5]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 13:59:00 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     roid@mellanox.com, saeedm@mellanox.com,
        Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 3/3] net/mlx5: E-switch, Set controller attribute for PCI PF and VF ports
Date:   Tue, 25 Aug 2020 16:58:39 +0300
Message-Id: <20200825135839.106796-4-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825135839.106796-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0048.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::28) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c-235-9-1-005.mtl.labs.mlnx (94.188.199.18) by AM0PR10CA0048.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 13:58:59 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c3f361c3-f2ce-4c0e-9f67-08d848ff043e
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3649:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB364945A3FC7F32B776209535D1570@AM0PR0502MB3649.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:457;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQvbnw1yXQBzkoc18l+1SUavfijRugmnBJtpkoxw6W10vSy+hiH79EP67DBrkJpeoUAc6aRonqCWKv9UPLPeqOFQS3+Cs1TuNJQmjvUcie719l8u17XLoJwL8Sti1X9qHHIFXN+7mmeMknJ9slD8CjqYF6OlHA935VWggcMkvavmHKz1aK+mKtenh6++uWmEanN+ItZBu62IAO2rzTpFwGrMjXIad1n1ciHofjt0I3HoTEAj+a8k5ov3cj9NWPmtxNr7WBA/Z/f6I8Cuz2OCWB22/2AsrFsFxI40q1Fcu7HGV8MN2s7sFKvqLtiS3zAobX76DfXRhqFejzZnVH3OkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(6506007)(6666004)(956004)(86362001)(36756003)(8936002)(54906003)(83380400001)(5660300002)(316002)(8676002)(4326008)(52116002)(6486002)(6512007)(1076003)(478600001)(2906002)(2616005)(66946007)(26005)(186003)(66476007)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YMVhs0GQD57DgjrXr+5Ts5SyhgXu3lE1SI6svbYgd19vSDgYZg3B25S/3P6oqKE6NFtsETbz3wRYXWeC/gmzf1U3WVzuXbplIixLD75b9jy4NgHtTtVi+yqr7muNAZU0gUayG2T1AyMt4BOXW7sxmJ5aJPgo8rEsdfd+QIrumLDPe3rELjzFkLp05uPtnDbFAL+5xn6eGaafSKovsoq4OklcQzkexjJCr7yLOyyzqAWYPWBom2+Tut9nO1QDrU3MrVKGfrXheuJ0u5JiOm9WH5XXPoGs028e9RQcO1nOYLq+9lM30F9fu3O8CaK1Kms4XJaYp5XlSNek8n8R2f0HjxK6PeerRX9uTpKFMYy5uGNKpaB0hDoixjzVTAuXEuOCEU8PjU9Mth84Iw+u8BF/9gLpvk6avt4Xyv4qu0QWCf12EnppT2brQdPKYazsSxMeuN7Z1N+45d9I1HQZYKGPbvlPDg2Q41uFZHtW4C0AuegvlMXrhrb7Bvdelcmm1MvrANNQ7xDOHu1xbZ2oSome1dXrL5/876NpdbEnR62LZHw91qiVZ4oV+z+mdk9KYzUzt2VKeT2MyyjPRPJ12//twY528kaF3DbzibHIWu/8wgwFZmQgj2ACL3suas4JZv8+fXK60E3J98p+snoayfQBOg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f361c3-f2ce-4c0e-9f67-08d848ff043e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 13:58:59.9757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNLwWTomNzX586u9E+WAQBqY+kDG0meayT/s4V9sX/NiKjmXzUbJTbryMDoKD19vprViOmznLVHDLN5w30VyJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3649
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ECPF supports one external host controller. When a port belongs to an external
host controller, setup external controller port attribute.

An example of a VF port of a ECPF supporting for an external controller:

$ devlink port show pci/0000:00:08.0/2
pci/0000:00:08.0/2: type eth netdev eth7 controller 0 flavour pcivf pfnum 0 vfnum 1 splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port show -jp pci/0000:00:08.0/2 {
    "port": {
        "pci/0000:00:08.0/2": {
            "type": "eth",
            "netdev": "eth7",
            "controller": 0,
            "flavour": "pcivf",
            "pfnum": 0,
            "vfnum": 1,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00"
            }
        }
    }
}

An example representor netdev udev name consist of controller
annotation for external controller with controller number = 0,
for PF 0 and VF 1:

$ udevadm test-builtin net_id /sys/class/net/eth7
Using default interface naming scheme 'v245'.
ID_NET_NAMING_SCHEME=v245
ID_NET_NAME_PATH=enp0s8f0nc0pf0vf1
Unload module index
Unloaded link configuration context.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  5 +++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 21 +++++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index e13e5d1b3eae..9c79d9b84ebd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1210,6 +1210,7 @@ is_devlink_port_supported(const struct mlx5_core_dev *dev,
 static int register_devlink_port(struct mlx5_core_dev *dev,
 				 struct mlx5e_rep_priv *rpriv)
 {
+	struct mlx5_esw_offload *offloads = &dev->priv.eswitch->offloads;
 	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct devlink_port_attrs attrs = {};
@@ -1232,10 +1233,14 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 	} else if (rep->vport == MLX5_VPORT_PF) {
 		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
 		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
+		if (mlx5_core_is_ecpf_esw_manager(dev))
+			devlink_port_attrs_controller_set(&rpriv->dl_port, offloads->host_number);
 		devlink_port_attrs_pci_pf_set(&rpriv->dl_port, pfnum);
 	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport)) {
 		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
 		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
+		if (mlx5_core_is_ecpf_esw_manager(dev))
+			devlink_port_attrs_controller_set(&rpriv->dl_port, offloads->host_number);
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
 					      pfnum, rep->vport - 1);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 867d8120b8a5..7455fbd21a0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -217,6 +217,7 @@ struct mlx5_esw_offload {
 	atomic64_t num_flows;
 	enum devlink_eswitch_encap_mode encap;
 	struct ida vport_metadata_ida;
+	unsigned int host_number; /* ECPF supports one external host */
 };
 
 /* E-Switch MC FDB table hash node */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d2516922d867..56b42ab66f3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2110,6 +2110,23 @@ int mlx5_esw_funcs_changed_handler(struct notifier_block *nb, unsigned long type
 	return NOTIFY_OK;
 }
 
+static int mlx5_esw_host_number_init(struct mlx5_eswitch *esw)
+{
+	const u32 *query_host_out;
+
+	if (!mlx5_core_is_ecpf_esw_manager(esw->dev))
+		return 0;
+
+	query_host_out = mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(query_host_out))
+		return PTR_ERR(query_host_out);
+
+	esw->offloads.host_number = MLX5_GET(query_esw_functions_out, query_host_out,
+					     host_params_context.host_number);
+	kvfree(query_host_out);
+	return 0;
+}
+
 int esw_offloads_enable(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
@@ -2124,6 +2141,10 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	mutex_init(&esw->offloads.termtbl_mutex);
 	mlx5_rdma_enable_roce(esw->dev);
 
+	err = mlx5_esw_host_number_init(esw);
+	if (err)
+		goto err_vport_metadata;
+
 	err = esw_set_passing_vport_metadata(esw, true);
 	if (err)
 		goto err_vport_metadata;
-- 
2.26.2

