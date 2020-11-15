Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABB92B31FB
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 03:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKOC0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 21:26:35 -0500
Received: from novek.ru ([213.148.174.62]:38954 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgKOC0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 21:26:35 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 6C5BB5010FE;
        Sun, 15 Nov 2020 05:26:40 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 6C5BB5010FE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605407201; bh=vvzcS+UM1DlegeezXMw+ydXWF0xqg1SzY9rBKEiwIRA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=p124DRxdSTXMM+Fc8SXskbsFW8sD0V8GUm2Cg3KC+C39xUbATE/KclnUq2TCmLM8T
         Xa7mZMgBwFiDbgEaXPOKl5SfuCm5+/u/iAoJaV+hXwbagALCQLDhx/l6oxS6FQjONf
         wpzQeOfVl7QZ+fdDDvN3H3fBrNCjNuEjnQBahvF0=
Subject: Re: [net] net/tls: fix corrupted data in recvmsg
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
References: <1605326982-2487-1-git-send-email-vfedorenko@novek.ru>
 <20201114181249.4fab54d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <2f5daf5a-0d38-d766-c345-9875f6d2d66d@novek.ru>
Date:   Sun, 15 Nov 2020 02:26:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201114181249.4fab54d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No, I don't have any BPFs in test.
If we have Application Data in TCP queue then tls_sw_advance_skb
will change ctx->control from 0x16 to 0x17 (TLS_RECORD_TYPE_DATA)
and the loop will continue. The patched if will make zc = true and
data will be decrypted into msg->msg_iter.
After that the loop will break on:
                 if (!control)
                         control = tlm->control;
                 else if (control != tlm->control)
                         goto recv_end;

and the data will be lost.
Next call to recvmsg will find ctx->decrypted set to true and will
copy the unencrypted data from skb assuming that it has been decrypted
already.

The patch that I put into Fixes: changed the check you mentioned to
ctx->control, but originally it was checking the value of control that
was stored before calling to tls_sw_advance_skb.

On 15.11.2020 02:12, Jakub Kicinski wrote:
> On Sat, 14 Nov 2020 07:09:42 +0300 Vadim Fedorenko wrote:
>> If tcp socket has more data than Encrypted Handshake Message then
>> tls_sw_recvmsg will try to decrypt next record instead of returning
>> full control message to userspace as mentioned in comment. The next
>> message - usually Application Data - gets corrupted because it uses
>> zero copy for decryption that's why the data is not stored in skb
>> for next iteration. Disable zero copy for this case.
>>
>> Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> Do you have some BPF in the mix?
>
> I don't see how we would try to go past a non-data record otherwise,
> since the loop ends like this:
>
> 		if (tls_sw_advance_skb(sk, skb, chunk)) {
> 			/* Return full control message to
> 			 * userspace before trying to parse
> 			 * another message type
> 			 */
> 			msg->msg_flags |= MSG_EOR;
> 			if (ctx->control != TLS_RECORD_TYPE_DATA)
> 				goto recv_end;
> 		} else {
> 			break;
> 		}

