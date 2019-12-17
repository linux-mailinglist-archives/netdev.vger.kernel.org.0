Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E511221ED
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 03:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfLQCYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 21:24:18 -0500
Received: from mail-eopbgr30064.outbound.protection.outlook.com ([40.107.3.64]:29767
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbfLQCYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 21:24:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzvagCUqpMWm1GKggnhpNabSA9MlqKQiwKEXl5KVAI5SLo8tgM7gI+v5ZvKlKv1zrhMhHDlJCWxzmruydI+pE+6JgoGiZ8UXF7soD7kzx9ETU9Ny4+A9VM8aDUDdAoMyitHDdVbbrhHB4644e1vUhzhijX370qYWCnV6CveU6JA2Ma93x20lAmv6iXJHM8JvQOYiqMwtp92FOZ/3405vH7cJLuItmvGJYb7nWLxrIZKdZM8RKp1/ozag/WA5HOLQXTI254D9Ml2wkhMLHpg8YKSltAvrf71BRMJHYgF/nw3v+uNBhQDSrg4RTUYxbgWCNDjrExMOcuKQAQLc1kEjGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cA1PVCeNjy+Ss9R3tmZhAl84GRP7r01z4MT0ZXU1D0=;
 b=UTKIUrrpu6r79Swbd1qv9Pq4UEIv3VrrgNCVtpVh3LhKSrY06Ji4soByVnUwafNu+1PWnLPVFlQWvDnE0lwQEdpT9ZeEJKna78IOiVek1vtXL0/o0LmS4NXvMGBCfOIc2lEAFFp6kcSbclIKPaX84KV+MVAsMew0vi28eYkzU8am+wNNnyVdSHjC7QU0k0MOHH1lAFwJMP4hqXpbKrYn9x89hkmbWOlyhqdLN9rkMlX62pLiI+r8fSD5UxC2utvVHu7Ff9IxX2lelzlq3+g+kZUv5yLt62eWZhlJPcfRQ+gQysPMnC6/wAXDIGenXvpsMEEnClEdxu9ZGhGiaxPPKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cA1PVCeNjy+Ss9R3tmZhAl84GRP7r01z4MT0ZXU1D0=;
 b=pTdPEWCX1r+PN+nP4w2NSnDeMrGVV3qHJb0QJONlSOom6AwL2kcA1HbkFu3rztTj1a8s7gbURPJEsX/LZpHKVMQqUmvgq6V7r82i9p94LNkJjGf5jHDHDqetT1ChXVecNFWlUhkGx9FaiaGNbSNA9cw17X5yZK2RxCO0D1jwEC0=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2333.eurprd04.prod.outlook.com (10.169.133.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 02:24:14 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b9ca:8e9c:39e6:8d5f]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b9ca:8e9c:39e6:8d5f%7]) with mapi id 15.20.2559.012; Tue, 17 Dec 2019
 02:24:14 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Thread-Topic: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Thread-Index: AQHVtCYMQFVIeYxyLkSR+ox4Z08Prqe9mZ1g
Date:   Tue, 17 Dec 2019 02:24:13 +0000
Message-ID: <VI1PR0401MB22378203BDAE222A6FDCCD09F8500@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <1576510350-28660-1-git-send-email-ioana.ciornei@nxp.com>
In-Reply-To: <1576510350-28660-1-git-send-email-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 17444dac-20d0-4cf0-cc6b-08d782983584
x-ms-traffictypediagnostic: VI1PR0401MB2333:|VI1PR0401MB2333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2333D20266925054E53CBCE0F8500@VI1PR0401MB2333.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(189003)(199004)(13464003)(2906002)(33656002)(6506007)(53546011)(26005)(45080400002)(86362001)(64756008)(66946007)(66476007)(66556008)(7696005)(76116006)(110136005)(316002)(478600001)(71200400001)(81156014)(8936002)(9686003)(5660300002)(52536014)(81166006)(66446008)(186003)(8676002)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2333;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C/3j70Ir5vtBJ6+sLFL/PVrmPsR+eGto8pz/oG432CxQdOB482OJcYF6Wb1nWPgWz9etFNVYxv9TL5mqWzn09Ggk+pXdmFqsmfOQi6putUnJq+pHDCUWR9uL9cDowploQSlqmG8wbxToGxr6gMEi5umu0wuW44Z0IzR09KEODIGoFCy5VoW9pu109yMBbVprCmAE1IcDzlJodCk+qjtuIyLAkFAYc8PzPsGSITlh5yRoNw6lI2qeQ/OyetfuicDJtbgEBGejxaRm+9+K8IoeEsHlmJf+ljz92PQhahcJzWISsZbVlSwVdfDb3Vlh6gx5oLNJ9qf4YpQhAqaDcUcHzK/jeiOXvUX7eOgmqxegYMcmS1frc4LhtYilH8hYIa+uQDU752d6xTBTK1oEA+SNMjouyww3zMJfvBdUwnGospL8bEM5n+rVt28ryrez2MczVQljGEeulx+HUc8fkyxFQcqIx8vk4eDys8bQfzfvvk82UG8tFhbOwW/xnYb9PLNO
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17444dac-20d0-4cf0-cc6b-08d782983584
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 02:24:13.9790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yRiJjnHYzt/wrerpvXy0x3CsTI/lLDK6Lm+yaqmWbB3eV35U2jFNHAWEFxTv8vYg4BXqOvptvr9ESyDy3fh+3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> Sent: Monday, December 16, 2019 11:33 PM
> To: davem@davemloft.net; netdev@vger.kernel.org
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; Y.b. Lu <yangbo.lu@nxp.com>
> Subject: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ

