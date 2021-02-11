Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD66318BAA
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 14:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhBKNLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 08:11:08 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63740 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231610AbhBKNHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 08:07:40 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BD0UYD021914;
        Thu, 11 Feb 2021 05:06:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=LDx4lMcPehYTRzkxYSfM03zu83xyhRbgTcCczKLiupQ=;
 b=ddUlQJyRJDwcXkyTnxPcScNi+u6UySO1caRY99/3rKDPewM/LoN3oNIWddFOGickNXVZ
 FsXvJIBoZ7q0hv2eSJvjyyLzq8JSLIAD8RLzhdcN6jIvUWD7sx2ufRhyEbHvLEKzTuh0
 RbHKg8QAQCaTTleAdispA1OsQ8+OJxmK+gtw9v0aRD6tQ9dQOKmQlbb75xytCKnNi331
 EzZdjVpEH1/feAqJeL3TW+JOfMlVsAuf7K+a9Qw+txlVyWTgMSd6DXI8BUqUnqRE/wfY
 fp/T6BoLRz6PMdWeX+CC/B38dUaQwaAxSucHDsqjWrfdvyI4URAPqlZkU2z4TMe2c/8r zw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrq1qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 05:06:45 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 05:06:44 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 05:06:44 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Feb 2021 05:06:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlzIiOI5rHPEtiXhh3545lfUOa8BVbRf8ywncOD4fbE+6Bp9k7fTfyOyXoEBGd+wNqz6vTSSvkmTr+GEOS5CR32iENO88AJIH416aOrwYdgaU0RhyzBf4Vx0r755lWVMU3QjXlPAOHRc/8XR4R0ecGIIBl1HCDoxle0gwnLL4x5TKge38b7LWVek+rHeA9JZMeTVIu4IYEQowbOkEcTUvEOC/Mwqj2TEw0MMULK5OFECtMGhHz9NuonMWm2XVY7t4008ayKCH4oQ5gu1S5WhVkaw/IQWcoD99smMMhz+y7IyKUtIvvMewBKxVtLRDLs8hdnVGrZmM6Ex7X5Bmq/nOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDx4lMcPehYTRzkxYSfM03zu83xyhRbgTcCczKLiupQ=;
 b=b8TIaUFulDrnA5VzqB2vorwkqMriv1mlKx9/2FlvZ15sQZUh6lWems96m7b9zHkJxYUQO9F9P7RR9rX1dBlG5nFSKuBLvlmvEh+BAH2FR7vWPyWYl7EKhMncdyzqWE6dcE3LDlMSjoSpSFJWXBM3IGJ7E6LHJtBEiVQMd+1vH0QYTAzHhhSp9RI73TX3V+8Fu4rPEcVdoweUfaBFMXtND+2vlb++JwoHGuJgV1Ub3+hNSbv0KzRaIuiUqk526tPBZocfkkp6Eb5CfbnQU5FhBlaaxcQxR27V3wlOuiZG4jd0YPjcVOW8qhRFxaH2IXkF4UuVsr0w7gpEgPfcWTtq0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDx4lMcPehYTRzkxYSfM03zu83xyhRbgTcCczKLiupQ=;
 b=i2M30uxAG86WYw4/e3i9eTUa8MomDp11NM56uNr77cjg2Ugx04zzBzKdQtIVH1Jg7lF5lDQo1Yez0MlOTmLZmvMAnbQx0HOQBhC8q//SCQXOzWM51OPabELDBSFPh1a2J031jBGAjbIWdmLC6lsf/qJngKuXQE5Gdx6DfTKgpGw=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW3PR18MB3561.namprd18.prod.outlook.com (2603:10b6:303:2e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 13:06:42 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.025; Thu, 11 Feb 2021
 13:06:41 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH v13 net-next 13/15] net: mvpp2: add PPv23 RX
 FIFO flow control
Thread-Topic: [EXT] Re: [PATCH v13 net-next 13/15] net: mvpp2: add PPv23 RX
 FIFO flow control
Thread-Index: AQHXAGQqIV7fN4UI+Ey/TvFhB0myCKpS6bwAgAACqfA=
Date:   Thu, 11 Feb 2021 13:06:41 +0000
Message-ID: <CO6PR18MB3873E18A4761D8DCB6D4300FB08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-14-git-send-email-stefanc@marvell.com>
 <20210211125606.GH1463@shell.armlinux.org.uk>
