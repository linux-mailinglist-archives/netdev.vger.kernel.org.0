Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05F9456E82
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhKSLx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbhKSLxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 06:53:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0C2C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 03:50:23 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637322622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W6POUtH0WDjnpAZtH7GQuxf8NJaaCIqaSsDxPmV6kD0=;
        b=lWRkikNjJqFLkzp8GfhLlK48dWK3PnwvmzuzmcLeugYBWXERU++QA5o3aodUozL/UU6Bk5
        q4mkTxizBm3JsAWHrEjZYw1tfoI4YAPLHPyyErTkyh8IdsuuXN1T1P64mJULdpqO3XavSA
        K+TeZ2+0ReY64Z/pIx9AA3HEcK9YO5NOcbTk2V6jgZBAMzqn0uMr6Buw7LnB1Ca+/EwGT+
        rfLh6dxKAKXlgF1Wz1HYQ24X86Wj7e+4dUgqGrV2azvmwfv+1/d/NLG9yt6mJdSUb3J2YH
        +shzf2Ayjz9QloPIYth0xdrawUF/2jWdW7YQaTbZeuS9PzOLg+wTrHD3Kqzxnw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637322622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W6POUtH0WDjnpAZtH7GQuxf8NJaaCIqaSsDxPmV6kD0=;
        b=54dZLbDVlE9rd1vOqGyu5HTixoKcrtmVLROgHRGExJiS69IYlMpPi2uUTD2JrWUP0GuZMX
        glQETqFGnlGETCCQ==
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Benedikt Spranger <b.spranger@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net-next v1] net: stmmac: Caclucate clock domain
 crossing error only once
In-Reply-To: <20211119081010.27084-1-kurt@linutronix.de>
References: <20211119081010.27084-1-kurt@linutronix.de>
Date:   Fri, 19 Nov 2021 12:50:21 +0100
Message-ID: <87mtm0l5z6.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kurt,

On Fri, Nov 19 2021 at 09:10, Kurt Kanzenbach wrote:

> The clock domain crossing error (CDC) is calculated at every fetch of Tx or Rx
> timestamps. It includes a division. Especially on arm32 based systems it is
> expensive. It also saves the two conditionals.

This does not make sense. What you want to say here is:

  It also requires two conditionals in the hotpath.

> Therefore, move the calculation to the PTP initialization code and just use the
> cached value in the timestamp retrieval functions.

Maybe:

  Add a compensation value cache to struct plat_stmmacenet_data and
  subtract it unconditionally in the RX/TX functions which spares the
  conditionals.

  The value is initialized to 0 and if supported calculated in the PTP
  initialization code.

or something to that effect.

> +	/* Calculate the clock domain crossing (CDC) error if necessary */
> +	priv->plat->cdc_error_adj = 0;
> +	if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate)
> +		priv->plat->cdc_error_adj = (2 * NSEC_PER_SEC) /
> +			priv->plat->clk_ptp_rate;

Nit. Just let stick it out. We lifted the 80 char limitation some time ago.

Thanks,

        tglx
