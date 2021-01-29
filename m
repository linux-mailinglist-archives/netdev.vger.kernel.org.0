Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8597A308DE4
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhA2T4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:56:34 -0500
Received: from novek.ru ([213.148.174.62]:50908 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232805AbhA2Tyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 14:54:33 -0500
Received: from [172.23.108.4] (unknown [88.151.187.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 9B91F50336D;
        Fri, 29 Jan 2021 22:55:04 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 9B91F50336D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1611950106; bh=QvUKfzgowASge7UazlBJHjSIrRFoDRvNXIMzU/CnNYk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Vdhibff2TwtpNTIN9rVtt9p8LolUnoGREER/gaQgM2XcDRlCXl+JFtg28q3+Q3n75
         HOYiTd6HxnGZh6upUMCHqd0qx65Jo/LLi49ojk9YFIkLGgHt7w8t6n98bXvYyJPBsb
         stg/k07ah4/4Y5a5Ice+Xbo7M1Ac4qbHryMP7kd0=
Subject: Re: [PATCH net] rxrpc: Fix deadlock around release of dst cached on
 udp tunnel
To:     David Howells <dhowells@redhat.com>
Cc:     syzbot+df400f2f24a1677cd7e0@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <076fad09-b59e-cb6d-6303-adf5964e13c7@novek.ru>
 <161193864000.3781058.7593105791689441003.stgit@warthog.procyon.org.uk>
 <3834976.1611942088@warthog.procyon.org.uk>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <f8c2e8be-7a5a-83a0-fc86-2bdd1095c33d@novek.ru>
Date:   Fri, 29 Jan 2021 19:53:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3834976.1611942088@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.01.2021 17:41, David Howells wrote:
> Vadim Fedorenko <vfedorenko@novek.ru> wrote:
> 
>> You missed the call to dst_release(sk->sk_rx_dst) in
>> rxrpc_sock_destructor. Without it we are still leaking the dst.
> 
> Hmmm...  I no longer get the messages appearing with this patch.  I'll have
> another look.

Sorry, my bad. rxrpc_sock_destructor destroys AF_RXRPC sockets, which are 
totally different from the UDP kernel socket used as a transport and which are 
destroyed as usual UDP sockets.

Ack-by: Vadim Fedorenko <vfedorenko@novek.ru>

