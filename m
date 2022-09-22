Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF525E580B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiIVBbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiIVBa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:30:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D9AAA4F2
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=hdmJ0asdheMb1xzvVIHXmL0Bl55Flg5r9ZdoHzUlFiY=; b=TB
        f46iqQAsz5gsy5mErYtPDp12uH/c3ZmUscZ25AH2SApllugVO8nET3pYU0FwXxUB+ENIRvdYC2YAj
        y9PUqMH26dImNwbL8yriSuYrxf7nrQr/LeVjtZg8Yw1QyeNsdb1IrWYxHNGfiya2YaPP9zaE18OPb
        QUy7r1n8p/Gq+rQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obB35-00HUAy-Vi; Thu, 22 Sep 2022 03:30:43 +0200
Date:   Thu, 22 Sep 2022 03:30:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <Yyu6w8Ovq2/aqzBc@lunn.ch>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921154107.61399763@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220921154107.61399763@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 03:41:07PM -0700, Stephen Hemminger wrote:
> On Wed, 21 Sep 2022 18:38:28 +0000
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> 
> > On Wed, Sep 21, 2022 at 11:36:37AM -0700, Stephen Hemminger wrote:
> > > On Wed, 21 Sep 2022 19:51:05 +0300
> > > Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > >   
> > > > +.BI master " DEVICE"
> > > > +- change the DSA master (host network interface) responsible for handling the
> > > > +local traffic termination of the given DSA switch user port. The selected
> > > > +interface must be eligible for operating as a DSA master of the switch tree
> > > > +which the DSA user port is a part of. Eligible DSA masters are those interfaces
> > > > +which have an "ethernet" reference towards their firmware node in the firmware
> > > > +description of the platform, or LAG (bond, team) interfaces which contain only
> > > > +such interfaces as their ports.  
> > > 
> > > We still need to find a better name for this.
> > > DSA predates the LF inclusive naming but that doesn't mean it can't be
> > > fixed in user visible commands.  
> > 
> > Need? Why need? Who needs this and since when?
> 
> Also see: https://www.kernel.org/doc/html/v6.0-rc6/process/coding-style.html#naming
> 
> For symbol names and documentation, avoid introducing new usage of ‘master / slave’ (or ‘slave’ independent of ‘master’) and ‘blacklist / whitelist’.
> 
> Recommended replacements for ‘master / slave’ are:
> ‘{primary,main} / {secondary,replica,subordinate}’ ‘{initiator,requester} / {target,responder}’ ‘{controller,host} / {device,worker,proxy}’ ‘leader / follower’ ‘director / performer’

Looking at these, none really fit the concept of what the master
interface is.

slave is also used quite a lot within DSA, but we can probably use
user in place of that, it is already somewhat used as a synonym within
DSA terminology.

Do you have any more recommendations for something which pairs with
user. 

   Andrew
