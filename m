Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7F258A1F1
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 22:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239788AbiHDU1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 16:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbiHDU1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 16:27:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844E91704C;
        Thu,  4 Aug 2022 13:27:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E90AB826AF;
        Thu,  4 Aug 2022 20:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85400C433D7;
        Thu,  4 Aug 2022 20:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659644868;
        bh=WKslkgauMcgPs5p6oyeqW1V1nFFD8xH0438vzYV6Xi0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EVeQ2Fyh8wHbWhx9Z1E2qiTK2rYovD5eREmaTpHHyEE97DO8Zf7+ySauZ8Chb2U1X
         GItZtVVsYfQxcpTfhs5SttqRTkCq80r+DfiAmP3iXwd+R4GiPRhZdWy7vUhCfUGBXJ
         M670l0iu9CogX45xIidKG2pOVPOVhSiXMYITCdL23CFW/4rUtnEJkjMW6cQd7MCwO7
         XFVklC27gQGkYAJVeC/d7uYtk2xyQy9ym0bnd+DarjcUC6pGtbCOAMlFFkWQl0i5P5
         utnnVLsRIZLnWMEeg06IbO6yfF0zmZte4OsO5Vb6JLpZZTiRTmPzcDooc8Wxka+QZL
         cNLOyY1VX14ow==
Date:   Thu, 4 Aug 2022 13:27:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Subject: Re: [PATCH net 1/2] s390/qeth: update cached link_info for ethtool
Message-ID: <20220804132742.73f8bfda@kernel.org>
In-Reply-To: <YuvEu9/bzLGU2sTA@lunn.ch>
References: <20220803144015.52946-1-wintera@linux.ibm.com>
        <20220803144015.52946-2-wintera@linux.ibm.com>
        <YuqR8HGEe2vWsxNz@lunn.ch>
        <dae87dee-67b0-30ce-91c0-a81eae8ec66f@linux.ibm.com>
        <YuvEu9/bzLGU2sTA@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Aug 2022 15:08:11 +0200 Andrew Lunn wrote:
> On Thu, Aug 04, 2022 at 10:53:33AM +0200, Alexandra Winter wrote:
> > Thank you Andrew for the review. I fully understand your point.
> > I would like to propose that I put that on my ToDo list and fix
> > that in a follow-on patch to net-next.
> > 
> > The fields in the link_info control blocks are used today to generate
> > other values (e.g. supported speed) which will not work with *_UNKNOWN,
> > so the follow-on patch will be more than just 2 lines.  
> 
> So it sounds like your code is all backwards around. If you know what
> the hardware is, you know the supported link modes are, assuming its
> not an SFP and the SFP module is not plugged in. Those link modes
> should be independent of if the link is up or not. speed/duplex is
> only valid when the link is up and negotiation has finished.

To make sure I understand - the code depends on the speed and duplex
being set to something specific when the device is _down_? Can this be
spelled out more clearly in the commit message?

> Since this is for net, than yes, maybe it would be best to go with a
> minimal patch to make your backwards around code work. But for
> net-next, you really should fix this properly. 

Then again this patch doesn't look like a regression fix (and does not
have a fixes tag). Channeling my inner Greg I'd say - fix this right and
then worry about backports later. 
