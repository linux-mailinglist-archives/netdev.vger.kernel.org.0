Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E5252EC6F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349623AbiETMmu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 May 2022 08:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349498AbiETMmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 08:42:37 -0400
X-Greylist: delayed 390 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 May 2022 05:42:21 PDT
Received: from unicorn.mansr.com (unicorn.mansr.com [81.2.72.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402B61901A;
        Fri, 20 May 2022 05:42:20 -0700 (PDT)
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:1::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id 6406615361;
        Fri, 20 May 2022 13:35:48 +0100 (BST)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 4D31721A3D6; Fri, 20 May 2022 13:35:48 +0100 (BST)
From:   =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Dan Malek <dan@embeddededge.com>,
        Joakim Tjernlund <joakim.tjernlund@lumentis.se>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fs_enet: sync rx dma buffer before reading
References: <20220519192443.28681-1-mans@mansr.com>
        <03f24864-9d4d-b4f9-354a-f3b271c0ae66@csgroup.eu>
Date:   Fri, 20 May 2022 13:35:48 +0100
In-Reply-To: <03f24864-9d4d-b4f9-354a-f3b271c0ae66@csgroup.eu> (Christophe
        Leroy's message of "Fri, 20 May 2022 05:39:38 +0000")
Message-ID: <yw1xmtfc9yaj.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe Leroy <christophe.leroy@csgroup.eu> writes:

> Le 19/05/2022 à 21:24, Mans Rullgard a écrit :
>> The dma_sync_single_for_cpu() call must precede reading the received
>> data. Fix this.
>
> See original commit 070e1f01827c. It explicitely says that the cache 
> must be invalidate _AFTER_ the copy.
>
> The cache is initialy invalidated by dma_map_single(), so before the 
> copy the cache is already clean.
>
> After the copy, data is in the cache. In order to allow re-use of the 
> skb, it must be put back in the same condition as before, in extenso the 
> cache must be invalidated in order to be in the same situation as after 
> dma_map_single().
>
> So I think your change is wrong.

OK, looking at it more closely, the change is at least unnecessary since
there will be a cache invalidation between each use of the buffer either
way.  Please disregard the patch.  Sorry for the noise.

>> 
>> Fixes: 070e1f01827c ("net: fs_enet: don't unmap DMA when packet len is below copybreak")
>> Signed-off-by: Mans Rullgard <mans@mansr.com>
>> ---
>>   drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
>> index b3dae17e067e..432ce10cbfd0 100644
>> --- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
>> +++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
>> @@ -240,14 +240,14 @@ static int fs_enet_napi(struct napi_struct *napi, int budget)
>>                                  /* +2 to make IP header L1 cache aligned */
>>                                  skbn = netdev_alloc_skb(dev, pkt_len + 2);
>>                                  if (skbn != NULL) {
>> +                                       dma_sync_single_for_cpu(fep->dev,
>> +                                               CBDR_BUFADDR(bdp),
>> +                                               L1_CACHE_ALIGN(pkt_len),
>> +                                               DMA_FROM_DEVICE);
>>                                          skb_reserve(skbn, 2);   /* align IP header */
>>                                          skb_copy_from_linear_data(skb,
>>                                                        skbn->data, pkt_len);
>>                                          swap(skb, skbn);
>> -                                       dma_sync_single_for_cpu(fep->dev,
>> -                                               CBDR_BUFADDR(bdp),
>> -                                               L1_CACHE_ALIGN(pkt_len),
>> -                                               DMA_FROM_DEVICE);
>>                                  }
>>                          } else {
>>                                  skbn = netdev_alloc_skb(dev, ENET_RX_FRSIZE);
>> --
>> 2.35.1
>> 

-- 
Måns Rullgård
