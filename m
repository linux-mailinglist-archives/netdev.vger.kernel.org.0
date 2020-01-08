Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38DDF134A57
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgAHSRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:17:54 -0500
Received: from www62.your-server.de ([213.133.104.62]:55474 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbgAHSRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:17:54 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipFtw-0008N1-I5; Wed, 08 Jan 2020 19:17:52 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipFtw-000387-9i; Wed, 08 Jan 2020 19:17:52 +0100
Subject: Re: [PATCH] bpf/sockmap: read psock ingress_msg before
 sk_receive_queue
To:     John Fastabend <john.fastabend@gmail.com>,
        Lingpeng Chen <forrest0579@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <5e15526d2ebb6_68832ae93d7145c08c@john-XPS-13-9370.notmuch>
 <20200108045708.31240-1-forrest0579@gmail.com>
 <20200108170259.GA7665@linux-3.fritz.box>
 <5e161913342f2_67ea2afd262665bc1c@john-XPS-13-9370.notmuch>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e40286e9-107c-4af9-e596-4af426408eca@iogearbox.net>
Date:   Wed, 8 Jan 2020 19:17:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <5e161913342f2_67ea2afd262665bc1c@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25688/Wed Jan  8 10:56:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/20 7:01 PM, John Fastabend wrote:
> Daniel Borkmann wrote:
>> On Wed, Jan 08, 2020 at 12:57:08PM +0800, Lingpeng Chen wrote:
>>> Right now in tcp_bpf_recvmsg, sock read data first from sk_receive_queue
>>> if not empty than psock->ingress_msg otherwise. If a FIN packet arrives
>>> and there's also some data in psock->ingress_msg, the data in
>>> psock->ingress_msg will be purged. It is always happen when request to a
>>> HTTP1.0 server like python SimpleHTTPServer since the server send FIN
>>> packet after data is sent out.
>>>
>>> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
>>> Reported-by: Arika Chen <eaglesora@gmail.com>
>>> Suggested-by: Arika Chen <eaglesora@gmail.com>
>>> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
>>> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>>> ---
>>>   net/ipv4/tcp_bpf.c | 7 ++++---
>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>>> index e38705165ac9..f7e902868fce 100644
>>> --- a/net/ipv4/tcp_bpf.c
>>> +++ b/net/ipv4/tcp_bpf.c
>>> @@ -123,12 +123,13 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>>>   
>>>   	if (unlikely(flags & MSG_ERRQUEUE))
>>>   		return inet_recv_error(sk, msg, len, addr_len);
>>
>> Shouldn't we also move the error queue handling below the psock test as
>> well and let tcp_recvmsg() natively do it in case of !psock?
>>
> 
> You mean the MSG_ERRQUEUE flag handling? If the user sets MSG_ERRQUEUE
> they expect to receive any queued errors it would be wrong to return
> psock data in this case if psock is attached and has data on queue and
> user passes MSG_ERRQUEUE flag.
> 
>   MSG_ERRQUEUE (since Linux 2.2)
>    This flag specifies that queued errors should be received from the socket
>    error queue.  The error is passed in an ancillary message with a type
>    dependent on the protocol (for IPv4 IP_RECVERR).  The user should supply
>    a buffer of sufficient size. See cmsg(3) and ip(7) for more information.
>    The payload of the original packet that caused the error is passed as
>    normal data via msg_iovec. The original destination address of the
>    datagram that caused the error is supplied via msg_name.
> 
> I believe it needs to be where it is.

I meant that it should have looked as follows (aka moving both below the
psock test) ...

         psock = sk_psock_get(sk);
         if (unlikely(!psock))
             return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
         if (unlikely(flags & MSG_ERRQUEUE))
             return inet_recv_error(sk, msg, len, addr_len);
	if (!skb_queue_empty(&sk->sk_receive_queue) && [...]

... since when detached it's handled already via tcp_recvmsg() internals.

>>> -	if (!skb_queue_empty(&sk->sk_receive_queue))
>>> -		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
>>>   
>>>   	psock = sk_psock_get(sk);
>>>   	if (unlikely(!psock))
>>>   		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
>>> +	if (!skb_queue_empty(&sk->sk_receive_queue) &&
>>> +	    sk_psock_queue_empty(psock))
>>> +		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
>>>   	lock_sock(sk);
>>>   msg_bytes_ready:
>>>   	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
>>> @@ -139,7 +140,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>>>   		timeo = sock_rcvtimeo(sk, nonblock);
>>>   		data = tcp_bpf_wait_data(sk, psock, flags, timeo, &err);
>>>   		if (data) {
>>> -			if (skb_queue_empty(&sk->sk_receive_queue))
>>> +			if (!sk_psock_queue_empty(psock))
>>>   				goto msg_bytes_ready;
>>>   			release_sock(sk);
>>>   			sk_psock_put(sk, psock);
>>> -- 
>>> 2.17.1
>>>
> 
> 

