Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0F257C14F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 02:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiGUAGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 20:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiGUAGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 20:06:16 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021022.outbound.protection.outlook.com [52.101.62.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6675730F42;
        Wed, 20 Jul 2022 17:06:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wcypu8Rn3QpzVrYjMjKhdolmGCUIXzNbvGAbhTq4HybmQJzbcOAIF+81NTJaXpzdrQBPU51qtkRYV1e08Ikud6W7VfNgVS5K/WbLVqYuPvaQX4NFFuQnm3ajFfkwDfWyDCxk68WEuohZbpcA4dgnZuKgYGOBc5zGg3bYX5jfogYdqqKHkk6rjYVnvQ3pNZqrthmumQX9fdpbXMxbYrCyMGn32gnkp2emeM8nRJESwRTxmz/X4uOE8oM2dM2jezl4R9ijjAhNCZXAi4g4N93leQWQo3QlIB/8e8FZYOcXn/ipi+Atth/ry3AFNHR905MgHvFEu7P7ViE+O/to7ot5eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ph2HWtgEXxltMMeeA2RKHyCIesYQhw4XkKq2hJUcRW8=;
 b=k0HbZibYRwbWW+LTjNhNxDfgFhmNAFld/VdoSdTxA7xdoRTjsll0V4yddvo1hf0LfZSMbwbfXR5AJ5Phfbe6w3jdpsDQITxYVVtJKA/abBaPEiPrAGyEoMfdyH0j427Bj+D5o9WrFoWgLNMB+THDbik3XzOHNo5/UmyTh/y9XVYk2LwgUOpSgQrX41vucdKoO106sSIwIIpNCVJOt7bbi003cJ+HiUg07gzdPheSC1OLE5sl2N6lRLXa2MH3vmUhDq8Kom/CE9mM6LaRly8M2JHSW6qGMuyDVCs8UesCXbL5Al8rigO/USqoAjZ0PERVpHg173RBjxkhRM91r7t0gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ph2HWtgEXxltMMeeA2RKHyCIesYQhw4XkKq2hJUcRW8=;
 b=CQPnEjvhfTpizCJvghIgbpC3O5qHjhbRPdReY70tBCIQSUkjV0Sm5Q02Pzd3fnLGMW4U/UUrVq4tc8ORrGOL0h6zkpPwsVHbPgMV0Vtv/icsy4UDauUihOU6RpJg95JOSGKP2DQhS6IjrAsebxyMm9Bwvq66ryV1KDqlOHaqSvc=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by SA0PR21MB1929.namprd21.prod.outlook.com (2603:10b6:806:e1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1; Thu, 21 Jul
 2022 00:06:13 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a%7]) with mapi id 15.20.5482.001; Thu, 21 Jul 2022
 00:06:12 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHYgSXY1SrlgLfyyEyOddi806gORa14hJeAgAK137CADOflgIAABSdw
