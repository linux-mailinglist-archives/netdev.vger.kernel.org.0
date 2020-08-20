Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6D324C50B
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgHTSEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:04:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:55293 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgHTSEI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 14:04:08 -0400
IronPort-SDR: IRLRMi67GOTBNkXJ8tQnd29X0rSfn3JhrOo72u1DQvYkhxXDWHgPlKN3a7JbtaUFVWudk2UB1e
 4b1r/EcrzKyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="156430447"
X-IronPort-AV: E=Sophos;i="5.76,334,1592895600"; 
   d="scan'208";a="156430447"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 11:04:06 -0700
IronPort-SDR: QBEEtp/ORGQ8hbu/QbvIr0FXCEYJg4qAdw/JeQ/dOkxn5UGZxWCnSA8VLdcoL5Zl8jh4tzjyTf
 onKXlkqDKWyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,334,1592895600"; 
   d="scan'208";a="371671063"
Received: from mkorak-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.52.12])
  by orsmga001.jf.intel.com with ESMTP; 20 Aug 2020 11:04:04 -0700
Subject: Re: [Intel-wired-lan] [PATCH 0/2] intel/xdp fixes for fliping rx
 buffer
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Li RongQing <lirongqing@baidu.com>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>, Piotr <piotr.raczynski@intel.com>,
        Maciej <maciej.machnikowski@intel.com>
References: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
 <CAJ+HfNi2B+2KYP9A7yCfFUhfUBd=sFPeuGbNZMjhNSdq3GEpMg@mail.gmail.com>
 <CAJ+HfNjybUeN9v6N-pnupi32088PL+ZXu8CKWGWmowOaH4nmOw@mail.gmail.com>
 <20200820165121.GA9731@ranger.igk.intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <4a78ace0-e84e-786f-127d-a3ab7d2a7c3f@intel.com>
Date:   Thu, 20 Aug 2020 20:04:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820165121.GA9731@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-20 18:51, Maciej Fijalkowski wrote:
> On Thu, Aug 20, 2020 at 05:13:16PM +0200, Björn Töpel wrote:
>> On Tue, 18 Aug 2020 at 16:04, Björn Töpel <bjorn.topel@gmail.com> wrote:
>>>
>>> On Fri, 17 Jul 2020 at 08:24, Li RongQing <lirongqing@baidu.com> wrote:
>>>>
>>>> This fixes ice/i40e/ixgbe/ixgbevf_rx_buffer_flip in
>>>> copy mode xdp that can lead to data corruption.
>>>>
>>>> I split two patches, since i40e/xgbe/ixgbevf supports xsk
>>>> receiving from 4.18, put their fixes in a patch
>>>>
>>>
>>> Li, sorry for the looong latency. I took a looong vacation. :-P
>>>
>>> Thanks for taking a look at this, but I believe this is not a bug.
>>>
>>
>> Ok, dug a bit more into this. I had an offlist discussion with Li, and
>> there are two places (AFAIK) where Li experience a BUG() in
>> tcp_collapse():
>>
>>              BUG_ON(offset < 0);
>> and
>>                  if (skb_copy_bits(skb, offset, skb_put(nskb, size), size))
>>                      BUG();
>>
>> (Li, please correct me if I'm wrong.)
>>
>> I still claim that the page-flipping mechanism is correct, but I found
>> some weirdness in the build_skb() call.
>>
>> In drivers/net/ethernet/intel/i40e/i40e_txrx.c, build_skb() is invoked as:
>>      skb = build_skb(xdp->data_hard_start, truesize);
>>
>> For the setup Li has truesize is 2048 (half a page), but the
>> rx_buf_len is 1536. In the driver a packet is layed out as:
>>
>> | padding 192 | packet data 1536 | skb shared info 320 |
>>
>> build_skb() assumes that the second argument (frag_size) is max packet
>> size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)). In other words,
>> frag_size should not include the padding (192 above). In build_skb(),
> 
> Not sure I am buying that reasoning. It assumes the padding + packet_data
> and we use skb_reserve() to tell the skb about the padding.
> 
> __build_skb_around() subtracts sizeof(struct skb_shared_info) from size
> that we are providing, so now we are with padding + packet_data.
> Then it is used to calculate the skb->end.
> 
> Back to i40e_build_skb(), we use the skb_reserve() to advance the
> skb->data and skb->tail so that they point to packet_data. Finally
> __skb_put() will move the skb->tail to the end of packet_data.
> 
> Wouldn't your approach disallow having the headroom at all in the linear
> part of skb?
>

Mea culpa.

You're perfectly right, and I'm all wrong. Thanks for sorting that out. 
xdp->data_hard_start messed up my neurons (if any one should ask).

*climbing back into the cave*


Sorry for the mail noise,
Björn
