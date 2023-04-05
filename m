Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946FC6D86A3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjDETP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDETP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:15:56 -0400
Received: from mx13lb.world4you.com (mx13lb.world4you.com [81.19.149.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB61EC3;
        Wed,  5 Apr 2023 12:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pfAd6rzcvzpbT+CnylS8wnbpgiCqVxB2qmXvCBZxKrA=; b=kC0ZI7HGskNVmGZP/HyHR7SEfl
        NrI6qrsqKqdS+0ozUmJ/DE60aYL9gPWOJLKNuo8mr7s1l7InhGD7H7GgyPioZbl2wuKef9j4vdRKw
        ncK08CQxivutOr120Uc3zmkmXKxpRVRYkyqp0HbjuG0e89PqTiErsLugfhZw+OHu73Ww=;
Received: from [88.117.56.218] (helo=[10.0.0.160])
        by mx13lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pk8bq-0002We-0a; Wed, 05 Apr 2023 21:15:54 +0200
Message-ID: <fa2a8f21-d933-369f-4520-79a840616546@engleder-embedded.com>
Date:   Wed, 5 Apr 2023 21:15:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 5/5] tsnep: Add XDP socket zero-copy TX support
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20230402193838.54474-1-gerhard@engleder-embedded.com>
 <20230402193838.54474-6-gerhard@engleder-embedded.com>
 <ZCtU8WN+NpNXS+N8@boxer>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <ZCtU8WN+NpNXS+N8@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.04.23 00:36, Maciej Fijalkowski wrote:
> On Sun, Apr 02, 2023 at 09:38:38PM +0200, Gerhard Engleder wrote:
>> Send and complete XSK pool frames within TX NAPI context. NAPI context
>> is triggered by ndo_xsk_wakeup.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep.h      |   2 +
>>   drivers/net/ethernet/engleder/tsnep_main.c | 131 +++++++++++++++++++--
>>   2 files changed, 123 insertions(+), 10 deletions(-)
>>
> 
> (...)
> 
>> +static void tsnep_xdp_xmit_zc(struct tsnep_tx *tx)
>> +{
>> +	int desc_available = tsnep_tx_desc_available(tx);
>> +	struct xdp_desc xdp_desc;
>> +	bool xmit = false;
>> +
>> +	/* ensure that TX ring is not filled up by XDP, always MAX_SKB_FRAGS
>> +	 * will be available for normal TX path and queue is stopped there if
>> +	 * necessary
>> +	 */
>> +	if (desc_available <= (MAX_SKB_FRAGS + 1))
>> +		return;
>> +	desc_available -= MAX_SKB_FRAGS + 1;
>> +
>> +	while (xsk_tx_peek_desc(tx->xsk_pool, &xdp_desc) && desc_available--) {
> 
> Again, I am curious how batch API usage would improve your perf.

I will try xsk_tx_peek_release_desc_batch().

Thank you for the review!

Gerhard