Date:   Thu, 21 Jul 2022 00:06:12 +0000
Message-ID: <PH7PR21MB3263F5FD2FA4BA6669C21509CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220720234209.GP5049@ziepe.ca>
In-Reply-To: <20220720234209.GP5049@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=952ff3b5-bbab-4714-ae30-9eeffd76dc4a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-21T00:00:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70359c4b-5b69-4125-3e7e-08da6aacd2bc
x-ms-traffictypediagnostic: SA0PR21MB1929:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j4VYvCLcwSA4mLbfH9A1Rs7+ugnUsD71sNYe+UmRQIUFZCDV+lv4rqkGThyGLYMEqVNeSch8W+xBDNfr/LEQr70VqoNiqNXh7BktLoxqw2mrDR0jIzeJ5Q3McZ+5+XxfDRc9+VSOoiMRsCaS8L587va+X+XmBnbFkKiAKJ8ATpDTLeyax4R2E6BS7cvY5OSj9Lrh/W4m9VQDC+LzIaPHLuca4fD48t8KWdN2S+EK59ZLugye/dlMeQUtWKuuMZjCELg1xhBdfptnGbGsqjgUl3UucMVmE9tVjbZmmL2HATBDNwalAnJERFoVcML4NhHAGLyyHsu5GJn0RqQ+HvMwe0Vh8ge+vggrz2uhky8V4gNbEqKAFMsUmLLmrNigeLBWzJmTbH3g06LQKEUxHY2GpKAyThTOkXTbmRTURGfsYQ9/7avoknSsvf2+N7mBlccdpQMBEsAbP+SQbKT7jN4l142VNxW9O5piwjFjhpAcVK//gF3Ip+1Urs1yR8SOJbzasGFWIL8QxEEAIn2XTpI+Lb3ITMO93EgGGA+obsntnFn7lcIjlsuKLuVaZ5Gg7iONHvMMZrN6J2cbv26gftiPnTnRgNd/lJrj9PUxRWiK4qvVy7/JV2MI80/vwJL2oVI19ziruOE1WjvliROWh7DxdlckSxsRgs9tkUe4zUW+7nFzBCMzWFRw03PiyHjS/R0F0p8v0kWdce6xIKzhpXc90z5u62QpG7mCtkx+w+mfnVASq4c2SUi/J/u3zwwHKdjtdrLqjqyghwdLZlmPiEKO/BmSQ413IHe7XdcVtgOuiuGOKrjx0njJG6Ba4I1huu5MwyE86TRPER9jos/Z+ISPshyguGYN/1bYFbiLpxqyNvo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(451199009)(8990500004)(8676002)(2906002)(86362001)(52536014)(41300700001)(33656002)(9686003)(83380400001)(26005)(186003)(7696005)(7416002)(6506007)(478600001)(5660300002)(8936002)(316002)(54906003)(6916009)(82950400001)(71200400001)(10290500003)(122000001)(66946007)(4326008)(64756008)(66446008)(66476007)(55016003)(38070700005)(76116006)(66556008)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I4yb2CCHcxrEOrGWV+jLbxS4VGnOBwm1SR5pSfCIIK3dKbf8pqEiMFyThT3n?=
 =?us-ascii?Q?wySxRdqEix6KzUvRtP+D9QQ7tbdeYFvR5jmhXOn46n+wtdnC8oXSbWCQVTze?=
 =?us-ascii?Q?I5X5l4Go9lsxIHloMjJi8I/izoLp0GOzBobR/2D1zk5YFsHfkBc0YoLn83uB?=
 =?us-ascii?Q?b49VixbUmG6VfXZ6YPN+w4QlBJ0DVafWxsF1TKBm3sPw6UJvin50bUiB8Hsu?=
 =?us-ascii?Q?dEYdWYqGBou02C8m2Vo8oGdAE3eTF3bTtfxGkRSg/SvUUQU0ksAMzxwhPDQ3?=
 =?us-ascii?Q?SqNFVxSrUSR9hqoSdxswNJoHvxhzGIRb+8G71IWHiu9NCjDAZyzynYLpPPPv?=
 =?us-ascii?Q?+VLB6jMueEdlSwnTMcy2b3X2h1VT2WH5XuXRXt5DV39dt5QSXuKV3B0uKqLw?=
 =?us-ascii?Q?1lMtzl1eu6nf93SQeAhZERAOR+/AEREvcDGrRDmEIDiQ69cpAdoM944P4eRz?=
 =?us-ascii?Q?n76A7/rXWW4lFgefRL9/NcYfv38aTb6d7IJGxkIKtmd7E8zhhXImNTnvgBGn?=
 =?us-ascii?Q?NfLi0edgvgLGoOjagYkYuGozp9uXyAWU7jXSqd8EnAtI99dTo9ZPJDO2KMKo?=
 =?us-ascii?Q?urb8xKTZ80MHpUFbbXhUbBkGaQNqEBG79LTEL59rEXTuEX+jr4rTD8IFW9qm?=
 =?us-ascii?Q?8d4GxoGMEdX/wAwT3TGHVNI8w4G7dTfewUbtdFNzidsbr/aVEgoLypaxTZWw?=
 =?us-ascii?Q?prmznR04gnPLeVpl+D6UVXqxQ7OkmZGP7mCXOriHhU7Sf2CAUmnaumIUjHZN?=
 =?us-ascii?Q?92kN5l+P7QLAilANDtz+cuaIpZ0oJoDBqe0w4zBGkH81buwfDjBXdrHNwub7?=
 =?us-ascii?Q?MDh79jlWR3RqZnjuoO27/NrF2nPF9YnYF/xFJUFPm699OrccKi3vUpdsYqx/?=
 =?us-ascii?Q?sgDL0RgHK5zDanPdsBp2lyiPc1iMh88d8OLlt52vZzAbar1U9mifm3wJSr58?=
 =?us-ascii?Q?s2vFXudmKtZM+GiPieLSkiTJzlkPof+HEAgD9zCZGO0nZb5NFUTgNmMPOAKH?=
 =?us-ascii?Q?8pUukJk7vEBdOLwdjTOO2yfnmpryE+zQVTWeoVpcrdAV6Yz62f4TNBRkZFjj?=
 =?us-ascii?Q?NukNVXjqZPhIJENBhsCj80QNCNxn7wnvW6U1c6r3v2Nl+Ua2O4kiCE2xFrEV?=
 =?us-ascii?Q?c812be0HeRsYmpLiREyEffFyCxVE80WrID1u2/GKLj2ZU6R9uHKzLERTdTrf?=
 =?us-ascii?Q?JSQF9Xkd+VW+ppZs/Bh3ljy0zxBwmE1LFY/Mp0/fqIKfbW9xUSCvR6Q1WUnL?=
 =?us-ascii?Q?ZzuHDyIseSxUDKWtB/m9BmIUpKRjsb3tjnTXiT5AJyB2jmLmdAB8w4Bqs2Y4?=
 =?us-ascii?Q?QMqUD+38lw73UkZBbsyJr3NAucuIDi0fd+YdMb9GCBOKElALtigxdNOVaDzU?=
 =?us-ascii?Q?pbdRXsi5DZDyGCZdUp15v7FugBTRf7Bd/dybmb/r7vNPv1ARiZuLI6MAe2H+?=
 =?us-ascii?Q?CiUQ0HlrWDW4uGcSDlg4EnMitGk56yt+QLXi1yYqym54MBpWFNUkil4YwLUA?=
 =?us-ascii?Q?1MW0BtW+ed2ZmETFJqtBwapbQNd5MqIHrDejEpolFtUlBA8TY6H0VR+y+dFW?=
 =?us-ascii?Q?acxOqgB6uGPRrDqZPi1rsd9kIJ5+T9X0CJXeKIjJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70359c4b-5b69-4125-3e7e-08da6aacd2bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 00:06:12.8504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PmMjTah1Xa+rGSQsbOSex3kNcHKGw+a3v24YKCzSgdN4F3T3JgUmkvN5GaJYPXQRJ+9zVKvvzaDEESB3gD0AAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1929
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing between
> devices
>=20
> On Tue, Jul 12, 2022 at 06:48:09PM +0000, Long Li wrote:
> > > > @@ -563,9 +581,19 @@ static int mana_cfg_vport(struct
> > > > mana_port_context *apc, u32 protection_dom_id,
> > > >
> > > >  	apc->tx_shortform_allowed =3D resp.short_form_allowed;
> > > >  	apc->tx_vp_offset =3D resp.tx_vport_offset;
> > > > +
> > > > +	netdev_info(apc->ndev, "Configured vPort %llu PD %u DB %u\n",
> > > > +		    apc->port_handle, protection_dom_id, doorbell_pg_id);
> > > Should this be netdev_dbg()?
> > > The log buffer can be flooded if there are many vPorts per VF PCI
> > > device and there are a lot of VFs.
> >
> > The reason netdev_info () is used is that this message is important
> > for troubleshooting initial setup issues with Ethernet driver. We rely
> > on user to get this configured right to share the same hardware port
> > between Ethernet and RDMA driver. As far as I know, there is no easy
> > way for a driver to "take over" an exclusive hardware resource from
> > another driver.
>=20
> This seems like a really strange statement.
>=20
> Exactly how does all of this work?
>=20
> Jason

"vport" is a hardware resource that can either be used by an Ethernet devic=
e, or an RDMA device. But it can't be used by both at the same time. The "v=
port" is associated with a protection domain and doorbell, it's programmed =
in the hardware. Outgoing traffic is enforced on this vport based on how it=
 is programmed.

Hardware is not responsible for tracking which one is using this "vport", i=
t's up to the software to make sure it's correctly configured for that devi=
ce.

Long
