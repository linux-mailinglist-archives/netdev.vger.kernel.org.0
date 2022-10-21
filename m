Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EC7607261
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 10:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJUIdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 04:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJUIds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 04:33:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA2B181965;
        Fri, 21 Oct 2022 01:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=3Fm6ambxuE8pEKfPpkAWDebJ7gijUTu0DPU4cmlHnmY=; b=TBjkPWmR34CgwalI2fCF5vvAmb
        YocKZjrlQK++lrm/E9txanO8iXri0LwG3HUkCCQV5VE8B8OMpT4+BVDAxlTvHWhNeobfD9HoBU4QF
        sOPI3nil/sPQzWXHuMk8Qzh82BFWS+bqxcQsAsCeD0YcvEHYcxFuBselnCvDqrIVqLoXliDmgjnJl
        e/AK7rOPtKElAemXqEn1zqjtzwJ9yeCSIusCRe1oeqZW2MGd65Dh9iiYbGcokek3G+oWf46atTGup
        /ivgEjVdcm1l6ZKI+HnzLaTiKP/lFVA8VPOZTdPrqMwOhXVFLTKKml26Jhp0Tj4N2pOCnh6jTVznY
        t27nO7RO8nLNh1tPhA4laywgpX+/WOE2YRxvPyDT0IR3436SwBmYp0ekOo/+fju2y+xwLZrXpNOs9
        qDUY9lBkLXdLJ5Vt1WfcrsW5cyuIH3LahmlRGqlwQ56ytTstvZsJwA2U1abVK/WQSNBqfDjTQWQoe
        Z/i6HJxSr70AbwQpfKVtnDov;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olnRw-0058Fb-QE; Fri, 21 Oct 2022 08:32:16 +0000
Message-ID: <86763cf2-72ed-2d05-99c3-237ce4905611@samba.org>
Date:   Fri, 21 Oct 2022 10:32:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: IORING_SEND_NOTIF_USER_DATA (was Re: IORING_CQE_F_COPIED)
Content-Language: en-US, de-DE
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <3e7b7606-c655-2d10-f2ae-12aba9abbc76@samba.org>
 <ae88cd67-906a-7c89-eaf8-7ae190c4674b@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <ae88cd67-906a-7c89-eaf8-7ae190c4674b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

>>>> Experimenting with this stuff lets me wish to have a way to
>>>> have a different 'user_data' field for the notif cqe,
>>>> maybe based on a IORING_RECVSEND_ flag, it may make my life
>>>> easier and would avoid some complexity in userspace...
>>>> As I need to handle retry on short writes even with MSG_WAITALL
>>>> as EINTR and other errors could cause them.
>>>>
>>>> What do you think?
>>
>> Any comment on this?
>>
>> IORING_SEND_NOTIF_USER_DATA could let us use
>> notif->cqe.user_data = sqe->addr3;
> 
> I'd rather not use the last available u64, tbh, that was the
> reason for not adding a second user_data in the first place.

As far as I can see io_send_zc_prep has this:

         if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
                 return -EINVAL;

both are u64...

metze
