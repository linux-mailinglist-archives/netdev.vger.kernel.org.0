Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F109D6C9475
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjCZNUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCZNUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:20:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2111.outbound.protection.outlook.com [40.107.237.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD671FFA
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 06:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OtULrG0pEYyjqAWeytIlpvEcUf3MZzW46/4rPdy5pvQpf8/iVQ7jotVHkecwM3jhhweQVUpMCrFPH+Z61QP9DguaIeSfcaBMfW2CnLXhI7ZXjUqkXuMzSr9Tvlpoj6vqJkbuDPHx7jKJHDA/gf/N9vkZXPKC4BG99/ltWKxoOopUiU59pbv1dxOI+4DpWSCEHZOksuSpwLtUdH3kK9Hl0R+3zS62WXZ/wcfQ03WW09ecfg1z6wwMXaks70XHorvyN+EB8YxYxpDLNTGgNYDXANEFyA1/vetgrg7/fzwxGIGvywWKAM45ydWbBF7oDFnb0eHuEep+JaWQaDAVAtMABg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5eFaKfaGWH07YLy4hAXL6XnGv9Xl4yVpvgyKrrCdTCY=;
 b=MKkMaoka914hscr7Xf7i2V4Ss3BNDBGS0QFxbmKhX1qwMZATWCvA2cObZYgLIWvIYX1+SJRV6ltk9RJkrYZcRiOKIPT6hSwp+dh1isHmNBEpnERH777x1TSJot3Re62Qj64m9rt1JYjG4bc5GhXBURvMCmLpYC+2pukwGS//MKURwcInQSWrfDC3Tlcq/Kd39MqfRsqMIVZbPmSf7M/5X3Z5enF+aWGa12qXWtrzyaXM2q/sHVqm87VSLlLEJaScVQgumrphiJc1umFMmVWqKbDWJMSKloolMN3+miYnfNAewjYdWdFebl7gWgVCNoRgnDKVfLvX0M3333xZbf7KVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5eFaKfaGWH07YLy4hAXL6XnGv9Xl4yVpvgyKrrCdTCY=;
 b=vkm7FjIY9JtIpZCtJrU9RmxRGXtFmqcMIQ8OmaFaL3AxIOtEjNp5nx5pdeO1N5A0urfK1GHrAQBhXPgHMzU/GdKhCy9fG4jlVNwKitLQg6OtSfmQ0oHuodFcsAva6agL/+LGJJsleNIEqnnddqcaNaXN1cE5xAS2t9nLhPD0G/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4067.namprd13.prod.outlook.com (2603:10b6:5:2a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 13:20:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 13:20:04 +0000
Date:   Sun, 26 Mar 2023 15:19:58 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        michal.swiatkowski@intel.com, shiraz.saleem@intel.com,
        jacob.e.keller@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, aleksander.lobakin@intel.com,
        lukasz.czapnik@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: Re: [PATCH net-next v3 7/8] ice: track interrupt vectors with xarray
Message-ID: <ZCBGfoqzid7PLcZE@corigine.com>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
 <20230323122440.3419214-8-piotr.raczynski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323122440.3419214-8-piotr.raczynski@intel.com>
X-ClientProxiedBy: AM4PR0302CA0020.eurprd03.prod.outlook.com
 (2603:10a6:205:2::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fbfaa76-b9e5-4d24-4995-08db2dfccfc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1B6VjOo/pgm6XlHSfzVGoTP8j5DWuVrVRDyr0b+MNkGxoXRhAj5qdoHAWdaTPLBzkmys4qwvkjWzuvzrJnTmc7ZpcjaqWJtEJZUBVIe3bPQImrGMHFhAA01PT0W80W1Jjmjw6WmTF/Dop/oeOl5Rufs91oSB7Q6LSJW9P8fsudlQQ53zy4zBHuz3QbS3/JDeiBGqHy6vlPv814pO956QrMraiCzHKpGHFT2EOBUJ2A3luqQCEew+NQyKRIHKP2czeFZw9irg3MT9Icu7WcSo+QUMHii9T560HMmtZ/STsSWYnbcNIXCWHO2Lkdmh9QyhMzGmNL0ZjptS0uvW/gn1NaD/oaruJoQw9zi7Eu4qAM4m/2rVHk4PsOsvEadx7N9+/80rVtts+r8HBzoqZRuNVKfLhpofBfDxbY1ZiF/qk0pQoMdVvPeXVk/UuuSBD8mg/YWEHVDqr8AjQCKCyqh2+Boic5E0ZrboPioA8YRnzVx16pZXNyz90xnHWCxKwPrUppRMbz7dsRvV8yLj8LfKzaDB3SEB1V1uKVtD5dK/+MZUHMjVBOggOtAS7B7b8DkA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(136003)(346002)(39830400003)(451199021)(2906002)(86362001)(83380400001)(186003)(2616005)(38100700002)(66556008)(8936002)(5660300002)(4326008)(6916009)(8676002)(41300700001)(66946007)(7416002)(36756003)(66476007)(44832011)(6506007)(6512007)(6486002)(316002)(6666004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oQouyz/2xnI48GlNo/NFb273piRe80zWE5jfMmpQ5FV/11POUWcYVvczQeul?=
 =?us-ascii?Q?yuvs/9iThy95n4z6gGNS/MWLCTkKedZ7uNS0ztJbU7nHI6k6jHdPFFu5O9gI?=
 =?us-ascii?Q?gu+GIDOXPQDDXRwDIvjaBjKtEHoZy4hvI0saZCNt4vvb7arBRz9p7renQ+Pg?=
 =?us-ascii?Q?7P4x3Xap2+toHCFPyTUPnTBJ5U1oVkHyoqGGZId8nh9OvYKrISJVfyrXP94H?=
 =?us-ascii?Q?W9ll04TKwhYG8f/81r8aZm32rzBKFbvtA5ubJFIMh+dCLQoiFkkTQkrXgwbL?=
 =?us-ascii?Q?t02n5xPxctaJImev1rcrJRFV86f4hjVzpBMz11gdGfE2hY5DwF0znZHcuOVO?=
 =?us-ascii?Q?OF3YClRs/Ayj7gNWxnPF+3Y/z5X7NN9N7lk4QoUWnv8pOaghaCfZREDiCGt1?=
 =?us-ascii?Q?fkHh8XizHt5FM4S0rzgnR+JioANJerJXIwDb/7oWPx/vHsS2uh1vj0ZdEdEb?=
 =?us-ascii?Q?257Le6xrwehXYxeNYKfxud3K5Vz10X09O+feh8Zy2b4NWBDh9Fxo86X61dPB?=
 =?us-ascii?Q?3Wg5D30JZUWaxMyauWmBc4NRI16m9rFPhQdhyu7FfeUz6C996lPlA67I3VWG?=
 =?us-ascii?Q?MkC9up8uMxg1cBTcsVF32fEI8m/LfE3GJ6c5GGsHI4LHugOerCnH+hmMUrrq?=
 =?us-ascii?Q?cYqaUYpnz0SPaFJ4Z7H8tHojAkYXTVD+PQmMdP10fmx0DBALofowufHgMyU+?=
 =?us-ascii?Q?gK9J0CEulf6rnh+r7bIGzR4d/UC8/uzwQQVSTzQTapm85x2impf4Z4dEMT1M?=
 =?us-ascii?Q?IxFC4zdj4olvXmweiRzawlHKTzgvUUQSy5Ks+gBbPTWHjSmWU6AP5xDbLQOg?=
 =?us-ascii?Q?5n80c7JfJ8JYFVpkWxns1rLsRn9y+kVdiqbRtbxPW6D8lAjRutkWutaf4BUd?=
 =?us-ascii?Q?dZuN781olFt8QN6eRFJIFXueKwTwid6B+ehNPtRTC3E7su6uxIIRDry9ff2+?=
 =?us-ascii?Q?rXUXyML5t8MVvdYCJSsSRbL7a796PExgC6VESsCiOIK7h144DrN/b4rn+YXg?=
 =?us-ascii?Q?am42+sa+bMmDSqYugRWRcpkDIuy4TY6oVmcxjDar/5oH2HJmEoOMGk7+/cT8?=
 =?us-ascii?Q?OzxQ5/mUZEdVM+JXnEUv52jZ0YggtdrTLkaBkA6Uycwjn+s5KEEMiOcES/5O?=
 =?us-ascii?Q?gjzyyBmNcpPKigHkaUyJVFaHos4hQ2O0DL2ar8uSUjKSklhUlt/0rBS5CbHG?=
 =?us-ascii?Q?kmNjdiQ52j78srrnwdHlqIldeXH6dlYY6KP/mfDCDLjdkA+OvG3RNjSPE08g?=
 =?us-ascii?Q?zZ93gAx70O+L3fvV4Ai+omWTan+bTBYNbWuO9e+eqm9Ny01hiGIcevM1FYSI?=
 =?us-ascii?Q?ods/MIYpncvbwy2vWuhHMT07SFrBrueWSy0hfp2UyZqoK0mMmMpQiwqSIDDu?=
 =?us-ascii?Q?g8TUTaEq1fwHSzj0hXmhmoOdxiFPlU/bikQwbeoH7cG5u1M9u4zd9d2kP3P6?=
 =?us-ascii?Q?0zvx76YEAR4A2q9pzIFbj6+TTOtrPlWWX+SSoDsv2JeujUfrK9DtBFzKnApu?=
 =?us-ascii?Q?ashGpeE2ZvojIaih7gCCFJopxR2MiyacvEeyuHiMsAvuknuSmPfng8mjio8N?=
 =?us-ascii?Q?KSacnGC4zZdSVDrZ/pYzFO4Is6yaxjPbamJTT1w4dZyDT5UB200bahBox805?=
 =?us-ascii?Q?Dk5k8fGojAg20QSTuT2pegO5yaIqORuNpMw6pY0FdaRocvi5PP7ixpuH6LTq?=
 =?us-ascii?Q?FhJ+Pw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbfaa76-b9e5-4d24-4995-08db2dfccfc0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:20:04.4891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O057r5hSqfYuPhB7Rfzhm5FI52z0RuwqzB7tsnLa2fynIgt2NS7C4qn/FEMT+pJH0MHRTmzMqlztQ7ELbBjh0B4gymRCc4YrHlZvVcjcw8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4067
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:24:39PM +0100, Piotr Raczynski wrote:
> Replace custom interrupt tracker with generic xarray data structure.
> Remove all code responsible for searching for a new entry with xa_alloc,
> which always tries to allocate at the lowes possible index. As a result
> driver is always using a contiguous region of the MSIX vector table.
> 
> New tracker keeps ice_irq_entry entries in xarray as opaque for the rest
> of the driver hiding the entry details from the caller.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

I've added a few comments inline for your consideration
if you need to respin for some other reason.

...

> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index 89d80a2b5feb..b7398abda26a 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -104,7 +104,6 @@
>  #define ICE_Q_WAIT_RETRY_LIMIT	10
>  #define ICE_Q_WAIT_MAX_RETRY	(5 * ICE_Q_WAIT_RETRY_LIMIT)
>  #define ICE_MAX_LG_RSS_QS	256
> -#define ICE_RES_VALID_BIT	0x8000

nit: BIT() could be used here.

>  #define ICE_INVAL_Q_INDEX	0xffff
>  
>  #define ICE_MAX_RXQS_PER_TC		256	/* Used when setting VSI context per TC Rx queues */

...

> diff --git a/drivers/net/ethernet/intel/ice/ice_irq.c b/drivers/net/ethernet/intel/ice/ice_irq.c
> index ca1a1de26766..20d4e9a6aefb 100644
> --- a/drivers/net/ethernet/intel/ice/ice_irq.c
> +++ b/drivers/net/ethernet/intel/ice/ice_irq.c

...

> +/**
> + * ice_get_irq_res - get an interrupt resource
> + * @pf: board private structure
> + *
> + * Allocate new irq entry in the free slot of the tracker. Since xarray
> + * is used, always allocate new entry at the lowest possible index. Set
> + * proper allocation limit for maximum tracker entries.
> + *
> + * Returns allocated irq entry or NULL on failure.
> + */
> +static struct ice_irq_entry *ice_get_irq_res(struct ice_pf *pf)
> +{
> +	struct xa_limit limit = { .max = pf->irq_tracker.num_entries,
> +				  .min = 0 };
> +	struct ice_irq_entry *entry;
> +	unsigned int index;
> +	int ret;
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		goto exit;

nit: maybe it is simpler to return NULL here.

> +
> +	ret = xa_alloc(&pf->irq_tracker.entries, &index, entry, limit,
> +		       GFP_KERNEL);
> +
> +	if (ret) {
> +		kfree(entry);
> +		entry = NULL;

and here.

> +	} else {
> +		entry->index = index;

Which allows for more idiomatic code by moving this out of the else clause.

> +	}
> +
> +exit:

And removal of this label.

> +	return entry;
> +}
> +
