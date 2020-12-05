Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F7C2CF807
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 01:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgLEAh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 19:37:59 -0500
Received: from www62.your-server.de ([213.133.104.62]:40872 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgLEAh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 19:37:59 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1klLZc-0002yZ-00; Sat, 05 Dec 2020 01:37:16 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1klLZb-0009Y1-OG; Sat, 05 Dec 2020 01:37:15 +0100
Subject: Re: [PATCH bpf-next v9 00/34] bpf: switch to memcg-based memory
 accounting
To:     Roman Gushchin <guro@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
 <CAADnVQJThW0_5jJ=0ejjc3jh+w9_qzctqfZ-GvJrNQcKiaGYEQ@mail.gmail.com>
 <20201203032645.GB1568874@carbon.DHCP.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6abdd146-c584-9c66-261d-d7d39ff3f499@iogearbox.net>
Date:   Sat, 5 Dec 2020 01:37:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201203032645.GB1568874@carbon.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26008/Fri Dec  4 23:08:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/20 4:26 AM, Roman Gushchin wrote:
> On Wed, Dec 02, 2020 at 06:54:46PM -0800, Alexei Starovoitov wrote:
>> On Tue, Dec 1, 2020 at 1:59 PM Roman Gushchin <guro@fb.com> wrote:
>>>
>>> 5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
>>>     a function to "explain" this case for users.
>> ...
>>> v9:
>>>    - always charge the saved memory cgroup, by Daniel, Toke and Alexei
>>>    - added bpf_map_kzalloc()
>>>    - rebase and minor fixes
>>
>> This looks great. Applied.
> 
> Thanks!
> 
>> Please follow up with a change to libbpf's pr_perm_msg().
>> That helpful warning should stay for old kernels, but it would be
>> misleading for new kernels.
>> libbpf probably needs a feature check to make this warning conditional.
> 
> I think we've discussed it several months ago and at that time we didn't
> find a good way to check this feature. I'll think again, but if somebody
> has any ideas here, I'll appreciate a lot.

Hm, bit tricky, agree .. given we only throw the warning in pr_perm_msg() for
non-root and thus probing options are also limited, otherwise just probing for
a helper that was added in this same cycle would have been good enough as a
simple heuristic. I wonder if it would make sense to add some hint inside the
bpf_{prog,map}_show_fdinfo() to indicate that accounting with memcg is enabled
for the prog/map one way or another? Not just for the sake of pr_perm_msg(), but
in general for apps to stop messing with rlimit at this point. Maybe also bpftool
feature probe could be extended to indicate that as well (e.g. the json output
can be fed into Go natively).
