Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB0944B11D
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 17:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbhKIQ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 11:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238397AbhKIQ3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 11:29:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D4D261251;
        Tue,  9 Nov 2021 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636475212;
        bh=SJd+CBR3hNdsEqv2/U4F2PEdGBxSNKt2Ee8Bu7IryJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SP9EdDjWkaoWtryXQxnAXLmrXpdzt5RSZu1RQZi8Ss78+Li6rDfqhDMaKqmNV9ZBV
         8eGYuVymP8ejDsC10J/MDIsZpA84QsU1ZexaNrZ4JpJ7nRn5i7mR35ImQaB5eLqWyr
         sx5wlo8NvhKiyBm8WX8zmIpIWJAVZLWsBG+6358y7PbtzcL/PTOzoLM+C/a7WM3nf1
         DpiHxr1JhIVj+blMNy5Dkx5RtXK+VXRo3nOnnMlQjDW6MU343ShYdoz3q7HPPWUSt7
         sWob6X0Hh2U3dXmn6ivzeGtn2pOixXbnvrHO98SrEPBEMG8kO2nIljEg1RzXIcUVCb
         DR8ao8I9k7iOg==
Date:   Tue, 9 Nov 2021 08:26:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211109082648.73092dfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YYqenGW4ftZH5Ufi@nanopsycho>
References: <YYgSzEHppKY3oYTb@unreal>
        <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlfI4UgpEsMt5QI@unreal>
        <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlrZZTdJKhha0FF@unreal>
        <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYmBbJ5++iO4MOo7@unreal>
        <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211109144358.GA1824154@nvidia.com>
        <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYqenGW4ftZH5Ufi@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Nov 2021 17:15:24 +0100 Jiri Pirko wrote:
> Tue, Nov 09, 2021 at 04:07:02PM CET, kuba@kernel.org wrote:
> >On Tue, 9 Nov 2021 10:43:58 -0400 Jason Gunthorpe wrote:  
> >> This becomes all entangled in the aux device stuff we did before.  
> >
> >So entangled in fact that neither of you is willing to elucidate 
> >the exact need ;)
> >  
> >> devlink reload is defined, for reasons unrelated to netns, to do a
> >> complete restart of the aux devices below the devlink. This happens
> >> necessarily during actual reconfiguration operations, for instance.
> >> 
> >> So we have a situation, which seems like bad design, where reload is
> >> also triggered by net namespace change that has nothing to do with
> >> reconfiguring.  
> >
> >Agreed, it is somewhat uncomfortable that the same callback achieves
> >two things. As clear as the need for reload-for-reset is (reconfig,
> >recovery etc.) I'm not as clear on reload for netns.
> >
> >The main use case for reload for netns is placing a VF in a namespace,
> >for a container to use. Is that right? I've not seen use cases
> >requiring the PF to be moved, are there any?
> >
> >devlink now lives in a networking namespace yet it spans such
> >namespaces (thru global notifiers). I think we need to define what it
> >means for devlink to live in a namespace. Is it just about the
> >configuration / notification channel? Or do we expect proper isolation?
> >
> >Jiri?  
> 
> Well honestly the primary motivation was to be able to run smoothly with
> syzkaller for which the "configuration / notification channel" is
> enough.

Hm. And syzkaller runs in a namespace?

> By "proper isolation" you mean what exactly?

For the devlink instance and all subordinate objects to be entirely
contained to the namespace within which devlink resides, unless
explicitly liked up with or delegated to another namespace.
