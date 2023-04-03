Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DC86D4571
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjDCNP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjDCNPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:15:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7D63A82;
        Mon,  3 Apr 2023 06:15:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61A3AB81A0C;
        Mon,  3 Apr 2023 13:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9690BC433EF;
        Mon,  3 Apr 2023 13:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680527722;
        bh=ZKbe4iw77LcGEt9e0AKV+R+NHoQp3vPrrcLrFIfvtR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jBwBAvc7kZbP14IOE13cMQhgEctVyn4LR3vE+/BjrPTqkWZDUoRxCrtZ1YuzPy5Dk
         qmIVi6KkoJmrXZMGdZD8oFlKEs8ZAraU5seApN/3yQ9Ke+2/TvX46hZZ5XxSHiTmkq
         MdaAuf6VwzC0ZCmIhSPuLXtnoTMTDhmwzNUSvli0=
Date:   Mon, 3 Apr 2023 15:15:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: net: dsa: mv88e6xxx: Request for stable inclusion
Message-ID: <2023040343-grip-magical-89d2@gregkh>
References: <CAOMZO5BTAaEV+vzq8v_gtyBSC24BY7hWVBehKa_X9BFZY4aYaA@mail.gmail.com>
 <20230328152158.qximoksxqed3ctqv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328152158.qximoksxqed3ctqv@skbuf>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 06:21:58PM +0300, Vladimir Oltean wrote:
> Hi Fabio,
> 
> On Tue, Mar 28, 2023 at 11:51:35AM -0300, Fabio Estevam wrote:
> > Hi,
> > 
> > I am running kernel 6.1 on a system with a mv88e6320 and can easily
> > trigger a flood of "mv88e6085 30be0000.ethernet-1:00: VTU member
> > violation for vid 10, source port 5" messages.
> > 
> > When this happens, the Ethernet audio that passes through the switch
> > causes a loud noise in the speaker.
> > 
> > Backporting the following commits to 6.1 solves the problem:
> > 
> > 4bf24ad09bc0 ("net: dsa: mv88e6xxx: read FID when handling ATU violations")
> > 8646384d80f3 ("net: dsa: mv88e6xxx: replace ATU violation prints with
> > trace points")
> > 9e3d9ae52b56 ("net: dsa: mv88e6xxx: replace VTU violation prints with
> > trace points")
> > 
> > Please apply them to 6.1-stable tree.
> > 
> > Thanks,
> > 
> > Fabio Estevam
> 
> For my information, is there any relationship between the audio samples
> that (presumably) get packet drops resulting in noise, and the traffic
> getting VTU member violations? In other words, is the audio traffic sent
> using VID 10 on switch port 5?
> 
> I don't quite understand, since VLAN-filtered traffic should be dropped,
> what is the reason why the trace point patches would help. My only
> explanation is that the audio traffic passing through the switch *also*
> passes through the CPU, and the trace points reduce CPU load caused by
> an unrelated (and rogue) traffic stream.
> 
> If this isn't the case, and you see VTU violations as part of normal
> operation, I would say that's a different problem for which we would
> need more details.

Agreed, this sounds like the removal of printk messages is removing the
noise, not the actual fix for the reason the printk messages in the
first place, right?

thanks,

greg k-h
