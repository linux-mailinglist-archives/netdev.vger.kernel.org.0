Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7403331C9
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 23:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhCIW6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 17:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232095AbhCIWwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 17:52:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1536964FBC;
        Tue,  9 Mar 2021 22:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615330327;
        bh=GgGN3Wx9k7pJrEfCTFr5qEj8Qpe7DrYkJHXwOr5nyHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ihaW/HGDBTAXMH8KX88ktCPXi7SxAZDuHpR9llQ/dvCUA4JxSuUY2u9TOB0qtoNj0
         sR1VljAfOT7xJ7BzofE2cXGrLjbUM71AbpA4QGC6NkOYgDOTJFfwBXmEVqaa2Pdozi
         zYitcHXreHUcVaXc6BCIxZtsqHaZ67+tZdHyl/tF0YUlIksWIf8XdhhY7GVmYnkHpT
         9TU8APxB9fbNCEgJ5DWKvFiKlT4byRHouPMtbo//WlarGfcUkRm5xlEDWI+cLRuzgI
         Rgd7GBNd69ckByCLAT3nCf8DNXtuxZQ/xfJHz/b04CXUsPhKcvw3AfHCyW21QUIpkb
         /tjkbFaqnB13g==
Date:   Tue, 9 Mar 2021 14:52:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>
Subject: Re: [RFC] devlink: health: add remediation type
Message-ID: <20210309145206.43091cdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <25fb28f1-03f9-8307-8d9b-22f81f94dfcd@nvidia.com>
References: <20210306024220.251721-1-kuba@kernel.org>
        <3d7e75bb-311d-ccd3-6852-cae5c32c9a8e@nvidia.com>
        <20210308091600.5f686fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <25fb28f1-03f9-8307-8d9b-22f81f94dfcd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Mar 2021 16:18:58 +0200 Eran Ben Elisha wrote:
> >> DLH_REMEDY_LOCAL_FIX: associated component will undergo a local
> >> un-harmful fix attempt.
> >> (e.g look for lost interrupt in mlx5e_tx_reporter_timeout_recover())  
> > 
> > Should we make it more specific? Maybe DLH_REMEDY_STALL: device stall
> > detected, resumed by re-trigerring processing, without reset?  
> 
> Sounds good.

FWIW I ended up calling it:

+ * @DLH_REMEDY_KICK: device stalled, processing will be re-triggered

> >> The assumption here is that a reporter's recovery function has one
> >> remedy. But it can have few remedies and escalate between them. Did you
> >> consider a bitmask?  
> > 
> > Yes, I tried to explain in the commit message. If we wanted to support
> > escalating remediations we'd also need separate counters etc. I think
> > having a health reporter per remediation should actually work fairly
> > well.  
> 
> That would require reporter's recovery procedure failure to trigger 
> health flow for other reporter.
> So we can find ourselves with 2 RX reporters, sharing the same diagnose 
> and dump callbacks, and each has other recovery flow.
> Seems a bit counterintuitive.

Let's talk about particular cases. Otherwise it's too easy to
misunderstand each other. I can't think of any practical case
where escalation makes sense.

> Maybe, per reporter, exposing a counter per each supported remedy is not 
> that bad?

It's a large change to the uAPI, and it makes vendors more likely 
to lump different problems under a single reporter (although I take
your point that it may cause over-splitting, but if we have to choose
between the two my preference is "too granular").
