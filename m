Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBB26D245F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjCaPs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbjCaPsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:48:19 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20354691
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 08:47:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2ZSZPZunnkfSH22CqEpsULkNsnwSqQrHRXimJlqnv4aZ6noqjerHDQkYVH+38pyd9oBNC8en5sg/lclbbAMk13zLCM3m8dQKXTKU7XQ8BTD6CYgdIsAR50iHJBcpDEAU4yBR0SGhafGQHOlrr8b8yDt5ynzU/YD+6l617kHnvMN1xZVPb+1yvJsYTceNPtW9SSloq1+YDdmjM/kBaWlZkiaKiEIe8z5bopzhVPsU8ZqPcbh+kmwsPiq1TKzW1USPOL663YptuB5UCqjtFNlCP9aKqXpLyrkJ4RoISNHaXyYq+adL8rfmk3TmIOSu1kAANSOXSVvxsTrdU8VjAoBCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7scq0GTVlOa+YvijD1WDNMNTT1hIeScN808AgF51Nw=;
 b=aiJgtE+Ag7dKVW/gJ5JNqyQh80ntGYRC2fw4ueSB7t+OJ8CEKiJugNWBbmwS/gFXg2QMdaUfRsSaF2vVyupVoUZz1+TLauKyv1EpW3eOSYvvU4lS/aUoTsXo2VxIlgDK1bh/3Fk9/czCWrjjiSEtHEoQ7ZdOQJ3wN//HBoyBqmDcqMbMuz8fdYucHnFALp4VrOKd6hrywQ4tBFcvqs1+zrc9JJxQfRRef0GFxX1gA7J0Mn5qCm/oPiMMWfM2FYWX7YACmPXLGxV9g+wXT2bA9AVBKv4O9hUiM3ACnFcA5MbRIl3AphbtSxpiRiHszUY0b4oZUWU+BdoPJMNROCxKLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7scq0GTVlOa+YvijD1WDNMNTT1hIeScN808AgF51Nw=;
 b=n3JXhs//xseTOT/3DKMmt8CmFrtRl+73F/EEfd/ZNF7Dt0HYHS2uBugLi63zzg3ghu9LpqBXRQEJ2hhBrF+HTUADEtvqiosde74o1N9TrstdKsfusjCme0tdZw8yMgEmSVlZLHWeQXvlCFjMwprPJZiw6zlt3nQLqgUd9yls3To=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5151.namprd13.prod.outlook.com (2603:10b6:408:152::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 15:47:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 15:47:47 +0000
Date:   Fri, 31 Mar 2023 17:47:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 06/15] idpf: continue
 expanding init task
