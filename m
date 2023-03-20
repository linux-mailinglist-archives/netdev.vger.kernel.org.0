Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1CE6C1AFF
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjCTQOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjCTQOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:14:05 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2094.outbound.protection.outlook.com [40.107.95.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1786838EB8;
        Mon, 20 Mar 2023 09:04:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUR4/sKatuHpEZWdznRgYR2AErO7c5Fjb1b7MEYvrfKwHXm5cgGul3nh4SyN5xZrGio2HX2oNOFFpQefnME+xXwAhnI7FE4K+JTZaMzCBW2MBnOH6LAGv+WwV2ueGF87/nJy5MfTTGYhKhjGMRIydLKckF9zoCGLp6RjUGDfniaAOviQZF/nNEPmNK0pMpnog7M6NrGSq6rmvvQdcoib17uFtEZd91lSYXjs1kGkvtN7PmuKMvM5Q0vpURElcog0Sw8v7/JwsGxbw5uJll/27+KZKozpa+7kZdbNIajomDvwMvk56GsQwcgk6+wOrtl0CPbMMnq3Lm9pKoa2OH5CnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uSAzYflRyg0zoxeo5p5jYZKtowlhccz4VaGbw82/kOI=;
 b=Z35VEZ5CtDmateRhoqO4dg35MEmx/nQQ3rK6dUXjgw5eTuA3u8LCA7ArouVTuOuq7Q1RSCRXJRt4P+he40THiqK9dUUjhyDdm7DaHeYvuu/xtPL1cDBFXm7rLKEId9wd9EDx5Pv3ILku/JOmEDxrFIf7FBedzA2RB3VSbLWFonLWz3gFm/JxU7OT2fZKwMAcLZyofNU5PX13/ARJkk/20tYDzEGJFm6gqVKuCnUMXcNOJ16FWmXpVZR01arupQc+xL7fKZlyVUuNDR54OLPSl7KAZadINbGjj076Wn4oH9Lf2CDzVkykXhpJDpjhS24jevyCD6KMNx7oKjiFFG39Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSAzYflRyg0zoxeo5p5jYZKtowlhccz4VaGbw82/kOI=;
 b=iwuUb+E5ZZecr/ffxwrXYK9Of9Itn5AkoxF1cHC0FziYQNpbo+w5Q7ypnalJ6tffnZpi5M/dOkT5hIPwzQnkk6qMXWpjMmTaSMhORTem8lnOfJeiUQ8SrSyE173tlfvelKHBfE6VmAIhZgEskC1kBEJ75e9SDmBC7ubyXVFJrO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5218.namprd13.prod.outlook.com (2603:10b6:610:f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 16:03:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:03:16 +0000
Date:   Mon, 20 Mar 2023 17:03:09 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Josef Miegl <josef@miegl.cz>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Josef Miegl <josef@miegl.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: geneve: accept every ethertype
Message-ID: <ZBiDvW+BZ/qE3EAV@corigine.com>
References: <20230319220954.21834-1-josef@miegl.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319220954.21834-1-josef@miegl.cz>
X-ClientProxiedBy: AM8P191CA0009.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5218:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aacfd27-e6e8-40b7-79a5-08db295c9d92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0PrBY3dlIJHGnTli64W298slCndb7Vw2TvYsSN9wa+LT1e/Kgc6uMNDtflB3A7Yqx0efbUWLMcV9lCFD4y2SLDWj8C5TjzUchLgUosiBgrC6cUvZqGz1FBWM1yKxDATMS15TwZwjhFl7URBOfjEokyjJJpkxMfWwSRV2x3/vNXDFsnup481NnVuXpUWCX6Rp7Wy2b9VvJyQOqUEjD/jDsRTk6lSvj5oBTX0SN4fQlOcZNspqMQxFD52EJm7zdkFfhN91A0DeOP4HXaVsEh4Y5gmVy8Yg3m/vJR/9FYIImogVUnx7dYiNDU2AWro0d+9gbSeeHdfcSWYxk7yb80vnFu/z+JFqGbMkTGk5dvVw6SXTJFYlCfFaym8GzXPop+2t3yddMoE28t5GR58yGSOjftXWEwzIZ9957RftTJ4eTkSxm1gmYtObQt7/Nwve2mCbmzbJKsz3i0DSqyp6gjJ9Yz0erwdVUENJZKVZ3UNQBFMYWAqLant32uaZRRT8fqizTK8coV/T7ZGvLP8S3R1gTDg3k9y2CrBakARGFxPlDxgjteqLam56JxGuwk0Wqd4Koh4Wg0LVRlylVVlhsUPB9bd3GpsS2bJlbM56FHH7AbdKw4EOW3ts0qXcMJuBY8ybBEOUEtcMcwjtXJJpWieZCMO7h9WAWzpl3K1AeHNggCYR1bmR2Y7R12DuKaK0bMN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(376002)(366004)(136003)(396003)(451199018)(36756003)(86362001)(2906002)(38100700002)(41300700001)(8936002)(5660300002)(44832011)(2616005)(4326008)(6666004)(186003)(6512007)(6506007)(316002)(54906003)(6916009)(8676002)(6486002)(966005)(478600001)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5buKW1LYL/w6diZpOzJ3/pxBMh5mMCAdzVjBnomKIw65ZnFqXYWqwoSfnvjp?=
 =?us-ascii?Q?xs6zT1MT7EAmSLAtijdWfH4Dp4c5h1i/NR30FOiXzhQdiMpYUKRjifWVbluO?=
 =?us-ascii?Q?qyJv+01KqLP2NwM2w45N92eQvOU99he5wXiTzcwF6TDwDJb1Aam0vixgaDwO?=
 =?us-ascii?Q?eXxQJ0gsncDBw5qfqHEn87AXbDC9gjcIEvoxVZkp18JiZKFBbjXbfT2aEAq2?=
 =?us-ascii?Q?+e/oFzGzUpRfK2MH8Ti8zGYJQ11fBXg03TjgYp7up2qoAQc5Bz8RCQO/WVEc?=
 =?us-ascii?Q?KMfDyLdiqHzHaOSwkeMFyjbMBq49LWtkOK0XFT4IkYXJ0T7+2Km9y2z65boh?=
 =?us-ascii?Q?wUxK2/17CKSVx4sGgO9fNyt1Faug7AJicRrBnYlcd8iPLHC/LEmwFK82Kh3h?=
 =?us-ascii?Q?ggvqWq/lL9ZjAD788XwvoYSpDv12/PD22Pvsw/m/RIMsCQWkMboT+P+R4BTX?=
 =?us-ascii?Q?2uR1Mkr8+ZBNponPuKGhIzA9uQoovv0+b9nyoFcgKejVpXxYm861V32a70Lv?=
 =?us-ascii?Q?GiwkhMclyzikTM+gLZ13HAHn1BrWKU6wM+sJNER72z+Wp4k89vAvlusUWh6H?=
 =?us-ascii?Q?uNguQBMFQouCmL60V3VVZIN12VE32CREfeEtT/JQzRTcqJiX6dgVTG02S9e7?=
 =?us-ascii?Q?iKZC9W9rUVDbHZ6Yj1H9eJQ3cNh6VJbm5YUcK38aL4UANMeEaif7AhCdMIGd?=
 =?us-ascii?Q?E2wOjkKAmuoScoq8t2Qj7SdVA0x8oMDJnEtyCvsi/G2GWNSfx32OT6KJMpo1?=
 =?us-ascii?Q?oA8u5ZcY1/dbkxds+mnVzZpOqNDpftbWlINIH9nKIiVWtKrpISmd+SaDqbty?=
 =?us-ascii?Q?vTilAXuiAlGvmwuFmYvyQghMg7y4uiIp9X7sktIJJx6hJxjy0KT860/RXYhH?=
 =?us-ascii?Q?hb630zOVNvUyMLRSaujGXhUtYB+ryhPb7I9WZ+vkgnyUHuNiYQHQqOKnaCqI?=
 =?us-ascii?Q?RDroz8caY8tBFyNOlXEjIjMOb2jlXthF19Sle6K2vaUFT+pltDmzoOGVljfR?=
 =?us-ascii?Q?YHkehUWV+PQN03TWvw90Sv58n/PKaZjRm/hoMdHILKnhIbeoHG8Rmj39PGR8?=
 =?us-ascii?Q?KD1WCjQ0iEKm1Pyf4VsTDQiyp4bH9OVyIVRgeu4iWtc1GZE1hGQ0EWc+WpgZ?=
 =?us-ascii?Q?6qHYs0MX3NUi949pQlmKz33KW6O7MkM+qkg+YhofTgt/1m2sSI8MH6qhBBHG?=
 =?us-ascii?Q?XMZpdVI5Ekd7vgeMsDdsUYX8AG8CefQrqcHUG07D8IT5JjXaABZ+uKNYs2hv?=
 =?us-ascii?Q?KSMVjCoLiUPEY1Hw6rLitEvOTeBUyhyDUqQ0Hhh6P/PZTFEEpBOxSgNq9Byv?=
 =?us-ascii?Q?OUM/hV2mm6GssNY/Gdtg4iovdDEgE9kKJe8q1IkOtTk1zQshP3I72ljFH+PY?=
 =?us-ascii?Q?Gel80t44wjRQP73zue11Zj+jy1yWM1ejKB/HLz46edg5D3WzgtYddqEhn3jU?=
 =?us-ascii?Q?BmI+cXQqAuYykeBV/ICsk5l7NcswKLoUCZUcvB1gHl/t9xnNb4XIrqN5KLHD?=
 =?us-ascii?Q?765xhc17BUdxXZ2Afj76X6aNm9gKj6/K+onQTV0aSbZ8yzu/6FQyAvcvybpU?=
 =?us-ascii?Q?oV7GVTUDYjnrKY1DQo24XDR3U421T5jhVRTLNtYvEs94F4sv22JBzyazpfjr?=
 =?us-ascii?Q?HjdEiq1XHuSHANIVvVePEzD+Ps22t9OMS63gJfIabZkHJ91Hg+HgI0sUpMyL?=
 =?us-ascii?Q?A6BQ1A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aacfd27-e6e8-40b7-79a5-08db295c9d92
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:03:16.2141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DZZd5IZklIdrnLkq1e3vCUOSAHOifYiEVjhcsvUcXShK+FbMU16nJC29T89roYa7DEueCkkjzid3fgTB779CwHpRoZ9QehhUA+YihXh+n0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5218
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 11:09:54PM +0100, Josef Miegl wrote:
> The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
> field, which states the Ethertype of the payload appearing after the
> Geneve header.
> 
> Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
> use of other Ethertypes than Ethernet. However, it did not get rid of a
> restriction that prohibits receiving payloads other than Ethernet,
> instead the commit white-listed additional Ethertypes, IPv4 and IPv6.
> 
> This patch removes this restriction, making it possible to receive any
> Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
> set.
> 
> The restriction was set in place back in commit 0b5e8b8eeae4
> ("net: Add Geneve tunneling protocol driver"), which implemented a
> protocol layer driver for Geneve to be used with Open vSwitch. The
> relevant discussion about introducing the Ethertype white-list can be
> found here:
> https://lore.kernel.org/netdev/CAEP_g=_1q3ACX5NTHxLDnysL+dTMUVzdLpgw1apLKEdDSWPztw@mail.gmail.com/
> 
> <quote>
> >> +       if (unlikely(geneveh->proto_type != htons(ETH_P_TEB)))
> >
> > Why? I thought the point of geneve carrying protocol field was to
> > allow protocols other than Ethernet... is this temporary maybe?
> 
> Yes, it is temporary. Currently OVS only handles Ethernet packets but
> this restriction can be lifted once we have a consumer that is capable
> of handling other protocols.
> </quote>
> 
> This white-list was then ported to a generic Geneve netdevice in commit
> 371bd1061d29 ("geneve: Consolidate Geneve functionality in single
> module."). Preserving the Ethertype white-list at this point made sense,
> as the Geneve device could send out only Ethernet payloads anyways.

I'm not sure if it ought to be fixed, but checkpatch complains that:

:379: ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 371bd1061d29 ("geneve: Consolidate Geneve functionality in single module.")'
This white-list was then ported to a generic Geneve netdevice in commit

> However, now that the Geneve netdevice supports encapsulating other
> payloads with IFLA_GENEVE_INNER_PROTO_INHERIT and we have a consumer
> capable of other protocols, it seems appropriate to lift the restriction
> and allow any Geneve payload to be received.
> 
> Signed-off-by: Josef Miegl <josef@miegl.cz>

Above nit not withstanding, and in keeping with the discussion of v1,
I am happy with this patch.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...
