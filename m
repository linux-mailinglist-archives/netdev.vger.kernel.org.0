Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5BD165940
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 09:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgBTIdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 03:33:02 -0500
Received: from first.geanix.com ([116.203.34.67]:43076 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbgBTIdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 03:33:02 -0500
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 6FDECABE2F;
        Thu, 20 Feb 2020 08:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582187579; bh=7fJH91fFHjiUXtmwG2jBMWpcDq/boOo9eUL36++h+i8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To;
        b=DfB4M8VqU8kTqcfghs5TeBFdORfpRU2MDPkS4nqrSVC+bK9H/MDeqQCulS33Xia+7
         MOWvLr3lrd1qYlx9j0HYK23jj3Amgql5uoTKeXJmtgFPScxp8ESrVrPWG2dCo6BPmF
         5r9SYM2A2lp58eeDqi9klcaLempfjO2NA34g6wcn6KZxPCZ9Llis8ycRNmfFxNctPj
         VMKf8Nmm5ZaKCcBGOel6f+ZoIUXrEFpS+NwJl4XOFh1jHtnF7X8lPzZssLPPVUVeAG
         CRJdqmHokbuMIaT8EBYFQ+Ov+jAHFg9SuOQPWzoFR/JN25DmNE0o1lzlEP0gAfEQFK
         7Ty11hZcZZxiA==
From:   Esben Haabendal <esben@geanix.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        michal.simek@xilinx.com, ynezz@true.cz
Subject: Re: [PATCH net 2/4] net: ll_temac: Add more error handling of dma_map_single() calls
References: <cover.1582108989.git.esben@geanix.com>
        <65907810dd82de3fcaad9869f328ab32800c67ea.1582108989.git.esben@geanix.com>
        <20200219.105954.1568022053134111448.davem@davemloft.net>
Date:   Thu, 20 Feb 2020 09:32:58 +0100
In-Reply-To: <20200219.105954.1568022053134111448.davem@davemloft.net> (David
        Miller's message of "Wed, 19 Feb 2020 10:59:54 -0800 (PST)")
Message-ID: <87v9o18xqd.fsf@geanix.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=4.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 05ff821c8cf1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Esben Haabendal <esben@geanix.com>
> Date: Wed, 19 Feb 2020 11:54:00 +0100
>
>> @@ -863,12 +865,13 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>>  	skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
>>  				      skb_headlen(skb), DMA_TO_DEVICE);
>>  	cur_p->len = cpu_to_be32(skb_headlen(skb));
>> +	if (WARN_ON_ONCE(dma_mapping_error(ndev->dev.parent, skb_dma_addr)))
>> +		return NETDEV_TX_BUSY;
>
> The appropriate behavior in this situation is to drop the packet and return
> NETDEV_TX_OK.

Ok, and I guess the same goes for the error handling of dma_map_single()
of one of the fragments later in same function.

/Esben
