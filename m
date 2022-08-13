Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F23059197A
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 10:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbiHMIpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 04:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHMIpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 04:45:42 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A6031909;
        Sat, 13 Aug 2022 01:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=3cEBObWgCZMEf5BzXPdMLgj+++YHuxc+xbCWnw6pWiE=; b=1BCxgAO3j1D7zHsNXs+eZtQn/P
        8xMlz2ekJlCiLTMMb+MjBx8SZt+yu6b5Frh8Hq2xxe8LClb/RTPE0P8a5f5+FqvSdvGbkBL1IziID
        yLmLVo5t4mB4TcOXP7s68jYHp2wf37YxzjJACLCbv+b/v4EtyqHSIR9GTTcCkWlr+oGuCDxOIu8fy
        DbM/Xtleb3dRjlc6oC5UMdW5Y9r/MO7P8jsnG73Vf7yL+XQYzeJriBrvF+qf+5JU+tYzfq8zhdI0I
        jCBON0LqNeo9apvSR8sQp0nR7/F5Ami8VLxlTNUbCkzjsFdfQsEGqhuBB3s6NTfjQiE034NVveI0F
        rNbnmvM8kIlScMnhW0Bur+bpLaQ+ZuDbKS3tzhCB5NqYF07Ws3seWMbzsqDS5F631n2D+aoHQS3qu
        lmOP3Ygevg4g/ZCBet7a819qMdJr+M8xbMDH1PZMVVnkXRXMxt6WDSbhqlCt1ktDgsFkbQCRxKAAf
        6ffa2hcD0SwM+4iPfyFR1fb+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oMmlp-009Qyp-37; Sat, 13 Aug 2022 08:45:25 +0000
Message-ID: <4eb0adae-660a-3582-df27-d6c254b97adb@samba.org>
Date:   Sat, 13 Aug 2022 10:45:24 +0200
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
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC net-next v3 23/29] io_uring: allow to pass addr into sendzc
In-Reply-To: <56631a36-fec8-9c41-712b-195ad7e4cb9f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

>> Given that this fills in msg almost completely can we also have
>> a version of SENDMSGZC, it would be very useful to also allow
>> msg_control to be passed and as well as an iovec.
>>
>> Would that be possible?
> 
> Right, I left it to follow ups as the series is already too long.
> 
> fwiw, I'm going to also add addr to IORING_OP_SEND.


Given the minimal differences, which were left between
IORING_OP_SENDZC and IORING_OP_SEND, wouldn't it be better
to merge things to IORING_OP_SEND using a IORING_RECVSEND_ZC_NOTIF
as indication to use the notif slot.

It would means we don't need to waste two opcodes for
IORING_OP_SENDZC and IORING_OP_SENDMSGZC (and maybe more)


I also noticed a problem in io_notif_update()

         for (; idx < idx_end; idx++) {
                 struct io_notif_slot *slot = &ctx->notif_slots[idx];

                 if (!slot->notif)
                         continue;
                 if (up->arg)
                         slot->tag = up->arg;
                 io_notif_slot_flush_submit(slot, issue_flags);
         }

  slot->tag = up->arg is skipped if there is no notif already.

So you can't just use a 2 linked sqe's with

IORING_RSRC_UPDATE_NOTIF followed by IORING_OP_SENDZC(with IORING_RECVSEND_NOTIF_FLUSH)

I think the if (!slot->notif) should be moved down a bit.

It would somehow be nice to avoid the notif slots at all and somehow
use some kind of multishot request in order to generate two qces.

I'm also wondering what will happen if a notif will be referenced by the net layer
but the io_uring instance is already closed, wouldn't
io_uring_tx_zerocopy_callback() or __io_notif_complete_tw() crash
because notif->ctx is a stale pointer, of notif itself is already gone...

What do you think?

metze
