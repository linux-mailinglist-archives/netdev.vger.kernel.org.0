Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AED51D8BE6
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgERXzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:55:24 -0400
Received: from novek.ru ([213.148.174.62]:51722 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgERXzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 19:55:23 -0400
Received: from [10.0.1.119] (unknown [62.76.204.32])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A67105020BC;
        Tue, 19 May 2020 02:55:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A67105020BC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589846120; bh=GDpSSED9gzADultolRcsaiI8aLfV/gmE1kyYBJcTJJw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lrf95rdll9ELWpT8e9Jv5c83+3VXYBp4U8T+9hoywTC69EJA166yjKGn4kV2qkZYC
         k8ewwjsCG0q1+dO7nkBGvDxpVV+4BN2uDWLq6zacl3ebQL6HkW3vUbkBK+y8qBAMyL
         deDMPcdrQ53YUv6FdvjGIZB+SWtmmkC8cdDd0PVk=
Subject: Re: [PATCH] net/tls: fix encryption error checking
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20200517014451.954F05026DE@novek.ru>
 <20200518153005.577dfe99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANN+EMpn2ZkquAdK5WFC-bmioSoAbAtNvovXtgTyTHW+-eDPhw@mail.gmail.com>
 <e26b157f-edc4-4a04-11ac-21485ed52f8a@novek.ru>
 <20200518162343.7685f779@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <8c526c6b-172e-1301-dbd0-6ce5901f5890@novek.ru>
Date:   Tue, 19 May 2020 02:55:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200518162343.7685f779@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=2.2 required=5.0 tests=RDNS_NONE,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.1
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.05.2020 02:23, Jakub Kicinski wrote:
> On Tue, 19 May 2020 02:05:29 +0300 Vadim Fedorenko wrote:
>> On 19.05.2020 01:30, Jakub Kicinski wrote:
>>>> tls_push_record can return -EAGAIN because of tcp layer. In that
>>>> case open_rec is already in the tx_record list and should not be
>>>> freed.
>>>> Also the record size can be more than the size requested to write
>>>> in tls_sw_do_sendpage(). That leads to overflow of copied variable
>>>> and wrong return code.
>>>>
>>>> Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
>>>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>>> Doesn't this return -EAGAIN back to user space? Meaning even tho we
>>> queued the user space will try to send it again?
>> Before patch it was sending negative value back to user space.
>> After patch it sends the amount of data encrypted in last call. It is checked
>> by:
>>    return (copied > 0) ? copied : ret;
>> and returns -EAGAIN only if data is not sent to open record.
> I see, you're fixing two different bugs in one patch. Could you please
> split the fixes into two? (BTW no need for parenthesis around the
> condition in the ternary operator.) I think you need more fixes tags,
> too. Commit d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
> already added one instance of the problem, right?
Sure, will split it into two. Also the problem with overflow is possible in
tls_sw_sendmsg(). But I'm not sure about correctness of freeing whole open
record in bpf_exec_tx_verdict.
> What do you think about Pooja's patch to consume the EAGAIN earlier?
> There doesn't seem to be anything reasonable we can do with the error
> anyway, not sure there is a point checking for it..
Yes, it's a good idea to consume this error earlier. I think it's better to fix
tls_push_record() instead of dealing with it every possible caller.

So I suggest to accept Pooja's patch and will resend only ssize_t checking fix.
