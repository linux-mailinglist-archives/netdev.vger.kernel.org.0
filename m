Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3304F6BF7F7
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCRFV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCRFVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:21:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF35A7B3A7;
        Fri, 17 Mar 2023 22:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C856EB826CD;
        Sat, 18 Mar 2023 05:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40A0C433D2;
        Sat, 18 Mar 2023 05:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679116879;
        bh=ArRYF4BA+E7Tyz1BYurYG5giIOqMsCRLQshVwP1KzDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=obBbpX0QIRFajzPFiKavuEO5zhPk40CAT4gY88WL4IyupBpK4gsuXPsZMaOCT4TPE
         e6S6+n51fuWf0HzlpYrOptXdxgZU6Sq/FcblaBiR+vnlRENDjnoNVEMaL0vjMCrU9A
         z9qQq5vJXSs6vXxe3l5LRjlCOMKqC+ebv3TF4wI1Dx2KrpuYqZFBR0dQAoW2DlcbXc
         wywhFKzC0ovE1BTfFhIivZ8QGbDdRPTar6nBnSRwRXRq0ei8DHYBkHZ+DH+530CrLO
         DTjHkC8Ompu8DRdROTMy9QSCQB9FnZ8mMXfgaxmvNrvU2yYEBQvKQSXWJVe/r5gejk
         m2qqC7WlF+MTw==
Date:   Fri, 17 Mar 2023 22:21:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2 1/2] net: stmmac: Premature loop termination
 check was ignored on rx
Message-ID: <20230317222117.3520d4cf@kernel.org>
In-Reply-To: <20230316075940.695583-2-jh@henneberg-systemdesign.com>
References: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
        <20230316075940.695583-2-jh@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 08:59:39 +0100 Jochen Henneberg wrote:
> The premature loop termination check makes sense only in case of the
> jump to read_again where the count may have been updated. But
> read_again did not include the check.
> 
> Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index e4902a7bb61e..ea51c7c93101 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>  			len = 0;
>  		}
>  
> +read_again:
>  		if (count >= limit)
>  			break;

Are you sure? Can you provide more detailed analysis?
Do you observe a problem / error in real life or is this theoretical?

As far as I can tell only path which jumps to read_again after doing
count++ is via the drain_data jump, but I can't tell how it's
discarding subsequent segments in that case..

> -read_again:
>  		buf1_len = 0;
>  		buf2_len = 0;
>  		entry = next_entry;

