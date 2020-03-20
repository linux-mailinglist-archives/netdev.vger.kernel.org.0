Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9AEB18DA10
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 22:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgCTVWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 17:22:54 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54122 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTVWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 17:22:53 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jFP6N-00Bvcd-65; Fri, 20 Mar 2020 22:22:47 +0100
Message-ID: <b4b1d7b252820591ebb00e3851d44dc6c3f2d1b9.camel@sipsolutions.net>
Subject: Re: [PATCH net] netlink: check for null extack in cookie helpers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Fri, 20 Mar 2020 22:22:45 +0100
In-Reply-To: <20200320211343.4BD38E0FD3@unicorn.suse.cz>
References: <20200320211343.4BD38E0FD3@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

> Unlike NL_SET_ERR_* macros, nl_set_extack_cookie_u64() and
> nl_set_extack_cookie_u32() helpers do not check extack argument for null
> and neither do their callers, as syzbot recently discovered for
> ethnl_parse_header().

What exactly did it discover?

> Instead of fixing the callers and leaving the trap in place, add check of
> null extack to both helpers to make them consistent with NL_SET_ERR_*
> macros.
> 
> Fixes: 2363d73a2f3e ("ethtool: reject unrecognized request flags")
> Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")

I'm not really convinced, at least not for the second patch.

After all, this is an important part of the functionality, and the whole
thing is pretty useless if no extack/cookie is returned since then you
don't have a handle to the in-progress operation.

That was the intention originally too, until now the cookie also got
used for auxiliary error information...

Now, I don't think we need to *crash* when something went wrong here,
but then I'd argue there should at least be a WARN_ON(). But then that
means syzbot will just trigger the WARN_ON which also makes it unhappy,
so you still would have to check in the caller?

johannes

