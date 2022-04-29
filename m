Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6D7514050
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354012AbiD2BoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235461AbiD2BoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:44:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EF55FF14;
        Thu, 28 Apr 2022 18:40:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0D715CE2F98;
        Fri, 29 Apr 2022 01:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7CBC385AC;
        Fri, 29 Apr 2022 01:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651196456;
        bh=Hz6ulH+o/XA3d/ohY6QMo3a7cl6ZEDIejB0K3veZ9gw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hbqr3sYCWquHPPIGT12Ir8IJ8M2rIRjkIx6bydazwbRTF3vsdVxWbwmYa17j93Y1T
         CmPDfLH9/sDfXM56lx64FfPeN3m/SyTtFt+mBdpbqM9RpLRfUKY9JiEPiPJUQgKhe5
         ili1hZR4k4Jg/LhXv3cRQZ+mnkM/L307Xkmuws0+bkoIKJD9JPiuJ5uCmPW0G/LgHs
         xvD8NR0nSQsQf+KwKIfjHsO89fGbTNUkhpu5/B4Qs1xveASSPEqOjG6sd4w+0f7v+S
         40LohYVRzYdxcPUfmec/UFYagUWtr32Qt/8I7TdWHZiGPlgW/XEijZHyWCaXzku6vH
         La9YD2kGDcCWA==
Date:   Thu, 28 Apr 2022 18:40:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianqun Xu <jay.xu@rock-chips.com>
Cc:     davem@davemloft.net, joabreu@synopsys.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH V2] ethernet: stmmac: support driver work for DTs
 without child queue node
Message-ID: <20220428184054.3dd72784@kernel.org>
In-Reply-To: <20220429004605.1010751-1-jay.xu@rock-chips.com>
References: <20220428010927.526310-1-jay.xu@rock-chips.com>
        <20220429004605.1010751-1-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 08:46:05 +0800 Jianqun Xu wrote:
> The driver use the value of property 'snps,rx-queues-to-use' to loop
> same numbers child nodes as queues, such as:
> 
>     gmac {
>         rx-queues-config {
>             snps,rx-queues-to-use = <1>;
>             queue0 {
>                 // nothing need here.
> 	    };
> 	};
>     };

I think you mean tx, not rx, given the code.

>  
>  		queue++;
>  	}
> -	if (queue != plat->tx_queues_to_use) {
> +	if (queue != plat->tx_queues_to_use && of_get_child_count(tx_node)) {
>  		ret = -EINVAL;
>  		dev_err(&pdev->dev, "Not all TX queues were configured\n");
>  		goto out;

Also what about the init to defaults I asked about?
