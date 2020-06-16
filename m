Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CA01FB1BC
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 15:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgFPNKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 09:10:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:45184 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgFPNKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 09:10:34 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jlBM0-0004aN-8w; Tue, 16 Jun 2020 15:10:16 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jlBLz-0004ar-ON; Tue, 16 Jun 2020 15:10:15 +0200
Subject: Re: [PATCH] [bpf] xdp_redirect_cpu_user: Fix null pointer dereference
To:     Gaurav Singh <gaurav1086@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20200614190434.31321-1-gaurav1086@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f803b1ad-cccd-750f-01e4-e1769ab1d538@iogearbox.net>
Date:   Tue, 16 Jun 2020 15:10:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200614190434.31321-1-gaurav1086@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25844/Mon Jun 15 15:06:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/20 9:04 PM, Gaurav Singh wrote:
> Memset() on the pointer right after malloc() can cause
> a null pointer dereference if it failed to allocate memory.
> Fix this by replacing malloc/memset with a single calloc().
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Squashed all three same fixes into one and pushed to bpf, thanks!

> @@ -222,11 +219,9 @@ static struct datarec *alloc_record_per_cpu(void)
>   static struct stats_record *alloc_stats_record(void)
>   {
>   	struct stats_record *rec;
> -	int i, size;
> +	int i;
>   
> -	size = sizeof(*rec) + n_cpus * sizeof(struct record);
> -	rec = malloc(size);
> -	memset(rec, 0, size);
> +	rec = calloc(n_cpus + 1, sizeof(struct record));

For the record, this one is buggy, so I fixed it up as well.

>   	if (!rec) {
>   		fprintf(stderr, "Mem alloc error\n");
>   		exit(EXIT_FAIL_MEM);
> 

Thanks,
Daniel
