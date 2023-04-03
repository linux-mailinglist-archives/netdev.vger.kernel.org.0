Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6E26D4575
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbjDCNQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbjDCNQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3351994;
        Mon,  3 Apr 2023 06:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6093F61B0F;
        Mon,  3 Apr 2023 13:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774B9C433EF;
        Mon,  3 Apr 2023 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680527787;
        bh=v5GEobEXWw9pWNaP5n7NjahjJYUHsbOXcTCsBnBC3Zs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tyLOupN8MHFwypuU5Jl7dKRwqg173TH0HJ2WHeo1zqSJtHhOjadclqraq9StnSdKY
         RkN+GrFcgkRiDWTtrpJgl2HZ0GiWseGC+vrSEcDkMieu1Y2oJW4fBO8e7+p5JF39N1
         OHckf/CmfRw1XrcUCCnL7YuxrnPZhhpFkrUJDNK4=
Date:   Mon, 3 Apr 2023 15:16:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: net: dsa: mv88e6xxx: Request for stable inclusion
Message-ID: <2023040308-entwine-paralyses-c870@gregkh>
References: <CAOMZO5BTAaEV+vzq8v_gtyBSC24BY7hWVBehKa_X9BFZY4aYaA@mail.gmail.com>
 <20230328152158.qximoksxqed3ctqv@skbuf>
 <2023040343-grip-magical-89d2@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023040343-grip-magical-89d2@gregkh>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 03:15:19PM +0200, Greg KH wrote:
> On Tue, Mar 28, 2023 at 06:21:58PM +0300, Vladimir Oltean wrote:
> > Hi Fabio,
> > 
> > On Tue, Mar 28, 2023 at 11:51:35AM -0300, Fabio Estevam wrote:
> > > Hi,
> > > 
> > > I am running kernel 6.1 on a system with a mv88e6320 and can easily
> > > trigger a flood of "mv88e6085 30be0000.ethernet-1:00: VTU member
> > > violation for vid 10, source port 5" messages.
> > > 
> > > When this happens, the Ethernet audio that passes through the switch
> > > causes a loud noise in the speaker.
> > > 
> > > Backporting the following commits to 6.1 solves the problem:
> > > 
> > > 4bf24ad09bc0 ("net: dsa: mv88e6xxx: read FID when handling ATU violations")
> > > 8646384d80f3 ("net: dsa: mv88e6xxx: replace ATU violation prints with
> > > trace points")
> > > 9e3d9ae52b56 ("net: dsa: mv88e6xxx: replace VTU violation prints with
> > > trace points")
> > > 
> > > Please apply them to 6.1-stable tree.
> > > 
> > > Thanks,
> > > 
> > > Fabio Estevam
> > 
> > For my information, is there any relationship between the audio samples
> > that (presumably) get packet drops resulting in noise, and the traffic
> > getting VTU member violations? In other words, is the audio traffic sent
> > using VID 10 on switch port 5?
> > 
> > I don't quite understand, since VLAN-filtered traffic should be dropped,
> > what is the reason why the trace point patches would help. My only
> > explanation is that the audio traffic passing through the switch *also*
> > passes through the CPU, and the trace points reduce CPU load caused by
> > an unrelated (and rogue) traffic stream.
> > 
> > If this isn't the case, and you see VTU violations as part of normal
> > operation, I would say that's a different problem for which we would
> > need more details.
> 
> Agreed, this sounds like the removal of printk messages is removing the
> noise, not the actual fix for the reason the printk messages in the
> first place, right?

But, in looking at the above commits, that makes more sense.  I'll go
queue these up for now, thanks.

greg k-h
