Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1ED6E9E59
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfJ3PHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:07:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:34926 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfJ3PHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:07:39 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <borkmann@iogearbox.net>)
        id 1iPpZN-000252-5l; Wed, 30 Oct 2019 16:07:33 +0100
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <borkmann@iogearbox.net>)
        id 1iPpZM-0003iH-So; Wed, 30 Oct 2019 16:07:32 +0100
Subject: Re: Compile build issues with samples/bpf/ again
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Sage <eric@sage.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191030114313.75b3a886@carbon>
 <CAJ+HfNhSsnFXFG1ZHYCxSmYjdv0bWWszToJzmH1KFn7G5CBavQ@mail.gmail.com>
 <20191030120551.68f8b67b@carbon>
From:   Daniel Borkmann <borkmann@iogearbox.net>
Message-ID: <d7d91ac5-a579-2ada-f96d-4239b8dc11b6@iogearbox.net>
Date:   Wed, 30 Oct 2019 16:07:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191030120551.68f8b67b@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: borkmann@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25618/Wed Oct 30 09:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19 12:05 PM, Jesper Dangaard Brouer wrote:
> On Wed, 30 Oct 2019 11:53:21 +0100
> Björn Töpel <bjorn.topel@gmail.com> wrote:
>> On Wed, 30 Oct 2019 at 11:43, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
[...]
>>> It is annoy to experience that simply building kernel tree samples/bpf/
>>> is broken as often as it is.  Right now, build is broken in both DaveM
>>> net.git and bpf.git.  ACME have some build fixes queued from Björn
>>> Töpel. But even with those fixes, build (for samples/bpf/task_fd_query_user.c)
>>> are still broken, as reported by Eric Sage (15 Oct), which I have a fix for.
>>
>> Hmm, something else than commit e55190f26f92 ("samples/bpf: Fix build
>> for task_fd_query_user.c")?
> 
> I see, you already fixed this... and it is in the bpf.git tree.
> 
> Then we only need your other fixes from ACME's tree.  I just cloned a
> fresh version of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
> to check that 'make M=samples/bpf' still fails.

Correct, the two fixes from Bjorn which made the test_attr__* optional were
taken by Arnaldo given the main change was under tools/perf/perf-sys.h. If
you cherry pick these ...

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=06f84d1989b7e58d56fa2e448664585749d41221
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=fce9501aec6bdda45ef3a5e365a5e0de7de7fe2d

... into bpf tree, then all builds fine. When Arnaldo took them, my assumption
was that these fixes would have been routed by him to Linus' tree, and upon
resync we pull them automatically into bpf tree again.

Look like didn't happen yet at this point, Arnaldo?

Build after cherry-pick:

root@foo1:~/bpf# make -j8 M=samples/bpf/ clean
   CLEAN   samples/bpf/
   CLEAN   samples/bpf//Module.symvers
root@foo1:~/bpf# make -j8 M=samples/bpf/
   AR      samples/bpf//built-in.a
make -C /root/bpf/samples/bpf/../../tools/lib/bpf/ RM='rm -rf' LDFLAGS= srctree=/root/bpf/samples/bpf/../../ O=
   HOSTCC  samples/bpf//bpf_load.o
   HOSTCC  samples/bpf//xdp1_user.o
   HOSTCC  samples/bpf//cookie_uid_helper_example.o
   HOSTCC  samples/bpf//test_lru_dist
   HOSTCC  samples/bpf//sock_example
   HOSTCC  samples/bpf//fds_example.o
   HOSTCC  samples/bpf//sockex1_user.o
   HOSTCC  samples/bpf//sockex2_user.o
   HOSTCC  samples/bpf//sockex3_user.o
   HOSTCC  samples/bpf//tracex1_user.o
   HOSTCC  samples/bpf//tracex2_user.o
   HOSTCC  samples/bpf//tracex3_user.o
   HOSTCC  samples/bpf//tracex4_user.o
   HOSTCC  samples/bpf//tracex5_user.o
   HOSTCC  samples/bpf//tracex6_user.o
   HOSTCC  samples/bpf//tracex7_user.o
   HOSTCC  samples/bpf//test_probe_write_user_user.o
   HOSTCC  samples/bpf//trace_output_user.o
   HOSTCC  samples/bpf//lathist_user.o
   HOSTCC  samples/bpf//offwaketime_user.o
   HOSTCC  samples/bpf//spintest_user.o
   HOSTCC  samples/bpf//map_perf_test_user.o
   HOSTCC  samples/bpf//test_overhead_user.o
   HOSTCC  samples/bpf//test_cgrp2_array_pin.o
   HOSTCC  samples/bpf//test_cgrp2_attach.o
   HOSTCC  samples/bpf//test_cgrp2_sock.o
   HOSTCC  samples/bpf//test_cgrp2_sock2.o
   HOSTLD  samples/bpf//xdp1
   HOSTLD  samples/bpf//xdp2
   HOSTCC  samples/bpf//xdp_router_ipv4_user.o
   HOSTCC  samples/bpf//test_current_task_under_cgroup_user.o
   HOSTCC  samples/bpf//trace_event_user.o
   HOSTCC  samples/bpf//sampleip_user.o
   HOSTCC  samples/bpf//tc_l2_redirect_user.o
   HOSTCC  samples/bpf//lwt_len_hist_user.o
   HOSTCC  samples/bpf//xdp_tx_iptunnel_user.o
   HOSTCC  samples/bpf//test_map_in_map_user.o
   HOSTLD  samples/bpf//per_socket_stats_example
   HOSTCC  samples/bpf//xdp_redirect_user.o
   HOSTCC  samples/bpf//xdp_redirect_map_user.o
   HOSTCC  samples/bpf//xdp_redirect_cpu_user.o
   HOSTCC  samples/bpf//xdp_monitor_user.o
   HOSTCC  samples/bpf//xdp_rxq_info_user.o
   HOSTCC  samples/bpf//syscall_tp_user.o
   HOSTCC  samples/bpf//cpustat_user.o
   HOSTCC  samples/bpf//xdp_adjust_tail_user.o
   HOSTCC  samples/bpf//xdpsock_user.o
   HOSTCC  samples/bpf//xdp_fwd_user.o
   HOSTCC  samples/bpf//task_fd_query_user.o
   HOSTCC  samples/bpf//xdp_sample_pkts_user.o
   HOSTCC  samples/bpf//ibumad_user.o
   HOSTCC  samples/bpf//hbm.o
   CLANG-bpf  samples/bpf//sockex1_kern.o
   CLANG-bpf  samples/bpf//sockex2_kern.o
   CLANG-bpf  samples/bpf//sockex3_kern.o
   CLANG-bpf  samples/bpf//tracex1_kern.o
   CLANG-bpf  samples/bpf//tracex2_kern.o
   CLANG-bpf  samples/bpf//tracex3_kern.o
   CLANG-bpf  samples/bpf//tracex4_kern.o
   CC      samples/bpf//syscall_nrs.s
   CLANG-bpf  samples/bpf//tracex6_kern.o
   CLANG-bpf  samples/bpf//tracex7_kern.o
   CLANG-bpf  samples/bpf//sock_flags_kern.o
   CLANG-bpf  samples/bpf//test_probe_write_user_kern.o
   CLANG-bpf  samples/bpf//trace_output_kern.o
   CLANG-bpf  samples/bpf//tcbpf1_kern.o
   CLANG-bpf  samples/bpf//tc_l2_redirect_kern.o
   CLANG-bpf  samples/bpf//lathist_kern.o
   CLANG-bpf  samples/bpf//offwaketime_kern.o
   CLANG-bpf  samples/bpf//spintest_kern.o
   CLANG-bpf  samples/bpf//map_perf_test_kern.o
   CLANG-bpf  samples/bpf//test_overhead_tp_kern.o
   CLANG-bpf  samples/bpf//test_overhead_raw_tp_kern.o
   CLANG-bpf  samples/bpf//test_overhead_kprobe_kern.o
   CLANG-bpf  samples/bpf//parse_varlen.o
   CLANG-bpf  samples/bpf//parse_simple.o
   CLANG-bpf  samples/bpf//parse_ldabs.o
   CLANG-bpf  samples/bpf//test_cgrp2_tc_kern.o
   CLANG-bpf  samples/bpf//xdp1_kern.o
   CLANG-bpf  samples/bpf//xdp2_kern.o
   CLANG-bpf  samples/bpf//xdp_router_ipv4_kern.o
   CLANG-bpf  samples/bpf//test_current_task_under_cgroup_kern.o
   CLANG-bpf  samples/bpf//trace_event_kern.o
   CLANG-bpf  samples/bpf//sampleip_kern.o
   CLANG-bpf  samples/bpf//lwt_len_hist_kern.o
   CLANG-bpf  samples/bpf//xdp_tx_iptunnel_kern.o
   CLANG-bpf  samples/bpf//test_map_in_map_kern.o
   CLANG-bpf  samples/bpf//tcp_synrto_kern.o
   CLANG-bpf  samples/bpf//tcp_rwnd_kern.o
   CLANG-bpf  samples/bpf//tcp_bufs_kern.o
   CLANG-bpf  samples/bpf//tcp_cong_kern.o
   CLANG-bpf  samples/bpf//tcp_iw_kern.o
   CLANG-bpf  samples/bpf//tcp_clamp_kern.o
   CLANG-bpf  samples/bpf//tcp_basertt_kern.o
   CLANG-bpf  samples/bpf//tcp_tos_reflect_kern.o
   CLANG-bpf  samples/bpf//tcp_dumpstats_kern.o
   CLANG-bpf  samples/bpf//xdp_redirect_kern.o
   CLANG-bpf  samples/bpf//xdp_redirect_map_kern.o
   CLANG-bpf  samples/bpf//xdp_redirect_cpu_kern.o
   CLANG-bpf  samples/bpf//xdp_monitor_kern.o
   CLANG-bpf  samples/bpf//xdp_rxq_info_kern.o
   CLANG-bpf  samples/bpf//xdp2skb_meta_kern.o
   CLANG-bpf  samples/bpf//syscall_tp_kern.o
   CLANG-bpf  samples/bpf//cpustat_kern.o
   CLANG-bpf  samples/bpf//xdp_adjust_tail_kern.o
   CLANG-bpf  samples/bpf//xdp_fwd_kern.o
   CLANG-bpf  samples/bpf//task_fd_query_kern.o
   CLANG-bpf  samples/bpf//xdp_sample_pkts_kern.o
   CLANG-bpf  samples/bpf//ibumad_kern.o
   CLANG-bpf  samples/bpf//hbm_out_kern.o
   CLANG-bpf  samples/bpf//hbm_edt_kern.o
   HOSTLD  samples/bpf//fds_example
   HOSTLD  samples/bpf//sockex1
   HOSTLD  samples/bpf//sockex2
   HOSTLD  samples/bpf//sockex3
   HOSTLD  samples/bpf//tracex1
   HOSTLD  samples/bpf//tracex2
   HOSTLD  samples/bpf//tracex3
   HOSTLD  samples/bpf//tracex4
   HOSTLD  samples/bpf//tracex5
   HOSTLD  samples/bpf//tracex6
   HOSTLD  samples/bpf//tracex7
   HOSTLD  samples/bpf//test_probe_write_user
   HOSTLD  samples/bpf//trace_output
   HOSTLD  samples/bpf//lathist
   HOSTLD  samples/bpf//offwaketime
   HOSTLD  samples/bpf//spintest
   HOSTLD  samples/bpf//map_perf_test
   HOSTLD  samples/bpf//test_overhead
   HOSTLD  samples/bpf//test_cgrp2_array_pin
   HOSTLD  samples/bpf//test_cgrp2_attach
   HOSTLD  samples/bpf//test_cgrp2_sock
   HOSTLD  samples/bpf//test_cgrp2_sock2
   HOSTLD  samples/bpf//xdp_router_ipv4
   HOSTLD  samples/bpf//test_current_task_under_cgroup
   HOSTLD  samples/bpf//trace_event
   HOSTLD  samples/bpf//sampleip
   HOSTLD  samples/bpf//tc_l2_redirect
   HOSTLD  samples/bpf//lwt_len_hist
   HOSTLD  samples/bpf//xdp_tx_iptunnel
   HOSTLD  samples/bpf//test_map_in_map
   HOSTLD  samples/bpf//xdp_redirect
   HOSTLD  samples/bpf//xdp_redirect_map
   HOSTLD  samples/bpf//xdp_redirect_cpu
   HOSTLD  samples/bpf//xdp_monitor
   HOSTLD  samples/bpf//xdp_rxq_info
   HOSTLD  samples/bpf//syscall_tp
   HOSTLD  samples/bpf//cpustat
   HOSTLD  samples/bpf//xdp_adjust_tail
   HOSTLD  samples/bpf//xdpsock
   HOSTLD  samples/bpf//xdp_fwd
   HOSTLD  samples/bpf//task_fd_query
   HOSTLD  samples/bpf//xdp_sample_pkts
   HOSTLD  samples/bpf//ibumad
   HOSTLD  samples/bpf//hbm
   UPD     samples/bpf//syscall_nrs.h
   CLANG-bpf  samples/bpf//tracex5_kern.o
   Building modules, stage 2.
   MODPOST 0 modules
root@foo1:~/bpf#
