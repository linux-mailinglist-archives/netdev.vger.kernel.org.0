Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E86F3E5893
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 12:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbhHJKuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 06:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239920AbhHJKuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 06:50:00 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC78C0613D3;
        Tue, 10 Aug 2021 03:49:37 -0700 (PDT)
Received: from [192.168.178.156] (unknown [80.156.89.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id BEE9CC0353;
        Tue, 10 Aug 2021 12:49:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1628592568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M0qF+o2AoVk5F58x/KmSY20curOZrhbNqe7IPSM3OJA=;
        b=n+fHjMvtfN0LwKThosvhFKpTysHYNz3y05ebgbmXczVeSF2/Hpk8w0xIviQW0d4t9/2R8H
        4CbkvT3toZe0uFnRDjHD8eFsNfj15HjXpPFettkL3f1U/Yk4mV3jtNuv1VGhK6xKeqFBzy
        sU+dO+33KeSZ/trhYO8ULtLjvyVs6RyfInzyAy995ZoZW3AsXOjwt7z67FRZXLqBy7rHpf
        0DLDZOzeQWPmbinKCCT3+vA4wrZaEBhleqOOk9aEZ/SGzDzCAyzJpeluaHFY2Pg8+Kpnjz
        glKyjnOTwSo58vfq8m/C9ctC0VqL6lDpnAkTrW3Hfd+kX2F7Rgyvv2RG/PmLxw==
Subject: Re: [PATCH net] net: Fix memory leak in ieee802154_raw_deliver
To:     Alexander Aring <alex.aring@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Takeshi Misawa <jeliantsurux@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>
References: <20210805075414.GA15796@DESKTOP>
 <20210805065022.574e0691@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAB_54W4DK3uo+q7vRC2Vzrs5BENq2L_ukkkewiSXMNaSBiTsEQ@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <47581b9b-4def-40be-88cb-6357516f9eb3@datenfreihafen.org>
Date:   Tue, 10 Aug 2021 12:49:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAB_54W4DK3uo+q7vRC2Vzrs5BENq2L_ukkkewiSXMNaSBiTsEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 09.08.21 15:06, Alexander Aring wrote:
> Hi,
> 
> On Thu, 5 Aug 2021 at 09:50, Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Thu, 5 Aug 2021 16:54:14 +0900 Takeshi Misawa wrote:
>>> If IEEE-802.15.4-RAW is closed before receive skb, skb is leaked.
>>> Fix this, by freeing sk_receive_queue in sk->sk_destruct().
>>>
>>> syzbot report:
>>> BUG: memory leak
>>> unreferenced object 0xffff88810f644600 (size 232):
>>>    comm "softirq", pid 0, jiffies 4294967032 (age 81.270s)
>>>    hex dump (first 32 bytes):
>>>      10 7d 4b 12 81 88 ff ff 10 7d 4b 12 81 88 ff ff  .}K......}K.....
>>>      00 00 00 00 00 00 00 00 40 7c 4b 12 81 88 ff ff  ........@|K.....
>>>    backtrace:
>>>      [<ffffffff83651d4a>] skb_clone+0xaa/0x2b0 net/core/skbuff.c:1496
>>>      [<ffffffff83fe1b80>] ieee802154_raw_deliver net/ieee802154/socket.c:369 [inline]
>>>      [<ffffffff83fe1b80>] ieee802154_rcv+0x100/0x340 net/ieee802154/socket.c:1070
>>>      [<ffffffff8367cc7a>] __netif_receive_skb_one_core+0x6a/0xa0 net/core/dev.c:5384
>>>      [<ffffffff8367cd07>] __netif_receive_skb+0x27/0xa0 net/core/dev.c:5498
>>>      [<ffffffff8367cdd9>] netif_receive_skb_internal net/core/dev.c:5603 [inline]
>>>      [<ffffffff8367cdd9>] netif_receive_skb+0x59/0x260 net/core/dev.c:5662
>>>      [<ffffffff83fe6302>] ieee802154_deliver_skb net/mac802154/rx.c:29 [inline]
>>>      [<ffffffff83fe6302>] ieee802154_subif_frame net/mac802154/rx.c:102 [inline]
>>>      [<ffffffff83fe6302>] __ieee802154_rx_handle_packet net/mac802154/rx.c:212 [inline]
>>>      [<ffffffff83fe6302>] ieee802154_rx+0x612/0x620 net/mac802154/rx.c:284
>>>      [<ffffffff83fe59a6>] ieee802154_tasklet_handler+0x86/0xa0 net/mac802154/main.c:35
>>>      [<ffffffff81232aab>] tasklet_action_common.constprop.0+0x5b/0x100 kernel/softirq.c:557
>>>      [<ffffffff846000bf>] __do_softirq+0xbf/0x2ab kernel/softirq.c:345
>>>      [<ffffffff81232f4c>] do_softirq kernel/softirq.c:248 [inline]
>>>      [<ffffffff81232f4c>] do_softirq+0x5c/0x80 kernel/softirq.c:235
>>>      [<ffffffff81232fc1>] __local_bh_enable_ip+0x51/0x60 kernel/softirq.c:198
>>>      [<ffffffff8367a9a4>] local_bh_enable include/linux/bottom_half.h:32 [inline]
>>>      [<ffffffff8367a9a4>] rcu_read_unlock_bh include/linux/rcupdate.h:745 [inline]
>>>      [<ffffffff8367a9a4>] __dev_queue_xmit+0x7f4/0xf60 net/core/dev.c:4221
>>>      [<ffffffff83fe2db4>] raw_sendmsg+0x1f4/0x2b0 net/ieee802154/socket.c:295
>>>      [<ffffffff8363af16>] sock_sendmsg_nosec net/socket.c:654 [inline]
>>>      [<ffffffff8363af16>] sock_sendmsg+0x56/0x80 net/socket.c:674
>>>      [<ffffffff8363deec>] __sys_sendto+0x15c/0x200 net/socket.c:1977
>>>      [<ffffffff8363dfb6>] __do_sys_sendto net/socket.c:1989 [inline]
>>>      [<ffffffff8363dfb6>] __se_sys_sendto net/socket.c:1985 [inline]
>>>      [<ffffffff8363dfb6>] __x64_sys_sendto+0x26/0x30 net/socket.c:1985
>>>
>>> Fixes: 9ec767160357 ("net: add IEEE 802.15.4 socket family implementation")
>>> Reported-and-tested-by: syzbot+1f68113fa907bf0695a8@syzkaller.appspotmail.com
>>> Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
