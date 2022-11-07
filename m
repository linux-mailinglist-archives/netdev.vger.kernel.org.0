Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333FA61EF7B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiKGJq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiKGJqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:46:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2097.outbound.protection.outlook.com [40.107.94.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A303C55AC
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 01:46:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YP31ZIISXmL0x2GDOc27gLZ65mIQIY1lXIBj9Wm19GRm3NXUqYiPBYgOJQGC1pB5idrJc1A5xOB4pTiN7lSGqTwOwr1IISSd4tiBQgJ36Mx14CJYvdM1kGeArxZPvvTPmQfHFQn/ijy6S6doeOyvqmo0A7OPCbe+LkzO2HIr7ie4fe84DrHIsMY4V1VOsDIeM4Wl3GxYttmWc+5k/jVlw4cBeG3YsjRx07tqObUfcKHbEO/oW4k2ee9erAUoBwFvD4o7zUyA5+V3aQJyyun4vCrVv9y6ka27Sj4tFdbNot+lVJENyfD7s8csXEgiLuURXS3D0yeIKgOdYuetUOSfrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QT0K8DIe+W3Bf81AqDIgZCCnL2UDxoNfmXZVOpX+NVA=;
 b=EV2ozPXJjHxxgkjwZDuork73H3aUC/zg77pdXnahwN49eKmGNFgHqTP14o1VQcqSJU48kPgTWibXBHuhFFdGkpR/77etKTpMCBcm5iq1sc3+orFmsMkaG8fZTpezybJMn4jRcu8t3IBEOBQJ4nhOSV3CammUFDjG5ATVttuulaZF1Y6xAPxeW8OIu04pOwMS1++ef94S7p085JicYa0p4i0hFF9v8DaK8D5j4apQeC/gVGXIEXk9jQdgP/w7hTTliIF2E8yzfwb4RG+BsKTjOIfeAWa7aem0+Z0s1U3qke7KDTU22L4fEId9evJp2XDAvDfgNXBjSRHbwUAkeRzsaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QT0K8DIe+W3Bf81AqDIgZCCnL2UDxoNfmXZVOpX+NVA=;
 b=DFxL3zbcgVneMVR+6HenZS0ewCfLACHLbcuKdx8ZfUeE7BOJPPlEc+3yzNIZc4wcMv0RNUBhguVDJCAQkCmFk9aI27AHFUc/ifRap4hj3hmALb6EGoK8J4TICExYiyrebWwvw0idWuejd1ajGLNenaxZuzqhUGn4/V6PwdvJSgw=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH0PR13MB5807.namprd13.prod.outlook.com (2603:10b6:510:11e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 7 Nov
 2022 09:46:46 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%9]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 09:46:46 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chengtian Liu <chengtian.liu@corigine.com>,
        HuanHuan Wang <huanhuan.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Topic: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Index: AQHY7eGMPasXy6hiXkqW0Y9zNHZbuK4zBIsAgAA10pA=
Date:   Mon, 7 Nov 2022 09:46:46 +0000
Message-ID: <DM6PR13MB3705DADE119F1895CA27EF9DFC3C9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com> <Y2iiNMxr3IeDgIaA@unreal>
In-Reply-To: <Y2iiNMxr3IeDgIaA@unreal>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|PH0PR13MB5807:EE_
x-ms-office365-filtering-correlation-id: dd402081-48ea-464a-851d-08dac0a4fc10
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lF2ehcWwrBw+WpZdWHZk1JH994SW57f3g/Cyn7h81axzffKl/hSvzHFvfGoMfgQ4nNKbdLghamcgOJVxtZLwxiC0oNjibWLFXhGZ3jd/63tmT5Ev+qdDdpiIQJiIKj1udDAyJNAvF4bWuVHbpP2AKJgIDq20UyP4tY7cShLAreEnV5iPQIENFLu8u2IMZBt6CWADpaXaH1MibGe3u+8CbwhPjbG9huvdO8JhwMiTYNxlAJB4EtzXi2QJU6WX6l2O5IG8/AUx02j57zuzOKHD31JsDbj+q/U/2MOCwB5IR/QdLol2JuukpAPY34JtM/ME/NHxgKNxB/IuZ0pSyheJx2xLh4WZwPZu4H0VW8oYBXy3XusfToQCAOUvmfN9ICjxIH6fEgSLbm8qDTnuYsAkjT66WN9L5Rek+oW/6p5ks6z7ZF1DUE/JJtQX3NhoA70aJrqy/nW2HAnzyDrXVTI0F80c+1gUrUPpmyrc23M4/ns85x3fGLpRZsb3RShEffayhQSSuBEG4OHIh3jYYResJVfl2h44LqkucISQhIgcNDl1hJWtavGGGd1Guj3SorZO67ciUAUCFZo9EG2sxCZ3f2hQ1pT8to7TajrhVLARsKtiA0CId+KjcMz2JMFUASAxeel43f4TmXmABddqVvPYt9ONNY7QfWPwTkg3o3qChOgAgwOafNWdph7Tbmu6eYQlJeHBXgN2Q3WSqpJmkw1W09G2gRQLLVlsEn3SvMy7Ci/horA/jAIm+semZsvK4BraxyYnecbfY1zLCmpXj2GYEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(346002)(136003)(39830400003)(451199015)(4326008)(8676002)(33656002)(54906003)(6916009)(44832011)(41300700001)(186003)(66446008)(66556008)(66476007)(64756008)(38100700002)(107886003)(5660300002)(66946007)(71200400001)(122000001)(76116006)(86362001)(478600001)(6506007)(7696005)(38070700005)(9686003)(2906002)(8936002)(52536014)(55016003)(83380400001)(316002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?L/yZ36IdT7fLlkI40tA6R/X6S6UqcdZknMF1E0QSR3LSkOMQ7By9O9n0OrAy?=
 =?us-ascii?Q?IpNAyuqDkK5cSUj0rs644r2lDBMF6IxDpyp8vbj0PFUNAflR8oWsR2AtcpXQ?=
 =?us-ascii?Q?D+QmC+DVOw8S/yUWFnVM3J+Hm+VqsAjVcsbqaMZgfxTX0lKybXNVZB56sKyF?=
 =?us-ascii?Q?VchBN2aW+KpO339pwjeEnyjfg5D2WonHnON0SzO9v/Bou9/ntxnZwlc/7uRu?=
 =?us-ascii?Q?PWvGQCAXwpqRC8XAc9LqTVsIJl7DEYd94+IoZhRJLHHwgPbYB66Q4J6jlpi3?=
 =?us-ascii?Q?GuWNrtuNRSah+AZmC0Zadpju4yIloo/BsSHrkrmKhC2rAG0tRLFfsxTkQXgH?=
 =?us-ascii?Q?ilw5SGm67bT6XSJSgOd4jg8dUUbnNzK9rwVry7bDZ3o2u7lMndb9nhHfKut8?=
 =?us-ascii?Q?USOSeOlziFH82+WaEaFkC8gdZ/jPOWIfmFlrSsTeyzdCxbGSCWBHXItHByIr?=
 =?us-ascii?Q?w+irbRDi8WQpCnKR9Cuegr2riOPPWs4OZ5zYgsWBxKWtu1nUU4TVl8V9hp4f?=
 =?us-ascii?Q?7V/4vHsVv0k3IvwSB7D7+fqK1mFqdLZ4vc4sxEQEJ1UlHKtnmqSMDjCT8IlL?=
 =?us-ascii?Q?/LtFBIeZHYy4kgvZAJ/DG1sxeUtQMwHE4kRGarE456KP4sbQ8sO2mgFlCmPQ?=
 =?us-ascii?Q?U1I9ekIT6vB4hEfgsBUD1nYKQv3FwCAXxV7GDK9r9tuhbE1codNcFfiv9yOD?=
 =?us-ascii?Q?spS4GCktAuPp1ralIDeIAK0hZ8XVXXI7IDjhK7N2vmbhuI7ovDRypDjL1VuA?=
 =?us-ascii?Q?4tZVDb0eJuwcldvrCqTINPwtRuuvM7XvBj5OSZbqrTm0A675Gd8xRFyHD+Ye?=
 =?us-ascii?Q?xSSZmswidWQygi8ns4FXoGhOPuPHj60atM8MsxHDTJS/g5doPpCXebrvQPo3?=
 =?us-ascii?Q?ZR26csRGDR+3QE0XRuJywj/NI54NSLan8VEUUf1MhuW0HLAjMirBWxqMHI7d?=
 =?us-ascii?Q?AspgOquUGToHu5oERNqRF2FZxraUJID9ATrwJlydQH82uUO/xZwAJtiUs0gi?=
 =?us-ascii?Q?X7UNJC3SCur6RViXZSE78vI7wf8GaowwePt5KnU4q+eQtDLgCUB5ZGgMKINa?=
 =?us-ascii?Q?lxAeSqUMiXh9PQ83hFuE8rpTdQYFuixQLMRhJLmAFpFuzPl6oIOelXAgqbKM?=
 =?us-ascii?Q?vvyhUsk6xMflw3v1+9ceAWUMbQGAn6KhhMh6eSt3Rd+ZRiR/G7ASjAxgKzJw?=
 =?us-ascii?Q?amiThpILJJtYzaqfS02joDoP6V5F5TWYnYqm/h8f5vgKYgt9R7IbpIwyImO2?=
 =?us-ascii?Q?WHaothEYFU/icqZNCz7M+AvRyqjuZVviCWZXLKDVgJU9gEv5DD/OvyTsOugV?=
 =?us-ascii?Q?F77Bnl63lmtVXHtpvSzkOIico0ylPFHUasJ4rjLAl4OyflydunG1DkIeBVSf?=
 =?us-ascii?Q?1QEc4a0pQmNxTTBNk88NW2OxMVFCKl0Ll16ic3RraV+e+Hv0K+7IFB0jPfBx?=
 =?us-ascii?Q?eE/q/fZuVKgQT4hYGD7GKvMUzUlJF1+mBbAxAVW3GQqy8XV+VnGyxa0lAdTP?=
 =?us-ascii?Q?sHG8N/x+OAKsWb3pvD/ybVKsbxccdkEJH0CLkpV4Cxl4MQHnFEm/Lw6pLCf7?=
 =?us-ascii?Q?tYZVxcwe2glugvSK+IQhRcfiZyXjYWGpZAfC2UkU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd402081-48ea-464a-851d-08dac0a4fc10
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 09:46:46.2300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: flFNDRNX6kLBBpHy0EpvNX59vcPQifIyy8+lLHOKDTo8J8qOXeeeyw+9t/WZXLqtkZvFuDDiXEkZnuJVRT5bbo9LzOa1Io1cpn+VsVl1X88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5807
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Nov 2022 08:14:12 +0200, Leon Romanovsky wrote:
 <...>
> > +	struct sa_ctrl_word {
> > +		uint32_t hash   :4;	  /* From nfp_ipsec_sa_hash_type */
> > +		uint32_t cimode :4;	  /* From nfp_ipsec_sa_cipher_mode */
> > +		uint32_t cipher :4;	  /* From nfp_ipsec_sa_cipher */
> > +		uint32_t mode   :2;	  /* From nfp_ipsec_sa_mode */
> > +		uint32_t proto  :2;	  /* From nfp_ipsec_sa_prot */
> > +		uint32_t dir :1;	  /* SA direction */
> > +		uint32_t ena_arw:1;	  /* Anti-Replay Window */
> > +		uint32_t ext_seq:1;	  /* 64-bit Sequence Num */
> > +		uint32_t ext_arw:1;	  /* 64b Anti-Replay Window */
> > +		uint32_t spare2 :9;	  /* Must be set to 0 */
> > +		uint32_t encap_dsbl:1;	  /* Encap/Decap disable */
> > +		uint32_t gen_seq:1;	  /* Firmware Generate Seq */
> > +		uint32_t spare8 :1;	  /* Must be set to 0 */
> > +	} ctrl_word;
> > +	u32 spi;			  /* SPI Value */
> > +	uint32_t pmtu_limit :16;	  /* PMTU Limit */
> > +	uint32_t spare3     :1;
> > +	uint32_t frag_check :1;		  /* Stateful fragment checking flag */
> > +	uint32_t bypass_DSCP:1;		  /* Bypass DSCP Flag */
> > +	uint32_t df_ctrl    :2;		  /* DF Control bits */
> > +	uint32_t ipv6       :1;		  /* Outbound IPv6 addr format */
> > +	uint32_t udp_enable :1;		  /* Add/Remove UDP header for NAT */
> > +	uint32_t tfc_enable :1;		  /* Traffic Flow Confidentiality */
> > +	uint32_t spare4	 :8;
> > +	u32 soft_lifetime_byte_count;
> > +	u32 hard_lifetime_byte_count;
>=20
> These fields are not relevant for IPsec crypto offload. I would be more
> than happy to see only used fields here.

They are not used currently in kernel indeed. However the HW is not designe=
d for=20
crypto-offloading only, not for kernel only, some extensive features are su=
pported.=20
So they're reserved here.

<...>
> > +
> > +	/* General */
> > +	switch (x->props.mode) {
> > +	case XFRM_MODE_TUNNEL:
> > +		cfg->ctrl_word.mode =3D NFP_IPSEC_PROTMODE_TUNNEL;
> > +		break;
> > +	case XFRM_MODE_TRANSPORT:
> > +		cfg->ctrl_word.mode =3D NFP_IPSEC_PROTMODE_TRANSPORT;
> > +		break;
>=20
> Why is it important for IPsec crypto? The HW logic must be the same for
> all modes. There are no differences between transport and tunnel.

As I mentioned above, it's differentiated in HW to support more features.

>=20
> > +	default:
> > +		nn_err(nn, "Unsupported mode for xfrm offload\n");
>=20
> There are no other modes.
>=20

<...>
>=20
> > +	err =3D xa_alloc(&nn->xa_ipsec, &saidx, x,
> > +		       XA_LIMIT(0, NFP_NET_IPSEC_MAX_SA_CNT - 1),
> GFP_KERNEL);
>=20
> Create XArray with XA_FLAGS_ALLOC1, it will cause to xarray skip 0.
> See DEFINE_XARRAY_ALLOC1() for more info.

Actually 0 is a valid SA id in HW/driver, we don't want to skip 0.

>=20
>=20
> > +	if (err < 0) {
> > +		nn_err(nn, "Unable to get sa_data number for IPsec\n");
> > +		return err;
> > +	}
> > +
> > +	/* Allocate saidx and commit the SA */
> > +	err =3D nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_ADD_SA,
> saidx, &msg);
> > +	if (err) {
> > +		xa_erase(&nn->xa_ipsec, saidx);
> > +		nn_err(nn, "Failed to issue IPsec command err ret=3D%d\n",
> err);
> > +		return err;
> > +	}
> > +
> > +	/* 0 is invalid offload_handle for kernel */
> > +	x->xso.offload_handle =3D saidx + 1;
>=20
> If you create XArray as I said above, you won't need to add +1.
>=20

