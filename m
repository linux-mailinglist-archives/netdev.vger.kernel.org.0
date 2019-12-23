Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF31129205
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 07:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbfLWGuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 01:50:08 -0500
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:54851
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbfLWGuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 01:50:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbV709W0AsGq/HcnGOiwevC5yJ/Tc7Z6kanNOsRw3RfERD7rW6So/CLfbyxfibF11XwkbpIGAXurHD4wTolZr5th0WFcpI5lWMJimNV+DSYP1fjJvaHsH34UDs+vE6qk7TzmMDghN9ZiFHQYSswCDR/nnI6a2r6xtwqlstbeiPRE3IyOMhjvILJxcmKQTaZ957wJS6bjNoJFBLJMNHiUK4sdz/14J7SoivCkVD6WI64eEOHp4qAGOHq4AYHU9xGMLSrwlqqGXyHCxPbLZzOIuKISAPVrYCbHsYzg5gwessLKwoUR6pj4DwRGcJgQnbWKlvCMDtmYt7HTy1JeDSViqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJh4oWB8ytJDiSAuOfi7RKc4He6+NIJqTIZIgoYgo5E=;
 b=Kb8KnKULT77ikW4XFNaCAKT0JaiRPuZ0tuXRZOUJKs5LDxOhc5Z9skIlpTG4TKRffRvI0TsDYUj1xtN238OS1beh16C/exqNUp0RI2USN1gwuo3yhqGmr9tosbPZfXr7VYKTjEZQ234IW43x5VA5NeBsOA9d2gsc19/diVbF+F5sz3RUiscaQBF2QqihP8ZCdOEWJJptOFWjdOoAf58mLArtvhZM7RWmbA7qdUXXOCt1UnW4YUWUc85N3oUSsjiYUdZdc6iW5L3nHEGELvYUV5ZdNrZFlibVkB/7grI9AlZqOXD41ttxsW4yBeVSyYi97gt1mIujdpKESDjwfkKaLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJh4oWB8ytJDiSAuOfi7RKc4He6+NIJqTIZIgoYgo5E=;
 b=FTQ54L51WxMGu3nctMAlkPD9Icd52Oy+FFgXLjM30/6IDquGQSjrMGA2MOPbyxUuvxweomKm0NF04nQ5uSgFPKvXsGXl8Wr3oG80wkahKpu78tfdiZx3a0XJjL1SijXcDQT2bL6YUm7RR3dE4Tf5QyMCsbEKUWTe7wITG6ceVoY=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB5277.eurprd04.prod.outlook.com (20.177.48.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 06:50:04 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 06:50:03 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     David Miller <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] dpaa_eth: fix DMA mapping leak
Thread-Topic: [PATCH] dpaa_eth: fix DMA mapping leak
Thread-Index: AQHVtnXZRmk6fTbj3EGul63ThTY2tKfEFAAAgAM5e/A=
Date:   Mon, 23 Dec 2019 06:50:03 +0000
Message-ID: <VI1PR04MB5567A2BC5EDF345F6A8AB59CEC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1576764528-10742-1-git-send-email-madalin.bucur@oss.nxp.com>
 <20191220.213532.2095474595045639925.davem@davemloft.net>
In-Reply-To: <20191220.213532.2095474595045639925.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [188.27.188.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0a215feb-7f7f-4d56-80cf-08d7877456df
x-ms-traffictypediagnostic: VI1PR04MB5277:|VI1PR04MB5277:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5277115696514295B65411B5AD2E0@VI1PR04MB5277.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(189003)(199004)(13464003)(8676002)(9686003)(81156014)(55016002)(4326008)(8936002)(478600001)(2906002)(81166006)(7696005)(4744005)(66556008)(64756008)(5660300002)(33656002)(71200400001)(26005)(66446008)(86362001)(52536014)(316002)(186003)(110136005)(6506007)(66946007)(66476007)(53546011)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5277;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2L4oNkh3mr+Bq9tiBBZtT3MdMQNCZxZ+ydDzBVIaA5yH4FExlCJhWfcYhlVo9gxmQHgUNCXlaICumV00zBMLAAe8zmzQfhL2fkYwepsL7k7TEI540/FltBpIvBb5KXr7upa4xA992f7VkP8iAQZbp6IG+tE7n42fFSNwAEdRv+6l9nmyka7vl368YTLF6lb+6ZliDhBKqO/XG7EWKWn/2voLjS/upnWX3B2PnlYPj6ahLzvWUgXV6yPMoPEVH3YkWqhkLYos7x4A45BJvoB5pVqsSn2Z3dXrfORASPwKy87LL5X1SS00LyjptobQ3LCf/slqShRRgnW8EdtBcOZtejMuPim8YCSajFzU1X/85qPsEV7TUJOnw58+iW/WrJN/chtDXVK7w60s0UbdWzSKmt3giaXAi9pbuEyCnC0BXoa5bWOaDWyZw+IH6dJ7Gmdf+MuFl3oaeAioPnpnfmS0hxMKc6wwstJ6GYhFTIakolNcaDo6+R0ae8goGEppQNJ8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a215feb-7f7f-4d56-80cf-08d7877456df
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 06:50:03.6420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2NBZA/hhuFV9LQNtfWMgIb5+6mcQqYna+eCWFoUa4E8gI760Z9rp+6qyHmMwYwzhKpG7nEDwGZUhOKkaSAL3Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5277
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Saturday, December 21, 2019 7:36 AM
> To: Madalin Bucur <madalin.bucur@nxp.com>; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [PATCH] dpaa_eth: fix DMA mapping leak
>=20
> From: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Date: Thu, 19 Dec 2019 16:08:48 +0200
>=20
> > @@ -1744,6 +1744,9 @@ static struct sk_buff *sg_fd_to_skb(const struct
> dpaa_priv *priv,
> >  		count_ptr =3D this_cpu_ptr(dpaa_bp->percpu_count);
> >  		dma_unmap_page(priv->rx_dma_dev, sg_addr,
> >  			       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
> > +
> > +		j++; /* fragments up to j were DMA unmapped */
> > +
>=20
> You can move this code:
>=20
> 		/* We may use multiple Rx pools */
> 		dpaa_bp =3D dpaa_bpid2pool(sgt[i].bpid);
> 		if (!dpaa_bp)
> 			goto free_buffers;
>=20
> 		count_ptr =3D this_cpu_ptr(dpaa_bp->percpu_count);
>=20
> after the dma_unmap_page() call and that is such a much simpler
> way to fix this bug.

Thank you, that will yield a simpler cleanup path.
