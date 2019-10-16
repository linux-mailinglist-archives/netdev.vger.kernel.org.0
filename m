Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13007D8655
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390910AbfJPDZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:25:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3468 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388957AbfJPDZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:25:09 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G3LkMZ030948
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:08 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnf1wkmkh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:08 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 15 Oct 2019 20:25:06 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id CDB58760F32; Tue, 15 Oct 2019 20:25:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 00/11] bpf: revolutionize bpf tracing
Date:   Tue, 15 Oct 2019 20:24:54 -0700
Message-ID: <20191016032505.2089704-1-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_01:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 clxscore=1034 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=1 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160027
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2->v3:
- while trying to adopt btf-based tracing in production service realized
  that disabling bpf_probe_read() was premature. The real tracing program
  needs to see much more than this type safe tracking can provide.
  With these patches the verifier will be able to see that skb->data
  is a pointer to 'u8 *', but it cannot possibly know how many bytes
  of it is readable. Hence bpf_probe_read() is necessary to do basic
  packet reading from tracing program. Some helper can be introduced to
  solve this particular problem, but there are other similar structures.
  Another issue is bitfield reading. The support for bitfields
  is coming to llvm. libbpf will be supporting it eventually as well,
  but there will be corner cases where bpf_probe_read() is necessary.
  The long term goal is still the same: get rid of probe_read eventually.
- fixed build issue with clang reported by Nathan Chancellor.
- addressed a ton of comments from Andrii.
  bitfields and arrays are explicitly unsupported in btf-based tracking.
  This will be improved in the future.
  Right now the verifier is more strict than necessary.
  In some cases it can fall back to 'scalar' instead of rejecting
  the program, but rejection today allows to make better decisions
  in the future.
- adjusted testcase to demo bitfield and skb->data reading.

v1->v2:
- addressed feedback from Andrii and Eric. Thanks a lot for review!
- added missing check at raw_tp attach time.
- Andrii noticed that expected_attach_type cannot be reused.
  Had to introduce new field to bpf_attr.
- cleaned up logging nicely by introducing bpf_log() helper.
- rebased.

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
Safer - because type safe direct load can be used most of the time
instead of bpf_probe_read().
Faster - because direct loads are used to walk kernel data structures
instead of bpf_probe_read() calls.
Note that such loads can page fault and are supported by
hidden bpf_probe_read() in interpreter and via exception table
if program is JITed.

See patches for details.

Alexei Starovoitov (11):
  bpf: add typecast to raw_tracepoints to help BTF generation
  bpf: add typecast to bpf helpers to help BTF generation
  bpf: process in-kernel BTF
  bpf: add attach_btf_id attribute to program load
  libbpf: auto-detect btf_id of BTF-based raw_tracepoints
  bpf: implement accurate raw_tp context access via BTF
  bpf: attach raw_tp program with BTF via type name
  bpf: add support for BTF pointers to interpreter
  bpf: add support for BTF pointers to x86 JIT
  bpf: check types of arguments passed into helpers
  selftests/bpf: add kfree_skb raw_tp test

 arch/x86/net/bpf_jit_comp.c                   |  97 +++++-
 include/linux/bpf.h                           |  39 ++-
 include/linux/bpf_verifier.h                  |   8 +-
 include/linux/btf.h                           |   1 +
 include/linux/extable.h                       |  10 +
 include/linux/filter.h                        |   6 +-
 include/trace/bpf_probe.h                     |   3 +-
 include/uapi/linux/bpf.h                      |  28 +-
 kernel/bpf/btf.c                              | 329 +++++++++++++++++-
 kernel/bpf/core.c                             |  39 ++-
 kernel/bpf/syscall.c                          |  88 +++--
 kernel/bpf/verifier.c                         | 161 ++++++++-
 kernel/extable.c                              |   2 +
 kernel/trace/bpf_trace.c                      |   6 +-
 net/core/filter.c                             |  15 +-
 tools/include/uapi/linux/bpf.h                |  28 +-
 tools/lib/bpf/bpf.c                           |   3 +
 tools/lib/bpf/libbpf.c                        |  38 +-
 .../selftests/bpf/prog_tests/kfree_skb.c      |  89 +++++
 tools/testing/selftests/bpf/progs/kfree_skb.c | 103 ++++++
 20 files changed, 1023 insertions(+), 70 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfree_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfree_skb.c

-- 
2.17.1

