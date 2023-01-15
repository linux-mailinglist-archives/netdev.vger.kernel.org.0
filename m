Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C5366B2A5
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 17:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjAOQsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 11:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjAOQsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 11:48:30 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD1EC675
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 08:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VDN4ZcMTm2XXAkD1jevXmk+JGFJznA8SYQizYocoJ/s=; b=k1ok4xo2PPrSDV/7QpXTR6DZia
        QKtxlY9//tK9r/oOITIKeymXmH+rZrKTFGZpfZ+fQxAcB9i52Eb3IzmZ4iUgcL1kE5dOpOwm2tl4f
        Lt+cO0pR8pxP0pRcI/zyPB4e9l/6xLLRBhWowufSOQyJgEJGAG1rUPrCP4kehve9Rxaw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pH6B0-0028s5-Av; Sun, 15 Jan 2023 17:48:10 +0100
Date:   Sun, 15 Jan 2023 17:48:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>
Subject: Re: [PATCH net v1] net: stmmac: Fix queue statistics reading
Message-ID: <Y8QuSiFkIyRv1Lqf@lunn.ch>
References: <20230114120437.383514-1-kurt@linutronix.de>
 <Y8LFyqcpi6RjcjMo@lunn.ch>
 <87fsccvy2o.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsccvy2o.fsf@kurt>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 12:25:51PM +0100, Kurt Kanzenbach wrote:
> Hi Andrew,
> 
> On Sat Jan 14 2023, Andrew Lunn wrote:
> > On Sat, Jan 14, 2023 at 01:04:37PM +0100, Kurt Kanzenbach wrote:
> >> Correct queue statistics reading. All queue statistics are stored as unsigned
> >> long values. The retrieval for ethtool fetches these values as u64. However, on
> >> some systems the size of the counters are 32 bit.
> >
> >> @@ -551,16 +551,16 @@ static void stmmac_get_per_qstats(struct stmmac_priv *priv, u64 *data)
> >>  		p = (char *)priv + offsetof(struct stmmac_priv,
> >>  					    xstats.txq_stats[q].tx_pkt_n);
> >>  		for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
> >> -			*data++ = (*(u64 *)p);
> >> -			p += sizeof(u64 *);
> >> +			*data++ = (*(unsigned long *)p);
> >> +			p += sizeof(unsigned long);
> >
> > As you said in the comment, the register is 32 bits.
> 
> Maybe the commit message is a bit misleading. There are no registers
> involved here.

Ah!

In that case, yes, unsigned long. Maybe reword the commit message to
mention the values are being read from struct stmmac_txq_stats and
struct stmmac_rxq_stats which use unsigned long. That would avoid my
confusion of thinking it is being read from a register.

With that change made, you can add my Reviewed-by.

    Andrew
