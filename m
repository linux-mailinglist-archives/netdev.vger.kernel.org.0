Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC4833FC1F
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 01:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhCRAPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 20:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhCRAPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 20:15:33 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DC7C06174A;
        Wed, 17 Mar 2021 17:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:From:To;
        bh=ERo1P9UI0lxoWnqnKaqtoDcM2RBuyA+RRfP43amFE1s=; b=bOXdkifkzRrZJRiqbCuQG4QRdF
        Y0mQMPt+/doCp3ZFm048nu3x88YM+JnOqW2SMYgX/VCS/8/m6gcXuD3/QEoUhaEOpWjHXbm7uRXIJ
        DndBr3Fq8oj0R72LYXli6dzhdR0mjxZ7QOC84PwbW3trcfto/wYAkWQmsxvOdDlHOwzqr5N2X+xHQ
        uZ4yUlvraoL4jTPwOmz2OeUWUxzB2usU/OO13A4DAMRbnJGt7tOStULSYbW/GUrAgPV3n+Q39wT+c
        KkH1/8+u3ApjQ4yqUirXfSdqWP+Ox+hn3hoVNX5wysr4FxlVlfluJV0IfGnTG3ksvIaAA6eYYCKUb
        alluuL7b0NztoyzygOZ6v7E6Vc+MYCpfcTmBiKbL6WA/eC1RUk9nFGQvN3aY8SuowcERuuH0cWUFR
        ha7Mj9/FidlG4p0K+6KbH8hMP1EkeVnPQWLxyBXfsVS+t4ZhMit+A7oM5rKuZoeE9wUMRRXRJUWpl
        1O6g5atnXnnWshSudRrIUN5P;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lMgK2-0001kK-9V; Thu, 18 Mar 2021 00:15:30 +0000
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1615908477.git.metze@samba.org>
 <47ae1117-0de3-47a9-26a2-80f92e242426@kernel.dk>
 <b2f00537-a8a3-9243-6990-d6708e7f7691@gmail.com>
 <e15f23a2-4efc-c12a-9a4f-b4e3c347ae63@samba.org>
 <c5b26bbe-7d95-ec86-5ddb-c2bd2b6c79a7@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/2] send[msg]()/recv[msg]() fixes/improvements
Message-ID: <903c17f5-4339-7ee8-40fb-34a6974ce597@samba.org>
Date:   Thu, 18 Mar 2021 01:15:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <c5b26bbe-7d95-ec86-5ddb-c2bd2b6c79a7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

>>>>> here're patches which fix linking of send[msg]()/recv[msg]() calls
>>>>> and make sure io_uring_enter() never generate a SIGPIPE.
>>>
>>> 1/2 breaks userspace.
>>
>> Can you explain that a bit please, how could some application ever
>> have a useful use of IOSQE_IO_LINK with these socket calls?
> 
> Packet delivery of variable size, i.e. recv(max_size). Byte stream
> that consumes whatever you've got and links something (e.g. notification
> delivery, or poll). Not sure about netlink, but maybe. Or some
> "create a file via send" crap, or some made-up custom protocols

Ok, then we need a flag or a new opcode to provide that behavior?

For recv() and recvmsg() MSG_WAITALL might be usable.

It's not defined in 'man 2 sendmsg', but should we use it anyway
for IORING_OP_SEND[MSG] in order to activate the short send check
as the low level sock_sendmsg() call seem to ignore unused flags,
which seems to be the reason for the following logic in tcp_sendmsg_locked:

if (flags & MSG_ZEROCOPY && size && sock_flag(sk, SOCK_ZEROCOPY)) {

You need to set SOCK_ZEROCOPY in the socket in order to give a meaning
to MSG_ZEROCOPY.

Should I prepare an add-on patch to make the short send/recv logic depend
on MSG_WAITALL?

I'm cc'ing netdev@vger.kernel.org in order to more feedback of
MSG_WAITALL can be passed to sendmsg without fear to trigger
-EINVAL.

The example for io_sendmsg() would look like this:

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4383,7 +4383,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
        struct io_async_msghdr iomsg, *kmsg;
        struct socket *sock;
        unsigned flags;
-       int expected_ret;
+       int min_ret = 0;
        int ret;

        sock = sock_from_file(req->file);
@@ -4404,9 +4404,11 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
        else if (issue_flags & IO_URING_F_NONBLOCK)
                flags |= MSG_DONTWAIT;

-       expected_ret = iov_iter_count(&kmsg->msg.msg_iter);
-       if (unlikely(expected_ret == MAX_RW_COUNT))
-               expected_ret += 1;
+       if (flags & MSG_WAITALL) {
+               min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+               if (unlikely(min_ret == MAX_RW_COUNT))
+                       min_ret += 1;
+       }
        ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
        if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
                return io_setup_async_msg(req, kmsg);
@@ -4417,7 +4419,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
        if (kmsg->free_iov)
                kfree(kmsg->free_iov);
        req->flags &= ~REQ_F_NEED_CLEANUP;
-       if (ret != expected_ret)
+       if (ret < min_ret)
                req_set_fail_links(req);
        __io_req_complete(req, issue_flags, ret, 0);
        return 0;

Which means the default of min_ret = 0 would result in:

        if (ret < 0)
                req_set_fail_links(req);

again...

>>> Sounds like 2/2 might too, does it?
>>
>> Do you think any application really expects to get a SIGPIPE
>> when calling io_uring_enter()?
> 
> If it was about what I think I would remove lots of old garbage :)
> I doubt it wasn't working well before, e.g. because of iowq, but
> who knows

Yes, it was inconsistent before and now it's reliable.

metze



