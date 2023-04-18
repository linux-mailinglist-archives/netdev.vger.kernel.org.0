Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9C76E6C4C
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjDRSmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbjDRSmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:42:07 -0400
Received: from mx16lb.world4you.com (mx16lb.world4you.com [81.19.149.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6A19031;
        Tue, 18 Apr 2023 11:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=icQqXp8H6dbIv/Jfy/LwqTJbTa7u53xAx/U7gBNJXnw=; b=t6YsmUnoDKkjQ3Mn3xrcdMUnPS
        8qUnqgv8yFVfltFYJ4P+A6HBiUT9QNthC8tdUs1SuWDTLJl1Ahfy+Ix/6LNTeHBH/80ONw9B6Ly/d
        5h/TRVvLA7TvMmmsJcMdilokEOTlZ1sA9R0Z0UbTqLQEubpGUNTBrhLI0pm8CSDvew1I=;
Received: from [88.117.57.231] (helo=[10.0.0.160])
        by mx16lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1poqH9-0004VC-Fm; Tue, 18 Apr 2023 20:41:59 +0200
Message-ID: <6661221c-2dc8-0501-3f59-8c59f3ad2d49@engleder-embedded.com>
Date:   Tue, 18 Apr 2023 20:41:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 5/6] tsnep: Add XDP socket zero-copy RX
 support
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com
References: <20230415144256.27884-1-gerhard@engleder-embedded.com>
 <20230415144256.27884-6-gerhard@engleder-embedded.com>
 <d872b08538aface37cb21eecb8a793a7063c4c49.camel@redhat.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <d872b08538aface37cb21eecb8a793a7063c4c49.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.04.23 10:22, Paolo Abeni wrote:
> On Sat, 2023-04-15 at 16:42 +0200, Gerhard Engleder wrote:
>> @@ -892,6 +900,37 @@ static int tsnep_rx_desc_available(struct tsnep_rx *rx)
>>   		return rx->read - rx->write - 1;
>>   }
>>   
>> +static void tsnep_rx_free_page_buffer(struct tsnep_rx *rx)
>> +{
>> +	struct page **page;
>> +
>> +	page = rx->page_buffer;
>> +	while (*page) {
>> +		page_pool_put_full_page(rx->page_pool, *page, false);
>> +		*page = NULL;
>> +		page++;
>> +	}
>> +}
> 
> [...]
> 
>>   static void tsnep_rx_close(struct tsnep_rx *rx)
>>   {
>> +	if (rx->xsk_pool)
>> +		tsnep_rx_free_page_buffer(rx);
> 
> It looks like the above could call tsnep_rx_free_page_buffer() with
> each page ptr in rx->page_buffer not zero. If so
> tsnep_rx_free_page_buffer() will do an out of bound access.

rx->page_buffer has space for up to TSNEP_RING_SIZE ptr's. The
descriptor ring is filled with at most TSNEP_RING_SIZE - 1
pages. Thus, the last ptr in rx->page_buffer is always zero.

> Also, why testing rx->xsk_pool instead of rx->page_buffer?

Testing for rx->xsk_pool is done for all code, which is only needed
if XSK zero-copy is enabled. For me this is more consistent to the
rest of the code.

Thanks!

Gerhard
