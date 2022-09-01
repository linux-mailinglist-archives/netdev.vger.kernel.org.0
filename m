Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEEE5A907D
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbiIAHiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbiIAHie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:38:34 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4697A116E14
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 00:38:30 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:34624.980274448
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-27.148.194.74 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 7C5772800A0;
        Thu,  1 Sep 2022 15:38:19 +0800 (CST)
X-189-SAVE-TO-SEND: liyonglong@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 52ec4fd87943445db9185f89024524e9 for pabeni@redhat.com;
        Thu, 01 Sep 2022 15:38:28 CST
X-Transaction-ID: 52ec4fd87943445db9185f89024524e9
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
Subject: Re: [PATCH] tcp: del skb from tsorted_sent_queue after mark it as
 lost
To:     Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
References: <1661761242-7849-1-git-send-email-liyonglong@chinatelecom.cn>
 <CAK6E8=dJzNC7GFTikanKM48Uo5DFZBZGSUVoMy1dCfV0ttNe+g@mail.gmail.com>
 <CAK6E8=eNe8Ce9zKXx1rKBL48XuDVGntAOOtKVi6ywgMjafMWXg@mail.gmail.com>
 <43b8a024-2ab8-157d-92c2-7367f632c659@chinatelecom.cn>
 <CADVnQynrEer3EBcDe2jeK4GNFOdKMFLwFgiXqjFg5CgAiBOjFA@mail.gmail.com>
From:   Yonglong Li <liyonglong@chinatelecom.cn>
Message-ID: <d46593a1-1dc2-ed59-8897-bc6c86cb34af@chinatelecom.cn>
Date:   Thu, 1 Sep 2022 15:38:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CADVnQynrEer3EBcDe2jeK4GNFOdKMFLwFgiXqjFg5CgAiBOjFA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neal, Yuchung,

I get your point. Thank you for your patience to feelback.

On 8/31/2022 8:46 PM, Neal Cardwell wrote:
> On Wed, Aug 31, 2022 at 3:19 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>>
>>
>>
>> On 8/31/2022 1:58 PM, Yuchung Cheng wrote:
>>> On Mon, Aug 29, 2022 at 5:23 PM Yuchung Cheng <ycheng@google.com> wrote:
>>>>
>>>> On Mon, Aug 29, 2022 at 1:21 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>>>>>
>>>>> if rack is enabled, when skb marked as lost we can remove it from
>>>>> tsorted_sent_queue. It will reduces the iterations on tsorted_sent_queue
>>>>> in tcp_rack_detect_loss
>>>>
>>>> Did you test the case where an skb is marked lost again after
>>>> retransmission? I can't quite remember the reason I avoided this
>>>> optimization. let me run some test and get back to you.
>>> As I suspected, this patch fails to pass our packet drill tests.
>>>
>>> It breaks detecting retransmitted packets that
>>> get lost again, b/c they have already been removed from the tsorted
>>> list when they get lost the first time.
>>>
>>>
>>
>> Hi Yuchung,
>> Thank you for your feelback.
>> But I am not quite understand. in the current implementation, if an skb
>> is marked lost again after retransmission, it will be added to tail of
>> tsorted_sent_queue again in tcp_update_skb_after_send.
>> Do I miss some code?
> 
> That's correct, but in the kind of scenario Yuchung is talking about,
> the skb is not retransmitted again.
> 
> To clarify, here is an example snippet of a test written by Yuchung
> that covers this kind of case:
> 
> ----
> `../common/defaults.sh`
> 
>     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
> 
>    +0 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
>    +0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK,nop,wscale 8>
>  +.02 < . 1:1(0) ack 1 win 257
>    +0 accept(3, ..., ...) = 4
>    +0 write(4, ..., 16000) = 16000
>    +0 > P. 1:10001(10000) ack 1
> 
> // TLP (but it is dropped too so no ack for it)
>  +.04 > . 10001:11001(1000) ack 1
> 
> // RTO and retransmit head
>  +.22 > . 1:1001(1000) ack 1
> 
> // ACK was lost. But the (spurious) retransmit induced a DSACK.
> // So total this ack hints two packets (original & dup).
> // Undo cwnd and ssthresh.
>  +.01 < . 1:1(0) ack 1001 win 257 <sack 1:1001,nop,nop>
>    +0 > P. 11001:13001(2000) ack 1
>    +0 %{
> assert tcpi_snd_cwnd == 12, tcpi_snd_cwnd
> assert tcpi_snd_ssthresh > 1000000, tcpi_snd_ssthresh
> }%
> 
> // TLP to discover the real losses 1001:11001(10000)
>  +.04 > . 13001:14001(1000) ack 1
> 
> // Fast recovery. PRR first then PRR-SS after retransmits are acked
>  +.01 < . 1:1(0) ack 1001 win 257 <sack 11001:12001,nop,nop>
>    +0 > . 1001:2001(1000) ack 1
> ----
> 
> In this test case, with the proposed patch in this thread applied, the
> final 1001:2001(1000) skb is transmitted 440ms later, after an RTO.
> AFAICT that's because the 1001:2001(1000) skb was removed from the
> tsorted list upon the original (spurious RTO) but not re-added upon
> the undo of that spurious RTO.
> 
> best regards,
> neal
> 

-- 
Li YongLong
