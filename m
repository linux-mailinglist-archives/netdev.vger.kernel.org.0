Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165396C1821
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjCTPUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbjCTPUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:20:03 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A262E80A;
        Mon, 20 Mar 2023 08:14:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTvEh2RKF5Bi/jAd/h20jBZTowssAYdlC86Dm121QyhjPnz/eIMIvim+ph/YYVqosVnCha9CV8FOknIPHQ4vfozlYQkznOZ23r9M3tdrE8vFVrviiKHN/Wd3XAH7KLo/1YYDe3wv3VTOOAv4nXMz9HnnUkpYOX+XjTfD1uzEdtdT9C5YQ42XXABBWd494YkvJLDKwJeQ7vQeGG4x9WpRNbtOA1j+IMaMkTXt9b+zUGa5LtzDMQLgGDniYA0sFyjNQ2TQChQ1fqfhjqWqxCzn3GKTdhD4AuYBQedeQTEKrhKfkN9qAcx026dWV9s5iL4kv+9h8tLfS2kT1JUlzU9w4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDnG7E42CDYx6f/6fGdxE7Y0ORdBRxJM6MbjJibQK64=;
 b=iH0w0zfprgYf3+KOXWQP0ldKyKuAoAB06ML1lKbS006Shub+eZbYyWWms48zOQrx3+FIl+o/ZwivipJZGFBq3E4+/JXBlrpn0xxEYTkQlmdMLQOLQSiRzY8QWO/+rybi//fMCclZhaUC4znS91HllKPklLSmu7tkVUpQBnRdIran9z0REvjGH+YKKOzOrUzgAsBT+gUJslmTUeswtdd6SNSAQmCXFf1/xCwK8I3wo2/pbdrN9FYVlueNWvJ3qBXWWfvV3C4TcIPMaiDLj9uinWKwcZZxbRkKxoqJQZnZQWhdu6IxyAO8zzZiOnP1W81RBgt06UyIrCNQnBjbGT8fPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDnG7E42CDYx6f/6fGdxE7Y0ORdBRxJM6MbjJibQK64=;
 b=Ww751akppgasb9x17qydjoIP769ExPFHsTL1PIV/tDlQsNZCFCCRlqky/u+Vo7oBH5Ge9vU0ZTnUMGJWAm1hqCLfoJBryP078NR7+HO/3gfzU8evUQ9N6pu/9dHj2Q1qF2TcTa3ZjDP8/Dqm10fPM0ktgaFcFD+D0xYxz+zaW9M=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3538.namprd21.prod.outlook.com (2603:10b6:8:a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.2; Mon, 20 Mar
 2023 15:14:36 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787%7]) with mapi id 15.20.6254.000; Mon, 20 Mar 2023
 15:14:32 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add support for jumbo frame
Thread-Topic: [PATCH net-next] net: mana: Add support for jumbo frame
Thread-Index: AQHZWqm9UOpmxqzZvUOZ7L83A2HDza8DSZcAgAB+W6A=
Date:   Mon, 20 Mar 2023 15:14:32 +0000
Message-ID: <PH7PR21MB31165FB2F772DBEEF242DCF4CA809@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
 <20230320074202.GH36557@unreal>
