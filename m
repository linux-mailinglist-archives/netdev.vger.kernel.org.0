Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B5333C15
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfFCXsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:48:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:46692 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfFCXsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:48:25 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hXwgf-00010o-Eh; Tue, 04 Jun 2019 01:48:21 +0200
Received: from [178.197.249.21] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hXwgf-000Lnk-48; Tue, 04 Jun 2019 01:48:21 +0200
Subject: Re: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Matt Mullins <mmullins@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Hall <hall@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Song Liu <songliubraving@fb.com>
References: <20190531223735.4998-1-mmullins@fb.com>
 <6c6a4d47-796a-20e2-eb12-503a00d1fa0b@iogearbox.net>
 <68841715-4d5b-6ad1-5241-4e7199dd63da@iogearbox.net>
 <05626702394f7b95273ab19fef30461677779333.camel@fb.com>
 <CAADnVQKAPTao3nE1AC5dvYtCKFhDHu9VeCnVE04TLjGpY6yANw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <70b9a1b2-c960-b810-96f9-1fb5f4a4061b@iogearbox.net>
Date:   Tue, 4 Jun 2019 01:48:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQKAPTao3nE1AC5dvYtCKFhDHu9VeCnVE04TLjGpY6yANw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25469/Mon Jun  3 09:59:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2019 01:27 AM, Alexei Starovoitov wrote:
> On Mon, Jun 3, 2019 at 3:59 PM Matt Mullins <mmullins@fb.com> wrote:
>>
>> If these are invariably non-nested, I can easily keep bpf_misc_sd when
>> I resubmit.  There was no technical reason other than keeping the two
>> codepaths as similar as possible.
>>
>> What resource gives you worry about doing this for the networking
>> codepath?
> 
> my preference would be to keep tracing and networking the same.
> there is already minimal nesting in networking and probably we see
> more when reuseport progs will start running from xdp and clsbpf
> 
>>> Aside from that it's also really bad to miss events like this as exporting
>>> through rb is critical. Why can't you have a per-CPU counter that selects a
>>> sample data context based on nesting level in tracing? (I don't see a discussion
>>> of this in your commit message.)
>>
>> This change would only drop messages if the same perf_event is
>> attempted to be used recursively (i.e. the same CPU on the same
>> PERF_EVENT_ARRAY map, as I haven't observed anything use index !=
>> BPF_F_CURRENT_CPU in testing).
>>
>> I'll try to accomplish the same with a percpu nesting level and
>> allocating 2 or 3 perf_sample_data per cpu.  I think that'll solve the
>> same problem -- a local patch keeping track of the nesting level is how
>> I got the above stack trace, too.
> 
> I don't think counter approach works. The amount of nesting is unknown.
> imo the approach taken in this patch is good.
> I don't see any issue when event_outputs will be dropped for valid progs.
> Only when user called the helper incorrectly without BPF_F_CURRENT_CPU.
> But that's an error anyway.

My main worry with this xchg() trick is that we'll miss to export crucial
data with the EBUSY bailing out especially given nesting could increase in
future as you state, so users might have a hard time debugging this kind of
issue if they share the same perf event map among these programs, and no
option to get to this data otherwise. Supporting nesting up to a certain
level would still be better than a lost event which is also not reported
through the usual way aka perf rb.
