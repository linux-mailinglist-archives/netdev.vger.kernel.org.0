Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFEA1F6D1C
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 20:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgFKSCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 14:02:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25810 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726998AbgFKSCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 14:02:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591898526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PDcY/aNN0AijO6KeFZRrqAa1c2dHhA8tsB/uBtT8Fjk=;
        b=SRvAIRwKJIUphA0INI8U2QQQDRkrJ15w4OR2+x/lHJgG91CrwVxvBwxMwUBasbl8Fn9d1J
        SYuwrEGLKtC6rM0yw5RVvChFARwbZAm7fEdb2AWtmvE5mQHyE03wkgNp9IQrGZfy+BU2VN
        J8Fq7IyKAxU24mviJP8xx4Mt/itQHto=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-V63-PS4kPWWBKyLEDIScKQ-1; Thu, 11 Jun 2020 14:01:51 -0400
X-MC-Unique: V63-PS4kPWWBKyLEDIScKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B46B0BFC6;
        Thu, 11 Jun 2020 18:01:48 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECCD05D9DC;
        Thu, 11 Jun 2020 18:01:43 +0000 (UTC)
Date:   Thu, 11 Jun 2020 20:01:40 +0200
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP (eXpress Data Path)),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path)),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] xdp_rxq_info_user: Replace malloc/memset w/calloc
Message-ID: <20200611200140.259423b4@carbon>
In-Reply-To: <20200611150221.15665-1-gaurav1086@gmail.com>
References: <20200611150221.15665-1-gaurav1086@gmail.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Jun 2020 11:02:21 -0400
Gaurav Singh <gaurav1086@gmail.com> wrote:

> Replace malloc/memset with calloc

Please also mention/describe  that this also solves the bug you found.

As this fix a potential bug, it will be appropriate to add a "Fixes:"
line, just before "Signed-off-by" (meaning no newline between the two).

Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info")
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>  samples/bpf/xdp_rxq_info_user.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
> index 4fe47502ebed..caa4e7ffcfc7 100644
> --- a/samples/bpf/xdp_rxq_info_user.c
> +++ b/samples/bpf/xdp_rxq_info_user.c
> @@ -198,11 +198,8 @@ static struct datarec *alloc_record_per_cpu(void)
>  {
>  	unsigned int nr_cpus = bpf_num_possible_cpus();
>  	struct datarec *array;
> -	size_t size;
>  
> -	size = sizeof(struct datarec) * nr_cpus;
> -	array = malloc(size);
> -	memset(array, 0, size);
> +	array = calloc(nr_cpus, sizeof(struct datarec));
>  	if (!array) {
>  		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
>  		exit(EXIT_FAIL_MEM);
> @@ -214,11 +211,8 @@ static struct record *alloc_record_per_rxq(void)
>  {
>  	unsigned int nr_rxqs = bpf_map__def(rx_queue_index_map)->max_entries;
>  	struct record *array;
> -	size_t size;
>  
> -	size = sizeof(struct record) * nr_rxqs;
> -	array = malloc(size);
> -	memset(array, 0, size);
> +	array = calloc(nr_rxqs, sizeof(struct record));
>  	if (!array) {
>  		fprintf(stderr, "Mem alloc error (nr_rxqs:%u)\n", nr_rxqs);
>  		exit(EXIT_FAIL_MEM);
> @@ -232,8 +226,7 @@ static struct stats_record *alloc_stats_record(void)
>  	struct stats_record *rec;
>  	int i;
>  
> -	rec = malloc(sizeof(*rec));
> -	memset(rec, 0, sizeof(*rec));
> +	rec = calloc(1, sizeof(struct stats_record));
>  	if (!rec) {
>  		fprintf(stderr, "Mem alloc error\n");
>  		exit(EXIT_FAIL_MEM);



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

