Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCAB50210C
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 05:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349256AbiDODvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 23:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349230AbiDODvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 23:51:47 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020022.outbound.protection.outlook.com [52.101.61.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD18686E07;
        Thu, 14 Apr 2022 20:49:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUYwJSL2HMQnMyr/ZJxvdqEyTgPlkSe7Zq4mZBoGWcef8jGNOTL6i/SZVf76az/TICCOv6KEYrq5R5Mv1kAMPcYAUsxtPJqt76Wg94+aOCkQVNGY3X4mhuZObqZEtP8/3n3oNiRuLLEf7H6OE8FhoqoBCj5gg3RnZG1B7/frL16rhOMNJFLB961kTam0vQKq5+nTw+ExsL4CAlRr2nGJtXr0pEVvVJiLR1OTOOULysYto0QiYtIbSLDSVQQ2jhosa8sk3dWfbeUv2koZrz1ZcC/ZPh9aqkRiST4rgmCD/MAO4qmGTv8akmPR3UdeEFNmlY5UAgl0WjD6b5MeUk91lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQ0f8dP0+kefWP5p59kEZ4SPEu4311HsaabrZhEZCsQ=;
 b=grlLEyBYPAhZeJfpjeX0z2KZ6wGL9Nf/oIT4TWFmmFOfuTrKSQmi5mEQDuK+v3H3YECcrdMtizxX3LUseHwNw2IKUJQERt9+v1xznykyadPmiGq7M41EJIBYGEh4fxHzqPqLtc7SDFRIzzhvOYBe/hriDyYfshMEwdbDnpAGk0SI19vZP6mY+pHNGB7kcKbpuEBCoy5GtTWii4/GdCZ7op/pTV2shRMCixW1eW34+FuhbzqngpRjtORlCcLvDrHwDSZWAK2GH1on3HHHSjHb71p+YgstMu7d42OQqfOjGobZ7fsKQhffQshigsFSJMoiQL+squHa7jIHAg7pQam5NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQ0f8dP0+kefWP5p59kEZ4SPEu4311HsaabrZhEZCsQ=;
 b=FF+8PbmGkkLqJ1tQ281JK1lksBPMQydmbkDfsDgDmA4sSPMfaCyU4wiTtPW7ufQrYXrAFGxVdiKblwsqJgC7iuXPiogBEVVKeghuN6St2K+tAXP6/0GTrNWz0828Sk3qjYCjPtQddITI4QGsdBTrzS1yq54isSGWeTArupPQol4=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by BL1PR21MB3256.namprd21.prod.outlook.com (2603:10b6:208:398::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Fri, 15 Apr
 2022 03:33:41 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f%9]) with mapi id 15.20.5186.009; Fri, 15 Apr 2022
 03:33:41 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 4/6] hv_sock: Initialize send_buf in
 hvs_stream_enqueue()
Thread-Topic: [RFC PATCH 4/6] hv_sock: Initialize send_buf in
 hvs_stream_enqueue()
