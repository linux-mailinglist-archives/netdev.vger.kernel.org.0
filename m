Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667C9536355
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 15:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351875AbiE0Ncl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 09:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240845AbiE0Nck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 09:32:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70D4146430
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 06:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=X1F2hPCxXVz8VFKOchBnmlBdpZm52ttGLEYrfweK9+4=; b=zKQ8nWzOS3P47GRiuZodf2rvQ8
        GkdiWxTLLu/1L8CsRmlIYxdbuxWn7G3gWGKADIQqgsKOIPdXimxH9fi0ADMcBguKEb03aFZuxEeZT
        AiqDeMZdJnGKwsr3+z7dVJtPTN8E+BOd8unZbKynymRvDzd5XP1DaycByZYJdTGnsKnY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nua4z-004SLS-56; Fri, 27 May 2022 15:32:37 +0200
Date:   Fri, 27 May 2022 15:32:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Markus Klotzbuecher <mk@mkio.de>
Cc:     netdev@vger.kernel.org
Subject: Re: cpsw_switch: unable to selectively forward multicast
Message-ID: <YpDS9Vg4Z+sdAfIp@lunn.ch>
References: <Yo33QJ1FXGBv2gHZ@e495>
 <Yo6aCiAOwZT6IiPR@lunn.ch>
 <YpBzDaZOzUYG0U/9@e495>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpBzDaZOzUYG0U/9@e495>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 08:43:25AM +0200, Markus Klotzbuecher wrote:
> Hi Andrew,
> 
> thank you for your feedback.
> 
> On Wed, May 25, 2022 at 11:05:14PM +0200, Andrew Lunn wrote:
> >On Wed, May 25, 2022 at 11:30:40AM +0200, Markus Klotzbuecher wrote:
> >> Hi All,
> >> 
> >> I'm using multiple am335x based devices connected in a daisy chain
> >> using cpsw_new in switch mode:
> >> 
> >>              /-br0-\          /-br0-\         /-br0-\
> >>             |       |        |       |       |       |
> >>         ---swp0    swp1-----swp0    swp1----swp0    swp1
> >>             |       |        |       |       |       |
> >>              \-----/          \-----/         \-----/
> >>                #1               #2              #3
> >> 
> >> The bridge is configured as described in cpsw_switchdev.rst
> >> [1]. Regular unicast traffic works fine, however I am unable to get
> >> traffic to multicast groups to be forwarded in both directions via the
> >> switches.
> >
> >Do you have listens reporting they are interested in the traffic via
> >IGMP? Do you have an IGMP quirer in your network? Without these, IGMP
> >snooping will not work.
> 
> The userspace application running on each device in the chain calls
> setsockopt + IP_ADD_MEMBERSHIP and peer devices receive IGMP packets
> such as
> 
>  7 10.399981403 192.168.178.51 ? 224.0.0.22   IGMPv3 62 Membership Report / Join group 239.253.253.239 for any sources
>  8 10.399981403 192.168.178.51 ? 224.0.0.22   IGMPv3 56 Membership Report / Join group 239.253.253.239 for any sources
> 
> and corresponding bridge mdb records appear for swpX and br0
> subsequently. Shouldn't this suffice for multicast to work or do I
> really need an additional IGMP querier? I realize that these mdb
> entries will expire, however multicast traffic isn't forwarded even
> temporarily and manually adding the same entries as 'permanent' didn't
> help either.

Hi Markus

You should have a quierer, in order to have reliable IGMP
snooping. However, that is a secondary issues, since it should work
with permanent mdb entries.

Unfortunately, i don't know the cpsw driver, so you need the TI guys
to help you.

   Andrew
