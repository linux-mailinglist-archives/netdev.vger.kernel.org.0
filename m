Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323F43E4D18
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbhHITbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235547AbhHITbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 15:31:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94B9D60C51;
        Mon,  9 Aug 2021 19:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628537472;
        bh=MrY/68GZ2Oe9njx/vSw5170b7WPyBLvamVAoadcb0kI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BWKcuWw9oc0cMdHuJ1xgqEk08FRS62kffb9z42tbOR7IKAbmdzacH9uvFM2sKxr26
         yL1MfVvLFb6Hjrkm9vpXooCJitdCWKSdKZufVMtmtOmLF1g9JNR94NRVRrzvyUS5Ap
         xifkakDJPRrnKdsqGAqxqzzEJSkAMHeheoEOi3FJ3qit2Xk1Pk0CwgWgFH91cE6WTR
         61Qaai7ZLCOZd8P287FJmJyuJU5bBh6LExw5fMMfpsq3V8KLWLc0wSXHj0AUyuJLbh
         3E7rsa2g8eoeW+2Bz5me6JUuvy+prIzNqoVig5PYk5gEPLeCJ1SFl5vkPHyMDeMaMo
         /ECDuyQ8VaSag==
Received: by pali.im (Postfix)
        id 241AEC7C; Mon,  9 Aug 2021 21:31:10 +0200 (CEST)
Date:   Mon, 9 Aug 2021 21:31:09 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210809193109.mw6ritfdu27uhie7@pali>
References: <20210807163749.18316-1-pali@kernel.org>
 <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 09 August 2021 12:25:46 Jakub Kicinski wrote:
> On Sat,  7 Aug 2021 18:37:49 +0200 Pali Rohár wrote:
> > Currently there are two ways how to create a new ppp interface. Old method
> > via ioctl(PPPIOCNEWUNIT) and new method via rtnl RTM_NEWLINK/NLM_F_CREATE
> > which was introduced in v4.7 by commit 96d934c70db6 ("ppp: add rtnetlink
> > device creation support").
> > 
> > ...
> 
> Your 2 previous patches were fixes and went into net, this patch seems
> to be on top of them but is a feature, so should go to net-next. 

Yes

> But it doesn't apply to net-next given net was not merged into net-next.
> Please rebase on top of net-next or (preferably) wait until next week
> so that the trees can get merged and then you can repost without causing
> any conflicts.

Better to wait. I would like hear some comments / review on this patch
if this is the correct approach as it adds a new API/ABI for userspace.

> >  static const struct nla_policy ppp_nl_policy[IFLA_PPP_MAX + 1] = {
> >  	[IFLA_PPP_DEV_FD]	= { .type = NLA_S32 },
> > +	[IFLA_PPP_UNIT_ID]	= { .type = NLA_S32 },
> >  };
> 
> set .strict_start_type, please so new attrs get validated better
> 
> >  static int ppp_nl_validate(struct nlattr *tb[], struct nlattr *data[],
> > @@ -1274,6 +1277,15 @@ static int ppp_nl_validate(struct nlattr *tb[], struct nlattr *data[],
> >  
> >  	if (!data[IFLA_PPP_DEV_FD])
> >  		return -EINVAL;
> > +
> > +	/* Check for IFLA_PPP_UNIT_ID before IFLA_PPP_DEV_FD to allow userspace
> > +	 * detect if kernel supports IFLA_PPP_UNIT_ID or not by specifying
> > +	 * negative IFLA_PPP_DEV_FD. Previous kernel versions ignored
> > +	 * IFLA_PPP_UNIT_ID attribute.
> > +	 */
> > +	if (data[IFLA_PPP_UNIT_ID] && nla_get_s32(data[IFLA_PPP_UNIT_ID]) < -1)
> > +		return -EINVAL;
> 
> please use NLA_POLICY_MIN() instead, no need to open-code
> 
> >  	if (nla_get_s32(data[IFLA_PPP_DEV_FD]) < 0)
> >  		return -EBADF;

I will look at both issues... and I would like to know what is preferred
way to introduce new attributes in a way that userspace can detect if
kernel supports them or not.
