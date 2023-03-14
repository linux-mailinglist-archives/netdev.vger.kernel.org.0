Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1A66B9063
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjCNKnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCNKny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:43:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF30814EB4;
        Tue, 14 Mar 2023 03:43:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD0806170C;
        Tue, 14 Mar 2023 10:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9CDC4339C;
        Tue, 14 Mar 2023 10:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678790591;
        bh=ornkWp5Ph6AdzScEq4ymFOIFMIZo4lm7FX7j2iEOLYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O3aKpmYweDBYbSu3Gsd6/ASy0IP8+MZVJ3zwUz9PaDftbzj0ln/IMSJWBtTAfqr8o
         OrmtturKJjJHEZn+c8rtI1VBWwxKYXIRJ+74tPiQX5S0eP5B2ve99oFQ5fW9RHIZi9
         EqvmATLL3bj/XaoER4sc3Fu8CUNu3ThMie6SGKrCKePXYvYVp1Mh6ihSor6h3N8W/8
         fHTFq8EVTuzR8vid5vh0klvan4oPRvYtEfCxkWWz2RB92cgP5sxxBJjhQsX9SeGoY2
         Zo88WZzr0DCbA3FAMUleZkuQikJYsUxT64rXvRFF6PFojZjzBKmRsiVBtWJJJ3g7Sb
         ObO9zUez0OCyw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pc28b-0003E8-FB; Tue, 14 Mar 2023 11:44:14 +0100
Date:   Tue, 14 Mar 2023 11:44:13 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: Re: [PATCH v5 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Message-ID: <ZBBP/S8OM0t6p57E@hovoldconsulting.com>
References: <20230209020916.6475-1-steev@kali.org>
 <20230209020916.6475-3-steev@kali.org>
 <ZAoS1T9m1lI21Cvn@hovoldconsulting.com>
 <CAKXuJqhEKB7cuVhEzObbFyYHyKj87M8iWVaoz7gkhS2OQ9tTBA@mail.gmail.com>
 <ZArb/ZQEmfGDjYyc@hovoldconsulting.com>
 <CAKXuJqhe3z0XrLCMZ3vc3+Ug-rMjayNuMAvh+ucuUkZQpQdb2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKXuJqhe3z0XrLCMZ3vc3+Ug-rMjayNuMAvh+ucuUkZQpQdb2A@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 10:18:48PM -0500, Steev Klimaszewski wrote:
> Hi Johan,
> 
> <SNIP>
> > > > As I mentioned elsewhere, you need to update also this function so that
> > > > wcn6855 can be powered down.
> > >
> > > Sorry, I do have that locally, I just haven't pushed a v6 as I was
> > > looking at Tim's v2 of the qca2066 and was wondering if I should or
> > > shouldn't continue working on my version of the driver?
> >
> > I only skimmed that patch a while ago, but that ones not strictly needed
> > for wcn6855, right? Things seems to work well here with just this series
> > applied.
> 
> Works, but, not quite well, and with the nvm bits from Tim's patch, we
> end up getting closer?  I think that is the best way to put it.  With
> what we currently have, we end up loading hpnv21.bin for our nvm patch
> file, however, we actually want (at least on my Thinkpad X13s) the
> .b8c file from the Windows partition for our nvm patch; With the b8c
> file symlinked to .bin with just my patch set, I am able to connect a
> pair of Air Pods Gen1 to the ThinkPad and play back audio, as well as
> use them for input.  With the .bin file that comes from
> linux-firmware, they will still connect, however, they will randomly
> disconnect, as well as the audio output is all garbled.

Hmm. Ok, but then we need to ask Lenovo and Qualcomm to release the
firmware files we need for the X13s. Until then using your patch and
"hpnv21.bin" at least works to some extent.

I could connect to one bluetooth speaker without noticing any problems,
but I did indeed get some garbled output when connecting to another. I
have not tried the .b8c file yet though, so this could possibly be some
other incompatibility issue.

> I think,
> ideally, we get v6+ in, and then we can figure out what to do about
> the bits that Tim's patch adds.  I've tried them locally, but I'm not
> confident enough in my knowledge to address the issues that are
> brought up in the code review there.

Yes, that seems reasonable. Your patch is more complete in that it adds
supports for managing power. Adding support for more fine grained
loading of "NVM configuration" files could be done on top.

> > > > With power-off handling fixed, this seems to work as quite well on my
> > > > X13s with 6.3-rc1. Nice job!
> > > >
> > > > Btw, apart from the frame reassembly error, I'm also seeing:
> > > >
> > > >         Bluetooth: Received HCI_IBS_WAKE_ACK in tx state 0
> > > >
> > > > during probe.
> > > >
> > > I'm still not sure where the frame reassembly error comes from, and I
> > > don't know how to get more info to figure it out either, if anyone
> > > happens to have any guidance for that, I would love some.
> > > Additionally, it doesn't always happen.  It seems to happen on the
> > > first load of the module, however, running modprobe -r && modprobe in
> > > a loop (with the powerdown properly modified so the log isn't full of
> > > splats),  it doesn't seem to occur every time. Likewise for the
> > > WAKE_ACK.
> >
> > Ok. Looks like the Chromium team tried to suppress these errors when
> > switching line speed by toggling rts, but the frame-assembly error I get
> > appears to happen before that.
> 
> I am still trying to figure it out here as well, but I want to get v6
> out there.

Yeah, I don't think that message during probe should be a show stopper
here.

Johan
