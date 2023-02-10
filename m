Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A065692492
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbjBJRh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbjBJRh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:37:58 -0500
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Feb 2023 09:37:56 PST
Received: from smtp-42ab.mail.infomaniak.ch (smtp-42ab.mail.infomaniak.ch [84.16.66.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D9C34F55
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 09:37:56 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PD1Cl0fmxzMrH7D;
        Fri, 10 Feb 2023 18:37:55 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PD1Ck2scyzlgQ;
        Fri, 10 Feb 2023 18:37:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1676050674;
        bh=ca5OzA0HqP2+e+kn7erjO7uqKO+YjgTZQMieOxfqNL0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=1FzvKLlNUk2sO+lY2Wh7SQAcyAn3cv6TOqWm0pdocbnVNA+z4yN8+5gUHYCHAGn4J
         pJaVyefmBOUCqxvocRaUS4/mWzSXtan0xMeXpqldCR3Q3Ib/oJYWKDVjCz648BvYXV
         2R4NOz+1HI5lqbX4XVw/7VJcMEor5fQThSZqJKY8=
Message-ID: <dcb11989-fa8d-3966-77da-2ff5fab2ef32@digikod.net>
Date:   Fri, 10 Feb 2023 18:37:53 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 05/12] landlock: Move and rename umask_layers() and
 init_layer_masks()
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-6-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230116085818.165539-6-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/01/2023 09:58, Konstantin Meskhidze wrote:
> This patch renames and moves unmask_layers() and init_layer_masks()
> helpers to ruleset.c to share them with Landlock network implementation
> in following commits.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v8:
> * Refactors commit message.
> * Adds "landlock_" prefix for moved helpers.
> 
> Changes since v7:
> * Refactors commit message.
> 
> Changes since v6:
> * Moves get_handled_accesses() helper from ruleset.c back to fs.c,
>    cause it's not used in coming network commits.
> 
> Changes since v5:
> * Splits commit.
> * Moves init_layer_masks() and get_handled_accesses() helpers
> to ruleset.c and makes then non-static.
> * Formats code with clang-format-14.
> 
> ---

[...]

> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 3e1cffda128e..22590cac3d56 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -572,3 +572,101 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
>   	}
>   	return NULL;
>   }
> +
> +/*
> + * @layer_masks is read and may be updated according to the access request and
> + * the matching rule.
> + *
> + * Returns true if the request is allowed (i.e. relevant layer masks for the
> + * request are empty).
> + */
> +bool landlock_unmask_layers(
> +	const struct landlock_rule *const rule,
> +	const access_mask_t access_request,
> +	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> +{
> +	size_t layer_level;
> +
> +	if (!access_request || !layer_masks)
> +		return true;
> +	if (!rule)
> +		return false;
> +
> +	/*
> +	 * An access is granted if, for each policy layer, at least one rule
> +	 * encountered on the pathwalk grants the requested access,
> +	 * regardless of its position in the layer stack.  We must then check
> +	 * the remaining layers for each inode, from the first added layer to
> +	 * the last one.  When there is multiple requested accesses, for each
> +	 * policy layer, the full set of requested accesses may not be granted
> +	 * by only one rule, but by the union (binary OR) of multiple rules.
> +	 * E.g. /a/b <execute> + /a <read> => /a/b <execute + read>
> +	 */
> +	for (layer_level = 0; layer_level < rule->num_layers; layer_level++) {
> +		const struct landlock_layer *const layer =
> +			&rule->layers[layer_level];
> +		const layer_mask_t layer_bit = BIT_ULL(layer->level - 1);
> +		const unsigned long access_req = access_request;
> +		unsigned long access_bit;
> +		bool is_empty;
> +
> +		/*
> +		 * Records in @layer_masks which layer grants access to each
> +		 * requested access.
> +		 */
> +		is_empty = true;
> +		for_each_set_bit(access_bit, &access_req,
> +				 ARRAY_SIZE(*layer_masks)) {
> +			if (layer->access & BIT_ULL(access_bit))
> +				(*layer_masks)[access_bit] &= ~layer_bit;
> +			is_empty = is_empty && !(*layer_masks)[access_bit];
> +		}
> +		if (is_empty)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +/*

Please keep the original "/**"


> + * init_layer_masks - Initialize layer masks from an access request
> + *
> + * Populates @layer_masks such that for each access right in @access_request,
> + * the bits for all the layers are set where this access right is handled.
> + *
> + * @domain: The domain that defines the current restrictions.
> + * @access_request: The requested access rights to check.
> + * @layer_masks: The layer masks to populate.
> + *
> + * Returns: An access mask where each access right bit is set which is handled
> + * in any of the active layers in @domain.
> + */
