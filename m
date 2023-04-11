Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCC06DCFA6
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 04:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDKCTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 22:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjDKCTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 22:19:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260781738;
        Mon, 10 Apr 2023 19:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4/pq0kfRsZZRdtz49/VrpJy5R/A4i/UsofZV+uwwKy8=; b=Aowq6Z9l2xa7L35kAFEsWHwI0D
        7TVFqAMffBofjnx1A48CSm1uMv9/PcGC6TaJWYf7lTJBbz7UQJY6Pag0HTvD/jgXB8wp1JKPD57hU
        gmtwJujaQq+liSXcqsFxA6rvtdT53zjXwHARfiXKyQrmFDyu06hOX011MTMIBW8ZDIR0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pm3b4-009xAV-WB; Tue, 11 Apr 2023 04:19:03 +0200
Date:   Tue, 11 Apr 2023 04:19:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Li <liali@redhat.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangbin Liu <haliu@redhat.com>,
        "Toppins, Jonathan" <jtoppins@redhat.com>
Subject: Re: [Question] About bonding offload
Message-ID: <49e0cf25-331b-4d26-8d9a-66434e7a270e@lunn.ch>
References: <CAKVySpzU_23Z6Gu1N=z0DRm+sUQDjyiyUc18r4rJ_YQ+YELuFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKVySpzU_23Z6Gu1N=z0DRm+sUQDjyiyUc18r4rJ_YQ+YELuFg@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 09:47:14AM +0800, Liang Li wrote:
> Hi Everyone,
> 
> I'm a redhat network-qe and am testing bonding offload. e.g. gso,tso,gro,lro.
> I got two questions during my testing.
> 
> 1. The tcp performance has no difference when bonding GRO is on versus off.
> When testing with bonding, I always get ~890 Mbits/sec bandwidth no
> matter whether GRO is on.
> When testing with a physical NIC instead of bonding on the same
> machine, with GRO off, I get 464 Mbits/sec bandwidth, with GRO on, I
> get  897 Mbits/sec bandwidth.
> So looks like the GRO can't be turned off on bonding?
> 
> I used iperf3 to test performance.
> And I limited iperf3 process cpu usage during my testing to simulate a
> cpu bottleneck.
> Otherwise it's difficult to see bandwidth differences when offload is
> on versus off.
> 
> I reported a bz for this: https://bugzilla.redhat.com/show_bug.cgi?id=2183434
> 
> 2.  Should bonding propagate offload configuration to slaves?
> For now, only "ethtool -K bond0 lro off" can be propagated to slaves,
> others can't be propagated to slaves, e.g.
>   ethtool -K bond0 tso on/off
>   ethtool -K bond0 gso on/off
>   ethtool -K bond0 gro on/off
>   ethtool -K bond0 lro on
> All above configurations can't be propagated to bonding slaves.
> 
> I reports a bz for this: https://bugzilla.redhat.com/show_bug.cgi?id=2183777
> 
> I am using the RHEL with kernel 4.18.0-481.el8.x86_64.
 
Hi Liang

Can you reproduce these issues with a modern kernel? net-next, or 6.3?

The normal process for issues like this is to investigate with the
latest kernel, and then backport fixes to old stable kernels.

       Andrew
