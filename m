Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44AF0F0A2
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfD3Gkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:40:43 -0400
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:20708
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbfD3Gkn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgvwS1AmHxskoF3cgI8434Dov5fv3kJ1oJd+XHRNwZ4=;
 b=kRPymRd9RuUP5HudMLIueKsPOynfgntoSAQfqL/SLG6QiNW6O9A0fjPlG+bej1zEJepJjeIWTCzWn93h9d5bFKA9+jgBbCCY5FlCjFXH3kEb63te1q1R9nIP6cxM5725yoD6JC2IcBLdOoBuseW3x29m8aUwaX/Bgxsh570wbuk=
Received: from AM0PR05MB6497.eurprd05.prod.outlook.com (20.179.34.15) by
 AM0PR05MB5346.eurprd05.prod.outlook.com (20.178.19.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Tue, 30 Apr 2019 06:40:36 +0000
Received: from AM0PR05MB6497.eurprd05.prod.outlook.com
 ([fe80::151:4fc5:f798:6ef1]) by AM0PR05MB6497.eurprd05.prod.outlook.com
 ([fe80::151:4fc5:f798:6ef1%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 06:40:35 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v3 net-next 1/3] ipv4: Move cached routes to fib_nh_common
Thread-Topic: [PATCH v3 net-next 1/3] ipv4: Move cached routes to
 fib_nh_common
Thread-Index: AQHU/qbBJ/rDaOIUHU+SKswK5TrlBaZUQeqA
Date:   Tue, 30 Apr 2019 06:40:35 +0000
Message-ID: <20190430064033.GA20104@splinter>
References: <20190429161619.23671-1-dsahern@kernel.org>
 <20190429161619.23671-2-dsahern@kernel.org>
In-Reply-To: <20190429161619.23671-2-dsahern@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0201CA0006.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::16) To AM0PR05MB6497.eurprd05.prod.outlook.com
 (2603:10a6:208:13f::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64ef4d1b-4468-4c5e-fcb2-08d6cd36c032
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5346;
x-ms-traffictypediagnostic: AM0PR05MB5346:
x-microsoft-antispam-prvs: <AM0PR05MB5346A8C0754FA1E4390BA26DBF3A0@AM0PR05MB5346.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(136003)(346002)(396003)(39860400002)(376002)(189003)(199004)(102836004)(14444005)(6486002)(256004)(26005)(486006)(476003)(11346002)(386003)(6506007)(7736002)(76176011)(446003)(3846002)(6116002)(305945005)(2906002)(229853002)(6916009)(6436002)(33656002)(8936002)(33716001)(478600001)(81166006)(8676002)(14454004)(5660300002)(186003)(81156014)(68736007)(25786009)(66066001)(97736004)(66946007)(1076003)(4326008)(64756008)(54906003)(71190400001)(99286004)(316002)(52116002)(6246003)(53936002)(6512007)(66476007)(66556008)(66446008)(71200400001)(73956011)(86362001)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5346;H:AM0PR05MB6497.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xVulaoDv/UzwzArrS14A5s4aTrAVL4uBolF4M/0sJAYE8AtIlWhNqXnuqVIuS8yG88GRXaHvUyoleYa6Sr2TyG5kA8ngWo1k5uXGJf6MKGXIr4CzE4q1E0iC+HLsys2tGq2+lHW9gmfYmTZD1uoguSF8Xjt2x2mNY7xPmMxCEi3/1jwSq7N6RUdHFsOBdRhFuRf+20v4Pisd/7V0hL8CLxeRP/UNb0g4AIyzLKmIEv5kdsj+GkmpxHFw8bKqtdFDTsv5IT/aPtmh6wiiBWgBnk0bdyi98OIlihcpKvmMdhueerNebKM12gtI6saEI4JxJ000QauRYdRJn8YqSeuQhlTlnGykkYJWcxnP9+sgsCvVWBZL42h6exLn1sYW9orKMam0fjJtlrhsI/16vyQY1jyOvUr9qdR/ctWs+9JZCQQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8339DF5A1CBFCA4588DE6641C4DA6D0E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ef4d1b-4468-4c5e-fcb2-08d6cd36c032
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 06:40:35.9037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5346
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 09:16:17AM -0700, David Ahern wrote:
>  /* Release a nexthop info record */
> @@ -491,9 +491,15 @@ int fib_nh_common_init(struct fib_nh_common *nhc, st=
ruct nlattr *encap,
>  		       u16 encap_type, void *cfg, gfp_t gfp_flags,
>  		       struct netlink_ext_ack *extack)
>  {
> +	int err;
> +
> +	nhc->nhc_pcpu_rth_output =3D alloc_percpu_gfp(struct rtable __rcu *,
> +						    gfp_flags);
> +	if (!nhc->nhc_pcpu_rth_output)
> +		return -ENOMEM;
> +
>  	if (encap) {
>  		struct lwtunnel_state *lwtstate;
> -		int err;
> =20
>  		if (encap_type =3D=3D LWTUNNEL_ENCAP_NONE) {
>  			NL_SET_ERR_MSG(extack, "LWT encap type not specified");

Failure here will leak 'nhc->nhc_pcpu_rth_output'

> @@ -502,12 +508,17 @@ int fib_nh_common_init(struct fib_nh_common *nhc, s=
truct nlattr *encap,
>  		err =3D lwtunnel_build_state(encap_type, encap, nhc->nhc_family,
>  					   cfg, &lwtstate, extack);
>  		if (err)
> -			return err;
> +			goto lwt_failure;
> =20
>  		nhc->nhc_lwtstate =3D lwtstate_get(lwtstate);
>  	}
> =20
>  	return 0;
> +
> +lwt_failure:
> +	rt_fibinfo_free_cpus(nhc->nhc_pcpu_rth_output);
> +	nhc->nhc_pcpu_rth_output =3D NULL;
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(fib_nh_common_init);
> =20
> @@ -515,18 +526,14 @@ int fib_nh_init(struct net *net, struct fib_nh *nh,
>  		struct fib_config *cfg, int nh_weight,
>  		struct netlink_ext_ack *extack)
>  {
> -	int err =3D -ENOMEM;
> +	int err;
> =20
>  	nh->fib_nh_family =3D AF_INET;
> =20
> -	nh->nh_pcpu_rth_output =3D alloc_percpu(struct rtable __rcu *);
> -	if (!nh->nh_pcpu_rth_output)
> -		goto err_out;
> -
>  	err =3D fib_nh_common_init(&nh->nh_common, cfg->fc_encap,
>  				 cfg->fc_encap_type, cfg, GFP_KERNEL, extack);
>  	if (err)
> -		goto init_failure;
> +		return err;
> =20
>  	nh->fib_nh_oif =3D cfg->fc_oif;
>  	nh->fib_nh_gw_family =3D cfg->fc_gw_family;
> @@ -546,12 +553,6 @@ int fib_nh_init(struct net *net, struct fib_nh *nh,
>  	nh->fib_nh_weight =3D nh_weight;
>  #endif
>  	return 0;
> -
> -init_failure:
> -	rt_fibinfo_free_cpus(nh->nh_pcpu_rth_output);
> -	nh->nh_pcpu_rth_output =3D NULL;
> -err_out:
> -	return err;
>  }
