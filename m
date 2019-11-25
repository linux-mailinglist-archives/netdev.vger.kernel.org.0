Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBD9108B2E
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 10:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfKYJsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 04:48:18 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:42884 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfKYJsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 04:48:18 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iZAyV-0082Cq-8X; Mon, 25 Nov 2019 10:48:07 +0100
Message-ID: <613b2aa1f9612898df7bb2e54bbb49b4115d29ae.camel@sipsolutions.net>
Subject: Re: [PATCH V2 net-next 1/6] netlink: Convert extack msg to a
 formattable buffer
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, David Ahern <dsahern@gmail.com>
Date:   Mon, 25 Nov 2019 10:48:05 +0100
In-Reply-To: <20191123165655.5a9b8877@cakuba.netronome.com> (sfid-20191124_015708_074656_C114DF73)
References: <20191122224126.24847-1-saeedm@mellanox.com>
         <20191122224126.24847-2-saeedm@mellanox.com>
         <20191123165655.5a9b8877@cakuba.netronome.com>
         (sfid-20191124_015708_074656_C114DF73)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Sat, 2019-11-23 at 16:56 -0800, Jakub Kicinski wrote:
> 
> > -/* Always use this macro, this allows later putting the
> > - * message into a separate section or such for things
> > - * like translation or listing all possible messages.

Regarding your other email also - this here was one stated purpose -
what I had also (maybe even more) in mind back then was that we'd be
able to elide the strings entirely for really small embedded builds. If
it's not used interactively, there isn't that much value in the strings
after all.

> > - * Currently string formatting is not supported (due
> > - * to the lack of an output buffer.)
> > - */
> > -#define NL_SET_ERR_MSG(extack, msg) do {		\
> > -	static const char __msg[] = msg;		\
> > +#define NL_MSG_FMT(extack, fmt, ...) \
> > +	WARN_ON(snprintf(extack->_msg, NL_EXTACK_MAX_MSG_SZ, fmt, ## __VA_ARGS__) \
> > +		>= NL_EXTACK_MAX_MSG_SZ)
> 
> I'd personally appreciate a word of analysis and reassurance in the
> commit message that this snprintf + WARN_ON inlined in every location
> where extack is used won't bloat the kernel :S

That does seem quite excessive, indeed.

I think _if_ we want this at all then I'd say that we should move this
out-of-line, to have a helper function that will kasprintf() if
necessary, and use a bit somewhere to indicate "has been allocated" so
it can be freed later?

However, this will need some kind of "release extack" API for those
places that declare their own struct on the stack, and would need to be
reentrant (in the sense that old error messages may be overwritten, and
must be freed at that point)...

Maybe an alternative would be to have a "can sprintf" flag, and then
provide a buffer in another pointer? The caller can then decide whether
this should be permitted, e.g. netlink_rcv_skb() could provide it, but
other places maybe don't need to?


Here in the patchset though, I basically found three cases using this
capability:

+	NL_SET_ERR_MSG_MOD(extack, MLXFW_ERR_PRFX "%s",
+			   mlxfw_fsm_state_err_str[fsm_state_err]);

This one seems somewhat unnecessary - it just takes a fixed string and
adds a prefix, that may be easier this way but it wouldn't be *that*
hard to "explode" that into a bunch of NL_SET_ERR_MSG_MOD() statements I
guess.

+		NL_SET_ERR_MSG_MOD(extack, "FSM state query failed, err (%d)",
+				   err);

This (and other similar instances) is pretty useless, the error number
is almost certainly returned to userspace anyway?

+		NL_SET_ERR_MSG_MOD(extack,
+				   "FSM component query failed, comp_name(%s) err (%d)",
+				   comp_name, err);

This (and similar) one seems like the only one that's reasonable. Note
that "comp_name" is actually just a number though.

johannes

