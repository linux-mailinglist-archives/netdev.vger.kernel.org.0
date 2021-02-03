Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CEA30D864
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 12:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhBCLSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 06:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbhBCLSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 06:18:38 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1FCC06174A;
        Wed,  3 Feb 2021 03:17:58 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id 7so23779030wrz.0;
        Wed, 03 Feb 2021 03:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EN3H31K/bOJSsjLnJKe3X5vfvZNM9RPMrc95EOotK5A=;
        b=TaWzyS/PVn45vOTeLE+4NrqYi2JM8VVCv0GhDIxDPUPXQNgW3vt4Onfh/6DSXymRek
         oL4wVmdvktu0n+MCCzcA8OTgZXolhwqdEklKjs09JBHIrugKA/DV7cYDytZf+oPG7SCj
         cXAedcRsfj8sgYHUyZYkwcK7dy2sZ9x/KDdV3nMYsATWhQ6aTzyIZdgRrFUzf2FEAtmr
         /UWomHlonmYykfbJA5pdo1TlexfIolsde+g2u5M+1WByW/afltxc/9lKBbl48e3BGU2M
         Wn4kbTl7QNuPR/h7aCpwCwyNsyd3dig0IKSWNGQRQ6EPUHKdNKsDd2T0+VpRkpU+r6pA
         nfIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EN3H31K/bOJSsjLnJKe3X5vfvZNM9RPMrc95EOotK5A=;
        b=jS7dJsUtru3O0xuCilIxDODkaMV/TiJvGNW7pzuEnUvgkp5rtoqm/WRtKs84afsX4q
         fySgbJMXd3ym4+hCM9USaYgQbga/Q8wOY6AbvGXFtDBSV3hc71sR7tI7P95Thiba0Ohc
         BXoBv9qhpljTO5AIHg/s9atvifjl/rk3Bxk/VdOu26umApuyyVujTl2CGKCTDzlrNBsO
         74oKVJQAaHcB7U4ZN3dBrCsOwSYsmeg1Efv+Fge5FFokn4Rv7qLAivAjVLxDkxvm3C0S
         HgQvoZnf3kIQugnn2f7j75u8ljrBq0kNxuoI4QHgpxrvWFH1ElMgHeuSx63l3FOUXYYL
         ow0Q==
X-Gm-Message-State: AOAM530VM5MrIqX9diPgeiQeqmb8aDtO5lmEMWKe+rkI6GxtglSEG9Ju
        x0kmqf5FOlWbFtwtyWOTZsY=
X-Google-Smtp-Source: ABdhPJza9GPgkT8rzhWt3hMXfvVqVfZ3MkTD9GIA4r5axgX8dZ2EzAi1SVnIHaQI/F6vjjnOGehTdw==
X-Received: by 2002:a05:6000:1249:: with SMTP id j9mr2989450wrx.307.1612351076761;
        Wed, 03 Feb 2021 03:17:56 -0800 (PST)
Received: from anparri (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id l8sm2341491wmi.8.2021.02.03.03.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 03:17:56 -0800 (PST)
Date:   Wed, 3 Feb 2021 12:17:48 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, mikelley@microsoft.com,
        linux-hyperv@vger.kernel.org, skarade@microsoft.com,
        juvazq@microsoft.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] hv_netvsc: Copy packets sent by Hyper-V out
 of the receive buffer
Message-ID: <20210203111748.GA558300@anparri>
References: <20210126162907.21056-1-parri.andrea@gmail.com>
 <161196780649.27852.15602248378687946476.git-patchwork-notify@kernel.org>
 <20210202081843.GA3923@anparri>
 <20210202114549.7488f5bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202114549.7488f5bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 11:45:49AM -0800, Jakub Kicinski wrote:
> On Tue, 2 Feb 2021 09:18:43 +0100 Andrea Parri wrote:
> > Hi net maintainers,
> > 
> > 
> > On Sat, Jan 30, 2021 at 12:50:06AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> > > Hello:
> > > 
> > > This patch was applied to netdev/net-next.git (refs/heads/master):
> > > 
> > > On Tue, 26 Jan 2021 17:29:07 +0100 you wrote:  
> > > > Pointers to receive-buffer packets sent by Hyper-V are used within the
> > > > guest VM.  Hyper-V can send packets with erroneous values or modify
> > > > packet fields after they are processed by the guest.  To defend against
> > > > these scenarios, copy (sections of) the incoming packet after validating
> > > > their length and offset fields in netvsc_filter_receive().  In this way,
> > > > the packet can no longer be modified by the host.
> > > > 
> > > > [...]  
> > > 
> > > Here is the summary with links:
> > >   - [v2,net-next] hv_netvsc: Copy packets sent by Hyper-V out of the receive buffer
> > >     https://git.kernel.org/netdev/net-next/c/0ba35fe91ce3  
> > 
> > I'd have some fixes on top of this and I'm wondering about the process: would
> > you consider fixes/patches on top of this commit now? 
> 
> Fixes for bugs present in Linus's tree?
> 
> You need to target the net tree, and give us instructions on how to
> resolve the conflict which will arise from merging net into net-next.
> 
> > would you rather prefer me to squash these fixes into a v3? other?
> 
> Networking trees are immutable, and v2 was already applied. We could
> do a revert, apply fix, apply v3, but we prefer to just handle the 
> merge conflict.

Thanks for the clarification, Jakub.

And sorry for the confusion; let me just send out the 'fixes'/patches (I
have one targeting the net tree and two targeting the net-next tree, with
no conflict between them), so that they can be reviewed and we can agree
/discuss any further steps.

Thanks,
  Andrea