Thread-Index: AQHYT3fj0GpxS7gRakKuoVXd9R6gy6zvoDCw
Date:   Fri, 15 Apr 2022 03:33:41 +0000
Message-ID: <PH0PR21MB3025F58A2536209ED3785F24D7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-5-parri.andrea@gmail.com>
In-Reply-To: <20220413204742.5539-5-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=640692ad-7e65-442a-b631-b9c2968ab046;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-14T16:49:10Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 208a2045-1ca0-44e3-555d-08da1e90bcae
x-ms-traffictypediagnostic: BL1PR21MB3256:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BL1PR21MB32561D079A1DEC60CCA245CCD7EE9@BL1PR21MB3256.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qtx2mb9Yr6VT6WGBJ9G1jdFF2VdcDgY/7qmlqHv6oVOYTM2MaUsChWHZCzKC5sLcZwCwH8h53jfRJqyb+bk3AwUDnNENsQsYTCjFNqz2bF0WdzoAJb4l3a5a/rabxSfhcQFgIW0BD3JZdRbB+Mye1LEThl/3uGTNwGXoRnsbWrRxvIIkb/r7/EoJGbfEMyheOUvKvekjGZNXgiLm4oeUUpiQk0TbTe07fx907SBImnqmTuJaRUYYY21dJMFVuu2WlQgkmhgQeWJOj1g7+3pxvRO6GnqOUXczpBViPZ4aAqLK/UVidk++EJKt1DJgiQIaTI49ZlDqiJEAJDs31u90Ya5i+Aul8vs9uzOhla0m3S4d/u+DiIaGJDGkuQfOvE5m/n/+J8bmIKlc2Jah1PXkgvPj5GB2rlU1LalifVOwLZFhd1Rk23fateBWDGW67BKgtGChDNKrVXYq8njIVLSx9O6pVQIg8bj6bTL5nNGF6omKMZZo6+vMhJNfLE23qj53ZWzjxvAhDl8C5lnErtSIBwRpvUSP+wCaAA2R+eGPJnrm5rblUU4v7MSiguPWYHVtBvQLvDEKTYVYkvsl5keSN3ygoVYzDD+vh1zAbZiZBP0aIV6DHlUlYylzeOBZCRUULuWf9vgd2+VnAGqL9SPa7WdilFaFECV7MqnMxdB5r4vLnmMwgkHsVMv8dayuHZ62EUIoZhqv68pnIplpQgh5G7xrdp2Az+GRfpUCzgjyGZPNVRNKhl5x81LkFv37cOcUKLwznS6umVSQjZhb9ghHAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(508600001)(921005)(55016003)(82950400001)(82960400001)(38100700002)(38070700005)(10290500003)(66476007)(7696005)(122000001)(6506007)(316002)(66556008)(66946007)(54906003)(110136005)(71200400001)(76116006)(4326008)(66446008)(64756008)(8676002)(86362001)(52536014)(8990500004)(83380400001)(33656002)(7416002)(5660300002)(8936002)(2906002)(186003)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5l9wPAbWXEEVUnx2eSmK3R+4RSuO6wMgw8lxCdGun1pa8mNfUhwWQyuCwmE/?=
 =?us-ascii?Q?Dx+SYmQXjP8bI2OT3bwung2x7lOrh0vcK3gza4AxB7L3SQg4ZI5uAfGsLW6s?=
 =?us-ascii?Q?HkuOaitw4w4To/8+QsUBgN0FotLFgt0L/AbO91kNUQCW9Jlg3z1/wN8EvqX/?=
 =?us-ascii?Q?N0HgHjWKBelil1Yz4lhV5wurgSLX1K8jGBfQWKDFy9dW8Rfq50joEGvJ6D2q?=
 =?us-ascii?Q?2nGIu41B5rkcH3a0FReSIVrP35e6B4RwjfNlGllptBc3tCgWoP1mrPl8A5GK?=
 =?us-ascii?Q?GBUXs262S94awHekVDREWsGuw/XlNa+MVLGbQQypOY8PXVsAgRIEMvVz/b9s?=
 =?us-ascii?Q?J2qs9lbAKJFL/H04koSaMnU6c2ss5Q4sy73MTqtgxWMnsAlU4enhnbihuLjo?=
 =?us-ascii?Q?hYQU4p2Gdp/iqkNpeHUNlPUrSabz9z1oh8GXrg5Wr/EAzzoTQirvuumSMlk8?=
 =?us-ascii?Q?VRKG7zVnldEio2Yf1q7PC/Tejjqfmaod7CSk5CqD4gv1hOtYYJNpgBVPGx1A?=
 =?us-ascii?Q?nmFa3KCg48YTxuumyBcJ6iHdeZ3GuAowcyjxI63OJCyXYWZy9PVu2RELpgZR?=
 =?us-ascii?Q?i/gGt5ofBp4T/Dj6cvyCGqzVow6q7Q2gjW2+DZQ/5/7SvPOQnnb1Ta6pPivk?=
 =?us-ascii?Q?boGwkEophqetK63V8+p4SAGg+SkuhJPqtkEeSsV22SsmIUXmwuWR+gJSfoWN?=
 =?us-ascii?Q?v5d3vDck7q+Mj0VFBDa8fFx9FTczyJMw8uMw80h4v2dYRlI4EkxH8rA3Xt6J?=
 =?us-ascii?Q?tDjOq7RuIAEiiItxfWYYjVUEmTZFTmTfluWH6ip+wJChNNMoURnsYV33plcl?=
 =?us-ascii?Q?rqB4qH6INEDDz/UIaENL5NAtjlvnomX/LC9tvYlCsE15UZzgwcti1t+SILkj?=
 =?us-ascii?Q?gW6tga6YFAsmMwWwuypWrGdyAaae0uOjIpKFvUw+bUBbNS8JEt6lJ75WFgid?=
 =?us-ascii?Q?Mlv9x0pBei3t80WKmuXTP61N6jnpCyVEi+83+A8y2B1uja23FXFEdGWLzt+i?=
 =?us-ascii?Q?Im1cyiQfmrvrZMHe4b1gTx0DvWIsu609lqbt4A5Vlpop40i3A9/Mk5HiQtne?=
 =?us-ascii?Q?DBLieTx8MI4bMzY+PKSEMMpY328rHahldRkFuEDqK596kbA8x8YHqMH4cxMj?=
 =?us-ascii?Q?d/3xuUgz4+HYE/oLsk4CnfZdZI4RyKN+iuJq3lr8A6gH8600/p4dD7SyfxM6?=
 =?us-ascii?Q?wadCe2TZHAEVQ9RAD1PRSA99yc6F86eyITH37JsTHjPOb7lBv/rfqQosnW+8?=
 =?us-ascii?Q?AAVKQOrICXQaeg/5+lIOiR/khMbCNoVpRxhyp786sKYgNdxh/SxFoIADli7X?=
 =?us-ascii?Q?DZ/VOvfl9ml7WBdY93mqCQIpdM4cWgDn+RhJcKStQ8N+yUJFjy29cNBXEPdD?=
 =?us-ascii?Q?sbKBDM5IVARrur14MIrMKZYfHcKnYTUfnWqYfVev5H2hxtTSSRGZ6PILJSh6?=
 =?us-ascii?Q?Lv09fCNcx+YYaTqTdARr9HM1qRIDGM93vtsEaiotj/Y/W4asuyIPpLTg3DnX?=
 =?us-ascii?Q?guYxsHY3y+MCfs/huASaHadoJEyxDLsbz01QqLmuan5dPjF+Dn4x8/CEVpqD?=
 =?us-ascii?Q?E7GPpJUzW2Cu8bLNNV5lw5aRV/2r3+uehambcNZ3oLIPt2ZCbxSwl43BKR3W?=
 =?us-ascii?Q?1f8f4ok8tLNwJs4MCTNU8vt48goF4u/CliVxrS3oP1O6PL2PO/35fEGmBf4R?=
 =?us-ascii?Q?lYgxvBeuZXk8TgrqdBNadHL9NYjo70Wse+ZdY/Vu9QYmaiZ5DZYuZVAYaXIj?=
 =?us-ascii?Q?r04HshG9PxLoEunjWIYqhT8M1VxkyAU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 208a2045-1ca0-44e3-555d-08da1e90bcae
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 03:33:41.5362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u3stmp/1baFrARQXmReO7U6SqRTqqvlEJ45XW7RP86j6rxPiQZSl9K0dOu0ft35vdASDFGoPtUXst2uM0CEy7jQN6O2xRp/bK3KeJl0V/MY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3256
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, Ap=
ril 13, 2022 1:48 PM
>=20
> So that padding or uninitialized bytes can't leak guest memory contents.
>=20
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
>  net/vmw_vsock/hyperv_transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_tran=
sport.c
> index 092cadc2c866d..72ce00928c8e7 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -655,7 +655,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *=
vsk,
> struct msghdr *msg,
>=20
>  	BUILD_BUG_ON(sizeof(*send_buf) !=3D HV_HYP_PAGE_SIZE);
>=20
> -	send_buf =3D kmalloc(sizeof(*send_buf), GFP_KERNEL);
> +	send_buf =3D kzalloc(sizeof(*send_buf), GFP_KERNEL);

Is this change really needed?   All fields are explicitly initialized, and =
in the data
array, only the populated bytes are copied to the ring buffer.  There shoul=
d not
be any uninitialized values sent to the host.   Zeroing the memory ahead of
time certainly provides an extra protection (particularly against padding b=
ytes,
but there can't be any since the layout of the data is part of the protocol=
 with
Hyper-V).  It is expensive protection to zero out 16K+ bytes every time we =
send
out a small message.

Michael

>  	if (!send_buf)
>  		return -ENOMEM;
>=20
> --
> 2.25.1

