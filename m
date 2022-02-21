Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B30A4BED0E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 23:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiBUWP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 17:15:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiBUWP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 17:15:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0597DA1;
        Mon, 21 Feb 2022 14:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LrbmvfwNGIwgy+UB4l1bSvxrHSaZTcqFnYluIe0366g=; b=RVfbGwXnvpSBpOoSQVaakQfn2I
        tPCRfUNRuo/MvVXjbHeDCbzD1n22PwG8WGJb7dgFie39xP/W4GR2f9rQl1TfwYonkDXqwq0QGczKE
        sDMOGcfExDJq7+IKQm3CQzPJrlSgKmmPQVu0Mcu4CATaj5aXA8uFYOunpLQDHohnbZX4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nMGxT-007RSF-Fw; Mon, 21 Feb 2022 23:15:03 +0100
Date:   Mon, 21 Feb 2022 23:15:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mauri Sandberg <maukka@ext.kapsi.fi>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: mv643xx_eth: handle EPROBE_DEFER
Message-ID: <YhQO52cvzIo8prKi@lunn.ch>
References: <20220221062441.2685-1-maukka@ext.kapsi.fi>
 <YhOD3eCm8mYHJ1HF@lunn.ch>
 <72041ee7-a618-85d0-4687-76dae2b04bbc@ext.kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72041ee7-a618-85d0-4687-76dae2b04bbc@ext.kapsi.fi>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Please can you add code to remove the platform device when the probe
> > fails.
> 
> I am looking at the vector 'port_platdev' that holds pointers to already
> initialised ports. There is this mv643xx_eth_shared_of_remove(), which
> probably could be utilised to remove them. Should I remove the platform
> devices only in case of probe defer or always if probe fails?
 
In general, a failing probe should always undo anything it has done so
far. Sometimes you can call the release function, or its
helpers. Other times you do a goto out: and then release stuff in the
reverse order it was taken.

It looks like platform_device_del() can take a NULL pointer, so it is
probably O.K. to call mv643xx_eth_shared_of_remove().

	 Andrew

