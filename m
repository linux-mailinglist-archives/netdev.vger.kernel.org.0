Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64353C5C31
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 14:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhGLMfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 08:35:34 -0400
Received: from novek.ru ([213.148.174.62]:51548 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhGLMfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 08:35:31 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A11A7503D9C;
        Mon, 12 Jul 2021 15:30:26 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A11A7503D9C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626093028; bh=JsCwLOFuzsSkwxahk+RhM9o9LI5v46a5GFYt/Stpawg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=b5IDHdJZhMCrlKvh9O76R02tsz5eGkhevqim0wovMr9zL3BHJvz88ffWfLBY4A8N7
         5gbzub9HkHNxKhDw1sjRrTEXfP1O74zdhOPDqeS0SBhRBBAW7KZvPCC+gnABoClxy0
         rxl041aVYq2NrOU3M3G4Xip7y3d4iZyBVmJyYCAM=
Subject: Re: [PATCH net 1/3] udp: check for encap using encap_enable
To:     Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210712005554.26948-1-vfedorenko@novek.ru>
 <20210712005554.26948-2-vfedorenko@novek.ru>
 <b076d20cb378302543db6d15310a4059ded08ecf.camel@redhat.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <6fbf2c3d-d42a-ecae-7fff-9efd0b58280a@novek.ru>
Date:   Mon, 12 Jul 2021 13:32:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b076d20cb378302543db6d15310a4059ded08ecf.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.07.2021 09:37, Paolo Abeni wrote:
> Hello,
> 
> On Mon, 2021-07-12 at 03:55 +0300, Vadim Fedorenko wrote:
>> Usage of encap_type as a flag to determine encapsulation of udp
>> socket is not correct because there is special encap_enable field
>> for this check. Many network drivers use this field as a flag
>> instead of correctly indicate type of encapsulation. Remove such
>> usage and update all checks to use encap_enable field
> 
> Uhmm... this looks quite dangerous to me. Apparently l2tp and gtp clear
> 'encap_type' to prevent the rx path pushing pkts into the encap on
> shutdown. Will such tunnel's shutdown be safe with the above?
>
I think it's safe because all the code that checks for encap_enabled checks for
encap_rcv before invoking it and l2tp clears this handler. A bit different
situation with gtp where no clearing is done while encap destroy, so I think
the same approach could be done to clear the receive handler.

I also realised that there could be some imbalance on udp_encap_needed_key in
case of l2tp and gtp. I will try to investigate it a bit more.

>> Fixes: 60fb9567bf30 ("udp: implement complete book-keeping for encap_needed")
> 
> IMHO this not fix. Which bug are you observing that is addressed here?
> 
I thought that introduction of encap_enabled should go further to switch the
code to check this particular flag and leave encap_type as a description of
specific type (or subtype) of used encapsulation. That's why I added Fixes tag.
Correct me if I'm wrong on this assumption

