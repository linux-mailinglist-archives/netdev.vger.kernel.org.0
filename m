Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1253D66AC06
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 16:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjANPKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 10:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjANPKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 10:10:23 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0099483F7
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 07:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Pd8XWrHTZcbCfMNT/i6MsIqkST/pHeVYMBqNhxl9+HQ=; b=abfWvaRkyX29jyqlxgt7D5br+r
        K++KY3ANInELjwiXuYm1SpSgerBoWBhmktvnKTHiXftGi3RWuBtPp+TIBIzH5LJeBt2qTCXMWbPKR
        fqhYbHW9wJ9Dt7Ct0M+OOprtWX2kKbuvw8yVBsJV1IyGRdKi13dfb1tVndE7scukp+8w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pGiAU-0025FR-1m; Sat, 14 Jan 2023 16:10:02 +0100
Date:   Sat, 14 Jan 2023 16:10:02 +0100
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
Message-ID: <Y8LFyqcpi6RjcjMo@lunn.ch>
References: <20230114120437.383514-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114120437.383514-1-kurt@linutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 14, 2023 at 01:04:37PM +0100, Kurt Kanzenbach wrote:
> Correct queue statistics reading. All queue statistics are stored as unsigned
> long values. The retrieval for ethtool fetches these values as u64. However, on
> some systems the size of the counters are 32 bit.

> @@ -551,16 +551,16 @@ static void stmmac_get_per_qstats(struct stmmac_priv *priv, u64 *data)
>  		p = (char *)priv + offsetof(struct stmmac_priv,
>  					    xstats.txq_stats[q].tx_pkt_n);
>  		for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
> -			*data++ = (*(u64 *)p);
> -			p += sizeof(u64 *);
> +			*data++ = (*(unsigned long *)p);
> +			p += sizeof(unsigned long);

As you said in the comment, the register is 32 bits. So maybe u32
would be better than unsigned long? And it would also avoid issues if
this code is every used on a 64 bit machine.

     Andrew