[Y.b. Lu] Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>

>=20
> Upon reusing the ptp_qoriq driver, the ptp_qoriq_free() function was used=
 on
> the remove path to free any allocated resources.
> The ptp_qoriq IRQ is among these resources that are freed in
> ptp_qoriq_free() even though it is also a managed one (allocated using
> devm_request_threaded_irq).
>=20
> Drop the resource managed version of requesting the IRQ in order to not
> trigger a double free of the interrupt as below:
>=20
> [  226.731005] Trying to free already-free IRQ 126 [  226.735533] WARNING=
:
> CPU: 6 PID: 749 at kernel/irq/manage.c:1707
> __free_irq+0x9c/0x2b8
> [  226.743435] Modules linked in:
> [  226.746480] CPU: 6 PID: 749 Comm: bash Tainted: G        W
> 5.4.0-03629-gfd7102c32b2c-dirty #912
> [  226.755857] Hardware name: NXP Layerscape LX2160ARDB (DT)
> [  226.761244] pstate: 40000085 (nZcv daIf -PAN -UAO) [  226.766022] pc :
> __free_irq+0x9c/0x2b8 [  226.769758] lr : __free_irq+0x9c/0x2b8
> [  226.773493] sp : ffff8000125039f0
> (...)
> [  226.856275] Call trace:
> [  226.858710]  __free_irq+0x9c/0x2b8
> [  226.862098]  free_irq+0x30/0x70
> [  226.865229]  devm_irq_release+0x14/0x20 [  226.869054]
> release_nodes+0x1b0/0x220 [  226.872790]  devres_release_all+0x34/0x50
> [  226.876790]  device_release_driver_internal+0x100/0x1c0
>=20
> Fixes: d346c9e86d86 ("dpaa2-ptp: reuse ptp_qoriq driver")
> Cc: Yangbo Lu <yangbo.lu@nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - change a goto err_free_mc_irq to err_free_threaded_irq
>=20
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> index a9503aea527f..6437fe6b9abf 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> @@ -160,10 +160,10 @@ static int dpaa2_ptp_probe(struct fsl_mc_device
> *mc_dev)
>  	irq =3D mc_dev->irqs[0];
>  	ptp_qoriq->irq =3D irq->msi_desc->irq;
>=20
> -	err =3D devm_request_threaded_irq(dev, ptp_qoriq->irq, NULL,
> -					dpaa2_ptp_irq_handler_thread,
> -					IRQF_NO_SUSPEND | IRQF_ONESHOT,
> -					dev_name(dev), ptp_qoriq);
> +	err =3D request_threaded_irq(ptp_qoriq->irq, NULL,
> +				   dpaa2_ptp_irq_handler_thread,
> +				   IRQF_NO_SUSPEND | IRQF_ONESHOT,
> +				   dev_name(dev), ptp_qoriq);
>  	if (err < 0) {
>  		dev_err(dev, "devm_request_threaded_irq(): %d\n", err);
>  		goto err_free_mc_irq;
> @@ -173,18 +173,20 @@ static int dpaa2_ptp_probe(struct fsl_mc_device
> *mc_dev)
>  				   DPRTC_IRQ_INDEX, 1);
>  	if (err < 0) {
>  		dev_err(dev, "dprtc_set_irq_enable(): %d\n", err);
> -		goto err_free_mc_irq;
> +		goto err_free_threaded_irq;
>  	}
>=20
>  	err =3D ptp_qoriq_init(ptp_qoriq, base, &dpaa2_ptp_caps);
>  	if (err)
> -		goto err_free_mc_irq;
> +		goto err_free_threaded_irq;
>=20
>  	dpaa2_phc_index =3D ptp_qoriq->phc_index;
>  	dev_set_drvdata(dev, ptp_qoriq);
>=20
>  	return 0;
>=20
> +err_free_threaded_irq:
> +	free_irq(ptp_qoriq->irq, ptp_qoriq);
>  err_free_mc_irq:
>  	fsl_mc_free_irqs(mc_dev);
>  err_unmap:
> --
> 1.9.1

