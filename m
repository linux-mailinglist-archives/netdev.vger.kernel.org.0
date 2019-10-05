Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D015CC812
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 07:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfJEFDz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Oct 2019 01:03:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32862 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727117AbfJEFDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 01:03:54 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x954xZID015206
        for <netdev@vger.kernel.org>; Fri, 4 Oct 2019 22:03:53 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ve548c1nf-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 22:03:53 -0700
Received: from 2401:db00:2120:80e1:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Oct 2019 22:03:20 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 65DC176091D; Fri,  4 Oct 2019 22:03:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 00/10] bpf: revolutionize bpf tracing
Date:   Fri, 4 Oct 2019 22:03:04 -0700
Message-ID: <20191005050314.1114330-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-05_02:2019-10-03,2019-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=1 spamscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910050044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revolutionize bpf tracing and bpf C programming.
C language allows any pointer to be typecasted to any other pointer
or convert integer to a pointer.
Though bpf verifier is operating at assembly level it has strict type
checking for fixed number of types.
Known types are defined in 'enum bpf_reg_type'.
For example:
PTR_TO_FLOW_KEYS is a pointer to 'struct bpf_flow_keys'
PTR_TO_SOCKET is a pointer to 'struct bpf_sock',
and so on.

When it comes to bpf tracing there are no types to track.
bpf+kprobe receives 'struct pt_regs' as input.
bpf+raw_tracepoint receives raw kernel arguments as an array of u64 values.
It was up to bpf program to interpret these integers.
Typical tracing program looks like:
int bpf_prog(struct pt_regs *ctx)
{
    struct net_device *dev;
    struct sk_buff *skb;
    int ifindex;

    skb = (struct sk_buff *) ctx->di;
    bpf_probe_read(&dev, sizeof(dev), &skb->dev);
    bpf_probe_read(&ifindex, sizeof(ifindex), &dev->ifindex);
}
Addressing mistakes will not be caught by C compiler or by the verifier.
The program above could have typecasted ctx->si to skb and page faulted
on every bpf_probe_read().
bpf_probe_read() allows reading any address and suppresses page faults.
Typical program has hundreds of bpf_probe_read() calls to walk
kernel data structures.
Not only tracing program would be slow, but there was always a risk
that bpf_probe_read() would read mmio region of memory and cause
unpredictable hw behavior.

With introduction of Compile Once Run Everywhere technology in libbpf
and in LLVM and BPF Type Format (BTF) the verifier is finally ready
for the next step in program verification.
Now it can use in-kernel BTF to type check bpf assembly code.

Equivalent program will look like:
struct trace_kfree_skb {
    struct sk_buff *skb;
    void *location;
};
SEC("raw_tracepoint/kfree_skb")
int trace_kfree_skb(struct trace_kfree_skb* ctx)
{
    struct sk_buff *skb = ctx->skb;
    struct net_device *dev;
    int ifindex;

    __builtin_preserve_access_index(({
        dev = skb->dev;
        ifindex = dev->ifindex;
    }));
}

These patches teach bpf verifier to recognize kfree_skb's first argument
as 'struct sk_buff *' because this is what kernel C code is doing.
The bpf program cannot 'cheat' and say that the first argument
to kfree_skb raw_tracepoint is some other type.
The verifier will catch such type mismatch between bpf program
assumption of kernel code and the actual type in the kernel.

Furthermore skb->dev access is type tracked as well.
The verifier can see which field of skb is being read
in bpf assembly. It will match offset to type.
If bpf program has code:
struct net_device *dev = (void *)skb->len;
C compiler will not complain and generate bpf assembly code,
but the verifier will recognize that integer 'len' field
is being accessed at offsetof(struct sk_buff, len) and will reject
further dereference of 'dev' variable because it contains
integer value instead of a pointer.

Such sophisticated type tracking allows calling networking
bpf helpers from tracing programs.
This patchset allows calling bpf_skb_event_output() that dumps
skb data into perf ring buffer.
It greatly improves observability.
Now users can not only see packet lenth of the skb
about to be freed in kfree_skb() kernel function, but can
dump it to user space via perf ring buffer using bpf helper
that was previously available only to TC and socket filters.
See patch 10 for full example.

The end result is safer and faster bpf tracing.
Safer - because direct calls to bpf_probe_read() are disallowed and
arbitrary addresses cannot be read.
Faster - because normal loads are used to walk kernel data structures
instead of bpf_probe_read() calls.
Note that such loads can page fault and are supported by
hidden bpf_probe_read() in interpreter and via exception table
if program is JITed.

See patches for details.

Alexei Starovoitov (10):
  bpf: add typecast to raw_tracepoints to help BTF generation
  bpf: add typecast to bpf helpers to help BTF generation
  bpf: process in-kernel BTF
  libbpf: auto-detect btf_id of raw_tracepoint
  bpf: implement accurate raw_tp context access via BTF
  bpf: add support for BTF pointers to interpreter
  bpf: add support for BTF pointers to x86 JIT
  bpf: check types of arguments passed into helpers
  bpf: disallow bpf_probe_read[_str] helpers
  selftests/bpf: add kfree_skb raw_tp test

 arch/x86/net/bpf_jit_comp.c                   |  96 +++++-
 include/linux/bpf.h                           |  21 +-
 include/linux/bpf_verifier.h                  |   6 +-
 include/linux/btf.h                           |   1 +
 include/linux/extable.h                       |  10 +
 include/linux/filter.h                        |   6 +-
 include/trace/bpf_probe.h                     |   3 +-
 include/uapi/linux/bpf.h                      |   3 +-
 kernel/bpf/btf.c                              | 318 ++++++++++++++++++
 kernel/bpf/core.c                             |  39 ++-
 kernel/bpf/verifier.c                         | 125 ++++++-
 kernel/extable.c                              |   2 +
 kernel/trace/bpf_trace.c                      |  10 +-
 net/core/filter.c                             |  15 +-
 tools/include/uapi/linux/bpf.h                |   3 +-
 tools/lib/bpf/libbpf.c                        |  16 +
 tools/testing/selftests/bpf/bpf_helpers.h     |   4 +
 .../selftests/bpf/prog_tests/kfree_skb.c      |  90 +++++
 tools/testing/selftests/bpf/progs/kfree_skb.c |  76 +++++
 19 files changed, 828 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfree_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfree_skb.c

-- 
2.20.0

