Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A541CECB0
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgELF71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 01:59:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41902 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgELF70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:59:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5wFf3136196;
        Tue, 12 May 2020 05:59:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=el87G9AX5/V/KBiW2l/xDS9bfY+fmEvCw2blEwfatGE=;
 b=VtznbKbeeteRyzVv0QWSl2sclFXxFTIWQBsPG6asAj90HOrkSij2Pdi/OxcBnV+ABvKs
 +t2WIa3+tWfftSxWCyicplUZvBJxlUQhDgH7ZBgtYZ9Sc8SRacUNSwjyET62Uxw65XmZ
 E47Z8SKIca3b0qu7SMzVYaVz1HBegyr1fgZHp8RB8pGCZehCXzUGxDOD4u/2aiop4ssL
 JQd/E2AjeA2WZXu9dSE3UCxjSbhsI1rCIMpDGrURb5XCtjea+16kySOrRX6zs9JzYksO
 nOIQmQog6NC4YXlomlbuGcT46LwAvQiVoMHF0zL8AmG6Ru9hQYbNlYv00usTq87kDe7h Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30x3gmgwhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 05:59:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5rsA8051857;
        Tue, 12 May 2020 05:57:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30ydspr27r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 05:57:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C5v2Og028243;
        Tue, 12 May 2020 05:57:02 GMT
Received: from localhost.uk.oracle.com (/10.175.210.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 22:57:01 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     joe@perches.com, linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com,
        yhs@fb.com, kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 0/7] bpf, printk: add BTF-based type printing
Date:   Tue, 12 May 2020 06:56:38 +0100
Message-Id: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120052
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The printk family of functions support printing specific pointer types
using %p format specifiers (MAC addresses, IP addresses, etc).  For
full details see Documentation/core-api/printk-formats.rst.

This patchset proposes introducing a "print typed pointer" format
specifier "%pT"; the argument associated with the specifier is of
form "struct btf_ptr *" which consists of a .ptr value and a .type
value specifying a stringified type (e.g. "struct sk_buff") or
an .id value specifying a BPF Type Format (BTF) id identifying
the appropriate type it points to.

There is already support in kernel/bpf/btf.c for "show" functionality;
the changes here generalize that support from seq-file specific
verifier display to the more generic case and add another specific
use case; snprintf()-style rendering of type information to a
provided buffer.  This support is then used to support printk
rendering of types, but the intent is to provide a function
that might be useful in other in-kernel scenarios; for example:

- ftrace could possibly utilize the function to support typed
  display of function arguments by cross-referencing BTF function
  information to derive the types of arguments
- oops/panic messaging could extend the information displayed to
  dig into data structures associated with failing functions

The above potential use cases hint at a potential reply to
a reasonable objection that such typed display should be
solved by tracing programs, where the in kernel tracing records
data and the userspace program prints it out.  While this
is certainly the recommended approach for most cases, I
believe having an in-kernel mechanism would be valuable
also.

The function the printk() family of functions rely on
could potentially be used directly for other use cases
like ftrace where we might have the BTF ids of the
pointers we wish to display; its signature is as follows:

int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
                           char *buf, int len, u64 flags);

So if ftrace say had the BTF ids of the types of arguments,
we see that the above would allow us to convert the
pointer data into displayable form.

To give a flavour for what the printed-out data looks like,
here we use pr_info() to display a struct sk_buff *.

  struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);

  pr_info("%pT", BTF_PTR_TYPE(skb, "struct sk_buff"));

...gives us:

(struct sk_buff){
 .transport_header = (__u16)65535,
 .mac_header = (__u16)65535,
 .end = (sk_buff_data_t)192,
 .head = (unsigned char *)000000007524fd8b,
 .data = (unsigned char *)000000007524fd8b,
 .truesize = (unsigned int)768,
 .users = (refcount_t){
  .refs = (atomic_t){
   .counter = (int)1,
  },
 },
}

