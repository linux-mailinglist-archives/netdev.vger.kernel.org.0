Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E1A1D8AEC
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgERW3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:29:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:55940 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgERW3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 18:29:46 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jaoGU-0007b4-CW; Tue, 19 May 2020 00:29:42 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jaoGU-000Ee7-4f; Tue, 19 May 2020 00:29:42 +0200
Subject: Re: [PATCH bpf-next 4/4] bpf, testing: add get{peer,sock}name
 selftests to test_progs
To:     Andrey Ignatov <rdna@fb.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        sdf@google.com
References: <cover.1589813738.git.daniel@iogearbox.net>
 <1b9869b34027bc0722f4217a0b04f1cccccc5c33.1589813738.git.daniel@iogearbox.net>
 <20200518221728.GA49655@rdna-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e6f2dc5e-3491-8ace-a902-975ab42002f0@iogearbox.net>
Date:   Tue, 19 May 2020 00:29:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200518221728.GA49655@rdna-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25816/Mon May 18 14:17:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/20 12:17 AM, Andrey Ignatov wrote:
> Daniel Borkmann <daniel@iogearbox.net> [Mon, 2020-05-18 08:35 -0700]:
>> Extend the existing connect_force_port test to assert get{peer,sock}name programs
>> as well. The workflow for e.g. IPv4 is as follows: i) server binds to concrete
>> port, ii) client calls getsockname() on server fd which exposes 1.2.3.4:60000 to
>> client, iii) client connects to service address 1.2.3.4:60000 binds to concrete
>> local address (127.0.0.1:22222) and remaps service address to a concrete backend
>> address (127.0.0.1:60123), iv) client then calls getsockname() on its own fd to
>> verify local address (127.0.0.1:22222) and getpeername() on its own fd which then
>> publishes service address (1.2.3.4:60000) instead of actual backend. Same workflow
>> is done for IPv6 just with different address/port tuples.
>>
>>    # ./test_progs -t connect_force_port
>>    #14 connect_force_port:OK
>>    Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Andrey Ignatov <rdna@fb.com>
>> ---
> 
>> --- a/tools/testing/selftests/bpf/network_helpers.c
>> +++ b/tools/testing/selftests/bpf/network_helpers.c
>> @@ -5,6 +5,8 @@
>>   #include <string.h>
>>   #include <unistd.h>
>>   
>> +#include <arpa/inet.h>
>> +
>>   #include <sys/epoll.h>
>>   
>>   #include <linux/err.h>
>> @@ -35,7 +37,7 @@ struct ipv6_packet pkt_v6 = {
>>   	.tcp.doff = 5,
>>   };
>>   
>> -int start_server(int family, int type)
>> +int start_server_with_port(int family, int type, int port)
> 
> Nit: IMO it's worth to start using __u16 for ports in new places,
> especially since this network helper can be adopted by many tests in the
> future. I know 4-byte int-s are used for ports even in UAPI, but IMO it
> just adds confusion and complicates implementation in both kernel and
> user BPF programs.

Ok, makes sense, I'll change the signature to __u16 port in a v2.

Thanks,
Daniel
