Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1DC354116
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 12:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241055AbhDEKHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 06:07:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42132 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232456AbhDEKHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 06:07:37 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 135A7Pkc002137;
        Mon, 5 Apr 2021 03:07:29 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0b-0016f401.pphosted.com with ESMTP id 37q2ms2wv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Apr 2021 03:07:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEC9Z002u4LKnpaP0dkxZe+5gfRl8VvHxzpEnf4RicY8cV4TClleDItkYFX1WSFa3ABWOq8GfoIJlCyNYqz7NoXS09uF1w/YK2O3oybUvGQ3BVtnwilzZXSry+E/7vhzG8taTEWaDHmc71MZCzJkm6e/nH41Megpr+U61oPErccfgGH3NbLGq7oPyuJ9W1dZGcFbkJetVi2oL8kKgKGPqXpkqfi9/wzh9qTRjgpTFSWIcLJkKAIT0XzJv1SE2v/M6pI+W2VN4Zo81d4wgjMil1W+axRHk7n5isb7+3Cj9rAHIqkPas+uPAcia3gKkrzBfUr6QCAccTlGfWlehv4hfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bhvb72ppEqD5+BLqSUKXfzw+MlKFoeU/hGzPog4ljbk=;
 b=ENBLFxs6AWp+mNxvB5jp4W/YqexvoEseZrOwnkVSYypaF2T9jEUax4VU49bL57Hx/JkgzBXljJkEaIKofsQmNjzvVYdaMbV2KYiwIsflGJHEfHEqWHVA7dQGTX8S68FfadjsRSQZwUseLV6b+lbe8ye4i+zTiTjytbEZyt61KO3EliwLyIjoUZnZP4WGhO2F1BeXlFJAmaXwcjYq0aoYF9vriHSyhHGMRlDR3pIQbmZ2UjrRsHzEtZ84ep+j2pW/QOs7OKBrdxAC08qEP4ofXDH/8Abvlsl5wlP+6YC0M9UjkeX2SR5NNLair39lhGFBEPqoKAlJWtDdWk43+rM79g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bhvb72ppEqD5+BLqSUKXfzw+MlKFoeU/hGzPog4ljbk=;
 b=EhgAKG3cBuGosrfZCosEVbm1xa61Vgjc6caecE0ezYhdj/RvVlYkmzLIVQIQVZhsrQZk0K7JFL5ruxew7QDg8AAoR2YcypdbCr0bzoKjXsbQRdVzg9sfPSTu5GWZnuLESs86UIWgeXdH+v57AvB9zrwqiTyXXtG2KaousWjBZ90=
Received: from DM6PR18MB3388.namprd18.prod.outlook.com (2603:10b6:5:1cc::13)
 by DM4PR18MB4367.namprd18.prod.outlook.com (2603:10b6:5:39f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Mon, 5 Apr
 2021 10:07:27 +0000
Received: from DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::954d:da2:7c1a:37b5]) by DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::954d:da2:7c1a:37b5%3]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 10:07:26 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [EXT] [PATCH 2/2] qede: Use 'skb_add_rx_frag()' instead of hand
 coding it
Thread-Topic: [EXT] [PATCH 2/2] qede: Use 'skb_add_rx_frag()' instead of hand
 coding it
Thread-Index: AQHXKVAP96DDFFdKl0Gt46ZJTDg4Gaqlsv0g
Date:   Mon, 5 Apr 2021 10:07:26 +0000
Message-ID: <DM6PR18MB338846FE9B4E083A7D7FD4C3AB779@DM6PR18MB3388.namprd18.prod.outlook.com>
References: <1c27abb938a430e58bd644729597015b3414d4aa.1617540100.git.christophe.jaillet@wanadoo.fr>
 <ee2f585f0fdb993366b1e33a01a4a268ba05e6f9.1617540100.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <ee2f585f0fdb993366b1e33a01a4a268ba05e6f9.1617540100.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2409:4042:278b:70f6:c9fb:d831:d2e5:ee85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f15b1ef-0ff5-416e-410a-08d8f81a9d9a
