Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497B546E074
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237906AbhLIBzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbhLIBzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:55:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020F3C061746;
        Wed,  8 Dec 2021 17:51:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74FD8B8236F;
        Thu,  9 Dec 2021 01:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75921C00446;
        Thu,  9 Dec 2021 01:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639014704;
        bh=5T0ucDpr39HCf8PypsCLt5HtRmXScmsEPR83rW4e950=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RYzHYbDzTs3jYNk+W5eTmiXbOhiozCA41/Erv8HRyDqrnhFPKC9OEd4iZWnpYJUNO
         pS5lFHtiuHzaxlMwk/1CQfsb6etPcxjqmpqZWs1VXWXxSFncbYzNqaMAiTj+oyVo2k
         i/Ou7QVxMlbBC7bhxogc21fbJr/e8QJcuoS30iz/+wD0XbJwo9LL6EnGVtd2p0GEzj
         6hLKL27k+MshR0bsUZjU8orNwQ3rmfrqqw4DFSSBW+Ies3IKq4aIW5qBPf+kVKiGTW
         W2Jj5UjhNGScILNtxukzyKWA0mBs4OUvTPkNzYK+nTD5R8Sg8yaCnEJcGccy1ECuC9
         j+uHFjmarYwHA==
Date:   Wed, 8 Dec 2021 17:51:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Subject: Re: [PATCH net-next v7 5/6] stmmac: dwmac-mediatek: add support for
 mt8195
Message-ID: <20211208175142.1b63afea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <39aa23e1a48bc36a631b3074af2abfd5d1e2256d.camel@mediatek.com>
References: <20211208054716.603-1-biao.huang@mediatek.com>
        <20211208054716.603-6-biao.huang@mediatek.com>
        <20211208063820.264df62d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <39aa23e1a48bc36a631b3074af2abfd5d1e2256d.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Dec 2021 09:48:25 +0800 Biao Huang wrote:
> Sorry for some typo in previous reply, fix it here.
> 
> All these warning lines share a similar semantics:
> delay_val |= FIELD_PREP(xxx, !!val);
> 
> and, should come from the expansion of FIELD_PREP in
> include/linux/bitfiled.h:
> 
>   FIELD _PREP --> __BF_FILED_CHECK --> "~((_mask) >> __bf_shf(_mask)) &
> (_val) : 0,"
> 
> ===============================================================
> __BF_FILED_CHECK {
> ...
>   BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?           \
>                    ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
>                    _pfx "value too large for the field"); \ ...
> ===============================================================
> 
> Should I fix it by converting
>   delay_val |= FIELD_PREP(ETH_DLY_TXC_ENABLE, !!mac_delay->tx_delay);
> to
>   en_val = !!mac_delay->tx_delay;
>   delay_val |= FIELD_PREP(ETH_DLY_TXC_ENABLE, en_val);
> 
> or other suggestions for these warnings?

I see, thanks for explaining. The code is fine, we can simply ignore
this warning IMHO.
