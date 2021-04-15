Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3340B35FEEC
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhDOAcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhDOAcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:32:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D69C6121E;
        Thu, 15 Apr 2021 00:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618446704;
        bh=W4NQDLXog65ATsP/URn/6Ch/hF1qQ77VqqLdenSVss0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S+zh1Ic7fAbqV1sHMMofI4ypphTg0nFm7nZ4pNZ/hHvgRdCBy9q182NLIwQdWleF/
         va4u1OTwEIbPAgbkSOFbb4EQcU53eg9djyBlOMUMdugQmQBf2DbZTYRA2Gtir4kyfp
         tsYdURU23etNqZN79qA56tmTAaY49f5AJF/KPgvg/5JtFcpge/tgsTK2KWvhTVq0R/
         PuRileozRd7ONjLCylglJ4cXdbF3YlQFo8I5H0pR+Pw9G6p4ont7OpFeFfa4tzi+Tl
         78gcgCG+tAG/wdDv2xEz+9yoCCbIvozWX+dO5CYYyPpTEZKlWLOGNU6YVHbJr0CJ+G
         e06K8J5Fduosg==
Date:   Wed, 14 Apr 2021 17:31:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Joseph, Jithu" <jithu.joseph@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dvorax.fuxbrumer@linux.intel.com" <dvorax.fuxbrumer@linux.intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Subject: Re: [PATCH net-next 8/9] igc: Enable RX via AF_XDP zero-copy
Message-ID: <20210414173142.4dccbba1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3ca4bc81f52a50d91c2ec55906c934244ee397c9.camel@intel.com>
References: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
        <20210409164351.188953-9-anthony.l.nguyen@intel.com>
        <20210409173604.217406b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fcd46fb09a08af36b7c34693f4e687d2c9ca2422.camel@intel.com>
        <20210414162500.397ddb7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3ca4bc81f52a50d91c2ec55906c934244ee397c9.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 23:59:22 +0000 Joseph, Jithu wrote:
> On Wed, 2021-04-14 at 16:25 -0700, Jakub Kicinski wrote:
> > On Wed, 14 Apr 2021 23:14:04 +0000 Joseph, Jithu wrote:  
> > > If h/w time-stamp is added by the NIC, then metasize will be non
> > > zero
> > > (as  xdp->data is advanced by the driver ) .  h/w ts  is still
> > > copied
> > > into "skb_hwtstamps(skb)->hwtstamp" by  the caller of this function
> > > igc_dispatch_skb_zc()  . Do you still want it to be copied into
> > > __skb_put(skb, ) area too ?   
> > 
> > If TS is prepended to the frame it should be saved (e.g. on the
> > stack)
> > before XDP program is called and gets the chance to overwrite it. The
> > metadata length when XDP program is called should be 0.  
> 
> When you say metadata length should be 0 above, Do you mean that when
> bpf_prog_run_xdp(prog, xdp) is invoked, xdp->data and xdp->data_meta
> should point to the same address ?

Correct, see xdp_prepare_buff().
