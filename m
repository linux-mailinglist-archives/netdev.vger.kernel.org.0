Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78773431F1
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 11:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCUKVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 06:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhCUKUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 06:20:45 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AFEC061762;
        Sun, 21 Mar 2021 03:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=AE2pu6r7u8eilhnmuwqN6wEZjDFbUEn6quKpMq7dLoA=; b=z+FQq5Bt2VdpNQlf7BcUT3Ou7B
        zq6+68ccSWStsCbgtc90V71w5y2PNGy62/65tQzGvZpDquAioQAWrGj0cKtKhG3nM+TH1dvcA8vDk
        pVzQu78N+taZfp2rZ1VOkyCVw+F92Q9dapzQOiVlpT+lB3GfR+Ze1wV8TN3FFPXwNaq74ceNqhVQm
        E5Zg6mEMzb/4bejYQd59Iz9N9AUBQxWko0njxdo2kk8C+lVrVJ8GDw3tXMEJlSIKgYNvaGqWerqhi
        m2QFjGr0mzoX0HY+2cpq2q6kCd96DQ0poyhwndTeQgeQ29IoUEMd+8wlGhoWbUfnpZmGuurXapedF
        rlSg9IfYHnjeM6uC9Ji8sM19jWtvRfURDu6iqE9HK18nfmyjywfsLvx0vl8308/e6FxjrRlPIstV7
        vPYvf50C5W2FCo5Igjif4ml67ULp7oB5Md2K+wDnzHjRAtHLYn9lm3aBoq5c1VWcbBVbIzqM95FMJ
        y1kz9qOySt4LCFMHsX/hICQC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNvCK-0002on-1z; Sun, 21 Mar 2021 10:20:40 +0000
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org
References: <c4e1a4cc0d905314f4d5dc567e65a7b09621aab3.1615908477.git.metze@samba.org>
 <12efc18b6bef3955500080a238197e90ca6a402c.1616268538.git.metze@samba.org>
 <38a987b9-d962-7531-6164-6dde9b4d133b@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v2 1/1] io_uring: call req_set_fail_links() on short
 send[msg]()/recv[msg]() with MSG_WAITALL
Message-ID: <d68edf13-99a7-d010-cfc8-542f59ac7e27@samba.org>
Date:   Sun, 21 Mar 2021 11:20:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <38a987b9-d962-7531-6164-6dde9b4d133b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 20.03.21 um 23:57 schrieb Jens Axboe:
> On 3/20/21 1:33 PM, Stefan Metzmacher wrote:
>> Without that it's not safe to use them in a linked combination with
>> others.
>>
>> Now combinations like IORING_OP_SENDMSG followed by IORING_OP_SPLICE
>> should be possible.
>>
>> We already handle short reads and writes for the following opcodes:
>>
>> - IORING_OP_READV
>> - IORING_OP_READ_FIXED
>> - IORING_OP_READ
>> - IORING_OP_WRITEV
>> - IORING_OP_WRITE_FIXED
>> - IORING_OP_WRITE
>> - IORING_OP_SPLICE
>> - IORING_OP_TEE
>>
>> Now we have it for these as well:
>>
>> - IORING_OP_SENDMSG
>> - IORING_OP_SEND
>> - IORING_OP_RECVMSG
>> - IORING_OP_RECV
>>
>> For IORING_OP_RECVMSG we also check for the MSG_TRUNC and MSG_CTRUNC
>> flags in order to call req_set_fail_links().
>>
>> There might be applications arround depending on the behavior
>> that even short send[msg]()/recv[msg]() retuns continue an
>> IOSQE_IO_LINK chain.
>>
>> It's very unlikely that such applications pass in MSG_WAITALL,
>> which is only defined in 'man 2 recvmsg', but not in 'man 2 sendmsg'.
>>
>> It's expected that the low level sock_sendmsg() call just ignores
>> MSG_WAITALL, as MSG_ZEROCOPY is also ignored without explicitly set
>> SO_ZEROCOPY.
>>
>> We also expect the caller to know about the implicit truncation to
>> MAX_RW_COUNT, which we don't detect.
> 
> Thanks, I do think this is much better and I feel comfortable getting
> htis applied for 5.12 (and stable).
> 

Great thanks!

Related to that I have a questing regarding the IOSQE_IO_LINK behavior.
(Assuming I have a dedicated ring for the send-path of each socket.)

Is it possible to just set IOSQE_IO_LINK on every sqe in order to create
an endless chain of requests so that userspace can pass as much sqes as possible
which all need to be submitted in the exact correct order. And if any request
is short, then all remaining get ECANCELED, without the risk of running any later
request out of order.

Are such link chains possible also over multiple io_uring_submit() calls?
Is there still a race between, having an iothread removing the request from
from the list and fill in a cqe with ECANCELED, that userspace is not awaire
of yet, which then starts a new independed link chain with a request that
ought to be submitted after all the canceled once.

Or do I have to submit a link chain with just a single __io_uring_flush_sq()
and then strictly need to wait until I got a cqe for the last request in
the chain?

Thanks!
metze
