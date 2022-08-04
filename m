Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CA9589C33
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 15:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbiHDNIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 09:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiHDNIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 09:08:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C59D63C5;
        Thu,  4 Aug 2022 06:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2zMZjkn8fyoKurObDxRmFDK54AzJli6i6gWrOVhN93g=; b=smfyW5Xw2WfXaBD8c1EiwfrRzu
        pb+SRazZo2AfqBnyAQNl1kS/qCzFiZwZ1OCSilW2gspEJbsSb/FXCsCj5DuwroNbQLJeK6Ll226LW
        QDz0TajPYVL3JJtYtl+4RnICllAsdgS3jdPafSPlFAw9Yr9aq5kGTFbViHlxKLp7njlg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oJaaB-00CQQp-Ga; Thu, 04 Aug 2022 15:08:11 +0200
Date:   Thu, 4 Aug 2022 15:08:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Subject: Re: [PATCH net 1/2] s390/qeth: update cached link_info for ethtool
Message-ID: <YuvEu9/bzLGU2sTA@lunn.ch>
References: <20220803144015.52946-1-wintera@linux.ibm.com>
 <20220803144015.52946-2-wintera@linux.ibm.com>
 <YuqR8HGEe2vWsxNz@lunn.ch>
 <dae87dee-67b0-30ce-91c0-a81eae8ec66f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dae87dee-67b0-30ce-91c0-a81eae8ec66f@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 04, 2022 at 10:53:33AM +0200, Alexandra Winter wrote:
> 
> 
> On 03.08.22 17:19, Andrew Lunn wrote:
> > On Wed, Aug 03, 2022 at 04:40:14PM +0200, Alexandra Winter wrote:
> >> Speed, duplex, port type and link mode can change, after the physical link
> >> goes down (STOPLAN) or the card goes offline
> > 
> > If the link is down, speed, and duplex are meaningless. They should be
> > set to DUPLEX_UNKNOWN, SPEED_UNKNOWN. There is no PORT_UNKNOWN, but
> > generally, it does not change on link up, so you could set this
> > depending on the hardware type.
> > 
> > 	Andrew
> 
> Thank you Andrew for the review. I fully understand your point.
> I would like to propose that I put that on my ToDo list and fix
> that in a follow-on patch to net-next.
> 
> The fields in the link_info control blocks are used today to generate
> other values (e.g. supported speed) which will not work with *_UNKNOWN,
> so the follow-on patch will be more than just 2 lines.

So it sounds like your code is all backwards around. If you know what
the hardware is, you know the supported link modes are, assuming its
not an SFP and the SFP module is not plugged in. Those link modes
should be independent of if the link is up or not. speed/duplex is
only valid when the link is up and negotiation has finished.

Since this is for net, than yes, maybe it would be best to go with a
minimal patch to make your backwards around code work. But for
net-next, you really should fix this properly. 

	  Andrew