x-ms-traffictypediagnostic: DM4PR18MB4367:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM4PR18MB43678642BAC74208149865F6AB779@DM4PR18MB4367.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:439;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JxJ310HKGl2s1p/zrgzkIdSsU3QKLuPJyJhIq3ihzkiM0dcBd8QXrgreMzMczG7jsmkGWQkaHBGJD7h2+CIF2RzlYZnPLVjVu1wdfxyglAVJRMbo83hn6asXnPpAsGJRNL8MIgHQJuRBlivNLN4vvUfuQW6+j/lbAfn0FOeIik8uQJBlzeaPWN6skI9rpe4McTzno3Ckc91hDzCWYItI4WKRIK3MYp1lP5DBc7TD2LYSY8iItnk4XjRJBZn25RVgeObmOql0Xi1hWxJzoc1/GO/Qbwok9Nwywxn5ymFNXcQ02juGFGnTiDxwixho2C6+5KiG2Z8qvQg8TWkN7L4VBM8db/+XlOfyPg1OKI6cP6oHDwCaf5OZCjSlw/8hCUMwO1Qdz4DACLB3xRjmq3QZuezzCEMc4gdcj2m07yguYLyP1Wmpe7W+PZLICEq+32lO7plQVTWGQ/yKxLhkpLLZ/bZ9unf9/4hCl+pSpRr7/0IaVYvUiMqkG2UQgm9MYUi+SKMBCzE1tLub0V9YgAVUGfz3l8Uc8/RZnmezDBUsqZY55VMxTkA2V3N6DRkNIyjNvVxoTTJr858X9dhJSoDrmZRc+ziQrVzqIx3zUxdu3WivgXP8+ZoioRLC+QIw4WmJoVagcRRO14oy0+bCYR1UGTTfbfm5XQADS47mLtTJQG0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3388.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(376002)(396003)(136003)(346002)(186003)(71200400001)(9686003)(33656002)(55016002)(86362001)(8936002)(66946007)(66446008)(7696005)(38100700001)(2906002)(316002)(478600001)(110136005)(64756008)(83380400001)(66556008)(54906003)(66476007)(76116006)(6506007)(8676002)(5660300002)(53546011)(52536014)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?x9owDV2TN2fEUpK4PkmaGVXBJi630OJ5hoy26zdmHzW8DL6wmJCQuiLCrMvy?=
 =?us-ascii?Q?xBhqrRM/w3LiaMcLjwFSfTf2Xi5JpPvNE3h9Wo4wqrLK7UioTkQN9Bxyp3Ng?=
 =?us-ascii?Q?jshAj/ePAhpUacD/SwTRwkx0nS4OYMeGhmMPSCvxHRoJrQhiO6cfYU+yB8zs?=
 =?us-ascii?Q?VGqd4FIa+KnAu/Xbq/PMWNiGuDJuN0E3N9lbHPSc1s18p9DTDbjia+njCEb2?=
 =?us-ascii?Q?Mt0oWxGcX43RjrSGMkkT0Pj21ZWQ/DRc4n7piTJ6hvup48WSyXfne+NHZYah?=
 =?us-ascii?Q?nqDkTq5AMSIBJ7cjzdFe8Ol+wAGOXkS15B2l75lF6wPOkIQJT0WiUyx27W50?=
 =?us-ascii?Q?i6JLPX2aZEaoC2Gk7y9/LhT+aXiVtooE/1XAohDXjSijDq9NHTIPLg3seYrf?=
 =?us-ascii?Q?J/PtyHUlR39BFc4QVYY1chxHs9U+3mYvBU3frebzHQj0HUg8sNqrm2jiQnOd?=
 =?us-ascii?Q?REAaknt4c3t7djnYzV1BahRKciYwPaDL8r4Bg8o9kTHiv/WVYsJbpdI+6XhD?=
 =?us-ascii?Q?RgOSyZ0hbMfQdAZK8786d6Omny1TcDzBKBFIT3oonFIQL5w/ul6k4SMq/6Vl?=
 =?us-ascii?Q?P2BnobvOgEe1g297muV54Nsll1iU2G37U4yq13vrZsO1CPslYfzPXXdYR9c2?=
 =?us-ascii?Q?ypneIISt/wsD01Y5U83DQuehhVRZp6NSMdeHoW32J1+nGFKOKM2wJ59T+SVD?=
 =?us-ascii?Q?FRVOrfdTBZGQ7nPoo/hRHazNzo/d1Uwa5IX9KDl33ryBl7M+lMeNW1TLUwSJ?=
 =?us-ascii?Q?p8Gv3vcG6xibDKSuT8/H2EANhDS4VWYOjLgt5N27sn7qR5cLPPJMpnIGCnBE?=
 =?us-ascii?Q?3FRLzIpBlfM1oi1Pn3Q/QWk/P5vmu8+pT14UpxlnE/w+M3LP4fSc01GoABSt?=
 =?us-ascii?Q?UtkTGIzwTbVcJcrvAAeqxnQQqaTVVGDOun8Loj67uNjE4njM3tumiiROZDD7?=
 =?us-ascii?Q?rOVrJvfv6RWrVv89xuwDoP7J2J6QLxIv5TZ6zSlrjOP7V55tQMrkQVSJhZzz?=
 =?us-ascii?Q?uXWxInSDNIZtfjV4rJBtzkolnLoa1XuGdhEvcfM2+U9wRXW0MS73G/fX5Qck?=
 =?us-ascii?Q?ekkeoAbsPwBMcXlRiaL8gxxNCsVNULRMUCvWN1wStxlFtbmeKo0TU8ZfC1U+?=
 =?us-ascii?Q?7w8uDyUkfYWaObAC9NfO9qMvya9b2CUYkytc5hEhziJzi77jvuVWwCHOUv2o?=
 =?us-ascii?Q?rntZUQxbt8MQoGB2eZYvVuW4PD80HIZW02KPx1tcU17dimflGZxn1ueGznbH?=
 =?us-ascii?Q?wdRhWkuih2Akg76Nllv7VDEuB4ehi8H5BmH81zWcSH7gPOvpCI/BJwGlQc8h?=
 =?us-ascii?Q?QC6lAw7QCEuisTQ3wE2tk/xpTWzEiWHBp8vVsMdRKqrOg6qFLRKBgJHS//fr?=
 =?us-ascii?Q?McQnlloDjL707VjoVd9RAlY7hdQZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3388.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f15b1ef-0ff5-416e-410a-08d8f81a9d9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2021 10:07:26.8126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aor0HKkDri/3Y4RUnVhZCkc1+4ShOVSl6GrEgGqU9KJdLABHzkvXYIlT+I+sYrXXc1t/3EvSC8fliSocuHS8jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR18MB4367
