Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BADD54458D
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiFIIU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiFIIU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:20:56 -0400
Received: from giacobini.uberspace.de (giacobini.uberspace.de [185.26.156.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAADF3B9267
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:20:50 -0700 (PDT)
Received: (qmail 26772 invoked by uid 990); 9 Jun 2022 08:20:48 -0000
Authentication-Results: giacobini.uberspace.de;
        auth=pass (plain)
Message-ID: <d950a0cb-72d3-aa1a-24c1-5a9380681dfd@eknoes.de>
Date:   Thu, 9 Jun 2022 10:20:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] Bluetooth: RFCOMM: Use skb_trim to trim checksum
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220608135105.146452-1-soenke.huster@eknoes.de>
 <CANn89iJ2gf4JfU8KZUYFSA8KgS-gEjhBZtX9WvUmWv2c8kPkJQ@mail.gmail.com>
From:   =?UTF-8?Q?S=c3=b6nke_Huster?= <soenke.huster@eknoes.de>
In-Reply-To: <CANn89iJ2gf4JfU8KZUYFSA8KgS-gEjhBZtX9WvUmWv2c8kPkJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Bar: /
X-Rspamd-Report: MIME_GOOD(-0.1) BAYES_HAM(-1.07202) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: 0.327979
Received: from unknown (HELO unkown) (::1)
        by giacobini.uberspace.de (Haraka/2.8.28) with ESMTPSA; Thu, 09 Jun 2022 10:20:48 +0200
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 08.06.22 17:33, Eric Dumazet wrote:
> On Wed, Jun 8, 2022 at 6:51 AM Soenke Huster <soenke.huster@eknoes.de> wrote:
>>
>> Use the skb helper instead of direct manipulation. This fixes the
>> following page fault, when connecting my Android phone:
>>
>>     BUG: unable to handle page fault for address: ffffed1021de29ff
>>     #PF: supervisor read access in kernel mode
>>     #PF: error_code(0x0000) - not-present page
>>     RIP: 0010:rfcomm_run+0x831/0x4040 (net/bluetooth/rfcomm/core.c:1751)
>>
>> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
>> ---
>>  net/bluetooth/rfcomm/core.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
>> index 7324764384b6..7360e905d045 100644
>> --- a/net/bluetooth/rfcomm/core.c
>> +++ b/net/bluetooth/rfcomm/core.c
>> @@ -1747,8 +1747,8 @@ static struct rfcomm_session *rfcomm_recv_frame(struct rfcomm_session *s,
>>         type = __get_type(hdr->ctrl);
>>
>>         /* Trim FCS */
>> -       skb->len--; skb->tail--;
>> -       fcs = *(u8 *)skb_tail_pointer(skb);
>> +       skb_trim(skb, skb->len - 1);
>> +       fcs = *(skb->data + skb->len);
>>
> 
> Hmmm... I do not see any difference before/after in term of memory
> dereference to get fcs.
> 
> I think you should give more details on how exactly the bug triggers.

Sorry, yesterday I was not able to track down why exactly it crashes,
but by now I think I figured it out.

The crash happens when using Bluetooth in a virtual machine.
On connecting my Android phone to the physical controller which I use 
inside the virtual machine via the VirtIO driver, after some seconds
the crash occurs.

Before the trimming step, I examined the skb in gdb and saw, that 
skb->tail is zero. Thus, skb->tail--; modifies the unsigned integer to -1
resp. MAX_UINT. In skb_tail_pointer, skb->head + skb->tail is calculated
which results in the page fault.

By using skb_trim, skb->tail is set to the accurate value and thus the
issue is fixed.

I am not an expert in the Linux kernel area, do you think there is an
underlying issue anywhere else? When using my Android phone on my host
computer, I do not have that problem - it might be in some 
(e.g. virtio_bt?) driver? On the other hand, with the patch my problem
is solved and the phone is usable in the virtual machine!
