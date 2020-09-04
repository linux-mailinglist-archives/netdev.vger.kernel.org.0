Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B6A25E242
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 21:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgIDT4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 15:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgIDT4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 15:56:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 123C42083B;
        Fri,  4 Sep 2020 19:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599249409;
        bh=c2AhlDdVAvX+tDg/VPTbZDKDsYGBF5EMgkBR3OTBRCk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uYOUFhdskgf4C0CbK6RaivPhsVj+G2NtB6UGnhw+xgvZh7Xh+yfO87mfwjbGDfgh6
         iM75mSL6rl8z2rzqOUfspZ02XdKHGAUbtsTHXC2Ytsu7ah5KEyZ2Zboq7gYifoj4Cl
         Bh6aC5GjIaxY+OTtUuGiwIA27dpDZpZANRVuj/wc=
Date:   Fri, 4 Sep 2020 12:56:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v3 01/14] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200904125647.799e66e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904090450.GH2997@nanopsycho.orion>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
        <1598801254-27764-2-git-send-email-moshe@mellanox.com>
        <20200831121501.GD3794@nanopsycho.orion>
        <9fffbe80-9a2a-33de-2e11-24be34648686@nvidia.com>
        <20200902094627.GB2568@nanopsycho>
        <20200902083025.43407d8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200903055729.GB2997@nanopsycho.orion>
        <20200903124719.75325f0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200904090450.GH2997@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 11:04:50 +0200 Jiri Pirko wrote:
> Thu, Sep 03, 2020 at 09:47:19PM CEST, kuba@kernel.org wrote:
> >On Thu, 3 Sep 2020 07:57:29 +0200 Jiri Pirko wrote:  
> >> Wed, Sep 02, 2020 at 05:30:25PM CEST, kuba@kernel.org wrote:  
> >> >On Wed, 2 Sep 2020 11:46:27 +0200 Jiri Pirko wrote:    
> >> >> >? Do we need such change there too or keep it as is, each action by itself
> >> >> >and return what was performed ?      
> >> >> 
> >> >> Well, I don't know. User asks for X, X should be performed, not Y or Z.
> >> >> So perhaps the return value is not needed.
> >> >> Just driver advertizes it supports X, Y, Z and the users says:
> >> >> 1) do X, driver does X
> >> >> 2) do Y, driver does Y
> >> >> 3) do Z, driver does Z
> >> >> [
> >> >> I think this kindof circles back to the original proposal...    
> >> >
> >> >Why? User does not care if you activate new devlink params when
> >> >activating new firmware. Trust me. So why make the user figure out
> >> >which of all possible reset option they should select? If there is 
> >> >a legitimate use case to limit what is reset - it should be handled
> >> >by a separate negative attribute, like --live which says don't reset
> >> >anything.    
> >> 
> >> I see. Okay. Could you please sum-up the interface as you propose it?  
> >
> >What I proposed on v1, pass requested actions as a bitfield, driver may
> >perform more actions, we can return performed actions in the response.  
> 
> Okay. So for example for mlxsw, user might say:
> 1) I want driver reinit
>     kernel reports: fw reset and driver reinit was done
> 2) I want fw reset
>     kernel reports: fw reset and driver reinit was done
> 3) I want fw reset and driver reinit
>     kernel reports: fw reset and driver reinit was done

Yup.

> >Then separate attribute to carry constraints for the request, like
> >--live.  
> 
> Hmm, this is a bit unclear how it is supposed to work. The constraints
> apply for all? I mean, the actions are requested by a bitfield.
> So the user can say:
> I want fw reset and driver reinit --live. "--live" applies to both fw
> reset and driver reinit? That is odd.

The way I was thinking about it - the constraint expresses what sort of
downtime the user can accept. So yes, it'd apply to all. If any of the
reset actions does not meet the constraint then error should be
returned.

In that sense I don't like --live because it doesn't really say much.
AFAIU it means 1) no link flap; 2) < 2 sec datapath downtime; 3) no
configuration is lost in kernel or device (including netdev config,
link config, flow rules, counters etc.). I was hoping at least the
documentation in patch 14 would be more precise.

I think you're saying that it's strange to express that as a constraint
because internally it maps to one of two fw reset types. And there is
only one driver reinit procedure. But I don't think that the
distinction of reset types is valuable to the user. What matters is if
application SLAs will be met or not.

I assume that deeper/longer reset is always less risky and would be
preferred unless constraint is specified.

> >I'd think the supported actions in devlink_ops would be fine as a
> >bitfield, too. Combinations are often hard to capture in static data.  
