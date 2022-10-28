Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A355610E0A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiJ1KB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJ1KBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:01:20 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F3B52804;
        Fri, 28 Oct 2022 03:01:13 -0700 (PDT)
Received: from [141.14.13.43] (g298.RadioFreeInternet.molgen.mpg.de [141.14.13.43])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 870D161EA192A;
        Fri, 28 Oct 2022 12:01:10 +0200 (CEST)
Message-ID: <1bd57adb-49f1-3b90-541c-8d3d10963ccb@molgen.mpg.de>
Date:   Fri, 28 Oct 2022 12:01:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Fix TX dispatch condition
Content-Language: en-US
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yan Vugenfirer <yan@daynix.com>,
        intel-wired-lan@lists.osuosl.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20221013050044.11862-1-akihiko.odaki@daynix.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221013050044.11862-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Akihiko,


Thank you very much for the patch.

Am 13.10.22 um 07:00 schrieb Akihiko Odaki:
> e1000_xmit_frame is expected to stop the queue and dispatch frames to
> hardware if there is not sufficient space for the next frame in the
> buffer, but sometimes it failed to do so because the estimated maxmium
> size of frame was wrong. As the consequence, the later invocation of
> e1000_xmit_frame failed with NETDEV_TX_BUSY, and the frame in the buffer
> remained forever, resulting in a watchdog failure.
> 
> This change fixes the estimated size by making it match with the
> condition for NETDEV_TX_BUSY. Apparently, the old estimation failed to
> account for the following lines which determines the space requirement
> for not causing NETDEV_TX_BUSY:
>> 	/* reserve a descriptor for the offload context */
>> 	if ((mss) || (skb->ip_summed == CHECKSUM_PARTIAL))
>> 		count++;
>> 	count++;
>>
>> 	count += DIV_ROUND_UP(len, adapter->tx_fifo_limit);

I’d just use Markdown syntax, and indent by four spaces without > for 
citation.

> This issue was found with http-stress02 test included in Linux Test
> Project 20220930.

So it was reproduced in QEMU? For convenience, it’d be great if you 
added the QEMU command.

Also, do you know if this is a regression? If so, it’d be great if you 
added the Fixes: tag.


Kind regards,

Paul


> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 321f2a95ae3a..da113f5011e9 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -5936,9 +5936,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
>   		e1000_tx_queue(tx_ring, tx_flags, count);
>   		/* Make sure there is space in the ring for the next send. */
>   		e1000_maybe_stop_tx(tx_ring,
> -				    (MAX_SKB_FRAGS *
> +				    ((MAX_SKB_FRAGS + 1) *
>   				     DIV_ROUND_UP(PAGE_SIZE,
> -						  adapter->tx_fifo_limit) + 2));
> +						  adapter->tx_fifo_limit) + 4));
>   
>   		if (!netdev_xmit_more() ||
>   		    netif_xmit_stopped(netdev_get_tx_queue(netdev, 0))) {
