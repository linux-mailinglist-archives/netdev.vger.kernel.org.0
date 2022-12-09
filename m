Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA7A647EE2
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiLIICR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLIICP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:02:15 -0500
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DBE56D6B;
        Fri,  9 Dec 2022 00:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fd1FFtFWRxZZ95dgvyOLsIzaX4/s4B6iSwD4ceFE1xA=; b=nkh48fIdkV4EiNmcsWAfuGuTAT
        AHdUSoWwPxZeTr7dV6u8p08Xt61tEyPyQ3qwnTCAyMiy4jbMNoqhQO9TlSraYJt8jUM9yvHrP7GFB
        6WZJ39riwvFhqbmNBQyjcGckAR4TBZaqAhMQMdjh582uW8bhGvw9dE9OivxSfKPsligg=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p3YKg-0006vs-Od; Fri, 09 Dec 2022 09:02:10 +0100
Message-ID: <082a47a9-74b2-1800-8c91-e38c73abc89f@engleder-embedded.com>
Date:   Fri, 9 Dec 2022 09:02:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 2/6] tsnep: Add XDP TX support
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-3-gerhard@engleder-embedded.com> <Y5KcJ+VliAl0aR0l@x130>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <Y5KcJ+VliAl0aR0l@x130>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.12.22 03:23, Saeed Mahameed wrote:
>> +static int tsnep_xdp_tx_map(struct xdp_frame *xdpf, struct tsnep_tx *tx,
>> +                struct skb_shared_info *shinfo, int count,
>> +                bool dma_map)
>> +{
>> +    struct device *dmadev = tx->adapter->dmadev;
>> +    skb_frag_t *frag;
>> +    unsigned int len;
>> +    struct tsnep_tx_entry *entry;
>> +    void *data;
>> +    struct page *page;
>> +    dma_addr_t dma;
>> +    int map_len = 0;
>> +    int i;
>> +
>> +    frag = NULL;
>> +    len = xdpf->len;
>> +    for (i = 0; i < count; i++) {
>> +        entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
>> +        if (dma_map) {
> 
> wouldn't it have made more sense if you passed TSNEP_TX_TYPE instead of
> bool dma_map ?
> here and in tsnep_xdp_xmit_frame_ring as well..

I will give it a try.

>> +/* This function requires __netif_tx_lock is held by the caller. */
>> +static int tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
>> +                     struct tsnep_tx *tx, bool dma_map)
>> +{
>> +    struct skb_shared_info *shinfo = 
>> xdp_get_shared_info_from_frame(xdpf);
>> +    unsigned long flags;
>> +    int count = 1;
>> +    struct tsnep_tx_entry *entry;
>> +    int length;
>> +    int i;
>> +    int retval;
> 
> Maciiej already commented on this, and i agree with him, the whole series
> needs some work on rev xmas tree variable declaration, code will look much
> neater.

So far I ordered the variable declaration by variable usage with common
variables like i and retval at the end. I will take a look an that.

>> +
>> +    if (unlikely(xdp_frame_has_frags(xdpf)))
>> +        count += shinfo->nr_frags;
>> +
>> +    spin_lock_irqsave(&tx->lock, flags);
>> +
>> +    if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1 + count)) {
>> +        /* prevent full TX ring due to XDP */
>> +        spin_unlock_irqrestore(&tx->lock, flags);
>> +
>> +        return -EBUSY;
> 
> You don't really do anything with the retval, so just return a boolean.

Will be changed.

>> +    }
>> +
>> +    entry = &tx->entry[tx->write];
>> +    entry->xdpf = xdpf;
>> +
>> +    retval = tsnep_xdp_tx_map(xdpf, tx, shinfo, count, dma_map);
>> +    if (retval < 0) {
>> +        tsnep_tx_unmap(tx, tx->write, count);
>> +        entry->xdpf = NULL;
>> +
>> +        tx->dropped++;
>> +
>> +        spin_unlock_irqrestore(&tx->lock, flags);
>> +
>> +        netdev_err(tx->adapter->netdev, "XDP TX DMA map failed\n");
> 
> please avoid printing in data path, find other means to expose such info.
> stats
> tracepoints
> debug_message rate limited, etc ..

I will improve that.


Gerhard
