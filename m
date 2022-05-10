Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436CA520A1E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiEJAbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbiEJAbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:31:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8883632EFA
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED28C614E2
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 00:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E0CC385C5;
        Tue, 10 May 2022 00:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652142431;
        bh=EjSMeepr/JZZwcIxeEB+VTEmMhnj3FQy7x3F5JaTwII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K1M1y7anyGIk1zXpT7rrg8uGGmk5m3/VnLBO7QtEgGJKtRWF4aNjojKmqwwp8C1mq
         1lts8DAvP7hrOvmmsl26nF5kGGKI27327OF7jNKZDBGy8uh6hHGr+5hygSgQqIS6Qv
         yb4aKNtfIWUN3eURPkL04KTM3is2UtTdoQ7Gyy9mjDvOJgzcGFKC0DCqqsJevLrGMJ
         eGTS1A57VYNQG09pzXdk7sBC9EiajmgpRS/tFDizWQyovx+BgD04O1F66AydzHyHnX
         +3YoeYdOZKdYGa1VVHbC8K40U1T3g40ezwgmuLYaZJjaNQAexwsDqAwcaqvTF/DbH3
         5A1L0eMgnm0Fg==
Date:   Mon, 9 May 2022 17:27:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: tag_mtk: add padding for tx packets
Message-ID: <20220509172709.52c8fc8e@kernel.org>
In-Reply-To: <20220506194344.83702-1-nbd@nbd.name>
References: <20220506194344.83702-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 May 2022 21:43:44 +0200 Felix Fietkau wrote:
> From: Felix Fietkau <nbd@nbd.name>
> To: netdev@vger.kernel.org

Please repost and CC DSA maintainers.

> Subject: [PATCH] net: dsa: tag_mtk: add padding for tx packets

[PATCH net]

> Padding for transmitted packets needs to account for the special tag.
> With not enough padding, garbage bytes are inserted by the switch at the
> end of small packets.
> 
> Fixes: 5cd8985a1909 ("net-next: dsa: add Mediatek tag RX/TX handler")

And CC anyone with tags on this commit.

> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/dsa/tag_mtk.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
> index 415d8ece242a..1d1f9dbd9e93 100644
> --- a/net/dsa/tag_mtk.c
> +++ b/net/dsa/tag_mtk.c
> @@ -25,6 +25,14 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>  	u8 xmit_tpid;
>  	u8 *mtk_tag;
>  
> +	/* The Ethernet switch we are interfaced with needs packets to be at
> +	 * least 64 bytes (including FCS) otherwise their padding might be
> +	 * corrupted. With tags enabled, we need to make sure that packets are
> +	 * at least 68 bytes (including FCS and tag).
> +	 */
> +	if (__skb_put_padto(skb, ETH_ZLEN + MTK_HDR_LEN, false))
> +		return NULL;

That doesn't happen for VLANs? Only the mtk tag is special?
