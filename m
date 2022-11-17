Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0D862E60E
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 21:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240452AbiKQUjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 15:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240402AbiKQUjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 15:39:17 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ADE8CB97
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=q3yu0qYDt1QjL+h7m5DHpsVVuZF/axUTSk6QNL2WIcU=; b=UTnT1wiDx+eXiA+9eLVANPPzVU
        yQgZF1gtVnD6lAe69nBK744nz5PpADl90qS216OYajsPBffup73SxNkRgWnMpz6xwSo+EqngA8SKg
        uGwn2u6jiXGgfJCcOBiEu/tJOodFrXtVyw0oQy2L9MrwFOPt1FmTIk6iVMPZ3zSEjjU0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovlfD-002jBD-4y; Thu, 17 Nov 2022 21:39:11 +0100
Date:   Thu, 17 Nov 2022 21:39:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 2/4] tsnep: Fix rotten packets
Message-ID: <Y3ab7xim0EfyCQHm@lunn.ch>
References: <20221117201440.21183-1-gerhard@engleder-embedded.com>
 <20221117201440.21183-3-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117201440.21183-3-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 09:14:38PM +0100, Gerhard Engleder wrote:
> If PTP synchronisation is done every second, then sporadic the interval
> is higher than one second:
> 
> ptp4l[696.582]: master offset        -17 s2 freq   -1891 path delay 573
> ptp4l[697.582]: master offset        -22 s2 freq   -1901 path delay 573
> ptp4l[699.368]: master offset         -1 s2 freq   -1887 path delay 573
>       ^^^^^^^ Should be 698.582!
> 
> This problem is caused by rotten packets, which are received after
> polling but before interrupts are enabled again.

Is this a hardware bug? At the end of the interrupt coalescence
period, should it not check the queue and fire an interrupt?

	Andrew
