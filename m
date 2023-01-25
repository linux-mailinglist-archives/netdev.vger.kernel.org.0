Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB74467B915
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjAYSO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbjAYSO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:14:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EAA4A209
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:14:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4887261389
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 18:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7014CC4339B;
        Wed, 25 Jan 2023 18:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674670464;
        bh=XWAVzb34iOoWWtM6l0EgcBzWniV1Dc84tP1r6KTDztc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DaPq6kiDl2PNz5qkDYSchFR0uzhMIkwTwmdd2ccGmCZ1DBnRhq/febrgd7Rq2Rk1p
         tqPNkKYrAftc2qbDtcZpm01Yb0AY6dd8nfmXHVjemFSjYM0vzxplSIQ771kUr+E4Zt
         Ir4zUJCvFv4yg7UOBGEEMC6vUIdG9dfWflinxkJXu17ggWD+nqjhf8H/bX/q2n1Vao
         ZfDPEIzeyI8t5KG/DIrb/twCKS8rIx6DvrWb5DEzWkRhGROqjQ2+EfG3U6bGgoH8s+
         5r/EWtENDNGdd5rqB7bYPoXBdu1JpzPKQCN4p8DGDWZ8VTXAnklj6lVtsm9dab5ZhP
         AgUDOmau1e43w==
Date:   Wed, 25 Jan 2023 10:14:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: Toggle between queue types in
 affinity mapping
Message-ID: <20230125101423.7b9590fe@kernel.org>
In-Reply-To: <0bf3b3e3-8927-bcdd-9600-4f9133d4d81d@linux.ibm.com>
References: <20230123221727.30423-1-nnac123@linux.ibm.com>
        <20230124183925.257621e8@kernel.org>
        <0bf3b3e3-8927-bcdd-9600-4f9133d4d81d@linux.ibm.com>
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

On Wed, 25 Jan 2023 10:55:20 -0600 Nick Child wrote:
> On 1/24/23 20:39, Jakub Kicinski wrote:
> > On Mon, 23 Jan 2023 16:17:27 -0600 Nick Child wrote:  
> >> A more optimal algorithm would balance the number RX and TX IRQ's across
> >> the physical cores. Therefore, to increase performance, distribute RX and
> >> TX IRQs across cores by alternating between assigning IRQs for RX and TX
> >> queues to CPUs.
> >> With a system with 64 CPUs and 32 queues, this results in the following
> >> pattern (binding is done in reverse order for readable code):
> >>
> >> IRQ type |  CPU number
> >> -----------------------
> >> TX15	 |	0-1
> >> RX15	 |	2-3
> >> TX14	 |	4-5
> >> RX14	 |	6-7  
> > 
> > Seems sensible but why did you invert the order? To save LoC?  
> 
> Thanks for checking this out Jakub.
> 
> Correct, the effect on performance is the same and IMO the algorithm
> is more readable. Less so about minimizing lines and more about
> making the code understandable for the next dev.

I spend way too much time explaining IRQ pinning to developers at my
"day job" :( Stuff like threaded NAPI means that more and more people
interact with it. So I think having a more easily understandable mapping
is worth the extra complexity in the driver. By which I mean:

Tx0 -> 0-1
Rx0 -> 2-3
Tx1 -> 4-5

IOW  Qn  -> n*4+is_rx*2 - n*4+is_rx*2+1
