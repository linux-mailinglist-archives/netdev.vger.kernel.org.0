Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F07640DFB
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbiLBS4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiLBS4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:56:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F831C7
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:56:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3E55B82222
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F84C433C1;
        Fri,  2 Dec 2022 18:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670007389;
        bh=xfwp7fvTaxFxqJSYeSvJrkW1TjrMx2vD+omSRbLvGiU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d5PKwDgjM31MkZm8h+nPiGCSyogMDS9loWLaBE6WgBIBT/cNI9M/Eqt7KFIqWKj4Q
         P40ecrRmDzlyrPzv3KsXWd6++irJj3Qbfvas9xHrwQl4ph45JjmefJEVR2/Z9xjCTw
         ij11VgoAPKnt5FkwnOhLJnxOfxWy7bZFApA2Er4TX826he2AXt6HKbPl/FtI5FC14V
         K//zAGLSnlPC9qVHyOW9mYSYIgYoH7qHTrMmF2mvDWTNP5ZHNHI9nd78DGvLsc2slc
         hC8n5flm9ObQ+2acXCGg6r0uk8a8YIAgGnl2MpUs0cE7xk8T+Ul3cgC+4UZGU4vEEg
         NlmQfEzerr0rw==
Date:   Fri, 2 Dec 2022 10:56:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Drory <shayd@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: Re: [PATCH net-next V2 4/8] devlink: Expose port function commands
 to control RoCE
Message-ID: <20221202105628.3a16029a@kernel.org>
In-Reply-To: <20221202082622.57765-5-shayd@nvidia.com>
References: <20221202082622.57765-1-shayd@nvidia.com>
        <20221202082622.57765-5-shayd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Dec 2022 10:26:18 +0200 Shay Drory wrote:
> Expose port function commands to enable / disable RoCE, this is used to
> control the port RoCE device capabilities.

> @@ -122,6 +122,9 @@ A user may set the hardware address of the function using
>  'devlink port function set hw_addr' command. For Ethernet port function
>  this means a MAC address.
>  
> +Users may also set the RoCE capability of the function using
> +'devlink port function set roce' command.

nit: use backticks (`) for better highlight?

> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 70191d96af89..830f8ffd69d1 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -658,11 +658,23 @@ enum devlink_resource_unit {
>  	DEVLINK_RESOURCE_UNIT_ENTRY,
>  };
>  
> +enum devlink_port_fn_attr_cap {
> +	DEVLINK_PORT_FN_ATTR_CAP_ROCE,
> +
> +	/* Add new caps above */
> +	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,
> +	DEVLINK_PORT_FN_ATTR_CAPS_MAX = __DEVLINK_PORT_FN_ATTR_CAPS_MAX - 1

Is DEVLINK_PORT_FN_ATTR_CAPS_MAX actually needed?
This is a bit list, not an attribute list, don't copy the format 
of netlink attribute definition without a reason.

> +};
> +
> +#define DEVLINK_PORT_FN_ATTR_CAPS_VALID_MASK \
> +	(_BITUL(__DEVLINK_PORT_FN_ATTR_CAPS_MAX) - 1)

This does not belong in the uAPI. User space has to discover the mask
at runtime via a policy dump, anyway.

> +	[DEVLINK_PORT_FN_ATTR_CAPS] =
> +		NLA_POLICY_BITFIELD32(DEVLINK_PORT_FN_ATTR_CAPS_VALID_MASK),

Why is there _ATTR in the name of the CAPS mask?

>  };
>  
>  static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {
> @@ -692,6 +694,64 @@ devlink_sb_tc_index_get_from_attrs(struct devlink_sb *devlink_sb,
>  	return 0;
>  }
>  
> +#define DEVLINK_PORT_FN_CAP(_name) \
> +	BIT(DEVLINK_PORT_FN_ATTR_CAP_##_name)

No, just work harder to make the name concise :/
Not being able to grep or ctag uses of a value is a huge PITA during
code reviews.

> +#define DEVLINK_PORT_FN_SET_CAP(caps, cap, enable)	\
> +	do {						\
> +		typeof(cap) cap_ = (cap); \
> +		typeof(caps) caps_ = (caps); \
> +		(caps_)->selector |= cap_;	\
> +		if (enable)					\
> +			(caps_)->value |= cap_; \
> +	} while (0)

I think you can code this up as a function instead of a macro.
