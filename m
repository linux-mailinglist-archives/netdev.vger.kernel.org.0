Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A913BE8CD
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 01:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfIYXJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 19:09:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45494 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfIYXJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 19:09:48 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iDGPi-0005aR-M7; Wed, 25 Sep 2019 23:09:38 +0000
Date:   Thu, 26 Sep 2019 00:09:38 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ncsi: prevent memory leak in ncsi_rsp_handler_gc
Message-ID: <20190925230938.GQ26530@ZenIV.linux.org.uk>
References: <20190925215854.14284-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925215854.14284-1-navid.emamdoost@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 04:58:53PM -0500, Navid Emamdoost wrote:
> In ncsi_rsp_handler_gc if allocation for nc->vlan_filter.vids fails the
> allocated memory for nc->mac_filter.addrs should be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  net/ncsi/ncsi-rsp.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> index d5611f04926d..f3f7c3772994 100644
> --- a/net/ncsi/ncsi-rsp.c
> +++ b/net/ncsi/ncsi-rsp.c
> @@ -800,8 +800,10 @@ static int ncsi_rsp_handler_gc(struct ncsi_request *nr)
>  	nc->vlan_filter.vids = kcalloc(rsp->vlan_cnt,
>  				       sizeof(*nc->vlan_filter.vids),
>  				       GFP_ATOMIC);
> -	if (!nc->vlan_filter.vids)
> +	if (!nc->vlan_filter.vids) {
> +		kfree(nc->mac_filter.addrs);
>  		return -ENOMEM;
> +	}

Again, why is it not a double-free?  IOW, what guarantees that we won't
be calling <greps> ncsi_remove_channel(nc) at later point?

I'm not familiar with that code, so you _might_ be correct in this case,
but you need a lot more analysis in commit message than "should be",
considering the other similar patches from the same source, with the
same level of details in them that had been provably broken.

I don't know what kind of heuristics you are using when looking for
leaks, but they demonstrably give quite a few false positives.

It might be useful (and not just for you) to discuss those heuristics.
Could you go over the patch series you've posted and follow them up
with "here I've decided that we have a leak for such and such reason".
_Including_ the ones where you've ended up with false positives.

Look at it this way: you've posted a lot of statements without any
proofs of their correctness *or* any way to guess what those missing
proofs might've been.  At least some of them are false.  I can try
to prove them from scratch and post such proofs where the statement
happens to be true and counterexamples where it happens to be false.
However, it would've been much more useful to go through what you've
actually done to arrive to those statements, so that mistakes
would not be repeated in new problems.  And those mistakes are very
unlikely to be yours alone, so other people would benefit as well.