For bpf_trace_printk() a "struct __btf_ptr *" is used as
argument; see tools/testing/selftests/bpf/progs/netif_receive_skb.c
for example usage.

The hope is that this functionality will be useful for debugging,
and possibly help facilitate the cases mentioned above in the future.

Changes since v1:

- changed format to be more drgn-like, rendering indented type info
  along with type names by default (Alexei)
- zeroed values are omitted (Arnaldo) by default unless the '0'
  modifier is specified (Alexei)
- added an option to print pointer values without obfuscation.
  The reason to do this is the sysctls controlling pointer display
  are likely to be irrelevant in many if not most tracing contexts.
  Some questions on this in the outstanding questions section below...
- reworked printk format specifer so that we no longer rely on format
  %pT<type> but instead use a struct * which contains type information
  (Rasmus). This simplifies the printk parsing, makes use more dynamic
  and also allows specification by BTF id as well as name.
- ensured that BTF-specific printk code is bracketed by
  #if ENABLED(CONFIG_BTF_PRINTF)
- removed incorrect patch which tried to fix dereferencing of resolved
  BTF info for vmlinux; instead we skip modifiers for the relevant
  case (array element type/size determination) (Alexei).
- fixed issues with negative snprintf format length (Rasmus)
- added test cases for various data structure formats; base types,
  typedefs, structs, etc.
- tests now iterate through all typedef, enum, struct and unions
  defined for vmlinux BTF and render a version of the target dummy
  value which is either all zeros or all 0xff values; the idea is this
  exercises the "skip if zero" and "print everything" cases.
- added support in BPF for using the %pT format specifier in
  bpf_trace_printk()
- added BPF tests which ensure %pT format specifier use works (Alexei).

Outstanding issues

- currently %pT is not allowed in BPF programs when lockdown is active
  prohibiting BPF_READ; is that sufficient?
- do we want to further restrict the non-obfuscated pointer format
  specifier %pTx; for example blocking unprivileged BPF programs from
  using it?
- likely still need a better answer for vmlinux BTF initialization
  than the current approach taken; early boot initialization is one
  way to go here.
- may be useful to have a "print integers as hex" format modifier (Joe)

Important note: if running test_printf.ko - the version in the bpf-next
tree will induce a panic when running the fwnode_pointer() tests due
to a kobject issue; applying the patch in

https://lkml.org/lkml/2020/4/17/389

...resolved this issue for me.

Alan Maguire (7):
  bpf: provide function to get vmlinux BTF information
  bpf: move to generic BTF show support, apply it to seq files/strings
  checkpatch: add new BTF pointer format specifier
  printk: add type-printing %pT format specifier which uses BTF
  printk: extend test_printf to test %pT BTF-based format specifier
  bpf: add support for %pT format specifier for bpf_trace_printk()
    helper
  bpf: add tests for %pT format specifier

 Documentation/core-api/printk-formats.rst          |  15 +
 include/linux/bpf.h                                |   2 +
 include/linux/btf.h                                |  46 +-
 include/linux/printk.h                             |  16 +
 include/uapi/linux/bpf.h                           |  27 +-
 kernel/bpf/btf.c                                   | 794 ++++++++++++++++++---
 kernel/bpf/verifier.c                              |  18 +-
 kernel/trace/bpf_trace.c                           |  21 +-
 lib/Kconfig                                        |  16 +
 lib/test_printf.c                                  | 301 ++++++++
 lib/vsprintf.c                                     | 113 +++
 scripts/checkpatch.pl                              |   2 +-
 tools/include/uapi/linux/bpf.h                     |  27 +-
 .../selftests/bpf/prog_tests/trace_printk_btf.c    |  83 +++
 .../selftests/bpf/progs/netif_receive_skb.c        |  81 +++
 15 files changed, 1439 insertions(+), 123 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c

-- 
1.8.3.1

