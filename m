Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33ACD546974
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345063AbiFJPfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344961AbiFJPfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:35:42 -0400
Received: from giacobini.uberspace.de (giacobini.uberspace.de [185.26.156.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ECD228489
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:35:38 -0700 (PDT)
Received: (qmail 21352 invoked by uid 990); 10 Jun 2022 15:35:37 -0000
Authentication-Results: giacobini.uberspace.de;
        auth=pass (plain)
Message-ID: <9f214837-dc68-ef1a-0199-27d6af582115@eknoes.de>
Date:   Fri, 10 Jun 2022 17:35:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] Bluetooth: RFCOMM: Use skb_trim to trim checksum
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
References: <20220610110749.110881-1-soenke.huster@eknoes.de>
 <CANn89i+YHqMddY68Qk1rZexqhYYX9gah-==WGttFbp4urLS7Qg@mail.gmail.com>
From:   =?UTF-8?Q?S=c3=b6nke_Huster?= <soenke.huster@eknoes.de>
In-Reply-To: <CANn89i+YHqMddY68Qk1rZexqhYYX9gah-==WGttFbp4urLS7Qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Bar: -
X-Rspamd-Report: MIME_GOOD(-0.1) BAYES_HAM(-2.998944) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -1.598944
Received: from unknown (HELO unkown) (::1)
        by giacobini.uberspace.de (Haraka/2.8.28) with ESMTPSA; Fri, 10 Jun 2022 17:35:37 +0200
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

On 10.06.22 15:59, Eric Dumazet wrote:
> On Fri, Jun 10, 2022 at 4:08 AM Soenke Huster <soenke.huster@eknoes.de> wrote:
>>
>> As skb->tail might be zero, it can underflow. This leads to a page
>> fault: skb_tail_pointer simply adds skb->tail (which is now MAX_UINT)
>> to skb->head.
>>
>>     BUG: unable to handle page fault for address: ffffed1021de29ff
>>     #PF: supervisor read access in kernel mode
>>     #PF: error_code(0x0000) - not-present page
>>     RIP: 0010:rfcomm_run+0x831/0x4040 (net/bluetooth/rfcomm/core.c:1751)
>>
>> By using skb_trim instead of the direct manipulation, skb->tail
>> is reset. Thus, the correct pointer to the checksum is used.
>>
>> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
>> ---
>> v2: Clarified how the bug triggers, minimize code change
>>
>>  net/bluetooth/rfcomm/core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
>> index 7324764384b6..443b55edb3ab 100644
>> --- a/net/bluetooth/rfcomm/core.c
>> +++ b/net/bluetooth/rfcomm/core.c
>> @@ -1747,7 +1747,7 @@ static struct rfcomm_session *rfcomm_recv_frame(struct rfcomm_session *s,
>>         type = __get_type(hdr->ctrl);
>>
>>         /* Trim FCS */
>> -       skb->len--; skb->tail--;
>> +       skb_trim(skb, skb->len - 1);
>>         fcs = *(u8 *)skb_tail_pointer(skb);
>>
>>         if (__check_fcs(skb->data, type, fcs)) {
>> --
>> 2.36.1
>>
> 
> Again, I do not see how skb->tail could possibly zero at this point.
> 
> If it was, skb with illegal layout has been queued in the first place,
> we need to fix the producer, not the consumer.
> 

Sorry, I thought that might be a right place as there is not much code in the kernel
that manipulates ->tail directly.

> A driver missed an skb_put() perhaps.
> 

I am using the (I guess quite unused) virtio_bt driver, and figured out that the following
fixes the bug:

--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -219,7 +219,7 @@ static void virtbt_rx_work(struct work_struct *work)
        if (!skb)
                return;
 
-       skb->len = len;
+       skb_put(skb, len);
        virtbt_rx_handle(vbt, skb);
 
        if (virtbt_add_inbuf(vbt) < 0)

I guess this is the root cause? I just used Bluetooth for a while in the VM
and no error occurred, everything worked fine.

> Can you please dump the skb here  ?
> 
> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
> index 7324764384b6773074032ad671777bf86bd3360e..358ccb4fe7214aea0bb4084188c7658316fe0ff7
> 100644
> --- a/net/bluetooth/rfcomm/core.c
> +++ b/net/bluetooth/rfcomm/core.c
> @@ -1746,6 +1746,11 @@ static struct rfcomm_session
> *rfcomm_recv_frame(struct rfcomm_session *s,
>         dlci = __get_dlci(hdr->addr);
>         type = __get_type(hdr->ctrl);
> 
> +       if (!skb->tail) {
> +               DO_ONCE_LITE(skb_dump(KERN_ERR, skb, false));
> +               kfree_skb(skb);
> +               return s;
> +       }
>         /* Trim FCS */
>         skb->len--; skb->tail--;
>         fcs = *(u8 *)skb_tail_pointer(skb);

If it might still help:

skb len=4 headroom=9 headlen=4 tailroom=1728          
mac=(-1,-1) net=(0,-1) trans=-1                       
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)   
hash(0x0 sw=0 l4=0) proto=0x0000 pkttype=0 iif=0      
skb linear:   00000000: 03 3f 01 1c                   

