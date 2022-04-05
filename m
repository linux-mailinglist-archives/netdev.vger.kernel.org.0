Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B254F34C4
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbiDEJer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 05:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238449AbiDEJci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:32:38 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3207D6C;
        Tue,  5 Apr 2022 02:19:29 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E1FF7221D4;
        Tue,  5 Apr 2022 11:19:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649150368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BOvj4u69nnl0MRspeEi8s3JMbY/tCVXYqntAM7FXoYM=;
        b=m3RUG0UMPDNFyI4gv+Ph23UcaiROlA2mhed7gN+Xme7uDlxgUwIZtiS2q3oJgilsF5toFx
        pHqXmbcoIlcQ6mNT9wgqyLFnA/NUyTxsASJRXOzUDrJgBRhSY3g6QlwFVEpdkUMvNFVx9p
        /nuXiThKwOhvWNzhZC9D6WKUNayp138=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 Apr 2022 11:19:27 +0200
From:   Michael Walle <michael@walle.cc>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, richardcochran@gmail.com,
        davem@davemloft.net, grygorii.strashko@ti.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
In-Reply-To: <877d83rjjc.fsf@kurt>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc> <YksMvHgXZxA+YZci@lunn.ch>
 <e5a6f6193b86388ed7a081939b8745be@walle.cc> <877d83rjjc.fsf@kurt>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc>
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

Am 2022-04-05 11:01, schrieb Kurt Kanzenbach:
> On Mon Apr 04 2022, Michael Walle wrote:
>> That would make sense. I guess what bothers me with the current
>> mechanism is that a feature addition to the PHY in the *future* (the
>> timestamping support) might break a board - or at least changes the
>> behavior by suddenly using PHY timestamping.
> 
> Currently PHY timestamping is hidden behind a configuration option
> (NETWORK_PHY_TIMESTAMPING). By disabling this option the default
> behavior should stay at MAC timestamping even if additional features
> are added on top of the PHY drivers at later stages. Or not?

That is correct. But a Kconfig option has several drawbacks:
(1) Doesn't work with boards where I might want PHY timestamping
     on *some* ports, thus I need to enable it and then stumple
     across the same problem.
(2) Doesn't work with generic distro support, which is what is
     ARM pushing right now with their SystemReady stuff (among other
     things also for embeddem system). Despite that, I have two boards
     which are already ready for booting debian out of the box for
     example. While I might convince Debian to enable that option
     (as I see it, that option is there to disable the additional
     overhead) it certainly won't be on a per board basis.
     Actually for keeping the MAC timestamping as is, you'd need to
     convince a distribution to never enable the PHY timestamping
     kconfig option.

So yes, I agree it will work when you have control over your
kconfig options, after all (1) might be more academic. But I'm
really concerned about (2).

-michael
