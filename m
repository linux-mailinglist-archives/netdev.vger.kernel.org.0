Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E6C2A6AEB
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbgKDQxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:53:31 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:46469 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731794AbgKDQx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:53:27 -0500
Received: from [10.193.177.175] (chethan-pc.asicdesigners.com [10.193.177.175] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A4GrFU1003415;
        Wed, 4 Nov 2020 08:53:16 -0800
Subject: Re: [net v4 05/10] cxgb4/ch_ktls: creating skbs causes panic
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
References: <20201030180225.11089-1-rohitm@chelsio.com>
 <20201030180225.11089-6-rohitm@chelsio.com>
 <20201103124646.795b96eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <a29b951d-1666-009a-9a4b-efa2ce8fd5ac@chelsio.com>
Date:   Wed, 4 Nov 2020 22:23:14 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20201103124646.795b96eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04/11/20 2:16 AM, Jakub Kicinski wrote:
> On Fri, 30 Oct 2020 23:32:20 +0530 Rohit Maheshwari wrote:
>> Creating SKB per tls record and freeing the original one causes
>> panic. There will be race if connection reset is requested. By
>> freeing original skb, refcnt will be decremented and that means,
>> there is no pending record to send, and so tls_dev_del will be
>> requested in control path while SKB of related connection is in
>> queue.
>>   Better approach is to use same SKB to send one record (partial
>> data) at a time. We still have to create a new SKB when partial
>> last part of a record is requested.
>>   This fix introduces new API cxgb4_write_partial_sgl() to send
>> partial part of skb. Present cxgb4_write_sgl can only provide
>> feasibility to start from an offset which limits to header only
>> and it can write sgls for the whole skb len. But this new API
>> will help in both. It can start from any offset and can end
>> writing in middle of the skb.
> You never replied to my question on v2.
>
> If the problem is that the socket gets freed, why don't you make the
> new skb take a reference on the socket?
>
> 650 LoC is really a rather large fix.
This whole skb alloc and copy record frags was written under the
assumption that there will be zero data copy (no linear skb was
expected) but that isn't correct. Continuing with the same change
requires more checks and will be more complicated. That's why I
made this change. I think using same SKB to send out multiple
records is better than allocating new SKB every time.
