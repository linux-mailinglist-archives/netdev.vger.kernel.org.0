Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11E1357BC5
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 07:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhDHFVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 01:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhDHFVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 01:21:37 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E52C061760;
        Wed,  7 Apr 2021 22:21:26 -0700 (PDT)
Received: from localhost ([127.0.0.1] helo=bute.mt.lv)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lUN6W-0003fP-72; Thu, 08 Apr 2021 08:21:20 +0300
MIME-Version: 1.0
Date:   Thu, 08 Apr 2021 08:21:20 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] atl1c: move tx cleanup processing out of interrupt
In-Reply-To: <7c5dad3e-950d-8ec9-8b9d-bbce41fafaa4@gmail.com>
References: <c8327d4bb516dd4741878c64fa6485cd@mikrotik.com>
 <7c5dad3e-950d-8ec9-8b9d-bbce41fafaa4@gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <5bd5e1b9c1fdf8c9a43a0d018a005eab@mikrotik.com>
X-Sender: gatis@mikrotik.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-07 19:55, Eric Dumazet wrote:
> On 4/6/21 4:49 PM, Gatis Peisenieks wrote:
>> Tx queue cleanup happens in interrupt handler on same core as rx queue
>> processing. Both can take considerable amount of processing in high
>> packet-per-second scenarios.
>> 
>> Sending big amounts of packets can stall the rx processing which is 
>> unfair
>> and also can lead to out-of-memory condition since __dev_kfree_skb_irq
>> queues the skbs for later kfree in softirq which is not allowed to 
>> happen
>> with heavy load in interrupt handler.
>> 
> 
> [ ... ]
> 
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 0f72ff5d34ba..489ac60b530c 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -6789,6 +6789,7 @@ int dev_set_threaded(struct net_device *dev, 
>> bool threaded)
>> 
>>      return err;
>>  }
>> +EXPORT_SYMBOL(dev_set_threaded);
>> 
>>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>>              int (*poll)(struct napi_struct *, int), int weight)
> 
> This has already been done in net-next
> 
> Please base your patch on top of net-next, this can not be backported 
> to old
> versions anyway, without some amount of pain.

Thank you Eric, for heads up, the v5 patch sent for net-next in response 
to
David Miller comment already does that.
