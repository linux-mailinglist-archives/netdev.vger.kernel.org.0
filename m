Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF14C4A787A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346853AbiBBTFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:05:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39656 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230380AbiBBTFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 14:05:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=V+xRsfniZoUjwwTXWo3AcpaQElWKB2pmUjbsABVQ718=; b=RbtTQf4YEu/YUnxL/EoicZGcuZ
        R1cVK9EYQq9g2gnymM0NAjadcfpSYV/hDwz7Rya4ZmE1F2rJiBcP7zAjEr1QVyy1zuitaeWHWFgr7
        ND/kpSADzgzGRSXmZnV/F3X+HWUl0EoWrvnmIZ0S3zkmkv4/R4rbT7GtE27rbfBQFZ5g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFKwC-0040IY-Cp; Wed, 02 Feb 2022 20:05:04 +0100
Date:   Wed, 2 Feb 2022 20:05:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: IPA monitor (Final RFC)
Message-ID: <YfrV4EISeGj3o23o@lunn.ch>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org>
 <YeLk3STfx2DO4+FO@lunn.ch>
 <c9db7b36-3855-1ac1-41b6-f7e9b91e2074@linaro.org>
 <20220118103017.158ede27@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <f02ad768-2c8e-c8ed-e5f6-6ee79bf97c06@linaro.org>
 <36491c9e-c9fb-6740-9e51-58c23737318f@linaro.org>
 <YfnOFpUcOgAGeqln@lunn.ch>
 <cadf424a-6d67-cfd0-03e8-810233f7712d@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cadf424a-6d67-cfd0-03e8-810233f7712d@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From what I can tell, CRC errors are not indicated in the status
> header.  The status seems to be more oriented toward "this is
> the processing that the IPA hardware performed on this packet."
> Including "it entered IPA on this 'port' and matched this
> filter rule and got routed out this other 'port'."  But to be
> honest my focus has been more on providing the feature than
> what exactly those bits represent...

My experience of using interfaces like this, it is sometimes CRC
problems you are trying to track down. So it would be nice if the
behaviour around CRCs was documented, to know if packets with bad CRC
get dropped, or are part of the stream etc. It probably does not make
much difference to the actual API design.

> > Do you look at various libpcap-ng implementations? Since this is
> > debugfs you are not defining a stable ABI, you can change it any time
> > you want and break userspace. But maybe there could be small changes
> > in the API which make it easier to feed to wireshark via libpcap.
> 
> I considered that.  That was really the interface I was envisioning
> at first.  Those things don't really align perfectly with the
> information that's made available here though.  This is more like
> "what is the hardware doing to each packet" (so we can maybe
> understand behavior, or identify a bug).  Rather than "what is
> the content of packets flowing through?"  It might be useful
> to use the powerful capabilities of things like wireshark for
> analysis, but I kind of concluded the purpose of exposing this
> information is a little different.

I've had good experiences with writing dissectors for wireshark.  I
think you should be able to decode the extra headers, and then pass
the IP packet onto the standard dissectors. And having multiple frames
in one message should also not be a big issue. So i would not discard
the idea of writing into some sort of pcap file and feeding it to
wireshark.

    Andrew
