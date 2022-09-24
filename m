Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F235E8DD4
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 17:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiIXP2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 11:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiIXP2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 11:28:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1CF8A1FD
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 08:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IUSpqnEy/yc65CtizDLAQ3RnWVoFSUm4I063YHxdw8s=; b=x6qlk55LTkq2CRBIDBu/66FjIN
        Zf7CoVZpv1HjFCRUZNYj/DHD5dG9zkRmcNeq2UssGF56nZOTQnGg4Rup0fKcVXV/0nfKEpASWCLN/
        b7kcoAOgY3hgS7ImF65MwVpuDe6cfJgghWiWhofaFXEKQ9BcTllMpYsDBFL6JqEVk50U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oc74R-0007ZF-MI; Sat, 24 Sep 2022 17:27:59 +0200
Date:   Sat, 24 Sep 2022 17:27:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v2 08/10] net: dsa: qca8k: Pass error code from reply
 decoder to requester
Message-ID: <Yy8h/+Fp0u5HQyzV@lunn.ch>
References: <20220922175821.4184622-1-andrew@lunn.ch>
 <20220922175821.4184622-1-andrew@lunn.ch>
 <20220922175821.4184622-9-andrew@lunn.ch>
 <20220922175821.4184622-9-andrew@lunn.ch>
 <20220923224201.pf7slosr5yag5iac@skbuf>
 <Yy8U71LdKpblNVjz@lunn.ch>
 <20220924144249.pz7577k3retgofjo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220924144249.pz7577k3retgofjo@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 02:42:50PM +0000, Vladimir Oltean wrote:
> On Sat, Sep 24, 2022 at 04:32:15PM +0200, Andrew Lunn wrote:
> > > My understanding of the autocast function (I could be wrong) is that
> > > it's essentially one request with 10 (or how many ports there are)
> > > responses. At least this is what the code appears to handle.
> > 
> > The autocast packet handling does not fit the model. I already
> > excluded it from parts of the patchset. I might need to exclude it
> > from more. It is something i need to understand more. I did find a
> > leaked data sheet for the qca8337, but i've not had time to read it
> > yet.
> > 
> > Either the model needs to change a bit, or we don't convert this part
> > of the code to use shared functions, or maybe we can do a different
> > implementation in the driver for statistics access.
> 
> I was thinking, as a complement to your series, maybe we could make the
> response processing also generic (so instead of the tagger calling a
> driver-provided handler, let it call a dsa_inband_response() instead).

I agree i've mostly looked at the dsa_inband_request side. Not having
any hardware means i've been trying to keep the patches simple,
obviously, and bug free. It seems i've failed at this last part.

I hope we can iterate the dsa_inband_response() afterwards. My
patchset is a good size on its own, so maybe we should get that merged
first, before starting on dsa_inband_response(). I would also like to
get some basic mv88e6xxx code merged, so it gives me a test system.

> This would look through the list of queued ds->requests, and have a
> (*match_cb)() which returns an action, be it "packet doesn't match this
> request", "packet matches, please remove request from list", or "packet
> matches, but still keep request in list". In addition, the queued
> request will also have a (*cb)(), which is the action to execute on
> match from a response. The idea is that if we bother to provide a
> generic implementation within DSA, at least we could try to make its
> core async, and just offer sychronous wrappers if this is what drivers
> wish to use (like a generic cb() which calls complete()).

The autocast is just different. What i don't know is, does any other
switch have anything similar? I guess every switch with inband is
going to have Request/reply, so i think we should concentrate on that.
Another thing we need to decide is, do we want to allow multiple in
flight request/reply. If we say No, all need is to be able to
determine is if a reply is late reply we should discard, or the reply
to the current request. That is much simpler than a generic match the
reply to a list of requests. For the moment, i would prefer KISS, lets
get something working for two devices. We can make it more complex
later.

    Andrew
