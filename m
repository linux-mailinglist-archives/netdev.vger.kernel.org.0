Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052296335A1
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 08:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbiKVHF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 02:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiKVHFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 02:05:24 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8262A97E;
        Mon, 21 Nov 2022 23:05:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ki94M/VJVB/ikaqu6oqe9cak0CpuFWSquwuNANk7Be1ALcjWKuKYJNP1ERELhCHIB02USh89DFJGeE/9nA9SuaDuYgclQD2WdqgoFceJ6nqAumzIExmaAfsl7Hbae1SEsbLKWGF5kz7sHgoebUK3e/knEQUC/5VTEmxC4+Y4K1xiIlxQ13s+1DrcICPrvOddYI5WjFkY79KKHL+jpo8DRYuFJ5st22SZZw04ce1zBFpK06Nt9Y7+0zMbs35Y+1+RESx02gCDejL+LsYk2AzgtHZeCXLeCIJEOV4PlbdmRLtIyA7L+HIggrfr5rTVKiqCUJ//NxykxnU4KlKHiGTcig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2OKIb0JgiKdz3zhNdqXUyAPPBO29J3jDsOXnU3jFeOo=;
 b=El196FtQZGU1iBIsSJXiIiumJ4WxNG+go3HldWWykLg+FpBE+elObPTKxm5E6hSg2zRzqi3lTdfbiWYxKxtQNvqkjLlgi+ZrVrCJaBFvrf9RD+rBvU6/7ziFBvxIwNk0zzFtHClF+r7EZOcQy7zNJkPqdNMVcvvNqheGIq/RmzeDiEk22wjNLzwcNT7yyHz5HsdVCBn7+3s6SRHuxO8/9to8phq1v/X14M0uoYGLpRMhtrEAc03V1YL/dHkWmKNDUfHJLFPWpd2eCGMTG03wJ6REfrvGMuJ51TEdKKL6hsnuTRITqd7qSQTUcrVgmZ3tTH30wzgF3fzK6AkfJnVkjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OKIb0JgiKdz3zhNdqXUyAPPBO29J3jDsOXnU3jFeOo=;
 b=GFDMUpJ5nkJmQgF5vEahAG3RUfLv14NMFEh4nv0WP6Cu8urbN27qGoxnWp1c9Gdf+NhJqWr8mXqOCGFF4ymI4HyhtGwsNGxZnxfusv4O5PWwpJg3dExoMYusKrD0hzEt5km0h2cwsXErEorV+YcJ0pd+1z/5i8SkYVIwnAUCm46fq9WzohgKBy7oOfOddSitXnqauFFUM3GW6k49iXWaTDVi7qyQDSKFor3xXl4sANtRIdp1b2bF0+aOjiNQe+QYGdQvS2bOFHuAF8Gqmi2J+RcJRYVc9gQYy+X7+FGVEZcf5GwzUCZeXAOAVdpNcdElfRRDpJ5ecVY6AnpyksIOaA==
