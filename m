Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE62D3982
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 08:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfJKGqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 02:46:06 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60858 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfJKGqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 02:46:06 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iIogU-0003Ja-I8; Fri, 11 Oct 2019 08:45:54 +0200
Message-ID: <4aba888eb7ae08b446aa1140df729bca93cb0d33.camel@sipsolutions.net>
Subject: Re: [patch net-next v2 2/4] devlink: propagate extack down to
 health reporter ops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        "dsahern@gmail.com" <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, moshe@mellanox.com,
        eranbe@mellanox.com, mlxsw@mellanox.com
Date:   Fri, 11 Oct 2019 08:45:52 +0200
In-Reply-To: <20191010190429.4511a8de@cakuba.netronome.com> (sfid-20191011_040448_580232_4CAE641F)
References: <20191010131851.21438-1-jiri@resnulli.us>
         <20191010131851.21438-3-jiri@resnulli.us>
         <20191010190429.4511a8de@cakuba.netronome.com>
         (sfid-20191011_040448_580232_4CAE641F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-10 at 19:04 -0700, Jakub Kicinski wrote:

> >  	if (reporter->auto_recover)
> > -		return devlink_health_reporter_recover(reporter, priv_ctx);
> > +		return devlink_health_reporter_recover(reporter,
> > +						       priv_ctx, NULL);
> >  
> >  	return 0;
> >  }
> 
> Thinking about this again - would it be entirely insane to allocate the
> extack on the stack here? And if anything gets set output into the logs?

I think that's fine.

> For context the situation here is that the health API can be poked from
> user space, but also the recovery actions are triggered automatically
> when failure is detected, if so configured (usually we expect them to
> be).

Right. We have similar situations in the wireless stack, and we usually
just get very noisy & WARN. But then it's a level lower, so you don't
have any extack around there :)

> When we were adding the extack helper for the drivers to use Johannes
> was concerned about printing to logs because that gave us a
> disincentive to convert all locations, and people could get surprised
> by the logs disappearing when more places are converted to extack [1].

Yes, but that argument doesn't apply here. The argument was around code
like

> +#define NL_SET_ERR_MSG(extack, msg) do {		\
> +	struct netlink_ext_ack *_extack = (extack);	\
> +	static const char _msg[] = (msg);		\
> +							\
> +	if (_extack)					\
> +		_extack->_msg = _msg;			\
> +	else						\
> +		pr_info("%s\n", _msg);			\
>  } while (0)

(which I quoted in the message you linked).

I still stand by my comment there, I think it'd be a bad idea to do
this, because it'd mean that some random code using NL_SET_ERR_MSG()
might print something to the log if it's called in one way, and perhaps
the fact that it's getting NULL there is due to some higher level call
chain a few steps up "losing" the extack (or not having one), but then
if that's fixed suddenly all the messages disappear.

In the case you're proposing it's entirely different - you're proposing
that a non-netlink caller still supplies an extack that can be filled,
and then prints it out by itself. There's no reason to believe that
would be changed to suddenly have a real netlink extack that *doesn't*
get printed - that wouldn't make sense since you're doing this precisely
because you're *not* inside a netlink call.

Now, if you were saying "let's have a netlink handler that prints the
extack because a few levels up in the callstack we aren't passing the
parameter down yet" I'd still oppose it on similar grounds - that's
something we'd want to fix later to actually report to userspace - but
here there's no chance of that.

So to me this looks fine.

I don't really share the concern about extack being netlink specific and
then using it here - it ultimately doesn't matter whether this thing is
called "netlink_extack" or "extended_error_reporting", IMHO.

I guess we could wrap this so we have

struct devlink_error_report {
  /* pretty much identical content to extack? */
};

and then in this path just print it, while in the actual netlink paths
convert it to extack a level up. That might be the right thing from an
abstraction POV (if we were designing this in Enterprise Architect ;-) )
but pragmatically I'd say it doesn't really matter what the struct is
called, and extack already has helper macros etc.

johannes