X-Proofpoint-GUID: Xs15WkDrrUPdMOGjnFN-JYTCc2in5z8G
X-Proofpoint-ORIG-GUID: Xs15WkDrrUPdMOGjnFN-JYTCc2in5z8G
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-05_07:2021-04-01,2021-04-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, April 4, 2021 6:13 PM
> To: Ariel Elior <aelior@marvell.com>; GR-everest-linux-l2 <GR-everest-lin=
ux-
> l2@marvell.com>; davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
> janitors@vger.kernel.org; Christophe JAILLET <christophe.jaillet@wanadoo.=
fr>
> Subject: [EXT] [PATCH 2/2] qede: Use 'skb_add_rx_frag()' instead of hand =
coding
> it
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Some lines of code can be merged into an equivalent 'skb_add_rx_frag()'
> call which is less verbose.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/qlogic/qede/qede_fp.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> index ee3e45e38cb7..8e150dd4f899 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> @@ -1209,12 +1209,9 @@ static int qede_rx_build_jumbo(struct qede_dev
> *edev,
>  		dma_unmap_page(rxq->dev, bd->mapping,
>  			       PAGE_SIZE, DMA_FROM_DEVICE);
>=20
> -		skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags,
> -				   bd->data, rxq->rx_headroom, cur_size);
> +		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, bd->data,
> +				rxq->rx_headroom, cur_size, PAGE_SIZE);
>=20
> -		skb->truesize +=3D PAGE_SIZE;
> -		skb->data_len +=3D cur_size;
> -		skb->len +=3D cur_size;
>  		pkt_len -=3D cur_size;
>  	}
>=20
> --
> 2.27.0

Thank you Christophe.
Acked-by: Manish Chopra <manishc@marvell.com>


