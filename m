Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810875F2E3E
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiJCJhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiJCJhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:37:20 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B9D5D139;
        Mon,  3 Oct 2022 02:32:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4hNM5ZBwDJriD75i77sxiLguPA27/BGgIneJilqABV28FfnjZRVtoaA8IM+sS18gPmqZCXIquuw5hwpfL/PtTE7Tn7uBXd0LQy+c8eZ3Ag5zQuWG4ET7UQc7pVahMZAaI+EVIECLC5MJZp3pXlW3MySF/fyHCoBx6C0EJnKqYgaXuyTtmTU5//53bZ6/pAdayIzCfc5dp59cY+Ohl3L/SygUOzOW80DneNMzG1rJhCTgIB2upRqUpywTRsYciwd92URXOKcqDrQh0tp+gdi10RH7iV1AflCzxhCDQu/jYvTeK4Y2mErx+zqPxkQ3Vedj4J8wo+vyNnd6xUBKp86Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeA/MXG8e5XmjU1iQtc3+GePiSmb2h9FrtvQ+s/RQbc=;
 b=ckJ6FslRQ+2K7PZvXG9dzq+lRAGp0Fl4SVHdpB4fqGrxVOhJyVZ5i1Ovja5FR1GdJ2MR1LgKAsKIefqeY5OgOh80qGah77RFcp7DkCtbzzjoy8H9NtzPMLiCcB1nQXc7jQCNy2aR16nUckExvedIRjvCHhReTmtfPrwvOhTs9kM7HR/FIkrXM9CW2vV/S8gmTRmUN6wH4TzZ91ybzRJ6Q2HKkKbJtTxTb9XRap4qib0ZeFJD0ZmtfAF4eBlAT7tpxjq9exw8YUm9JfGUo7aOihdHFtPmKYEFAupnKDwvIMEe3Hq1rg4CeRqxmf3rzJ0MF7Ku+ieZUezw4nTtRAWtGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeA/MXG8e5XmjU1iQtc3+GePiSmb2h9FrtvQ+s/RQbc=;
 b=2eXCiz1aDPQft9acMDmsZFXovl0QDuOTRXBS4+AIGXLfd12HOwYBE6zQpKaZ/jOsZEkhtSWgtQI21Ejf7e89B3eyf7B6re3WfeOaxgEEpcWmfaXOOYr7DA1WIsbwv8U76t6fsXmhNBzKM4FVgMtF8tOzBZt8NP7kd2sYgc8lfn4=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by PH7PR12MB7305.namprd12.prod.outlook.com (2603:10b6:510:209::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Mon, 3 Oct
 2022 09:29:01 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::f099:96c9:82e4:600f]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::f099:96c9:82e4:600f%6]) with mapi id 15.20.5676.024; Mon, 3 Oct 2022
 09:29:00 +0000
From:   "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To:     Rob Herring <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>
Subject: RE: [RFC PATCH] dt-bindings: net: ethernet-controller: Add
 ptimer_handle
Thread-Topic: [RFC PATCH] dt-bindings: net: ethernet-controller: Add
 ptimer_handle
Thread-Index: AQHY0/zQrGhXct8GIk+5NMkHMGtsKK34W9kAgAPrvpA=
Date:   Mon, 3 Oct 2022 09:29:00 +0000
Message-ID: <MW5PR12MB55988BE28F8879AF78B4441E875B9@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20220929121249.18504-1-sarath.babu.naidu.gaddam@amd.com>
 <20220930192200.GA693073-robh@kernel.org>
