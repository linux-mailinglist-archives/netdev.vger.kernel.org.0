Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B0C1F69B3
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 16:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgFKONL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 10:13:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:55442 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgFKONJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 10:13:09 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jjNwr-0006SL-06; Thu, 11 Jun 2020 16:12:53 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jjNwq-000TE2-HS; Thu, 11 Jun 2020 16:12:52 +0200
Subject: Re: [PATCH] xdp_rxq_info_user: Add null check after malloc
To:     Gaurav Singh <gaurav1086@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "open list:XDP (eXpress Data Path)" <netdev@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200610030145.17263-1-gaurav1086@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <de636159-a33e-cfa9-0d8f-e9c81873588f@iogearbox.net>
Date:   Thu, 11 Jun 2020 16:12:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200610030145.17263-1-gaurav1086@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25840/Thu Jun 11 14:52:31 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/20 5:01 AM, Gaurav Singh wrote:
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> 
> The memset call is made right after malloc call which
> can return a NULL pointer upon failure causing a
> segmentation fault. Fix this by adding a null check
> right after malloc() and then do memset().

The SoB should come after the commit message here.

> ---
>   samples/bpf/xdp_rxq_info_user.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
> index 4fe47502ebed..2d03c84a4cca 100644
> --- a/samples/bpf/xdp_rxq_info_user.c
> +++ b/samples/bpf/xdp_rxq_info_user.c
> @@ -202,11 +202,11 @@ static struct datarec *alloc_record_per_cpu(void)
>   
>   	size = sizeof(struct datarec) * nr_cpus;
>   	array = malloc(size);
> -	memset(array, 0, size);

All these below are candidates for calloc(), can we just use that instead and
simplify the below.

>   	if (!array) {
>   		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
>   		exit(EXIT_FAIL_MEM);
>   	}
> +	memset(array, 0, size);
>   	return array;
>   }
>   
> @@ -218,11 +218,11 @@ static struct record *alloc_record_per_rxq(void)
>   
>   	size = sizeof(struct record) * nr_rxqs;
>   	array = malloc(size);
> -	memset(array, 0, size);
>   	if (!array) {
>   		fprintf(stderr, "Mem alloc error (nr_rxqs:%u)\n", nr_rxqs);
>   		exit(EXIT_FAIL_MEM);
>   	}
> +	memset(array, 0, size);
>   	return array;
>   }
>   
> @@ -233,11 +233,11 @@ static struct stats_record *alloc_stats_record(void)
>   	int i;
>   
>   	rec = malloc(sizeof(*rec));
> -	memset(rec, 0, sizeof(*rec));
>   	if (!rec) {
>   		fprintf(stderr, "Mem alloc error\n");
>   		exit(EXIT_FAIL_MEM);
>   	}
> +	memset(rec, 0, sizeof(*rec));
>   	rec->rxq = alloc_record_per_rxq();
>   	for (i = 0; i < nr_rxqs; i++)
>   		rec->rxq[i].cpu = alloc_record_per_cpu();
> 

Thanks,
Daniel