In-Reply-To: <20230320074202.GH36557@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bb797122-71e7-49a3-b2e4-f0272a4e2ebc;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-20T15:14:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3538:EE_
x-ms-office365-filtering-correlation-id: 528229de-e69c-4993-8795-08db2955cee8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zbtZRPZ0IWQrtjZ9FzJV2LHC3PSbcVgwAwr2pGeOweKfOWt5s/ZyyRZmcZcM85L2ycDd/WRAOwpYuVWfaynaq2RiWBp525khfZ4pBlf3rFkWN3PiOzbZV/IaH+AnwBLBgYxKTsBySDxKMUdqNZRh8G5x+AlLttIvwd2zmn8wjzB+JdzgWLjM8GgvXREVOGwVAm5TPrcc9rpPyQLrB6PEm3A9LPvdrOtYzkeIAGa9WDUIFLsfhoDFHthQ4TicQop3JzasjP8BgwYIKb6NiYjZsQp6rjPIvTwsZ1m7maxekYND6MhOU5L8FEp5GtLM5yVPweJlf1J/sGrx94E8sYhyCWm41aMuI9TqbBF0tkvHvTsxigX/iTRyPmpojb/dBAJIOGozHc/5xcdiOnr1+CGDW1qfZKLuYkTsQJTv27i94WBAb+p1OQ2OsPXTTZuE+rgacD4z6STm7F9RiV6E5yGKpga8snOqT/J0q/oKXEdKpM3icAG+WKG9J3TmN/+LXhdRIeUvuBkFhf9rGuPOTnA3ig3kBRKhwFV7RKmOP70gSLK8TnE657qR4wQ92PQce8DrhbiFWjjz2bBmUOBdxL4RUQ6VdKImli/R076x+MDQ5NqRA7aMs4nobYGDRZI293vF1qIYj55JFwfbnLZzk/69oMJtT2029L8T0WYm3yHo/15NsQIyX+xI80PhdoWaRN1qJ/mSZWDq0ipRgU+8UH8oPMSLFJEi4prI0+nw1YL8yuMB0Y0GNF5l6XomvJLDlInC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199018)(41300700001)(83380400001)(55016003)(7416002)(5660300002)(53546011)(26005)(6506007)(10290500003)(9686003)(7696005)(186003)(71200400001)(66446008)(478600001)(64756008)(66476007)(66556008)(76116006)(66946007)(6916009)(4326008)(54906003)(8676002)(52536014)(33656002)(8936002)(2906002)(38100700002)(122000001)(316002)(82950400001)(82960400001)(86362001)(8990500004)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zWe3Twxmhw13qZKpqjlNrfBu8Bk7/YhHy3RxqT3SHmhUB3F1uJdXs3HVwW6p?=
 =?us-ascii?Q?C0GGvrmP0KMsLsvAfrKXB6Ie1KPvxa64n4aZJnWfWKHas1Eyw9fY5tezZ/Sz?=
 =?us-ascii?Q?+mUweeQpV/NxRnWOpTC9sdPYoxuZ7/PEYP8hcfUUEiE9g4akzfXmkdjigmOz?=
 =?us-ascii?Q?Ldfqcyfo8Rr94sFxAUOQaaBGdAtxSuBBZqw/1h1V64Hi7spOee+D5XdXMq8n?=
 =?us-ascii?Q?KIXNCd75BvtAYOfRZpdeJXZJR+6JxT0qzlICiKIQgpLngOoHWSrE31T8SapE?=
 =?us-ascii?Q?OAHSkFGqAFlWTrr1rtNFmckDTIKj7y9bVa6Lr8TE36WanHK27EsWdhr767RO?=
 =?us-ascii?Q?b2TI/OT1O6x6i6HinTj+/sXSewGaC8lLheqVtzxPbfyMzKHX0mFSQ2xDGSlc?=
 =?us-ascii?Q?4C8sP66RKpm/Cc33P75A5V9eqQQmUaTb/xLFhPTwCpJnqYPWU5BCxdkUNL0D?=
 =?us-ascii?Q?HsaJWBxwxMd0knq0wBdsyqVAnmu179D1CM0F/5v2yOSwVb9e8KrllpAzLAmC?=
 =?us-ascii?Q?9K2UiV1cAvo99dA56opbMF9oVRWAXUUdl5TajNnTUAyMgJ+N4svp8G2cQpmt?=
 =?us-ascii?Q?N8hJ7axFtxtWEm1XqIbMrOL45o++UMjIMxv+KU5D6PlVbQdMPNNqnPK4pEmI?=
 =?us-ascii?Q?9mV96pS810Cj5ImTkbKi9+R0uk/9pazxKGhJ+64b4VpDc6cACBfPB9bzK0zF?=
 =?us-ascii?Q?oK5+nF7EJzOeBh/h37X8LGdczI3exA6Qmm4MkjItGuN0mhfJiqRjXLBKuqbp?=
 =?us-ascii?Q?LLIHwkNIepYcjT2xWpKJHrN8elZpGixxj7S841PEnZFKuvy/5hBIfjS8YImM?=
 =?us-ascii?Q?gaAgJqzcMurMGdjU+MpveyegvQ1W/7soEu6b4JJnFXntl3+UL0bfsewtOv2K?=
 =?us-ascii?Q?zytOKMUGGf6xfDU3Us13VC0wpyU0xEeHKjXPDwSWN8J/QGlJrafgEkQyCOjz?=
 =?us-ascii?Q?NAxNz2MIomjr7ldUbTKMwsMUl05j3H2sjcNEa0jJXAvOqWt2aZ1BezVZZ17+?=
 =?us-ascii?Q?euOC7Qusa8LFHUldWSlUbZDVRJ1/5vbtAzvAE5iUF96tfr2tXCI+avTWWN0V?=
 =?us-ascii?Q?Sw9jG98fwyIHjSbIRlObvHMskAc/s6qDsyYOTXDUSt1xPhO8h0lRARbdjO82?=
 =?us-ascii?Q?8/67Dp37e/rhNfIcrHiVFGplV8Fwpwn3ugoGUoA7869kxBMmyLAmRy2+PeOQ?=
 =?us-ascii?Q?BaKSVUW3yabiVekuTUJYfigsGVPxrPdvSb3aNAdd6GndXzyhF5h5ah55mXr9?=
 =?us-ascii?Q?62no2EC8r+/kgdpJO3Pwn7z1MsLTl2CLvNsFmEPd0JdDKXFR9kYSZqjRCqtm?=
 =?us-ascii?Q?aGBPeyoul7lJLgyiRzMaXhtGAS4zLVWXRevRFCnMBiKfFh9tO2r8RrceXinU?=
 =?us-ascii?Q?spsKDSA6x4o+1Z9/5nHBnVsZFZM0vPJ0vaDlOS1njHypLUu2q8p6sJ8RyM5k?=
 =?us-ascii?Q?k4oi/RvZzkZ7e6ShnIRT/51//OyZiiFe/pxF15oZcCJbmJ4/WG+iY29CGOT8?=
 =?us-ascii?Q?exSrmuRb6eiIPhAoCIQ1p8dmy7ZdM5W0eIBUpndmlC/meM7jVaXAHwyzmI6Y?=
 =?us-ascii?Q?wLqHwkpilvwQB6LGSrxnOcJ2+anPVgrvx9Qb+M3p?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528229de-e69c-4993-8795-08db2955cee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 15:14:32.2835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9mNbJXuUdLRhS+U4x5seCXczSPFjkNMIrJqe+AIVwBNXuUncCM76m8GfufdPSRLm0u+EkxdIl7crD/ysPoMQaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3538
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Monday, March 20, 2023 3:42 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; Long Li <longli@microsoft.com>;
> ssengar@linux.microsoft.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] net: mana: Add support for jumbo frame
>=20
> On Sun, Mar 19, 2023 at 02:27:44PM -0700, Haiyang Zhang wrote:
> > During probe, get the hardware allowed max MTU by querying the device
> > configuration. Users can select MTU up to the device limit. Also,
> > when XDP is in use, we currently limit the buffer size to one page.
> >
> > Updated RX data path to allocate and use RX queue DMA buffers with
> > proper size based on the MTU setting.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  .../net/ethernet/microsoft/mana/mana_bpf.c    |  22 +-
> >  drivers/net/ethernet/microsoft/mana/mana_en.c | 229 ++++++++++++----
> --
> >  include/net/mana/gdma.h                       |   4 +
> >  include/net/mana/mana.h                       |  18 +-
> >  4 files changed, 183 insertions(+), 90 deletions(-)
>=20
> <...>
>=20
> > +static int mana_change_mtu(struct net_device *ndev, int new_mtu)
> > +{
> > +	unsigned int old_mtu =3D ndev->mtu;
> > +	int err, err2;
> > +
> > +	err =3D mana_detach(ndev, false);
> > +	if (err) {
> > +		netdev_err(ndev, "mana_detach failed: %d\n", err);
> > +		return err;
> > +	}
> > +
> > +	ndev->mtu =3D new_mtu;
> > +
> > +	err =3D mana_attach(ndev);
> > +	if (!err)
> > +		return 0;
> > +
> > +	netdev_err(ndev, "mana_attach failed: %d\n", err);
> > +
> > +	/* Try to roll it back to the old configuration. */
> > +	ndev->mtu =3D old_mtu;
> > +	err2 =3D mana_attach(ndev);
>=20
> I second to Francois and agree with him that it is very questionable.
> If mana_attach() failed for first try, you should bail out and not
> retry with some hope that it will pass.
>=20

Will consider. Thanks.
