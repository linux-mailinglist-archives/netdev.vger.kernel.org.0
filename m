Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607FE63A9CF
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiK1NnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiK1Nm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:42:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6B61131;
        Mon, 28 Nov 2022 05:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sMuw+r8XztM/y1RLcfVFDrwbd0bUxp2HwDoeUHaaJ4I=; b=lHZ+um/dRDTPKX/QYmMSYhCILO
        +GZexIJXLRc2Pr3g4cE8ujWFp4NxKn/r9Y7SgCSO83epSVKZ+ZZWHROK+QcolC1ktkUAtH/d/oqOQ
        SUsNwiP3KhKEUd/4s0YH6i1eA3hYmXW3anOJ6anakRqdk6WhZuIymun513EEeBd30e6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozeOw-003emo-2x; Mon, 28 Nov 2022 14:42:26 +0100
Date:   Mon, 28 Nov 2022 14:42:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Alan Stern <stern@rowland.harvard.edu>, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 2/6] can: etas_es58x: add devlink support
Message-ID: <Y4S6wnM33Vs56vr5@lunn.ch>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-3-mailhol.vincent@wanadoo.fr>
 <Y4JEGYMtIWX9clxo@lunn.ch>
 <CAMZ6RqK6AQVsRufw5Jr5aKpPQcy+05jq3TjrKqbaqk7NVgK+_Q@mail.gmail.com>
 <Y4OD70GD4KnoRk0k@rowland.harvard.edu>
 <CAMZ6Rq+Gi+rcLqSj2-kug7c1G_nNuj6peh5nH1DNoo8B3aSxzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6Rq+Gi+rcLqSj2-kug7c1G_nNuj6peh5nH1DNoo8B3aSxzw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > But if a driver does make the call, it should be careful to ensure that
> > the call happens _after_ the driver is finished using the interface-data
> > pointer.  For example, after all outstanding URBs have completed, if the
> > completion handlers will need to call usb_get_intfdata().
> 
> ACK. I understand that it should be called *after* the completion of
> any ongoing task.

What sometimes gets people is /sys, /proc. etc. A process can have
such a file open when the device is unplugged. If the read needs to
make use of your private data structure, you need to guarantee it
still exists.  Ideally the core needs to wait and not call the
disconnect until all such files are closed. Probably the USB core
does, it is such an obvious issue, but i have no knowledge of USB.

	Andrew

