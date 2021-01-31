Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADC5309D55
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhAaPNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 10:13:55 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24572 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232282AbhAaPLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 10:11:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VFAeEZ018797;
        Sun, 31 Jan 2021 07:10:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=fos2x9isHH5ide6x0TbjoCrR3nmbMJXNf0wVgl3o5NE=;
 b=dyiHTHEL2FNSZo+ik2sFXcpkgvjy5gOhlAaLePWG+b2hMdaQ/bn8T/OYBR4cxg4ohmGY
 SA+/3FxJyCxZwP5wtL5DzssJb/EnxgWBdwJfxvERyUaasvabgjw3PS8M4VOkLVuHfdas
 AKi+0WgVDP4UclYy1s92jyts7zPfpur0KGlHc6ifD+Y0ru5nWoIMddS02JXMfZuFvLhj
 TAeVJDA86SFaExewsJAZayUXjMVk7ADDEFG+dzBc4c1J/PCTkz89wCkQ9XPN4qgidBV6
 jg4mZ4POzRy58zso/vnlpSc6u6yz3j655P8YZdLyfWPp4vhEUPEKJ++nMxI6/5KhlV8g JA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5pssxes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 07:10:40 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 07:10:39 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 07:10:38 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 31 Jan 2021 07:10:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPRQjOmpFRT5uKR7QrxYgzG6302d9yg9rjYPd8vXKxEtMahswEzyy11nDtTlybth8JiAR4DFlFSdHnpYMkoCVQSAZkTWJyDRKOXD8xm28g8AwTOzNez/NKNQesiRKBRERasxqtQZapcl5lj1/QSMNL5v01AKfI+B/2DjZqLgoBNTqlH+BkhlzpEldcUXslL5B2+eVGlZk509VqMh5GgwYP7wWsRdZLSRGB5i0KdohS7Ida9qoWLLCiFUZNU4npWevT9mdsZA7xjAiWNJcL9UXKXouvQhU3ckfgZ1H0X/VkDf/QJDRN69KMcyZvR9o5ysiABXZJQlm8IJwzTb8NPuKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fos2x9isHH5ide6x0TbjoCrR3nmbMJXNf0wVgl3o5NE=;
 b=eh3HttFDTggQkL8RpLcfNc9u5njxBxaR26xIVd5PXKNmDDngEi5ME+liayYieb4DMILZ6kf98tuOS+Q2PWmK+cMlSAS0F0cxgjEWDy/MAYdeInSmq0MZBJLl4mL/kNR8rA7fLNhcwIOyHP+0vMrF3SKaOvxAdnfe8nzYPO53Z10+JYEln0ZZG4dydCteQqSxi6l4PMrqAIokT4jCH+Uw5Eg8W+joPXl+z3f41BoIoU/cy9SXms6JCmHcT37Q0AO5BRw210K/jCW3iilTXtWp4mxcZU8cHezicv4/YH4UAD5+NmQ8cppBsTHS75YgGwi7+0b4PpsEt9uUlaSLsslQPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fos2x9isHH5ide6x0TbjoCrR3nmbMJXNf0wVgl3o5NE=;
 b=uNiLm0f5AT/VO5inJvYPBxsPbxaD7C2jrTbgWB/MDPLVKX7pWu26UEd6P2IGQfZeXcTy0pUNP7flGkqvJd5ACUudUxWkghtlqhq+4b2vkLlC6yC/nCK+ERgjiFFldNcTHPwkEN4ncFUTJlkwbUVB9xHh0G3zhQPy7tqshnd5zDY=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW2PR18MB2188.namprd18.prod.outlook.com (2603:10b6:907:d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Sun, 31 Jan
 2021 15:10:36 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3805.024; Sun, 31 Jan 2021
 15:10:36 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v5 net-next 00/18] net: mvpp2: Add TX Flow
 Control support
Thread-Topic: [EXT] Re: [PATCH v5 net-next 00/18] net: mvpp2: Add TX Flow
 Control support
Thread-Index: AQHW9aPOiPqZIMA/y0u3Xuo4/7naLqo932+AgAOi7iCAAEspQIAABpwAgAAEMoCAAAGUAA==
Date:   Sun, 31 Jan 2021 15:10:36 +0000
Message-ID: <CO6PR18MB38736280C339F36B1C985E72B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
 <20210128182049.19123063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO6PR18MB38736602343EEDFB934ACE3EB0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <CO6PR18MB3873FF66600BCD9E7E5A4FEDB0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131144524.GD1463@shell.armlinux.org.uk>
 <20210131150025.GB1477@shell.armlinux.org.uk>
