Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DAD283F23
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgJES45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 14:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgJES45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 14:56:57 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B19C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 11:56:57 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPVfB-00HNSB-VG; Mon, 05 Oct 2020 20:56:46 +0200
Message-ID: <631a2328a95d0dd06d901cdb411c3eb06f90bda7.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: wire up get policies to ops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz
Date:   Mon, 05 Oct 2020 20:56:29 +0200
In-Reply-To: <20201005155753.2333882-2-kuba@kernel.org>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 08:57 -0700, Jakub Kicinski wrote:
> 
> @@ -783,6 +799,9 @@ static const struct genl_ops ethtool_genl_ops[] = {
>  		.start	= ethnl_default_start,
>  		.dumpit	= ethnl_default_dumpit,
>  		.done	= ethnl_default_done,
> +		.policy = ethnl_rings_get_policy,
> +		.maxattr = ARRAY_SIZE(ethnl_rings_get_policy) - 1,
> +
>  	},

If you find some other reason to respin, perhaps remove that blank line
:)

Unrelated to that, it bothers me a bit that you put here the maxattr as
the ARRAY_SIZE(), which is of course fine, but then still have

> @@ -127,7 +127,7 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
>  	.max_attr		= ETHTOOL_A_PRIVFLAGS_MAX,

max_attr here, using the original define - yes, mostly the policies use
the define to size them, but they didn't really *need* to, and one might
make an argument that on the policy arrays the size might as well be
removed (and it be sized automatically based on the contents) since all
the unspecified attrs are rejected anyway.

But with the difference it seems to me that it'd be possible to get this
mixed up?

I do see that you still need this to size the attrs for parsing them
even after patch 2 where this:

>  	.req_info_size		= sizeof(struct privflags_req_info),
>  	.reply_data_size	= sizeof(struct privflags_reply_data),
> -	.request_policy		= privflags_get_policy,
> +	.request_policy		= ethnl_privflags_get_policy,

gets removed completely.


Perhaps we can look up the genl_ops pointer, or add the ops pointer to
struct genl_info (could point to the temporary full struct that gets
populated, size of genl_info itself doesn't matter much since it's on
the stack and temporary), and then use ops->maxattr instead of
request_ops->max_attr in ethnl_default_parse()?

johannes

