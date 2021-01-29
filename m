Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665D5308BC2
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 18:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhA2Rkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 12:40:55 -0500
Received: from novek.ru ([213.148.174.62]:50072 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232388AbhA2RhK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 12:37:10 -0500
Received: from [172.23.108.4] (unknown [88.151.187.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C6A1C50336D;
        Fri, 29 Jan 2021 20:37:41 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C6A1C50336D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1611941863; bh=55lwVtwV1yZBBug+A5YlWxboD+QLCVR3fnslwWwHkYU=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=Cpq/ScLFFMSFBAx5HYyPGIjEeXE5DueSIYnHcDOtNSqmp8W+ViQTdl7ireixYpOsh
         zOvCGQ+uZdJ87foAu6ntpIIxdZxfPLZ1Jsqzc0FBV+yS1AQ4oEXro3ic4P0naEwnnX
         cP06ndis/3Ll9iw/4K9r3L2PLUWd7qIRCq1AXXBw=
Subject: Re: [PATCH net] rxrpc: Fix deadlock around release of dst cached on
 udp tunnel
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Howells <dhowells@redhat.com>
Cc:     syzbot+df400f2f24a1677cd7e0@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <161193864000.3781058.7593105791689441003.stgit@warthog.procyon.org.uk>
 <076fad09-b59e-cb6d-6303-adf5964e13c7@novek.ru>
Message-ID: <1299193d-e9dd-4560-7c95-39692df6e5a3@novek.ru>
Date:   Fri, 29 Jan 2021 17:36:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <076fad09-b59e-cb6d-6303-adf5964e13c7@novek.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.01.2021 17:30, Vadim Fedorenko wrote:
> On 29.01.2021 16:44, David Howells wrote:
>> AF_RXRPC sockets use UDP ports in encap mode.  This causes socket and dst
>> from an incoming packet to get stolen and attached to the UDP socket from
>> whence it is leaked when that socket is closed.
>>
>> When a network namespace is removed, the wait for dst records to be cleaned
>> up happens before the cleanup of the rxrpc and UDP socket, meaning that the
>> wait never finishes.
>>
>> Fix this by moving the rxrpc (and, by dependence, the afs) private
>> per-network namespace registrations to the device group rather than subsys
>> group.  This allows cached rxrpc local endpoints to be cleared and their
>> UDP sockets closed before we try waiting for the dst records.
>>
>> The symptom is that lines looking like the following:
>>
>>     unregister_netdevice: waiting for lo to become free
>>
>> get emitted at regular intervals after running something like the
>> referenced syzbot test.
>>
>> Thanks to Vadim for tracking this down and work out the fix.
> 
> You missed the call to dst_release(sk->sk_rx_dst) in rxrpc_sock_destructor. 
> Without it we are still leaking the dst.
I mean this part:

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 0a2f481..3c0635e 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -833,6 +833,7 @@ static void rxrpc_sock_destructor(struct sock *sk)
         _enter("%p", sk);

         rxrpc_purge_queue(&sk->sk_receive_queue);
+       dst_destroy(sk->sk_rx_dst);

         WARN_ON(refcount_read(&sk->sk_wmem_alloc));
         WARN_ON(!sk_unhashed(sk));

