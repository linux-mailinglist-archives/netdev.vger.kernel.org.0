Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC5A1208D6
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfLPOoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:44:07 -0500
Received: from www62.your-server.de ([213.133.104.62]:44068 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbfLPOoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:44:06 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1igrbQ-0001aO-T6; Mon, 16 Dec 2019 15:44:04 +0100
Date:   Mon, 16 Dec 2019 15:44:04 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/4] Fix perf_buffer creation on systems with
 offline CPUs
Message-ID: <20191216144404.GG14887@linux.fritz.box>
References: <20191212013521.1689228-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212013521.1689228-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25665/Mon Dec 16 10:52:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 05:35:20PM -0800, Andrii Nakryiko wrote:
> This patch set fixes perf_buffer__new() behavior on systems which have some of
> the CPUs offline/missing (due to difference between "possible" and "online"
> sets). perf_buffer will create per-CPU buffer and open/attach to corresponding
> perf_event only on CPUs present and online at the moment of perf_buffer
> creation. Without this logic, perf_buffer creation has no chances of
> succeeding on such systems, preventing valid and correct BPF applications from
> starting.

Once CPU goes back online and processes BPF events, any attempt to push into
perf RB via bpf_perf_event_output() with flag BPF_F_CURRENT_CPU would silently
get discarded. Should rather perf API be fixed instead of plain skipping as done
here to at least allow creation of ring buffer for BPF to avoid such case?

> Andrii Nakryiko (4):
>   libbpf: extract and generalize CPU mask parsing logic
>   selftests/bpf: add CPU mask parsing tests
>   libbpf: don't attach perf_buffer to offline/missing CPUs
>   selftests/bpf: fix perf_buffer test on systems w/ offline CPUs
> 
>  tools/lib/bpf/libbpf.c                        | 157 ++++++++++++------
>  tools/lib/bpf/libbpf_internal.h               |   2 +
>  .../selftests/bpf/prog_tests/cpu_mask.c       |  78 +++++++++
>  .../selftests/bpf/prog_tests/perf_buffer.c    |  29 +++-
>  4 files changed, 213 insertions(+), 53 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cpu_mask.c
> 
> -- 
> 2.17.1
> 
