Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946181945A7
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 18:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgCZRjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 13:39:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbgCZRjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 13:39:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDA7C20719;
        Thu, 26 Mar 2020 17:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585244355;
        bh=QFbC4JP/v5BYbHustgiwJJpoze5fhVmjYd679Zzz4nc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sDOhu+/iJr05p6mh49gRc/saTrEiISC2IAWWId92quaChbz2CVcOWgdK6BoW/eWhM
         0Kmx5Rb1zrnReA7XO90fZVFIfQXhsND6gA+gUlK3YmkQRXHY+vpH+qC7RUIpJWBpiD
         8mFCAmRIol/2eGhH8i5tbaN2mPBTLNWN5y/B0gFU=
Date:   Thu, 26 Mar 2020 10:39:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 2/2] devlink: Add auto dump flag to health
 reporter
Message-ID: <20200326103913.150b8108@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200326102244.GT11304@nanopsycho.orion>
References: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
        <1585142784-10517-3-git-send-email-eranbe@mellanox.com>
        <20200325114529.3f4179c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200325190821.GE11304@nanopsycho.orion>
        <f947cfe1-1ec3-7bb5-90dc-3bea61b71cf3@mellanox.com>
        <20200325170135.28587e4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200326102244.GT11304@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 11:22:44 +0100 Jiri Pirko wrote:
> >> >>> @@ -4983,6 +4985,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
> >> >>>   	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
> >> >>>   			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
> >> >>>   		goto reporter_nest_cancel;
> >> >>> +	if (reporter->ops->dump &&
> >> >>> +	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
> >> >>> +		       reporter->auto_dump))
> >> >>> +		goto reporter_nest_cancel;    
> >> >>
> >> >> Since you're making it a u8 - does it make sense to indicate to user    
> >> > 
> >> > Please don't be mistaken. u8 carries a bool here.  
> >
> >Are you okay with limiting the value in the policy?  
> 
> Well, not-0 means true. Do you think it is wise to limit to 0/1?

Just future proofing, in general seems wise to always constrain the
input as much as possible. But in this case we already have similar
attrs in the dump which don't have the constraint, and we will probably
want consistency, so maybe we're unlikely to use other values.

In particular I was wondering if auto-dump value can be extended to
mean the number of dumps we want to collect, the current behavior I
think matches collecting just one. But obviously this can be solved
with a new attr when needed..
