Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91FB5627A2D
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbiKNKNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiKNKM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:12:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7D21F60C;
        Mon, 14 Nov 2022 02:11:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E81E4B80DA8;
        Mon, 14 Nov 2022 10:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B2DC433D6;
        Mon, 14 Nov 2022 10:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668420692;
        bh=QwvAOVq2fJvIwPsgNt5K4VGQpKMoNtnaEe10rICI774=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KXIPBygAW4o4Cd6O22Jbnovr6UA54g8AiWNlc2E5/N52DHrjPdi3UAOZRO1NuxBih
         cRAMsqrkAmeXxsISPxeZ5S6tcu03r4T9ka5UhaUxotBqeXFHTEeJWQIbFq5FNPTUzo
         bB/gDtRzhAvzcT3TqDe9axGHz/l07p6FjIPC0986OglCfffqO2Q0lbDeM3cqs5K23+
         0wJ5hW2SGiZEDhlcNIQ7gQSssC7jXJVDT5vnGeY00U26k9AHXP7e/90I3EVpany2q7
         EOESr8yFzlWmmzeMpjI6WqXpwKTz3X+MOjcSWlHMWPO3COxqVyTugDo7RN6A8EU/Nw
         hBq4rXhw2p7wQ==
Date:   Mon, 14 Nov 2022 10:11:25 +0000
From:   Lee Jones <lee@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Gene Chen <gene_chen@richtek.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 00/11] leds: deduplicate led_init_default_state_get()
Message-ID: <Y3IUTUr/MXf9RQEP@google.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
 <Y1gZ/zBtc2KgXlbw@smile.fi.intel.com>
 <Y1+NHVS5ZJLFTBke@google.com>
 <Y1/qisszTjUL9ngU@smile.fi.intel.com>
 <Y2pmqBXYq3WQa97u@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y2pmqBXYq3WQa97u@smile.fi.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 08 Nov 2022, Andy Shevchenko wrote:

> On Mon, Oct 31, 2022 at 05:32:26PM +0200, Andy Shevchenko wrote:
> > On Mon, Oct 31, 2022 at 08:53:49AM +0000, Lee Jones wrote:
> > > On Tue, 25 Oct 2022, Andy Shevchenko wrote:
> > > 
> > > > On Tue, Sep 06, 2022 at 04:49:53PM +0300, Andy Shevchenko wrote:
> > > > > There are several users of LED framework that reimplement the
> > > > > functionality of led_init_default_state_get(). In order to
> > > > > deduplicate them move the declaration to the global header
> > > > > (patch 2) and convert users (patche 3-11).
> > > > 
> > > > Dear LED maintainers, is there any news on this series? It's hanging around
> > > > for almost 2 months now...
> > > 
> > > My offer still stands if help is required.
> > 
> > From my point of view the LED subsystem is quite laggish lately (as shown by
> > this patch series, for instance), which means that _in practice_ the help is
> > needed, but I haven't got if we have any administrative agreement on that.
> > 
> > Pavel?
> 
> So, Pavel seems quite unresponsive lately... Shall we just move on and take
> maintainership?

I had an off-line conversation with Greg who advised me against that.

-- 
Lee Jones [李琼斯]