In-Reply-To: <20220930192200.GA693073-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|PH7PR12MB7305:EE_
x-ms-office365-filtering-correlation-id: 512534ca-d612-4e21-699f-08daa521b49b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nXbVBWoM1DHPsUNZTE5radCu7hEp6ZTsKkseJLey3IibFmvciSStt5c+Zm0R8ZjnRpT2s3FWTJNejHxrDUVpKqMJT3+F9xw/g9cMSTH0OtriNOmN4gnWxs3Kq9z3/SjTaqrsSHHsLy/gWTQm9iHXSYiVgTvUmfTR3KAIZzxs4ZlwurgFm6PlO4jhMKvey6wystHvm9iboVFHCKyQdP7hR689Fb/IEeKe57dAL3/oI0Bgn2MJOclhBPWokAUGSNIV1IuubG0HufOGtKMXhPDqY2aWepdN+bwbUSL/cxDRJCcsCCem0KGg9f0e75xM5RID/ZA0Zu+HMx/Ik4NNKk6N5rlcqbzn61BzBuG8yMql7RNvAnp3GTccwu6DzbgICM3WCk2JuwkZBcAw1DOSa1c+EKWBB1OwvyUJdTKuysDP9Vji9U5+SAQO4LV/sAQfAegsA2epKbx44s9JZe2NhCBpuR7n39WJ2QOEC3CDpaKuYi92VwspPEi/5m5CVh5dJMtecgjF3CaOtrfPwyrSnQUuLtvP/r+bLQPyuuQkVHBai9wbW9az/aoDvP3sE2BmyZaV/DWvaQ1cVCmdSnClFqtXZ+7rTwaR1Q9ENh84GPT0MnCpHUn/vHacKMePo41gxSHMNRSTA6bad4uKsynlDLDxkzGaHKDNX2zU64ZOXbP8Gf39l5hh5wCaD2TQBQjRaIIdI87N9QJpaMGpKlUyLcE60AQB/V/xuoFQteh6Mmw9BxepL2X055hfsDnYPW7kC+XrV49bVsEVBd4H7s/yAtuNutekQmYACVlN5YqR9lOt/cc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199015)(6506007)(66446008)(66556008)(7696005)(64756008)(66476007)(9686003)(26005)(8676002)(54906003)(6916009)(4326008)(53546011)(478600001)(316002)(76116006)(966005)(66946007)(71200400001)(38100700002)(55016003)(122000001)(86362001)(33656002)(38070700005)(83380400001)(186003)(5660300002)(7416002)(8936002)(41300700001)(52536014)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Jmcf2Hmk3bb5XiX+i3QWV1IZEoYFtoL58rkvMxHVEF2j/NXjLM/O8Concg3H?=
 =?us-ascii?Q?xryUD74xXSrQ7OLKeptpdZxq0L+I1MKGYYey05w8VhNdZOAayamehVf058VD?=
 =?us-ascii?Q?9DKDlQINEu88Hn5ktNYGWlpwWuWUO18ViNoCm3HWAkT+WVxidOf+Rnp02dag?=
 =?us-ascii?Q?ZMMBS3Vc3u/3iKrVd0XKlHXcioAeWLtD9KcIOuLY2QSx47uG+X0/S3FEimfB?=
 =?us-ascii?Q?CjoHkPyqpdyXK4Ep+zunKX8YOZIhplppKu2S1fOrzqIJ8Rnv2utb/VKgG3/o?=
 =?us-ascii?Q?s4K/2p7mUOVevGWySnpAkh39ixiy0a5Z/Hr0pbtc6mg+7RWXPYvSEoBKc8NT?=
 =?us-ascii?Q?LcNzhZUqQcSZ76+D4qJSrlBicuAZNvg6EsgSlFKvkocHq+bhGh9sURqa4GKl?=
 =?us-ascii?Q?Dq+XV4WesS/D7tvzr5WZXsNjqoMN1tYZiyxE1LqTq4wgBfXUoW59a/TWfC2K?=
 =?us-ascii?Q?Y8u0k75Xun6vxrnGDC3I9eC58M7y6ENxz6EKyl9TbejHyoItKzxo31ahZ3FV?=
 =?us-ascii?Q?R54PlwD7DqD27OULAvv5EA/Rr1Hbj732vDe/IleaXzTaFF5KrqwoLvhZF/xv?=
 =?us-ascii?Q?WJtuNXOT+LrczNzkFo30QoD+yJr++LNsxHFhKqlCoi2t/e9Fap3t0xWKXR4v?=
 =?us-ascii?Q?D4vVdZfutsAxX7dGEHnnWZ2GYTMEGBaPUsv9AjgdwMnkAktqzZji8kT6pehx?=
 =?us-ascii?Q?teV0Uv4dOGg7VV33WgnnpfgLuFhsc3gWUIX+mJpDmzUbYZckCV/lcREPS21d?=
 =?us-ascii?Q?xxWDd2hGcatXpO5E+Q6kdfypfMUXClmFk/La7XjwbYU7vMBYJjqBceVMszCs?=
 =?us-ascii?Q?QAdHF/QGDWsaySVtW8AjE+klEcXYJMuIwLfhzb8T09hsUBnqQUa4vtYacuFf?=
 =?us-ascii?Q?A3LS0iAogrp39bfI29QIwooAGtn5XY+SQXNS6ubL+BBiYQzxHN3pEhUMSfcm?=
 =?us-ascii?Q?L3Y7v3+yIpQhpb6BiL9/loV4cs8rduT+iOzRWIoHyKDAAa/ysLKtitwp8GVv?=
 =?us-ascii?Q?936c1AuIMyvTLjuzAu5mn794aqNJNeja9T3zov/OSGMIGaeMu/LFS/z7lV6l?=
 =?us-ascii?Q?xjats9xclDOvxIMHabPO/fkoDMVD+cR2wggdDAdrFblnvHXQd2Pvo7a1pDah?=
 =?us-ascii?Q?Oy6j/NjhbxghZIwEoCITBp84mTHOuJ8cwyen5W/UJIgymVocfoPmkb+PxENN?=
 =?us-ascii?Q?VAysNjAaxKL/lMX0rVQ6pWunfI23y/hmXS1YgYhSJecUbakSYMt0MYUayUZ5?=
 =?us-ascii?Q?wzgSDLvJgQKEbfqK4ozCY4PoeR7sUtaEZ809uSSRynY+sTKKLCIZfX7ytXTV?=
 =?us-ascii?Q?JcOjrhkEnRMhsMNQwDyO//rdhEAHEs96JK+8ys28P2oprGdK/at19nujJDiB?=
 =?us-ascii?Q?1iB+jgBbtezJu9M05Cgyll9+6XtnZRZWvmcm0A9IJyR6abQ+e6JX1ddfSf3w?=
 =?us-ascii?Q?8B4ZsKBp1Odk92X/6a/m1C5NHsO1qOQWinmSKYlNTX5GiQHr1sQR8X0hRiGp?=
 =?us-ascii?Q?nOQ+Z1VY2gFWZRgnHjxfT0SXwdoFNUP2qb6SwczliwT/z3CflfBDFzzFPtTP?=
 =?us-ascii?Q?s0+jsYnrh9NkFTbxjgo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 512534ca-d612-4e21-699f-08daa521b49b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 09:29:00.8309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SWke1wvPLxQ3AGvGVsW3dkUvOKhgdKpALeVdV+sVYeFlD2kGKvbCou9sV1Tsyoe8Wu2+XjNTa8lod77EHZAO8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7305
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Richard Cochran

> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Saturday, October 1, 2022 12:52 AM
> To: Gaddam, Sarath Babu Naidu <sarath.babu.naidu.gaddam@amd.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; krzysztof.kozlowski+dt@linaro.org;
> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-
> kernel@vger.kernel.org; yangbo.lu@nxp.com; Pandey, Radhey Shyam
> <radhey.shyam.pandey@amd.com>; Sarangi, Anirudha
> <anirudha.sarangi@amd.com>; Katakam, Harini <harini.katakam@amd.com>
> Subject: Re: [RFC PATCH] dt-bindings: net: ethernet-controller: Add
> ptimer_handle
>=20
> On Thu, Sep 29, 2022 at 06:12:49AM -0600, Sarath Babu Naidu Gaddam wrote:
> > There is currently no standard property to pass PTP device index
> > information to ethernet driver when they are independent.
> >
> > ptimer_handle property will contain phandle to PTP timer node.
>=20
> ptimer_handle or ptimer-handle? One matches conventions.
>=20
> However, 'handle' is redundant and 'ptimer' is vague. 'ptp-timer'
> instead? (Humm, looking at fsl-fman.txt after writing everything here, it=
's
> already using that name! So why are you making something new?)

Thanks for the review.
I think Freescale driver uses "ptimer-handle" but I also see Freescale DT=20
documentation refers to "ptp-timer".
=20
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
tree/Documentation/devicetree/bindings/net/fsl-fman.txt#n320

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
tree/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c#n467

it will be good to agree on a generic property name to link to PTP phandle
to Ethernet node for any driver to use.=20

>=20
> However, for anything common, I'd like to see multiple examples and users=
.
> Do we have any custom bindings for this purpose already (besides FSL)?

AFAIK There are no other examples. We plan to use this in Xilinx axienet. =
=20

>=20
> Could an ethernet device ever need more than 1 timer? Could a provider
> provide multiple timers? IOW, does this need to follow standard
> provider/consumer pattern of 'foos' and '#foo-cells'?

No, Even In systems with multiple timers ethernet uses timestamps only
from one associated PTP timer.

>=20
> > Freescale driver currently has this implementation, but it will be good
> > to agree on a generic (optional) property name to link to PTP phandle
> > to Ethernet node. In future or any current ethernet driver wants to
> > use this method of reading the PHC index,they can simply use
>=20
> What's PHC index?

PHC(PTP Hardware clock) index is a number which is used by ptp4l
application. When a PTP device registers with a kernel, device node
will be created in the /dev.For example, /dev/ptp0, /dev/ptp1.

When PTP and Ethernet are in the same device driver, This PHC index
Information is internally accessible. When they are independent drivers,
PTP DT node should be linked to ethernet node so that PTP timer
information such as PHC index is accessible.  =20

>=20
> > this generic name and point their own PTP timer node, instead of
> > creating seperate property names in each ethernet driver DT node.
> >
> > axiethernet driver uses this method when PTP support is integrated.
> >
> > Example:
> > 	fman0: fman@1a00000 {
> > 		ptimer-handle =3D <&ptp_timer0>;
> > 	}
> >
> > 	ptp_timer0: ptp-timer@1afe000 {
> > 		compatible =3D "fsl,fman-ptp-timer";
> > 		reg =3D <0x0 0x1afe000 0x0 0x1000>;
> > 	}
> >
> > Signed-off-by: Sarath Babu Naidu Gaddam
> > <sarath.babu.naidu.gaddam@amd.com>
> > ---
> > We want binding to be reviewed/accepted and then make changes in
> > freescale binding documentation to use this generic binding.
>=20
> You can't just change the binding you are using. That's an ABI break.
>=20
Apologies for confusion. I am not proposing a change to the property
name.I am simply trying to document the correct DT property name=20
used in Freescale and then move it to generic ethernet-controller.yaml.

Thanks,
Sarath



