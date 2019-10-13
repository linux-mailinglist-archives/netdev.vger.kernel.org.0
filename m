Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC37D559D
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 12:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbfJMKRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 06:17:53 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:50343 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728528AbfJMKRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 06:17:53 -0400
X-Originating-IP: 90.177.210.238
Received: from [192.168.1.110] (238.210.broadband10.iol.cz [90.177.210.238])
        (Authenticated sender: i.maximets@ovn.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 9ADA440004;
        Sun, 13 Oct 2019 10:17:48 +0000 (UTC)
Subject: Re: [PATCH bpf v2] libbpf: fix passing uninitialized bytes to
 setsockopt
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <5da24d48.1c69fb81.a3069.c817SMTPIN_ADDED_BROKEN@mx.google.com>
 <20191012232437.2xpi5mmmv7mxz3yy@ast-mbp.dhcp.thefacebook.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <c338b2fd-8e0d-885d-5895-317d20800815@ovn.org>
Date:   Sun, 13 Oct 2019 12:17:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191012232437.2xpi5mmmv7mxz3yy@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.10.2019 1:24, Alexei Starovoitov wrote:
> On Wed, Oct 09, 2019 at 06:49:29PM +0200, Ilya Maximets wrote:
>> 'struct xdp_umem_reg' has 4 bytes of padding at the end that makes
>> valgrind complain about passing uninitialized stack memory to the
>> syscall:
>>
>>    Syscall param socketcall.setsockopt() points to uninitialised byte(s)
>>      at 0x4E7AB7E: setsockopt (in /usr/lib64/libc-2.29.so)
>>      by 0x4BDE035: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:172)
>>    Uninitialised value was created by a stack allocation
>>      at 0x4BDDEBA: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:140)
>>
>> Padding bytes appeared after introducing of a new 'flags' field.
>> memset() is required to clear them.
>>
>> Fixes: 10d30e301732 ("libbpf: add flags to umem config")
>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>> ---
>>
>> Version 2:
>>    * Struct initializer replaced with explicit memset(). [Andrii]
>>
>>   tools/lib/bpf/xsk.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> index a902838f9fcc..9d5348086203 100644
>> --- a/tools/lib/bpf/xsk.c
>> +++ b/tools/lib/bpf/xsk.c
>> @@ -163,6 +163,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
>>   	umem->umem_area = umem_area;
>>   	xsk_set_umem_config(&umem->config, usr_config);
>>   
>> +	memset(&mr, 0, sizeof(mr));
>>   	mr.addr = (uintptr_t)umem_area;
>>   	mr.len = size;
>>   	mr.chunk_size = umem->config.frame_size;
> 
> This was already applied. Why did you resend?
> 

Sorry, it wasn't me.  Looking at the mail delivery chain:

Received: from listssympa-test.colorado.edu (listssympa-test.colorado.edu [128.138.129.156])
	by spool.mail.gandi.net (Postfix) with ESMTPS id 66E2F780445
	for <i.maximets@ovn.org>; Sun, 13 Oct 2019 04:52:14 +0000 (UTC)
Received: from listssympa-test.colorado.edu (localhost [127.0.0.1])
	by listssympa-test.colorado.edu (8.15.2/8.15.2/MJC-8.0/sympa) with ESMTPS id x9D4pvsL015926
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 12 Oct 2019 22:51:57 -0600
Received: (from root@localhost)
	by listssympa-test.colorado.edu (8.15.2/8.15.2/MJC-8.0/submit) id x9D4pujl015885;
	Sat, 12 Oct 2019 22:51:56 -0600
Received: from DM5PR03MB3273.namprd03.prod.outlook.com (2603:10b6:a03:54::17) by
  BYAPR03MB4376.namprd03.prod.outlook.com with HTTPS via
  BYAPR02CA0040.NAMPRD02.PROD.OUTLOOK.COM; Wed, 9 Oct 2019 22:04:15 +0000
Received: from BN6PR03CA0057.namprd03.prod.outlook.com (2603:10b6:404:4c::19) by
  DM5PR03MB3273.namprd03.prod.outlook.com (2603:10b6:4:42::32) with Microsoft
  SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
  id 15.20.2347.16; Wed, 9 Oct 2019 17:44:13 +0000

There is some strange server listssympa-test.colorado.edu.
Looks like someone in colorado.edu is testing stuff on production server.

The simplified delivery chain looks like this:

Me -> relay6-d.mail.gandi.net -> vger.kernel.org -> mx.colorado.edu ->
mail.protection.outlook.com -> namprd03.prod.outlook.com ->
listssympa-test.colorado.edu -> spool.mail.gandi.net -> Me again!

Best regards, Ilya Maximets.