In-Reply-To: <20210211125606.GH1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.25.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83380dfd-7ef5-40a8-0f97-08d8ce8de031
x-ms-traffictypediagnostic: MW3PR18MB3561:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3561C988870B27EEADC8C144B08C9@MW3PR18MB3561.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: benrgYURWCqQFcFlP8fRyGjDoOi3Nafpf7ZYkL3E2hPs6mXl9+trP7z93oLdsT2mb+tPEpolb0fK4pb8cMP3O4S/kOdKJ/LEuX9muf7cN/pS0P4XYrq02pXebUErLSeFqnhBq6Di0n/icskbiCQWXOhrlHZmCZ+QUMGkiIO/EDn0jhFWn4HoNGd69awHekioWxv3nh0VpetA2favks08ElvVSTWe5Ia9T+tvg8f9r+NAC9dHA6C0sm+RpEmF7JGBrFe8fYogoxc3MCbHeRnOZGcIfcaR2yhaj14es/aXKuqR47VuNKD6XyPaNPffUy4P3pEMbkDgs6uDZo2wInpzOt2t8ZSIFjEn2YGo5TXUo3XXaj0vk5tK5rdKUiWtMsLu2NVUyy+wHT5U5oPZ/k/8ZxaWn+BbiWBtWNpOFwKjC2THpzB41vyJ7oLYQhzHf9xk7/gZfmqhQ5OEHn1E3RldHJ6JyXBHjt8AYwoWd462uOY0e//T2pI+tgYTaaFsQQPFWB84JrnqPE9KlajjlImX+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(55016002)(9686003)(6916009)(66446008)(7696005)(186003)(26005)(6506007)(8936002)(2906002)(316002)(54906003)(7416002)(4744005)(64756008)(66476007)(86362001)(66946007)(71200400001)(4326008)(76116006)(33656002)(8676002)(478600001)(52536014)(66556008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Ipqy8dxkjbcpLpQYyz6D6EGg16rH5UpWQKF5DIdbgG/wfsSuMIXRxuElazP4?=
 =?us-ascii?Q?jEFqjKs/GRqMIjGjeC+sx9Amh+kJpArmacPtoEV4S/EInBU4jqq0HoFWUP+L?=
 =?us-ascii?Q?nyay0ZkWIAkuyGVl0/3Fd9B7Jo/DSASNjACf5XCtxhmixVL66HvP1YtWba4M?=
 =?us-ascii?Q?j0YlnqvZFU7r5zT/o6jbrBb2PAYv/M1vXJZz80elSue05h2KF+kePhwSJaHl?=
 =?us-ascii?Q?lnlAYWckuXx2zEYCN1SpD10/Yup1Hj3sJH5uy+oLyfdSRWuilAdWFBbuOfXN?=
 =?us-ascii?Q?w8JieS3lzjC5MZ0MNCpaKWlchkw0Rt5kTIcWNfWCca8dLkInM18wgVNVn463?=
 =?us-ascii?Q?NuVFCaf4VtFOnub5vN08Q/WhGh1ozJ9PZl7ai3zmwMosQLiYO1VCGndWtMW7?=
 =?us-ascii?Q?28ziJcVMC/ni98VilWyLovf2F6fpD0HAGtoYwdqcg2JwGZ65SWyUv0guqbcl?=
 =?us-ascii?Q?5F0R/Lo+6Lh+BJBt43O73zQV1LPYY9RdMqo37C8GQk1a63Lw636tS1S8nOas?=
 =?us-ascii?Q?QjLCyhJrZppeJQvnk7OKaky/79wyyMKjNRZHkR6yKiTvYRtCJ5JVL40ZvC/x?=
 =?us-ascii?Q?TJfmJj34u0s4Lkczcfw0fo5bXCLB7A2TlB4Tx2fF4gGEaJFiQCinJ+QilBz/?=
 =?us-ascii?Q?zwoB/DScyfrgNbO+LX/K2a45Q2I59+mSjLftOo7sgKIUvO8kDoblDFVTW8rx?=
 =?us-ascii?Q?b+7TewT1d78nXK58ZodCpKlXKtRwiTC5EyBBVMNuGrSMfuTiV08dMG3F/5OL?=
 =?us-ascii?Q?tzsRaqheSajcy5d+z2mUXTBXcp6cGUKEYLjmQ/zk2xO72yiWYopAfBJzcWgP?=
 =?us-ascii?Q?UYr4pvmlnzzcyrps0F/NP9RttX83lvSm0KpfIVH+dpdCaOI3Jp+D/JHSL391?=
 =?us-ascii?Q?snXXLus6u5j2e28RFA9kVusQeFF2VdkqCAjbtD0pePEfIivVm95sqKGnbbTR?=
 =?us-ascii?Q?VPRW7x+sWPDCswUgAFdc9FjvdKFQCJ/KLylvS2825L8ulGd1KpyeWxO8nGZ0?=
 =?us-ascii?Q?Dp7R5/BEXU692n2dIjQVcWMTo1CdSJSt5ncMWocz7BhjAxx0zTTBPp6ZUxsM?=
 =?us-ascii?Q?3GP0N4kEqNEw3rUawg7OKGb9QUFouTXr4ZcvTFwnkf0t2SPwDAas4NNvcE2L?=
 =?us-ascii?Q?aI0wsY3bXy99YUZZMg/qwq0qsdBdI9X51/N4FPxRkEIfBw/5bP2YQNf8D0bH?=
 =?us-ascii?Q?JSEqiCRLEf/eJ4ZrtK8pi6WG9oUwO5o47zj8Qz815bv6NdgVBZajaC4CbWU7?=
 =?us-ascii?Q?Sd14re3+dc4QpQjenHR04N1Lg9zw5mim74h+sT5fBc7s9fVDHbm7kfWVZUVF?=
 =?us-ascii?Q?hxU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83380dfd-7ef5-40a8-0f97-08d8ce8de031
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 13:06:41.8732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h/sfSd0sh6eb3qx+Tm6/+DE5QBwToC3l2mkweyjOI+YcBQiIV4PN9jOgBTOrmYvBczOjRZBKn01KZikX5eT5IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3561
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_06:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > +/* Configure Rx FIFO Flow control thresholds */ void
> > +mvpp23_rx_fifo_fc_en(struct mvpp2 *priv, int port, bool en) {
> > +	int val;
>=20
> 	u32 ?

OK.

> > +
> > +	val =3D mvpp2_read(priv, MVPP2_RX_FC_REG(port));
> > +
> > +	if (en)
> > +		val |=3D MVPP2_RX_FC_EN;
> > +	else
> > +		val &=3D ~MVPP2_RX_FC_EN;
> > +
> > +	mvpp2_write(priv, MVPP2_RX_FC_REG(port), val);
>=20
> 	if (en)
> 		val =3D MVPP2_RX_FC_EN;
> 	else
> 		val =3D 0;
>=20
> 	mvpp2_modify(priv + MVPP2_RX_FC_REG(port),
> MVPP2_RX_FC_EN, val);
>=20
> ?

OK, I would use mvpp2_modify Here.

Thanks,
Stefan.
