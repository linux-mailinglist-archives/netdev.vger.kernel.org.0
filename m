Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F147363CD16
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 03:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiK3CCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 21:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3CCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 21:02:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403751145E
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 18:02:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B539561991
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 02:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9914C433D7;
        Wed, 30 Nov 2022 02:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669773772;
        bh=4vQ3eCemM5ZpgiBiOryJuqXywtD95+NIXK5ae2tovm8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y4QKwf53kDmMaeRoBgt51bsy5JXCgn9ZuPQgE7Y1z6W+H0Y2r8wQMbfivU2Gjceys
         mRlo15kK0ngyF6l2fYXnuYXxjLqt+wUudHWMldipmNvZ+fzNEXWgwSbQFVyG6WcjnP
         CUFA8FBD4doa27Wr+ra/HLER0eivLPYEK7HP5P1St2CvPbQt+zU5DZ8ezSJHpfd2zx
         elOkPcKG4I6AxqbQjB5Cgz5laYDiVNiur7DvblmiESFzIQbBVSWM0N+P2MzXOe+V6z
         CNBiuu3DO67OshCaWHbMDDndEZYLPBRY4xCY9ANgfRdoWmOHVlvlAj3xUWdlAsSPmB
         J4uSEJSDrOBcw==
Date:   Tue, 29 Nov 2022 18:02:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Message-ID: <20221129180250.3320da56@kernel.org>
In-Reply-To: <fbf3266c-f125-c01a-fcc3-dc16b4055ed5@amd.com>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-9-snelson@pensando.io>
        <20221128102828.09ed497a@kernel.org>
        <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
        <20221128153719.2b6102cc@kernel.org>
        <75072b2a-0b69-d519-4174-6d61d027f7d4@amd.com>
        <20221128165522.62dcd7be@kernel.org>
        <51330a32-1fa1-cc0f-e06e-b4ac351cb820@amd.com>
        <20221128175448.3723f5ee@kernel.org>
        <fbf3266c-f125-c01a-fcc3-dc16b4055ed5@amd.com>
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

On Tue, 29 Nov 2022 09:57:25 -0800 Shannon Nelson wrote:
> >> Yes, a PF representor simply so we can get access to the .ndo_set_vf_xxx
> >> interfaces.  There is no network traffic running through the PF.  
> > 
> > In that case not only have you come up with your own name for
> > a SmartNIC, you also managed to misuse one of our existing terms
> > in your own way! It can't pass any traffic it's just a dummy to hook
> > the legacy vf ndos to. It's the opposite of what a repr is.  
> 
> Sorry, this seemed to me an reasonable use of the term.  Is there an 
> alternative wording we should use for this case?
> 
> Are there other existing methods we can use for getting the VF 
> configurations from the user, or does this make sense to keep in our 
> current simple model?

Enough back and forth. I'm not going to come up with a special model
just for you when a model already exists, and you present no technical
argument against it.

I am against merging your code, if you want to override find other
vendors and senior upstream reviewers who will side with you.
