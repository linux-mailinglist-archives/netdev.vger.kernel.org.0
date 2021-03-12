Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A3133833C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 02:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhCLBlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 20:41:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhCLBkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 20:40:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00CC564F84;
        Fri, 12 Mar 2021 01:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615513251;
        bh=uGVTP503N6JlMDKuA96LI3I3fD8dKjw5WZ0J7DOgtv4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eXGQXSxVMrUsk5SIGieigS+tyLp4S3BNh76QgpD1Xt1iuhGi93aC+RGxlJx2MgJbE
         0ys3wuVOnWjLeShCjjnTdqGa7leyGFyF5jT8qTzAC9tzEdd6TvlUJWtbfqAM6mx6bL
         yD6C1AGy94nM5HJdyVaTR/v3+pt2QnBu/1TCtgmBRPGXc8PWnE2dqp3TSYSByDSljz
         9esasWgwRNQ6LMjmWN/Qq8vnlzffFwZGX3CWr0YilJOdsgXscA/7LrZxcEqKHsoIpL
         /mMbBUkH8Tm2zzElrHIdGWk9dLBydMboTbHYtDKQx6Fg26/6n2BdUaLkMZDG6UInxu
         qgHa/86tQevUw==
Date:   Thu, 11 Mar 2021 17:40:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: lapbether: Prevent racing when checking
 whether the netif is running
Message-ID: <20210311174050.0386416f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJht_EPf+MT+QARY3VUHzZUtNKshpAD0239xN1weAmRyj=2WTA@mail.gmail.com>
References: <20210311072311.2969-1-xie.he.0141@gmail.com>
        <20210311124309.5ee0ef02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EMToKj2OeeE1fMfwAVYvhbgZpENkv0C7ac+XHnWcTe2Tg@mail.gmail.com>
        <20210311145230.5f368151@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EMR6kqsetwNUbJJziLW97T0pXBSqSNZ5ma-q175cxoKyQ@mail.gmail.com>
        <20210311161030.5ed11805@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EPf+MT+QARY3VUHzZUtNKshpAD0239xN1weAmRyj=2WTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 16:28:47 -0800 Xie He wrote:
> On Thu, Mar 11, 2021 at 4:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > And the "noqueue" queue is there because it's on top of hdlc_fr.c
> > somehow or some out of tree driver? Or do you install it manually?  
> 
> No, this driver is not related to "hdlc_fr.c" or any out-of-tree
> driver. The default qdisc is "noqueue" for this driver because this
> driver doesn't set "tx_queue_len". This means the value of
> "tx_queue_len" would be 0. In this case, "alloc_netdev_mqs" will
> automatically add the "IFF_NO_QUEUE" flag to the device, then
> "attach_one_default_qdisc" in "net/sched/sch_generic.c" will attach
> the "noqueue" qdisc for devices with the "IFF_NO_QUEUE" flag.

I see.
