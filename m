Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1706C9472
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjCZNSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCZNSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:18:17 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2091.outbound.protection.outlook.com [40.107.212.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B212110E4
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 06:18:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f63TfuLJ+Lb6ecH49ZVzlwB8UDIBKoQjWYKWbewm+1sICTl6zroYubZmZYvEq2eb/B7Vs3k51K9KNSVu2ejhjz7lXDe78cfDwzZu92j73HkyZMuO9SUVHUGGB3avdtdBXm4nWWtzUYVRJzWBXlOPDcFFTp/pEEElnn3kMb+gmNf6MMiwSn1OSHaVfMkCZnafVD3pjU/iGrfdscesd8gAaM+SE1zNeGFafm2JOUCrn7uTqK3L1UZLJ4XwksEFHTGtmNWewxMYjDZW/PBCHIpV+fj/4aSljslOoRcmOd/bbYga5PvK+PF2fL3gEIudOjmKvJx1Mx9kI+kPQYY1fCzL4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJmb7LFoSdB9cbXXZV/TJ6dLkPJdZDj5X9qvXhk/WV8=;
 b=Ohzh7r+myop6Gj4UuPLztm28LC+X2JCW4YLf6oRYu2m29Xw3mwyRGK9OwHrmxZJwVUaajkVeBbNDO3DwAU4sM1RcIntN7HhEEXDosE8Q1bhJyY08/6yveMS4b7/akzzlCSZpChwBRzaocJ8kE7FiepMim4BjRD+qIqN4G58dAetWC7wcM7B3/W6GSD0tB0x3kf/YdUAitsjo1hdTaCBh568flhBmCWQQf3d26VyeQoVOdUgiRaZlovRizdlVHm93KGMgQU8rHTOqmBOizY4tegdUV48HIpntzXq2g+81jsjje+EWdapDrqeiX30ycPcFer8O8NMm5vf0pJ35o0Bp6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJmb7LFoSdB9cbXXZV/TJ6dLkPJdZDj5X9qvXhk/WV8=;
 b=jtqlywedrwvxoZGfOLWHq2v/EoUoeNFFzYpOkjRCij2GCiBZRRX9fBM/hKpF05eDwPJz31NKG2GiOOl73ZvWG2YTCLuB+VL775V86SDbQObwoELP/5siLBvRDFTOgsnGIM2m6NhwjFdtbApQDQAohnUZWMHvDNz1j/lcm+XJ3ys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4067.namprd13.prod.outlook.com (2603:10b6:5:2a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 13:18:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 13:18:10 +0000
Date:   Sun, 26 Mar 2023 15:18:03 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        michal.swiatkowski@intel.com, shiraz.saleem@intel.com,
        jacob.e.keller@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, aleksander.lobakin@intel.com,
        lukasz.czapnik@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: Re: [PATCH net-next v3 6/8] ice: add individual interrupt allocation
Message-ID: <ZCBGC47iYuMloMms@corigine.com>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
 <20230323122440.3419214-7-piotr.raczynski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323122440.3419214-7-piotr.raczynski@intel.com>
X-ClientProxiedBy: AM3PR04CA0141.eurprd04.prod.outlook.com (2603:10a6:207::25)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: cd7f0936-490a-40f9-b6a4-08db2dfc8ba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nk5qr6PUZH2neKp81uDWHaprmpnkB5R/LKELPZe36CgWUPvt02JDhu5z/Hqw73goyf9iGAXgWfWDkpO56HNmt7VMxwNCtNi8+wcxwF+0W8+6uznMFxakBwtU+ZWLUF2vrv6Kgs9dknHHbZDqCwQiYJuh28uN3Tzmtvsb685OY+RGGi7jCCQ7I7/yyCwWd3WYbIzfKCSnA4GLVIbJ1S6eFf6NllRf3bzaBDoW25+9VOdR+irPEGqGelu7VzuFyB4ZH6jRRpKiVErdmi2dHz8QRzV2j0mZqgpjk6EADC33rSj82PE8+Z1Am8gi+1/xhDMxXtnoJUjrUyOtt4lJBPigmC3S1gFCzuDg8EI5hvQmPpgsJmLxqBLOEwYPXmWx0lOtYK8xg9dQDiyvFweAF0BpLj1Lb9XuQ4GUASjSENSazWATPKz+kGQtginKPPK3BIXjCj9UlY8xA00u5hO/ASZbzctmcWDUB7xJ3t7LZcimCJJv1DjuxCtA1QBs0qT+MJDChss7bBnY60WTcfAK6fBkWTbMsfG499lP7b0UOHwsEG9/VzFicvuOAhBITppGH9Wq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(136003)(346002)(39830400003)(451199021)(2906002)(86362001)(83380400001)(186003)(2616005)(38100700002)(66556008)(8936002)(5660300002)(4326008)(6916009)(8676002)(41300700001)(66946007)(7416002)(36756003)(66476007)(44832011)(6506007)(6512007)(6486002)(316002)(6666004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ghR4Hnb43L65hFU+kjuGiJEZLOsEP9Vv2/V80sz2/C7EVvEEhGu3r2JmsxZ?=
 =?us-ascii?Q?+mHGT1bHmLqjC7fi98+C3Vf6BAXOtBnyqae+6HCJEnHW4qHOv8dKa/ngS0Vl?=
 =?us-ascii?Q?D00ER1hTYPQ/x9m53ZTW2PVH3P6EWWICTUWjWEUB9hpUVBYShy55H5SiVrw4?=
 =?us-ascii?Q?88d7YaSkNE+3qePQL6PwtBvQNwxSVr59ceE4Hr0ZM+oAZbBhjlj7wfz8BiCz?=
 =?us-ascii?Q?mM1GOxDyAl2+VTPNLibM2OBdN/ooUlSaZ9oZbizBRetJxq96W/6PQR55zKAU?=
 =?us-ascii?Q?d81YymyAw0BtGgmFRPDT3+nMJePBfP7kPZKGLM/qWuwT4vlL6ILkZfJ5BlKQ?=
 =?us-ascii?Q?pn9FV7E4yrLlROTsy5qRlEcsViMed1kJe63EbdgG95KUG8gw2DylxUtQRjsX?=
 =?us-ascii?Q?iSnhjSZF1qpim/gTb5GS9fjka+/gH+oJpDqUJety/hAMCsD6tdWrKXNtPpKp?=
 =?us-ascii?Q?RfZZluvihC5S5h2fxEptqhcfdz1DSIszJWhEcXFf41RVxv5q+OYF37iBcqwy?=
 =?us-ascii?Q?nLoTWD9/P1j2txFJuWon8xHogG7Bb24UJj4v3R06l16E0sKQuXx95V5A5EX1?=
 =?us-ascii?Q?foVFC2nCSyfn8ES9M9DL8RlHRiNAn9aA1MX7CUwP9BDucicRcD5C8YfYE+14?=
 =?us-ascii?Q?ad5niW5dMWKw4HESLsLrJGQEXKyVdgqxhryc92Bs9OgVftgA0YBHqwueea4z?=
 =?us-ascii?Q?rswo5qxaBj3XBFVIm/7Tl/Wo3FBBT2Zn4CjqibWu3gn92/Z9TEmXbCO4BQBw?=
 =?us-ascii?Q?NEBpTXF6wmlGOzk8X3FE9VE9cdB+GiyBw1gVXglWq7LZ/G4fLbeNm1XNqZXH?=
 =?us-ascii?Q?3iwKBqPFfA8UWrfpgNkCTnUolTY99trolNNPaqRYfFVh1hI3OcRHaGVHJXWA?=
 =?us-ascii?Q?2Vto1KASFoIq0ipj/zK5nBTTTYjeMC+BFUPXH/Ce26N5HDzd7+2uOSWkAyYE?=
 =?us-ascii?Q?n+/+X5dFBs10BE5gbCEuZIKOSv9W+YNDAIuoMUJmI9Fqj8s/1AyZ7ymp/wMF?=
 =?us-ascii?Q?2jqLv95SH0ljFIxw3xZKDPKDkjPggOzrsVMRKy133+NGwTepI8aPQgv0ZOUW?=
 =?us-ascii?Q?D8twSX95yrU6MVRPvxhKekTfzWnehuQ5T7BmQz7DKpgnPbzBYr02VmoR1ssi?=
 =?us-ascii?Q?GTs5mhg4iW+FRkIB/4u+a74SND4JqoXon2cJzwGs0JVdy6g7BV2jD7Ao1kyr?=
 =?us-ascii?Q?FIlJEY94PbJMGuxESmHfwmiMuzHICcAtO3d/XlmemKUNfbPVxl9/IOnRlVuH?=
 =?us-ascii?Q?bq89+OefPduWjvMzXuLfen3ADIL4S9GUbGzJmqWidX/dyt8eoAXT7bYI9Ax4?=
 =?us-ascii?Q?1aEjoVjOe1LcPrzDC7m5Dhh6FNmGtIvV8L4kNMrXX4tgrxjsKbRB5luIcTOP?=
 =?us-ascii?Q?hx1nYyj2+jKuvHgCuQ9TMpGLw2CgSLKGAgPrA0Myz0HrJWzYB2pIFzBsZV7+?=
 =?us-ascii?Q?X7rkrlXPSggU9fTS5eNUl55A/tNFkDktT/upKvcQlJhcHCpT7TjTuS5zLOXh?=
 =?us-ascii?Q?wd2COCf1Pr5hatHrxqpQcIsR6xeTTHr14G1JndlO4FcEaDrHn1z8ZmZKgLR1?=
 =?us-ascii?Q?Nle44ewYHwroVXZWoM/IL3EAg8978BN2N267WJrne3G45hi2KduvNcUr9F8V?=
 =?us-ascii?Q?VoH3ujnTiMGum8bhE9W8q4Aq2CKnsxZ+6Q7UZ1azcEKUVCI9gzOJhxTRlcR+?=
 =?us-ascii?Q?FHTmCw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7f0936-490a-40f9-b6a4-08db2dfc8ba6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:18:10.4211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2vux0ahvgkT+2jHSTlwWE7GAegcqo+R/j+v4GqdOHafnO0TFXAV8tlNimcEAPPMUc8qKh4t/ror3DMgGYNH2krof/jm63JT6hs36NRnrALk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4067
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:24:38PM +0100, Piotr Raczynski wrote:
> Currently interrupt allocations, depending on a feature are distributed
> in batches. Also, after allocation there is a series of operations that
> distributes per irq settings through that batch of interrupts.
> 
> Although driver does not yet support dynamic interrupt allocation, keep
> allocated interrupts in a pool and add allocation abstraction logic to
> make code more flexible. Keep per interrupt information in the
> ice_q_vector structure, which yields ice_vsi::base_vector redundant.
> Also, as a result there are a few functions that can be removed.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

I've made a few minor observations inline.
I don't think there is a need to respin for any of them.

> ---
>  drivers/net/ethernet/intel/ice/ice.h         |  11 +-
>  drivers/net/ethernet/intel/ice/ice_arfs.c    |   5 +-
>  drivers/net/ethernet/intel/ice/ice_base.c    |  36 ++-
>  drivers/net/ethernet/intel/ice/ice_ethtool.c |   2 +-
>  drivers/net/ethernet/intel/ice/ice_idc.c     |  45 ++--
>  drivers/net/ethernet/intel/ice/ice_irq.c     |  46 +++-
>  drivers/net/ethernet/intel/ice/ice_irq.h     |   3 +
>  drivers/net/ethernet/intel/ice/ice_lib.c     | 225 ++-----------------

Nice code removal from ice_lib.c :)

>  drivers/net/ethernet/intel/ice/ice_lib.h     |   4 +-
>  drivers/net/ethernet/intel/ice/ice_main.c    |  44 ++--
>  drivers/net/ethernet/intel/ice/ice_ptp.c     |   2 +-
>  drivers/net/ethernet/intel/ice/ice_sriov.c   |   2 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c     |   5 +-
>  13 files changed, 154 insertions(+), 276 deletions(-)

...

> diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
> index 1911d644dfa8..e5db23eaa3f4 100644
> --- a/drivers/net/ethernet/intel/ice/ice_base.c
> +++ b/drivers/net/ethernet/intel/ice/ice_base.c
> @@ -118,9 +118,31 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
>  	q_vector->rx.itr_mode = ITR_DYNAMIC;
>  	q_vector->tx.type = ICE_TX_CONTAINER;
>  	q_vector->rx.type = ICE_RX_CONTAINER;
> +	q_vector->irq.index = -ENOENT;
>  
> -	if (vsi->type == ICE_VSI_VF)
> +	if (vsi->type == ICE_VSI_VF) {
> +		q_vector->reg_idx = ice_calc_vf_reg_idx(vsi->vf, q_vector);
>  		goto out;
> +	} else if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
> +		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
> +
> +		if (ctrl_vsi) {
> +			if (unlikely(!ctrl_vsi->q_vectors))
> +				return -ENOENT;
> +			q_vector->irq = ctrl_vsi->q_vectors[0]->irq;
> +			goto skip_alloc;

nit: I think goto for error paths is very much the norm.
     But, FWIIW, I would have avoided using goto here.

> +		}
> +	}
> +
> +	q_vector->irq = ice_alloc_irq(pf);
> +	if (q_vector->irq.index < 0) {
> +		kfree(q_vector);
> +		return -ENOMEM;
> +	}
> +
> +skip_alloc:
> +	q_vector->reg_idx = q_vector->irq.index;
> +
>  	/* only set affinity_mask if the CPU is online */
>  	if (cpu_online(v_idx))
>  		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
> @@ -168,6 +190,18 @@ static void ice_free_q_vector(struct ice_vsi *vsi, int v_idx)
>  	if (vsi->netdev)
>  		netif_napi_del(&q_vector->napi);
>  
> +	/* release MSIX interrupt if q_vector had interrupt allocated */
> +	if (q_vector->irq.index < 0)
> +		goto free_q_vector;
> +
> +	/* only free last VF ctrl vsi interrupt */
> +	if (vsi->type == ICE_VSI_CTRL && vsi->vf &&
> +	    ice_get_vf_ctrl_vsi(pf, vsi))
> +		goto free_q_vector;

Ditto (x2).

> +
> +	ice_free_irq(pf, q_vector->irq);
> +
> +free_q_vector:
>  	devm_kfree(dev, q_vector);
>  	vsi->q_vectors[v_idx] = NULL;
>  }