Received: from LV2PR12MB5727.namprd12.prod.outlook.com (2603:10b6:408:17d::7)
 by DM6PR12MB5024.namprd12.prod.outlook.com (2603:10b6:5:20a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 07:05:22 +0000
Received: from LV2PR12MB5727.namprd12.prod.outlook.com
 ([fe80::649e:8cf:b4f9:f97e]) by LV2PR12MB5727.namprd12.prod.outlook.com
 ([fe80::649e:8cf:b4f9:f97e%4]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 07:05:22 +0000
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
Thread-Topic: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
Thread-Index: AQHYz0KK0TEm2qmBmU241dJjBKAgHa3zjSuAgBbAn3CAOq+oAIAF482g
Date:   Tue, 22 Nov 2022 07:05:22 +0000
Message-ID: <LV2PR12MB57272349F55FC1E971DA64EEAF0D9@LV2PR12MB5727.namprd12.prod.outlook.com>
References: <20220923114922.864552-1-thierry.reding@gmail.com>
 <1b50703c-9de0-3331-0517-2691b7005489@gmail.com>
 <LV2PR12MB5727354F4A1EDE7B08FBC5A5AF229@LV2PR12MB5727.namprd12.prod.outlook.com>
 <20221118130216.hxes7yucdl6hn2kl@skbuf>
In-Reply-To: <20221118130216.hxes7yucdl6hn2kl@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR12MB5727:EE_|DM6PR12MB5024:EE_
x-ms-office365-filtering-correlation-id: a1a645df-dceb-4b04-7583-08dacc57ec36
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dWmxbIKJLHDMPIykuIXPk2i3HQm6j+ytAgk9loyNj/5eJfi71Ej+5Dkjf5mRfutWk3OS72gAz6LvDNqX8JJ7P1la+J+M0ZJsm4WPKeLzUpfZAa/CGScAcKUAeISYMi8jKAbdyc0femUHDW7E7cApnkr/6bVcf9y0lctPdzTcfeEvEyMOGGicKt282uWka8wfBh2/8JU18853Gsk//4cW4dr+dwwTvJNq0DMn+alkV8cneu8mMuKgzIMawuQG8M+ZnGNI+DoWbrPX9I3W6KNP+M8QOjYElqrhBMuYqLrf5FRluNGQxUBg+1XerH9SB+6m+D3MoLGHxcDpZJaGvK53wZhM440N/4p4dVRn8GF93dDKaWWThE4HFNEcpJYxK9AazX2ai2qRPIETXqkIoZhrvGPs8Ey3l3F/LoNqGv4/ELRVkC0xd9Hs3FjrFmmzBRYgEldJ8judWWd4feWzSgjb03BXrwHOe3jFXhirZhFhHPLVhpAgNrAFTLXezB9Hxc7LgxodEemkiQLVqQHSN0KkZHb6zN6eKu3jaa9iLJL6hkg3IdVOq1rW01QS9QASeJ1dwB4ePeFM4/1yfgmJgVcJwMewf6WZtJnqCsQ+fLhU/qmGHfV5opJOjKRo1ZAF+u/3h2OOA5QTr2iwyrlJQxetApYuOhZXTjvgrOWG6kSA7qm5bVR8vs6MUzMMknHmVM2A69QglGT2/V4uXADvE/z47Lgs0UF5QEAn3OA7Lv6TIFRU3DPWm2LOqw4zP5DgKVG5Hv/YRBxr2ZlKibz9XMOWdnoh92j/hGNyXQNIdQbBy4s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5727.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199015)(2906002)(33656002)(76116006)(66556008)(66946007)(55016003)(53546011)(41300700001)(86362001)(4326008)(66446008)(38070700005)(7696005)(122000001)(6506007)(6916009)(54906003)(83380400001)(38100700002)(52536014)(8936002)(5660300002)(8676002)(64756008)(66476007)(186003)(9686003)(478600001)(316002)(966005)(7416002)(71200400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZZGg2NTUI53JQseOIdWKuOdvdkrbiqpokOjYK6nbYBuwLETvAG0dy4LuDxMi?=
 =?us-ascii?Q?EhYx0JGdqczPHHYNvx2CkH4Rx1qu89wR6z0Sm9UPFEJxn3+nb4tkJKY6r5Ry?=
 =?us-ascii?Q?KV9or/NuxjUDwldcBxyeMhBhsxqwVZuog9RBD7B6PjfvrWjBhm8hsIPhpnxW?=
 =?us-ascii?Q?VUIO/3uW4q4C4HqxX3J9jks98odvttkXThOtD4BedRE+gezAnbD3+tQKOr9w?=
 =?us-ascii?Q?aU9DrnV4FJ6KFhV6pdv5SMU200DVhXH2pDErXNKK4hu2N9ReVIHK75ffVOJd?=
 =?us-ascii?Q?Yo0MyfvmrKrOaEaQM9WuY3byDqWbYpO70lecWDCvmsQmTBws3h0+vO6qvB2s?=
 =?us-ascii?Q?dylbFcEpzleAIWLG3bij73zUm2vnVNxaz3NI7a3ADahBrpiGedDPgifvdnES?=
 =?us-ascii?Q?d2QeI03JrQq4fyDjDYQdVYZXfjhlOO4XpD4ngfuEboPKtsUBoa3hie83vdRM?=
 =?us-ascii?Q?q7gRyo7a/OjvZZo9Af8EHHRzbPrtzHhUlDgeDKAY0QbyLyKoMAYzVMjdyVyT?=
 =?us-ascii?Q?E89PFS/VBq2WtOVbGi35kyOxEkjeBG4/73LnkS7tYxbrIHfXNQtSVAZkuUbV?=
 =?us-ascii?Q?k4jUVB7tXootkY0a6yr/ik6/Dpu46EPW/vpyEinV5YbZAdR1SjSe0exY5yoc?=
 =?us-ascii?Q?WpveUQ8gW92xezfnuAQoX0yM9TVnv9SEjk36Qxe5k5O+VvxVakerNzrnQ+4y?=
 =?us-ascii?Q?Gna7jl4T7c/7fDJMoVnd7vRuq2lejm/rz97sb5Xju6jWqVR6is/SHHSKCZxG?=
 =?us-ascii?Q?lgyGTMtLCwDOPC6lvOB37Qc49yXSv4d4+ixollsK+nFHMRSX+jlb6F6jFowb?=
 =?us-ascii?Q?NI9BRZy4X5cjF1RUAjb+OLi9b34Xp2OD6PiAvCUCAG2WsTaE1BH2b9vwyt1+?=
 =?us-ascii?Q?yLXg9pqSEb9rHlJeiYVfBR+g6bO+RjbKqGlPM6jsahI18oJkp2ymtqV9G2tA?=
 =?us-ascii?Q?eBC6wjU1XSI30VNNGVNMAXbRmy9WByVzGDsy8OMCWwT/rEdnXTFYjRxgGV8l?=
 =?us-ascii?Q?SI2wKhtaLmtHhd3Gx9dytgmru4blB66hr+N3yLrDluKOifF99ELLQt2/TGMn?=
 =?us-ascii?Q?OQcFXPlW0C1NNXg8qcCKjEXac54xzp6nVQnqePgnPC1V9KHUZEr2hbWx7fJ+?=
 =?us-ascii?Q?IyGyTwEsUztm1HV0vae8oxdgCtiJgEN5FYQWBk4/RYnOdDXDF1kqlzUYjS9K?=
 =?us-ascii?Q?EQoNjKmjqqYPmueIWm/AwWjFAt0sfd3f+7Cipvt14CijQHbZZljmVUWiLb1k?=
 =?us-ascii?Q?TBcdwIHE1JJWvRxA52PgM2E4MFlzPrR6mBP83niwzB80cIeVO3iy5pKhVuzE?=
 =?us-ascii?Q?AH5KhZi4IV2ddFWpeK5zdmXDOI5Dxi3TiSuOphHGOe17WExe7nlBgA25cXzL?=
 =?us-ascii?Q?OweSlx2aa9TieMzL+Ee8WWsKs5pwLLPwbbploHL0U14CPYjGm2R4B8aOCI+M?=
 =?us-ascii?Q?8UrDlNq7qXLYktz7gqVZrfgsDnxEMmGGa3Y5pn2KQHV/p03upSSySmygDdwB?=
 =?us-ascii?Q?tNyNbkO5lSMjltvjr3bMVqf2RPqv23Z/mjqFq91ux7mk8hTmDsZHntYNlBdU?=
 =?us-ascii?Q?zo0C+us6+1CJLACQyBAKrnMmqFMzdqqV2Y7VIYTi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5727.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a645df-dceb-4b04-7583-08dacc57ec36
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 07:05:22.2934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pKqnkeBnF+oCatU+XroyuB1EldY2NtdjjrTmVBPRh/6budVKZHvGYhj5nsJVXOQd/Ak1UBKZaUYjkUVispG/xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5024
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: 18 November 2022 06:32 PM
> To: Bhadram Varka <vbhadram@nvidia.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>; Thierry Reding
> <thierry.reding@gmail.com>; David S . Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Russell King <linux@armlinux.org.uk>;
> Andrew Lunn <andrew@lunn.ch>; Revanth Kumar Uppala
> <ruppala@nvidia.com>; Jonathan Hunter <jonathanh@nvidia.com>; linux-
> tegra@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> Hi Bhadram,
>=20
> On Wed, Oct 12, 2022 at 04:56:52AM +0000, Bhadram Varka wrote:
> > > You should be modeling this as a proper PCS driver and have a 'pcs-
> handle'
> > > property pointing to it in your Device Tree.
> > >
> > > The configuration you are doing here is probably working the first
> > > time you bring-up the network device but I doubt it works across
> > > system suspend/resume states where power to the GMAC and PCS is
> > > lost, it also begs the question of which mediums this was tested
> > > with and whether dynamic switching of speeds and so on is working?
> > > --
> >
> > For Tegra234, there is UPHY lanes control logic inside XPCS IP which is
> memory-mapped IP (not part of the MAC IP).
> > mgbe_uphy_lane_bringup performs UPHY lane bring up here. Here
> MGBE/XPCS works in XFI mode.
> >
> > Agree that lane bring down logic is not present interface down/suspend
> paths. Will update the changes accordingly.
> > One more thing is that UPHY lane bring should happen only after the lin=
e
> side link is up. This also will make the changes.
> > Please let me know if I miss anything here.
>=20
> What about the non-UPHY part of the XPCS IP, how does the dwmac-tegra.c
> driver control it/see the status it reports?

Reset values of XPCS IP take care of configuring the IP in 10G mode. No nee=
d for extra register programming is required from the driver side. The only=
 status that the driver expects from XPCS IP is RLU to be up which will be =
done by serdes_up in recent posted changes. Please let me know if any other=
 queries on recent changes [0]

Thank You!

[0]: https://patchwork.ozlabs.org/project/linux-tegra/patch/20221118075744.=
49442-2-ruppala@nvidia.com/