In-Reply-To: <20210131150025.GB1477@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec74b1fc-3831-4fb6-21a1-08d8c5fa5d1d
x-ms-traffictypediagnostic: MW2PR18MB2188:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB2188CEEA5D99385EF50AFB6BB0B79@MW2PR18MB2188.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:327;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h2PBcMVyUH/BFJ1yoKZKICz1yyoVlT5zoOM8vbNpmO8wNJSzBBpnT+tPXTN/zeU4IneVkOGpUmI1iMEijEm88Jhk8Stq7uKy4gNNOoQssMSey4Y6tqFV61ZPRBjeDFzcksSPD70b+WSuIo72dCd1HfZ9tuz7KvWI0n7G+IW5qsrTD6aUmGBSJZjfD7xZ7JPKGox2fmCvb6/x9Ocs9r7VoLsXqwC35yLI+DofCknD6i+K8J7YZxVqe/4yP7qXNfThUSOm1/LKofGpcxXMkNUHAtCm9dsc2k/vItQLllW16Fs4GT3LlL7UYBNHnKMHidtx0HGQYjmplJASM8OYCGcmXaFJXaOJZ/Rt5F7TszTG2j59+Rz1QSZ1pyod2MmxT83hcwMq8nlCRRRJl3A6Hel3//LStU4ASoWD22Q/6uyOldRmdoyoy0oiZyRI6VpnRkV6hz3p2HaeFAZt6gyZcHE/itjYlFaKakrJnCuAhAC5GxJbYXe4xKzjmICfbQU7LzVmltv+2ns6F9ayl5uU05ZW5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(136003)(346002)(396003)(366004)(558084003)(7696005)(478600001)(2906002)(316002)(8936002)(86362001)(4326008)(8676002)(54906003)(33656002)(186003)(55016002)(6916009)(66476007)(66556008)(26005)(66446008)(71200400001)(6506007)(66946007)(76116006)(5660300002)(9686003)(64756008)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2KZTRCHuhFXkMvviTHi/RzdxS0ay5R45OKonFHvXUzmrBitxS0HWdJ15AoTr?=
 =?us-ascii?Q?URvL/d6ZIL5nu+MsKg8eKVu6Tz2OGeOJWS8vQOLL6qt1/jVRiGe3V1qlpvFw?=
 =?us-ascii?Q?H+pYMmKHpVhFCkpChYxC3VPLmzpt26bbcWkZKoZefwyc8wl865mC6Wt6KDM1?=
 =?us-ascii?Q?d67C4T1p/tSe1gEvrzVFEnxPnKlSPym84kyQYDU2aqbgflkEgTn1nvU34Lo6?=
 =?us-ascii?Q?PIwQ4xvl9H8I90Z9+kGrJjTwdHHamQwN5IgKfEfFn3x1DYI7wJEDVNcUV0I8?=
 =?us-ascii?Q?H0a/ir9P9ArPBkDNvgcFHVqtiCbC5Zj5iS7R5n+LZgnhodpL3PmKSDApIyTt?=
 =?us-ascii?Q?ZsFjuOAcgOvAuUryh0QJ8/2cIoQmCsAqocbdQnvkl6Riq2YBEpfiLTut/71k?=
 =?us-ascii?Q?ekTr8Cgnw6ui4ydFlnFdjqXPyL+6Sye1DrUccPGE/gKL52NZ8Vj/2VXrHl6k?=
 =?us-ascii?Q?BKlFuI9DljFkjrG+k+cMxDneFTUsCJ/4N6TF5geM9+h6EWGkag87EZUCVjK8?=
 =?us-ascii?Q?D5jy16W6ys7UFlMdNrtnaDu0hVCfFsbSQG6u38/yT1DD0kzHB8ihLvLcKjK+?=
 =?us-ascii?Q?lFyi5D/R8PXVnp4kFXYa2cmyAO9iLbXe46MJtuXGaTn/H2q9I4MhhmYG0uQV?=
 =?us-ascii?Q?DqX3azXhep7QDZVmUY80+sRGPn+slcaCHwStMlvf5TYjZGTU6+dnpp1AsNsC?=
 =?us-ascii?Q?i9WTFLi9UPCYjvRQaB8uZ9owZLxNkzPkK3cv4IIsYDrEc7fotSJjTGo9MAOz?=
 =?us-ascii?Q?+FV5cg26QY/oascdnJk9uqtHezBM1vleRVgRMzhqyjdgm1cVNDMbdNOEJTSP?=
 =?us-ascii?Q?eKIHIDHntNKVhsUWEp4bTQb3B+Uoqu2D2DEk9ry8K/NCM+kkvPFRtjqJ5NZU?=
 =?us-ascii?Q?Cs8Q86C1BRbOQok9JNZNyp2tO8L5vbgVwDhvT20NqAzpnT8ByWblkCJU83W/?=
 =?us-ascii?Q?1YNd8l3JkALAR7m51Rf6jZkT/ecFuIRhTIu4hQAyp+7LOGL9J5/E87WWsvsg?=
 =?us-ascii?Q?3oP6cVd2YdGCwu4a+NROobkUc4t6/Hf2qu+RXMIWO8leXe/thN8HTGF7p9TG?=
 =?us-ascii?Q?6PbZXHOV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec74b1fc-3831-4fb6-21a1-08d8c5fa5d1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 15:10:36.7113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N2SvLO2Tz1F2/AnDRw2+Z5vi3ZNB3A3eUbhywwAgNL4ilO2Ncgz+8Uw7K/rp4OhHJ+983megMzK6WI/jclo0sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2188
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> Ok, kernel.org has now dropped spamcop.net, so email should flow normally
> now.
>=20
> Are you sure all your emails are being received by vger.kernel.org?

No, I get Undeliverable Email response. I probably would wait till tomorrow=
 and repost them again as v8.

Regards,
Stefan.
