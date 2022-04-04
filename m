Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E574F1B2A
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379471AbiDDVTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379477AbiDDROL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 13:14:11 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E28513D16;
        Mon,  4 Apr 2022 10:12:14 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B2D27221D4;
        Mon,  4 Apr 2022 19:12:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649092332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r1V391gXkrq+wObnVOltoNfX4nAIN03QikBJ+WLh+HA=;
        b=hiHm2MFMnw2dS46c9Bx40pbU3T9Oh6eRxc5v8NhA0omQRL9qVl9YftXxiVzQdFk+QCntjR
        PbUnAPOSLZQV73qG0DGGmcLb+2AmkZxUwjxa7fxWKLUd1xUS1/e1jJHIV/ZYNJ2par2R7n
        nCgN1ChQj27AQitOJ8boPhF5BN6k14M=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 04 Apr 2022 19:12:11 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     richardcochran@gmail.com, davem@davemloft.net,
        grygorii.strashko@ti.com, kuba@kernel.org, kurt@linutronix.de,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
In-Reply-To: <YksMvHgXZxA+YZci@lunn.ch>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc> <YksMvHgXZxA+YZci@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <e5a6f6193b86388ed7a081939b8745be@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-04-04 17:20, schrieb Andrew Lunn:
> On Mon, Apr 04, 2022 at 05:05:08PM +0200, Michael Walle wrote:
>> Sorry for digging out this older thread, but it seems to be discussed
>> in [1].
>> 
>> > IMO, the default should be PHY because up until now the PHY layer was
>> > prefered.
>> >
>> > Or would you say the MAC layer should take default priority?
>> >
>> > (that may well break some existing systems)
>> 
>> Correct me if I'm wrong, but for systems with multiple interfaces,
>> in particular switches, you'd need external circuits to synchronize
>> the PHCs within in the PHYs.
> 
> If the PHYs are external. There are switches with internal PHYs, so
> they might already have the needed synchronisation.
> 
>> (And if you use a time aware scheduler
>> you'd need to synchronize the MAC, too). Whereas for switches there
>> is usually just one PHC in the MAC which just works.
> 
> And there could be switches with the MACs being totally
> independent. In theory.
> 
>> On these systems, pushing the timestamping to the PHY would mean
>> that this external circuitry must exist and have to be in use/
>> supported. MAC timestamping will work in all cases without any
>> external dependencies.
> 
> And if the MAC are independent, you need the external dependency.
> 
>> I'm working on a board with the LAN9668 switch which has one LAN8814
>> PHY and two GPY215 PHYs and two internal PHYs. The LAN9668 driver
>> will forward all timestamping ioctls to the PHY if it supports
>> timestamping (unconditionally). As soon as the patches to add ptp
>> support to the LAN8814 will be accepted, I guess it will break the
>> PTP/TAS support because there is no synchronization between all the
>> PHCs on that board. Thus, IMHO MAC timestamping should be the default.
> 
> There are arguments for MAC being the defaults. But we must have the
> option to do different, see above. But the real problem here is
> history. It is very hard to change a default without breaking systems
> which depend on that default. I believe Russell has a system which
> will break if the default is changed.
> 
> So i suspect the default cannot be changed, but maybe we need a
> mechanism where an interface or a board can express a preference it
> would prefer be used when there are multiple choices, in addition to
> the user space API to make the selection.

That would make sense. I guess what bothers me with the current
mechanism is that a feature addition to the PHY in the *future* (the
timestamping support) might break a board - or at least changes the
behavior by suddenly using PHY timestamping.

-michael
