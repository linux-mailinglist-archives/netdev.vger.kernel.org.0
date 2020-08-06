Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0A623E2F3
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 22:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgHFUNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 16:13:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50684 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgHFUNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 16:13:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076EgAfH175366;
        Thu, 6 Aug 2020 14:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=sjtN+u4jC9Ht8p59OvrPGMDnS5TblL+US63NwcAFliM=;
 b=Tud5yzMzSuw2emWSk2OCx8u1UwSc386u0jjuO/cZzGMfI9l8TES49e8GmGIhA8z8pfJG
 t9faGKssXUXMv7yuAtLIGE0nnaICzVQKLsBcux60tQiEKwav+AQQ3POmaEGYAS3XBTK3
 ckiRhqQuWZeiANchkzIDGrvDtbrc2Do3vUeKnoGrz79uM2S6G7AyFublH8pJdf5MNcwx
 sa3UvTxlvMYQtp02NrOexYiNozqpRdJyOdl7br7Ojqy2C8AcJrNndd3qHg6nPjcvi9fg
 ao8PJhvWbd/Wu2tFH8F2jjWQ0OoUfmZgZ9If3JH7zaRPofNRD9R1WOElhkWBY7G9T1JX Jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32r6fxkcey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 14:42:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076EdFbP010286;
        Thu, 6 Aug 2020 14:42:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32p5gvh4rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 14:42:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 076EgcS4013941;
        Thu, 6 Aug 2020 14:42:38 GMT
Received: from localhost.uk.oracle.com (/10.175.182.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 07:42:38 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC PATCH bpf-next 0/4] bpf: add bpf-based bpf_trace_printk()-like support
Date:   Thu,  6 Aug 2020 15:42:21 +0100
Message-Id: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 clxscore=1011 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series attempts to provide a simple way for BPF programs (and in
future other consumers) to utilize BPF Type Format (BTF) information
to display kernel data structures in-kernel.  The use case this
functionality is applied to here is to support a bpf_trace_printk
trace event-based method of rendering type information.

There is already support in kernel/bpf/btf.c for "show" functionality;
the changes here generalize that support from seq-file specific
verifier display to the more generic case and add another specific
use case; rather than seq_printf()ing the show data, it is traced
using the bpf_trace_printk trace event.  Other future uses of the
show functionality could include a bpf_printk_btf() function which
printk()ed the data instead. Oops messaging in particular would
be an interesting application for such functionality.

The above potential use case hints at a potential reply to
a reasonable objection that such typed display should be
solved by tracing programs, where the in-kernel tracing records
data and the userspace program prints it out.  While this
is certainly the recommended approach for most cases, I
believe having an in-kernel mechanism would be valuable
also.  Critically in BPF programs it greatly simplifies
debugging and tracing of such data to invoking a one-line
helper.

One challenge raised in an earlier iteration of this work -
where the BTF printing was implemented as a printk() format
specifier - was that the amount of data printed per
printk() was large, and other format specifiers were far
simpler.  This patchset tackles this by instead displaying
data _as the data structure is traversed_, rathern than copying
it to a string for later display.  The problem in doing this
however is that such output can be intermixed with other
bpf_trace_printk events.  The solution pursued here is to
associate a trace ID with the bpf_trace_printk events.  For
now, the bpf_trace_printk() helper sets this trace ID to 0,
and bpf_trace_btf() can specify non-zero values.  This allows
a BPF program to coordinate with a user-space program which
creates a separate trace instance which filters trace events
based on trace ID, allowing for clean display without pollution
from other data sources.  Future work could enhance
bpf_trace_printk() to do this too, either via a new helper
or by smuggling a 32-bit trace id value into the "fmt_size"
argument (the latter might be problematic for 32-bit platforms
though, so a new helper might be preferred).

To aid in display the bpf_trace_btf() helper is passed a
"struct btf_ptr *" which specifies the data to be traced
(struct sk_buff * say),  the BTF id of the type (the BTF
id of "struct sk_buff") or a string representation of
the type ("struct sk_buff").  A flags field is also
present for future use.

Separately a number of flags control how the output is
rendered, see patch 3 for more details.