...

> diff --git a/drivers/net/ethernet/intel/ice/ice_irq.c b/drivers/net/ethernet/intel/ice/ice_irq.c
> index f61be5d76373..ca1a1de26766 100644
> --- a/drivers/net/ethernet/intel/ice/ice_irq.c
> +++ b/drivers/net/ethernet/intel/ice/ice_irq.c
> @@ -194,9 +194,53 @@ int ice_init_interrupt_scheme(struct ice_pf *pf)
>  	}
>  
>  	/* populate SW interrupts pool with number of OS granted IRQs. */
> -	pf->num_avail_sw_msix = (u16)vectors;
>  	pf->irq_tracker->num_entries = (u16)vectors;
>  	pf->irq_tracker->end = pf->irq_tracker->num_entries;
>  
>  	return 0;
>  }
> +
> +/**
> + * ice_alloc_irq - Allocate new interrupt vector
> + * @pf: board private structure
> + *
> + * Allocate new interrupt vector for a given owner id.
> + * return struct msi_map with interrupt details and track
> + * allocated interrupt appropriately.
> + *
> + * This function mimics individual interrupt allocation,
> + * even interrupts are actually already allocated with
> + * pci_alloc_irq_vectors. Individual allocation helps
> + * to track interrupts and simplifies interrupt related
> + * handling.
> + *
> + * On failure, return map with negative .index. The caller
> + * is expected to check returned map index.
> + *
> + */
> +struct msi_map ice_alloc_irq(struct ice_pf *pf)
> +{
> +	struct msi_map map = { .index = -ENOENT };
> +	int entry;
> +
> +	entry = ice_get_res(pf, pf->irq_tracker);
> +	if (entry < 0)

nit: map.index could be initialised here.

> +		return map;
> +
> +	map.index = entry;
> +	map.virq = pci_irq_vector(pf->pdev, map.index);
> +
> +	return map;
> +}
