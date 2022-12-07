Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6EE64620E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 21:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiLGUF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 15:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLGUF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 15:05:58 -0500
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FE72F029;
        Wed,  7 Dec 2022 12:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vvKxSWuVNWtg1bhAmV73FFXvBAYUsqgsTq9lPaegTvs=; b=MmZmj/ORvuOJzTxXBoWr7H5kex
        gmUP8qtbXdRIj6WZkS/flJQohpmUypBypHR4NePnVQLBZRLEbrJf0tTQENjLimrOZGMg6hbQVbO0A
        ghF0zmyaV/cOE+dgEiFrABDoWniyMpA/P9xLm2/NU9tdHyzpR1AvnH6m6wLVqnlMetwM=;
Received: from [88.117.56.227] (helo=[10.0.0.160])
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p30fy-0000l9-3h; Wed, 07 Dec 2022 21:05:54 +0100
Message-ID: <80f863b5-2507-358c-207c-46aac197a453@engleder-embedded.com>
Date:   Wed, 7 Dec 2022 21:05:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 2/6] tsnep: Add XDP TX support
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
 <20221203215416.13465-3-gerhard@engleder-embedded.com>
 <db3d16ff19ee4558bf96e585e56661eb626163df.camel@redhat.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <db3d16ff19ee4558bf96e585e56661eb626163df.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.12.22 11:24, Paolo Abeni wrote:
> On Sat, 2022-12-03 at 22:54 +0100, Gerhard Engleder wrote:
> [...]
>> +/* This function requires __netif_tx_lock is held by the caller. */
>> +static int tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
>> +				     struct tsnep_tx *tx, bool dma_map)
>> +{
>> +	struct skb_shared_info *shinfo = xdp_get_shared_info_from_frame(xdpf);
>> +	unsigned long flags;
>> +	int count = 1;
>> +	struct tsnep_tx_entry *entry;
>> +	int length;
>> +	int i;
>> +	int retval;
>> +
>> +	if (unlikely(xdp_frame_has_frags(xdpf)))
>> +		count += shinfo->nr_frags;
>> +
>> +	spin_lock_irqsave(&tx->lock, flags);
> 
> Not strictily related to this patch, but why are you using the _irqsafe
> variant? it looks like all the locak users are either in process or BH
> context.

You are right. I will check that and would post a patch later.

Thank you!

Gerhard
