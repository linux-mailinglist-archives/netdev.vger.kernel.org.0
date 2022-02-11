Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBB64B2FD3
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 22:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353756AbiBKVuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 16:50:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiBKVuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 16:50:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161DBC66
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 13:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ipeT+rOOHTnRnU53FiQGNwUnB5ctvJAMKSGrsw5oQqY=; b=tnq14GrmmDjd1n9yYhtnNb2MSz
        wZDnJY1PPkBKbYnzg7+feEL72cftfLAWNXxiDDyz6rLL2sofRW30VchE3LwVWrJcLaQEFIs82zKld
        N4/Svjht7HKJniECpgYR7EMjakY7w4j2grwy88CGswDdjiS7eqb3n8hNN45iSQo2wV9g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIdoG-005Wdu-8O; Fri, 11 Feb 2022 22:50:32 +0100
Date:   Fri, 11 Feb 2022 22:50:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev@vger.kernel.org
Subject: Re: packet stats validation
Message-ID: <YgbaKDZhHfGV542h@lunn.ch>
References: <YgYixOmTSI7jxALK@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgYixOmTSI7jxALK@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 09:48:04AM +0100, Oleksij Rempel wrote:
> Hi all,
> 
> I'm implementing stats64 for the ksz switch and by validating my
> implementation found different by count methods in different sub
> systems. For example, i send 64 byte packet with:
> 
> mausezahn enp1s0f3 -c 1 -a rand -p 64
> 
> - tshark is recognizing 64 byte frame with 50 byte data
> - Intel igb is counting it as 64 byte
> - ksz9477 switch HW counter is counting it as 68 bytes packet
> - linux bridge is counting it as 50 byte packet
> 
> Can you please help me to understand this differences?
> Do linux bridge is doing it correct or it is a bug?
> ksz9477 is probably adding a tag and counting tagged packets. Should
> this number be provided to stats64?

I've come across this before, when i was doing systematic testing of
switches, using different USB ethernet dongles as traffic
source/sinks. Tests with one board and set of dongles gave different
results to a different board with different dongles. The drivers
counted different bytes in the frames. Some drivers include the FCS,
some don't, etc. I proposed a change to one of the drivers so it gave
the same counters as the other, but it was rejected. Because it is not
clearly defined what should be counted, there is not correct driver.

It is also unclear how you should count runt frames which get padded
up to 64 when actually put on the wire. This might be why the bridge
is so different, the frame as not been padded yet.

   Andrew
