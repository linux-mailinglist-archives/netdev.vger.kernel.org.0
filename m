Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE803348BA
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhCJUQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:16:19 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:34977 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhCJUQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:16:01 -0500
Received: from maxwell ([93.223.218.186]) by mrelayeu.kundenserver.de
 (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis) id
 1MJW5G-1l0LQo2NWy-00Jsyd; Wed, 10 Mar 2021 21:15:38 +0100
References: <87ft12ri0t.fsf@henneberg-systemdesign.com>
 <20210310182935.GC17851@1wt.eu>
User-agent: mu4e 1.2.0; emacs 27.1
From:   Henneberg - Systemdesign <lists@henneberg-systemdesign.com>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org
Subject: Re: TIOCOUTQ implementation for sockets vs. tty
In-reply-to: <20210310182935.GC17851@1wt.eu>
Date:   Wed, 10 Mar 2021 21:15:37 +0100
Message-ID: <87eegmrcie.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:YaP9tuG6IbqPG61pmFmFUNC/Ag+2sAQAaQjAeKmqhZsuNdUTBBg
 6M8/3wOZdt/DfnvHRK3wdq7lmXuFY5vECvi7k0zAhIYh0r2ZTPnOTbC8uX0TZQAeBupi0eD
 nkfjNO3dMye/qLv9zDETTs2/16aQ+6CiqqbKWcM4G7PuaIqbd4BFCRX5Msa2idpTgWnHeJW
 RsE5ZkFdryeKuXP2U0i6A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/oPpUeyTVls=:j1GuQSL9hWrPB/rxA+fts7
 VWRT6GC6w2q1c9hHRcPuJoo4PKzcsJpSn7gmLTG/+L4tLpRj01z5IpPDVRhgcjMr3y7ZvSzS0
 omuBPYXbPrZMiFfytIJY0PV3++c8baROnhOVbzYXun/O7spctEvGIUSBJXQXU3SyT1mK0mIgx
 lyGz7uCj1ZBwwgIc0C9fbZDqDUOJyCKszkRqwGifDCdbn1WsKZPxU7X9O1hc9hQ28vGY9kaGz
 4Z19U4a9gZZ7BhTntU4B2RIZAZDXytyj9R4UyfkjZSppkf8dfgAXquGoIt4OkMzjiDUwU2KVT
 NKH8806ELQy8nxRGSzY7QmonPhwsVdgVo8JDKcCfRNCVp7eWriI05qzuo7svmFhMTC4EHvYTe
 RbV1neSIYwK1kx83B3Ql6ye4xU0qo7oI4mIws/KvQS+Egcvvy0HvvsuKPh4EyHcy766IulmY/
 r2egTZBBRg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Willy Tarreau <w@1wt.eu> writes:

> Hi,
>
> On Wed, Mar 10, 2021 at 07:16:34PM +0100, Henneberg - Systemdesign wrote:
>> Hi,
>> 
>> I have a question regarding the implementation of ioctl TIOCOUTQ for
>> various sockets compared to the tty implementation.
>> 
>> For several sockets, e. g. AF_BLUETOOTH it is done like this
>> 
>> af_bluetooth.c:
>> case TIOCOUTQ:
>> 	if (sk->sk_state == BT_LISTEN)
>> 		return -EINVAL;
>> 
>> 	amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
>> 	if (amount < 0)
>> 		amount = 0;
>> 	err = put_user(amount, (int __user *)arg);
>> 	break;
>> 
>> so the ioctl returns the available space in the send queue if I
>> understand the code correctly (this is also what I observed from tests).
>> 
>> The tty does this:
>> 
>> n_tty.c:
>> case TIOCOUTQ:
>> 	return put_user(tty_chars_in_buffer(tty), (int __user *) arg);
>> 
>> so it returns the used space in the send queue. This is also what I
>> would expect from the manpage description.
>> 
>> Is this mismatch intentional?
>
> At least both man pages (tty_ioctl and tcp(7)) mention that TIOCOUTQ
> should return the number of byte in queue.
>
> What I suspect for sockets is that sk_sndbuf grows with allocations
> and that sk_wmem_alloc_get() in fact returns the number of unused
> allocations thus the difference would be the amount queued. But I
> could be wrong and I would tend to read the code the same way as you
> did.

I am quite sure that my assumption is right. When I call the ioctl right
before and after writing data to an AF_BLUETOOTH socket the returned
value decreases where it should increase.

-Jochen

>
> Willy


-- 
Henneberg - Systemdesign
Jochen Henneberg
Loehnfeld 26
21423 Winsen (Luhe)
--
Fon: +49 172 160 14 69
www: www.henneberg-systemdesign.com
