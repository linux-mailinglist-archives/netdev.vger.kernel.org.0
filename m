Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D538A20E2
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 18:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfH2Q21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 12:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbfH2Q20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 12:28:26 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 570932339E
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 16:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567096105;
        bh=0isBkftQj9Gg9hHTU78TmmFxYE1h8gyYcnugZeuoeWU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wukAxiPZfDy3ZtcloWmqW3DP3qsMj7ePmtvvo298RNDdeLbjk+yDLMngxgGPkpG7c
         vjPBXqrWXSXrTSTm2apasNoSbqYSII8sJNLJ+d/TLdh6+maBvkzuBbiBfhlrys+I+/
         kLnPGK0ahX1LZHTZVcWXA4go+SOrk1UNPGmTEQi0=
Received: by mail-wm1-f51.google.com with SMTP id y135so2445288wmc.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 09:28:25 -0700 (PDT)
X-Gm-Message-State: APjAAAUE54dSRNL2hsp2yrMqOqe2gvoVI0kMBzwVL/uWzGj6P3vKvnHp
        drFLXU/lSCzn2mRMwuZrU9Ktxr5OqGYOIl/luZuhMA==
X-Google-Smtp-Source: APXvYqw4AFPdrT5RzNU6kJNbmC7DZNh9sfduGZL2/yjx0+ctJaAvdCV/NlCBgqiaCkyDGXTO5nK7NXnSodHqigUTJa8=
X-Received: by 2002:a05:600c:22d7:: with SMTP id 23mr13191080wmg.0.1567096103873;
 Thu, 29 Aug 2019 09:28:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190829051253.1927291-1-ast@kernel.org> <536636ad-0baf-31e9-85fe-2591b65068df@iogearbox.net>
In-Reply-To: <536636ad-0baf-31e9-85fe-2591b65068df@iogearbox.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 29 Aug 2019 09:28:12 -0700
X-Gmail-Original-Message-ID: <CALCETrWFeAXjZEiTZJjansqCLLO3OK=Vf+qeRh48akMjf34Ctw@mail.gmail.com>
Message-ID: <CALCETrWFeAXjZEiTZJjansqCLLO3OK=Vf+qeRh48akMjf34Ctw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and CAP_TRACING
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Aug 29, 2019, at 8:47 AM, Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>
>> On 8/29/19 7:12 AM, Alexei Starovoitov wrote:
>> [...]
>>  +/*
>> + * CAP_BPF allows the following BPF operations:
>> + * - Loading all types of BPF programs
>> + * - Creating all types of BPF maps except:
>> + *    - stackmap that needs CAP_TRACING
>> + *    - devmap that needs CAP_NET_ADMIN
>> + *    - cpumap that needs CAP_SYS_ADMIN
>> + * - Advanced verifier features
>> + *   - Indirect variable access
>> + *   - Bounded loops
>> + *   - BPF to BPF function calls
>> + *   - Scalar precision tracking
>> + *   - Larger complexity limits
>> + *   - Dead code elimination
>> + *   - And potentially other features
>> + * - Use of pointer-to-integer conversions in BPF programs
>> + * - Bypassing of speculation attack hardening measures
>> + * - Loading BPF Type Format (BTF) data
>> + * - Iterate system wide loaded programs, maps, BTF objects
>> + * - Retrieve xlated and JITed code of BPF programs
>> + * - Access maps and programs via id
>> + * - Use bpf_spin_lock() helper
>
> This is still very wide. Consider following example: app has CAP_BPF +
> CAP_NET_ADMIN. Why can't we in this case *only* allow loading networking
> related [plus generic] maps and programs? If it doesn't have CAP_TRACING,
> what would be a reason to allow loading it? Same vice versa. There are
> some misc program types like the infraread stuff, but they could continue
> to live under [CAP_BPF +] CAP_SYS_ADMIN as fallback. I think categorizing
> a specific list of prog and map types might be more clear than disallowin=
g
> some helpers like below (e.g. why choice of bpf_probe_read() but not
> bpf_probe_write_user() etc).

Wow, I didn=E2=80=99t notice that bpf_probe_write_user() existed. That shou=
ld
need something like CAP_PTRACE or CAP_SYS_ADMIN.

I'm starting to think that something like this:

https://lore.kernel.org/bpf/968f3551247a43e1104b198f2e58fb0595d425e7.156504=
0372.git.luto@kernel.org/

should maybe be finished before CAP_BPF happens at all.  It really
looks like the bpf operations that need privilege need to get fully
catalogued and dealt with rather than just coming up with a new
capability that covers a huge swath.

(bpf_probe_write_user() is also terminally broken on architectures
like s390x, but that's not really relevant right now.  I'm a bit
surprised it works on x86 with SMAP, though.)
