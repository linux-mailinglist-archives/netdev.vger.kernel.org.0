Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D413C9F2B0
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbfH0SwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:52:07 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35271 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730475AbfH0SwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:52:06 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so2524plb.2
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 11:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=9f7OW9psaHYpoha3rwueLFeklcUR/fkrCK2sl4WYQXA=;
        b=eDCnRrIghGC4NtC2plzVBRwqYIQL32b4SlJLNmiGl8LMwP4GVwVfhSDspV4Xrvy6cM
         N6ASCoZJVFub+0OA+iEaj835IRvL2tNbG1bbuC96RGJ8UTjsY4pnftu0QmkYMnRYk9hj
         Lk0r8qlCv6F2A7INkkwEJchU/nWmP63Gpv59aF0ft7KWpO67CczvAdKGFtpbIRTrh+1A
         v9vrJLcEFtSGB2Z3yCPFKtR4j1EQGPBxtC2SD4IpYbE4B0cuZMienG9CF83oKp2onUeH
         R7oOYyKUaE8+l33n5HPAketRW8ne7mqaR7Iu0gvFHLi1fpiB5ZtrXEh9QsXFukc1EkU8
         M8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9f7OW9psaHYpoha3rwueLFeklcUR/fkrCK2sl4WYQXA=;
        b=A/I91u1qWowydlLLqdK19yMnRWoZOA4xzdrbBxIUyMX8h7RDQZ7/y6YTn+088jbM0Q
         40b9ym9l06zPR6YRO3s8dW73OatE0sr6KfD0Mtl1c4t+A1UBJOdi4E31weEkSLcoGd+K
         b0AuJlPddaIj6cC8yJkDf/Jc9dacsvyyPFIcW0ZDnGvfa2j+ivTPEja4S+4Skv1DR3FE
         Hv+P9DrFQ0eYTxyY5sVJ8yhrs/cywTw/nsf69mmGcYHStloqWuAxm4p9MqfCgyECa/YM
         6gnz5b7b6xyVhRRNygKwItcAMs7uPI9CWiNvh7viImpi8sI/93ImFMaaD5HHX+WMEF7X
         bN7w==
X-Gm-Message-State: APjAAAW05K4Y32Nv5kZbGhYrwmWcJ6sDZAcDn6ooEyHy82wO8H2li3vg
        VF4ZMO/wOkStLn8aR4MLNVyy+wprGrw=
X-Google-Smtp-Source: APXvYqy6rzduh30eMgmau/csYoL0/D8c/nFN7glcJfNflCmNxl97EJSGkRix9IpgJf7Tl3aJo585cA==
X-Received: by 2002:a17:902:6b4c:: with SMTP id g12mr356836plt.118.1566931926121;
        Tue, 27 Aug 2019 11:52:06 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id w20sm28152pfn.72.2019.08.27.11.52.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 11:52:05 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 14/18] ionic: Add Tx and Rx handling
To:     Yunsheng Lin <linyunsheng@huawei.com>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20190826213339.56909-1-snelson@pensando.io>
 <20190826213339.56909-15-snelson@pensando.io>
 <664bbe2c-0e28-6e4a-a44e-c498259be842@huawei.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <c34c828d-c511-079f-ffcc-bf6c6bb9a5d7@pensando.io>
Date:   Tue, 27 Aug 2019 11:52:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <664bbe2c-0e28-6e4a-a44e-c498259be842@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 7:32 PM, Yunsheng Lin wrote:
> On 2019/8/27 5:33, Shannon Nelson wrote:
>> Add both the Tx and Rx queue setup and handling.  The related
>> stats display comes later.  Instead of using the generic napi
>> routines used by the slow-path commands, the Tx and Rx paths
>> are simplified and inlined in one file in order to get better
>> compiler optimizations.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
[...]
>> +static int ionic_txrx_init(struct ionic_lif *lif)
>> +{
>> +	unsigned int i;
>> +	int err;
>> +
>> +	for (i = 0; i < lif->nxqs; i++) {
>> +		err = ionic_lif_txq_init(lif, lif->txqcqs[i].qcq);
>> +		if (err)
>> +			goto err_out;
>> +
>> +		err = ionic_lif_rxq_init(lif, lif->rxqcqs[i].qcq);
>> +		if (err) {
>> +			ionic_lif_qcq_deinit(lif, lif->txqcqs[i-1].qcq);
>> +			goto err_out;
>> +		}
>> +	}
>> +
>> +	ionic_set_rx_mode(lif->netdev);
>> +
>> +	return 0;
>> +
>> +err_out:
>> +	for (i--; i > 0; i--) {
>> +		ionic_lif_qcq_deinit(lif, lif->txqcqs[i-1].qcq);
>> +		ionic_lif_qcq_deinit(lif, lif->rxqcqs[i-1].qcq);
>> +	}
> The "i--" has been done in for initialization, and
> ionic_lif_qcq_deinit is called with lif->rxqcqs[i-1], which may
> cause the last lif->txqcqs or lif->rxqcqs not initialized problem.
>
> It may be more common to do the below:
> while (i--) {
> 	ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
> 	ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
> }

Sure.

>> +
>> +	return err;
>> +}
>> +
>> +static int ionic_txrx_enable(struct ionic_lif *lif)
>> +{
>> +	int i, err;
>> +
>> +	for (i = 0; i < lif->nxqs; i++) {
>> +		err = ionic_qcq_enable(lif->txqcqs[i].qcq);
>> +		if (err)
>> +			goto err_out;
>> +
>> +		ionic_rx_fill(&lif->rxqcqs[i].qcq->q);
>> +		err = ionic_qcq_enable(lif->rxqcqs[i].qcq);
>> +		if (err) {
>> +			ionic_qcq_disable(lif->txqcqs[i].qcq);
>> +			goto err_out;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +
>> +err_out:
>> +	for (i--; i >= 0 ; i--) {
>> +		ionic_qcq_disable(lif->rxqcqs[i].qcq);
>> +		ionic_qcq_disable(lif->txqcqs[i].qcq);
>> +	}
> It may be better to use the above pattern too.

Okay


>> +static dma_addr_t ionic_tx_map_single(struct ionic_queue *q, void *data, size_t len)
>> +{
>> +	struct ionic_tx_stats *stats = q_to_tx_stats(q);
>> +	struct device *dev = q->lif->ionic->dev;
>> +	dma_addr_t dma_addr;
>> +
>> +	dma_addr = dma_map_single(dev, data, len, DMA_TO_DEVICE);
>> +	if (dma_mapping_error(dev, dma_addr)) {
>> +		net_warn_ratelimited("%s: DMA single map failed on %s!\n",
>> +				     q->lif->netdev->name, q->name);
>> +		stats->dma_map_err++;
>> +		return 0;
> zero may be a valid dma address, maybe check the dma_mapping_error in
> ionic_tx_tso instead.

Hmmm, hadn't thought of 0 as a valid address...
I'll need to make a similar adjustment to ionic_tx_map_frag() uses.

>
>
> +
> +static void ionic_tx_tcp_inner_pseudo_csum(struct sk_buff *skb)
> +{
> +	skb_cow_head(skb, 0);
> May need to check for return error of skb_cow_head.

Sure, and in both places.

Thanks,
sln


