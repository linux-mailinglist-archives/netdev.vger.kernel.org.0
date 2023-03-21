Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCDC6C39BC
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjCUTDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjCUTC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:02:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A6751C87
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wQOGZW0XRxg9zqRtPqOD9ZPLKxGCemryNCznxBTEgkU=; b=4KZeaLC3aD3I2CF1W66hcmrwRU
        tXv4ZKF5+tHLq/JgqXi1SuCW9yCj5W+sxuuXbozUA0cL0xCBI2gAzBcM5duSUSKvMr504kaSnqigI
        1pwPT1jhDLcOHQFjFJk7wc0aX2HaOmVTmP0kK7on5KUhOZQwyjGH3nLGUqK7Ad83DTDw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pehFG-007zjy-EI; Tue, 21 Mar 2023 20:02:06 +0100
Date:   Tue, 21 Mar 2023 20:02:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jan Hoffmann <jan@3e8.eu>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        openwrt-devel@lists.openwrt.org,
        Sander Vanheule <sander@svanheule.net>,
        erkin.bozoglu@xeront.com
Subject: Re: [PATCH 0/6] realtek: fix management of mdb entries
Message-ID: <b6223705-e34d-4f0e-8d42-021fa467d773@lunn.ch>
References: <20230303214846.410414-1-jan@3e8.eu>
 <dd0c8abb-ebb7-8ea5-12ed-e88b5e310a28@arinc9.com>
 <20230306134636.p2ufzoqk6kf3hu3y@skbuf>
 <db38eb8f-9109-b142-6ef4-91df1c1c9de3@3e8.eu>
 <20230321172415.3ccdi4j226d5qa7h@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321172415.3ccdi4j226d5qa7h@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If the DSA subsystem could handle the "merging" instead and also call
> > port_mdb_add/port_mdb_del as appropriate for multicast router ports, the
> > individual drivers wouldn't have to deal with this particular issue at all.
> > 
> > > As a way to fix a bug quickly and get correct behavior, I guess there's
> > > also the option of stopping to process multicast packets in hardware,
> > > and configure the switch to always send any multicast to the CPU port
> > > only. As long as the tagger knows to leave skb->offload_fwd_mark unset,
> > > the bridge driver should know how to deal with those packets in
> > > software, and forward them only to whom is interested. But the drawback
> > > is that there is no forwarding acceleration involved. Maybe DSA should
> > > have done that from the get go for drivers which didn't care about
> > > multicast in particular, instead of ending up with this current situation
> > > which appears to be slightly chaotic.
> > 
> > Thanks,
> > Jan
> 
> Andrew, Florian, do you have any additional comments here?

I've no real experience with this either. But it sounds like this
merging should be pulled up into the bridge, if all switchdev drivers
need it.

     Andrew
