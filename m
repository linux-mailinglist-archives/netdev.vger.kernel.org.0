Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE7951B5C8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 04:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238493AbiEECYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 22:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238455AbiEECYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 22:24:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8AF49C8B
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 19:20:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB4B5B82A9E
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 02:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240E2C385A5;
        Thu,  5 May 2022 02:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651717230;
        bh=4JuRqwNQ9hwhUqTttT0gUicftS+I9uLmhezFx58s+fo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kB5vwBUbJlggf+csLOoIg92Angr/zA4Hb3vNbjMioqtV2/uR879da47d+Y38esAW/
         J2kheQFTNgQivKUXK5NOZLhoXhGhegDwzAMYan/e3AuD1XDwPnUYKuOeIhGbMIJDiq
         pNuuNuRuOMBbPjbixs8f2Hw5oqOEsral2Jgq2UNgMeBOkypxbHwS2WIVEr3qMwoLc5
         YnG8p7ADHMxGUVFaiCB7MO7A41BNfTfpZb3wrIfF3pUvl3T0kKxkiE7tiWnmCLtmGg
         TCykz182vzT96MPv0CosQYBR5gMSM16Q3LdY+lGr9E9y7thhRQ6QCYtJmKWm1W0keO
         3WWttwF7xND9Q==
Date:   Wed, 4 May 2022 19:20:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Radhey Shyam Pandey <radheys@xilinx.com>,
        Robert Hancock <robert.hancock@calian.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Message-ID: <20220504192028.2f7d10fb@kernel.org>
In-Reply-To: <SA1PR02MB856018755A47967B5842A4C4C7C19@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220429222835.3641895-1-robert.hancock@calian.com>
        <SA1PR02MB856018755A47967B5842A4C4C7C19@SA1PR02MB8560.namprd02.prod.outlook.com>
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

On Mon, 2 May 2022 19:30:51 +0000 Radhey Shyam Pandey wrote:
> > This driver was using the TX IRQ handler to perform all TX completion
> > tasks. Under heavy TX network load, this can cause significant irqs-off
> > latencies (found to be in the hundreds of microseconds using ftrace).
> > This can cause other issues, such as overrunning serial UART FIFOs when
> > using high baud rates with limited UART FIFO sizes.
> > 
> > Switch to using the NAPI poll handler to perform the TX completion work
> > to get this out of hard IRQ context and avoid the IRQ latency impact.  
> 
> Thanks for the patch. I assume for simulating heavy network load we
> are using netperf/iperf. Do we have some details on the benchmark
> before and after adding TX NAPI? I want to see the impact on
> throughput.

Seems like a reasonable ask, let's get the patch reposted 
with the numbers in the commit message.
