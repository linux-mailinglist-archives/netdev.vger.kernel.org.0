Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F163F3EE848
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 10:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239084AbhHQISj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 04:18:39 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.166.231]:58650 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234706AbhHQISf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 04:18:35 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id C118024ACB;
        Tue, 17 Aug 2021 01:18:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com C118024ACB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1629188280;
        bh=0xZ8pgGrQDUx2DKXZLbQE9+YSyK5bQFM0TkSsIlD0I4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=f4zQFyzMewT4vwNRW1hNJJ+2dqx6vcMqr6+7/BKKOGLH/SDTsH7i0xGSTi3amDLmo
         WozdnPtPpuRcmhyarV30t9Fpfn9yjxE7jJzp///i/+V3ck6GWhYUkLDb/N9Nw9Xyo7
         dbj6OQnablN+MvKXJCTH60BxqKLkq7waH1np6m5Y=
Received: from [10.230.40.140] (unknown [10.230.40.140])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id B3B5B1874BD;
        Tue, 17 Aug 2021 01:17:57 -0700 (PDT)
Subject: Re: 5.10.58 UBSAN from brcmf_sdio_dpc+0xa50/0x128c [brcmfmac]
To:     Arend van Spriel <aspriel@gmail.com>,
        Ryutaroh Matsumoto <ryutaroh@ict.e.titech.ac.jp>
Cc:     linux-rpi-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>
References: <20210816.084210.1700916388797835755.ryutaroh@ict.e.titech.ac.jp>
 <85b31c5a-eb4a-48a0-ad94-e46db00af016@broadcom.com>
 <20210817.093658.33467107987117119.ryutaroh@ict.e.titech.ac.jp>
 <17b52a1ab20.279b.9696ff82abe5fb6502268bdc3b0467d4@gmail.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <56ea3e65-62f4-2496-edd4-e454126abc66@broadcom.com>
Date:   Tue, 17 Aug 2021 10:17:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <17b52a1ab20.279b.9696ff82abe5fb6502268bdc3b0467d4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+netdev, +Dave

On 8/17/2021 7:42 AM, Arend van Spriel wrote:
> Using different email to avoid disclaimers...
> 
> 
> On August 17, 2021 2:39:56 AM Ryutaroh Matsumoto 
> <ryutaroh@ict.e.titech.ac.jp> wrote:
> 
>> Hi Arend, thank you for paying attention to this.
>>
>>> Line 2016 in skbuff.h is inline function __skb_queue_before() and as
>>> far as I can tell brcmfmac is not using that direct or indirect. Maybe
>>> I am reading the line info incorrectly?
>>
>> I am unsure of it. On the other hand, I have also seen somewhat similar
>> UBSAN from a header file "include/net/flow.h" as reported at
>> https://lore.kernel.org/netdev/20210813.081908.1574714532738245424.ryutaroh@ict.e.titech.ac.jp/ 
>>
>>
>> All UBSANs that I have seen come from *.h compiled with clang...
>>
>>> Would you be able to provide information as to what line
>>> brcmf_sdio_dpc+0xa50 refers to.
>>
>> I'd like to do, but I do not know how to let kernel UBSAN include a 
>> line number,
>> though I know it with user-space applications...
> 
> If you enable CONFIG_DEBUG_INFO in your kernel .config and recompile 
> brcmfmac you can load the module in gdb:
> 
> gdb> add-symbol-file brcmfmac.ko [address]
> gdb> l *brcmf_sdio_dpc+0xa50
> 
> The [address] is not very important so just fill in a nice value. The 
> 'l' command should provide the line number.

Hi Ryutaroh,

Meanwhile I did some digging in the brcmfmac driver and I think I found 
the location in brcmf_sdio_sendfromq() where we do a __skb_queue_tail(). 
So I looked at that and it does following:

static inline void __skb_queue_tail(struct sk_buff_head *list,
				   struct sk_buff *newsk)
{
	__skb_queue_before(list, (struct sk_buff *)list, newsk);
}

Your report seems to be coming from the cast that is done here, which is 
fine as long as sk_buff and sk_buff_head have the same members 'next' 
and 'prev' at the start, which is true today and hopefully forever ;-) I 
am inclined to say this is a false report.

Can you please confirm the stack trace indeed points to 
brcmf_sdio_sendfromq() in your report.

Regards,
Arend
