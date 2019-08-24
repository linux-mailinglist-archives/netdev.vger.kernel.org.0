Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1ED9B9F8
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 03:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfHXBGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 21:06:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfHXBGN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 21:06:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC21483F3B;
        Sat, 24 Aug 2019 01:06:12 +0000 (UTC)
Received: from localhost (ovpn-112-32.ams2.redhat.com [10.36.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66E5318685;
        Sat, 24 Aug 2019 01:06:11 +0000 (UTC)
Date:   Sat, 24 Aug 2019 03:06:06 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [net PATCH] net: route dump netlink NLM_F_MULTI flag missing
Message-ID: <20190824030606.6ed68c9c@redhat.com>
In-Reply-To: <156660549861.5753.7912871726096518275.stgit@john-XPS-13-9370>
References: <156660549861.5753.7912871726096518275.stgit@john-XPS-13-9370>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Sat, 24 Aug 2019 01:06:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019 17:11:38 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> An excerpt from netlink(7) man page,
> 
>   In multipart messages (multiple nlmsghdr headers with associated payload
>   in one byte stream) the first and all following headers have the
>   NLM_F_MULTI flag set, except for the last  header  which  has the type
>   NLMSG_DONE.
> 
> but, after (ee28906) there is a missing NLM_F_MULTI flag in the middle of a
> FIB dump.

In your case (see below), it can be zero or more, depending on how many
exception routes you have.

> The result is user space applications following above man page
> excerpt may get confused and may stop parsing msg believing something went
> wrong.

Worse yet, also RFC 3459 says:

	[...] For multipart
	messages, the first and all following headers have the NLM_F_MULTI
	Netlink header flag set, except for the last header which has the
	Netlink header type NLMSG_DONE.

But iproute2 doesn't check for this, so the selftests I added didn't
notice. Thanks for fixing this!

> In the golang netlink lib [0] the library logic stops parsing believing the
> message is not a multipart message. Found this running Cilium[1] against
> net-next while adding a feature to auto-detect routes. I noticed with
> multiple route tables we no longer could detect the default routes on net
> tree kernels because the library logic was not returning them.

However, note that if strict netlink checking is requested (I think the
library should be updated), and RTM_F_CLONED is not set (which should
be the case if you are just looking for "regular" routes), you won't
hit this.

> Fix this by handling the fib_dump_info_fnhe() case the same way the
> fib_dump_info() handles it by passing the flags argument through the
> call chain and adding a flags argument to rt_fill_info().
> 
> Tested with Cilium stack and auto-detection of routes works again. Also
> annotated libs to dump netlink msgs and inspected NLM_F_MULTI and
> NLMSG_DONE flags look correct after this.
> 
> Note: In inet_rtm_getroute() pass rt_fill_info() '0' for flags the same
> as is done for fib_dump_info() so this looks correct to me.

Yes, that's correct, because if the buffer is too small for a single
route dumped by a single rt_fill_info() call, we'll just fail, so that
will never be a multipart message.

> [0] https://github.com/vishvananda/netlink/
> [1] https://github.com/cilium/
> 
> Fixes: ee28906fd7a14 ("ipv4: Dump route exceptions if requested")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano
