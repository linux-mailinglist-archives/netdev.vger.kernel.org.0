Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4624308BAD
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 18:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhA2RdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 12:33:22 -0500
Received: from novek.ru ([213.148.174.62]:49994 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232541AbhA2RbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 12:31:16 -0500
Received: from [172.23.108.4] (unknown [88.151.187.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 5301D50336D;
        Fri, 29 Jan 2021 20:31:42 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 5301D50336D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1611941503; bh=UpNwpbPvyiTwBiO+3m9ceWt4XhWDDHb7nJx7oBas5eE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZnD1RJUjrJ2ZG52bSj4yGOy+n5D22vJI5iQXzkI0/0Sxi7ek9zfcmuIflkWYAtXYl
         a6tgtINJqI8M42gBF9HQVsxPVE96xPmb2vJ/L1pzG595LaT49QDSA4Q4P9EmPnmmqa
         3mQGEyfO3AfnemZ7J2fyXDUkPQhue8mXUt1sgRw4=
Subject: Re: [PATCH net] rxrpc: Fix deadlock around release of dst cached on
 udp tunnel
To:     David Howells <dhowells@redhat.com>
Cc:     syzbot+df400f2f24a1677cd7e0@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <161193864000.3781058.7593105791689441003.stgit@warthog.procyon.org.uk>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <076fad09-b59e-cb6d-6303-adf5964e13c7@novek.ru>
Date:   Fri, 29 Jan 2021 17:30:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <161193864000.3781058.7593105791689441003.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.01.2021 16:44, David Howells wrote:
> AF_RXRPC sockets use UDP ports in encap mode.  This causes socket and dst
> from an incoming packet to get stolen and attached to the UDP socket from
> whence it is leaked when that socket is closed.
> 
> When a network namespace is removed, the wait for dst records to be cleaned
> up happens before the cleanup of the rxrpc and UDP socket, meaning that the
> wait never finishes.
> 
> Fix this by moving the rxrpc (and, by dependence, the afs) private
> per-network namespace registrations to the device group rather than subsys
> group.  This allows cached rxrpc local endpoints to be cleared and their
> UDP sockets closed before we try waiting for the dst records.
> 
> The symptom is that lines looking like the following:
> 
> 	unregister_netdevice: waiting for lo to become free
> 
> get emitted at regular intervals after running something like the
> referenced syzbot test.
> 
> Thanks to Vadim for tracking this down and work out the fix.

You missed the call to dst_release(sk->sk_rx_dst) in rxrpc_sock_destructor. 
Without it we are still leaking the dst.

