Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E201DA4F9
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgESWti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:49:38 -0400
Received: from novek.ru ([213.148.174.62]:46236 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgESWti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 18:49:38 -0400
Received: from [10.0.1.119] (unknown [62.76.204.32])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 4D0355028F3;
        Wed, 20 May 2020 01:49:32 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 4D0355028F3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589928572; bh=nf3XNoiCy9/fUfMf2OIY9gSgW5Gm2zxWhgjLaW7RdSw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OnPHOvdOjBLxVXezx+JEz1asRbtmYvbQ5G945f6jzDwbGpxnXMEq/mAYQzGoLYZX5
         aobUliGgyAohy7FwaLi4AWCpFeppFjwFdODtBr9ZiBLzXNsXwruP8XOXwI9zImqRRv
         MQza92GvE4eYW5ATeckcg1ixQ2k1SMH+g8xLTTzY=
Subject: Re: [PATCH v2 net] net/tls: fix encryption error checking
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <1589883643-6939-1-git-send-email-vfedorenko@novek.ru>
 <20200519150420.485c800d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <e4ec82ba-10e5-8b23-4da5-5883f3a89b92@novek.ru>
Date:   Wed, 20 May 2020 01:49:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200519150420.485c800d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=2.2 required=5.0 tests=RDNS_NONE,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.1
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.05.2020 01:04, Jakub Kicinski wrote:
> On Tue, 19 May 2020 13:20:43 +0300 Vadim Fedorenko wrote:
>> bpf_exec_tx_verdict() can return negative value for copied
>> variable. In that case this value will be pushed back to caller
>> and the real error code will be lost. Fix it using signed type and
>> checking for positive value.
>>
>> Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
>> Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> If the error encountered is transient we will still drop some data from
> the stream, because the record that was freed may have included data
> from a previous send call. Still, cleaning up the error code seems like
> an improvement.
>
> John, do you have an opinion on this?

Jakub, maybe it is better to free only in case of fatal encryption error? I mean
when sk->sk_err is EBADMSG. Because in case of ENOMEM we will iterate to
alloc_payload and in case of ENOSPC we will return good return code and send
open_rec again on next call. The EBADMSG state is the only fatal state that needs
freeing of allocated record.
