Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698E04B624E
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiBOFEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:04:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiBOFEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:04:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B6A1029DB;
        Mon, 14 Feb 2022 21:04:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57FF5612CF;
        Tue, 15 Feb 2022 05:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3D2C340EC;
        Tue, 15 Feb 2022 05:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644901451;
        bh=PX9u+6e9QNinBvycdzgGx+KcKDyFl4Dcs+o64X5VPL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CMb2PgLzLXx7wKXCZVsLow2ZhDlkO9pq/g3CjzFkE7ipJn5Q4wlwr6qrLTEUXhxNG
         9El6rqnXP3dbmSiNMtoKv8UyvEYMyf5i0t9a20Nfl2Y0nLYAsPshDy1uKHPqPFn+pC
         8oawFRliEkgadAhzmWM9Th4K3CHjn9Z+eFFGVaYcLJzY11sTvkjGYxSj6uITANU0xv
         XVZGggC3N6WY5XrD/s2F3jMzwaZFYD+RhlCGeJPWfyvRNrPHS2Tf5h3dDLvS+czwMA
         8L1T9qp24uqGztSfri0cMsRV6jMXat25ySPHO15HLfakKsnDDyvqk6U45J2LplbunI
         mU+kzA48hJ98w==
Date:   Mon, 14 Feb 2022 21:04:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     Wolfram Sang <wsa@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Subject: Re: [PATCH net-next v5 2/2] mctp i2c: MCTP I2C binding driver
Message-ID: <20220214210410.2d49e55f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b857c3087443f86746d81c1d686eaf5044db98a7.camel@codeconstruct.com.au>
References: <20220210063651.798007-1-matt@codeconstruct.com.au>
        <20220210063651.798007-3-matt@codeconstruct.com.au>
        <20220211143815.55fb29e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b857c3087443f86746d81c1d686eaf5044db98a7.camel@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Feb 2022 12:22:14 +0800 Matt Johnston wrote:
> On Fri, 2022-02-11 at 14:38 -0800, Jakub Kicinski wrote:
> >   
> > > +// Removes and unregisters a mctp-i2c netdev
> > > +static void mctp_i2c_free_netdev(struct mctp_i2c_dev *midev)
> > >   
> > You're doing a lot before the unregister call, this is likely racy.
> > The usual flow is to unregister the netdev, then do uninit, then free.
> > For instance you purge the queue but someone may Tx afterwards.
> > needs_free_netdev is a footgun.  
> 
> Thanks Jakub. I've reworked it here to do the work before register/after
> unregister, without needs_free_netdev.
> 
> One question, the tx thread calls netif_wake_queue() - is it safe to call
> that after unregister_netdev()? (before free_netdev)

I don't think so.

> I've moved the kthread_stop() to the post-unregister cleanup.

The usual way to deal with Tx would be to quiesce the worker in
ndo_stop. Maybe keep it simple and add a mutex around the worker?
You can then take the same mutex around:

	stop queue
	purge queue
	
Thanks to the mutex you'd know the worker is not running and as
long as worker does its !skb_queue_empty() under the same mutex
it will not wake the queue.
