Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3951AAF12
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 01:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389140AbfIEXXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 19:23:15 -0400
Received: from mail-eopbgr720117.outbound.protection.outlook.com ([40.107.72.117]:4016
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733128AbfIEXXO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 19:23:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkM6n/72SaPiRoOgbBkBjMD4wPnLagPHyMHGhocVZ+wsI3ejn1vxoRDfvUf3ouhLRHzAk9yIEgYPwLFzoeKNaENs3PzfT08pp9d2RLFSD+2G8yOdwzs642LPceFzz06RypXjM0Hg+uY7bz4oE8UcOf0IOvT3Ux9ijqNBRwkewzwHdIhqXFD9femiOZTzHdKGYaB/B6Mklmsd69hGhgBvtXDRDpxNTNgDGCtAfdkPCo6CRBm0WmSydj+LC9Fw1vs5+rXMytttp6ysLhZdXQBery7bhI51UHuCjuTY8DEA36h5D0e73tw6pLjacGyptWt02zY0yhVh8B7Sx21KpVfDyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLXZJoFvAsuji7Xt+B38YnSUmRLxb+E15GK8aClGxK8=;
 b=eTwoqo3Lm4LH73AZncWrpvEGwz6ja5eesS/dq50V1cquN7rdeXlqyJmBVe1As0JrUpMkFt8BBt6nzPcbD5F2VJUQGPYvj2I/EMymJPO2PnDJA1m9yB+pUcyxX3sSrivh9L4z6+0KTmx/CzLO+wrXgL8yPPtaysCIC8DYPIBspsgZ0Tx0lAEcb3MPRs3AdRkxkuEazmnxnxDVWJCR8RnrD39P6SadMNOLSO8xTOCGuggOyAGQRv3JHJtUEf3OeBI2KiUlkvOgaFQro6gJjOjXnpHiPi3MECKFyKXPbO809dgatg1I2RcwPi11ajkq5bQnK/Mf7XyzC+5aO/EEDDgO8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLXZJoFvAsuji7Xt+B38YnSUmRLxb+E15GK8aClGxK8=;
 b=mkQNv+DtzceOGY6kcZlZj8WI+9DXOk/bgHR/We8RY2kHcmbZTfXROh+Splr+mSDFTb4vZx8fMgUbvgeAeSNleVqIiFKk9xjS98C5Ty3f+1h+ug/ACffwshukVBDEVUGZe1/mb72A/SBAcRskT+rqjfKDDzaNYW52C51+38dGNO4=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1241.namprd21.prod.outlook.com (20.179.50.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.10; Thu, 5 Sep 2019 23:23:12 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a419:3eba:811b:847b]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a419:3eba:811b:847b%5]) with mapi id 15.20.2263.005; Thu, 5 Sep 2019
 23:23:12 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH net-next,v2, 2/2] hv_netvsc: Sync offloading features to VF
 NIC
Thread-Topic: [PATCH net-next,v2, 2/2] hv_netvsc: Sync offloading features to
 VF NIC
Thread-Index: AQHVZEDix2e9FNcwgkWwLrAPfhxrqQ==
Date:   Thu, 5 Sep 2019 23:23:12 +0000
Message-ID: <1567725722-33552-3-git-send-email-haiyangz@microsoft.com>
References: <1567725722-33552-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1567725722-33552-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0082.namprd17.prod.outlook.com
 (2603:10b6:300:c2::20) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a31fd0b-f2d3-4b5f-a67c-08d73258051d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1241;
