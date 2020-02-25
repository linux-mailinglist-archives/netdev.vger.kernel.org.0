Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A650C16BB82
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 09:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgBYIIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 03:08:01 -0500
Received: from relay.sw.ru ([185.231.240.75]:41934 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729111AbgBYIIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 03:08:00 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1j6VFv-000547-UQ; Tue, 25 Feb 2020 11:07:52 +0300
Subject: Re: [PATCH net-next v2 2/2] unix: Show number of pending scm files of
 receive queue in fdinfo
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <157588582628.223723.6787992203555637280.stgit () localhost !
 localdomain> <2c18fad07d0e303557185aa760ba37688191eaa3.camel@redhat.com>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <96efcefc-fa4f-cd9c-78e1-5e00c0a96321@virtuozzo.com>
Date:   Tue, 25 Feb 2020 11:07:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <2c18fad07d0e303557185aa760ba37688191eaa3.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 24.02.2020 13:15, Paolo Abeni wrote:
> Hi,
> 
> On Mon, 2019-12-09 at 10:03 +0000, Kirill Tkhai wrote:
>> diff --git a/include/net/af_unix.h b/include/net/af_unix.h
>> index 3426d6dacc45..17e10fba2152 100644
>> --- a/include/net/af_unix.h
>> +++ b/include/net/af_unix.h
>> @@ -41,6 +41,10 @@ struct unix_skb_parms {
>>  	u32			consumed;
>>  } __randomize_layout;
>>  
>> +struct scm_stat {
>> +	u32 nr_fds;
>> +};
>> +
> 
> I'd like to drop the 'destructor' argument from
> __skb_try_recv_datagram() and friends - that will both clean-up the
> datagram code a bit and will avoid an indirect call in fast-path.
> 
> unix_dgram_recvmsg() needs special care: with the proposed change
> scm_stat_del() will be called explicitly after _skb_try_recv_datagram()
> while 'nr_fds' must to be updated under the receive queue lock.
> 
> Any of the following should work:
> - change 'nr_fds' to an atomic type, and drop all lockdep stuff
> - acquire again the receive queue spinlock before calling
> scm_stat_del(), ev doing that only 'if UNIXCB(skb).fp'
> - open code a variant of __skb_try_recv_datagram() which will take care
> of scm_stat_del() under the receive queue lock.
> 
> Do you have any preferences? If you don't plan to add more fields to
> 'struct scm_stat' I would go for the first option.

The first option looks the best in my opinion.

Kirill
