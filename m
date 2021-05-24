Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD6D38E6EF
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 14:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhEXMub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 08:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhEXMua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 08:50:30 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B46C061574;
        Mon, 24 May 2021 05:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YacW6io6DWTOFa5KQGhkhN3I+/IjUtx4Uj8CmQReZwI=; b=gyVucV7tvNZ96Umui+fC1G3iVG
        T1HD449QzwXBQv19h5HvuBolpWc64zRdr0NAFe4zT+6JtFImis9tr+cZpXhun3eIhSckjtdoZXQQv
        14veiKTp2W2YA3JEBVL5EaraxG7ntpSjQW9lRjF1jTeKJsPQ0WhyHAcOgu/fVohLXnnmXhXsYwgQY
        x6yvjNl4OZQiOjk5HDD/uPfV7RYMAolrqf5RqbdqNnDtEDIbBgHAjuq2gg4vCjJ6k+5IDhLqzsVZ+
        dh3KXvbMOq2ZFWtumI6jT53/OZEbmQ0xPG83rd4m0tbOEBcTKiSiu8RLvSU7V4Wuy+m5UEyPadoB/
        M0pIEi2Q==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=[192.168.1.10])
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <cyndis@kapsi.fi>)
        id 1llA0s-00071Q-Kb; Mon, 24 May 2021 15:48:54 +0300
Subject: Re: [BUG] net: stmmac: Panic observed in stmmac_napi_poll_rx()
To:     Jon Hunter <jonathanh@nvidia.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
References: <b0b17697-f23e-8fa5-3757-604a86f3a095@nvidia.com>
 <20210514214927.GC1969@qmqm.qmqm.pl>
 <b9a1eef5-c515-e905-9328-9024c3472e29@nvidia.com>
From:   Mikko Perttunen <cyndis@kapsi.fi>
Message-ID: <9c58567a-f490-2d3e-7262-ade3ddd55785@kapsi.fi>
Date:   Mon, 24 May 2021 15:48:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <b9a1eef5-c515-e905-9328-9024c3472e29@nvidia.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 84.249.134.236
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 1:39 PM, Jon Hunter wrote:
> 
> On 14/05/2021 22:49, Micha³ Miros³aw wrote:
>> On Fri, May 14, 2021 at 03:24:58PM +0100, Jon Hunter wrote:
>>> Hello!
>>>
>>> I have been looking into some random crashes that appear to stem from
>>> the stmmac_napi_poll_rx() function. There are two different panics I
>>> have observed which are ...
>> [...]
>>> The bug being triggered in skbuff.h is the following ...
>>>
>>>   void *skb_pull(struct sk_buff *skb, unsigned int len);
>>>   static inline void *__skb_pull(struct sk_buff *skb, unsigned int len)
>>>   {
>>>           skb->len -= len;
>>>           BUG_ON(skb->len < skb->data_len);
>>>           return skb->data += len;
>>>   }
>>>
>>> Looking into the above panic triggered in skbuff.h, when this occurs
>>> I have noticed that the value of skb->data_len is unusually large ...
>>>
>>>   __skb_pull: len 1500 (14), data_len 4294967274
>> [...]
>>
>> The big value looks suspiciously similar to (unsigned)-EINVAL.
> 
> Yes it does and at first, I thought it was being set to -EINVAL.
> However, from tracing the length variables I can see that this is not
> the case.
> 
>>> I then added some traces to stmmac_napi_poll_rx() and
>>> stmmac_rx_buf2_len() to trace the values of various various variables
>>> and when the problem occurs I see ...
>>>
>>>   stmmac_napi_poll_rx: stmmac_rx: count 0, len 1518, buf1 66, buf2 1452
>>>   stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 66, plen 1518
>>>   stmmac_napi_poll_rx: stmmac_rx: count 1, len 1518, buf1 66, buf2 1452
>>>   stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 66, plen 1536
>>>   stmmac_napi_poll_rx: stmmac_rx: count 2, len 1602, buf1 66, buf2 1536
>>>   stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 1602, plen 1518
>>>   stmmac_napi_poll_rx: stmmac_rx: count 2, len 1518, buf1 0, buf2 4294967212
>>>   stmmac_napi_poll_rx: stmmac_rx: dma_buf_sz 1536, buf1 0, buf2 4294967212
>>
>> And this one to (unsigned)-EILSEQ.
> 
> Yes but this simply comes from 1518-1602 = -84. So it is purely
> coincidence.
> 
> Jon
> 

I dug around this a little bit. It looks like the issue occurs when we 
get (pardon my terminology, I haven't dealt with networking stuff much) 
a split packet.

What happens is we first process the first frame, growing 'len'. 
buf1_len, I think, hits the "First descriptor, get split header length" 
case and the length is 66. buf2_len hits the rx_not_ls case and the 
length is 1536. In total 1602.

Then the condition 'likely(status & rx_not_ls)' passes and we goto back 
to 'read_again', and read the next frame. Here we eventually get to 
buf2_len again. stmmac_get_rx_frame_len returns 1518 for this frame 
which sounds reasonable, that's what we normally get for non-split 
frames. So what we get is 1518 - 1602 which overflows.

I can dig around a bit more but it would be nice if someone with a bit 
more knowledge of the hardware could comment on the above.

Thanks,
Mikko
