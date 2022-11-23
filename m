Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F898636D3A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 23:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiKWWgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 17:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiKWWgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 17:36:36 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130045.outbound.protection.outlook.com [40.107.13.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F7A11E713;
        Wed, 23 Nov 2022 14:36:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdSWFCl2V+yT7SmoU/xbf7QyTFl4U8fx0hMtdObCwSLdR1fMycQD/GWPn9bZfX1tPKjpsH/y7RiA3iNWK/MJpBu8H2UScMKfxFKBf1a94RJq2GAhIbhsEQ+VD1ReA2BSVnTAfItDId6XlyrzP3Kk2jl4Iwc3+c6wLlNeQM9aCQJfusABdpeGjysrIgNKS5aEPVPwRse4L95yQ64sASzIUswDOszbm4mYsuhMcMvqtbrjCNF2K8358yvMRDglKJIGgIuMlEFbbRja9Ovvgs4c7X5GTOb/+gceXpgOBtPZB4YHnSGlgnQAq86ZOFe6hqrR9XXMMMBmDEh3WKqBE2qnKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXXvw+sy9v9xmt0DHrwEk1bahk4Cayww55aEDaIekfw=;
 b=oBau4eSBqGzib2hOKei4nDWKKUB6rvXC3eoAxNoUEHxn4M+f0MIccK9FpOuT4KGy8aV+n3+xrwLjHFRbE4dyy+aQSi6SqLxfuodg8C/tcAsMfSJlnw2BFgDXSlOZnym3CgdadWNg/W978BLr1T/0rS9fPKCvdq1XFRsNSNjcMhO0pkjaeSG8QDeqZQOZmHaamBg2G/O08a6yIN5dLOIpZ8XzVogPgrq14hN77PJ5vtvaYyj1m84lcLftx/tIVFTe/0JeXn6Nv4Hh8eHsLOknFd+HkrmuAiFDtbRhEt2WVdTCMisrCb5sAEv4DEufaLTs8X7S5MwbvkM+kQjL7n52FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXXvw+sy9v9xmt0DHrwEk1bahk4Cayww55aEDaIekfw=;
 b=sxJBT+0sQHeNGiyez5PcQl+RJr9LJN0AX7mo5kHyiwU2h5RODdHgoKdBesX9q3GMPSzL555Ra/CrygFJ4bCFrvrayKKASHNf6kFrCQjurvU9CxafZABFK1nc8URiYRr/jR/3xEDKGoIcSEkdAXOzWzUJHCMeQFtdE387TBSrXBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Wed, 23 Nov
 2022 22:36:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 22:36:31 +0000
Date:   Thu, 24 Nov 2022 00:36:26 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Alexander Lobakin <alobakin@mailbox.org>,
        Alexander Lobakin <alobakin@pm.me>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] dsa: ocelot: fix mixed module-builtin object
Message-ID: <20221123223626.xpztd3jlnfv7isq4@skbuf>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <20221119225650.1044591-15-alobakin@pm.me>
 <20221121175504.qwuoyditr4xl6oew@skbuf>
 <Y3u/qwvLED4nE/jR@colin-ia-desktop>
 <20221123214746.62207-1-alobakin@mailbox.org>
 <Y36cGl7wLM3aGeI2@colin-ia-desktop>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y36cGl7wLM3aGeI2@colin-ia-desktop>
