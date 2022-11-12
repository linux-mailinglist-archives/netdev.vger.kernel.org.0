Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F518626728
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 06:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiKLFeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 00:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKLFeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 00:34:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CC456ED7
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 21:34:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DCA960695
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 05:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F47C433D6;
        Sat, 12 Nov 2022 05:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668231259;
        bh=Sosg3LmKz15mZAzB/URe0w9Zx9E1om3psqk509/Wlvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tWJaMf9ka4+tLx9Vy2jnZAH4eWaGxHFLLFVb3hq8Nol9szdkDKpXPV7+aJcNYblGZ
         3eXkYZt8aPRYAOj2ACfzCoBixcnAvtgnO/397Hr6NbNmQN53gfYhA7LCfd1zctisXX
         x7Sv1AoHUnt1Bd6O2yaxK9X3y6JSW8shO+v8hLB1R1UuQiyZ175v36iIVCsQUh+4tH
         LjY2Wam//y5GTpvxLmlmPc3HmTsRNFsqjn+SX4mqm2W8snaH4hNc4G0YI2/xkZatPb
         PXDBxJhMXPimh4N79lc3amFwObv5RCFwjSDDV9uVIvWXGh0fW1pH6kvNsk602MCl4L
         pgFbo3g2i8hvQ==
Date:   Fri, 11 Nov 2022 21:34:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Thompson <davthompson@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        cai.huoqing@linux.dev, brgl@bgdev.pl, limings@nvidia.com,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <20221111213418.6ad3b8e7@kernel.org>
In-Reply-To: <Y2z9u4qCsLmx507g@lunn.ch>
References: <20221109224752.17664-1-davthompson@nvidia.com>
        <20221109224752.17664-4-davthompson@nvidia.com>
        <Y2z9u4qCsLmx507g@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Nov 2022 14:33:47 +0100 Andrew Lunn wrote:
> On Wed, Nov 09, 2022 at 05:47:51PM -0500, David Thompson wrote:
> > The BlueField-3 out-of-band Ethernet interface requires
> > SerDes configuration. There are two aspects to this:
> > 
> > Configuration of PLL:
> >     1) Initialize UPHY registers to values dependent on p1clk clock
> >     2) Load PLL best known values via the gateway register
> >     3) Set the fuses to tune up the SerDes voltage
> >     4) Lock the PLL
> >     5) Get the lanes out of functional reset.
> >     6) Configure the UPHY microcontroller via gateway reads/writes
> > 
> > Configuration of lanes:
> >     1) Configure and open TX lanes
> >     2) Configure and open RX lanes  
> 
> I still don't like all these black magic tables in the driver.
> 
> But lets see what others say.

Well, the patch was marked as Changes Requested so it seems that DaveM
concurs :) (I'm slightly desensitized to those tables because they
happen in WiFi relatively often.)

The recommendation is to come up with a format for a binary file, load
it via FW loader and then parse in the kernel?

We did have a recommendation against parsing FW files in the kernel at
some point, too, but perhaps this is simple enough to pass.

Should this be shared infra? The problem is fairly common.
