Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A96DBBA2
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 16:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjDHOlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 10:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDHOlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 10:41:11 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2090.outbound.protection.outlook.com [40.107.100.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B5DFC;
        Sat,  8 Apr 2023 07:41:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPvnJZbXJOLLv1gYZKCZgbzasHx9qa1sQnR4SbcZnsG2D/9pi6U82HiY3W2OWPDNbVOpCI2X/pwEHyapP9DsDHM+V46qVQVjVX3L6CgWMXmAZZGw5jqlGcZbuD8pX5WxcZWFR66mUR00398nfcsI1RGtkSXx+ra75q96VlNx68+tYwWml7mmahNgXs+mCG7F3HWoOBa8+SfT82x+z9VbbjnRxp4MiqCLm0cRruYBunuHR7FS1ujhsLAEPj6sySTJNVFujavn+jqz/UlO3Ob75P1LIerTLRXnBBXSeg5Q4abfmgVyOgqLdHK3zTdpOGdzSiOqwDc9cZzg31Ov61Xmlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlcmSlB5tVuYa1312O5CJsqHJdQm/0SjH1ozHRei4Dc=;
 b=Mf6GKN5bKKeA2HaBb7KB7FCHB9qIHpjUQo4vcfx8HfEzlT3icTl92KV5JjQdogShZW+YDC+uCm3oTaSbJZzBaFupwhqs/nr/T0bWK62sBQ/dN7oQ468mKTL8X48Ktia8uZuK4vASi9JVTSu59M12uSk45sSWBBpOCYJVM9moP/FtEBxbKzP/Q3STpIL5Z8Sm1khtqb+6oFDeuIcCsXweT9DtL20zi74Q7uaZmCF647xbHmC8NqEWsjK+aloSVpvHP3Tv19h0J5HdeDvZMib1GUkkopDbKPB32HimlUWb2fRNcPjviLUk82ZMijdcrdy3unU1K8diXvhI4PF+QHuqUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlcmSlB5tVuYa1312O5CJsqHJdQm/0SjH1ozHRei4Dc=;
 b=P8rgwmb/faQJ/WKqu/5muh7pL6/4MZsuqHDlgGqtz8JyNSfGTNWCfRtBwReEFAkKZEP9RKnoVRWsoliYbg2X3LIAbIgLgG3zUDuRb9tgAryipTIDMnaMtnx4jhM6EoJH1nw0LYMIuRL2ItvfHbttBVH2qCz0Q4rVALhIrShWn34=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH8PR13MB6289.namprd13.prod.outlook.com (2603:10b6:510:254::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Sat, 8 Apr
 2023 14:41:05 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9%3]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 14:41:05 +0000
Date:   Sat, 8 Apr 2023 16:40:56 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, richardcochran@gmail.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v2 2/7] octeontx2-af: Fix start and end bit for scan
 config
Message-ID: <ZDF8+FIFqyKORLjo@corigine.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-3-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407122344.4059-3-saikrishnag@marvell.com>
X-ClientProxiedBy: AM0PR04CA0066.eurprd04.prod.outlook.com
 (2603:10a6:208:1::43) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH8PR13MB6289:EE_
