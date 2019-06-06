Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD34237F40
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfFFVJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:09:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:42620 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFVJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:09:26 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYzdP-0008MU-Rg; Thu, 06 Jun 2019 23:09:19 +0200
Received: from [178.197.249.21] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYzdP-000XK7-KF; Thu, 06 Jun 2019 23:09:19 +0200
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Cc:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, yhs@fb.com
References: <20190531202132.379386-1-andriin@fb.com>
 <20190531202132.379386-7-andriin@fb.com> <20190531212835.GA31612@mini-arch>
 <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch>
 <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch>
 <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
 <20190604042902.GA2014@mini-arch> <20190604134538.GB2014@mini-arch>
 <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3ff873a8-a1a6-133b-fa20-ad8bc1d347ed@iogearbox.net>
Date:   Thu, 6 Jun 2019 23:09:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25472/Thu Jun  6 10:09:59 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2019 07:31 PM, Andrii Nakryiko wrote:
> On Tue, Jun 4, 2019 at 6:45 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>> On 06/03, Stanislav Fomichev wrote:
>>>> BTF is mandatory for _any_ new feature.
>>> If something is easy to support without asking everyone to upgrade to
>>> a bleeding edge llvm, why not do it?
>>> So much for backwards compatibility and flexibility.
>>>
>>>> It's for introspection and debuggability in the first place.
>>>> Good debugging is not optional.
>>> Once llvm 8+ is everywhere, sure, but we are not there yet (I'm talking
>>> about upstream LTS distros like ubuntu/redhat).
>> But putting this aside, one thing that I didn't see addressed in the
>> cover letter is: what is the main motivation for the series?
>> Is it to support iproute2 map definitions (so cilium can switch to libbpf)?
> 
> In general, the motivation is to arrive at a way to support
> declaratively defining maps in such a way, that:
> - captures type information (for debuggability/introspection) in
> coherent and hard-to-screw-up way;
> - allows to support missing useful features w/ good syntax (e.g.,
> natural map-in-map case vs current completely manual non-declarative
> way for libbpf);
> - ultimately allow iproute2 to use libbpf as unified loader (and thus
> the need to support its existing features, like
> BPF_MAP_TYPE_PROG_ARRAY initialization, pinning, map-in-map);

Thanks for working on this & sorry for jumping in late! Generally, I like
the approach of using BTF to make sense out of the individual members and
to have extensibility, so overall I think it's a step in the right direction.
Going back to the example where others complained that the k/v NULL
initialization feels too much magic from a C pov:

struct {
	int type;
	int max_entries;
	int *key;
	struct my_value *value;
} my_map SEC(".maps") = {
	.type = BPF_MAP_TYPE_ARRAY,
	.max_entries = 16,
};

Given LLVM is in charge of emitting BTF plus given gcc/clang seem /both/
to support *target* specific attributes [0], how about something along these
lines where the type specific info is annotated as a variable BPF target
attribute, like:

struct {
	int type;
	int max_entries;
} my_map __attribute__((map(int,struct my_value))) = {
	.type = BPF_MAP_TYPE_ARRAY,
	.max_entries = 16,
};

Of course this would need BPF backend support, but at least that approach
would be more C like. Thus this would define types where we can automatically
derive key/val sizes etc. The SEC() could be dropped as well as map attribute
would imply it for LLVM to do the right thing underneath. The normal/actual members
from the struct has a base set of well-known names that are minimally required
but there could be custom stuff as well where libbpf would query some user
defined callback that can handle these. Anyway, main point, what do you think
about the __attribute__ approach instead? I think this feels cleaner to me at
least iff feasible.

Thanks,
Daniel

  [0] https://clang.llvm.org/docs/AttributeReference.html
      https://gcc.gnu.org/onlinedocs/gcc/Variable-Attributes.html

> The only missing feature that can be supported reasonably with
> bpf_map_def is pinning (as it's just another int field), but all the
> other use cases requires awkward approach of matching arbitrary IDs,
> which feels like a bad way forward.
> 
>> If that's the case, maybe explicitly focus on that? Once we have
>> proof-of-concept working for iproute2 mode, we can extend it to everything.

