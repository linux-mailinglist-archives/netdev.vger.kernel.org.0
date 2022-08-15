Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED039592FEE
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 15:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbiHONbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 09:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242386AbiHONas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 09:30:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32D22AE1;
        Mon, 15 Aug 2022 06:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=DAW+JK1+w1rGYbURTQaZFFMQesVsw3aBfPZ2wMQaKes=; b=ODdYUQieyy0DoIcwkoTEtfqKYj
        NJ/fz6cROM+tzkrjHHQZZTHJLspZ7evNSbyrdQeFLbH2Qg1GCa/eY9zsuly1kkM5CHxyH5xsrbmu6
        4/KEbC8mt9s8iyz03EmFAqVbi5dO+qktd1CSAeA6GKr9TY76PMzczfGE4Kt9REbYcwvDLNaPEphsN
        86oWhZE72Wh8SSotSjuuRUBv2UebIPvqVfw3qh6jesJzCjUe1gUsc8jmpub1Vwad8wkTRmkUeK1HR
        QozCeEDoti1+2thSikBQ9q1WpUDzBg1OMX3H5Yv+9JniQOQ5cuRMtw/qVwnsxRSqOUWnZMKLI0PJj
        Ls94l8IO/pB6k1LqC/j+0aIRV68WuKfJvON5dXIq+D0yHXXQSxJRmzA8mDhwTRTsTp6NC/IUyJDHJ
        glkG6jHyR1toTE2nBHyoIM66vXqzzPkz9OOKrWPE+/gKNPtapWxc4flfR/j1T81ybzbGHYcjsqhs4
        /zOjIyHnkyzAWWp/z1z/eIwo;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oNaAr-000Gbd-1g; Mon, 15 Aug 2022 13:30:33 +0000
Message-ID: <f8ec9b9e-80b5-a24f-eb12-4069b7b90bea@samba.org>
Date:   Mon, 15 Aug 2022 15:30:32 +0200
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
 <246ef163-5711-01d6-feac-396fc176e14e@samba.org>
 <9edd5970-504c-b088-d2b1-3a2b7ad9b345@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC net-next v3 23/29] io_uring: allow to pass addr into sendzc
In-Reply-To: <9edd5970-504c-b088-d2b1-3a2b7ad9b345@gmail.com>
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

>>> Thanks for giving a thought about the API, are you trying
>>> to use it in samba?
>>
>> Yes, but I'd need SENDMSGZC and then I'd like to test,
>> which variant gives the best performance. It also depends
>> on the configured samba vfs module stack.
> 
> I can send you a branch this week if you would be
> willing to try it out as I'll be sending the "msg" variant
> only for 5.21

I'm not sure I'll have time to do runtime testing,
but it would be great to have a look at the code and give some comments
based on that.

>> I think it should be:
>>
>>                    if (up->arg)
>>                            slot->tag = up->arg;
>>                    if (!slot->notif)
>>                            continue;
>>                    io_notif_slot_flush_submit(slot, issue_flags);
>>
>> or even:
>>
>>                    slot->tag = up->arg;
>>                    if (!slot->notif)
>>                            continue;
>>                    io_notif_slot_flush_submit(slot, issue_flags);
>>
>> otherwise IORING_RSRC_UPDATE_NOTIF would not be able to reset the tag,
>> if notif was never created or already be flushed.
> 
> Ah, you want to update it for later. The idea was to affect only
> those notifiers that are flushed by this update.
> ...

notif->cqe.user_data = slot->tag; happens in io_alloc_notif(),
so the slot->tag = up->arg; here is always for the next IO_SENDZC.

With IORING_RSRC_UPDATE_NOTIF linked to a IORING_OP_SENDZC(with IORING_RECVSEND_NOTIF_FLUSH)
I basically try to reset slot->tag to the same (or related) user_data as the SENDZC itself.

So that each SENDZC generates two CQEs with the same user_data belonging
to the same userspace buffer.


> I had a similar chat with Dylan last week. I'd rather not rob SQE of
> additional u64 as there is only addr3 left and then we're fully packed,
> but there is another option we were thinking about based on OVERRIDE_TAG
> feature I scrapped from the final version of zerocopy patches.
> 
> Long story short, the idea is to copy req->cqe.user_data of a
> send(+flush) request into the notification CQE, so you'll get 2 CQEs
> with identical user_data but they can be distinguished by looking at
> cqe->flags.
> 
> What do you think? Would it work for you?

I guess that would work.

>>>> I'm also wondering what will happen if a notif will be referenced by the net layer
>>>> but the io_uring instance is already closed, wouldn't
>>>> io_uring_tx_zerocopy_callback() or __io_notif_complete_tw() crash
>>>> because notif->ctx is a stale pointer, of notif itself is already gone...
>>>
>>> io_uring will flush all slots and wait for all notifications
>>> to fire, i.e. io_uring_tx_zerocopy_callback(), so it's not a
>>> problem.
>>
>> I can't follow :-(
>>
>> What I see is that io_notif_unregister():
>>
>>                  nd = io_notif_to_data(notif);
>>                  slot->notif = NULL;
>>                  if (!refcount_dec_and_test(&nd->uarg.refcnt))
>>                          continue;
>>
>> So if the net layer still has a reference we just go on.
>>
>> Only a wild guess, is it something of:
>>
>> io_alloc_notif():
>>          ...
>>          notif->task = current;
>>          io_get_task_refs(1);
>>          notif->rsrc_node = NULL;
>>          io_req_set_rsrc_node(notif, ctx, 0);
>>          ...
>>
>> and
>>
>> __io_req_complete_put():
>>                  ...
>>                  io_req_put_rsrc(req);
>>                  /*
>>                   * Selected buffer deallocation in io_clean_op() assumes that
>>                   * we don't hold ->completion_lock. Clean them here to avoid
>>                   * deadlocks.
>>                   */
>>                  io_put_kbuf_comp(req);
>>                  io_dismantle_req(req);
>>                  io_put_task(req->task, 1);
>>                  ...
>>
>> that causes io_ring_exit_work() to wait for it.> It would be great if you or someone else could explain this in detail
>> and maybe adding some comments into the code.
> 
> Almost, the mechanism is absolutely the same as with requests,
> and notifiers are actually requests for internal purposes.
> 
> In __io_alloc_req_refill() we grab ctx->refs, which are waited
> for in io_ring_exit_work(). We usually put requests into a cache,
> so when a request is complete we don't put the ref and therefore
> in io_ring_exit_work() we also have a call to io_req_caches_free(),
> which puts ctx->refs.

Ok, thanks.

Would a close() on the ring fd block? I guess not, but the exit_work may block, correct?
So a process would be a zombie until net released all references?

metze

