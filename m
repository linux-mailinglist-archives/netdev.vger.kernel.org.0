Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BA23C5BDD
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 14:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhGLML5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 08:11:57 -0400
Received: from novek.ru ([213.148.174.62]:50896 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230074AbhGLMLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 08:11:55 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id ACF5C503D9C;
        Mon, 12 Jul 2021 15:06:49 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru ACF5C503D9C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626091610; bh=R1OLzsI/VyWD5qZhdtHwndBDDqOtO0Ksy0X719XDFV4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=q11ggXyEGXkCp+viGvWYWxhLMyEm0cRLUWs0lJ7QwxTD+GIqPUN2x7cIBRI4ncRaH
         hY7175PhI7xklyMRTntoYvbnQ4+U181faA9WNNmMLCoeKOUNo22DzqlJVDC/8US1NL
         UEGJL8lIvW+GTGtA0dAzmhcmplPT+VwXciJBHasU=
Subject: Re: [PATCH net 2/3] udp: check encap socket in __udp_lib_err
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210712005554.26948-1-vfedorenko@novek.ru>
 <20210712005554.26948-3-vfedorenko@novek.ru>
 <CA+FuTSdCMqVqvUKfM3+3=B0k+2MQzB0+aNJJYQZP+d=k2dy34A@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <ad38c217-b97d-d4ad-7689-f2728a804fbf@novek.ru>
Date:   Mon, 12 Jul 2021 13:09:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdCMqVqvUKfM3+3=B0k+2MQzB0+aNJJYQZP+d=k2dy34A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.07.2021 08:59, Willem de Bruijn wrote:
> On Mon, Jul 12, 2021 at 2:56 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>>
>> Commit d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
>> added checks for encapsulated sockets but it broke cases when there is
>> no implementation of encap_err_lookup for encapsulation, i.e. ESP in
>> UDP encapsulation. Fix it by calling encap_err_lookup only if socket
>> implements this method otherwise treat it as legal socket.
>>
>> Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>> ---
>>   net/ipv4/udp.c | 24 +++++++++++++++++++++++-
>>   net/ipv6/udp.c | 22 ++++++++++++++++++++++
>>   2 files changed, 45 insertions(+), 1 deletion(-)
> 
> This duplicates __udp4_lib_err_encap and __udp6_lib_err_encap.
> 
> Can we avoid open-coding that logic multiple times?
> 
Yes, sure. I was thinking about the same but wanted to get a feedback
on approach itself. I will try to implement parts of that duplicates
as helpers next round.
