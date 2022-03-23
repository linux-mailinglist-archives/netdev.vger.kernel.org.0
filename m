Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438494E5587
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 16:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238256AbiCWPo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 11:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238237AbiCWPo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 11:44:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E71827B06
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 08:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13B5B617AE
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 15:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351D9C340E8;
        Wed, 23 Mar 2022 15:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648050205;
        bh=mhFwXfpfc1/YEsFC8glHzQpcxPjICKS8rePHQ8EaPJU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rVw3UKvzSKdE5ueKKjD9vCHfCNCjpGNbrTXWPYJadFCgg7gwEfqpsaEUMcxP653/b
         fZ8MnXMlhe3CKpSsB6RKdUAjomPKM/EkQtwtWM5mvodDIk3Jpc8Q5aqYboMMcEv8iW
         mDP1PR0fenZoLgGgaM0Uz4guHQLohYkWfyxcy5jqnMwj6cldJFwG0ON7z9L7jPtobJ
         zn9wmXp5lyDYiz+8ZS3ApQKGx+TgjH4ouwdW0aacKhLZ9NxkL9J60Ichf0AvfbQxDw
         xwexGa3BpmBTruhc/UL5vcjKGyUbv2Qvu76y6vPAdZn6DJovjq5c1aKVmvtUdAMLNy
         vFcXE8n/Kvikg==
Date:   Wed, 23 Mar 2022 08:43:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tomas Melin <tomas.melin@vaisala.com>,
        Robert Hancock <robert.hancock@calian.com>
Cc:     claudiu.beznea@microchip.com, Nicolas.Ferre@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3] net: macb: restart tx after tx used bit read
Message-ID: <20220323084324.37001694@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220323080820.137579-1-tomas.melin@vaisala.com>
References: <1545040937-6583-1-git-send-email-claudiu.beznea@microchip.com>
        <20220323080820.137579-1-tomas.melin@vaisala.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 10:08:20 +0200 Tomas Melin wrote:
> > From: <Claudiu.Beznea@microchip.com>
> > To: <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>
> > Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
> > 	<Claudiu.Beznea@microchip.com>
> > Subject: [PATCH v3] net: macb: restart tx after tx used bit read
> > Date: Mon, 17 Dec 2018 10:02:42 +0000	[thread overview]
> > Message-ID: <1545040937-6583-1-git-send-email-claudiu.beznea@microchip.com> (raw)
> > 
> > From: Claudiu Beznea <claudiu.beznea@microchip.com>
> > 
> > On some platforms (currently detected only on SAMA5D4) TX might stuck
> > even the pachets are still present in DMA memories and TX start was
> > issued for them. This happens due to race condition between MACB driver
> > updating next TX buffer descriptor to be used and IP reading the same
> > descriptor. In such a case, the "TX USED BIT READ" interrupt is asserted.
> > GEM/MACB user guide specifies that if a "TX USED BIT READ" interrupt
> > is asserted TX must be restarted. Restart TX if used bit is read and
> > packets are present in software TX queue. Packets are removed from software
> > TX queue if TX was successful for them (see macb_tx_interrupt()).
> > 
> > Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>  
> 
> On Xilinx Zynq the above change can cause infinite interrupt loop leading 
> to CPU stall. Seems timing/load needs to be appropriate for this to happen, and currently
> with 1G ethernet this can be triggered normally within minutes when running stress tests
> on the network interface.
> 
> The events leading up to the interrupt looping are similar as the issue described in the
> commit message. However in our case, restarting TX does not help at all. Instead
> the controller is stuck on the queue end descriptor generating endless TX_USED           
> interrupts, never breaking out of interrupt routine.
> 
> Any chance you remember more details about in which situation restarting TX helped for
> your use case? was tx_qbar at the end of frame or stopped in middle of frame?

Which kernel version are you using? Robert has been working on macb +
Zynq recently, adding him to CC.
