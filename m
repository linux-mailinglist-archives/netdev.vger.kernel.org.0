Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C91960D8E
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfGEWAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:00:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:53184 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGEWAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:00:49 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjWG5-0003S0-M8; Sat, 06 Jul 2019 00:00:45 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjWG5-0003Kn-AR; Sat, 06 Jul 2019 00:00:45 +0200
Subject: Re: [PATCHv2] tools bpftool: Fix json dump crash on powerpc
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Michael Petlan <mpetlan@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>
References: <20190704085856.17502-1-jolsa@kernel.org>
 <20190704134210.17b8407c@cakuba.netronome.com> <20190705121031.GA10777@krava>
 <20190705102452.0831942a@cakuba.netronome.com>
 <83d18af0-8efa-c8d5-3d99-01aed29915df@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5168f635-a23c-eac3-479d-747e55adfc4c@iogearbox.net>
Date:   Sat, 6 Jul 2019 00:00:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <83d18af0-8efa-c8d5-3d99-01aed29915df@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25501/Fri Jul  5 10:01:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2019 07:26 PM, Quentin Monnet wrote:
> 2019-07-05 10:24 UTC-0700 ~ Jakub Kicinski <jakub.kicinski@netronome.com>
>> On Fri, 5 Jul 2019 14:10:31 +0200, Jiri Olsa wrote:
>>> Michael reported crash with by bpf program in json mode on powerpc:
>>>
>>>   # bpftool prog -p dump jited id 14
>>>   [{
>>>         "name": "0xd00000000a9aa760",
>>>         "insns": [{
>>>                 "pc": "0x0",
>>>                 "operation": "nop",
>>>                 "operands": [null
>>>                 ]
>>>             },{
>>>                 "pc": "0x4",
>>>                 "operation": "nop",
>>>                 "operands": [null
>>>                 ]
>>>             },{
>>>                 "pc": "0x8",
>>>                 "operation": "mflr",
>>>   Segmentation fault (core dumped)
>>>
>>> The code is assuming char pointers in format, which is not always
>>> true at least for powerpc. Fixing this by dumping the whole string
>>> into buffer based on its format.
>>>
>>> Please note that libopcodes code does not check return values from
>>> fprintf callback, but as per Jakub suggestion returning -1 on allocation
>>> failure so we do the best effort to propagate the error. 
>>>
>>> Reported-by: Michael Petlan <mpetlan@redhat.com>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>
>> Thanks, let me repost all the tags (Quentin, please shout if you're
>> not ok with this :)):
> 
> I confirm it's all good for me, thanks :)
> 
>> Fixes: 107f041212c1 ("tools: bpftool: add JSON output for `bpftool prog dump jited *` command")
>> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Given merge window coming up, I've applied this to bpf-next, thanks everyone!

P.s.: Jiri, please repost full/proper patch next time instead of inline reply.
