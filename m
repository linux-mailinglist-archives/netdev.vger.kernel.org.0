Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811555E731C
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 06:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiIWEwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 00:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiIWEwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 00:52:15 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20707.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::707])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110BD1257B9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 21:52:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3Qk09FfSbISqM0UZRM9u0Hcg0kuauiwEjo7YbGqULZXI5WJ31H7z7BgzNm6W4T8pDUSRyJOoP+IUA+J7XkD0nIVih2LDEKXHJaNr090rqAwhqsEODTcyn0eFU/3+ir0QowKSZ/QPFiQ9Bx5XlG3Ef9+QGHMmeZkPU8TRvW2bnQZbxDbwPD8qLgjeTv5tkTQDvIr4B3GYpvg9I9VhWhXh0eTD9oQSMGf6D2qRTNbR74WiqQ1sFhZ9jpD1xR/ZfvV0FmM/5C8eCbAPnH/U6aTTvxQK4QjhK9g215DXUNNnULK/5LbuNKzPCVhSNay5yDyjz3x3idBJNLex9gGx9UnSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2p218iDzmRvRdQjDoKQNeuNRBtcSI0UiQsgAnfdLzs=;
 b=IPRcFO19ZDxYqmWH+RbY5FP6bre8QjrI6sg3837TMwih310BpKXpFPQid0z+HxbEQgy5/oFWthohsCtZsYPOkjvzie/Ckm9kyRV8wAg7tTFLwFPVZM5vW3tWjl26fiXcOelpLyFTFhGEVhcCbfwxkcvsJa19BTEunpsZ7CV8g25yj0zaMIt5W7t2IoCwaw0YldaqJ01aUrqGq7oGHd9QCm57we7k16S7h8ulJjOHlFG6H2dHwzs+EmLkbVIgYrbjEeuONQ5ggOZmnIaXt+1zi6zvMciVoJswfsSd239tVLgTpWtx0wW2KEnLdDLA4t6sS1e3djj3mvqcgQ3Jtp9cNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2p218iDzmRvRdQjDoKQNeuNRBtcSI0UiQsgAnfdLzs=;
 b=dVDMNK9esaxURtcBPrArOwO4VQ7Gvgm79mgibXtpUNSketVSDKVbzOdABkpPn/AL/hyed4UJN4dqMcdQ1SzlHHS0NiLAMvdxoEEgfiS6TQYeDowtYkkT9QqZFeOKOK+TChq1Q96CTfNP3JkaLpmxRHCWdJuZX5eUomkW4hlzJDU=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by MN2PR13MB3944.namprd13.prod.outlook.com (2603:10b6:208:267::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.7; Fri, 23 Sep
 2022 04:52:11 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be%6]) with mapi id 15.20.5676.009; Fri, 23 Sep 2022
 04:52:11 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: RE: [PATCH net-next 3/3] nfp: add support restart of link
 auto-negotiation
Thread-Topic: [PATCH net-next 3/3] nfp: add support restart of link
 auto-negotiation
Thread-Index: AQHYzbN6NGIRbUhLl0yJnbtzNwwnjq3sMseAgAA+W2CAAAOYAA==
Date:   Fri, 23 Sep 2022 04:52:11 +0000
Message-ID: <DM6PR13MB3705AB81BD51C39ED89E5CDAFC519@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
        <20220921121235.169761-4-simon.horman@corigine.com>
 <20220922175453.0b7057ac@kernel.org>
 <DM6PR13MB37050FD20AF4529263102B52FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
