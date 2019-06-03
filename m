Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB42330A3
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfFCNIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:08:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:45050 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbfFCNIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:08:50 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hXmhf-0000SK-K6; Mon, 03 Jun 2019 15:08:43 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hXmhf-0007wD-54; Mon, 03 Jun 2019 15:08:43 +0200
Subject: Re: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
To:     Matt Mullins <mmullins@fb.com>, hall@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
References: <20190531223735.4998-1-mmullins@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6c6a4d47-796a-20e2-eb12-503a00d1fa0b@iogearbox.net>
Date:   Mon, 3 Jun 2019 15:08:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190531223735.4998-1-mmullins@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25469/Mon Jun  3 09:59:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2019 12:37 AM, Matt Mullins wrote:
> It is possible that a BPF program can be called while another BPF
> program is executing bpf_perf_event_output.  This has been observed with
> I/O completion occurring as a result of an interrupt:
> 
> 	bpf_prog_247fd1341cddaea4_trace_req_end+0x8d7/0x1000
> 	? trace_call_bpf+0x82/0x100
> 	? sch_direct_xmit+0xe2/0x230
> 	? blk_mq_end_request+0x1/0x100
> 	? blk_mq_end_request+0x5/0x100
> 	? kprobe_perf_func+0x19b/0x240
> 	? __qdisc_run+0x86/0x520
> 	? blk_mq_end_request+0x1/0x100
> 	? blk_mq_end_request+0x5/0x100
> 	? kprobe_ftrace_handler+0x90/0xf0
> 	? ftrace_ops_assist_func+0x6e/0xe0
> 	? ip6_input_finish+0xbf/0x460
> 	? 0xffffffffa01e80bf
> 	? nbd_dbg_flags_show+0xc0/0xc0 [nbd]
> 	? blkdev_issue_zeroout+0x200/0x200
> 	? blk_mq_end_request+0x1/0x100
> 	? blk_mq_end_request+0x5/0x100
> 	? flush_smp_call_function_queue+0x6c/0xe0
> 	? smp_call_function_single_interrupt+0x32/0xc0
> 	? call_function_single_interrupt+0xf/0x20
> 	? call_function_single_interrupt+0xa/0x20
> 	? swiotlb_map_page+0x140/0x140
> 	? refcount_sub_and_test+0x1a/0x50
> 	? tcp_wfree+0x20/0xf0
> 	? skb_release_head_state+0x62/0xc0
> 	? skb_release_all+0xe/0x30
> 	? napi_consume_skb+0xb5/0x100
> 	? mlx5e_poll_tx_cq+0x1df/0x4e0
> 	? mlx5e_poll_tx_cq+0x38c/0x4e0
> 	? mlx5e_napi_poll+0x58/0xc30
> 	? mlx5e_napi_poll+0x232/0xc30
> 	? net_rx_action+0x128/0x340
> 	? __do_softirq+0xd4/0x2ad
> 	? irq_exit+0xa5/0xb0
> 	? do_IRQ+0x7d/0xc0
> 	? common_interrupt+0xf/0xf
> 	</IRQ>
> 	? __rb_free_aux+0xf0/0xf0
> 	? perf_output_sample+0x28/0x7b0
> 	? perf_prepare_sample+0x54/0x4a0
> 	? perf_event_output+0x43/0x60
> 	? bpf_perf_event_output_raw_tp+0x15f/0x180
> 	? blk_mq_start_request+0x1/0x120
> 	? bpf_prog_411a64a706fc6044_should_trace+0xad4/0x1000
> 	? bpf_trace_run3+0x2c/0x80
> 	? nbd_send_cmd+0x4c2/0x690 [nbd]
> 
> This also cannot be alleviated by further splitting the per-cpu
> perf_sample_data structs (as in commit 283ca526a9bd ("bpf: fix
> corruption on concurrent perf_event_output calls")), as a raw_tp could
> be attached to the block:block_rq_complete tracepoint and execute during
> another raw_tp.  Instead, keep a pre-allocated perf_sample_data
> structure per perf_event_array element and fail a bpf_perf_event_output
> if that element is concurrently being used.
> 
> Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_data")
> Signed-off-by: Matt Mullins <mmullins@fb.com>

You do not elaborate why is this needed for all the networking programs that
use this functionality. The bpf_misc_sd should therefore be kept as-is. There
cannot be nested occurrences there (xdp, tc ingress/egress). Please explain why
non-tracing should be affected here...
