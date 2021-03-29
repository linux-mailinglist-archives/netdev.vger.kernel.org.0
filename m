Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699FA34C48B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 09:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhC2HG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 03:06:27 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33656 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhC2HGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 03:06:19 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1617001578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SjIWl6Q8kBkuVAs+N+jCTZufMdOF8wSZY6Dy3zKfy6M=;
        b=nz6GQ0yiuhTym30CxXQ2Br6fIfhu2ai0jTHteE2m41lKQWKun3NSG2IovyPY7H7rkv0Jmw
        AGhNp4AqE+/znl4e4K9TgkjojrTz83dJNxx/XKmFpvQs/ETuwzbTQ+YcilugjEn1isHZsw
        gfjoZUu2wZS/MJitfcGmmeB1JtOL3R+FUZEqv6AcxSh7B+hUM/mlaRtRWZiza1VUDG3HHg
        eyVLPEHBpqg8jHhKo9qTdr0luidrWu71c5f/KgQTggniOtejMHQvvp2kLK9x03xXcplzrR
        TXf3ndjHApGFSONd1H4c5A8e+binkTd/4SAGxlysOztGgLcsrkfkQc+dwBZnRA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1617001578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SjIWl6Q8kBkuVAs+N+jCTZufMdOF8wSZY6Dy3zKfy6M=;
        b=fLSZSnPVQcIddHsGQJbkUA33aH4DD8F8axnt5YpJT6xH9MMFNF1xlDUTw6x5UR1OghxB3K
        5tCsHPMkHCIXt/BA==
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/packet: Reset MAC header for direct packet transmission
In-Reply-To: <CA+FuTSfzoQ_b4mu-kbXa6Gz5g3ZV4kz+ygLb7x==BJVD_040sQ@mail.gmail.com>
References: <20210326154835.21296-1-kurt@linutronix.de> <CA+FuTSfzoQ_b4mu-kbXa6Gz5g3ZV4kz+ygLb7x==BJVD_040sQ@mail.gmail.com>
Date:   Mon, 29 Mar 2021 09:06:09 +0200
Message-ID: <87blb21lsu.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sun Mar 28 2021, Willem de Bruijn wrote:
> On Fri, Mar 26, 2021 at 11:49 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>>
>> Reset MAC header in case of using packet_direct_xmit(), e.g. by specifying
>> PACKET_QDISC_BYPASS. This is needed, because other code such as the HSR layer
>> expects the MAC header to be correctly set.
>>
>> This has been observed using the following setup:
>>
>> |$ ip link add name hsr0 type hsr slave1 lan0 slave2 lan1 supervision 45 version 1
>> |$ ifconfig hsr0 up
>> |$ ./test hsr0
>>
>> The test binary is using mmap'ed sockets and is specifying the
>> PACKET_QDISC_BYPASS socket option.
>>
>> This patch resolves the following warning on a non-patched kernel:
>>
>> |[  112.725394] ------------[ cut here ]------------
>> |[  112.731418] WARNING: CPU: 1 PID: 257 at net/hsr/hsr_forward.c:560 hsr_forward_skb+0x484/0x568
>> |[  112.739962] net/hsr/hsr_forward.c:560: Malformed frame (port_src hsr0)
>>
>> The MAC header is also reset unconditionally in case of PACKET_QDISC_BYPASS is
>> not used.
>
> At the top of __dev_queue_xmit.
>
> I think it is reasonable to expect the mac header to be set in
> ndo_start_xmit. Not sure which other devices besides hsr truly
> requires it.
>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>
> If this fixes a bug, it should target net.
>
> Fixes: d346a3fae3ff ("packet: introduce PACKET_QDISC_BYPASS socket
> option")

OK.

>
> This change belongs in __dev_direct_xmit unless all callers except
> packet_direct_xmit do correctly set the mac header. xsk_generic_xmit
> appears to miss it, too, so would equally trigger this warning.

It seems like there are only two callers and the XDP part is missing it
as well. I'll move it to __dev_direct_xmit().

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmBhfGEACgkQeSpbgcuY
8KYPFA//al2kyEHn1wItbBZrlgIP7E9ayZ/HqcdIhyk3mzyMaCud1TcDdbhPZs2F
AiKPIbrpp7Gfv73/uPusJXkh8Rul4DMLZFjC0J5DSWODmWuKNWX+YoTHmezmOtPZ
y4TUle0TrXEr325lLbaKXEM11YV+K6Ii2tJhsj3nBgR3rTyb9Skt5FJlfM4MIxs+
yk0vZxAzag+TEtfOqrq7vxg3jdiQFdKN1ZBy+YpSCai9t4fYkw/B7r3jl0GXBtUe
NUsban2x4tTBGiufaXjNCHi3SKrw2UsaflqClxT75Vi+M+31BreJIPg8WAts4X4k
D3eYQ/RKdJJ0xArMYOjvJh0n3ZJL9l2IFirrUd/iC8d2ULpUwjxDYisTKAffgtDu
iD3e93p6k8qpswCijDF0JzsgOxXzxS7Ox71TNLGBqjLqfS/PEQryyFFuXbNFMf6Q
OEmPbZzordKBnZ38gLefPOoNxcHuhT8r28K2UqlXtHLEG2ptnEUT9kl/1XFS19SU
VPLAOsdHIvNeT1r5EynDymVwDakkMAiv7Xp+pRU8SlkKU1JQVXMaj5qlOX85oF7U
bsCtcDhqpsIApQsbXQGgvfDqNG9SwW3S7oA9Bx6kHQM0WdAeb7v/02r4m/ug12S7
BsT97OgjPQq0X5v2ZtugrzT5FiUcDGxvI8a251wqHlk7iGPKA/4=
=UCbi
-----END PGP SIGNATURE-----
--=-=-=--
