Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE5DC1D35
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbfI3IcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:32:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:52440 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbfI3IcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:32:10 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iEr6F-0007P2-Ou; Mon, 30 Sep 2019 10:32:07 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iEr6F-000PvS-I8; Mon, 30 Sep 2019 10:32:07 +0200
Subject: Re: [PATCH bpf] libbpf: count present CPUs, not theoretically
 possible
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20190928063033.1674094-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0b70df6a-28fd-e139-d72c-d4d88e9bc7b7@iogearbox.net>
Date:   Mon, 30 Sep 2019 10:32:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190928063033.1674094-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25587/Sun Sep 29 10:25:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/19 8:30 AM, Andrii Nakryiko wrote:
> This patch switches libbpf_num_possible_cpus() from using possible CPU
> set to present CPU set. This fixes issues with incorrect auto-sizing of
> PERF_EVENT_ARRAY map on HOTPLUG-enabled systems.

Those issues should be described in more detail here in the changelog,
otherwise noone knows what is meant exactly when glancing at the git log.

> On HOTPLUG enabled systems, /sys/devices/system/cpu/possible is going to
> be a set of any representable (i.e., potentially possible) CPU, which is
> normally way higher than real amount of CPUs (e.g., 0-127 on VM I've
> tested on, while there were just two CPU cores actually present).
> /sys/devices/system/cpu/present, on the other hand, will only contain
> CPUs that are physically present in the system (even if not online yet),
> which is what we really want, especially when creating per-CPU maps or
> perf events.
> 
> On systems with HOTPLUG disabled, present and possible are identical, so
> there is no change of behavior there.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   tools/lib/bpf/libbpf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index e0276520171b..45351c074e45 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5899,7 +5899,7 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
>   
>   int libbpf_num_possible_cpus(void)
>   {
> -	static const char *fcpu = "/sys/devices/system/cpu/possible";
> +	static const char *fcpu = "/sys/devices/system/cpu/present";

Problem is that this is going to break things *badly* for per-cpu maps as
BPF_DECLARE_PERCPU() relies on possible CPUs, not present ones. And given
present<=possible you'll end up corrupting user space when you do a lookup
on the map since kernel side operates on possible as well.

>   	int len = 0, n = 0, il = 0, ir = 0;
>   	unsigned int start = 0, end = 0;
>   	int tmp_cpus = 0;
> 

