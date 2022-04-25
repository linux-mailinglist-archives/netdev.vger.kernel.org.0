Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB94D50E208
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbiDYNki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiDYNkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:40:33 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186CD2AE0B
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:37:27 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 68C18240013;
        Mon, 25 Apr 2022 13:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650893846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=18zNJHD3IAD9QeHWgDT3mu9Gjegdi3D3qLCte3J/LE8=;
        b=dAfgSCzQaFJvf2OwvO+BiMcf1nNIJUNuxwPMb5mmalloIjqyLgGdlljQFtbUmTXQf1MbDo
        wAtn/EoxUMTb/+T/cEbZXpyHWw5opusv3zCnVk2vg5RX17y42TakFUhUvTA4OhBPI68Qj/
        uxYoGxfqZ/d+M/VL5cmjCvOTisY/HShTJ66z8i2+63rSNVId34cbxVk5TxuCWAt6ovV1rU
        U/y0HdidkvHCBEXRGoKcUPEnYyYCzDP5okG1FcxkUaeVcqPPdWudQMywXpA7sDjK5JHnbf
        bFDb/NjrmFYLdZc0utV8YjEBwSrjbDl1HzaYBDTVy10jLWgOtvk15QPbp+R9uQ==
Date:   Mon, 25 Apr 2022 15:37:24 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "Allan.Nielsen@microchip.com" <Allan.Nielsen@microchip.com>
Subject: Re: Offloading Priority Tables for queue classification
Message-ID: <20220425153724.17988365@pc-20.home>
In-Reply-To: <20220415154229.pmzgkgvlau5mftkp@skbuf>
References: <20220415173718.494f5fdb@fedora>
        <20220415154229.pmzgkgvlau5mftkp@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir !

On Fri, 15 Apr 2022 15:42:29 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Hi Maxime!
> 
> On Fri, Apr 15, 2022 at 05:37:18PM +0200, Maxime Chevallier wrote:
> > So in the end, my question would be : Is it OK to mix all of these
> > together ? Using the dcb layer to configure the internal mapping of
> > traffic -> priority, then using mqprio to configure the priority ->
> > queue mapping, and then either TC again or ethtool do configure the
> > behaviour of the queues themselves ? Or is there some other way that
> > we've missed ?  
> 
> I think it's ok to mix all of those together. At least the
> ocelot/felix DSA switches do support both advance QoS classification
> using tc-flower
> + skbedit priority action, and basic QoS classification (port-based or
> IP DSCP based) using the dcbnl application table. In short, at the end
> of the QoS classification process, a traffic class for the packet is
> selected. Then, the frame preemption would operate on the packet's
> traffic class.

Thank you very much for that answer, it helps a lot. TBH when digging
into classification, especially with TC, it's a bit overwhelming and it
gets difficult pretty quickly to get what's the right approach.

> Do you have any particular concerns?

My concerns were mainly about not reinventing the wheel, but also
making sure that I have the correct understanding on these
classification steps. I'll make sure to CC you when I have a first
series implementing that.

Best regards,

Maxime
