Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D19A3121EC
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 06:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBGFvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 00:51:06 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:13166 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhBGFvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 00:51:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612677040; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=C57MKdbM9QZYpCQ2ncUjXMoC564wXOYgRhPojZSGn3s=; b=SDUbeVoZZBG6Znk1iDdAtfEolNz4O5140AncKeK4EchtGkJ/oq8yf/bXP4lEd4HCxZfykxfk
 W94sk/i82hbu7Vyb90wJAfQp2TwF06tdOQq5vZtP1/R7w8VoWLMWsAyB0is+v8QdF4bZMaUB
 LXdsYwY1IEYnlrHJbxCP7qsnAbA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 601f7f93f112b7872c6ba8b6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 07 Feb 2021 05:50:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 03882C43462; Sun,  7 Feb 2021 05:50:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A81A6C433C6;
        Sun,  7 Feb 2021 05:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A81A6C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: pull-request: wireless-drivers-2021-02-05
References: <20210205163434.14D94C433ED@smtp.codeaurora.org>
        <20210206093537.0bfaf0db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210206194325.GA134674@lore-desk>
Date:   Sun, 07 Feb 2021 07:50:06 +0200
In-Reply-To: <20210206194325.GA134674@lore-desk> (Lorenzo Bianconi's message
        of "Sat, 6 Feb 2021 20:43:25 +0100")
Message-ID: <87r1ls5svl.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> On Fri,  5 Feb 2021 16:34:34 +0000 (UTC) Kalle Valo wrote:
>> > Hi,
>> > 
>> > here's a pull request to net tree, more info below. Please let me know if there
>> > are any problems.
>> 
>> Pulled, thanks! One thing to confirm tho..
>> 
>> > ath9k
>> > 
>> > * fix build regression related to LEDS_CLASS
>> > 
>> > mt76
>> > 
>> > * fix a memory leak
>> 
>> Lorenzo, I'm just guessing what this code does, but you're dropping a
>> frag without invalidating the rest of the SKB, which I presume is now
>> truncated? Shouldn't the skb be dropped?
>> 
>
> Hi Jakub,
>
> I agree. We can do something like:
>
> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
> index e81dfaf99bcb..6d84533d1df2 100644
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -511,8 +511,9 @@ mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
>  {
>  	struct sk_buff *skb = q->rx_head;
>  	struct skb_shared_info *shinfo = skb_shinfo(skb);
> +	int nr_frags = shinfo->nr_frags;
>  
> -	if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
> +	if (nr_frags < ARRAY_SIZE(shinfo->frags)) {
>  		struct page *page = virt_to_head_page(data);
>  		int offset = data - page_address(page) + q->buf_offset;
>  
> @@ -526,7 +527,10 @@ mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
>  		return;
>  
>  	q->rx_head = NULL;
> -	dev->drv->rx_skb(dev, q - dev->q_rx, skb);
> +	if (nr_frags < ARRAY_SIZE(shinfo->frags))
> +		dev->drv->rx_skb(dev, q - dev->q_rx, skb);
> +	else
> +		dev_kfree_skb(skb);
>  }
>  
>
> I do not know if it can occur, but I guess we should even check q->rx_head
> pointer before overwriting it because if the hw does not report more set to
> false for last fragment we will get a memory leak as well. Something like:
>
> @@ -578,6 +582,8 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
>  		done++;
>  
>  		if (more) {
> +			if (q->rx_head)
> +				dev_kfree_skb(q->rx_head);
>  			q->rx_head = skb;
>  			continue;
>  		}

So what's the plan? Is there going to be a followup patch? And should
that also go to v5.11 or can it wait v5.12?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
