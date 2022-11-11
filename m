Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEE16260B0
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbiKKRxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiKKRxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:53:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576E5D111
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6rQZXTxg4b2bpbWBfBE969TjJ5jTuvoB67Nz49wbJWw=; b=M4pN45sdhrfq5FzWL6vTvEh/BI
        n0cRRZeYpVmrSsfrVn8nEI+5k+GdPtu9yKFPOfeOAnIq5Lrh/CuHJcli6uaOILsXwZkyE69TFZGaH
        nxtNXadwmJkPfWv95o8kr0+3/Tpg9icxyfZYqEjSJuEiY8ZQKtZVuQyGT9iZy3ZxfP1o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otYDY-0028mB-PI; Fri, 11 Nov 2022 18:53:28 +0100
Date:   Fri, 11 Nov 2022 18:53:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] option to use proper skew timings for Micrel KSZ9021
Message-ID: <Y26MGEqo+kdSiQmM@lunn.ch>
References: <c3755dfd-004a-d869-3fcf-589297dd17bd@mev.co.uk>
 <Y2vi/IxoTpfwR65T@lunn.ch>
 <0b22ce6a-97b5-2784-fb52-7cbae8be39b0@mev.co.uk>
 <Y25bQfVwPZDT4T5D@lunn.ch>
 <23e33ae8-3cd0-cd4b-4648-5ffb07329efa@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23e33ae8-3cd0-cd4b-4648-5ffb07329efa@mev.co.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, but you've convinced me that it is slightly more involved than I
> initially thought!
> 
> > If you are going to do this, i think you really should fix all the
> > bugs, not just the step. KSZ9021 has an offset of -840ps. KSZ9031 has
> > an offset of -900ps. So both are broke, in that the skew is expected
> > to be a signed value, 0 meaning 0.
> > 
> > I would suggest a bool property something like:
> > 
> > micrel,skew-equals-real-picoseconds
> > 
> > and you need to update the documentation in a way it is really clear
> > what is going on.
> 
> Perhaps it could allow the renamed properties for the KSZ9131 to be used.
> (They have similar names to the KSZ9021/KSZ9031 properties, but change the
> `-ps` suffix to `-psec`.)

That is also broken. Go check, everything else in DT uses -ps.

> > I would also consider adding a phydev_dbg() which prints the actual ps
> > skew being used, with/without the bug.
> > 
> > And since you are adding more foot guns, please validate the values in
> > DT as strictly as possible, without breaking the existing binding.
> 
> Yes, some min/max clamping of skew values would be good.  The code for
> KSZ9131 does that already.

I would want much more strict checking than that. The old and the new
values probably don't intersect. So if you see an old value while
micrel,skew-equals-real-picoseconds is in force, fail the probe with
-EINVAL. It looks like the old binding silently preforms rounding to
the nearest delay. So you probably should not do the opposite, error
out for a new value when micrel,skew-equals-real-picoseconds is not in
force. But you can add range checks. A negative value is clearly wrong
for the old values and should be -EINVAL. You just need to watch out
for that the current code reads the values as u32, not s32, so you
won't actually see a negative value.

Sometimes it is better to leave broke but working stuff broken and
just live with it.

      Andrew
