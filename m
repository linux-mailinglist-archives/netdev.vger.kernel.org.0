Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BF5699513
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjBPNCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjBPNCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:02:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94963E634
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A16FBB82782
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 13:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27DAC433D2;
        Thu, 16 Feb 2023 13:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676552525;
        bh=96pnkAHxhPLP9/rqDxx9K/tWaZeynTtilJzM3a2T2yw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZvHw0QgoTy+Khnw/CU1LfVSgEg9MAMN7Oo1UYtvBGlEsRd0DXvvYIUCSs0hpEoFXv
         XRrqGtTYNkd46bYq6ySTDhztI0FCa1DxLvL+iEtMaAv2BhsnhzLpyKdezTafskyT8o
         2hOkd8lYHHj1C2mwjV140dWiZxtsbY12C/5oiXjY=
Date:   Thu, 16 Feb 2023 14:02:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Temerkhanov, Sergey" <sergey.temerkhanov@intel.com>,
        netdev@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next] auxiliary: Implement refcounting
Message-ID: <Y+4pSlKeNHhD2nH2@kroah.com>
References: <20230216121621.37063-1-sergey.temerkhanov@intel.com>
 <Y+4kwf3SRq5NBzBz@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+4kwf3SRq5NBzBz@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oh, one more fun thing:

On Thu, Feb 16, 2023 at 02:42:41PM +0200, Leon Romanovsky wrote:
> On Thu, Feb 16, 2023 at 01:16:21PM +0100, Temerkhanov, Sergey wrote:
> >  struct auxiliary_device {
> >  	struct device dev;
> > +	refcount_t refcnt;
> >  	const char *name;
> > +	struct wait_queue_head wq_head;
> >  	u32 id;

Sergey, you are adding an additional reference count to a structure that
is already properly reference counted!  So you are imposing 2 different
counts and lifecycles on a single tiny structure?  How is that even
supposed to work?

Again, please get reviews from internal Intel developers FIRST as is
required by all Intel kernel developers touching code like this.  You
know this, it is part of your internal development rules, please do not
try to ignore them, that's a sure way to get everyone to just ignore
your changes going forward.

thanks,

greg k-h
