Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605915E912F
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 08:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiIYGBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 02:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiIYGB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 02:01:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51E83DBFB
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 23:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91E05B80B50
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 06:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A578BC433C1;
        Sun, 25 Sep 2022 06:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664085686;
        bh=ZAcJFKlBa1MF+t/2GfyFmGBNIweKLg5SBjvlzpf4Ioo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FwLdLMjMvjP+6pjeyB+ufq6/8ibEXl4fDvlVuaY5AjwOgOHmJGawp8xKiMgVczN6t
         SzLKrtdNQ4zbdW7e+gcK5lYH2tGtm09nqy3QirLYM/F0Pw8ucQmALzHZNUZ9VcMVR/
         vRC1PVVsPlrS97z7Y6d2n0F9uFrgNbARl/A8/a+erodNjVydCL5JOs04n6ZPimHuPh
         U3hSd2zGD9ehGGoUDo+ZeEKeHv7T9RiEL5Lh/AXPCgVhxon1f6P//cwgCo56mVvRZ+
         xkKG7MNWcqxnypV3O6YNN7k3DFaXrn6/sWO6rbPoG2OrNx8U4Mk7/yEdRKQUvDfx14
         f6EGHJOzUC9eA==
Date:   Sun, 25 Sep 2022 09:01:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] net/mlx5: Make ASO poll CQ usable in atomic
 context
Message-ID: <Yy/usWIjvzHGNq0b@unreal>
References: <d941bb44798b938705ca6944d8ee02c97af7ddd5.1664017836.git.leonro@nvidia.com>
 <20220924172425.bfagbky4h5tbcxf4@fedora>
 <Yy9RuS1AaEe45iLZ@unreal>
 <20220924201131.6r2wslhqovcdhq5z@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220924201131.6r2wslhqovcdhq5z@fedora>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 01:11:31PM -0700, Saeed Mahameed wrote:
> On 24 Sep 21:51, Leon Romanovsky wrote:
> > On Sat, Sep 24, 2022 at 10:24:25AM -0700, Saeed Mahameed wrote:
> > > On 24 Sep 14:17, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > Poll CQ functions shouldn't sleep as they are called in atomic context.
> > > > The following splat appears once the mlx5_aso_poll_cq() is used in such
> > > > flow.
> > > >
> > > > BUG: scheduling while atomic: swapper/17/0/0x00000100
> > > 
> > > ...
> > > 
> > > > 	/* With newer FW, the wait for the first ASO WQE is more than 2us, put the wait 10ms. */
> > > > -	err = mlx5_aso_poll_cq(aso, true, 10);
> > > > +	expires = jiffies + msecs_to_jiffies(10);
> > > > +	do {
> > > > +		err = mlx5_aso_poll_cq(aso, true);
> > > > +	} while (err && time_is_after_jiffies(expires));
> > > > 	mutex_unlock(&flow_meters->aso_lock);
> > >         ^^^^
> > > busy poll won't work, this mutex is held and can sleep anyway.
> > > Let's discuss internally and solve this by design.
> > 
> > This is TC code, it doesn't need atomic context and had mutex + sleep
> > from the beginning.
> > 
> 
> then let's bring back the sleep for TC use-case, we don't need to burn the
> CPU!

Again, this is exactly how TC was implemented. The difference is that
before it burnt cycles in poll_cq and now it does it inside TC code.

> But still the change has bigger effect on other aso use cases, see below.

I have serious doubts about it.

> 
> > My change cleans mlx5_aso_poll_cq() from busy loop for the IPsec path,
> > so why do you plan to change in the design?
> > 
> 
> a typical use case for aso is
> 
> post_aso_wqe();
> poll_aso_cqe();
> 
> The HW needs time to consume and excute the wqe then generate the CQE.
> This is why the driver needs to wait a bit when polling for the cqe,
> your change will break others. Let's discuss internally.

IPsec was always implemented without any time delays, and I'm sure that
MACsec doesn't need too, it is probably copy/paste.

More generally, post_wqe->poll_cq is very basic paradigm in RDMA and
delays were never needed.

But if you insist, let's discuss internally.

Thanks

> 
> > Thanks