X-ClientProxiedBy: AM3PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:207:1::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7281:EE_
X-MS-Office365-Filtering-Correlation-Id: 880cff13-c1d5-4f98-2f0c-08dacda32ad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJKFivw5OqTfQQExnOcFPRXrbRsfEt5js4mLMpCCGTiW7547C5AFb5jTIYWcXvzkNWvCSOECdVWRWSIQ2+/iYRdI2qFkIt0X93rOxbL16O2EJZBE0tJ+xplcyKILG2BixNRiCpFiiPoxPFEOX+S72xvcqUkWxHZDYwqjoTz5fc0tDZAOjyYxguFsEipNRygSGrr+nGwkNpiKf4ypKcWYts68pmaEiuiVwBQLszcXi4jhoTkor8hdHdpOCA6XePebn9Y2vvNmy0FnYUojsWLr3C+IQCamDlXmzKh10zhi7Gui5AJ1j7VHLN9FKf/+Gc7oOalfQguYLdPiRGeQ9vCjnJ+ncJ7Jw7ktVIfarII+RRNU2b4zxFcXsKxI8JUdbKapqs16cVTpfxJTxNrRiL/zat3ca8Z1GSpEdfsUkKlupZEgm2bensAWgZ8Qgoh987NwmGWhDhv5R+aOfhPQYgSA3Bs5Y4Ty9LHup+6mzPtZhkr/+gy4hgLbAtF173idy2nu1M2z9zcBDP1R/4WuEBKWTeOyobQV7ls3Qj6a7duwAj8VYpCVHBfC5sMMzd3yG/Rqo+8kftR6uqAMnYdvYqbJmhH/NGOBURydbIoEzG8v7qBCsVhIWK8tdpwR1Ir2aCG/Lts0jA2n9d+TCeu9NfpbHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199015)(6666004)(41300700001)(478600001)(6486002)(4326008)(66476007)(8676002)(316002)(9686003)(1076003)(8936002)(26005)(66556008)(33716001)(66946007)(7416002)(186003)(5660300002)(54906003)(44832011)(6916009)(6506007)(83380400001)(2906002)(86362001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bHztFamZv9S1DTLdd50j4798Fx++x8CIkvJtNJ0Mk5T0G6p44P0VqAjuc9/R?=
 =?us-ascii?Q?HrD1LTtNtPt2H550Sg16XPOpl4iEhlmTlWLh/0J2zZjm6n5mmFdjxd27QLuU?=
 =?us-ascii?Q?ESm/OTvvkG9TLAEOzrwcH7mfjXsG4MhV1tqM1XNwFixzoZCnjmbklSnU2mwj?=
 =?us-ascii?Q?98etUTy4bILY68ra3fHL77vQiGcmrHkeIrT0bce6bxNNbbNxF8kx4qMVnvwF?=
 =?us-ascii?Q?mvvr/nXG2wzawVTfgkpxUWbEIOttM0U3b0adzr4FahPg+iYyEujk/TDu280H?=
 =?us-ascii?Q?0Y2iIRh4ogcoDVh4S+scZ5QJzZ00nt8zzY7P5i8kbcfre/rUAtkvWJ66JCno?=
 =?us-ascii?Q?OlC6EPRNX4slqgASNSnkUJhAuFNVOHjIpYsRSadqky85aV5Yk0AlXrKYavNv?=
 =?us-ascii?Q?7gx0pARMczB3YapyiK7F0mZy8gq22hctP0NutKEfH5IQr9IP0a5wxwqYnhO7?=
 =?us-ascii?Q?y7mxeCbIkvitcP/VF941VKsvjBOfYEZNcQiFN/MCFe6V0RYQH/PgRnD31knZ?=
 =?us-ascii?Q?9ZhkVCKziUvcBxp/HfJDwGFaFab3q7aDpzx+PIUe3Q3mKmk6GKEcJuvhZnUX?=
 =?us-ascii?Q?S6Yz0kQ5aOt3wPdMbWXgUSxZEzYU0GqUC9JYBjOn1SbLbsNPs5et5x8U+r5c?=
 =?us-ascii?Q?z343C2d8MnEgb7xoTv1k4HFz0RdM0stRLJ0aHWuJ3zEwOj4pjOuMOJ7CdwZl?=
 =?us-ascii?Q?y9mXgab16J6T7R94GZKRZzcUBz7vrTmNoowZr/4L+NjmLbe21zBsIJSH31As?=
 =?us-ascii?Q?jVDB5nyf5cRbhLMhD+jvNUUDesYbLwWOruwksls06CLY4lh/VW+2d8ahLu1e?=
 =?us-ascii?Q?6j9AXF9iG4+iA/o7fQ3D6fvCE4KmEQ0IBKu/f0Um+pYdXrGx1IogIAr7FD6r?=
 =?us-ascii?Q?gzmbGStvXkbAdcaYZEwNSJ6Nig+YIugIh9QE4PWdvlPUN+P+CJBRj2K8/mVH?=
 =?us-ascii?Q?M5iQFecChshXod9/I+WiH9T2OKMEv33Kjpv0K07q0BWrpPEcgvREp/H9unTR?=
 =?us-ascii?Q?+dGLjqGvsMJ6u0OeCygyWILKLMhb9Od6EQ/Wn+LP1vNEh3FXm4F07RPjVY4N?=
 =?us-ascii?Q?hhi6wOXjupeeGmLnxrArCJYKVgu+S8eIgUX7JKJHdQpiA+JU3hX6wzMr+IVS?=
 =?us-ascii?Q?ZjsW4lIyWlc1eOBgOmJ7BaedlKNqLHDwKg4+pImskFIZTK6CRFKaqXv9sxyz?=
 =?us-ascii?Q?IV4ElvfBcucFxq0cPO4eBaWYSxqNghoU6nvPgWbTylR+BJfC6ok+cVWjdBjm?=
 =?us-ascii?Q?1YqaMuBay2wOfHNkwaIuq1XefUfnszXYOZzSKXCc9z/LUwb0Cf9Fv3nxchL+?=
 =?us-ascii?Q?UYjMYUB67pshdk0+ZCZb0PjuaLcTlt+Nc+EQmhPBYGOa1UiqPUp6LPV/1GXj?=
 =?us-ascii?Q?cRqHvONa/nuxXd5gQgetrwNEQZycC0gp3ppoxU+ZGLRvIaz1RLnl2EIzcz/k?=
 =?us-ascii?Q?hHuJI4FHeLTtaR/R2SG/+a5h+M3oqolSbnNTL2c2BNTmZxTTFL2U52TKCYEA?=
 =?us-ascii?Q?hUMQ6n69y+01R48FN1qEzFU02vkkQEGu3VMFA9fegUod0oGRK3byBAzGcfMb?=
 =?us-ascii?Q?b9L++92F0tawxzTmumSlWq0cS+qy8CTp/WPE+dMVAN6h0j+JPkBidEvOqIsj?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 880cff13-c1d5-4f98-2f0c-08dacda32ad2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 22:36:30.9377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Kt3b73nlQdW0O54/DhlAiwIuOLQJczTVGdgXxPc71VqXr7xoy8ABW6i4hlHjTnOkW/7tO7fo1vcdMBS5D+l7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 02:18:02PM -0800, Colin Foster wrote:
> > The thing confused me is that one chip is named Felix and the other
> > one is Seville, but the shared code is named felix as well. So at
> > first I thought maybe Felix is a family of chips and Seville is a
> > chip from that family, dunno :D
> 
> Not important, but in case anyone is curious:
> 
> Ocelot is a family of switches. Linux support exists for the internal
> MIPS on some of those devices. My understanding is the switching
> hardware is licensed out to other chips that can be controlled
> externally (e.g. PCIe). Felix was the first chip to do so with full
> Linux support. When Seville came along, it utilized a lot of common
> code from Felix. Thus, Felix is a "chip" as well as a "library" -
> specifically the DSA implementation of Ocelot. At least in my mind.
> 
> (Note: I haven't verified this timeline back to the early days of
> Felix... I'm mostly speculating)

I'm not sure marketing would agree that Ocelot, Felix, Seville are part
of the same "family". They're all Vitesse switch designs which share the
same core architecture, even if some are sold by other companies.

The Ocelot switchdev driver came first to Linux. The Felix switch was
very similar, except it was DSA and not switchdev. So when it got added,
Ocelot became the name of a library for sharing code between a switchdev
front-end and a DSA front-end, as well as the name of a driver proper.

The Seville hardware is actually much older than both Ocelot and Felix.
It comes from the same family as Serval. It's integrated into old
Freescale PowerPC SoCs. It only got Linux support late in its life,
when it became super easy to do it, basically after Felix paved the way.
When that happened, Felix also got split up into a library (for the DSA
aspects of interfacing with the ocelot library) and a driver proper.

Colin is now working on a switch which marketing really would say that
it's part of the Ocelot family. Except it's DSA, so it has to use the
Felix library.

Anyway, TL;DR: name of common code is given by the first supported
hardware, it's quite a common pattern really.

What's more interesting to me is the strange humour of somebody at
Vitesse (now Microchip) who gave the feline code names for these
switches (Ocelot, Serval, Jaguar). Felix is none other than Felix the Cat.
