Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC9D23D5A0
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 04:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgHFC5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 22:57:17 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:39270 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgHFC5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 22:57:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596682636; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=H/fMnJVieUL4Dlvn7ai7jzobHw8KyVB1/ebQeG0HImM=; b=e/pM2LpfWGkSXVAP9ixbyDkDm1hkDMae2cuyebZcY9q9SvCACbRE7V3zDzSy2XkGP/ikr4Za
 Iizbt8Rnkx7o0ioQUO+evV8aYa+KZrRBe1OWSgkpdyNj2K24e5nAD0yedhbiU5CGFCFW0NoJ
 lG0nLPhW1VNVjMkDCshsucB+8Tg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n18.prod.us-west-2.postgun.com with SMTP id
 5f2b718b2889723bf899ca83 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 06 Aug 2020 02:57:15
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BF589C433AF; Thu,  6 Aug 2020 02:57:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from Pillair (unknown [49.205.240.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 51009C433CB;
        Thu,  6 Aug 2020 02:57:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 51009C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Christophe JAILLET'" <christophe.jaillet@wanadoo.fr>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
Cc:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20200802122227.678637-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20200802122227.678637-1-christophe.jaillet@wanadoo.fr>
Subject: RE: [PATCH] ath10k: Fix the size used in a 'dma_free_coherent()' call in an error handling path
Date:   Thu, 6 Aug 2020 08:27:07 +0530
Message-ID: <002101d66b9d$497721b0$dc656510$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL6RW6rmvo2uaX7dS3qhQ/yDQwO+Kbir3+A
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, August 2, 2020 5:52 PM
> To: kvalo@codeaurora.org; davem@davemloft.net; kuba@kernel.org;
> pillair@codeaurora.org
> Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
> janitors@vger.kernel.org; Christophe JAILLET
> <christophe.jaillet@wanadoo.fr>
> Subject: [PATCH] ath10k: Fix the size used in a 'dma_free_coherent()' call
in
> an error handling path
> 
> Update the size used in 'dma_free_coherent()' in order to match the one
> used in the corresponding 'dma_alloc_coherent()'.
> 
> Fixes: 1863008369ae ("ath10k: fix shadow register implementation for
> WCN3990")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch looks obvious to me, but commit 1863008369ae looks also simple.
> So it is surprising that such a "typo" slipped in.

Reviewed-by: Rakesh Pillai <pillair@codeaurora.org> 

> ---
>  drivers/net/wireless/ath/ath10k/ce.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/ce.c
> b/drivers/net/wireless/ath/ath10k/ce.c
> index 294fbc1e89ab..e6e0284e4783 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.c
> +++ b/drivers/net/wireless/ath/ath10k/ce.c
> @@ -1555,7 +1555,7 @@ ath10k_ce_alloc_src_ring(struct ath10k *ar,
> unsigned int ce_id,
>  		ret = ath10k_ce_alloc_shadow_base(ar, src_ring, nentries);
>  		if (ret) {
>  			dma_free_coherent(ar->dev,
> -					  (nentries * sizeof(struct
> ce_desc_64) +
> +					  (nentries * sizeof(struct ce_desc)
+
>  					   CE_DESC_RING_ALIGN),
>  					  src_ring-
> >base_addr_owner_space_unaligned,
>  					  base_addr);
> --
> 2.25.1


