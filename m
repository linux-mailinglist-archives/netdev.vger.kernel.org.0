Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7663827FA57
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgJAHed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgJAHec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:34:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF966C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:34:32 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNt6j-00ERul-Sv; Thu, 01 Oct 2020 09:34:30 +0200
Message-ID: <187cb655088747c42f1bf4b147b272eab8f968c0.camel@sipsolutions.net>
Subject: Re: [RFC net-next 2/9] genetlink: reorg struct genl_family
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, jiri@resnulli.us, mkubecek@suse.cz,
        dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 09:34:20 +0200
In-Reply-To: <20201001000518.685243-3-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
         <20201001000518.685243-3-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 17:05 -0700, Jakub Kicinski wrote:
> There are holes and oversized members in struct genl_family.
> 
> Before: /* size: 104, cachelines: 2, members: 16 */
> After:  /* size:  88, cachelines: 2, members: 16 */
> 
> The command field in struct genlmsghdr is a u8, so no point
> in the operation count being 32 bit. Also operation 0 is
> usually undefined, so we only need 255 entries.
> 
> netnsok and parallel_ops are only ever initialized to true.

The fundamentally are bools, so that makes sense :)

> We can grow the fields as needed, compiler should warn us
> if someone tries to assign larger constants.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/genetlink.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/genetlink.h b/include/net/genetlink.h
> index a3484fd736d6..0033c76ff094 100644
> --- a/include/net/genetlink.h
> +++ b/include/net/genetlink.h
> @@ -48,8 +48,11 @@ struct genl_family {
>  	char			name[GENL_NAMSIZ];
>  	unsigned int		version;
>  	unsigned int		maxattr;
> -	bool			netnsok;
> -	bool			parallel_ops;
> +	unsigned int		mcgrp_offset;	/* private */

In practice, we can probably also shrink that to u16, since it just
gives you the offset of the multicast groups this family has in the
whole table - and we'll hopefully never run more than 2**16 multicast
groups across all genetlink families :)

But it also doesn't matter much.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

