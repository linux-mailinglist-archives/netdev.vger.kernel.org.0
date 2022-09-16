Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D675BB4AB
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 01:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiIPXKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 19:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIPXKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 19:10:43 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2124.outbound.protection.outlook.com [40.107.100.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C6C2019E;
        Fri, 16 Sep 2022 16:10:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpXVWipsOVZZdnTfNYIiAprz+Y3oEOqEP0lY9x6IxnzBDUhy1TmwAWLMlQSr7wjdjTb9+6el9EoFI7FskAEFA0xAMpxI3SGvQvT5XNp1+Zk8IEGTR2wIiL2ad0wh/PEh0FKoFooEzTsvn+N2G5bzfmvUNFWSBS9sDbuKSuB0xvCJpxd+1g3nSmxr6MQMB+U8cztddvO8UEKq4+wJ+2ief3OD2a102Q5n8jq8fzccRswYbegAGpV6vQBYEIr0+kkiyWLDmHCQt2zFp+jN3z+8FQ/OxdzpFQ4U2ZrwTjPUTZvdDffrOp+0H4/WszPNuVav/Xa4XYcXjZJzoZeNCLYqRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoTQcz6ZO9ZThInOAmqALWBRiHRXdNxKb8kJ520mjpw=;
 b=ag01E/Hd4j68769DD9WczN+hztPhXX1nWESgdUo/DmLWufECbY/agURC9W3KjMPAV/JE+LpGNiq4uTNL7Ho3OHLL6BHSfoHirY5pfnxLXP25YoWgg3UVFfyIrbJbrm8Uemq/bBFLWuT9e20HehSmk3l8zLvjz15jy+fX8UvNa/mLtJ/j65Y/hUQeP1DP9suXxG+zJRTIUtZz9+lRd33o67v8pNGm9YuUTEXrgaVFJiNAgjMhGVDWyISKL4z6TFisChx50CucfL6+lChPCkim77JATm03AGZdZA+bbhVrYLvrdWJh1hG/VS8RLgf27eS+yGZnUVNH5ypD3ZefihA0Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoTQcz6ZO9ZThInOAmqALWBRiHRXdNxKb8kJ520mjpw=;
 b=dXXZ372zqKl5STnCeFeQqpHvPkT0tDbwMe2lUTUV4mNzVxyYBIqiMrFjwiErDgYhE3pNIXE+ZiRfccjENhUkh/knVzAeXecAUcVeZvAMozbvye5GT9VV0/1/U+pt5m46cNpojvoygmF6A72+KMDlEcrirw0szUiRd5zOt1fzcwQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6202.namprd10.prod.outlook.com
 (2603:10b6:510:1f2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Fri, 16 Sep
 2022 23:10:40 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 23:10:39 +0000
Date:   Fri, 16 Sep 2022 16:10:36 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot
 switch control
Message-ID: <YyUCbLeXmHPs5gJM@euler>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220912172109.ezilo6su5w6dihrk@skbuf>
 <YySqm8t0pbH4cqR/@euler>
 <20220916223146.a5djbyvwlh6jekw6@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916223146.a5djbyvwlh6jekw6@skbuf>
X-ClientProxiedBy: BYAPR05CA0083.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6202:EE_
X-MS-Office365-Filtering-Correlation-Id: 6270e6a7-b946-4991-723e-08da9838abf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HvakxXLyrdoJJPK+LGmmOxAXQYil+U5Uxg9xId2rKr7Y5PtWhZZUeIFtyL6IGe6QkbjbTTz5qucExPq6RHPY/0r0X3yQBo4xwtPTLCWoTLNSWQHA3rgU8E5bmbtW7FGvgSoM9A5Vmq5KaVlQMpjndtMQaa4uLFYuPxoc8jqAhAcG0bmqHeIar8UhBO/CphKm2p13sncwt6VcefSQryShfMe+ESj95cmPLeIxuwuh7/xnu+kT5knoKqf6MpPkTZGcSRPacnPxP3Qm2/FebJJUIS95IKWjQ3mbuosEb7yDQ6xNy89A7P6jMpkjLeAwQhfjMiUOOGAxXFkNwQsnCmXgQSLYOSApqTmFYd6kTBNhTRC1SpjuAAAI+yZud2RqvIjMkZE39UaEhNHMLyx/jWf23sc0k5WPXXa0m5vIZmhqHh4TFfv6EMVyM3BraFOzCu+xoJc32dtyQpYJe7C5ojJyD9kJF654RtZNJfwdDU42E6X9tTtCA6+Up6gToIgjwsW5LNKGc+AspZecVBrkR18ck4rbVRSRc3ljftubLLPm9+kg7G6s0Zky2Aog6/A3Acze9zaqBwvdAT86sHQPEX3BstjUN1L8OpJfuQeWbW83Gv2dCitmcVSf6yWGzVxtEymde70mHEPp8/OmZ9TzF92pF6X1vx9E7CX4E65pOsKwoGcF1ZX0VLAR8gtr6wCLXHPf5RMNgJ7GmfhTNTuc95UyCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(39840400004)(366004)(136003)(376002)(346002)(451199015)(86362001)(316002)(41300700001)(66476007)(33716001)(26005)(186003)(6512007)(2906002)(6506007)(66946007)(5660300002)(6486002)(7416002)(38100700002)(4326008)(54906003)(478600001)(9686003)(66556008)(44832011)(8936002)(8676002)(6666004)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FvXjEYZtdfwpYv4FYfJevJY3OfPDlK12z1D+VNt/Ldwyndq7khaBX3JyvqQk?=
 =?us-ascii?Q?N2F6Vz1ma+h02fyWXEcYg1Bs74EnvosftNWsX+Ll1fib+rNyD1a8rvn4E7XI?=
 =?us-ascii?Q?mkR86p5NLeBEd09dQEFnf4HXrIRLerII3VsBE7ycp2Kl9o1hd0rc/CKkHJYZ?=
 =?us-ascii?Q?/guKEBdIgj9LyXwYhUWFhDjU+xV8DhP9ANil6bvTRc1raDQecPex+YbPMNUg?=
 =?us-ascii?Q?ToG03u6mKu63OQf03OIbNqmpzjSYtDZgtP/swksDCkMyfwJLryg8nFDn3msB?=
 =?us-ascii?Q?soDpivcoIKhTznTag5K+W/brJXbaXTaCRh0c4gWA7HLbruOzFI2NW2kJhW5B?=
 =?us-ascii?Q?ud6wKZyI74zMlLsSNsyrUf7A1OO+pgFHHiwQttJAfnmq2m1SLlIZ6YFgHKuW?=
 =?us-ascii?Q?Iw+kyTJXK/1mdAq0EeLlf5fon09oA1JGBfUdsoea4NNC0UR5uXwzK5qkT5Q8?=
 =?us-ascii?Q?98Cpl0LhLXllk4DBtaR54AwUuvv282siOG0TQfMeoIlE8+FYTBiwRmFJZvN8?=
 =?us-ascii?Q?u109y1mvDuMd/XgRdFOa11pRmaGGqUFxuGf6YkswUV4ytbU3CIv9RSNRT8LF?=
 =?us-ascii?Q?DBoHExY+uIQtE0z9rRSGFWVarrsZjDyEprYLypJ5Xjgq20O6l+izg9sDHfG+?=
 =?us-ascii?Q?Ea6ex9OOKBNm8SCptws2ucOGo9d/OCWCzx+5BVajRlhGQu+BndYlrRc8Kya1?=
 =?us-ascii?Q?AhVw3Ih3qKL/6PF433s0MRFVfAMDScx8YU+gBrgfORBltByaviOPvx4ZwJ6r?=
 =?us-ascii?Q?sQ7OoxnuF51k01OUv8wPfYSbNcSjPlE6xbzt6Qd9SjhT0GsxGcE3EnrN7BPO?=
 =?us-ascii?Q?21n5VSas+WDupFRUmpyp2ZKCcecvjRdyVgBfLZr02Pm33aIP5T9N/cxYUMI3?=
 =?us-ascii?Q?05jW0uMylXfHv2uQvb2OVr1YcijIb6XV8rcpjNHNbsrbBm5KDc+dBx9fyyFh?=
 =?us-ascii?Q?eTUSMlKRQtBC8kchrbMQqJo2W5Q2a8m7CgzR2LsdxHNDdtB7wESVhhPiZ9bS?=
 =?us-ascii?Q?/ml0RXAC0I7wRu3SwmBf3NNEd76+g1S7ktCKEl9bnk7vGugGNr1Nj8Bbdtbw?=
 =?us-ascii?Q?LIMB5YzvE+SUTUSb9+/mHWqmSAjoBEHVzooZnDiLYpCVqu7DlHyWOMPGzPAI?=
 =?us-ascii?Q?bC0P2gaeEXBhcJt/xLZ2IEHbQAmZ9yQZhmd3gsQjPM/b+An7DC1Y0hEkcx9p?=
 =?us-ascii?Q?ZDmGt9WoYu/5gGVMeLANLHSGjezcHcKETb1m4abJA9qO9QKNIoepJqsJDsqx?=
 =?us-ascii?Q?SlO4zbj7d2iVFcxZrO1/u1gq3hZN3z6ArkQpZwrw9LSE+FtkboJIPeTNJiDy?=
 =?us-ascii?Q?jb8gS2vUOOEj82WmUjAhgRGiXjT5diA5YazaxyCknnD6KzfP4Op+F1JK9vcw?=
 =?us-ascii?Q?Y56nCC1dDMZExJ+1JEi6oBjHt9qo/EHOz05BlX07L5QjCSrZMo0zVwduECpj?=
 =?us-ascii?Q?vnciubwAT6GAwzHx67To6cyA3LyFltI4/G4/MEKxUOKjYgZRAgWjbrC/hZKE?=
 =?us-ascii?Q?2n9ZCuN7fzQAv7HScZUQZxMSBkQzzJ4uA7V1ihSwxGM5zJi2YTLDZzgFoF76?=
 =?us-ascii?Q?EzqqJw4DGmTHM72FB4BEBtPBz+UyKcHnmKGBNrDgtCdObZl8aTJXR855trYC?=
 =?us-ascii?Q?73jItGcY0WnMDaVI5e0K/78=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6270e6a7-b946-4991-723e-08da9838abf1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 23:10:39.8539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftND0Ty58QaHvkfHThuZohPK9g2Jlpq2O0D8Wax+EQROxPBY/zBrltN4bLp5T9xhmA2ipLIfrpKBPm6X0v3jnJ5klvDCS2Jcb8QF/a/309k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6202
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 10:31:47PM +0000, Vladimir Oltean wrote:
> On Fri, Sep 16, 2022 at 09:55:55AM -0700, Colin Foster wrote:
> Yes, please use as much as possible from the ocelot switch library,
> after all you are driving pretty much the same hardware. I'm glad for
> your revelation and sorry that I didn't think of expressing it this way
> sooner. I think the reset procedure used to be slightly different in the
> times when the ocelot_ext DSA driver also took care of setting up what
> is now the responsibility of the ocelot-mfd driver.

That's exactly right. Early on ocelot_ext was doing all sorts of things
that are now the control of ocelot-mfd and the various subsystems. These
couple procedures seem to be the last relics of those early days.

As I cleaned this up, I realized ocelot_ext_reset_phys() is no longer
needed, as it is handled in the MDIO driver. It looks like there won't
be much to remove when this is all said and done :-)

> Between then and
> now, some time has passed (years if I'm not mistaken)

Thanks for reminding me. If I knew then what I know now... maybe I'd ask
the hardware person to spec a different chip ;-)

I'm joking of course, and looking forward to being able to use this
thing!
