Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FE86DF867
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbjDLO0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjDLO0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:26:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64B77ED1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 07:25:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4887363551
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 14:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4518BC433D2;
        Wed, 12 Apr 2023 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681309556;
        bh=C/wNsCsqE6XBryEeNQP80N9Ixxia6H2jwBja9NvRP48=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EWAlCQ7aQheqqifH2rgzfwEGknmfjPc1UPaKDttOAGuy0lz5n+g45pfu8K9KLwFXb
         qCGXIaA4KPUNNKsMoxABsWn9GccyLdx8cVNcf7kOtMlpykBfLitCFBpQ008uTCPLxt
         5VaW3POIweFjRyQhc/Z2aeyEgorQwM3SY9asZ9Xqkgb7OFglNMqcLKemr3sObgDemS
         oJ1WfkGHotDDBt1J0dSiBNr27xdgvTMGwuRCF27Vz9hQ8s2ob7yCjhr9B9HKeOUrlf
         Zm0A4SMUf7f872xEFNonVsq0bjJiqxiStm9wODUizWJ5c0pnPXvDeI8BhYUY+YWIeq
         BcqUxUMni97yQ==
Date:   Wed, 12 Apr 2023 07:25:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv3 net-next] bonding: add software tx timestamping
 support
Message-ID: <20230412072555.38c7288f@kernel.org>
In-Reply-To: <ZDaj2J/2CR03H/Od@Laptop-X1>
References: <20230410082351.1176466-1-liuhangbin@gmail.com>
        <20230411213018.0b5b37ec@kernel.org>
        <32194.1681281203@famine>
        <ZDaj2J/2CR03H/Od@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 20:28:08 +0800 Hangbin Liu wrote:
> > 	Ok, maybe I didn't look at that carefully enough, and now that I
> > do, it's really complicated.
> > 
> > 	Going through it, I think the call path that's relevant is
> > taprio_change -> taprio_parse_clockid -> ethtool_ops->get_ts_info.
> > taprio_change is Qdisc_ops.change function, and tc_modify_qdisc should
> > come in with RTNL held.
> > 
> > 	If I'm reading cscope right, the other possible caller of
> > Qdisc_ops.change is fifo_set_limit, and it looks like that function is
> > only called by functions that are themselves Qdisc_ops.change functions
> > (red_change -> __red_change, sfb_change, tbf_change) or Qdisc_ops.init
> > functions (red_init -> __red_change, sfb_init, tbf_init).
> > 
> > 	There's also a qdisc_create_dflt -> Qdisc_ops.init call path,
> > but I don't know if literally all calls to qdisc_create_dflt hold RTNL.
> > 
> > 	There's a lot of them, and I'm not sure how many of those could
> > ever end up calling into taprio_change (if, say, a taprio qdisc is
> > attached within another qdisc).
> > 
> > 	qdisc_create also calls Qdisc_ops.init, but that one seems to
> > clearly expect to enter with RTNL.
> > 
> > 	Any tc expert able to state for sure whether it's possible to
> > get into any of the above without RTNL?  I suspect it isn't, but I'm not
> > 100% sure either.  
> 
> You dug more than me. Maybe we can add an ASSERT_RTNL() checking here first?
> But since we can't 100% sure we are holding the rtnl lock, I think we
> can keep the rcu lock for safe. I saw rlb_next_rx_slave() also did the same...

ASSERT_RTNL sounds good. I think that drivers may expect rtnl lock to 
be held around ethtool ops, so if some path is not holding it - I'd
count that as a bug.

> > >You could check in this loop if TX is supported...  
> > 
> > 	I see your point below about not wanting to create
> > SOFT_TIMESTAMPING_SOFTRXTX, but doesn't the logic need to test all three
> > of the flags _TX_SOFTWARE, _RX_SOFTWARE, and _SOFTWARE?  
> 
> I think Jakub means we have already add _RX_SOFTWARE and _SOFTWARE for bonding
> whatever slave's flag, then we just need to check slave's _TX_SOFTWARE flag.

Indeed.
