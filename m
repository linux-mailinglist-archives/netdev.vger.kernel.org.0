Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CE5592E46
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 13:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiHOLkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 07:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiHOLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 07:40:17 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732941ED;
        Mon, 15 Aug 2022 04:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=I4kcLuOI9QLkFp6Xx5xV8uExa8DcDiyV34XA38HR150=; b=McBLV2os4UzFnUyyptk1VDPsRT
        rYIIQ9rFdiXwsVdAdG4+rsQw1K2th3kRpjCiwJ/P84PJY2jvoP2IzbOlpTS/y65JN9PC4p3aHT9ko
        o1lWg5qtMJWchNNHQHiiYndJwBtKwfSe1UV07QxBJ/tAo/PbxR5EkHrlflfP8PyWmyKxzWXRjI9Jd
        sFX25GLvUwWaBRqyaWycOl1Rnv8BH0S6XJb+9bTzHKGpCDigwj3hA87izQLhCTfrljxkoOhFXC2x8
        i+FUSnJIJohw1oPDQDsFmZq/RhS8IAH0quMEatJb+3wCMoUvI0u44AeDOo7gQut5ZMlJI6+itfcMT
        3/tb2xDiXDHhJ3dkJefgPeTz1ajItnQ6Rm3YLBnzMrA/XNctZxwOEtM9jLRdDZ0SE2acLhW26Q888
        FhA6aEUAUh6KDz5cm2jD19wl/SsKztvnlVY2JsbCLo9Pwjw9ZOAsxFSl0AUltGsIAOBTEGO+c96uj
        nrSodYrz80sQsYGHxysPqWpH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oNYRv-000Fwz-9b; Mon, 15 Aug 2022 11:40:03 +0000
Message-ID: <246ef163-5711-01d6-feac-396fc176e14e@samba.org>
Date:   Mon, 15 Aug 2022 13:40:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
 <228d4841af5eeb9a4b73955136559f18cb7e43a0.1653992701.git.asml.silence@gmail.com>
 <cccec667-d762-9bfd-f5a5-1c9fb46df5af@samba.org>
 <56631a36-fec8-9c41-712b-195ad7e4cb9f@gmail.com>
 <4eb0adae-660a-3582-df27-d6c254b97adb@samba.org>
 <db7bbfcd-fdd0-ed8e-3d8e-78d76f278af8@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC net-next v3 23/29] io_uring: allow to pass addr into sendzc
In-Reply-To: <db7bbfcd-fdd0-ed8e-3d8e-78d76f278af8@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

> Thanks for giving a thought about the API, are you trying
> to use it in samba?

Yes, but I'd need SENDMSGZC and then I'd like to test,
which variant gives the best performance. It also depends
on the configured samba vfs module stack.

My current prototype uses IO_SENDMSG for the header < 250 bytes
followed by up to 8MBytes via IO_SPLICE if the storage backend also
supports splice, otherwise I'd try to use IO_SENDMSGZC for header + 8 MBytes payload
together. If there's encryption turned actice on the connection we would
most likely always use a bounce buffer and hit the IO_SENDMSGZC case.
So all in all I'd say we'll use it.

I guess it would be useful for userspace to notice if zero was possible or not.

__msg_zerocopy_callback() sets SO_EE_CODE_ZEROCOPY_COPIED, maybe
io_uring_tx_zerocopy_callback() should have something like:

if (!success)
     notif->cqe.res = SO_EE_CODE_ZEROCOPY_COPIED;

This would make it a bit easier to judge if SENDZC is useful for the
application or not. Or at least have debug message, which would explain
be able to explain degraded performance to the admin/developer.

>>>> Given that this fills in msg almost completely can we also have
>>>> a version of SENDMSGZC, it would be very useful to also allow
>>>> msg_control to be passed and as well as an iovec.
>>>>
>>>> Would that be possible?
>>>
>>> Right, I left it to follow ups as the series is already too long.
>>>
>>> fwiw, I'm going to also add addr to IORING_OP_SEND.
>>
>>
>> Given the minimal differences, which were left between
>> IORING_OP_SENDZC and IORING_OP_SEND, wouldn't it be better
>> to merge things to IORING_OP_SEND using a IORING_RECVSEND_ZC_NOTIF
>> as indication to use the notif slot.
> 
> And will be even more similar in for-next, but with notifications
> I'd still prefer different opcodes to get a little bit more
> flexibility and not making the normal io_uring send path messier.

