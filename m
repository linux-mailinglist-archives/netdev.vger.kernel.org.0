Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DB858DBF
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfF0WOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:14:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:45120 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfF0WOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:14:35 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgcf2-0004BA-FZ; Fri, 28 Jun 2019 00:14:32 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgcf2-000Qzl-AK; Fri, 28 Jun 2019 00:14:32 +0200
Subject: Re: [PATCH bpf-next v5 1/3] devmap/cpumap: Use flush list instead of
 bitmap
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
 <156125626115.5209.3880071777007082264.stgit@alrua-x1>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ff82dde7-8f31-1ab5-65b8-5e2d5ca5f680@iogearbox.net>
Date:   Fri, 28 Jun 2019 00:14:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <156125626115.5209.3880071777007082264.stgit@alrua-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25493/Thu Jun 27 10:06:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/23/2019 04:17 AM, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> The socket map uses a linked list instead of a bitmap to keep track of
> which entries to flush. Do the same for devmap and cpumap, as this means we
> don't have to care about the map index when enqueueing things into the
> map (and so we can cache the map lookup).
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
[...]
> +static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx)
>  {
> +	struct bpf_cpu_map_entry *rcpu = bq->obj;
>  	unsigned int processed = 0, drops = 0;
>  	const int to_cpu = rcpu->cpu;
>  	struct ptr_ring *q;
> @@ -621,6 +630,9 @@ static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
>  	bq->count = 0;
>  	spin_unlock(&q->producer_lock);
>  
> +	__list_del(bq->flush_node.prev, bq->flush_node.next);
> +	bq->flush_node.prev = NULL;

Given this and below is a bit non-standard way of using list API, maybe add
these as inline helpers to include/linux/list.h to make sure anyone changing
list API semantics doesn't overlook these in future?

>  	/* Feedback loop via tracepoints */
>  	trace_xdp_cpumap_enqueue(rcpu->map_id, processed, drops, to_cpu);
>  	return 0;
[...]
> +
> +	if (!bq->flush_node.prev)
> +		list_add(&bq->flush_node, flush_list);
> +
>  	return 0;
>  }
>  
