Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F0468BBFF
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjBFLsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjBFLsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:48:47 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2110.outbound.protection.outlook.com [40.107.94.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BCD7685;
        Mon,  6 Feb 2023 03:48:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mr9jcUUgWlkXfyk5e+/Kvt85WU/ryr5T0AsVUW1HKp8T7aDmtEqgAfJ+1b5icqQsO4C3HRWW7GZl0jcxgDJTbnwsrUF+Z518LrD6kHQUCFkMdC3FAytmsEjInjI+zvDsh1IuuqZ5Jbxynbj1ly9ObdraXuOeRGdLZaSECyroMbE7GRl+DDIz6iqaR4la4aYd8BfsxsRjAdejzSW+b/kWvFO9b7B7JGXjwkiPxmh7i/Ycg1qm2MmN6EmVSJ9E4/jpqvB5LcT/ArnRNYavALaFq2f97VbU3F0q3g0kobMhx/0vsPgVEzJ39y48O6MzizypzZwyXOTuW9Cv2tN1oeuY7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgyhPCL53ukINXveoU5kZ8F09ffqzq6Fwqn420oVK9U=;
 b=Uh3abL+3/KdkbECGl04rpUndGAEPyMKJVyBey8DEidu2XxGaxuUs4CwmM476W9WBbQ+UQopYwBT+ImueoS5kuq51d25jZRQiwVJVG6OUbLQqw8Ou9rGtDUDYfyYhLZL/2wNxoEEsawrcYIjTu0+sIkxCWMgFzyvn2bNn+R4C3yc97YVcEARVMog+s0vrU1YFC3A/ZZj54RTXsSulcpLmcFbA2P+l2Tvp/9dQW1btxSHpNPwrIZvEa94iqXTpvFPO01X86dVEKhtrnYmSWTYWaLPjKmDWt72nY4Ko2/BOwJXZEC9/zc093GVhBJkvA60xCjFTnMlJjXHShAUDl4Mxeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgyhPCL53ukINXveoU5kZ8F09ffqzq6Fwqn420oVK9U=;
 b=eE1H8LOmCO9NRm8a6T7e6mfh5cuVAe20YRZO2PMSoYMGpgHXk8ycDytuBxpC7kFbpBX9bElLKrbop2LrjBWQMrEzx9mcIBTPt7PBO1RbW9BttK3hE2uQYBzl78CbugFSo94xLz/G9jIpt5zRnUmLHsbzhelkhG9/luhClJo4Y60=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5193.namprd13.prod.outlook.com (2603:10b6:208:340::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 11:48:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 11:48:24 +0000
Date:   Mon, 6 Feb 2023 12:48:17 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: Re: [PATCH net 1/2] net: mscc: ocelot: fix VCAP filters not matching
 on MAC with "protocol 802.1Q"
Message-ID: <Y+DpAXdFCj+laoRF@corigine.com>
References: <20230205192409.1796428-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205192409.1796428-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR02CA0219.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5193:EE_
X-MS-Office365-Filtering-Correlation-Id: b392edc4-bde3-4a95-242e-08db08380d32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ROo4DWVjBJjLIgRO4XoSR2gTEeHtntSKXGT5jOCOQ1t1SSrM3ePS39aiMSCnaFNHuSwZAZFmqfA0WhNkIutQe4S+Btpdom4b+Ixq+PTHaN9XTjVfEr3ILxblV/CBc/ml4+QQ6tpCMVgE78LjcOX2TwnV97GnuTmSQZIepfryeX92AVqvVR1Q0X5GuD8HpS9FAbDBglwz8KBHnPP7oioXEFRRQIkWBAWC43kOnSnkyVoSG0HxJ6uIs8ChjLHGOB0jF4f9B6IrrRZw1+qnIqT9RYNYgWhN3ZMVGB7zca50q3PLv3eLXOTZPP7T6rCNCjyx2aNcs3cfKaH82MgegjL1IvWkaYr3HirGVLoCHwUCkV8hGVAcQAnNv6Elh7TpvRZtAtvQPeffghQIAEccmJT2z2+Y90sIEqWgza+xtvN5QUw/Vkiq+mGRgZlL6EkNTAg5y4NAthaa04jwMvwxIWYEcCn+VumscnHpejFxq1UWIqhqH61n6qcYezR7OXRniNXgDKegXYk4VFupGrar7O9ppvheiQXxt9nMxqc5ywo8qzWnq0jc2FPYuYnxKNYk/97v351QIkuAOR2CDEGEm5UmylIFjJ2oJilDFa4VTq9ZnKtz22CgtVS4BE6wO9VXlwEtRLovGwfoLWKl6mwG5sVIiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(366004)(39840400004)(451199018)(36756003)(86362001)(38100700002)(2616005)(186003)(83380400001)(6512007)(41300700001)(6486002)(478600001)(6506007)(8676002)(4326008)(7416002)(54906003)(6666004)(66946007)(316002)(8936002)(6916009)(66556008)(44832011)(5660300002)(66476007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CJ41QYuELEp3henuEL3zI30oWEA1Le/+O4AY3TX7oeUmojNOgNAcdKvLvOWS?=
 =?us-ascii?Q?FMvnEF7zAK+iHQpbqzHD1NZbWGL2u9W+HB3XxX61nsJ5hZxyyRN3z3IVdRCb?=
 =?us-ascii?Q?quAqmGSyuciqlEiqY7phzPOhEb5ZVMhWMiipXAWm2I9vZArRQ/FBZMsvjpMB?=
 =?us-ascii?Q?zh+2hVASm72DG0SmBtKtWzF0klRTOSFzyfXy4oq3lsLyCBzWmEpEZznQ10Ua?=
 =?us-ascii?Q?Ic5XwTyGaonovvvUR+lgbBW3uD3N6p3O1U2pEEh4DyH07sxwZgQn6Hfks/zh?=
 =?us-ascii?Q?Vdu7ZUNuEkQfV3yjxaNtuEaRnnenwiKl5ZgVo/LK3x1+se5RHuCv5TVkWHVc?=
 =?us-ascii?Q?a4J8Ms62Et0n98TCRe7mRFdISBC1uCsTmkKBLxMr4szx9JmRwlBlmntyCqc2?=
 =?us-ascii?Q?bqUYkw9Wgc1UoW62ZANeaGQNNBnXqcLk3oLgmHFABVrPr5UWv3tcp8wGvmUC?=
 =?us-ascii?Q?ej866kIzPe6FGJFFGaOXkbg3kPoUYqqhYbKDDY7NwnftECsvvVByBYGM51G1?=
 =?us-ascii?Q?nnhn84nqle6C62GZ28Fs+nhqYrq9aKs4BHVv4xdjV/2Z8T4KuClomcZAP6yB?=
 =?us-ascii?Q?mcQEMQnD93/BCqvWuPOyV6rCAaP4KcjkFdJy8tFMGEKpO+FX2aU2SkIST5Fx?=
 =?us-ascii?Q?sGKAsLFdq2l7JWOu1LxP6HkiTztWygXHZpEizAI15xICyP4oJIAJHSakFXlJ?=
 =?us-ascii?Q?k5GTBa4qzICGfhR9OkuAFjqWaW8u1/t7b6sfMpmUbRXXHE9eNILmcDmqMlZk?=
 =?us-ascii?Q?+BRZg+dAydW2tCntaT0PJVa8KrBtgicSnvIZBr/LX71e8zt7LsFLyp58l/5q?=
 =?us-ascii?Q?9zDr+acKlo7wfZ308J7knKLfWyLzCZR5NbothBwZxNuXWHABlruyRdfMjdYw?=
 =?us-ascii?Q?GHo1xy0C2+Yv437tG3X6lRXXt+GtEyrkGrcW5/cMvM5ZFGY9oko95sYsP25Z?=
 =?us-ascii?Q?AwrVzsIrnkoGGSKvXKOJcgqlQt5c3HFZhvh59jn5BLsqA/1no0D/PMboJniW?=
 =?us-ascii?Q?5qbgTG2EsgyNHMeC0Wytr7wh2BEWxh+CWvG+kIBWC7mhwZjw+0m534fN/sVo?=
 =?us-ascii?Q?k3cuwtqooah5vdbCxbGshUTDR96fSBQPNl6/sZCPQHjLmpCZd/gNfbGezMZR?=
 =?us-ascii?Q?r3Eiwywf4Vvd0Yk4xPGBlKzh8Ea0Ny1Vi4kG6+0HY1xVkiRRo2TITlsI+psJ?=
 =?us-ascii?Q?Feniak9I/Wtofg1+ee2RKgVx5uOrbqhJJJcIrDILR+BEDWtkggjZMzNJsC2b?=
 =?us-ascii?Q?vtVJdtJ5jL9LKePjI4XAzjckoOOfZ304kNLmyl2kGRGY2uVb+2hw62tG099L?=
 =?us-ascii?Q?mVZYXMWFN91UwCuh+Q6eCkm3IcBTwOaOrTOJzesUili3BXJn1Sf9ZdZqlFEI?=
 =?us-ascii?Q?tLEpD+NORSHepzR2jRWp0/WWF0CR2NU66SlLcbq/3MIajkKRbpm0QB7xroxx?=
 =?us-ascii?Q?tvEV/7N58eroUvsTgJ4w5Z0XS/g5F/u/rkUSpmS3ivpR2c4ZdQ9ks1K6i1OE?=
 =?us-ascii?Q?z8rBxvX+X69BXa8B9k3xdK/GX+WWGkh2C3rLnRiQ9D9a+p35+H/T64YC1TQZ?=
 =?us-ascii?Q?VCkxRtebpmxYrN21X9+ma/d3blf0BdSsSPH9lYC8axVaz8/P3yKUZvWS7JCx?=
 =?us-ascii?Q?k8AAVlRegNWqU6ak3yPsklAjnHd9vXzxpE29KZYm8zEnIFX/AWhvoZMzseaX?=
 =?us-ascii?Q?TA3brA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b392edc4-bde3-4a95-242e-08db08380d32
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 11:48:23.7981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lnqJj+uypahuVln3ZbFE79kpqXarNQAN7zRY+tU4cA4zHoxqrNOev8RbZkppFlfkOWP6Xg8m21Sw8oKSn4G10TiW0JYhcBOfJ1jyyY0tYEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5193
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 09:24:08PM +0200, Vladimir Oltean wrote:
> Alternative short title: don't instruct the hardware to match on
> EtherType with "protocol 802.1Q" flower filters. It doesn't work for the
> reasons detailed below.
> 
> With a command such as the following:
> 
> tc filter add dev $swp1 ingress chain $(IS1 2) pref 3 \
> 	protocol 802.1Q flower skip_sw vlan_id 200 src_mac $h1_mac \
> 	action vlan modify id 300 \
> 	action goto chain $(IS2 0 0)
> 
> the created filter is set by ocelot_flower_parse_key() to be of type
> OCELOT_VCAP_KEY_ETYPE, and etype is set to {value=0x8100, mask=0xffff}.
> This gets propagated all the way to is1_entry_set() which commits it to
> hardware (the VCAP_IS1_HK_ETYPE field of the key). Compare this to the
> case where src_mac isn't specified - the key type is OCELOT_VCAP_KEY_ANY,
> and is1_entry_set() doesn't populate VCAP_IS1_HK_ETYPE.
> 
> The problem is that for VLAN-tagged frames, the hardware interprets the
> ETYPE field as holding the encapsulated VLAN protocol. So the above
> filter will only match those packets which have an encapsulated protocol
> of 0x8100, rather than all packets with VLAN ID 200 and the given src_mac.
> 
> The reason why this is allowed to occur is because, although we have a
> block of code in ocelot_flower_parse_key() which sets "match_protocol"
> to false when VLAN keys are present, that code executes too late.
> There is another block of code, which executes for Ethernet addresses,
> and has a "goto finished_key_parsing" and skips the VLAN header parsing.
> By skipping it, "match_protocol" remains with the value it was
> initialized with, i.e. "true", and "proto" is set to f->common.protocol,
> or 0x8100.
> 
> The concept of ignoring some keys rather than erroring out when they are
> present but can't be offloaded is dubious in itself, but is present
> since the initial commit fe3490e6107e ("net: mscc: ocelot: Hardware
> ofload for tc flower filter"), and it's outside of the scope of this
> patch to change that.
> 
> The problem was introduced when the driver started to interpret the
> flower filter's protocol, and populate the VCAP filter's ETYPE field
> based on it.
> 
> To fix this, it is sufficient to move the code that parses the VLAN keys
> earlier than the "goto finished_key_parsing" instruction. This will
> ensure that if we have a flower filter with both VLAN and Ethernet
> address keys, it won't match on ETYPE 0x8100, because the VLAN key
> parsing sets "match_protocol = false".
> 
> Fixes: 86b956de119c ("net: mscc: ocelot: support matching on EtherType")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

