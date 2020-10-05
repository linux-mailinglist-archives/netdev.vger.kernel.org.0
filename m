Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A22283F46
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgJETFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgJETFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:05:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B97CC0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 12:05:34 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPVnd-00HNj3-LS; Mon, 05 Oct 2020 21:05:29 +0200
Message-ID: <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz, dsahern@gmail.com,
        pablo@netfilter.org
Date:   Mon, 05 Oct 2020 21:05:23 +0200
In-Reply-To: <20201005155753.2333882-6-kuba@kernel.org>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-6-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 08:57 -0700, Jakub Kicinski wrote:

> We don't have good validation policy for existing unsigned int attrs
> which serve as flags (for new ones we could use NLA_BITFIELD32).
> With increased use of policy dumping having the validation be
> expressed as part of the policy is important. Add validation
> policy in form of a mask of supported/valid bits.

Nice, I'll surely use this as well somewhere :)

>  #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
> +#define NLA_ENSURE_UINT_TYPE(tp)			\
> +	(__NLA_ENSURE(tp == NLA_U8 || tp == NLA_U16 ||	\
> +		      tp == NLA_U32 || tp == NLA_U64) + tp)
>  #define NLA_ENSURE_UINT_OR_BINARY_TYPE(tp)		\

nit: maybe express this (_OR_BINARY_TYPE) in terms of UINT_TYPE() ||
tp==NLA_BINARY? Doesn't matter much though.

> +static int nla_validate_mask(const struct nla_policy *pt,
> +			     const struct nlattr *nla,
> +			     struct netlink_ext_ack *extack)
> +{
> +	u64 value;
> +
> +	switch (pt->type) {
> +	case NLA_U8:
> +		value = nla_get_u8(nla);
> +		break;
> +	case NLA_U16:
> +		value = nla_get_u16(nla);
> +		break;
> +	case NLA_U32:
> +		value = nla_get_u32(nla);
> +		break;
> +	case NLA_U64:
> +		value = nla_get_u64(nla);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (value & ~(u64)pt->mask) {
> +		NL_SET_ERR_MSG_ATTR(extack, nla, "reserved bit set");
> +		return -EINVAL;

You had an export of the valid bits there in ethtool, using the cookie.
Just pointing out you lost it now. I'm not sure I like using the cookie,
that seems a bit strange, but we could easily define a different attr?

OTOH, one can always query the policy export too (which hopefully got
wired up) so it wouldn't really matter much.


Either way is fine with me on both of these points.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

johannes

