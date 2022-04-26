Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A192D50FC91
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 14:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346873AbiDZMPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 08:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345832AbiDZMPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 08:15:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744A922502
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 05:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Dq4q2zah4CrB69PB06jhJaSWSlf9RvpQ/G+Wl2cmm24=; b=BkDetfgs+JuvhQ2Gw924xiZZwb
        +f8G1ijBnAnP1tuTpqCATDcOSaHFDraIQ9+zWyYt1/PlBPWusWD1mU81vbbjJLbbZdGAlQCX5M5u9
        mDJ8ng9M/ddH1ovss+2+rsvjW4Wlm6FVNFQniKcyOQ/HJqPujxuixkrXxTNaIMqhLsRQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njK2h-00HXxP-4Q; Tue, 26 Apr 2022 14:11:43 +0200
Date:   Tue, 26 Apr 2022 14:11:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Ymfhf9aS0Rc/rhN2@lunn.ch>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <20220425125218.7caa473f@kernel.org>
 <YmeXyzumj1oTSX+x@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmeXyzumj1oTSX+x@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> The idea (implemented in the next patchset) is to let these devices
> >> expose their own "component name", which can then be plugged into the
> >> existing flash command:
> >> 
> >>     $ devlink lc show pci/0000:01:00.0 lc 8
> >>     pci/0000:01:00.0:
> >>       lc 8 state active type 16x100G
> >>         supported_types:
> >>            16x100G
> >>         devices:
> >>           device 0 flashable true component lc8_dev0
> >>           device 1 flashable false
> >>           device 2 flashable false
> >>           device 3 flashable false
> >>     $ devlink dev flash pci/0000:01:00.0 file some_file.mfa2 component lc8_dev0
> >
> >IDK if it's just me or this assumes deep knowledge of the system.
> >I don't understand why we need to list devices 1-3 at all. And they
> >don't even have names. No information is exposed. 
> 
> There are 4 gearboxes on the line card. They share the same flash. So if
> you flash gearbox 0, the rest will use the same FW.

Is the flash big enough to hold four copies of the firmware? Listing
all four devices gives you a path forward to allowing each device to
have its own firmware.

On the flip side, flashable false is not really true. I don't know
this API at all, but are there any flags? Can you at least indicate it
is shared? You could then have an output something like:

           device 0 flashable true shared component lc8_dev0
           device 1 flashable true shared component lc8_dev0
           device 2 flashable true shared component lc8_dev0
           device 3 flashable true shared component lc8_dev0

so you get to see the sharing relationship.

   Andrew
