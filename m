Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3700E195E32
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgC0TGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:06:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35479 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgC0TGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:06:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id f74so2621867wmf.0;
        Fri, 27 Mar 2020 12:06:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7zb6SiI4nmp02mKFSs20kViYZxVWw7k/43h6Rb3FzOw=;
        b=scYTpi7udt8u30tzoYr69lQrDCyRl4sRmmhaZAD+UT3xO33BnLujlrC7hakDD0fpDZ
         k8KMkewnhM7c3pKhVIMaFsCw6eV3DcQEt3XRNFN8pECueJ/4um5JPbVz1hJVNrMOFusT
         Rdx1Ktf9cW2p+vfCSMjy7g/zgq2PkdxkqA5HFBrBYL4auk5PCqii7c0vVvo+UIVmIe4e
         97WPpUlRaMf7+COMVFSwcRPVt7ACQ/cI8v5/7ClNoG18zRKKxhlXiVpYbVUv4RBZt+X/
         jV1QEHCAlrXCtHdwa+YUl530FUHRaNBumk7HIiIZzfgAyNStYJLI2o1qzAWHnKdFjfVL
         aZLg==
X-Gm-Message-State: ANhLgQ0CQo8y3E1VblKzm3olQI0PQYDmdyKfJ/XHN6dm53/BSqVKvS9y
        /32vhL+ZBjdWcrkJA9S7+y1UcElexpw2Mfe5rLs=
X-Google-Smtp-Source: ADFU+vt1ZOonYTOFiqM5IhLZKvBX+Tla7+io3O0gMz3oWvHWw4K0AwwY0PeZgBpM1U+tmmeHMhQX2U5V2mcp4hD7TYo=
X-Received: by 2002:a05:600c:2244:: with SMTP id a4mr123306wmm.74.1585335997021;
 Fri, 27 Mar 2020 12:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com> <CACAyw99Eeu+=yD8UKazRJcknZi3D5zMJ4n=FVsxXi63DwhdxYA@mail.gmail.com>
 <20200326210719.den5isqxntnoqhmv@ast-mbp>
In-Reply-To: <20200326210719.den5isqxntnoqhmv@ast-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Fri, 27 Mar 2020 12:06:24 -0700
Message-ID: <CAOftzPjyCNGEjBm4k3aKK+=AB-1STDbYbQK5sZbK6gTAo13XuA@mail.gmail.com>
Subject: Re: call for bpf progs. Re: [PATCHv2 bpf-next 5/5] selftests: bpf:
 add test for sk_assign
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Yonghong Song <yhs@fb.com>,
        Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 2:07 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> The second concern was pruning, but iirc the experiments were inconclusive.
> selftests/bpf only has old fb progs. Hence, I think, the step zero is for
> everyone to contribute their bpf programs written in C. If we have both
> cilium and cloudflare progs as selftests it will help a lot to guide such long
> lasting verifier decisions.

How would you like to handle program changes over time for this?

In Cilium community we periodically rebuild bpf-next VM images for
testing, and run every pull request against those images[0]. We also
test against specific older kernels, currently 4.9 and 4.19. This
allows us to get some sense for the impact of upstream changes while
developing Cilium features, but unfortunately doesn't allow everyone
using kernel selftests to get that feedback at least from the kernel
tree. We also have a verifier complexity test script where we compile
with the maximum number of features (to ideally generate the most
complex programs possible) then attempt to load all of the various
programs, and output the complexity count that the kernel reports[1,2]
which we can track over time.

However Cilium BPF programs are actively developing and even if we
merge these programs into the kernel tree, they will get out-of-date
quickly. Up until recently everything was verifying fine compiling
with LLVM7 and loading into bpf-next. Over the past month we started
noticing new issues not with the existing implementation, but in *new*
BPF features. As we increased complexity, our CI started failing
against bpf-next[3] while they loaded fine on older kernels. We ended
up mitigating by upgrading to LLVM-10. Long story short, there's
several moving parts; changing BPF program implementations, changing
the compiler toolchain, changing the kernel verifier. So my question
is basically, where's the line of responsibility for what the kernel
selftests are responsible for vs integration tests? How do we maintain
those over time as the BPF programs and compiler changes?

Do we just parachute the ~11K LoC of Cilium datapath into the kernel
tree once per cycle? Or should Cilium autobuild a verifier-test docker
image that kernel testing scripts can pull & run? Or would it be
helpful to have a separate GitHub project similar to libbpf that pulls
out kernel selftests, Cilium progs, fb progs, cloudflare progs, etc
automatically and centralizes a generic suite of BPF verifier
integration tests? Some other option?

[0] https://github.com/cilium/packer-ci-build
[1] https://github.com/cilium/cilium/blob/master/test/bpf/check-complexity.sh
[2] https://github.com/cilium/cilium/blob/master/test/bpf/verifier-test.sh
[3] https://github.com/cilium/cilium/issues/10517
