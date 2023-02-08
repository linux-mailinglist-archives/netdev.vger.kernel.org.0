Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F3768EF7A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjBHNEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjBHNEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:04:23 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2124.outbound.protection.outlook.com [40.107.92.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BEA46179;
        Wed,  8 Feb 2023 05:04:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxETobLHU688hREXFucYVohZ+u/CimJdhueWTB8jxZEZ5dNP7fPJt3Kid9TJPPpOTiurd07duuHLqBRyNgr8lJacmjYnBLkpiC5GdM9GsBgdzbTqNWZQByctKB9v8dYTwYswRn/grTAxVPOayvL/V96+gmSqVWR+I7K4Tr3165B5KnEDNP1QWBHdEzyS4JaebtV63k4cmR+rHq9lSRShkk+k3AO+61qDetGBie/LfC0q8W5I6ntnWvupiJl1a9sny14i1qTa7rRAATdHIV6SAok8rD1GAzvfITHG+244AaLRi5oVl95nWolrRCQIKT8nI4/VmKP+xPkZSJDnYwFLvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJDGOrESqVw7O/6115CebnbOEq+KHWZ2tAT8wWIZs98=;
 b=hZGx6BByRhLIKpMVXQY856LAABnb89gyGCMlB+2IuOqLnN8xnNEBOOBO4JIQV1ATOuHN+LRfPOAKQxg/3FoWVWE/D0cRbWWqT9jD0RsKijE/Yqlk/IsuZ3Wm7c0jcxkdHuFi3hrrTErcgTAwb8HVutZV7BGY9FBR6WMDUGn8EDExJUEy4D9ZQFOGGKm4nkyQMc7bv6wrUmiSW3kZqFWLrxUU52qU5zOgTtglNkO5cMQ+HZ9X05i8lpX9XmKDsJknYAylFOoJ8oJblPWg7YjkentBj06iBsae2icqM0ADJVUsCP/NtR0b3o6Jn0P8+A68PHpuV3KaUuH9yZja72zJwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJDGOrESqVw7O/6115CebnbOEq+KHWZ2tAT8wWIZs98=;
 b=MUnl4PP0gqu/BA3PB29P88G+CZcVmSWMUn2mt7Flzn83LslcVhpCS8J/kTOUvWKu/scVvgn1OMNIX7IVOEPQTbM7NFstW4oOitZGxxYzmF/ddC0Hd9gTse/NwLfGZgvqMURS5Y3VkxviM4IG8kFfBYuhL1h4c3VoATO2JgsiUNg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5699.namprd13.prod.outlook.com (2603:10b6:510:116::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 13:04:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 13:04:16 +0000
Date:   Wed, 8 Feb 2023 14:04:10 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        razor@blackwall.org, roopa@nvidia.com, pabeni@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] net: bridge: clean up one inconsistent indenting
Message-ID: <Y+OdyiQpz7lIBfh3@corigine.com>
References: <20230208005626.56847-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208005626.56847-1-yang.lee@linux.alibaba.com>
X-ClientProxiedBy: AM8P191CA0005.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5699:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f1b531b-4a0d-4f67-9dfe-08db09d4fb4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FkoMkAwgUkYrRcpYEryELrT1EaGQw9LeUDkeotqUv2C4MCQ0YjXYhz8zHLjXDXPGHTdTIIUF8GRrLHNmZX6besDM688s0nl1Yhq6msTzvuiZGAZr9z1Hsm9RIfi1LdVH3TujkSV3xwG4dHGUz2o52dDXY+JkZUpD7/U/H/gDmNX+8iFQkW8n+BUeIQcYpeSBAfgrcIcEhWI6PLWgQJRrENkDKFU7g2hv0BrczyUHENV/5E/+3I0B0SeDQ/M2OkUcs01KvZ4GejNT7rF1M+PnvjRpUzRQt9EtQF5/J5Ul7PlJtH3G7FrbQEvLdUW4qJgIRtBSZ8xVEmrQH0LeE430aqWIDhpwqVipyP7Obd03SgQQ0RWFjCJ3MOO4wltBgThGZKKoAJ7rXftIAkGcwfdidzzDrMLpTFxfe0YZKHmxNadprcVjo9teo1YrpzOADA0XP1q0WEMaWUYGt/6y/RXqtmP3lKwNLWVdlSKR35cYsCoYIzJc7L6HRuAWH3Cqliqz4viBengB+Fh/9+u5GgfyoWxz9vvdk2lp8vlPqAvaSOrFBnjExxSCu6xDGV9Rtb2Wu0QWwalMUZD/m/rpJo3VNoy4ZVSiSUXK+ctmK8cQYbS10JVCI9wxRBmAhXa3sWaOPFUOi/haUMNTSIg0NzDG18Jmp05EyHLUBb3iMRZU5WQxDzGee/5fG3nfyPwy8dWbqUxwuR6SwctFNayJjD6/p3HyIH2z9K+UtXYSbRimOps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(396003)(39840400004)(346002)(451199018)(44832011)(6512007)(186003)(6506007)(2906002)(6666004)(36756003)(966005)(7416002)(5660300002)(478600001)(6486002)(41300700001)(8936002)(2616005)(8676002)(66946007)(66476007)(4326008)(6916009)(83380400001)(66556008)(86362001)(316002)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8bL1kISOqAMEpPcZbd/ckGAY1AK77Wf0Q5wK5YKFrhRH6uXF4MIWaSfqBpBm?=
 =?us-ascii?Q?LST5QoPUXGtfaexHMzE5SnGyc9vYD65vTHLHdpn2nJltH3YpdktHPkjdnMO+?=
 =?us-ascii?Q?73qxiikDGpOwik9kzbQ0Keul9PpHD1ulS5nI2Q7SmzV1jE9qh3smS4GhiPPO?=
 =?us-ascii?Q?PpwnJcaUWrmfI46oNImcUN61HKF+e3TyCITgTkuoVyH7XfLON6Rcxh+xv81v?=
 =?us-ascii?Q?LEapPYgAp7pYhcM4zMNJ7NfGsE3rYjO2Iu9IXNesppsnfYTUHYwgIdOoBvQX?=
 =?us-ascii?Q?+4a69MMknhgRZnPkoYO7n6CrxQUe6fXmpzRacdAFKa0dgPNUdXInrfW4imsu?=
 =?us-ascii?Q?PAgBtNxs1owiMa/YaUg5r0KmxMRIEqQe2IBkbsAWpJXE9Vnfvt6Rp0XBT+gy?=
 =?us-ascii?Q?gqdxyzxuVIClF8vu8M/OiP+Vt6LftMGb/pb65XBf3/kJ1e2OzewW6PZSoyym?=
 =?us-ascii?Q?RAG7FakQA/NHdhXE/JMqaH8Lv46OsSRzut5NnSpbpJgKmY7Lxq6brqo2fx33?=
 =?us-ascii?Q?mJvKl/CKwFisb7hARED6kD9RDnw9fn82BSREPHJ+SMjRQnIsdxg9I032mBhw?=
 =?us-ascii?Q?FZ3Q8OIVB8Fet4Q0lUyyBrTFM7JLRZEUsERplwzH9Oo72fVVFPASVhV/tSM0?=
 =?us-ascii?Q?FaMh56eMfeZTlvDH/UuIfi/wUVn0R2RaQ57J6cIsIUmi/0Fgoh/In4FGX2ma?=
 =?us-ascii?Q?+VuaxX7/+tgldOQgn5/FSUSvGJGcEw0HJ+69i4xBF2nxZOL1dLI4tmB76wFD?=
 =?us-ascii?Q?i6BuMgdpme7p9PBK313RlghCRSdaB8WStxvIVXKBBIeB8fau72juOT4EEGwX?=
 =?us-ascii?Q?DcQ91F5+s5IIbKjB5jrxWiOi6jGXKLYWECq5ecshAgo/1XrXPc5fWydh7cRK?=
 =?us-ascii?Q?MxLq6dOgBgVeYEbaUDzzMN+9l5o/pejq+CRxEa2jgmiEDcirJ0kE71QRaKN4?=
 =?us-ascii?Q?MxfOqKcX3PQVvFu9ZZBOQ3ZfgUmKtaQ1VYZw5f72ftswtnO/gWcZEoY9T1lS?=
 =?us-ascii?Q?KnrxO2FSvgO27EjDGw6Nn996qWB9SXUG5PbBU+3GH+jt11yQLqdHXq3NtPCZ?=
 =?us-ascii?Q?KG1VgzfSo7nzA3p/bZ/Nr3ZLY1wUYMvnEnEaWpuQZtbk5nxhEsZEqMxVnpNQ?=
 =?us-ascii?Q?GqffT8Nl3BKToPqaIUsAAL//tT/rDbfguQBj8lxg25p29juRzeZwM6zWjHTC?=
 =?us-ascii?Q?b+8nOImanjmk9r1nGJC0ltOJZ1s2jFuEH02MB1cbQrKicWILOsxFwwFNIhbL?=
 =?us-ascii?Q?BFeVFwhNJEPj8LpjZ8xn5Notr8XI7g3ADoFZxcT1gwHbbwHM76NDNCfrny1c?=
 =?us-ascii?Q?8R/6Ucyq+v+iPUQXum0wMwjzMGO301Nj8rVtCt4qtIqT9IUeV079ujUH7x0t?=
 =?us-ascii?Q?5ZdTP3pBxDmMfR1AlEQV9jOE1DC61wwscme4Sa3NUBRQHZ6AbcINZeVS8ezd?=
 =?us-ascii?Q?1PDHid6f6vOZ36xlMcMndQ3VVLuX4rwO6h3xLUgtjSY00M9Dymg/dbqyUM+e?=
 =?us-ascii?Q?TW/y86q/G7Z9SlFRXl5B5NAASrdx3rSB2H5IIRT1O3RQ4Pf7JJkscDuUqHmG?=
 =?us-ascii?Q?bvQVTTwtu9tpirqkZV7/wcSTbsLjuu3vurR7VIDudnGC1+FxMFwxm8cuZD+H?=
 =?us-ascii?Q?K8uLcgQhylX5Ko1IB+ZacSsvkqmBbWAUqF3TblQau3QVtqDtuPXY9DMLG/Cu?=
 =?us-ascii?Q?9OVuhw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1b531b-4a0d-4f67-9dfe-08db09d4fb4a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 13:04:15.9100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mLuzE/dprq6LKDgNXamXpOMw14UeBuZ6eHPaMq2gZBeYD+PHSwO69n2H08M5WC0EJbMxtEnErS799ZhDFf/fc9z8gC4b4gLR26Tp09f4NM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5699
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 08:56:26AM +0800, Yang Li wrote:
> ./net/bridge/br_netlink_tunnel.c:317:4-27: code aligned with following code on line 318
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3977
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

As you may need to respin this:

Assuming this is targeting net-next, which seems likely to me,
the subject should denote that. Something like this:

[PATCH net-next] net: bridge: clean up one inconsistent indenting

> ---
>  net/bridge/br_netlink_tunnel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
> index 17abf092f7ca..eff949bfdd83 100644
> --- a/net/bridge/br_netlink_tunnel.c
> +++ b/net/bridge/br_netlink_tunnel.c
> @@ -315,7 +315,7 @@ int br_process_vlan_tunnel_info(const struct net_bridge *br,
>  
>  			if (curr_change)
>  				*changed = curr_change;
> -			 __vlan_tunnel_handle_range(p, &v_start, &v_end, v,
> +			__vlan_tunnel_handle_range(p, &v_start, &v_end, v,
>  						    curr_change);

I think you also need to adjust the line immediately above.

>  		}
>  		if (v_start && v_end)
> -- 
> 2.20.1.7.g153144c
> 
