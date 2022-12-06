Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE869643AEC
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 02:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiLFBor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 20:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiLFBoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 20:44:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF321262F
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 17:44:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAAE1B81601
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03559C433D6;
        Tue,  6 Dec 2022 01:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670291083;
        bh=SM22d4N/E+zIdAac9YNQCnzKGtuEJmhYYckf1i4nf1Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JqKCAuF5EOLgZagLic2ogHMa7Z48kXYx5KWxnGSoj1FWnI4F0+IYOuegRuoHdDUPz
         XHxY9SRhnLgT4AxitiKOQg4UyDwapgIrEVtinIlflY/DgTUh09LbwpzSJUUMavAT6j
         uN+ESMJeth4wdX0xxhmcxkMw+r8xuCn/r5zZaXDnm9YOS/9ef425vNOdUSl59q44QS
         SjQgHO9C9HacP/yClknFF3twdU7xd9ZCcheWkkwjTBzSlziKeP1xY3JWRT+fAYT6i2
         RkvL4lCjrm2QzyyVJsMn5kbqL703Hl+56tss3MZFQzm60kXRYAP0VQFlGXfK2sNCdP
         atJjfLZafjATg==
Date:   Mon, 5 Dec 2022 17:44:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: fix possible deadlock
 if mtk_wed_wo_init fails
Message-ID: <20221205174441.30741550@kernel.org>
In-Reply-To: <Y420B4/IpwFHJAck@lore-desk>
References: <a87f05e60ea1a94b571c9c87b69cc5b0e94943f2.1669999089.git.lorenzo@kernel.org>
        <Y4ybbkn+nXkGsqWe@unreal>
        <Y4y4If8XXu+wErIj@lore-desk>
        <Y42d2us5Pv1UqhEj@unreal>
        <Y420B4/IpwFHJAck@lore-desk>
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

On Mon, 5 Dec 2022 10:04:07 +0100 Lorenzo Bianconi wrote:
> > IMHO, it is a culprit, proper error unwind means that you won't call to
> > uninit functions for something that is not initialized yet. It is better
> > to fix it instead of adding "if (!wo) ..." checks.  
> 
> So, iiuc, you would prefer to do something like:
> 
> __mtk_wed_detach()
> {
> 	...
> 	if (mtk_wed_get_rx_capa(dev) && wo) {
> 		mtk_wed_wo_reset(dev);
> 		mtk_wed_free_rx_rings(dev);
> 		mtk_wed_wo_deinit(hw);
> 	}
> 	...
> 	
> Right? I am fine both ways :)

FWIW, that does seem slightly better to me as well.
Also - aren't you really fixing multiple issues here 
(even if on the same error path)? The locking, 
the null-checking and the change in mtk_wed_wo_reset()?
