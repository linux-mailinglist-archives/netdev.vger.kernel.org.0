Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F3D6F2EE1
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 08:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjEAGrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 02:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjEAGq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 02:46:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360D5192
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 23:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682923616; x=1714459616;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YqfN2dGTPjfFiF+QW5+XH7L1fq0xdFqvGuvE6s0D7FY=;
  b=hkvRfc39uEXndGltWykYXCiiFP+cfbsZ8pb54egSN7pEqt5BZp8gZ+7D
   hz68YIwmlh34/BjDJ7zcD3Q/jsbriFXGsUi/LDUY9ulzUcK8EIjb8iKDN
   jH98GcusqJB0JSneb6XWkvyHWTrumR0JxTUEoblsLFwvNA8XAikrmZZ4u
   9fB/aWl2KlvsnVz+IYDmYcoa1L9yVtGot9RTY5fjGRCNjx4JHoZBh+uk/
   szRuQnGaNQEEBQ+WmaqwzDZN6ZLSQKwPYDC7ifPSfDDLqf81IYi5+m2tD
   MXNEYvnJpHIGOOLB+T10ORRtWJx1fb4LxgyBVob5RuTYqIUGVgq1bTE7Z
   A==;
X-IronPort-AV: E=Sophos;i="5.99,239,1677567600"; 
   d="scan'208";a="211357451"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Apr 2023 23:46:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 30 Apr 2023 23:46:56 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Sun, 30 Apr 2023 23:46:55 -0700
Date:   Mon, 1 May 2023 08:46:55 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Ron Eggler <ron.eggler@mistywest.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: Unable to TX data on VSC8531
Message-ID: <20230501064655.2ovbo3yhkym3zu57@soft-dev3-1>
References: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/30/2023 07:08, Ron Eggler wrote:
> 
> Hi,

Hi Ron,

> 
> I've posted here previously about the bring up of two network interfaces
> on an embedded platform that is using two the Microsemi VSC8531 PHYs.
> (previous thread: issues to bring up two VSC8531 PHYs, Thanks to Heiner
> Kallweit & Andrew Lunn).
> I'm able to seemingly fully access & operate the network interfaces
> through ifconfig (and the ip commands) and I set the ip address to match
> my /24 network. However, while it looks like I can receive & see traffic
> on the line with tcpdump, it appears like none of my frames can go out
> in TX direction and hence entries in my arp table mostly remain
> incomplete (and if there actually happens to be a complete entry,
> sending anything to it doesn't seem to work and the TX counters in
> ifconfig stay at 0. How can I further troubleshoot this? I have set the
> phy-mode to rgmii-id in the device tree and have experimented with all
> the TX_CLK delay register settings in the PHY but have failed to make
> any progress.

Some of the VSC phys have this COMA mode, and then you need to pull
down a GPIO to take it out of this mode. I looked a little bit but I
didn't find anything like this for VSC8531 but maybe you can double
check this. But in that case both the RX and TX will not work.
Are there any errors seen in the registers 16 (0x10) or register 17
(0x11)?

> 
> Thank you,
> Ron

-- 
/Horatiu
