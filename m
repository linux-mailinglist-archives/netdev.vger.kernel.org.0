Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6D7280905
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733110AbgJAVDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbgJAVDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 17:03:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E576CC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 14:03:04 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kO5jC-00Eowu-Fu; Thu, 01 Oct 2020 23:03:03 +0200
Message-ID: <dcaeaedaa179c558cab0d417277fea9ac29d8b79.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 9/9] genetlink: allow dumping command-specific
 policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 23:03:01 +0200
In-Reply-To: <20201001183016.1259870-10-kuba@kernel.org>
References: <20201001183016.1259870-1-kuba@kernel.org>
         <20201001183016.1259870-10-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 11:30 -0700, Jakub Kicinski wrote:
> 
> +++ b/net/netlink/genetlink.c
> @@ -1119,6 +1119,7 @@ static const struct nla_policy ctrl_policy_policy[] = {
>  	[CTRL_ATTR_FAMILY_ID]	= { .type = NLA_U16 },
>  	[CTRL_ATTR_FAMILY_NAME]	= { .type = NLA_NUL_STRING,
>  				    .len = GENL_NAMSIZ - 1 },
> +	[CTRL_ATTR_OP]		= { .type = NLA_U8 },

I slightly wonder if we shouldn't make this wider. There's no real
*benefit* to using a u8 since, due to padding, the attribute actually
has the same size anyway (up to U32), and we also still need to validate
it actually exists.

However, if we ever run out of command numbers in some family (nl80211
is almost half way :-) ) then I believe we still have some reserved
space in the genl header that we could use for extensions, but if then
we have to also go around and change a bunch of other interfaces like
this, it'll just be so much harder, and ... we'd probably just be
tempted to multiplex onto an "extension command" or something? Or maybe
then we should have a separate genl family at that point?

(Internal interfaces are much easier to change)

Dunno. Just a thought. We probably won't ever get there, it just sort of
rubs me the wrong way that we'd be restricting this in an "unfixable"
API for no real reason :)

> -	if (!rt->policy)
> +	if (tb[CTRL_ATTR_OP]) {
> +		err = genl_get_cmd(nla_get_u8(tb[CTRL_ATTR_OP]), rt, &op);

OK, so maybe if we make that wider we also have to make the argument to
genl_get_cmd() wider so we don't erroneously return op 1 if you ask for
257, but that's in an at least 32-bit register anyway, presumably?

johannes

