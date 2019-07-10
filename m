Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB8264CD4
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 21:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfGJTcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 15:32:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:54536 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfGJTcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 15:32:32 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlIKI-0003Sy-QL; Wed, 10 Jul 2019 21:32:26 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlIKI-000Dcz-JO; Wed, 10 Jul 2019 21:32:26 +0200
Subject: Re: [PATCH V2 1/1 (was 0/1 by accident)] tools/dtrace: initial
 implementation of DTrace
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <clm@fb.com>, brendan.d.gregg@gmail.com,
        davem@davemloft.net
References: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
 <201907101542.x6AFgOO9012232@userv0121.oracle.com>
 <20190710181227.GA9925@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c7f15d1d-1696-4d95-1729-4c4e97bdc43e@iogearbox.net>
Date:   Wed, 10 Jul 2019 21:32:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190710181227.GA9925@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25506/Wed Jul 10 10:11:44 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Kris,

On 07/10/2019 08:12 PM, Kris Van Hees wrote:
> This patch's subject should of course be [PATCH V2 1/1] rather than 0/1.
> Sorry about that.
> 
> On Wed, Jul 10, 2019 at 08:42:24AM -0700, Kris Van Hees wrote:
>> This initial implementation of a tiny subset of DTrace functionality
>> provides the following options:
>>
>> 	dtrace [-lvV] [-b bufsz] -s script
>> 	    -b  set trace buffer size
>> 	    -l  list probes (only works with '-s script' for now)
>> 	    -s  enable or list probes for the specified BPF program
>> 	    -V  report DTrace API version
>>
>> The patch comprises quite a bit of code due to DTrace requiring a few
>> crucial components, even in its most basic form.
>>
>> The code is structured around the command line interface implemented in
>> dtrace.c.  It provides option parsing and drives the three modes of
>> operation that are currently implemented:
>>
>> 1. Report DTrace API version information.
>> 	Report the version information and terminate.
>>
>> 2. List probes in BPF programs.
>> 	Initialize the list of probes that DTrace recognizes, load BPF
>> 	programs, parse all BPF ELF section names, resolve them into
>> 	known probes, and emit the probe names.  Then terminate.
>>
>> 3. Load BPF programs and collect tracing data.
>> 	Initialize the list of probes that DTrace recognizes, load BPF
>> 	programs and attach them to their corresponding probes, set up
>> 	perf event output buffers, and start processing tracing data.
>>
>> This implementation makes extensive use of BPF (handled by dt_bpf.c) and
>> the perf event output ring buffer (handled by dt_buffer.c).  DTrace-style
>> probe handling (dt_probe.c) offers an interface to probes that hides the
>> implementation details of the individual probe types by provider (dt_fbt.c
>> and dt_syscall.c).  Probe lookup by name uses a hashtable implementation
>> (dt_hash.c).  The dt_utils.c code populates a list of online CPU ids, so
>> we know what CPUs we can obtain tracing data from.
>>
>> Building the tool is trivial because its only dependency (libbpf) is in
>> the kernel tree under tools/lib/bpf.  A simple 'make' in the tools/dtrace
>> directory suffices.
>>
>> The 'dtrace' executable needs to run as root because BPF programs cannot
>> be loaded by non-root users.
>>
>> Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
>> Reviewed-by: David Mc Lean <david.mclean@oracle.com>
>> Reviewed-by: Eugene Loh <eugene.loh@oracle.com>
>> ---
>> Changes in v2:
>>         - Use ring_buffer_read_head() and ring_buffer_write_tail() to
>>           avoid use of volatile.
>>         - Handle perf events that wrap around the ring buffer boundary.
>>         - Remove unnecessary PERF_EVENT_IOC_ENABLE.
>>         - Remove -I$(srctree)/tools/perf from KBUILD_HOSTCFLAGS since it
>>           is not actually used.
>>         - Use PT_REGS_PARM1(x), etc instead of my own macros.  Adding 
>>           PT_REGS_PARM6(x) in bpf_sample.c because we need to be able to
>>           support up to 6 arguments passed by registers.

Looks like you missed Brendan Gregg's prior feedback from v1 [0]. I haven't
seen a strong compelling argument for why this needs to reside in the kernel
tree given we also have all the other tracing tools and many of which also
rely on BPF such as bcc, bpftrace, ply, systemtap, sysdig, lttng to just name
a few. Given all the other tracers manage to live outside the kernel tree just
fine, so can dtrace as well; it's _not_ special in this regard in any way. It
will be tons of code in long term which is better off in its separate project,
and if we add tools/dtrace/, other projects will come as well asking for kernel
tree inclusion 'because tools/dtrace' is now there, too. While it totally makes
sense to extend the missing kernel bits where needed, it doesn't make sense to
have another big tracing project similar to perf in the tree. Therefore, I'm
not applying this patch, sorry.

Thanks,
Daniel

  [0] https://lore.kernel.org/bpf/CAE40pdeSfJBpbBHTmwz1xZ+MW02=kJ0krq1mN+EkjSLqf2GX_w@mail.gmail.com/

>> ---
>>  MAINTAINERS                |   6 +
>>  tools/dtrace/Makefile      |  87 ++++++++++
>>  tools/dtrace/bpf_sample.c  | 146 ++++++++++++++++
>>  tools/dtrace/dt_bpf.c      | 185 ++++++++++++++++++++
>>  tools/dtrace/dt_buffer.c   | 338 +++++++++++++++++++++++++++++++++++++
>>  tools/dtrace/dt_fbt.c      | 201 ++++++++++++++++++++++
>>  tools/dtrace/dt_hash.c     | 211 +++++++++++++++++++++++
>>  tools/dtrace/dt_probe.c    | 230 +++++++++++++++++++++++++
>>  tools/dtrace/dt_syscall.c  | 179 ++++++++++++++++++++
>>  tools/dtrace/dt_utils.c    | 132 +++++++++++++++
>>  tools/dtrace/dtrace.c      | 249 +++++++++++++++++++++++++++
>>  tools/dtrace/dtrace.h      |  13 ++
>>  tools/dtrace/dtrace_impl.h | 101 +++++++++++
>>  13 files changed, 2078 insertions(+)
>>  create mode 100644 tools/dtrace/Makefile
>>  create mode 100644 tools/dtrace/bpf_sample.c
>>  create mode 100644 tools/dtrace/dt_bpf.c
>>  create mode 100644 tools/dtrace/dt_buffer.c
>>  create mode 100644 tools/dtrace/dt_fbt.c
>>  create mode 100644 tools/dtrace/dt_hash.c
>>  create mode 100644 tools/dtrace/dt_probe.c
>>  create mode 100644 tools/dtrace/dt_syscall.c
>>  create mode 100644 tools/dtrace/dt_utils.c
>>  create mode 100644 tools/dtrace/dtrace.c
>>  create mode 100644 tools/dtrace/dtrace.h
>>  create mode 100644 tools/dtrace/dtrace_impl.h
