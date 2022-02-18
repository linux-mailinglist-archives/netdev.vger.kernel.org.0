Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529054BAF3D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 02:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiBRBtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 20:49:11 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiBRBtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 20:49:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E97B12635
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 17:48:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41F7EB8253B
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 01:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9163AC340E8;
        Fri, 18 Feb 2022 01:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645148931;
        bh=XGNzRfsArXgL5xVz5Ku6OFAA2gdNxm2cWhWqfwGAPfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DAQFudneOuyxsqMjyIct7oqIjsj5+lResEM7jCBshxDssq98P9rYiWPCYiDQSoJ5z
         YWsbQ7WfWJ2sww2/XRFGRK4s0smw3u5nWX0ZfdaiIRFWcEaAuXV93w2pUjIXZxbpzo
         oi9jrHVJevcxSXi/njxhKDZHO7Cn6g4ABCne9m7jRVX73h+tEUWIaTf+o2w3MbmTVw
         CpAKIo3Kph3b0s4EBuVtrIXOfRBFnfmGEfBUPV/2dmcHNd3OPtay4b1woxUnvAXmS2
         EOeMkCtL/4hgIPcPxVlYpSTEw4ddXzjR8L/kEK3H6AYrjaA600eHFc7JAFofEbrATm
         tXvo+F9kDCxMA==
Date:   Thu, 17 Feb 2022 17:48:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, kernel-team@fb.com, axboe@kernel.dk
Subject: Re: [PATCH net-next] tls: cap the output scatter list to something
 reasonable
Message-ID: <20220217174850.1498c61c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207153450.07102d45@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220202222031.2174584-1-kuba@kernel.org>
        <YgFTsot6DUQptjWk@zeniv-ca.linux.org.uk>
        <20220207092619.08754453@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YgGNBMvSCcmLgTAJ@zeniv-ca.linux.org.uk>
        <20220207153450.07102d45@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On Mon, 7 Feb 2022 15:34:50 -0800 Jakub Kicinski wrote:
> > What's the point of pass maxpages as argument to that, seeing that
> > you ignore the value you've got?  I'm just trying to understand what
> > semantics do you really intend for that thing.
> > 
> > Another thing: looking at that bunch now, for pipe-backed ones
> > that won't work.  It's a bug, strictly speaking, even though
> > the actual primitives that grab those pages *will* honour the
> > truncation/reexpand.
> > 
> > Frankly, I wonder if we would be better off with making
> > iov_iter_npages() a wrapper for that one, passing SIZE_MAX as
> > maxbytes.  How does the following (completely untested) look for you?  
> 
> That looks cleaner to me as well! Will you submit officially or should 
> I take care of the conversion?  My v1 has already made its way to
> net-next.

Gentle reminder that I need at least your sign-off tag to make progress
here.
