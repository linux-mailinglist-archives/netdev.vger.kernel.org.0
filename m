Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2C96D074E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjC3Nvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjC3Nvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:51:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2122.outbound.protection.outlook.com [40.107.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3030E5266
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:51:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ca8n86UKba1E4KVO0m8V2MhNk83C2xJtrz5HMLWBP04JYrs59GUnpJDXUCRwvc/WkWq+/DHdH3tHTdzfU38YZtTbk6BpBMKTXf8I7tdmWhiHyxHNiM2U3aspCXkLGGO049BpbuXM/xZ4v8EK/gg6L0VZym1Snb90eQCPCVTs2zmOmbYwDm0tUZtyB4/LO4LjNsKHP8pzLgh13eeKjhgiJA628r18WK9pRfOv9SKfyeArUBgJuE7ULRja7XTWDTHKRP8Bn90j+lzbIOevnAaxpF2EryPQ5u//6J2cxxU0JJr/b7hFIQyNp/1vxdGCSJZpV+T3yFAYkcXIWOJ8artpsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCCHNYaOAuhXVTjZcvHzI8MMvLDqrO+efkgI6ftmYm4=;
 b=lgV2XOandHe4Wn37cQtTajlVBz0RbjoJPZY9IDH8g1XRY5OnLhuxPB4QfffJF8f6I2rdRuwAtbxLuw45fyzun5SL3su7Z24pDObkS+6+1KGa46W94P+4kH1h2wZX0kejhFAN3/0/2kKQ05C/NhldTKVo5H/r9l5dp8CuDpM67FmPTrzPunxk55RzFwg2R35+uDzqbtQ7+aFSvjkYM1h24H+RR6ZfLZUFJ2quRDdfB7MRTu3sKXlyl0LDP2yS69eYJAMbZqRSub/BNGCVhwUQYx1I7UagqNfmzEYItv1EH26aiNo/Ra6Jgutf9MJ0BiqtqdXo/x0d3zInDMLtUCkIOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCCHNYaOAuhXVTjZcvHzI8MMvLDqrO+efkgI6ftmYm4=;
 b=U0ew2PlchzrjbCO7RG12BpoZYX79root9jbiBrQ/hAhmJzgFM6XgyP2dvi0QlGxygiEvQpNU4uwoBE1tgiQ80YgFYMis3WcFNxYaSpjdN92EXVLCbVGGbWTrIxDCDfR9NuU2e9H2fAoBfSsICs8Gq4lY3Kge2UojHQ/wVSBC7ao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4863.namprd13.prod.outlook.com (2603:10b6:806:1a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 13:51:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 13:51:38 +0000
Date:   Thu, 30 Mar 2023 15:51:30 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: fix db type confusion in host fdb/mdb
 add/del
Message-ID: <ZCWT4tK6aNBshFcl@corigine.com>
References: <20230329133819.697642-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329133819.697642-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P190CA0030.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: df94255f-6914-4b7d-5243-08db3125e1dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wyzWGM+kcVcf1UuMRhBFZiplHYllNEdqWhLSZIUkV89xHo5BlFfuGWdVmv6rv3JL6R8C2uAWdLaEJgHGFzRJvJpJ3VCzvN3IVG2L0D6mguc7bP+DxJZCRzmMpCDbFgso2jQ1z65In9dbG7fGJHdoXMwNI6C64yb+UO5h3CJ13feahA1k53122CCMoELtrjyKWDbHbFSkwvE7/Re5oE0nAGjrx8+/EVu25XL5qXtJ7IYoFOLtfQJJcdf6arxPaJ720HccncZKVaTksT9dYzpJTCU2n5zQOh5m3tohQ6sszhNApw/Lqf1GxiOYQ4ozSftuNGRRXIwkFG0awtttHe7Ujv8ukGE/nDHr21aYnIdrKoMqtNGmWpB+Q9lKkGrE4qb0gzWUnf1PIzVH8nqlDytUCXZOggE4vSznffmNoSWAhtK0GiqtsfMHLp91Zufv+CXDnVHshNLMs6TTZwLySVyS+wcikAld6e/ayzsjDihpwqYgfhQ6A2pGLMxM/PTpxk81buqhjwjQR2/wYXNuQtPB7NJHqDaKIcSpPIGLMOa6w99w8HOZjO3QJRjAHcYBbuvv92+xBQ36uczA8E8+lSj/QP94+4BRwTXwvPUltgfPs0g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(376002)(136003)(39840400004)(451199021)(36756003)(86362001)(2906002)(6666004)(2616005)(6512007)(478600001)(83380400001)(6506007)(6916009)(4326008)(66946007)(54906003)(66556008)(316002)(8936002)(41300700001)(8676002)(6486002)(186003)(66476007)(38100700002)(44832011)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uDURKyHN5lqrCxykXAihZsT76uXB5Zvamd5r/ok6CjSYLvffhiHDAFIevnod?=
 =?us-ascii?Q?hnGjj2LMN6cQdK6N6NwzhJgD2g47kFvIA9quP5Tvg2Vt9cuX8sQ8jXZX1/By?=
 =?us-ascii?Q?cModz+B5eQlbja+TUYNVQRWf6zJRfStVIf7D8lo8pX5vh2VK4k9grU3ZOT5N?=
 =?us-ascii?Q?F6OkzdprxMTBNgdCwl4tmAMcqezpw3ypcxCJbwiHH98u5juPsek/BxWdFsc5?=
 =?us-ascii?Q?IA7Cd5sEtQwhkJZlRlprcG/nBhaDjjbGgabsN8I/gkNGjJhXvz/qkO8THtIQ?=
 =?us-ascii?Q?RFmMk/AZ3cWxUnS5FyJLWrH1wdXrB8iuWBf0SCdXHDO4t+UNcRZxLe4W2qat?=
 =?us-ascii?Q?dDKGLzqAQW9YA2N0f3/gXN9LeyrbU4z2Vv1sCHDZQrK6bLMejeIJ1fBHJ+be?=
 =?us-ascii?Q?QWg4j8Gw982Gr4qrSDkZfnYbk5oa1hT9wGfXSnfsS7qu+oWTBfH+p3oLNZK5?=
 =?us-ascii?Q?vSmTzzJVG9+LEJ81Any5/FgqdDX88KRPUXZOZ5Lrsoh8mk9Bmlj6qSRoQmU1?=
 =?us-ascii?Q?Ok1bg0w9YZdwJ9wxNy0MZzXtA+p9qjqXubk7+OJ7WYRnFWl3cM5aWGsKcQhT?=
 =?us-ascii?Q?fBF/bp5uFs9NIphX99DOwwvHcar4fLJlw7HH1JUzcpOyDUTmSaZJD3mXsjnX?=
 =?us-ascii?Q?cwC/1/ySUCxJaFVsN6uYMmdVVunws5geP0zDjFXx1H0RlnI3jyqyOWfTk5TN?=
 =?us-ascii?Q?1TJPRt/38liVJr92YaQ3g/gDDs/TSi6SLrlDTVncOh/HsF//xbiQ0rqNLN0g?=
 =?us-ascii?Q?yFHMe9mH4DMe7XMsv8kOTt/YmrSyWDm7RFhP8h8iYtvkwKzvFMJc9LheQ5Ql?=
 =?us-ascii?Q?GzJQj8CLqRvV21nUqGBYLDLYtNhVXlGTd5OMJVfkBf1W760w6uqVpqbI1iwv?=
 =?us-ascii?Q?ORSSPy4tbasA5V1eLNviveW5pxHF4ICmqnMIsz/RkHb9anDqK9aYk8WMTOI7?=
 =?us-ascii?Q?BwitYcM5n52PeitficM2EjvaNsDF0FJdBny1DKKPalxq6GwOtyBZoX2XV55r?=
 =?us-ascii?Q?NGetgs3jilf5kByl9N3ytS5I1ruaf0ZRBsLRAY9AP++yMktSSjJ+VLWgMdFl?=
 =?us-ascii?Q?zeW7CEYO3lsuBF3XyqQXlAuHbv4PYopkvBiWdv5hX9OW8MM5MOTr47Dd1LFu?=
 =?us-ascii?Q?FMOKaS89YuqtKRYhkrWefK2Eq7wVDGslRTubFrlswwjRIEt9hF/tviQvamVm?=
 =?us-ascii?Q?ZIiLzwB1gL5HLKqdCmnQRlVQ3wMAdge7dwBRvda+TP7tywWbBIcSm/2FHF5K?=
 =?us-ascii?Q?Tbo7gzACeTgy61Uy49VvjT4QTXDYvMActzoB9VvjcREfl1I8vPkEE0h6loLs?=
 =?us-ascii?Q?G3ZLVaayz99soo+JN/4DeZcZcmzh/HLVKYalQ1VLMsMM7fEi7434ic3tPX+/?=
 =?us-ascii?Q?QBWGNlWtqXPX7UZ1JUORaJOcj9xzbxPt6ykph4zExYBHAqNAAuHGOVCIJ8Wl?=
 =?us-ascii?Q?YXJJZOEc+Q6XkfFc/FLo8I8r0qZmH5OFaGNxVxHzMYy1yeAf3jEuG05sGwb9?=
 =?us-ascii?Q?+y1V/PFO6HzdIznGcD8SEIsLcwnaRu7R51LdT8u1JJ/Vl0tX8BPb+D9YB519?=
 =?us-ascii?Q?jYar2krtVJYEYRX790MqxuMUD2zAKKem0e9LrOyAWPZz4CuW0wGmj2vCkMvK?=
 =?us-ascii?Q?xddptLjTK0h92UD6GgP+MuY3WdMeJd1+VnfsVtzCx8Krph/ZzCRIi8wpw+ME?=
 =?us-ascii?Q?Y3zK4w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df94255f-6914-4b7d-5243-08db3125e1dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 13:51:37.9532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 86bI7ZJbjPFygeSDaSSaeSrGJrXSVUF9H1a2KkyVqFJ2Tg9j3wQwROPgUGjzL3MWVAMqOZ+fpAhzYhictj5uVI/EZGfXqzwSFZlv7VfH/GU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4863
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 04:38:19PM +0300, Vladimir Oltean wrote:
> We have the following code paths:
> 
> Host FDB (unicast RX filtering):
> 
> dsa_port_standalone_host_fdb_add()   dsa_port_bridge_host_fdb_add()
>                |                                     |
>                +--------------+         +------------+
>                               |         |
>                               v         v
>                          dsa_port_host_fdb_add()
> 
> dsa_port_standalone_host_fdb_del()   dsa_port_bridge_host_fdb_del()
>                |                                     |
>                +--------------+         +------------+
>                               |         |
>                               v         v
>                          dsa_port_host_fdb_del()
> 
> Host MDB (multicast RX filtering):
> 
> dsa_port_standalone_host_mdb_add()   dsa_port_bridge_host_mdb_add()
>                |                                     |
>                +--------------+         +------------+
>                               |         |
>                               v         v
>                          dsa_port_host_mdb_add()
> 
> dsa_port_standalone_host_mdb_del()   dsa_port_bridge_host_mdb_del()
>                |                                     |
>                +--------------+         +------------+
>                               |         |
>                               v         v
>                          dsa_port_host_mdb_del()
> 
> The logic added by commit 5e8a1e03aa4d ("net: dsa: install secondary
> unicast and multicast addresses as host FDB/MDB") zeroes out
> db.bridge.num if the switch doesn't support ds->fdb_isolation
> (the majority doesn't). This is done for a reason explained in commit
> c26933639b54 ("net: dsa: request drivers to perform FDB isolation").
> 
> Taking a single code path as example - dsa_port_host_fdb_add() - the
> others are similar - the problem is that this function handles:
> - DSA_DB_PORT databases, when called from
>   dsa_port_standalone_host_fdb_add()
> - DSA_DB_BRIDGE databases, when called from
>   dsa_port_bridge_host_fdb_add()
> 
> So, if dsa_port_host_fdb_add() were to make any change on the
> "bridge.num" attribute of the database, this would only be correct for a
> DSA_DB_BRIDGE, and a type confusion for a DSA_DB_PORT bridge.
> 
> However, this bug is without consequences, for 2 reasons:
> 
> - dsa_port_standalone_host_fdb_add() is only called from code which is
>   (in)directly guarded by dsa_switch_supports_uc_filtering(ds), and that
>   function only returns true if ds->fdb_isolation is set. So, the code
>   only executed for DSA_DB_BRIDGE databases.
> 
> - Even if the code was not dead for DSA_DB_PORT, we have the following
>   memory layout:
> 
> struct dsa_bridge {
> 	struct net_device *dev;
> 	unsigned int num;
> 	bool tx_fwd_offload;
> 	refcount_t refcount;
> };
> 
> struct dsa_db {
> 	enum dsa_db_type type;
> 
> 	union {
> 		const struct dsa_port *dp; // DSA_DB_PORT
> 		struct dsa_lag lag;
> 		struct dsa_bridge bridge; // DSA_DB_BRIDGE
> 	};
> };
> 
> So, the zeroization of dsa_db :: bridge :: num on a dsa_db structure of
> type DSA_DB_PORT would access memory which is unused, because we only
> use dsa_db :: dp for DSA_DB_PORT, and this is mapped at the same address
> with dsa_db :: dev for DSA_DB_BRIDGE, thanks to the union definition.
> 
> It is correct to fix up dsa_db :: bridge :: num only from code paths
> that come from the bridge / switchdev, so move these there.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

