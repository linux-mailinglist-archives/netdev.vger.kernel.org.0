Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4761C2B3214
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 05:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgKOELN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 23:11:13 -0500
Received: from novek.ru ([213.148.174.62]:39100 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgKOELN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 23:11:13 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 2AD4A5010FE;
        Sun, 15 Nov 2020 07:11:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 2AD4A5010FE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605413478; bh=BiWA6hcpHJWZKQQBFhxhuteKkOAheGExQO9e9sp46fE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VCzL/YAu16/fmONWInkhvfmAVWLin9EFOFXaOiTXfi7lxwxz5UnV5N1kAQCWWUZkv
         vjLwBgHyAq74IGRg6PkdM2hspX1Go6+6L/pS1X9vWaiqFu2zBAjYSUzQHVoYRzNeru
         ICFcMM5Ra17VFWItnag9hha45xiJY+0jDJD6Bua0=
Subject: Re: [net] net/tls: fix corrupted data in recvmsg
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
References: <1605326982-2487-1-git-send-email-vfedorenko@novek.ru>
 <20201114181249.4fab54d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2f5daf5a-0d38-d766-c345-9875f6d2d66d@novek.ru>
 <20201114195437.4d0493b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <5bc6ebac-f399-add3-f528-422840b988d3@novek.ru>
Date:   Sun, 15 Nov 2020 04:11:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201114195437.4d0493b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15.11.2020 03:54, Jakub Kicinski wrote:
> Please don't top post.
>
> On Sun, 15 Nov 2020 02:26:30 +0000 Vadim Fedorenko wrote:
>> No, I don't have any BPFs in test.
>> If we have Application Data in TCP queue then tls_sw_advance_skb
>> will change ctx->control from 0x16 to 0x17 (TLS_RECORD_TYPE_DATA)
>> and the loop will continue.
> Ah! Missed that, unpausing the parser will make it serve us another
> message and overwrite ctx.
>
>> The patched if will make zc = true and
>> data will be decrypted into msg->msg_iter.
>> After that the loop will break on:
>>                   if (!control)
>>                           control = tlm->control;
>>                   else if (control != tlm->control)
>>                           goto recv_end;
>>
>> and the data will be lost.
>> Next call to recvmsg will find ctx->decrypted set to true and will
>> copy the unencrypted data from skb assuming that it has been decrypted
>> already.
>>
>> The patch that I put into Fixes: changed the check you mentioned to
>> ctx->control, but originally it was checking the value of control that
>> was stored before calling to tls_sw_advance_skb.
> Is there a reason why we wouldn't just go back to checking the stored
> control? Or better - put your condition there (control != ctx->control)?
> Decrypting the next record seems unnecessary given we can't return it.
Going back to checking stored control is working in TLS 1.2 but I cannot
test it with TLS 1.3. But it looks like it will work too in that case.
Variable control should store correct value to pass it in control message
and it's not chaged after that.
Ok, will send v2 with check reverted, thanks!
