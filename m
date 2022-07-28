Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094C658372F
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 04:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiG1CvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 22:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbiG1CvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 22:51:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8655072A
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 19:51:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E988061961
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 02:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE03C433C1;
        Thu, 28 Jul 2022 02:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658976667;
        bh=841ZhDSXz+kiQxrPbP8gtmlQU0L762nWHfS1y4eMdYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yald9G+OLhoa4hOuGZG+B6KvzBrFRLTquez/KJp5oW7JuQUUkEQzuTEIeaB3XdPpX
         8njjisZgNe1ovpqFm+s1kA+URB6dqz0aQEu4ZJhFJuEn1u9KOhOuGO2P46iqwrSJP+
         Y6y+UPpdA2vUIcMs4NWiaz4Rl61PimjLjFM/By8xV+liJBLonLYrUqEbC+gJD4fM3t
         wl8jcy+o28hZE9NAnElkJE0WYjHVn5jpunWhKvV3eSds+hskpGl+8xpESiwxrelcwe
         uwZAhI+7xQ/v5pPJieNB67IkHU7YErMzsQnPLMKMm0j4jRbpBJUXV3XE9klyuGVSIq
         UpRvQqA6BMvWg==
Date:   Wed, 27 Jul 2022 19:51:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <sgoutham@marvell.com>, <netdev@vger.kernel.org>,
        Suman Ghosh <sumang@marvell.com>
Subject: Re: [net v2 PATCH 3/5] octeontx2-af: Allow mkex profiles without
 dmac.
Message-ID: <20220727195106.44100254@kernel.org>
In-Reply-To: <1658844682-12913-4-git-send-email-sbhatta@marvell.com>
References: <1658844682-12913-1-git-send-email-sbhatta@marvell.com>
        <1658844682-12913-4-git-send-email-sbhatta@marvell.com>
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

On Tue, 26 Jul 2022 19:41:20 +0530 Subbaraya Sundeep wrote:
> From: Suman Ghosh <sumang@marvell.com>
> 
> It is possible to have custom mkex profiles which do not extract
> DMAC into the key to free up space in the key and use it for L3
> or L4 packet fields. Current code bails out if DMAC extraction is
> not present in the key. This patch fixes it by allowing profiles
> without DMAC and also supports installing rules based on L2MB bit
> set by hardware for multicast and broadcast packets.

This sounds half way between a feature and a fix. Can you make it
clearer why it's a fix and not an optimization?

> This patch also adds debugging prints needed to identify profiles
> with wrong configuration.

All those prints make the patch even less acceptable as a fix.
We merge fixes into net-next every week, you can send a minimal
fix and extend the code in net-next soon after that.

> Fixes: 9b179a960a96 ("octeontx2-af: Generate key field bit mask from KEX profile")

> +	/* If DMAC is not extracted in MKEX, rules installed by AF
> +	 * can rely on L2MB bit set by hardware protocol checker for
> +	 * broadcast and multicast addresses.
> +	 */
> +	if (npc_check_field(rvu, blkaddr, NPC_DMAC, req->intf))
> +		goto process_flow;

Merge this condition with the condition below, goto should be avoided
but for error paths.

> +	if (is_pffunc_af(req->hdr.pcifunc) &&
> +	    req->features & BIT_ULL(NPC_DMAC)) {
> +		if (is_unicast_ether_addr(req->packet.dmac)) {
> +			dev_err(rvu->dev,
> +				"%s: mkex profile does not support ucast flow\n",
> +				__func__);
> +			return NPC_FLOW_NOT_SUPPORTED;
> +		}
> +
> +		if (!npc_is_field_present(rvu, NPC_LXMB, req->intf)) {
> +			dev_err(rvu->dev,
> +				"%s: mkex profile does not support bcast/mcast flow",
> +				__func__);
> +			return NPC_FLOW_NOT_SUPPORTED;
> +		}
> +
> +		/* Modify feature to use LXMB instead of DMAC */
> +		req->features &= ~BIT_ULL(NPC_DMAC);
> +		req->features |= BIT_ULL(NPC_LXMB);
> +	}
> +
> +process_flow:
>  	if (from_vf && req->default_rule)
>  		return NPC_FLOW_VF_PERM_DENIED;
>  

