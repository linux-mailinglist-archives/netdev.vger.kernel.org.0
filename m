Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135D46CD47A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjC2IWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjC2IWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:22:18 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021026.outbound.protection.outlook.com [52.101.62.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E13B5B82;
        Wed, 29 Mar 2023 01:21:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxzlDAXKT8Jyv1QYdXvE2WKnvmvVHBTjaJ8L7u+VSLXQalfE+jX8qHtv2k5jRccK+mQOPjqMBFgzAEtpmRyUiAdMF7Ppm+9ocRXP1wab9c6PawNmp/SJF/bu7l28j0xkGvvw1lWAzblzsc5wrwtd1Rb2BgMWMfcQYlafkU0Wz31c6fckVqgx5RXMtjPQPGCL4qabiqobcGbgxDuCUZ19zIpUVVJvK/tzSVIBCSpaEtuQYiXoN+PVzwlANuAybz6A2ghw9Haa5MUx6FlpWyvuklGlupAfD87cq+L9fDWLq75JiXLKG7BpbwmxiLtanc2h5+jxLhx0KrqnDkKTegGciQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+i4kCWKvgSVf0AOw9WBGGh7yOWARMa275NXQbjbxoMU=;
 b=afrbOixHY/Wn37tSepYAaWK8x94Xo8yBx1hZQtDguFnW8aHgw6U8HmQCV5cFxT8z2PSt5/mCWEsz+bEKJPFtC30sGu3aYoo6Gz3w9WtUO1qYklCUZZt+7iNOMkz1rwxXX9v/lSLbRz+fJaf0sBCoKeax6Yn9CcihRvxWCATGHITuqIW8tJkMSuJhkqq4IPzXsFCuofKkSJ+Wo5l2ENq7dhldTjzzpIyQierC74ap1InqFy+9F9k5DbqMU1pxJU0VIJV4y3gZ/DLw1Vy7t6B1ztCoHtqHrqHdQbDFCYF8LoFCN6hsJXOJfePymC+/DSIG1iJENXF0ua/LOYGp+GxTIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+i4kCWKvgSVf0AOw9WBGGh7yOWARMa275NXQbjbxoMU=;
 b=b0RlnQyx1nrVWDrspw3o/Fj9eM7S1y8CEU8DB12Mnxqj2aFXRKeAMMgIEiPJfsEasiMHJwy67Feuy4fwKPuGZrOaCdo58UIV4V1TH6lQ/ov/oo3qlXGuiJvgIpwpJkZvPp8h/Js/MpMwIt789FizwK5qZQnJEPNZ6OOwoiQiCd8=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by SN6PR2101MB1358.namprd21.prod.outlook.com (2603:10b6:805:107::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.5; Wed, 29 Mar
 2023 08:21:15 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6277.010; Wed, 29 Mar 2023
 08:21:15 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>,
        KY Srinivasan <kys@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Thread-Topic: [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Thread-Index: AQHZYTEw5EIgYDC+IUOtVNpvTo0Kxa8QZ0BAgAD9eoA=
Date:   Wed, 29 Mar 2023 08:21:14 +0000
Message-ID: <SA1PR21MB13356B7C8DD4DA9CC20A880ABF899@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-2-decui@microsoft.com>
 <PH7PR21MB32632E889A7F589C32FE51EDCE889@PH7PR21MB3263.namprd21.prod.outlook.com>
In-Reply-To: <PH7PR21MB32632E889A7F589C32FE51EDCE889@PH7PR21MB3263.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=90dfa640-62da-43df-b474-aa70d6393cab;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-28T16:46:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|SN6PR2101MB1358:EE_
x-ms-office365-filtering-correlation-id: d2502342-feba-4e15-a150-08db302e9030
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8De/SFVB5HPsZnbTZxRY7aedKoj3th48ijOWS6G2VdaKEreeRcV+ditDZXHGuRkCMeqr1n+SO0oAyKMfFhoPJU42NwTCX1Q/y8OHAJENR/YxcmMpmF6+zm4FuhGCEvGQSK7KiFKqPM4OoIZcfhMAcMYVDhvwO06eRaJnfLag/IR1dADfqVyymIdkIRzYFK8jwlqBIUUBncG3+yyVXN6c3uyPCCuDJfSNJSqM8gB+dWqt1fniQlpC0hwLcMjSIaEVKNb4vzFRrtgpqidewtxXErzF3FF3xW4QpUxqcNIxZQ/eNzk6b1nDISaZrkuW64vND55vRM8b45D4Fx90MOifKRaVLLGKY/zCrr4ILqsc/+SahyN5tkNhQHfpFtv8D5XLku0G7TEWjehQ9igsyHT/KkaXu0blD/71kLtHo/ODeLZv8QjWMI1625f7ywsxBczGirpo1ezVPwTemmP6b4KoC3BFKAbcjeRMYjgB8gKiy4Pc7/dpjky4C/8HB2CQc8rvEUlXMfe8B4pOR9RWmQ4/Wr+FuE5KzFSbF+tz7xHQWAcjxHAZ0GNEudYbP3VaLGT+kleu1bHvV9twUjaPykV8+2yc2Hq/9kZsIupfhUgpq9Dypd45BKPayVu2rRzhFJFadkLw6dCrCbUHH1rFl3ODMxouP/Bm6NP3VSijserSJRAha6wv5vmN3KnsV6ZdUySw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199021)(478600001)(5660300002)(64756008)(66476007)(66446008)(66946007)(76116006)(66556008)(10290500003)(4326008)(316002)(921005)(52536014)(82950400001)(82960400001)(122000001)(7416002)(41300700001)(8936002)(186003)(54906003)(26005)(83380400001)(7696005)(8676002)(9686003)(71200400001)(110136005)(6506007)(55016003)(38070700005)(8990500004)(33656002)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6HvROvVUHOOq6SnpUtfYj3R/KrrG0E1LHj51QF4YbIzZD1VoN/0UIfH7UhQ4?=
 =?us-ascii?Q?HxaaHFhA/sIti6UfroQt5/iEp1ZFW732KcW77vD47Jl14RhOQocxmK3tfFVi?=
 =?us-ascii?Q?kOK8kpNU1W0an8U2bT5REQvo/vrAbRoc99GSO635YLbdY72wluBCvmA3j3M/?=
 =?us-ascii?Q?Q6GeARqvcKyOE6hv7MW2olOrxNtpJ+0gjD7LtRlePXlSvxuqOH/nnqOFA4TZ?=
 =?us-ascii?Q?XrBYxNENeSN/2bXqqWe9fvanEcnSmD2EslFLFN5WpKL7BwxsaTlJcdpOWPRL?=
 =?us-ascii?Q?TujwQ4FyU6o93PgDuYhcypvD0is/Hy8POi1GKQW+4OGQRiL5ghwjNAxGcKKB?=
 =?us-ascii?Q?rg7n4g4PnxHbFyWYKCPdHP3VQrLHuMVvCmRX3tHE1uUEacUM0wMiZ8J+Dh0W?=
 =?us-ascii?Q?m2SB+0Tp+rH9DGU1c8kjMdnkWyJ3DJzdWsPAEwoJM9ax3wh2rln/F2DTxRi1?=
 =?us-ascii?Q?SgNU4hd0eYjenhUjyh5qRpnajBGtiCS6dPBPa/7Igf+ozdJF8iYCeUEALQhi?=
 =?us-ascii?Q?A5NHFAVpAeHcZ3YtBZhzaq3xdl0ekD8G+EF04gjwHSaOXwpQ5n+3Yyx3GX21?=
 =?us-ascii?Q?//K5FNnPOZREOGBg6xmF9BAs0eCcf3JPl5R7r6fdrc6PYE2ruK2wvzLdPGPS?=
 =?us-ascii?Q?AjHsufQK9KwEFkxARxsJQVH/hVm48AJFZ2idzkImoHvdZEktcCFxQEYuRCsl?=
 =?us-ascii?Q?mKTGQ3XgcaNz2IWZWWYWSqCIzkZjHuCBcKErSdaD7YawNcarocI4A5OBJrZ+?=
 =?us-ascii?Q?MHaSjm9h6a1UuLwF4ZeG/qAHLQi4WF6vvnFoAnPuC74gjDAWVZmNpXlGyVpW?=
 =?us-ascii?Q?wZH3TdEINPOJW7OYRCceuZ4OZHSRGhng9yC49tf7Xrnku7mGE8QLBI1kfsQO?=
 =?us-ascii?Q?la44eD91Vn8MpFMaozl1oGklyFSv3Rcq+tCNTAFloonCBhWWlVQzNtHlK0/4?=
 =?us-ascii?Q?whVMG3SHE83m46HPrgA/P6FT8HUUWULLUarLVRLZ/Pzw/HV9313qjxv/eMxe?=
 =?us-ascii?Q?chnpV7CRAU77z472g6P47BbOn0E8GLqv1Ulyw1/i75Dz2XCBLzL473Qk4Iaj?=
 =?us-ascii?Q?f4K0QfKB+4BkIgssxjlsK6TJL8v51eRiia951yqV3CH5l4Eef+khaFCrJlMR?=
 =?us-ascii?Q?US1dwhv42BTPPzWhMrSDmv6sJZnbyVkiwDtiiQW8CUhwwaiAl8O7k6XVQV02?=
 =?us-ascii?Q?J/gfPsUvRA2BklSd1KXkWTro3EPcWxenb+0My0Yc0ASJwSDM3RZNUZbFLbHo?=
 =?us-ascii?Q?IgUEteJpWrnfJ4SQTC9Uii7ecHOsCHvHeDSaVfXyI0WRv58zLrNzScL85DdM?=
 =?us-ascii?Q?KEurhWHJZtwFtu0WsvxWXMw/rdGedLwcjg0YM3PJULmvm7cCJMt12qv+6QP4?=
 =?us-ascii?Q?JBoGUYA5kFHWd2raJW2SdCzHm3Y0W08znQDwuwV9FNc2DzDRLYE3hqzi1X6Z?=
 =?us-ascii?Q?iwvvFjNxFvFwECQXQaGZZaBrbzpTh/hwIEW/x9SFJr1+3E89RXk/NRbyoy9Q?=
 =?us-ascii?Q?W5AFmifYvMdp60jYQh/kBoRYKI/UKzXskj7cm5Cbbo5cts2XCPdiTMVXBdsm?=
 =?us-ascii?Q?LZgmWG1sBArQPHMb4UGC+zPbqiQt1rQIoGgKQOm3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2502342-feba-4e15-a150-08db302e9030
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 08:21:14.8658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O7mrIwHVtmikXvbq4wgaxYZxpoMCeBRks6Livw8gJziIUKEIuxGliK09c1ZDiqMglxctD2vcusJUsuXEDv5ndg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB1358
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Long Li <longli@microsoft.com>
> Sent: Tuesday, March 28, 2023 9:49 AM
> > --- a/drivers/pci/controller/pci-hyperv.c
> > +++ b/drivers/pci/controller/pci-hyperv.c
> > @@ -3308,6 +3308,19 @@ static int hv_pci_query_relations(struct
> hv_device
> > *hdev)
> >  	if (!ret)
> >  		ret =3D wait_for_response(hdev, &comp);
> >
> > +	/*
> > +	 * In the case of fast device addition/removal, it's possible that
> > +	 * vmbus_sendpacket() or wait_for_response() returns -ENODEV but
> > we
> > +	 * already got a PCI_BUS_RELATIONS* message from the host and the
> > +	 * channel callback already scheduled a work to hbus->wq, which can
> > be
> > +	 * running survey_child_resources() -> complete(&hbus-
> > >survey_event),
> > +	 * even after hv_pci_query_relations() exits and the stack variable
> > +	 * 'comp' is no longer valid. This can cause a strange hang issue
> > +	 * or sometimes a page fault. Flush hbus->wq before we exit from
> > +	 * hv_pci_query_relations() to avoid the issues.
> > +	 */
> > +	flush_workqueue(hbus->wq);
>=20
> Is it possible for PCI_BUS_RELATIONS to be scheduled arrive after calling
> flush_workqueue(hbus->wq)?

It's possible, but that doesn't matter:

hv_pci_query_relations() is called only once, and it sets hbus->survey_even=
t
to point to the stack variable 'comp'. The first survey_child_resources()
calls complete() for the 'comp' and sets hbus->survey_event to NULL.

When the second survey_child_resources() is called, hbus->survey_event
is NULL, so survey_child_resources() returns immediately.

According to my test, after hv_pci_enter_d0() posts PCI_BUS_D0ENTRY,
the guest receives a second PCI_BUS_RELATIONS2 message, which is
the same as the first PCI_BUS_RELATIONS2 message, which is basically
a no-op in pci_devices_present_work(), especially with the
newly-introduced per-hbus state_lock mutex.