A snippet of output from printing "struct sk_buff *"
(see patch 3 for the full output) looks like this:

          <idle>-0     [023] d.s.  1825.778400: bpf_trace_printk: (struct sk_buff){
          <idle>-0     [023] d.s.  1825.778409: bpf_trace_printk:  (union){
          <idle>-0     [023] d.s.  1825.778410: bpf_trace_printk:   (struct){
          <idle>-0     [023] d.s.  1825.778412: bpf_trace_printk:    .prev = (struct sk_buff *)0x00000000b2a3df7e,
          <idle>-0     [023] d.s.  1825.778413: bpf_trace_printk:    (union){
          <idle>-0     [023] d.s.  1825.778414: bpf_trace_printk:     .dev = (struct net_device *)0x000000001658808b,
          <idle>-0     [023] d.s.  1825.778416: bpf_trace_printk:     .dev_scratch = (long unsigned int)18446628460391432192,
          <idle>-0     [023] d.s.  1825.778417: bpf_trace_printk:    },
          <idle>-0     [023] d.s.  1825.778417: bpf_trace_printk:   },
          <idle>-0     [023] d.s.  1825.778418: bpf_trace_printk:   .rbnode = (struct rb_node){
          <idle>-0     [023] d.s.  1825.778419: bpf_trace_printk:    .rb_right = (struct rb_node *)0x00000000b2a3df7e,
          <idle>-0     [023] d.s.  1825.778420: bpf_trace_printk:    .rb_left = (struct rb_node *)0x000000001658808b,
          <idle>-0     [023] d.s.  1825.778420: bpf_trace_printk:   },
          <idle>-0     [023] d.s.  1825.778421: bpf_trace_printk:   .list = (struct list_head){
          <idle>-0     [023] d.s.  1825.778422: bpf_trace_printk:    .prev = (struct list_head *)0x00000000b2a3df7e,
          <idle>-0     [023] d.s.  1825.778422: bpf_trace_printk:   },
          <idle>-0     [023] d.s.  1825.778422: bpf_trace_printk:  },
          <idle>-0     [023] d.s.  1825.778426: bpf_trace_printk:  .len = (unsigned int)168,
          <idle>-0     [023] d.s.  1825.778427: bpf_trace_printk:  .mac_len = (__u16)14,

Changes since v3:

- Moved to RFC since the approach is different (and bpf-next is
  closed)
- Rather than using a printk() format specifier as the means
  of invoking BTF-enabled display, a dedicated BPF helper is
  used.  This solves the issue of printk() having to output
  large amounts of data using a complex mechanism such as
  BTF traversal, but still provides a way for the display of
  such data to be achieved via BPF programs.  Future work could
  include a bpf_printk_btf() function to invoke display via
  printk() where the elements of a data structure are printk()ed
  one at a time.  Thanks to Petr Mladek, Andy Shevchenko and
  Rasmus Villemoes who took time to look at the earlier printk()
  format-specifier-focused version of this and provided feedback
  clarifying the problems with that approach.
- Added trace id to the bpf_trace_printk events as a means of
  separating output from standard bpf_trace_printk() events,
  ensuring it can be easily parsed by the reader.
- Added bpf_trace_btf() helper tests which do simple verification
  of the various display options.

Changes since v2:

- Alexei and Yonghong suggested it would be good to use
  probe_kernel_read() on to-be-shown data to ensure safety
  during operation.  Safe copy via probe_kernel_read() to a
  buffer object in "struct btf_show" is used to support
  this.  A few different approaches were explored
  including dynamic allocation and per-cpu buffers. The
  downside of dynamic allocation is that it would be done
  during BPF program execution for bpf_trace_printk()s using
  %pT format specifiers. The problem with per-cpu buffers
  is we'd have to manage preemption and since the display
  of an object occurs over an extended period and in printk
  context where we'd rather not change preemption status,
  it seemed tricky to manage buffer safety while considering
  preemption.  The approach of utilizing stack buffer space
  via the "struct btf_show" seemed like the simplest approach.
  The stack size of the associated functions which have a
  "struct btf_show" on their stack to support show operation
  (btf_type_snprintf_show() and btf_type_seq_show()) stays
  under 500 bytes. The compromise here is the safe buffer we
  use is small - 256 bytes - and as a result multiple
  probe_kernel_read()s are needed for larger objects. Most
  objects of interest are smaller than this (e.g.
  "struct sk_buff" is 224 bytes), and while task_struct is a
  notable exception at ~8K, performance is not the priority for
  BTF-based display. (Alexei and Yonghong, patch 2).
- safe buffer use is the default behaviour (and is mandatory
  for BPF) but unsafe display - meaning no safe copy is done
  and we operate on the object itself - is supported via a
  'u' option.
- pointers are prefixed with 0x for clarity (Alexei, patch 2)
- added additional comments and explanations around BTF show
  code, especially around determining whether objects such
  zeroed. Also tried to comment safe object scheme used. (Yonghong,
  patch 2)
- added late_initcall() to initialize vmlinux BTF so that it would
  not have to be initialized during printk operation (Alexei,
  patch 5)
- removed CONFIG_BTF_PRINTF config option as it is not needed;
  CONFIG_DEBUG_INFO_BTF can be used to gate test behaviour and
  determining behaviour of type-based printk can be done via
  retrieval of BTF data; if it's not there BTF was unavailable
  or broken (Alexei, patches 4,6)
- fix bpf_trace_printk test to use vmlinux.h and globals via
  skeleton infrastructure, removing need for perf events
  (Andrii, patch 8)

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
- removed incorrect patch which tried to fix dereferencing of resolved
  BTF info for vmlinux; instead we skip modifiers for the relevant
  case (array element type determination) (Alexei).
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





Alan Maguire (4):
  bpf: provide function to get vmlinux BTF information
  bpf: make BTF show support generic, apply to seq
    files/bpf_trace_printk
  bpf: add bpf_trace_btf helper
  selftests/bpf: add bpf_trace_btf helper tests

 include/linux/bpf.h                                |   5 +
 include/linux/btf.h                                |  38 +
 include/uapi/linux/bpf.h                           |  63 ++
 kernel/bpf/btf.c                                   | 962 ++++++++++++++++++---
 kernel/bpf/core.c                                  |   5 +
 kernel/bpf/helpers.c                               |   4 +
 kernel/bpf/verifier.c                              |  18 +-
 kernel/trace/bpf_trace.c                           | 121 ++-
 kernel/trace/bpf_trace.h                           |   6 +-
 scripts/bpf_helpers_doc.py                         |   2 +
 tools/include/uapi/linux/bpf.h                     |  63 ++
 tools/testing/selftests/bpf/prog_tests/trace_btf.c |  45 +
 .../selftests/bpf/progs/netif_receive_skb.c        |  43 +
 13 files changed, 1257 insertions(+), 118 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c

-- 
1.8.3.1

