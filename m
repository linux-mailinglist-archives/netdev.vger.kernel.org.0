Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFB71F9A4
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfEOR5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:57:07 -0400
Received: from mail-eopbgr770095.outbound.protection.outlook.com ([40.107.77.95]:4762
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbfEOR5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 13:57:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=t3wIvKhkv9eJ1rpa9bt/luEJpPsdSp6A7ZXbGg3SB8NZZNy/4RP0b65yewkj+rx5Bl1rzHWkwZFUj7TXPUlo33r8n1Kam06JRk4Hq2dRA5Yjd4rCstSPRE9XpLU7Ueo/NAaJfYp8ncDxED2N/yIzgkKNqhJFRuREU0Try17vOSw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ef4P6pzQOpNQXloGuF6Ndhg1TNnNKhrC0Rm352yidE=;
 b=Zpgmnygb3IijdKtnw7sp8vO291bHXfrbkEkm7lmSEEi7WtTc7YC5zBRV8FY2OQYy1ihoQVTjXF6ocqsOERNtQaEl+J8VewG5MBWeHM/OKn+JMCM6LDm9scQusmqhujWBHqJfQ6Us+AkvogHO/CKAIJprn4JjUAnRYCfy1kaZlGE=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ef4P6pzQOpNQXloGuF6Ndhg1TNnNKhrC0Rm352yidE=;
 b=D0eAwtXJb4YsMw3l04cO1/PEMVSsc8AWKqY/nNopv+5Y4KRJZ5JhLIh9HKIihdlSkHX2xUjJDwylKCQHX9mNwektwm+uN3H+97SQsG6tdhHrDSRmJhO4xg+j0tUcV436ZTSjADklQui03YT5DjSzv4kNkDbaBImEqCXU/cyGr4w=
Received: from BYAPR21MB1336.namprd21.prod.outlook.com (2603:10b6:a03:115::18)
 by BYAPR21MB1174.namprd21.prod.outlook.com (2603:10b6:a03:104::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.6; Wed, 15 May
 2019 17:57:04 +0000
Received: from BYAPR21MB1336.namprd21.prod.outlook.com
 ([fe80::d8a5:74b5:c527:f9b2]) by BYAPR21MB1336.namprd21.prod.outlook.com
 ([fe80::d8a5:74b5:c527:f9b2%3]) with mapi id 15.20.1922.002; Wed, 15 May 2019
 17:57:04 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: RE: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
Thread-Topic: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
Thread-Index: AQHVCvSxPa1tDZX3c0upfd5eitLuyKZsddLggAACegCAAACZwA==
Date:   Wed, 15 May 2019 17:57:03 +0000
Message-ID: <BYAPR21MB133676EA954F27FED27D34FACA090@BYAPR21MB1336.namprd21.prod.outlook.com>
References: <20190515080319.15514-1-sthemmin@microsoft.com>
        <20190515080319.15514-2-sthemmin@microsoft.com>
        <BYAPR21MB133640B374769CDF84685C03CA090@BYAPR21MB1336.namprd21.prod.outlook.com>
 <20190515105330.4b955e7d@hermes.lan>
In-Reply-To: <20190515105330.4b955e7d@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-15T17:57:02.6839821Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6d337ef3-c908-41ed-b36c-9e01ce247f4e;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 902f7749-3943-41ca-38f4-08d6d95ebd14
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BYAPR21MB1174;
x-ms-traffictypediagnostic: BYAPR21MB1174:
x-microsoft-antispam-prvs: <BYAPR21MB117486DC4137E9F1E38DCD0ECA090@BYAPR21MB1174.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(366004)(376002)(346002)(189003)(199004)(13464003)(51914003)(52536014)(316002)(6246003)(53936002)(8676002)(54906003)(4326008)(6436002)(68736007)(10090500001)(33656002)(14444005)(52396003)(74316002)(55016002)(256004)(7696005)(22452003)(107886003)(486006)(76176011)(26005)(73956011)(86362001)(76116006)(25786009)(9686003)(186003)(71190400001)(8990500004)(66946007)(8936002)(6506007)(66556008)(66476007)(476003)(64756008)(229853002)(6916009)(86612001)(478600001)(66446008)(11346002)(53546011)(66066001)(10290500003)(2906002)(102836004)(81156014)(81166006)(7736002)(305945005)(71200400001)(14454004)(6116002)(446003)(99286004)(5660300002)(3846002)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR21MB1174;H:BYAPR21MB1336.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DoHtrVUPd1AgM3Zb4P+pkvY8zGKfNK8qhhimvZ4yhMmmBd/Xwz5srCsveQrdTS8iU/vcoJHEYIvHP5JR5+6lZWAdZukXRjWSfuXj86omvZpEJVlK9QPIzs71Rns0zL89+Qvz8M+ISqoUT+TecbHEeCAsWOJKJP4U+c/TP9QVkqvmfMNXQERuQ46bbAzDmdbF8TgDcv7EM1kjIBYakFDbIY8Oibki3oBDciJ+8AQ+Ky5ujVJoeUwTr5zCvVnWBsGnbKTPBMizUSyGnA4qHmRuql/S1w4vF5J5jGf7N9wvTgIoGXYZVi/mV0V8lGLEF8yRWGtUTMNBpvjiDcWfDVvFn40PGDqxIa6j+rxdY/NPQPKVWonPmBwmFv//gSqF869uPWyIAuaM9JlHiM12xaGc7EvWq7AL9ModaWNeX6FeQf8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 902f7749-3943-41ca-38f4-08d6d95ebd14
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 17:57:04.0194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haiyangz@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1174
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Wednesday, May 15, 2019 1:54 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; davem@davemloft.net;
> netdev@vger.kernel.org; Stephen Hemminger <sthemmin@microsoft.com>
> Subject: Re: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
>=20
> On Wed, 15 May 2019 17:50:25 +0000
> Haiyang Zhang <haiyangz@microsoft.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Stephen Hemminger <stephen@networkplumber.org>
> > > Sent: Wednesday, May 15, 2019 4:03 AM
> > > To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > > <haiyangz@microsoft.com>; davem@davemloft.net
> > > Cc: netdev@vger.kernel.org; Stephen Hemminger
> <sthemmin@microsoft.com>
> > > Subject: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
> > >
> > > XDP generic does not work correctly with the Hyper-V/Azure netvsc dev=
ice
> > > because of packet processing order. Only packets on the synthetic pat=
h get
> > > seen by the XDP program. The VF device packets are not seen.
> > >
> > > By the time the packets that arrive on the VF are handled by netvsc a=
fter
> the
> > > first pass of XDP generic (on the VF) has already been done.
> > >
> > > A fix for the netvsc device is to do this in the VF packet handler.
> > > by directly calling do_xdp_generic() if XDP program is present on the
> parent
> > > device.
> > >
> > > A riskier but maybe better alternative would be to do this netdev cor=
e code
> > > after the receive handler is invoked (if RX_HANDLER_ANOTHER is return=
ed).
> > >
> > > Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
> > > Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> > > ---
> > >  drivers/net/hyperv/netvsc_drv.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> > > index 06393b215102..bb0fc1869bde 100644
> > > --- a/drivers/net/hyperv/netvsc_drv.c
> > > +++ b/drivers/net/hyperv/netvsc_drv.c
> > > @@ -1999,9 +1999,15 @@ static rx_handler_result_t
> > > netvsc_vf_handle_frame(struct sk_buff **pskb)
> > >  	struct net_device_context *ndev_ctx =3D netdev_priv(ndev);
> > >  	struct netvsc_vf_pcpu_stats *pcpu_stats
> > >  		 =3D this_cpu_ptr(ndev_ctx->vf_stats);
> > > +	struct bpf_prog *xdp_prog;
> > >
> > >  	skb->dev =3D ndev;
> > >
> > > +	xdp_prog =3D rcu_dereference(ndev->xdp_prog);
> > > +	if (xdp_prog &&
> > > +	    do_xdp_generic(xdp_prog, skb) !=3D XDP_PASS)
> > > +		return RX_HANDLER_CONSUMED;
> >
> > Looks fine overall.
> >
> > The function do_xdp_generic() already checks NULL on xdp_prog,
> > so we don't need to check it in our code.
> >
> > int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
> > {
> >         if (xdp_prog) {
> >
>=20
> The null check in the netvsc code was just an minor optimization
> to avoid unnecessary function call in fast path.

Thanks for the explanation.

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
