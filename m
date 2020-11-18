Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA022B7365
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgKRAuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:50:55 -0500
Received: from novek.ru ([213.148.174.62]:50126 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgKRAuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 19:50:54 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 25ED3502C3D;
        Wed, 18 Nov 2020 03:51:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 25ED3502C3D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605660662; bh=6adnlXsOMVIeP37vOGMsmEGtjr2MAdGOSkL3cU89Ql8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZB3nL7p4Zg84JtY3RLZBDuylGzLiDRA0rVf0FtJJHdZZoBl5X4G76lUu28Ki6Ujxw
         R/tzS7xAw3LXBHmsYX4araz/kwfHmR2pZsyd8UJZ1Dg3QR1OaRO2Bb2MFdI4fZ1cVQ
         ga82qnvdTihJG/X645WEt3vLDOiN5fIwggVpFdGU=
Subject: Re: [net] net/tls: missing received data after fast remote close
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
References: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
 <20201117143847.2040f609@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <71f25f4d-a92c-8c56-da34-9d6f7f808c18@novek.ru>
Date:   Wed, 18 Nov 2020 00:50:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201117143847.2040f609@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.11.2020 22:38, Jakub Kicinski wrote:
> On Sun, 15 Nov 2020 14:43:48 +0300 Vadim Fedorenko wrote:
>> In case when tcp socket received FIN after some data and the
>> parser haven't started before reading data caller will receive
>> an empty buffer.
> This is pretty terse, too terse for me to understand..
The flow is simple. Server sends small amount of data right after the
connection is configured and closes the connection. In this case
receiver sees TLS Handshake data, configures TLS socket right after
Change Cipher Spec record. While the configuration is in process, TCP
socket receives small Application Data record, Encrypted Alert record
and FIN packet. So the TCP socket changes sk_shutdown to RCV_SHUTDOWN
and sk_flag with SK_DONE bit set.
>> This behavior differs from plain TCP socket and
>> leads to special treating in user-space. Patch unpauses parser
>> directly if we have unparsed data in tcp receive queue.
> Sure, but why is the parser paused? Does it pause itself on FIN?
No, it doesn't start even once. The trace looks like:

tcp_recvmsg is called
tcp_recvmsg returns 1 (Change Cipher Spec record data)
tls_setsockopt is called
tls_setsockopt returns
tls_recvmsg is called
tls_recvmsg returns 0
__strp_recv is called
stack
         __strp_recv+1
         tcp_read_sock+169
         strp_read_sock+104
         strp_work+68
         process_one_work+436
         worker_thread+80
         kthread+276
         ret_from_fork+34tls_read_size called

So it looks like strp_work was scheduled after tls_recvmsg and
nothing triggered parser because all the data was received before
tls_setsockopt ended the configuration process.
>
>> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
>> index 2fe9e2c..4db6943 100644
>> --- a/net/tls/tls_sw.c
>> +++ b/net/tls/tls_sw.c
>> @@ -1289,6 +1289,9 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
>>   	struct sk_buff *skb;
>>   	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>>   
>> +	if (!ctx->recv_pkt && skb_queue_empty(&sk->sk_receive_queue))
>> +		__strp_unpause(&ctx->strp);
>> +
>>   	while (!(skb = ctx->recv_pkt) && sk_psock_queue_empty(psock)) {
>>   		if (sk->sk_err) {
>>   			*err = sock_error(sk);

