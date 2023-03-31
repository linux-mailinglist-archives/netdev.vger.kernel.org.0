Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0600B6D248D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjCaP7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbjCaP7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:59:51 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2123.outbound.protection.outlook.com [40.107.102.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628511A44F
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 08:59:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmghHmrK+PK0QKKRPMDjnMlVdBWpa1is8TqH/NRRgIbibkzTsuKaMhoVfF1fBR4tOVHSIH6xolENIgjtjZnf13y2zjNbX+DuqeGG1zVl5/OKCpsd/v78OYitb+BkEXlMmZc6mzsIqHuwAGdm36mG5bOY/mJstdHeXSkcGc/X6+PxcPAXscmKio2MsBfndxRoba4iq3BWkt8VAOq58VyUWLhd+NQhofZrsrsJXi4Id3kUsxaQPhd4yeZVvh/M7XvFV/rUO+1ugAiFLwnC1/gJLx5MH7MhMq8QYsta2NsQA0KYa9ChOPbNx3uSrsPTHQuZrfHWvKhS/hL2PTY7kv3/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zD0dgzNjNtWnphm8aUe0uy2+QERwfXudHjfVsY5EJg=;
 b=QmUYDtZlDBWGC9ntihOfO1DctySMnH114bwy4kSgo0fY6ivwycm8BB0rFs6kN/m31YAb77vavq3d+Q8Mbo7bzQlHA6hJWyY0dhBimpVSlLX8CA4n+qqutSFpDlnMn80GvOLOTbvzmdf2/ujsgdksFhD8a0HRj4arlnccJzOxKRX67rBSZEBHWPpeJugsFl7HnUkXon1fuit/UE5LYKyqxx68lxrZb6kmJMBVRed6+fefsETLQauxBd54wTFnKiQV1FJBPdCo9R6PvKWIZn5HaMhCPg+jxddJQdcHy2/NCl5JVwJND0UIVcO/0pJYkwCZ2TPa6fgNJk+MzI/NvoPjCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zD0dgzNjNtWnphm8aUe0uy2+QERwfXudHjfVsY5EJg=;
 b=qWKfI7NO0K7N+YXaLt6UaZxPoUzwXpAgT+9EDMotlKJm3uFSiRJSjceE6x8qDrfhQvgwu5Ry+XPL6qsazXy5pYDbFqDkL6pyeRNqcxYfm+VoIV3bZ228dD/46DXh2ohItTCFDNaZMtNUijn0+XfDE3q4+5PliNyuJrZ4rmXa++0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5108.namprd13.prod.outlook.com (2603:10b6:208:353::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Fri, 31 Mar
 2023 15:59:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 15:59:46 +0000
Date:   Fri, 31 Mar 2023 17:59:37 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 09/15] idpf: initialize
 interrupts and enable vport
Message-ID: <ZCcDabCHzjXeN+xI@corigine.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-10-pavan.kumar.linga@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329140404.1647925-10-pavan.kumar.linga@intel.com>
X-ClientProxiedBy: AS4P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ef34c3b-6247-45a7-0a17-08db3200f2f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d2PzpU1mD+PwQd0YwJPde56tAeROOZD6RfpK3BhFzjRRqzSPsCFrbH1DhBhYM/3G23gbvGs8w+dGYpz9580bhTP30XR2ET75YYTI2iI2/D5zbYDcldpL0DAnBshSrRmuXcceieENZ75SuQoS7Lbvue/pnl54rhDD13XzsuiPruw83JRBBTPVl35hIgOaoEZY09FIqlxG+i2ViKNgOEpzDTfgAj0cPVOf2d4Ih6O2ba8hewBd7VB8KDeSZaxhnzR7o5tTb5rn9+GydIs/3Ywrl6pxohY7cHLclAlyAp6IRPQnYekORWEfRcd4c02HKcpAGBB1sXlJvatBS5FvBbXtKZuwB7A+De2PX5PZDVjYZiJVwP14D0Pr/1ghf/sT59KEXomRHMq0ziF45OSJsPEuPKSMJFTu4MZAK4nXC/U1zON58eaQuDmOE0kKC4NHssPUWbd6wRD1WozkmY/eSmxFOLnBN4CLNPxjyE35sPsATXok83MKNfSbdzytYkuBwoOA+8Zw6Td9NXowKXa0fVhK4FVkwqDGwb+ljNh+tHkjYz6jdw0vjokE2btRUh48P46ri5dHWEUBaCBsqvNQ4uHXppQevggM2N+sQZLgJ6/2up8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(136003)(39840400004)(396003)(451199021)(44832011)(5660300002)(7416002)(8936002)(86362001)(2906002)(41300700001)(8676002)(66476007)(66556008)(6916009)(66946007)(4326008)(2616005)(54906003)(316002)(478600001)(36756003)(6486002)(6666004)(6512007)(6506007)(186003)(83380400001)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TNHyZkXn12PR7C/eEVTDa+imDu+9vHwsdW2lntnoGoRBMu6zoJJWreT/JcsZ?=
 =?us-ascii?Q?p85Zi2ikuPHlD7HvZsCGeMwU60ZyFOKzb1tugrgwRyv34s8wjEe8kgV7LWDj?=
 =?us-ascii?Q?RwgeiWskk+OIiXAMreVQXPFlwxbd7LvOKLwfKu9x6klyshrzbePVgjF3RnZ3?=
 =?us-ascii?Q?oPR2nyhCVflKEiaAomZouietGvf/hNjx14Q44FDQkY1FXa7jIbHC0cnnhO3Z?=
 =?us-ascii?Q?2Cf1H+4QOT6j+h4HfkKxS0ugqGESo9qowfovXUlqBlkNjpgpEwFE0BkFUfR9?=
 =?us-ascii?Q?AetE7Y3tZcYoof3JqWySsMWS+RPLMxSmNGSTwPDSKrjfrjB9H0W+TYtfvpzQ?=
 =?us-ascii?Q?+fotvwJ+tohEfPm3lbFxoEgfNvpH0sr1xAnPvFaRhse/sECkVTTmIH2wpGWl?=
 =?us-ascii?Q?2fDad5+JfiQoJqU2hjaQZqHu5cAxpXfrkTLeoB+MaPcVaIZGdPHxiRtOtGoM?=
 =?us-ascii?Q?J/o6jSnc5Xg17COdXPhZa5SIVnX7/gZb8nw/gIChIJ7yWlExfXreJPjsUhzA?=
 =?us-ascii?Q?3SW4e/1Vj6/i+/L4vmGmqD/l1xWyOWpy8VDvfqFxsLgw+Loz11G4NU2l5Wxy?=
 =?us-ascii?Q?5x9ssr8Z6c5Thn4qbP+q4cWUdU3ZnT09z+WMrXnrMdul+PWtxWYCgk7COYAm?=
 =?us-ascii?Q?FMwG4DqMyhjRoqaIp5/Wjqkf8HABNDtpmayLDQtjbWdojdbDNwVsOo4Huj0Z?=
 =?us-ascii?Q?Uan7IP7C8MyylBxd7dkZTonJN4epu77XBnmF5h5ptYAyvN2KqUdF+5IX7ZZb?=
 =?us-ascii?Q?Wf0PtUtBrtduBcXx6LJB7NoFSzEZpTDa83QE0xCVG/r3Dq7nMKEA5A4cJBhd?=
 =?us-ascii?Q?LUNN2vVZ18No6igQQDrb7TmiLLvb8fA8Ffr6Cha0CFjaGbV26KSXkkHotIqD?=
 =?us-ascii?Q?rKMbYJXEQzKLVP5L6ohEb6R3/T8OZ+PCCl7kYDgIH8jDmXpUR6FJ5YTWv4aO?=
 =?us-ascii?Q?AypfXlVH0CY79zwoBhWGn47+9S4Bsls4d0bLq0DVT3v+TC7BvEq++9o/z4DF?=
 =?us-ascii?Q?hM5TPIyVHltbAcr5f/gdm8MKgLLI0bR2l5i3EoNWNVs2BzNpgCzsCQS3KX+V?=
 =?us-ascii?Q?9IfBkbUkR4xZvpwwzFnstpjHeiKvqNehvFFKFyNq03fKrZMqnuRwqjD11PkD?=
 =?us-ascii?Q?VqQczLp4pns1Q9qDFEW7NJVsdWmUJ3cEJA6BEsoJ4U081HYgMyXCcqfN0KhK?=
 =?us-ascii?Q?L2fr0PjOXtwC7xb/zXa526gi7QioWw7QtoWixI43x8B5miOVpQH4p2lZx/Uz?=
 =?us-ascii?Q?HM2rU7g89Rfogrv6GPYYvLAL7Pr+p1z4/O9Qo5IYy6t/D8WFlZs3IWsz3Grq?=
 =?us-ascii?Q?iyWxqlhGQXxQkqu0sHreu84gPVvs4iiDaJWyeY/I/614IENsNt+Qoa5umldT?=
 =?us-ascii?Q?NrfF0Sx4LpeXlO5YIPzwLlNpFP8c97LDUgVacVIVbY9iFUa0rFW1VkM4Ffoz?=
 =?us-ascii?Q?gr8+Y+z9aXqbtFUc3m++/L1DmHNenIlH/4Oh+VxdhvnpMgvdneJn6zMmlEim?=
 =?us-ascii?Q?+yWUePrTSCJyvNCRyCx872K7cn5YssGm5fy0aiORYFQlSZE2rHhGJcakBqFc?=
 =?us-ascii?Q?dsvNy60/ZwWwf9/sam2orFK5WIte/h8FYL7JmI5s9DZT6huzh2cwmjReRWwg?=
 =?us-ascii?Q?kshW817H52wJ5whhbCjasfy0t88k7Toe/Zg9GxCIVvLuNa8DyavbakB0ntpT?=
 =?us-ascii?Q?Orp1SA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ef34c3b-6247-45a7-0a17-08db3200f2f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 15:59:46.3184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+21YCih2aldNB/7kekEKbnDSyGX2Qoyp016cBFG/RWBGvqKEJyWYE8UbEF8thEZj+t1GYQz1KiuhQJ7FY9CbmzfWOKWBGMLX1dub7oKEhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5108
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 07:03:58AM -0700, Pavan Kumar Linga wrote:
> To further continue 'vport open', initialize all the resources
> required for the interrupts. To start with, initialize the
> queue vector indices with the ones received from the device
> Control Plane. Now that all the TX and RX queues are initialized,
> map the RX descriptor and buffer queues as well as TX completion
> queues to the allocated vectors. Initialize and enable the napi
> handler for the napi polling. Finally, request the IRQs for the
> interrupt vectors from the stack and setup the interrupt handler.
> 
> Once the interrupt init is done, send 'map queue vector', 'enable
> queues' and 'enable vport' virtchnl messages to the CP to complete
> the 'vport open' flow.
> 
> Co-developed-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

Spelling from me again.
I think I'll stop there and just mention that you might want to consider
adding ./checkpatch.pl --codespell to your CI.


> diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c

...

> +/**
> + * idpf_up_complete - Complete interface up sequence
> + * @vport: virtual port strucutre
> + *
> + * Returns 0 on success, negative on failure.
> + */

s/strucutre/structure/

...
