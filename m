Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBA55763B8
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 16:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiGOOhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 10:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiGOOho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 10:37:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67A56EE98;
        Fri, 15 Jul 2022 07:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 606F361DA6;
        Fri, 15 Jul 2022 14:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EFBC34115;
        Fri, 15 Jul 2022 14:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657895862;
        bh=qkVcpST2o3Jr1fVSdgL/7dqsGupR5VwFKlLsdoSgiKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=keKvmYrJwxGuSdCTA1/9asZho0tJKw4B5JLSzoIyIo/2qdgP5BVhLY4C70jbmpgcr
         WkIRiFliZ6FyV0Ny1wAsNEfMCrg6JDPWKEsUCWlykcH3efgW0xWs6agvcqlbk8Zkv4
         FT1soll7ROBO2TIo/+Pc03PiGqYMcrD1QKdalKOg=
Date:   Fri, 15 Jul 2022 16:37:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
        Doug Berger <opendmb@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH stable 4.14 v3] net: dsa: bcm_sf2: force pause link
 settings
Message-ID: <YtF7s1bZQPJ90czR@kroah.com>
References: <20220708001405.1743251-1-f.fainelli@gmail.com>
 <20220708001405.1743251-2-f.fainelli@gmail.com>
 <Ys3JIVVpKvEts/Am@kroah.com>
 <b3c1d411-34c5-197c-5643-6fe4c4ee3723@gmail.com>
 <20220712220728.zqhq3okafzwz6cvb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712220728.zqhq3okafzwz6cvb@skbuf>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 01:07:28AM +0300, Vladimir Oltean wrote:
> On Tue, Jul 12, 2022 at 12:30:00PM -0700, Florian Fainelli wrote:
> > On 7/12/22 12:18, Greg Kroah-Hartman wrote:
> > > On Thu, Jul 07, 2022 at 05:14:05PM -0700, Florian Fainelli wrote:
> > > > From: Doug Berger <opendmb@gmail.com>
> > > > 
> > > > commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream
> > > > 
> > > > The pause settings reported by the PHY should also be applied to the
> > > > GMII port status override otherwise the switch will not generate pause
> > > > frames towards the link partner despite the advertisement saying
> > > > otherwise.
> > > > 
> > > > Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
> > > > Signed-off-by: Doug Berger <opendmb@gmail.com>
> > > > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > > > Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
> > > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > > ---
> > > > Changes in v3:
> > > > 
> > > > - gate the flow control enabling to links that are auto-negotiated and
> > > >    in full duplex
> > > > 
> > > 
> > > Are these versions better / ok now?
> > 
> > Vladimir "soft" acked it when posting the v3 to v2 incremental diff here:
> > 
> > https://lore.kernel.org/stable/20220707221537.atc4b2k7fifhvaej@skbuf/
> > 
> > so yes, these are good now. Thanks and sorry for the noise.
> > -- 
> > Florian
> 
> Sorry, I tend not to leave review tags on backported patches. I should
> have left a message stating that I looked at these patches and they look ok.

Thanks, both now queued up.

greg k-h
