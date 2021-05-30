Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38F439502E
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 11:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhE3JCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 05:02:46 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:51596 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhE3JCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 05:02:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622365266; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=m6gbfF2M8WEGMtZm9Ch5HQfluH/QE2I8j/C41+TlWbM=; b=ZIythUawtpBDSbsYQx+SIFGdGymdXK+1WI6b9N/o4N4h/LSIhfamIYulW/t/eUQf1H94lt6w
 OmWo8G9oxIpc8j0C8uD6c5a2GEYTPg4l5D0o85r6j5BaznQn96xolaOqqMAfcTcuuH3ZU5Vv
 MSDEIAQQ/Z8dTVTvV5m5bMw+pGs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60b3544b51f29e6bae4b4ea4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 30 May 2021 09:00:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 600C2C433F1; Sun, 30 May 2021 09:00:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7DB0FC433D3;
        Sun, 30 May 2021 09:00:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7DB0FC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        fw@strlen.de
Subject: Re: [PATCH v2] ath9k: ath9k_htc_rx_msg: return when sk_buff is too small
References: <20210502212611.1818-1-phil@philpotter.co.uk>
Date:   Sun, 30 May 2021 12:00:53 +0300
In-Reply-To: <20210502212611.1818-1-phil@philpotter.co.uk> (Phillip Potter's
        message of "Sun, 2 May 2021 22:26:11 +0100")
Message-ID: <87fsy4ppdm.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phillip Potter <phil@philpotter.co.uk> writes:

> At the start of ath9k_htc_rx_msg, we check to see if the skb pointer is
> valid, but what we don't do is check if it is large enough to contain a
> valid struct htc_frame_hdr. We should check for this and return if not,
> as the buffer is invalid in this case. Fixes a KMSAN-found uninit-value bug
> reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=7dccb7d9ad4251df1c49f370607a49e1f09644ee
>
> Reported-by: syzbot+e4534e8c1c382508312c@syzkaller.appspotmail.com
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---
>
> V2:
> * Free skb properly when this problem is detected, as pointed out by
>   Florian Westphal.
>
> ---
>  drivers/net/wireless/ath/ath9k/htc_hst.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
> index 510e61e97dbc..1fe89b068ac4 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -406,6 +406,11 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
>  	if (!htc_handle || !skb)
>  		return;
>  
> +	if (!pskb_may_pull(skb, sizeof(struct htc_frame_hdr))) {
> +		kfree_skb(skb);
> +		return;
> +	}

This does not look complete to me, I think the function is missing
proper length checks. For example, with ENDPOINT0 it reads two byte
msg_id after the htc header and it's not verified that skb really has
that. I did not check if ep_callbacks.rx handlers have proper length
handling, I recommend verifying that also while fixing this.

Also I want to point out that the skb is freed differently based on
endpoint, I did not check why and don't know if it causes:

	if (epid < 0 || epid >= ENDPOINT_MAX) {
		if (pipe_id != USB_REG_IN_PIPE)
			dev_kfree_skb_any(skb);
		else
			kfree_skb(skb);
		return;
	}

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
