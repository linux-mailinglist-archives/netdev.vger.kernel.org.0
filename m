Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BBE26A979
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 18:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgIOQPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 12:15:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:51930 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbgIOQLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:11:11 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kIDXk-0003yI-Mu; Tue, 15 Sep 2020 18:10:56 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kIDXk-000EWV-Fm; Tue, 15 Sep 2020 18:10:56 +0200
Subject: Re: [PATCH v7 bpf-next 7/7] selftests: bpf: add dummy prog for
 bpf2bpf with tailcall
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
References: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
 <20200902200815.3924-8-maciej.fijalkowski@intel.com>
 <20200903195114.ccfzmgcl4ngz2mqv@ast-mbp.dhcp.thefacebook.com>
 <20200911185927.GA2543@ranger.igk.intel.com>
 <20200915043924.uicfgbhuszccycbq@ast-mbp.dhcp.thefacebook.com>
 <5bf5a63c-7607-a24d-7e14-e41caa84bfc3@iogearbox.net>
 <CAADnVQJoCXa90Pvkm5xyNAR3cHGx+0YO58hHOnq+LsiQuJMBiQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ed704e11-3399-135d-0bab-8699ef2e85e8@iogearbox.net>
Date:   Tue, 15 Sep 2020 18:10:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQJoCXa90Pvkm5xyNAR3cHGx+0YO58hHOnq+LsiQuJMBiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25930/Tue Sep 15 15:55:28 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/20 5:48 PM, Alexei Starovoitov wrote:
> On Tue, Sep 15, 2020 at 8:03 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> On 9/15/20 6:39 AM, Alexei Starovoitov wrote:
>>> On Fri, Sep 11, 2020 at 08:59:27PM +0200, Maciej Fijalkowski wrote:
>>>> On Thu, Sep 03, 2020 at 12:51:14PM -0700, Alexei Starovoitov wrote:
>>>>> On Wed, Sep 02, 2020 at 10:08:15PM +0200, Maciej Fijalkowski wrote:
>> [...]
>>>>> Could you add few more tests to exercise the new feature more thoroughly?
>>>>> Something like tailcall3.c that checks 32 limit, but doing tail_call from subprog.
>>>>> And another test that consume non-trival amount of stack in each function.
>>>>> Adding 'volatile char arr[128] = {};' would do the trick.
>>>>
>>>> Yet another prolonged silence from my side, but not without a reason -
>>>> this request opened up a Pandora's box.
>>>
>>> Great catch and thanks to our development practices! As a community we should
>>> remember this lesson and request selftests more often than not.
>>
>> +1, speaking of pandora ... ;-) I recently noticed that we also have the legacy
>> ld_abs/ld_ind instructions. Right now check_ld_abs() gates them by bailing out
>> if env->subprog_cnt > 1, but that doesn't solve everything given the prog itself
>> may not have bpf2bpf calls, but it could get tail-called out of a subprog. We
>> need to reject such cases (& add selftests for it), otherwise this would be a
>> verifier bypass given they may implicitly exit the program (and then mismatch
>> the return type that the verifier was expecting).
> 
> Good point. I think it's easier to allow ld_abs though.
> The comment in check_ld_abs() is obsolete after gen_ld_abs() was added.
> The verifier needs to check that subprog that is doing ld_abs or tail_call
> has 'int' return type and check_reference_leak() doesn't error before
> ld_abs and before bpf_tail_call.

Agree, sub prog 'int' return type is also currently the only option for tail call
progs anyway w/o bigger rework in verifier to track signatures.
