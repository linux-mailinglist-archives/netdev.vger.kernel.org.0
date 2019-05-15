Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCC61F998
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfEORve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:51:34 -0400
Received: from mail-eopbgr750111.outbound.protection.outlook.com ([40.107.75.111]:33639
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726562AbfEORvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 13:51:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=er43JEk2/9GUPCBwz5j2ioKtYB6uVxczDBUvpDe5KNwFoFGUqEQWGKGFpc+OW2RHRTr6gUJXhyUkSHrHQ0L+OQba0PCR0nlqtO/2YfuS8ehuKww5RSjxA5fM8yLyMVPHjuJcGF9SeLPv86mjx8UwYOmF/KQLaGIJ2gCpOr4Ugo8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHZnTmxcFwEtTx5ink6sdQiSj3QkM/THbyP79Fu4E+Q=;
 b=LiaBa2iiJZIseaRZNc4Y1ElXJ5vEPvdxe1nhzmVl/NxBAExCEaY756S22fO8cEcOsAIRXcetQrLh/qZWreEUOzIUYH1vdfLOGKVwqr/l6DiZESqgYaFVPGNnIk365GvTUveHmEs4/3LAOpr7S90GcGbaGTrI5BFivyF8IPmz2LA=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHZnTmxcFwEtTx5ink6sdQiSj3QkM/THbyP79Fu4E+Q=;
 b=cOJKUezBzjgwxarb6HbucRqbf6J58Jdpjfwqm+aHcWOqo9S87ljOBDUn3fuLuPN0DvizyWLxeWDoanjFueb0Dp5eVO0XPj9bCzse0tfcrbSOOy/WSguXJkmEP4bhcMoJ5dSJ9bvaz5WVjhyv2w49PpGGG8zZfd9ZwAveViseOds=
Received: from BYAPR21MB1336.namprd21.prod.outlook.com (2603:10b6:a03:115::18)
 by BYAPR21MB1224.namprd21.prod.outlook.com (2603:10b6:a03:107::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.3; Wed, 15 May
 2019 17:50:25 +0000
Received: from BYAPR21MB1336.namprd21.prod.outlook.com
 ([fe80::d8a5:74b5:c527:f9b2]) by BYAPR21MB1336.namprd21.prod.outlook.com
 ([fe80::d8a5:74b5:c527:f9b2%3]) with mapi id 15.20.1922.002; Wed, 15 May 2019
 17:50:25 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: RE: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
Thread-Topic: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
Thread-Index: AQHVCvSxPa1tDZX3c0upfd5eitLuyKZsddLg
Date:   Wed, 15 May 2019 17:50:25 +0000
Message-ID: <BYAPR21MB133640B374769CDF84685C03CA090@BYAPR21MB1336.namprd21.prod.outlook.com>
References: <20190515080319.15514-1-sthemmin@microsoft.com>
 <20190515080319.15514-2-sthemmin@microsoft.com>
In-Reply-To: <20190515080319.15514-2-sthemmin@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-15T17:50:23.5861265Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b4c7bad0-59a6-4f8c-b525-7cc3b27894c1;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f7a0905-e9ed-4742-c2ae-08d6d95dcfb8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BYAPR21MB1224;
x-ms-traffictypediagnostic: BYAPR21MB1224:
x-microsoft-antispam-prvs: <BYAPR21MB1224ACD33A4C9230A31CF186CA090@BYAPR21MB1224.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(346002)(376002)(136003)(396003)(13464003)(199004)(189003)(110136005)(54906003)(25786009)(76176011)(99286004)(74316002)(33656002)(52396003)(2906002)(68736007)(229853002)(53936002)(316002)(22452003)(6116002)(256004)(8990500004)(14444005)(7696005)(3846002)(6436002)(7736002)(305945005)(9686003)(81166006)(71190400001)(71200400001)(81156014)(4326008)(8936002)(66066001)(107886003)(6246003)(55016002)(1511001)(8676002)(446003)(486006)(11346002)(102836004)(186003)(476003)(10290500003)(10090500001)(53546011)(5660300002)(6506007)(76116006)(86612001)(66476007)(66556008)(64756008)(66446008)(66946007)(86362001)(73956011)(2501003)(26005)(478600001)(52536014)(14454004)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR21MB1224;H:BYAPR21MB1336.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HuYO+OWfutbN1e3kLauY6ApWepZuuwwCS2Ghi3TvtuKTO57ibBRGFMPK/LUBpnYh/DKIC0PGnAXM+cwaSn1x/gaFv8uijO/5zyLWM7FIO5piETaiucmgMpYgS7GOR/S4p+B76cWOF8ZO63mSvGlaxHIrf5WepHaimhaElWaHZmYGXTWdS+vOVt3f3EsLr5NKPC20oh+Z1D58Gs9dff0jcmBXgZp9ytc9ctht6mG3NkGhqCGXwODr4WvukYmOZASAppT6ZXiZFvr3nsmqiGrLvDFfpN8r/3FzqeQ00BGYk9jzZ/yslzdLemvnjcOtDBRMQ3NDtUk8br8NWecr9xfn4dWXvA2uCEyxhPPmi/4aYbNYTtoiY2/ZjYc5ht9asxnCyBW8KQBSi57Vp/bVCMDJ8ecc/BASgCzc5FVnM+CgpZI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7a0905-e9ed-4742-c2ae-08d6d95dcfb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 17:50:25.7610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haiyangz@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1224
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Wednesday, May 15, 2019 4:03 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; davem@davemloft.net
> Cc: netdev@vger.kernel.org; Stephen Hemminger <sthemmin@microsoft.com>
> Subject: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
>=20
> XDP generic does not work correctly with the Hyper-V/Azure netvsc device
> because of packet processing order. Only packets on the synthetic path ge=
t
> seen by the XDP program. The VF device packets are not seen.
>=20
> By the time the packets that arrive on the VF are handled by netvsc after=
 the
> first pass of XDP generic (on the VF) has already been done.
>=20
> A fix for the netvsc device is to do this in the VF packet handler.
> by directly calling do_xdp_generic() if XDP program is present on the par=
ent
> device.
>=20
> A riskier but maybe better alternative would be to do this netdev core co=
de
> after the receive handler is invoked (if RX_HANDLER_ANOTHER is returned).
>=20
> Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_=
drv.c
> index 06393b215102..bb0fc1869bde 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -1999,9 +1999,15 @@ static rx_handler_result_t
> netvsc_vf_handle_frame(struct sk_buff **pskb)
>  	struct net_device_context *ndev_ctx =3D netdev_priv(ndev);
>  	struct netvsc_vf_pcpu_stats *pcpu_stats
>  		 =3D this_cpu_ptr(ndev_ctx->vf_stats);
> +	struct bpf_prog *xdp_prog;
>=20
>  	skb->dev =3D ndev;
>=20
> +	xdp_prog =3D rcu_dereference(ndev->xdp_prog);
> +	if (xdp_prog &&
> +	    do_xdp_generic(xdp_prog, skb) !=3D XDP_PASS)
> +		return RX_HANDLER_CONSUMED;

Looks fine overall.

The function do_xdp_generic() already checks NULL on xdp_prog,
so we don't need to check it in our code.=20

int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
{
        if (xdp_prog) {

Thanks,
- Haiyang
