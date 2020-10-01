Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D37B27FA98
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbgJAHsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgJAHse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:48:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F172C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:48:34 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNtKK-00ESJk-Me; Thu, 01 Oct 2020 09:48:32 +0200
Message-ID: <f035af6008cdca32c84f13bc3f38614fa0b535ac.camel@sipsolutions.net>
Subject: Re: [RFC net-next 5/9] genetlink: add a structure for dump state
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, jiri@resnulli.us, mkubecek@suse.cz,
        dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 09:48:31 +0200
In-Reply-To: <20201001000518.685243-6-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
         <20201001000518.685243-6-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 17:05 -0700, Jakub Kicinski wrote:
> Whenever netlink dump uses more than 2 cb->args[] entries
> code gets hard to read. We're about to add more state to
> ctrl_dumppolicy() so create a structure.
> 
> Since the structure is typed and clearly named we can remove
> the local fam_id variable and use ctx->fam_id directly.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/netlink/genetlink.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 38d8f353dba1..a8001044d8cd 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1102,13 +1102,18 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
>  	return 0;
>  }
>  
> +struct ctrl_dump_policy_ctx {
> +	unsigned long state;

Maybe if we do this, also make a "struct netlink_policy_dump_state" in
include/net/netlink.h for the policy dump to use as a state? Right now
it just uses an "unsigned long *state" there.

I feel that would more clearly show what this "state" actually is.

Alternatively, perhaps just rename it to "policy_dump_state"? Yeah,
that's longer, but at least would be very obvious?

> +	unsigned int fam_id;

You could make this a u16 I guess, but it doesn't really matter.

>  static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
>  {
> +	struct ctrl_dump_policy_ctx *ctx = (void *)cb->args;


I'd also prefer if you stuck a

	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->args));

here. It's not likely we'll need so much more state here, but would
still be good to check IMHO.

But in general looks good :)

johannes