X-MS-Office365-Filtering-Correlation-Id: b8957681-ebdf-4cfc-780f-08db383f486a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7brMl2J21IvXUtsp+3FM7FgaqHmfaW4pSfQKPwywNd6Ql+jUWvpbQAyIp1IZf81kCCKv/fQkNYjuzkg3Ps4mq13dwAyxvrQWd6OsCsvVJZ+0Y5IBAc/iT+fRxXj6UrSJ2g676CvOZGXb494m61U6s2w+WpT+3DfquPMK4MFmT9Q2VAYXu//1z6j4ssMTqyyvkgCPcZPE7jhRt0+rT27fozDgI8QG1Ci4Pit7mjtuPCJBEGytS9gTN/8U67cI621bGx8jY9J9Z28fjcgiod/FDPXZKbo4oHdjfzD6/rvdQLFAxQyY+zX2fyMIfZlrlZC1yifytiHaT/25EfoL8pxqUA8fm89R2/y+gyUDglsCpAi5iy4zZOiePzebqTbf/ECfzfT64vXfWInww21soMpmNhF4Rbfif/ZyOAHhT/OHSMy/fKr5JU9TckCdeW6z6Oh6I+X8Z5PTjkyowmsE8ktrPC5kLdh8+LHB2lFyk02wQl9diZeFCIKK3W3EKH//D9ve5WLk92d8ZFHci2ctf249hdn/KI5bVFa6tblvyvEMN5dkxoACeUvY19HxrcmHt7+YfHi7lY1EdlLXdzSnqcPGyRyamqUhF/jbbUHKq8xCMkibpsJIdDyxzSvi/4GXfGwXk8vmRoxLGJ47Jyph/t+s48bRtBSRGhnNEg1exlKBR9M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39840400004)(346002)(366004)(451199021)(7416002)(5660300002)(44832011)(86362001)(186003)(2616005)(6506007)(6512007)(38100700002)(8936002)(4326008)(478600001)(6486002)(6916009)(8676002)(66476007)(41300700001)(36756003)(6666004)(66946007)(66556008)(316002)(4744005)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RQX6IL/GLhWHF1cc+RYy2AylvMdTp9oGJD24gtwTlYz7UPRUjIgzQClLRhYL?=
 =?us-ascii?Q?Dhy80kbEX6WdxL8vIWqi1W7OW5GZPCIzySPi1ewzvTdIeiC5nx6tWL7uuHaL?=
 =?us-ascii?Q?2ZpHmL0WH1+GEYHcF6mS7Qm8euNepCmczUHSP0aBWN9VzO80+OXDW+RgadXV?=
 =?us-ascii?Q?7BAuN0IouSFqScUVe/MjZ2VFNjXsF2c+J5wI5zcUstjepOeuPbWu2ZBEucZ6?=
 =?us-ascii?Q?DbU7xT1QHPgz5rGdztehMbIcl8ZTEXdRDkt2lkWaiWkNBHQX7nZAXY6lVxnf?=
 =?us-ascii?Q?g5WDw//o1EVQZ0Rbce/FpmZacyO1qCKmazJ7dIqqj+31wQrmdYkidxWeBWNU?=
 =?us-ascii?Q?N9aRvZ8+1U5JdjqefNQqn5C5Wkt8AAje++ZNghjQSPuf/P5FuVVLDSpHMMke?=
 =?us-ascii?Q?b5EMkUtMiJTOHXknpcOu/d768Jg1VMVRqkR8U0FPSNBpg20II2APdLEfO3WI?=
 =?us-ascii?Q?bMs6e6Ai+UVPzEQqn6BAKLgv1Gemd8BCE37Tj/GG35dbtT11rLVrL+RVgJ+L?=
 =?us-ascii?Q?7kW908ywCIgABauJfXU80Tzjp304DyYgOvakbrsXDwu8CLApnaxQWpPiC6hY?=
 =?us-ascii?Q?7on5DDt6OjToi4VNUu4YfiESIJ000rD2vn+7GcTwcIc5DhmOmEP+4YbjzAqP?=
 =?us-ascii?Q?v6JRhQlQa1mhXaUdONBHSX0JJFV33jH6xFv0zyzbRbpzGtF4Ws6teFoMpxAX?=
 =?us-ascii?Q?PLXKy/R8zvsCGIRorD1FlkCty7ZVuQo4FZVLorYUTfQnFUcZHWKsWC0eKXb7?=
 =?us-ascii?Q?ziK7JrEtnHTeO0sIRu7WgLGFWEv7K8+wIggEB+y1z7ExGnYr4C4MPQKaqGIm?=
 =?us-ascii?Q?nnDxy+Iu63fzFZA72YbAg29hWGSMvHKDNn4XKutwFHYzHg+4EWt+Wtn/XzTW?=
 =?us-ascii?Q?Nh2OFk9qAQ/L83fm9P9gB1RTIOwi6mqwfXRfFcrW39JK1N/SbMYe7QwCdLn2?=
 =?us-ascii?Q?LD1VfzwqIhIKx+cfZIFMEHIcQoCVyWIFzKdGbOOmEvpY/KJtNarwCSUmeEBG?=
 =?us-ascii?Q?4q66ZBzK0QpbcP39Ov4nEW87p54NXpdurYv5qepp7VtHevjfo8PH6x13MXf5?=
 =?us-ascii?Q?w+evRDDl+b4Mqr0HtwI8Xu59j83wmpnNr+aXT60kNrzdPTaPa/WJt6Ns/S2w?=
 =?us-ascii?Q?n0Fl9McZr7EVEav2j7Se6nLZJ4AmLjBNly/GUz4rNzrph+nFtDr+usbeanws?=
 =?us-ascii?Q?o03C0fSbbY+Hg+8yXu9ikwFt24sa+oUrgk1uPGM9jOgONcwuvV7uuT+STQra?=
 =?us-ascii?Q?Bx2axsHUdkYhC6qF7+0ucbYB9bWfH9BQc8VcAcklouVqQT3T0seMEGQiMiGS?=
 =?us-ascii?Q?rzFJ9YD9tpa2rFgo6nD/4zKo2E/AGsAtdLXa28aZJENzYW+4/uYM0NcPJwhL?=
 =?us-ascii?Q?JESVqLtjgTfF6lCzDvoN9vjiJegUjYvUF33xJxYe9Q7UCnDXeRP4fU40i42E?=
 =?us-ascii?Q?ho4DaNNW6eR8oIc+brqBg/76Y3U9Sl4vW8HOmSTvo7NQQUu1/8ZYkQ9tabsj?=
 =?us-ascii?Q?VX1kPvRKpGXR1eYaKG+dX6H7Onf/8XKUoeppA/kX4uWH34X0UCOIRaODnIBC?=
 =?us-ascii?Q?ZoG+SFSmYvcb3HPr3bYb7jaEqZ2qR/JioKuZRFpdRZYfkdJHDNvgxjSQWQ7p?=
 =?us-ascii?Q?Fi5qqo8/dNXzmFxhEzrmCiqSLbXFKb7FtM+jvT2IovXacb3+iZIRC3cbfe86?=
 =?us-ascii?Q?5BNgeg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8957681-ebdf-4cfc-780f-08db383f486a
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 14:41:05.4944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKDzI8sk4T0T5cvPutZE3f6ygGczrrEORJ4sp2nnDy42rRaDAoHa58uHogSFIdUsVJGvqS0RPbkpuzzN6Be0ODEq/GCHTED+7u+g+bL07Ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6289
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:53:39PM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> Fix the NPC nibble start and end positions in the bit
> map. Fix the depth of cam and mem table configuration.
> Increased the field size of dmac filter flows as cn10kb
> support large in number.
> 
> Fixes: b747923afff8 ("octeontx2-af: Exact match support")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

Hi Sai, Ratheesh,

this is fixing a number of things.
So I wonder if it would make sense to break this
into multiple patches: one per thing.
