Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60816361BB
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238546AbiKWO2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238818AbiKWO1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:27:14 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130082.outbound.protection.outlook.com [40.107.13.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78B06BDC6
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:26:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+FSDZBiReJd7mnGqU/fPAyN2STvCrlu4q7/1o+zGykn0Ywftd0hwqVicCKoS0xmSYTOM8Dsh2laJDrKmgyYfbjD3I+KPsvhRTZJ09bhnDv+/B9FaURhvJ+p3APzQQLJTFSqzZzc2k/jpTwlKwz68j3tadYQn05w1bHPy2PV0bM3orbHGji3ELUvGg2g23K5Uicplf5m3KMyHDdvNMjOUGrSwKncwX/jMlebZ8f5tImVs/rfFwAeV8IjPYv3Rg2RrXUizkRq0EYSUnX3puiCp4Oa2N7lPmx6KQapSfdBcL8lNCXErCeMiNjcCgm0VuNCxQPXaNoSzXyofuIFZ5SKFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tK2tF661Ccn9pi4x5bhUlWCBrlh3WbaRIZDLh5zap2g=;
 b=YgccYDpgzeouFqu97gYG6VyyKva62W9bYQt5J06Spg/A64rSk8iMW6kdUHmfZfhk1v52yn+R2NzPlz4ot4byHYJieoKNdxwwDbA3+OHLQUPPqvhll49WHw2Q2VOIsSgT077N3ima9AaD5lHGBiRmEQxxo5GAYq6Q+L4chabu5vZnH0j93uh8vj8P49SuB3cxAC44+5zFDC4kZUnTRfq7fMsEvd1MW1VRjmQ4c54rh8HbjRSjW/uzBCH53tqE05hW4eENt0aOCVOSn9InBuEFZTm3D3aexLvwplYPTG3zKxAG+rxVN/jE7NnkaickmMM9b7r7Sv7cc1hEwqJJz0g4og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tK2tF661Ccn9pi4x5bhUlWCBrlh3WbaRIZDLh5zap2g=;
 b=Lb6dMJPJ+EaoQ75TD8HRzBKjdtFYwJnmurptrojrYGsSM1VJE16Q+l7oS3jjE2xY36WubC3FoLaaNAoeREcKGlxYoBD/6SIP6lxFeovnjQP90I6djcoWwHKQdVjLTZPZx6uCKV2aZNEqEvsSDqWFEohCVcsqev0U+javfYqLWT8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8192.eurprd04.prod.outlook.com (2603:10a6:102:1cd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Wed, 23 Nov
 2022 14:26:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 14:26:17 +0000
Date:   Wed, 23 Nov 2022 16:26:14 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Steve Williams <steve.williams@getcruise.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
Message-ID: <20221123142558.akqff2gtvzrqtite@skbuf>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <20221121195810.3f32d4fd@kernel.org>
 <20221122113412.dg4diiu5ngmulih2@skbuf>
 <CALHoRjcw8Du+4Px__x=vfDfjKnHVRnMmAhBBEznQ2CfHPZ9S0A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALHoRjcw8Du+4Px__x=vfDfjKnHVRnMmAhBBEznQ2CfHPZ9S0A@mail.gmail.com>
X-ClientProxiedBy: AM4PR0101CA0056.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: af1f4acd-7ca2-45be-b60b-08dacd5eaeaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1Q/CxzkSMzCNDN2w3vppy6b7mo0vtltZjjl8058ehG/IP1mXxSFZYv8HZZc61qT6F07fVfLrjRUQGWmIui3FSABaXI6gUdMCpa3X9XoQSzmPB9SSWR6FmINtgUp1q6T+0nReNbGzmWLgjZ7JRcQHyWGGT3gx9lvd6Qn+zNHGfy0qmCdcA5NC1eki4GPf02xNvLjPQumUwwWN2CFXh7it5zDitouWxrQ2GkB0x4rNT/qoyDZqgbdAYfuTQd5WaElOd6Vh7Ba5ZcE7dyoyFHFh/0OkiuvE5e/6zuhu8MHiTELAWOy2qOMzpDSocwjjkxt80x74iAC19mK+cJYokPnWi9kF0s7PU5yqtw9qzXYsgj0HAalsmn178nKKpZ/8aYE8lxqD5Ovp1e2kNu9aiAYo/ydSHJU8yJ1jr63E3pAdGZkwejQprWOBA47ZjnNkb+uCDpMeAudz0QRIuymw8/OGoBSowq5tHcJ+bU3ecMQd7qZEru8J/D0CWv3DKWhipXcknXRg9mvks92H+KGSekiMDry7MVmmgI6jUsZT+70e1pE0ev15KccONlUPaVDMrObwafza+wgDGtfzja9Y6hGRQblBWqPSPK5w15273jJt+DHTySGHGGsNaKkkuHkN6WU/XGH0Zr6YxlI9xiaVU/EyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199015)(6506007)(478600001)(6486002)(54906003)(6916009)(6666004)(1076003)(41300700001)(66556008)(66476007)(66946007)(4326008)(8676002)(5660300002)(8936002)(6512007)(9686003)(2906002)(44832011)(186003)(316002)(26005)(33716001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QrV2SY4OCompRj0B5V/N1/YtE4NutsMkNtpP6E7DX17hZyK9NUN6Is+a1uYb?=
 =?us-ascii?Q?etmj3JXhjNKbc4vNXkEq2GnB3RtPQ8mJoGmEL1rVOseT23hT7IDxMxxNyJpQ?=
 =?us-ascii?Q?fpyveiYKFo725raow2+TMGNB/KPniUGK05v0s6nUtQYS2/bfLS0JrPoo6chz?=
 =?us-ascii?Q?4aH2eC0qY0nIb3nlW9RSDlhGNMT2yY+RcTFfWCkVu+80h8F6lcuvttbsVJha?=
 =?us-ascii?Q?3KhK2njkzpU1C/BsxXwhQnR250KEdvCbPksVDK4lOn1BrHQeEtbXjKaM8kNS?=
 =?us-ascii?Q?zo5vLAkaotZv6I8Q03RZV3QVpwEN8Rp3t+fscyYKS4vG+caLeGJQFoXOVeEv?=
 =?us-ascii?Q?VFfiwUEvj9qfNqmBbom3vYxelyjLFd9P0maUtVXNNKiZMKwwwZpUmYtPd0KU?=
 =?us-ascii?Q?9SdpQebqsCz8x32dbhL61EOpiWpIGzemol8zvOEq8gIj1qGRl2fSPCuuIJje?=
 =?us-ascii?Q?jN/Egu2Mpk75bxgoujqWsxyFjhxSz/bRK9Vw5bNaW+14tUk/XCtZQBKuWMch?=
 =?us-ascii?Q?BWVSFZaLUIjO+VYiUIykOuTLGbhM+gxBAtcMd4y3hiLLzgWfCSibYPz19nrq?=
 =?us-ascii?Q?/dPQJ9XaN/+/bzuDTXAQs79ZokxM+eDqk+JJABSiynv2tX8th6fJbH9asnKa?=
 =?us-ascii?Q?EsrhdYfBnYpgZdnk5dRSC/h4ReiL1dTXtFi9YvwRMSmQco834953XGOnQrU1?=
 =?us-ascii?Q?22P+T6g92YoQbIo+8KE3eLHQDT1MWjwY0prqowdDIimfFTY3CvFR3L7QxJNm?=
 =?us-ascii?Q?M3Xsu1/KELRZSwyK8t6vQ6YEQpkKwOBBy9+14BdaUKUz2P8jnNvASIC8pSwU?=
 =?us-ascii?Q?fRfpGiZdFtxzHPqC2lqUqSlcNiBRjGIjtJ3gMSS3AXbONyLdbxcgDcsBntBG?=
 =?us-ascii?Q?WhclBJDN7yZFPZL+BGbLhWrOjNaVcE3PqTn7z+l487kiM88rfl8E4kqh6bn1?=
 =?us-ascii?Q?Ov+aKP23DXd3OcOIKTMaONXf0RiaGQkTlKtkZO09Kpowt2jeRGkjZL9Nd7lm?=
 =?us-ascii?Q?pJr9U3SegZouUr6Pii84fJWU1OYD8RVLZ+aVDhzBRtgvLkxgQgvisLpkPJP0?=
 =?us-ascii?Q?q3P8R+y3I7C96317UVbba3FHPhVZO/f/wymPebB2Byhrlw5+n3JzhCziC3fs?=
 =?us-ascii?Q?pAuFLLLa1em7OBES+co7kADn6soOD4VbXqHgm1R2B39k6ULzLXCm+CHangUm?=
 =?us-ascii?Q?qk2dAGAW+E0a++0RJRDZuvjNvXhmqmMvSplinBUKZ7NUrrTeC6FD7cARieFF?=
 =?us-ascii?Q?CWMoXG7PNLw0mm13Zu9MAxmpG8z+O0lKfsSa+2V2gItLfPFHRAhhdNhwHvs1?=
 =?us-ascii?Q?vHQiQ6tIE+YOyXBniMOWrYur342ZuycTTs7WuZZxZiZA2j9OOm1sWSy1bDg2?=
 =?us-ascii?Q?oQyt8jI697PD0/ul68e4d3i8f3oDW9qLxRfRO/DZWPqFWdTRfCY1JBc5bLJ2?=
 =?us-ascii?Q?x/TYe49OftZl+AV+RjPkQGcyRZ1oomG5uRw8DJuXvS5BEj2ZZUdHf22Ad5uw?=
 =?us-ascii?Q?I4H3RvJPZ8HjPgEwKcgRhGxi5N//5AdnfePtNGBlcUOua6us9lOu5Qkkliwr?=
 =?us-ascii?Q?zRNDoYDknZYU+wuh4ALekX2ShSBxXBqlZgmZl+oj7m85XEde+b8kZfU2GbiA?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af1f4acd-7ca2-45be-b60b-08dacd5eaeaa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 14:26:17.3795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/+T+HbIF+ATHNA9n3QyZhajQa5DWm/X+lttbqiApPtpB+cgE2NgOdLGOCnO62Thfog6NkLfdE9CN4UgZgOV4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8192
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 12:51:53PM -0800, Steve Williams wrote:
> This driver provides a way for outbound traffic to be tagged and duplicated out
> multiple ports, and inbound R-TAG'ed packets to be deduplicated.

> Hanic tries to make the R-TAG handling transparent,

> Generic filtering and/or dynamic stream identification methods just seemed
> out of scope for this driver. Certainly out of scope for our needs.

> Yes, hanic implements a practical subset of the standard, and I try to be
> clear about that in the documentation.

I'm back with a more intelligent question, after looking a bit at the
code and at the problem it tries to solve.

The question is: why don't you create a tap interface, and a user space
program which is given the physical ports and tap interface as command
line arguments, and does the following:

- on reception from physical interfaces, handles 802.1CB traffic from
  physical ports, eliminates the duplicates and pops the R-TAG, then
  sends the packets to the tap interface
- handles packets transmitted to the tap, splits them and pushes
  whatever R-TAG is needed, then forwards them to the physical network
  interfaces

Then your Cruise 802.1CB endpoint solution becomes a user space handler
for a tap interface. To users of your solution, it's the same thing,
except they open their socket on a tap interface and not on a hanic
interface.

Reworded, why must the hanic functionality to be in the kernel?

Thank you.
