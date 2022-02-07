Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02ACD4ACDD2
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343840AbiBHBGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343578AbiBGXex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 18:34:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78102C061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 15:34:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 152B860EBE
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 23:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2C2C004E1;
        Mon,  7 Feb 2022 23:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644276892;
        bh=mV1SxDa66ERsrE5nIoh/L740qZRd2co98GM/3ZeFB6o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VHbdSrNtmU2wcpUa0nVECveM9rLMQIYxtIiNhOPAs2L2tHSt0ZBq4uD5EKWtm62Pn
         dZdFyFB3moEtbseT870ASANCbOqRTPdcZuN0g4Xl4cl4RS71irDEShTZ2QrpHsqmEK
         NMATUzwoFD8VOSGdPYox1MVIRrGl/szalax8KG70Fd3G5TssqVElx0REe2G0eYCQNO
         E+mwT5kYpKPX/B2y7+yMUAJ8asctxr9w0WC/s0vtDRk2OHX+Lun4TYhC1pCHcgUu8x
         OdOTGpDl7GCz7Un9PRrMs9qMAQ684Bey3EJgqEy7jftv3aq7R70QbFNGplY6eqez8S
         y8+LVqfRRdEHw==
Date:   Mon, 7 Feb 2022 15:34:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, kernel-team@fb.com, axboe@kernel.dk
Subject: Re: [PATCH net-next] tls: cap the output scatter list to something
 reasonable
Message-ID: <20220207153450.07102d45@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YgGNBMvSCcmLgTAJ@zeniv-ca.linux.org.uk>
References: <20220202222031.2174584-1-kuba@kernel.org>
        <YgFTsot6DUQptjWk@zeniv-ca.linux.org.uk>
        <20220207092619.08754453@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YgGNBMvSCcmLgTAJ@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Feb 2022 21:20:04 +0000 Al Viro wrote:
> > > > Alternatively we could parametrize iov_iter_npages() to take
> > > > the size as arg instead of using i->count, or do something
> > > > else..    
> > > 
> > > Er...  Would simply passing 16384/PAGE_SIZE instead of MAX_INT
> > > work for your purposes?  
> > 
> > The last arg is maxpages, I want maxbytes, no?  
> 
> What's the point of pass maxpages as argument to that, seeing that
> you ignore the value you've got?  I'm just trying to understand what
> semantics do you really intend for that thing.
> 
> Another thing: looking at that bunch now, for pipe-backed ones
> that won't work.  It's a bug, strictly speaking, even though
> the actual primitives that grab those pages *will* honour the
> truncation/reexpand.
> 
> Frankly, I wonder if we would be better off with making
> iov_iter_npages() a wrapper for that one, passing SIZE_MAX as
> maxbytes.  How does the following (completely untested) look for you?

That looks cleaner to me as well! Will you submit officially or should 
I take care of the conversion?  My v1 has already made its way to
net-next.