x-ms-traffictypediagnostic: DM6PR21MB1241:|DM6PR21MB1241:|DM6PR21MB1241:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1241D31FBE24F233001A3D0AACBB0@DM6PR21MB1241.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(7846003)(6392003)(4720700003)(6436002)(14444005)(66066001)(10290500003)(305945005)(25786009)(6512007)(8676002)(256004)(36756003)(8936002)(81156014)(81166006)(5660300002)(52116002)(4326008)(53936002)(478600001)(99286004)(2201001)(7736002)(10090500001)(22452003)(3846002)(71200400001)(6116002)(316002)(71190400001)(66476007)(66556008)(64756008)(66946007)(66446008)(14454004)(2906002)(446003)(11346002)(2616005)(486006)(476003)(186003)(76176011)(26005)(6486002)(386003)(54906003)(110136005)(50226002)(2501003)(6506007)(102836004)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1241;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IrMDACHfHb0Uxq82stY+RI/h221EDPYCiLHblxysKpGR0Y27mOvpVOcCD/FlO1uoXBz2LdWxnSBy+2PwamQt61H+GYA0VTMpg5v9A0L9Y2gFBIdc4qCOEBZzl1sJmbtNzQWLeedHMxyH7Az5woYz0lL5k2Y5CNyKrPhsV7Y6SWqIAzgd3CyfXJbe1HpqZHQMunfSMe8UzjjfxgnoVukue58S9VgNah1GfL2PaSEOrWX2HnbJGHxO8MzcZRKxdGwFPxDcaXdKkgiaH/h95n6QesPLZciSi88gO+W0J1xVAbgrY219kI9j/vg0OOY/G4i2fatEnTc2ibBdYB7VN7IyMpNjf5mHb6Hn4m8VcvNdyI7p0lpQOPING8ALIzrngoXyRMpWJkoaRRB/0gSKpNuychtiPywFQvgdxMqBrJgjU/s=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a31fd0b-f2d3-4b5f-a67c-08d73258051d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 23:23:12.1314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: up45kQSHc/vhQblMGTVs+YHRomcsBUXd8fBSVJq5OI4795o2gJEzi8k6amgHJ9mTQgYOO6XyDfbz4b0KnPIdLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1241
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VF NIC may go down then come up during host servicing events. This
causes the VF NIC offloading feature settings to roll back to the
defaults. This patch can synchronize features from synthetic NIC to
the VF NIC during ndo_set_features (ethtool -K),
and netvsc_register_vf when VF comes back after host events.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Mark Bloch <markb@mellanox.com>
---
 drivers/net/hyperv/netvsc_drv.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 1f1192e..39dddcd 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1785,13 +1785,15 @@ static int netvsc_set_features(struct net_device *n=
dev,
 	netdev_features_t change =3D features ^ ndev->features;
 	struct net_device_context *ndevctx =3D netdev_priv(ndev);
 	struct netvsc_device *nvdev =3D rtnl_dereference(ndevctx->nvdev);
+	struct net_device *vf_netdev =3D rtnl_dereference(ndevctx->vf_netdev);
 	struct ndis_offload_params offloads;
+	int ret =3D 0;
=20
 	if (!nvdev || nvdev->destroy)
 		return -ENODEV;
=20
 	if (!(change & NETIF_F_LRO))
-		return 0;
+		goto syncvf;
=20
 	memset(&offloads, 0, sizeof(struct ndis_offload_params));
=20
@@ -1803,7 +1805,19 @@ static int netvsc_set_features(struct net_device *nd=
ev,
 		offloads.rsc_ip_v6 =3D NDIS_OFFLOAD_PARAMETERS_RSC_DISABLED;
 	}
=20
-	return rndis_filter_set_offload_params(ndev, nvdev, &offloads);
+	ret =3D rndis_filter_set_offload_params(ndev, nvdev, &offloads);
+
+	if (ret)
+		features ^=3D NETIF_F_LRO;
+
+syncvf:
+	if (!vf_netdev)
+		return ret;
+
+	vf_netdev->wanted_features =3D features;
+	netdev_update_features(vf_netdev);
+
+	return ret;
 }
=20
 static u32 netvsc_get_msglevel(struct net_device *ndev)
@@ -2181,6 +2195,10 @@ static int netvsc_register_vf(struct net_device *vf_=
netdev)
=20
 	dev_hold(vf_netdev);
 	rcu_assign_pointer(net_device_ctx->vf_netdev, vf_netdev);
+
+	vf_netdev->wanted_features =3D ndev->features;
+	netdev_update_features(vf_netdev);
+
 	return NOTIFY_OK;
 }
=20
--=20
1.8.3.1

