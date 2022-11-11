Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756A2626216
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 20:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbiKKTfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 14:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiKKTfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 14:35:34 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B6576F94
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 11:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+DvGLwJq1616gqec2e/1wE27gnAMLbRxFeAYLeeC0Hg=; b=3aG/vF5q3nrbJz2H465ujEHqvw
        Gkt2tDvSuJ8D3v2E4Prni14+Q3bdFmVa5EgoF58NRDgHq1DUEWqjVA4iimPIkcBAXTwEjjJOxTyBm
        2xDYFqyPfLW8JX1VD2vloVMGnnX4Mgqzu3h2QBGxkz3qBrG4gyaMwf+2O5P9fpCBrXGU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otZoK-00292a-78; Fri, 11 Nov 2022 20:35:32 +0100
Date:   Fri, 11 Nov 2022 20:35:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] option to use proper skew timings for Micrel KSZ9021
Message-ID: <Y26kBMCnoGFho5Ne@lunn.ch>
References: <c3755dfd-004a-d869-3fcf-589297dd17bd@mev.co.uk>
 <Y2vi/IxoTpfwR65T@lunn.ch>
 <0b22ce6a-97b5-2784-fb52-7cbae8be39b0@mev.co.uk>
 <Y25bQfVwPZDT4T5D@lunn.ch>
 <23e33ae8-3cd0-cd4b-4648-5ffb07329efa@mev.co.uk>
 <Y26MGEqo+kdSiQmM@lunn.ch>
 <f2dff077-8a0b-2164-404f-d9bf4ee40d76@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2dff077-8a0b-2164-404f-d9bf4ee40d76@mev.co.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 07:03:08PM +0000, Ian Abbott wrote:
> On 11/11/2022 17:53, Andrew Lunn wrote:
> > > > And since you are adding more foot guns, please validate the values in
> > > > DT as strictly as possible, without breaking the existing binding.
> > > 
> > > Yes, some min/max clamping of skew values would be good.  The code for
> > > KSZ9131 does that already.
> > 
> > I would want much more strict checking than that. The old and the new
> > values probably don't intersect. So if you see an old value while
> > micrel,skew-equals-real-picoseconds is in force, fail the probe with
> > -EINVAL. It looks like the old binding silently preforms rounding to
> > the nearest delay. So you probably should not do the opposite, error
> > out for a new value when micrel,skew-equals-real-picoseconds is not in
> > force. But you can add range checks. A negative value is clearly wrong
> > for the old values and should be -EINVAL. You just need to watch out
> > for that the current code reads the values as u32, not s32, so you
> > won't actually see a negative value.
> 
> I'm not sure how to tell old values and new values apart (except for
> negative new values).  A divisibility test won't work for values that are
> divisible by 600 (lcm(120, 200)).

I might have this wrong, but i think they are:


 Old	New
===== ======
0	-840
200	-720
400	-600
600	-480
800	-360
1000	-240
1200	-120
1400	0
1600	120
1800	240
2000	360
2200	480
2400	600
2600	720
2800	840
3000	960

The only overlap is 0 and 600. You can just special case those two
values.

	Andrew
