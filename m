Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD696478EFE
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 16:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbhLQPG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 10:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237848AbhLQPG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 10:06:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EF0C061574;
        Fri, 17 Dec 2021 07:06:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5014862258;
        Fri, 17 Dec 2021 15:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02804C36AE7;
        Fri, 17 Dec 2021 15:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639753587;
        bh=reSbYJsb2lp4YkJ36gpZzEnh+V1VGf/jaqK9usFoEPE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jnTkSMMbUX0E4r7fq7fLheHX71+ibSEGk3+4BjQRMNluPyw8HQi0RLWXUlqPqOT5y
         Pqj3qMedcF7cBPMtey0kEo9LB5eoxdBBzsxA1OvHDYZhxRaCpepAf5ec35tU89m2uY
         5kw/217MJDC5GS9vGmS053m9XnjHueIwcnZLw13LiZtU+2P0EJLehLOM/vN5D1vLgY
         7H5MDZ1Y21NSV+HxEBtYcdJuGvj7vkSoZAPlYJDiUEEUC1/P8Jb/kPr++rvDrzC4NK
         0By1l2ewSIwogNC8udO0scT35o0X0VrJ2B4k6bkAw/S4W1U9F9aGMvwFcQIUeKUkCb
         VuLvlY7Tln1UA==
Date:   Fri, 17 Dec 2021 07:06:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] sctp: export sctp_endpoint_{hold,put}() and
 return incremented endpoint
Message-ID: <20211217070626.790b8340@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211217134607.74983-1-lee.jones@linaro.org>
References: <20211217134607.74983-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Dec 2021 13:46:06 +0000 Lee Jones wrote:
> For example, in sctp_sock_dump(), we could have the following hunk:
> 
> 	sctp_endpoint_hold(tsp->asoc->ep);
> 	ep = tsp->asoc->ep;
> 	sk = ep->base.sk
> 	lock_sock(ep->base.sk);
> 
> It is possible for this task to be swapped out immediately following
> the call into sctp_endpoint_hold() that would change the address of
> tsp->asoc->ep to point to a completely different endpoint.  This means
> a reference could be taken to the old endpoint and the new one would
> be processed without a reference taken, moreover the new endpoint
> could then be freed whilst still processing as a result, causing a
> use-after-free.
> 
> If we return the exact pointer that was held, we ensure this task
> processes only the endpoint we have taken a reference to.  The
> resultant hunk now looks like this:
> 
>       ep = sctp_endpoint_hold(tsp->asoc->ep);
> 	sk = ep->base.sk
> 	lock_sock(sk);

If you have to explain what the next patch will do to make sense 
of this one it really is better to merge the two patches.
Exporting something is not a functional change, nor does it make
the changes easier to review, in fact the opposite is true.

> Fixes: 8f840e47f190c ("sctp: add the sctp_diag.c file")

This patch in itself fixes exactly nothing.
