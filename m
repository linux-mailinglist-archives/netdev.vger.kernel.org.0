Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC09604CD5
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 18:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJSQMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 12:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiJSQMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 12:12:22 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A7D192DA1;
        Wed, 19 Oct 2022 09:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=WNEsWRsc9YQ7S7HzOE/ZygTuGJweijxa7FYHUIU8grc=; b=phuFdzZj7saAx1oykcGf8qserz
        mepCDfKO0OlbkbPWO5GqZpSeBtGC4T3V/w7lL9CxztytOxmwicOpwzOwvWsv83We8uLkuHGtqvfPz
        OJlY/MfheYXZTqJQTwmrhnAyz5kEF5sKfP5Lli9TxZ3S6Ihx591Wb/poVixWwOI4oUnL52F1zp37P
        wnlL1N/0JZyO4rhleTWkx2tmshfZ6jaMV+tmPMh93dPUfl15yS1BlTGHIi18XqJ8wIqQGoNu8/WA1
        TsUglwJKnNSCDhvHViAY8dM3JxJHHZV9kM375OjECig9k0jYhw0+rV3/4Ezoa8iYyp4tftjwKRBEP
        lF2i9HfHsFt95cpZhdiOrCHYxgRNo+vCo+jBHS9pVENUUBckrMRwFJGxPfAeFz5P3c2wh7+4Ugn2T
        OBvuVfNk0bjOeX+FIhtXKyqjvZILi+kWz3Wel7Tyedut3L9ZCxJZxiL8s+PyJc+JcTdX7Fe8jXTE8
        LOS1AdhSibRjqxrXw3miwfiJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olBfx-004tmH-7w; Wed, 19 Oct 2022 16:12:13 +0000
Message-ID: <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
Date:   Wed, 19 Oct 2022 18:12:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: IORING_CQE_F_COPIED
In-Reply-To: <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

>> As I basically use the same logic that's used to generate SO_EE_CODE_ZEROCOPY_COPIED
>> for the native MSG_ZEROCOPY, I don't see the problem with IORING_CQE_F_COPIED.
>> Can you be more verbose why you're thinking about something different?
> 
> Because it feels like something that should be done roughly once and in
> advance. Performance wise, I agree that a bunch of extra instructions in
> the (io_uring) IO path won't make difference as the net overhead is
> already high, but I still prefer to keep it thin. The complexity is a
> good point though, if only we could piggy back it onto MSG_PROBE.
> Ok, let's do IORING_CQE_F_COPIED and aim 6.2 + possibly backport.

Thanks!

Experimenting with this stuff lets me wish to have a way to
have a different 'user_data' field for the notif cqe,
maybe based on a IORING_RECVSEND_ flag, it may make my life
easier and would avoid some complexity in userspace...
As I need to handle retry on short writes even with MSG_WAITALL
as EINTR and other errors could cause them.

What do you think?

> First, there is no more ubuf_info::zerocopy, see for-next, but you can
> grab space in io_kiocb, io_kiocb::iopoll_completed is a good candidate.

Ok I found your "net: introduce struct ubuf_info_msgzc" and
"net: shrink struct ubuf_info" commits.

I think the change would be trivial, the zerocopy field would just move
to struct io_notif_data..., maybe as 'bool copied'.

> You would want to take one io_uring patch I'm going to send (will CC
> you), with that you won't need to change anything in net/.

The problem is that e.g. tcp_sendmsg_locked() won't ever call
the callback at all if 'zc' is false.

That's why there's the:

                         if (!zc)
                                 uarg->zerocopy = 0;

Maybe I can inverse the logic and use two variables 'zero_copied'
and 'copied'.

We'd start with both being false and this logic in the callback:

if (success) {
     if (unlikely(!nd->zero_copied && !nd->copied))
        nd->zero_copied = true;
} else {
     if (unlikely(!nd->copied)) {
        nd->copied = true;
        nd->zero_copied = false;
     }
}

And __io_notif_complete_tw still needs:

         if (!nd->zero_copied)
                 notif->cqe.flags |= IORING_CQE_F_COPIED;

instead of if (nd->copied)

> And the last bit, let's make the zc probing conditional under IORING_RECVSEND_* flag,
> I'll make it zero overhead when not set later by replacing the callback.

And the if statement to select a highspeed callback based on
a IORING_RECVSEND_ flag is less overhead than
the if statements in the slow callback version?

metze