In-Reply-To: <DM6PR13MB37050FD20AF4529263102B52FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|MN2PR13MB3944:EE_
x-ms-office365-filtering-correlation-id: 09b77d8e-a1e9-4b8d-1bff-08da9d1f6077
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SKXaZtzoWrmwkfSjcDco1MOaXml5VPJDuVu+1U97nZMr1dm8hmG7gmPuKESxtgGWxDLRm6BLpXqY6+RXHUA/RB2IfpG0WP4qaZEjWk07Egr6czoy2U9hR8ZqzeOuWC8J7yWnSMpfodbrBTSvKu/sGLB6U1QV8cUj7l2vuNcAJVRdYuS+boAu6fQODLiQbczctzmT7LPkPKsC4XwjTmjfw+AVqBaJrzU44NRnK1biGHpTSYvt8mI/End4SBy1DHAHshDqINlyGZC1dIrmd7a3KRKIfncfJtJyZa2udb2O29rRbhA5Pf3OKkxVpRHHfYf1lls8lN7fQxsadnMpAU30D6TlJrKYzA6S/XoQ6jTx3OYcs8ZIEr9GbVMWmQE3c9B08uaYwqQOG+dJETV6W0zRwIiG/SjXqH8kfN1kzdvkS25JKWrUjgE0eyEZ1Y82qpVwSG4fybdpJ1qy0OytaeLHW7y8w4AiB73JMe4ZEbDGvfpFeY4P9yczUKdB4ND2gIYAOkpXKAmxa/thllLKnnAUmBm/6RlA3ntxS1C+zCLafz/ek0y5+n7+wrmsKMRExooWZTvivsk2fO/djXGz7TlkRMa/TEZybYOpwL+2HD4I42z2XYCTklKgx0p13UOdtvxmHEHj95aB404WHekZDBSVQI8HJqXTHYtwtflx8+++LdXuSLvHH9yEccqXhvCnbMNC3PSXsF3MQWW7niFy4hoCVacu8lZlLxVL8XLKC8+Xd1DMcnMVxtn1zNIANRG6+m8vBHXw8yQV03xknRZK1jaYpLYM7MvNG2FNU5XZCZOCq328e4gie12V+OCwmvXPID8+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39840400004)(136003)(376002)(366004)(451199015)(8936002)(4744005)(44832011)(66446008)(33656002)(64756008)(54906003)(5660300002)(86362001)(66476007)(6636002)(316002)(66556008)(8676002)(76116006)(4326008)(122000001)(110136005)(186003)(66946007)(38100700002)(52536014)(7696005)(71200400001)(41300700001)(6506007)(107886003)(9686003)(478600001)(26005)(38070700005)(2940100002)(55016003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t/mk25E5qyECSv9WIA/BOde1HVd0i/uufVOSkdxLRb4371paXRAmFQIanVt8?=
 =?us-ascii?Q?phv5XTDCs/ytMIHragbPyZAyrV1qO3sP0bPkFefk+7JZD4CaPSF4ZDtopY3v?=
 =?us-ascii?Q?8u3DDhFxstXwc2pxmNtMhg8FZo0w2KAuF2h6t+TRkLM0C1cnDGzwiFKt7R/d?=
 =?us-ascii?Q?7Gjdalk+ISsVdsTrBNOh1PoRIdpHzburszXSEsvVjw1HDANbio8xF7T/3GyV?=
 =?us-ascii?Q?z8WDA5sBJad0Uq3ezV26VoeblmDtqUCofNgN84QIem5S3j4wpb7M6s5QFsry?=
 =?us-ascii?Q?4mhRSHk+GMwGlTDVcy22y+UroDinUa9c7BzcSQAHcpDjQV6Lm8imaVhVTiwR?=
 =?us-ascii?Q?kDfm3ToLdbxT8Q3UYwClpG2AKW+Q6uJPSvHdmxssTnsJdQbZdMjcoLKxAq2T?=
 =?us-ascii?Q?PnLFlKqgUMN9YWVBS9vCazYgFMgDfKoaYFoghRjSwzKyIoauwOf4MFZeud8d?=
 =?us-ascii?Q?wH76AUM1mFj55Qvm3OoRw0iRJbDiBSpO9iTW6a1BnKNe+pZyEX+zCQG+GGD3?=
 =?us-ascii?Q?b4UlsnRfqias9nGYnlAwldig5ZycPnEmYM3imHGfkbBp+gGWXTc4pr+OBRJF?=
 =?us-ascii?Q?wYH+nxn4lJXa6+FIw89TXmSurOMb88VuLevmiDFIYLle1XbV2Cp1rb69Xa3l?=
 =?us-ascii?Q?uWYndyES3kQKr4pNZXail6gjz/4LAGLX93Z7OurGrQIAdhnXwfvWuIfz145f?=
 =?us-ascii?Q?UnyxbzeXyV/xV+ZAA0k3UdmOj1YB2nIoaMe92gWJ3+nTdrlbCL2Kjk896jbu?=
 =?us-ascii?Q?byQE8BTWfZ5v+M/gY1U7bTch/j75+Ou+HgfBKc1kMu9X/pplFCRPQoyTCNOo?=
 =?us-ascii?Q?6P8gj48IOC9EI6GF4OHsFJOVAB1AYrmi+5BNygaVhIUz4G0/wk9D91rq20+T?=
 =?us-ascii?Q?cksFPCupaHqP+ozAnEfI6FnOQzxg8QV/BPU28BmGXhYJnGgWQbGRGGS81zvJ?=
 =?us-ascii?Q?uQM9W04zVJcLYUCCFfr6q2q9swxNXGRXqn1ap3XEVg8zbnMPr2MjruN28WUh?=
 =?us-ascii?Q?PiWBbdUkfkMGNaHKzJ2I1C6zO7mzFlTnnC7GyjXHLRBpNHn3+3jUGkskTJ1/?=
 =?us-ascii?Q?D13Yrptab5yQURcwlIL0qYFK8eMKKK/iL2oE11OO7o644t+NBkTfafgPMHPt?=
 =?us-ascii?Q?XeKYRAR2tTYskFaRDNltFWp2xCFlGowlRtEdFN7YuJx9b6mxRPA/YYHfZKTq?=
 =?us-ascii?Q?aA+v2KTxpxVe7/b86H1vQVoH+AQ0gG+rBzrxS+n+wApREg/kDzzGQssQu1Wu?=
 =?us-ascii?Q?nb1xmFXV8QFGjxRivGY3n540S6Nn8AjwDUKVTZdrdlNK4xLd+s3fnE5s1PFc?=
 =?us-ascii?Q?7ze07na7Io6WDYzWlYhif8JKY6HXYIGca9sGcv6bpiRR4FHB704lTDYCZ/E8?=
 =?us-ascii?Q?AZumLzylZMfnt7bNnCXKL02nPTQkrwprPm+5O4SPqIuI9TLAtdZfsqYEQxxi?=
 =?us-ascii?Q?EP7ap4y4t7SfHo11F8sN/qDchFwWf6WmehMAQ1swOADMmeCPdons488Vv7IK?=
 =?us-ascii?Q?ne1FBaH3V8nPR3uUXJP5o/srMjfmv+BhxboNk0ECfDfCJi7EBZMOYzL2isdr?=
 =?us-ascii?Q?Ht9lxf2+KvtunYmpwx6JoefuANUGH4AsRj3/eBM6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b77d8e-a1e9-4b8d-1bff-08da9d1f6077
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 04:52:11.3844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YsTLS9QOVMIgW6F5YQNRoPUPdt7rO/x7JhR3otTs/GSAIqjqLLGMqRCQCmOHQhjdvAhQgjkCVKdzXy4Tn3eQb/nMi2iBLV8Ot6FSW0fAljk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3944
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, 22 Sep 2022 17:54:53 -0700 Jakub Kicinski wrote:
> > On Wed, 21 Sep 2022 14:12:35 +0200 Simon Horman wrote:
> > > +
> > > +	netdev_info(netdev, "Link reset succeeded\n");
> > > +	return 0;
> >
> > This will not do anything if the port is forced up by multi host
> > or NC-SI.
>=20
> OK, we're going to do the reset thing as long as it's physically
> configured up.

Sorry, I may misunderstand, will use ` nfp_eth_set_configured` directly.
