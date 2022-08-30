Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE075A6728
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiH3PVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiH3PVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:21:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4427C53B
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 08:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=k0BYIdjn8WKVt44zyMWESTS8DjHHRL94hwXzVY5B8UQ=; b=qx
        YkW4zOkU+pMsRoPtYQKwheaPPOeMGl5T+TiwZy1gp5npn2lyLMUoZs1vwHWaWJFjt8mRO1+IvXW4/
        JILsiUJnrvttYSzmubS+TA3BAtq3Ca56ARBOm73sh5UmXb9weRiy1kWhP1y0cHSvdpefnF7NFUnbF
        LPaZPa+SmDUKuiM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oT33D-00F5Dx-HO; Tue, 30 Aug 2022 17:21:15 +0200
Date:   Tue, 30 Aug 2022 17:21:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, qiangqing.zhang@nxp.com,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH v2] net: fec: Use unlocked timecounter reads for saving
 state
Message-ID: <Yw4q616Nl4LJdy/a@lunn.ch>
References: <20220830111516.82875-1-csokas.bence@prolan.hu>
 <Yw4ClKHWACSP2EQ1@lunn.ch>
 <bbe8a924-7291-14f9-1e88-802a211ca0f4@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bbe8a924-7291-14f9-1e88-802a211ca0f4@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 05:05:24PM +0200, Csókás Bence wrote:
> 
> 
> On 2022. 08. 30. 14:29, Andrew Lunn wrote:
> > > -	fec_ptp_gettime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
> > > +	if (preempt_count_equals(0)) {
> > 
> > ~/linux/drivers$ grep -r preempt_count_equals *
> > ~/linux/drivers$
> > 
> > No other driver plays games like this.
> > 
> > Why not unconditionally take the lock?
> 
> Because then we would be back at the original problem (see Marc's message):
> 
> | [   14.001542] BUG: sleeping function called from invalid context at
> kernel/locking/mutex.c:283
> 
> | [   14.010604] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 13,
> name: kworker/0:1
> 
> | [   14.018737] preempt_count: 201, expected: 0
> 
> We cannot take a mutex in atomic context. However, we also don't *need to*
> take a mutex in atomic context.

You are not taking a mutex, you are taking a spinlock. You can do that
in atomic context. Can you protect everything which needs protecting
with a spinlock? And avoid sleeping...

     Andrew
