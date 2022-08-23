Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D6E59EA71
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 20:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiHWRvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiHWRuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:50:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA794F650;
        Tue, 23 Aug 2022 08:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=S7JuWIzJexO0qQd7I43+qNWfasTh4kJF/2AB4acc9Fs=; b=wP982P1lHIUHbrYUcSB8e1/FoR
        Bz6RGKWd06Yer9negTdpGnC+Z50HUs9Bp6xLkpCKAqahk0G+xmsez2LNZU+CMx9dXEL/MVUusaLnZ
        wDfDJi5zg/To/6uK4AFuvaZrENtk7CWxBWB343hVnj4hYBAHia1LPcwLEVia7qsQHYF8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQWAx-00EMdR-Nt; Tue, 23 Aug 2022 17:50:47 +0200
Date:   Tue, 23 Aug 2022 17:50:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeontx2-pf: Add egress PFC support
Message-ID: <YwT3V6A4xrS3jAqf@lunn.ch>
References: <20220823065829.1060339-1-sumang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823065829.1060339-1-sumang@marvell.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
> +int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool txschq_for_pfc)
>  {
>  	struct otx2_hw *hw = &pfvf->hw;
>  	struct nix_txschq_config *req;
> @@ -602,7 +602,13 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
>  	req->lvl = lvl;
>  	req->num_regs = 1;
>  
> -	schq = hw->txschq_list[lvl][0];
> +#ifdef CONFIG_DCB
> +	if (txschq_for_pfc)
> +		schq = pfvf->pfc_schq_list[lvl][prio];
> +	else
> +#endif

Please could you try to remove as many of these #ifdef CONFIG_DCB as
possible. It makes build testing less efficient at finding build
problems. Can you do:

> +	if (IS_ENABLED(CONFIG_DCB) && txschq_for_pfc)
> +		schq = pfvf->pfc_schq_list[lvl][prio];

> +#ifdef CONFIG_DCB
> +int otx2_pfc_txschq_config(struct otx2_nic *pfvf)
> +{
> +	u8 pfc_en, pfc_bit_set;
> +	int prio, lvl, err;
> +
> +	pfc_en = pfvf->pfc_en;
> +	for (prio = 0; prio < NIX_PF_PFC_PRIO_MAX; prio++) {
> +		pfc_bit_set = pfc_en & (1 << prio);
> +

Maybe put all of this into a file of its own, and provide stubs for
when it is not enabled?

     Andrew
