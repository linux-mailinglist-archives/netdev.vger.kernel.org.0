Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3593FBA4A
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 18:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbhH3Qn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 12:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237049AbhH3Qn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 12:43:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CCFD60E90;
        Mon, 30 Aug 2021 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630341782;
        bh=3jELwyqjZM5q7lHZjWyEBaPFAJtZedb/iuwBoo03j5w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JSafe2vbeIQAAm6u+KUHiYDyZhlRLlKukqGcvu03wgXNVAYlntz2Fb69i8fzI4ReC
         FUGK3RJdf1REn6a6mkphnTHNo/CRTs5YUV9xTBPCLRvrWF4vxBFcCXQEn10PyrQPKX
         yAKQ6Q6ZEQaovt3gCKlK8vGvDDMiRv3IicE9I5FoJQYivq9/oCK2wrmkANNVcp/6+f
         buZ73+YhpUngOyVqiFpC9ZwQGIcEBND9QFtyi3KrLWtJ+R4WV3wMFgHZzeHPyeaV5r
         VFaiwSz6ZB8nrDfermOdKHWMSW/zIcU2yf24qhQHzSh1bmwLQIibDLn4ubk3aZuBNt
         cLSZ6wBYEKkXg==
Date:   Mon, 30 Aug 2021 09:43:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     ebiederm@xmission.com (Eric W. Biederman),
        Andrey Ignatov <rdna@fb.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kernel-team@fb.com>
Subject: Re: [PATCH net] rtnetlink: Return correct error on changing device
 netns
Message-ID: <20210830094301.4f6ada72@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830075948.73fda029@hermes.local>
References: <20210826002540.11306-1-rdna@fb.com>
        <8735qwi3mt.fsf@disp2133>
        <20210830075948.73fda029@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 07:59:48 -0700 Stephen Hemminger wrote:
> On Thu, 26 Aug 2021 11:15:22 -0500
> ebiederm@xmission.com (Eric W. Biederman) wrote:
> 
> > The analysis and the fix looks good to me.
> > 
> > The code calling do_setlink is inconsistent.  One caller of do_setlink
> > passes a NULL to indicate not name has been specified.  Other callers
> > pass a string of zero bytes to indicate no name has been specified.
> > 
> > I wonder if we might want to fix the callers to uniformly pass NULL,
> > instead of a string of length zero.
> > 
> > There is a slight chance this will trigger a regression somewhere
> > because we are changing the error code but this change looks easy enough
> > to revert in the unlikely event this breaks existing userspace.
> > 
> > Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>  
> 
> This patch causes a new warning from Coverity:
> ________________________________________________________________________________________________________
> *** CID 1490867:  Null pointer dereferences  (FORWARD_NULL)
> /net/core/rtnetlink.c: 2701 in do_setlink()
> 2695     
> 2696     	/*
> 2697     	 * Interface selected by interface index but interface
> 2698     	 * name provided implies that a name change has been
> 2699     	 * requested.
> 2700     	 */
>  [...]  
> 2701     	if (ifm->ifi_index > 0 && ifname[0]) {
> 2702     		err = dev_change_name(dev, ifname);
> 2703     		if (err < 0)
> 2704     			goto errout;
> 2705     		status |= DO_SETLINK_MODIFIED;
> 2706     
> 
> Originally, the code was not accepting ifname == NULL and would
> crash. Somewhere along the way some new callers seem to have gotten
> confused.
> 
> What code is call do_setlink() with NULL as ifname, that should be fixed.

It's a false positive. There's only one caller with ifname=NULL:

static int rtnl_group_changelink(const struct sk_buff *skb,
...
			err = do_setlink(skb, dev, ifm, extack, tb, NULL, 0);
			if (err < 0)
				return err;

Which has one caller, under this condition:

		if (ifm->ifi_index == 0 && tb[IFLA_GROUP])
			return rtnl_group_changelink(skb, net, ...

condition which excludes evaluating the check in question:

	if (ifm->ifi_index > 0 && ifname[0]) {
		err = dev_change_name(dev, ifname);

Proving ifm->ifi_index has to be 0 for ifname to be NULL.
