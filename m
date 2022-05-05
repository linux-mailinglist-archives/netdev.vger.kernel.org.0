Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC2D51C6BE
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 20:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354855AbiEESMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 14:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiEESMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 14:12:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFCF554B3
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 11:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 616D961F1F
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6763DC385A4;
        Thu,  5 May 2022 18:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651774099;
        bh=o1D9W3mV4nlOFvs/Rd77CWl4QI0upM7ggMCpojlvSas=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n0GdqlXT8vlY/pkauwl80J2AMHZrHfcndVEYOFcMNzQSFAR1t640sY7vJ/O2TWfli
         GcroCF6NRbx2cE2vmB/vFx7rzdGGZCRSw+ME71ZPjL6sz45KgGjU4G06KrEE7cefpH
         y3/KuvUSWpkfrGdVfszh6GHmUPlJGg+VEdhoSeH0MjzTtTokn4+RTbSRqH955VPqvC
         3I2YmXHfRdb6wnuC2gDVr8sX4kleDPo+4MEV10NQgSZtSG7zaNp1NmFX6M4Pii7XPA
         xJLeGk+gtfbRq6yeDGIV89ulTbC7u/cjS/jVWa0gWUMh2RLRlW1IHtGhlVe7ptp35w
         G36YhscgVHIBw==
Date:   Thu, 5 May 2022 11:08:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "radheys@xilinx.com" <radheys@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "harinik@xilinx.com" <harinik@xilinx.com>
Subject: Re: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Message-ID: <20220505110817.74938ad8@kernel.org>
In-Reply-To: <5376cbf00c18487b7b96d72396807ab195f53ddc.camel@calian.com>
References: <20220429222835.3641895-1-robert.hancock@calian.com>
        <SA1PR02MB856018755A47967B5842A4C4C7C19@SA1PR02MB8560.namprd02.prod.outlook.com>
        <20220504192028.2f7d10fb@kernel.org>
        <5376cbf00c18487b7b96d72396807ab195f53ddc.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 May 2022 17:33:39 +0000 Robert Hancock wrote:
> On Wed, 2022-05-04 at 19:20 -0700, Jakub Kicinski wrote:
> > On Mon, 2 May 2022 19:30:51 +0000 Radhey Shyam Pandey wrote:  
> > > Thanks for the patch. I assume for simulating heavy network load we
> > > are using netperf/iperf. Do we have some details on the benchmark
> > > before and after adding TX NAPI? I want to see the impact on
> > > throughput.  
> > 
> > Seems like a reasonable ask, let's get the patch reposted 
> > with the numbers in the commit message.  
> 
> Didn't mean to ignore that request, looks like I didn't get Radhey's email
> directly, odd.
> 
> I did a test with iperf3 from the board (Xilinx MPSoC ZU9EG platform) connected
> to a Linux PC via a switch at 1G link speed. With TX NAPI in place I saw about
> 942 Mbps for TX rate, with the previous code I saw 941 Mbps. RX speed was also
> unchanged at 941 Mbps. So no real significant change either way. I can spin
> another version of the patch that includes these numbers.

Sounds like line rate, is there a difference in CPU utilization?
