Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C60CE4DE
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbfJGOO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:14:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfJGOO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 10:14:29 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B623614218221;
        Mon,  7 Oct 2019 07:14:27 -0700 (PDT)
Date:   Mon, 07 Oct 2019 16:14:26 +0200 (CEST)
Message-Id: <20191007.161426.108032588372697075.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: Fix sparse warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b59904022c2f96aca956aa693040faf0dddeb802.1570454078.git.Jose.Abreu@synopsys.com>
References: <b59904022c2f96aca956aa693040faf0dddeb802.1570454078.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 07:14:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon,  7 Oct 2019 15:16:08 +0200

> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 8b76745a7ec4..40b0756f3a14 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -4207,6 +4207,7 @@ static u32 stmmac_vid_crc32_le(__le16 vid_le)
>  static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
>  {
>  	u32 crc, hash = 0;
> +	__le16 pmatch = 0;
>  	int count = 0;
>  	u16 vid = 0;
>  
> @@ -4221,11 +4222,11 @@ static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
>  		if (count > 2) /* VID = 0 always passes filter */
>  			return -EOPNOTSUPP;
>  
> -		vid = cpu_to_le16(vid);
> +		pmatch = cpu_to_le16(vid);
>  		hash = 0;
>  	}
>  
> -	return stmmac_update_vlan_hash(priv, priv->hw, hash, vid, is_double);
> +	return stmmac_update_vlan_hash(priv, priv->hw, hash, pmatch, is_double);
>  }

I dunno about this.

The original code would use the last "vid" iterated over in the
for_each_set_bit() loop if the priv->dma_cap.vlhash test does not
pass.

Now, it will use zero in that case.

This does not look like an equivalent transformation.