Ok, we should just remember the opcode is only u8
and we already have ~ 50 out of ~250 allocated in ~3 years
time.

>> It would means we don't need to waste two opcodes for
>> IORING_OP_SENDZC and IORING_OP_SENDMSGZC (and maybe more)
>>
>>
>> I also noticed a problem in io_notif_update()
>>
>>          for (; idx < idx_end; idx++) {
>>                  struct io_notif_slot *slot = &ctx->notif_slots[idx];
>>
>>                  if (!slot->notif)
>>                          continue;
>>                  if (up->arg)
>>                          slot->tag = up->arg;
>>                  io_notif_slot_flush_submit(slot, issue_flags);
>>          }
>>
>>   slot->tag = up->arg is skipped if there is no notif already.
>>
>> So you can't just use a 2 linked sqe's with
>>
>> IORING_RSRC_UPDATE_NOTIF followed by IORING_OP_SENDZC(with IORING_RECVSEND_NOTIF_FLUSH)
> 
> slot->notif is lazily initialised with the first send attached to it,
> so in your example IORING_OP_SENDZC will first create a notification
> to execute the send and then will flush it.
> 
> This "if" is there is only to have a more reliable API. We can
> go over the range and allocate all empty slots and then flush
> all of them, but allocation failures should be propagated to the
> userspace when currently the function it can't fail.
> 
>> I think the if (!slot->notif) should be moved down a bit.
> 
> Not sure what you mean

I think it should be:

                   if (up->arg)
                           slot->tag = up->arg;
                   if (!slot->notif)
                           continue;
                   io_notif_slot_flush_submit(slot, issue_flags);

or even:

                   slot->tag = up->arg;
                   if (!slot->notif)
                           continue;
                   io_notif_slot_flush_submit(slot, issue_flags);

otherwise IORING_RSRC_UPDATE_NOTIF would not be able to reset the tag,
if notif was never created or already be flushed.

>> It would somehow be nice to avoid the notif slots at all and somehow
>> use some kind of multishot request in order to generate two qces.
> 
> It is there first to ammortise overhead of zerocopy infra and bits
> for second CQE posting. But more importantly, without it for TCP
> the send payload size would need to be large enough or performance
> would suffer, but all depends on the use case. TL;DR; it would be
> forced to create a new SKB for each new send.
> 
> For something simpler, I'll push another zc variant that doesn't
> have notifiers and posts only one CQE and only after the buffers
> are no more in use by the kernel. This works well for UDP and for
> some TCP scenarios, but doesn't cover all cases.

I think (at least for stream sockets) it would be more useful to
get two CQEs:
1. The first signals userspace that it can
    issue the next send-like operation (SEND,SENDZC,SENDMSG,SPLICE)
    on the stream without the risk of byte ordering problem within the stream
    and avoid too high latency (which would happen, if we wait for a send to
    leave the hardware nic, before sending the next PDU).
2. The 2nd signals userspace that the buffer can be reused or released.

In that case it would be useful to also provide a separate 'user_data' element
for the 2nd CQE.

>> I'm also wondering what will happen if a notif will be referenced by the net layer
>> but the io_uring instance is already closed, wouldn't
>> io_uring_tx_zerocopy_callback() or __io_notif_complete_tw() crash
>> because notif->ctx is a stale pointer, of notif itself is already gone...
> 
> io_uring will flush all slots and wait for all notifications
> to fire, i.e. io_uring_tx_zerocopy_callback(), so it's not a
> problem.

I can't follow :-(

What I see is that io_notif_unregister():

                 nd = io_notif_to_data(notif);
                 slot->notif = NULL;
                 if (!refcount_dec_and_test(&nd->uarg.refcnt))
                         continue;

So if the net layer still has a reference we just go on.

Only a wild guess, is it something of:

io_alloc_notif():
         ...
         notif->task = current;
         io_get_task_refs(1);
         notif->rsrc_node = NULL;
         io_req_set_rsrc_node(notif, ctx, 0);
         ...

and

__io_req_complete_put():
                 ...
                 io_req_put_rsrc(req);
                 /*
                  * Selected buffer deallocation in io_clean_op() assumes that
                  * we don't hold ->completion_lock. Clean them here to avoid
                  * deadlocks.
                  */
                 io_put_kbuf_comp(req);
                 io_dismantle_req(req);
                 io_put_task(req->task, 1);
                 ...

that causes io_ring_exit_work() to wait for it.
It would be great if you or someone else could explain this in detail
and maybe adding some comments into the code.

metze