Message-ID: <ZCcAnHMxjRhSdKgp@corigine.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-7-pavan.kumar.linga@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329140404.1647925-7-pavan.kumar.linga@intel.com>
X-ClientProxiedBy: AM3PR05CA0099.eurprd05.prod.outlook.com
 (2603:10a6:207:1::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5151:EE_
X-MS-Office365-Filtering-Correlation-Id: e109e81a-2ef9-4369-165f-08db31ff4670
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pCUnBM+mXk1lzhBiLr9yRVgryf9qZ8xgEMnyHCUlSqx20jix1nyLWRZoZsTH/1tutGLvdVthJOEasYSxG4rtKsuGOEiQeiKh+mMl3Z957ljOU0NajA5dQi3mRbd6PnA/yaOrY9iZ/pG7bSlty2FyjXRTOnSfFQo5CMo5FBuR66z4KXpiRGSVhDbS1empBXpDMD7UdRV+Px0/+Y47JMFGhpml//bFyXSqddKa2mrfuGeDQuNzrUd77vL0atvlyo+FsB+EvsANDcY16BKvjajbcYxi/G7SWMk0rDgsf1Pc7ezWhp8JaW4iPfaXp3b7ppevTH7QyX492bs/rUQSgXcgPI6V64TJEHU3uvsBsfS+fm5/6rzqxq/YWfh3GtKOQP002Ed6EnFA3BvC33sl+0XTcLbPQCp9LRdV+3ZgLHfOt+tpEswx54qrAZO+swkHe5sV68AYrRCtKZtLHUmrharvDXsi7OXUIDHwnhMa214+PzBnOrGsp6hvANPYhXKiG3WBsYm/5cRsWBUPb9XV7Q9KiBPPjXJCR9oWKqwm5bKwsNkX5yNCgPj1yJTsl95/T27LhHP8H+v9qp+Fp00BExyfh1IDzmffyUZNgc4mdGPG4/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(396003)(376002)(366004)(451199021)(478600001)(54906003)(316002)(83380400001)(2616005)(6512007)(6506007)(36756003)(186003)(38100700002)(86362001)(6666004)(6486002)(44832011)(6916009)(41300700001)(7416002)(4326008)(66476007)(66556008)(66946007)(8676002)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4FyT3HrEzrbR/ZnfZ2v5FDxojnIeYIknl/hKuezYjKcwuKkSFyqqk8GDBBrA?=
 =?us-ascii?Q?7HVt1ETtksMQTTQ2UKeiA8JEPWi5IOOYikTzynLDJ/XjX9iVo5uDRmKtXgeP?=
 =?us-ascii?Q?Y387XoPquXnN1Km9r31PcxhsCv9ssTCPlaoemIjJjwykDjKSZTFd02bJDLxy?=
 =?us-ascii?Q?tDteDE7ITkKgyUPiwmTrHMneqigOMovXEbOEVFYtiq36BqSP649Ug5Z2oVEb?=
 =?us-ascii?Q?T5mcNHIaV4K457la3flMhqmBDo5THU2peXakGXihtkqrSX1Vtrhagl4b+bDZ?=
 =?us-ascii?Q?3ic8+fxLZQOPstbavquigBiEUYqeZ98uqIlMopmrQc64U5SXM7Mv/FeWRKSQ?=
 =?us-ascii?Q?1XOYjgbhxLDsB9lnxeo8nWNwnaCuxLo5fvruwr327yJVGTOPcPfiVjFlA/ks?=
 =?us-ascii?Q?Xpd3vIawtL9CaldjOmAVqUTlFokNA452VO1Lrg1BTFTI8sBjI0wrfw/j0mHR?=
 =?us-ascii?Q?+PRQWJpBvGCVs93KpWdcN/vKshJz9B6RrjIuSOY9J77d4rppsgK77k28s46U?=
 =?us-ascii?Q?mOX9hxCefNJVXpB/HAbOewEGJUT+tvt2Ll7UtFfjfIPQdgr/Q7qk9XI0gPE6?=
 =?us-ascii?Q?Vsft61oluszL5AVrWiqKpxX29q0v0NXnx6Ml/os9q7vXXIQFIL6kiTdsmwqr?=
 =?us-ascii?Q?F26ESBIZ/HYCu24KlPGJzHaonr1sPuC/NU5xhd20SADZm83fFW3C+U2rVhVg?=
 =?us-ascii?Q?O3CQClLZUi03gQ/R5p/3rxnKtukHbMKYMHFSIQOeQYKlBq3afrah5ArrQyDa?=
 =?us-ascii?Q?ppBSfxrfK9EBE2/izbiJzxNca0sxyrl/fLhL/Lpq0oZPbILMx79lVLyulu/m?=
 =?us-ascii?Q?j3vaZ9oTqZo4leC0jPFI3mAYzZsP7od00+Fbj3hXlxm+vNnERf2tg9n92Zxv?=
 =?us-ascii?Q?UdjN2Zcr0RpYnW9ijX9X/54DU80Mv1Oy7pY3I4aD38vbrFKcCgNpV9fMrF/w?=
 =?us-ascii?Q?ondBtzufM0tgYHhR7Y9PositoqV4bS8TedhOXcOMrOubDhwyVLFNFC1nZrGz?=
 =?us-ascii?Q?Qjk6DD7q8kdazl4EASCS6tVcipYA3+P2Kd3dwJjlhT0UUk5KDZqMOiYbA+aU?=
 =?us-ascii?Q?Z7yE1766qE3c5ywGpm8dRbN+vnc0O6f2/6iPTEknx1T4b30wVbQTdsPShOiV?=
 =?us-ascii?Q?mureuAHnI4vCZ9MJYhUraG16FMP1LOsbp2tkXVXq1uQ8FRLL+FWKtpcFrtE8?=
 =?us-ascii?Q?Ya3XFHh14egtHN6skBbzci4VyQoYWf28O59qK7fakRqbXg5BzX0/9Q/Oz5xJ?=
 =?us-ascii?Q?9pQvQC4Zlp69eHN/ydSPtsZnS/uv/7jUsB3+nwzCYbp5Ll3DzphhzGcsGmmI?=
 =?us-ascii?Q?0bJcxZKmiJfZd6JplXpAUB2YIuAgIV2voskrZCeIMpYem06EwSuBSmraIoDY?=
 =?us-ascii?Q?sNfJMMOgNLsQf4uILNXUcnqp5cqbP7YMaT6Y3MAyQVofsRUZLFf14+GRuw7P?=
 =?us-ascii?Q?1pwnYqo+MtZV7DCiMfsQn4oN6TlVHCpTJo5Cjy0JbmaDbHWbh9kJbEGoRlGa?=
 =?us-ascii?Q?1JU3X3RVueqT7FAV0LSu6lAiV4JcKxdpzrpk/qHkxmhu/jpb+ECj35PZmVoa?=
 =?us-ascii?Q?GIV1X7AgdI7O/MEmDxvsLip2bejgC/i1hWa5efs87SgEFqjRBnw1qipt4n5J?=
 =?us-ascii?Q?GYLuNavhvue7odBHH/UZUeFBxwTw4oojBU835vmacTN9xpxlNmxB/q6QfgpF?=
 =?us-ascii?Q?vNW9/w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e109e81a-2ef9-4369-165f-08db31ff4670
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 15:47:47.3160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvhLGvHE5NBmjWZh9F6Y7wUHv4YoUWaDAUl3i7ix9ay/GFAyMRT0q2+EyW1OH3IrpGObs5rUhTsYYZpQvYXBaLjRCbmnGUV54GLOe5tO62Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5151
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 07:03:55AM -0700, Pavan Kumar Linga wrote:
> Add the virtchnl support to request the packet types. Parse the responses
> received from CP and based on the protocol headers, populate the packet
> type structure with necessary information. Initialize the MAC address
> and add the virtchnl support to add and del MAC address.
> 
> Co-developed-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> Signed-off-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

Another spelling nit from my side.

> diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c

...

> @@ -1432,3 +1778,139 @@ u32 idpf_get_vport_id(struct idpf_vport *vport)
>  
>  	return le32_to_cpu(vport_msg->vport_id);
>  }
> +
> +/**
> + * idpf_add_del_mac_filters - Add/del mac filters
> + * @vport: virtual port data structure
> + * @add: Add or delete flag
> + * @async: Don't wait for return message
> + *
> + * Returns 0 on success, error on failre.
> + **/

s/failre/failure/

...
