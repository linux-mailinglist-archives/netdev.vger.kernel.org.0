Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580AF625CF2
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 15:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbiKKOZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 09:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiKKOZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 09:25:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8387391C0
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 06:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8YD7vYZrXCDu/cc3/7SdQkoqJr2hYQgTHeq8C1qQLo4=; b=NSK/hRK+bNhmpo38MYpxDsn3xE
        RPte9TbKdxUfWvCZ4Pvy1rtTWz8YjaVl48stoYjJ6VKlhVL0vbG2iAA4LjcvzwwKrZjDzPNqFN/zI
        CvMzsQXzfQ6LuaGOJG4i+yLSICmwU5gyrT9y/C84zujbFyJnMmZMb4wZ7SYS6+/9cEkg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otUxt-0027r8-37; Fri, 11 Nov 2022 15:25:05 +0100
Date:   Fri, 11 Nov 2022 15:25:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] option to use proper skew timings for Micrel KSZ9021
Message-ID: <Y25bQfVwPZDT4T5D@lunn.ch>
References: <c3755dfd-004a-d869-3fcf-589297dd17bd@mev.co.uk>
 <Y2vi/IxoTpfwR65T@lunn.ch>
 <0b22ce6a-97b5-2784-fb52-7cbae8be39b0@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b22ce6a-97b5-2784-fb52-7cbae8be39b0@mev.co.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 1. Forward planning to replace KSZ9021 with KSZ9031 in a future hardware
> iteration.  As long as the device tree and kernel driver (and possibly the
> bootloader if it uses the same device tree blob as the kernel internally)
> are upgraded at the same time, software upgrades of existing hardware with
> KSZ9021 will continue to work correctly.  Upgraded hardware with KSZ9031
> will work properly with the updated software.
> 
> 2. Due to KSZ9031 chip shortages, it may be useful to replace KSZ9031 with
> KSZ9021 for a few manufacturing runs.  This can be done as long as the
> device tree and driver are updated to know about the new property in time
> for those manufacturing runs.
> 
> In both cases, the skew timings chosen would need to apply to both KSZ9021
> and KSZ9031.

So you are saying that as it is pin compatible ( i assume), you can
swap the PHY and still call it the same board, and still use the same
device tree blob.

If you are going to do this, i think you really should fix all the
bugs, not just the step. KSZ9021 has an offset of -840ps. KSZ9031 has
an offset of -900ps. So both are broke, in that the skew is expected
to be a signed value, 0 meaning 0.

I would suggest a bool property something like:

micrel,skew-equals-real-picoseconds

and you need to update the documentation in a way it is really clear
what is going on.

I would also consider adding a phydev_dbg() which prints the actual ps
skew being used, with/without the bug.

And since you are adding more foot guns, please validate the values in
DT as strictly as possible, without breaking the existing binding.

   Andrew
