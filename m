Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6F7F22BD
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 00:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732564AbfKFXiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 18:38:03 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46572 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbfKFXiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 18:38:03 -0500
Received: by mail-lf1-f65.google.com with SMTP id 19so27492lft.13;
        Wed, 06 Nov 2019 15:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3FsspPdAx8GGQ7PlRVWn0MeB4amgg8OXjRJl49LtVq0=;
        b=IJAIUEbQwzfAgX6BwmV8dnF2q/Wh7j7GWXc197EBVfs5Vp+TuatiiUI8Aqu0H8+/CB
         hT6i558V3H/mjDxjjP21lfAN3G/oDfcEYF9zhThWV1RvuEcNChNqDmT9m4BH6joSC4GS
         JO4jsgyFoAH0vCpLUSEvbclU1rPgnRKidYu7wQRobXDcwNfGnk9PYxzzBjGOUhgneNyG
         Ca7c7M0UPlVkITPOK8cf/vYzNv6aR15eCS5kKxqw3+rO+FWV4XJ4t+uT3JxOiAhYQwP9
         d/U6tSGZnI14q+oJBXmeMbuog5+SJ6UWLKFjG2p46PHmw1OFSlsWHbNvGTSouz/8oAXA
         xU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3FsspPdAx8GGQ7PlRVWn0MeB4amgg8OXjRJl49LtVq0=;
        b=baD2ys2o0qQ0GoKGQBlOGJSjryXK7LiwQRi3c9E2lUeGX7mic9X0Vrs6zjMl+wIB2E
         lc0e2Yqii3bvTkUU+jyQocEIRvRVDm6gyY+METRc8D65kyHxIqq6a6629nH8G6jSxNlg
         x7v7vXn+RUsRopB6b+JREkMumqbNeyzatcKzj1aRyYEcNGpRK5PSAH3aR2R7INvChAAu
         utQbSk56mgEELf+53wtk/x20iVrtN/aBGHmfq7OluLCrjP3cWVtQNXkRPJfw7V/5SCN4
         w9WDfTHuBJ0XRtMHlkVXq6q3gEIlRRNH9+7nrEKxIUJAK/9YVezhchDmr4T2V4c2m6ga
         GP9Q==
X-Gm-Message-State: APjAAAWtb4U6oPIZC1vC/wu+HBiI/h28BXToulzGKMAXHwoyNSMX1CVw
        niWn7R68d/7H+vGmuCX+lW+P8JdDv8LVhtHtKcc=
X-Google-Smtp-Source: APXvYqyC9616NNMDTB6Bz6B/n4Yr1+Lph18VghyKHwb8qZ3omB0a5929XK5b3cC3SOfuDfIHcqHELq/cC5v1OMdZxyA=
X-Received: by 2002:ac2:5453:: with SMTP id d19mr21495lfn.181.1573083480756;
 Wed, 06 Nov 2019 15:38:00 -0800 (PST)
MIME-Version: 1.0
References: <20191106231210.3615828-1-kafai@fb.com>
In-Reply-To: <20191106231210.3615828-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 6 Nov 2019 15:37:49 -0800
Message-ID: <CAADnVQLv+QjNmaLhuesjbtDFGfEiqxjMJgRf1mH2OeSfwAvskw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/2] bpf: Add array support to btf_struct_access
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 3:12 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This series adds array support to btf_struct_access().
> Please see individual patch for details.
>
> v2:
> - Fix a divide-by-zero when there is empty array in
>   a struct (e.g. "__u8 __cloned_offset[0];" in skbuff)
> - Add 'static' to a global var in prog_tests/kfree_skb.c

still something wrong:
sysctl net.core.bpf_jit_enable=0
 ./test_progs -n 11
libbpf: failed to guess program type based on ELF section name 'test1'
libbpf: supported section(type) names are: socket kprobe/ uprobe/
kretprobe/ uretprobe/ classifier action tracepoint/ tp/
raw_tracepoint/ raw_tp/ tp_btf/ xdp perf_event lwt_in lwt_out lwt_xmit
lwt_seg6local cgroup_skb/ingress cgroup_skb/t
test_kfree_skb:PASS:prog_load sched cls 0 nsec
test_kfree_skb:PASS:prog_load raw tp 0 nsec
test_kfree_skb:PASS:find_prog 0 nsec
test_kfree_skb:PASS:attach_raw_tp 0 nsec
test_kfree_skb:PASS:find_perf_buf_map 0 nsec
test_kfree_skb:PASS:perf_buf__new 0 nsec
test_kfree_skb:PASS:ipv6 5219 nsec
on_sample:PASS:check_size 0 nsec
on_sample:PASS:check_meta_ifindex 0 nsec
on_sample:FAIL:check_cb8_0 cb8_0 0 != 84
test_kfree_skb:PASS:perf_buffer__poll 5219 nsec
test_kfree_skb:FAIL:114
#11 kfree_skb:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

Though it passes when JITed.
