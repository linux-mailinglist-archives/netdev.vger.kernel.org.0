Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612DA2491A4
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgHSAFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSAFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 20:05:51 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8DDC061389;
        Tue, 18 Aug 2020 17:05:51 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so9952044plk.13;
        Tue, 18 Aug 2020 17:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/YnuQIuqofLqE8AgteDk6cmQRX57TrKaILSNeZxQNxo=;
        b=WaD56x/Go7jRXHV25TSKwGe45kBLP//MycRwVJyN5ur6uQ/7orANwmHnIoqxwtq5tD
         PTG6KPyMw+YujUHhkb6uFzbY8ySZZs+SS8BJNic1jsCkdV2eaMea50bX2KAle16eY3hm
         YjYgICPTt+4j323/fMJ7ypFFwUECH+vOyXYX91T1fhmQc6NReO+3OSd/qn8TCwEoLqcX
         5EXt2ex4hMEKPPKCBRxQToOhIjvjq3SAPCd4pDv6trKDPRD2F5rPJPF0ZIOr24qM/M9s
         /fhRt78hlvhO8GZ9DWhtxzZ901ZLltJcDwQMwvJp3HxXRxoDubVZAnXyVQ1tXB88hSKc
         ucPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/YnuQIuqofLqE8AgteDk6cmQRX57TrKaILSNeZxQNxo=;
        b=p0l/J1OjfG0KoOgnl4oA+VDw5luT73P+bf8KBy1ohCGL4EvIiMMSTawDXwT5t9qWaL
         JpxiO+l3GMh1ifqmZPRFi6jqkJylG6ZbwjTA5NlVJQlqb5hpwMtUu0wWKLQeX0nBOB+X
         QbWTIoVcMpV3bVHu1cADwhncjFbKsw8WpUL2Eqw9OTq4YJtcNoOUmxQns5XDRyt68UJ8
         oTVTD7DeVWre+9GcTx1aEdqj1R4HM3EQZxOq7nLwe/mzBVVDEfnfKsK1UGyJx1FbWu/g
         N0FIVnExI5X1JIPgHU/M9M1ALHrzJX185SGCa7ZK0K2gK3yZ9pssjDr8rYQSnzXELz+P
         8zpg==
X-Gm-Message-State: AOAM530LZWNmZ9LYRchnm51PYEBt6miKZuFtCVFYx3wpxbTNsOsBWv2k
        vAElOdARq6rg6r4NvL9tcHe9fG9GsPA=
X-Google-Smtp-Source: ABdhPJwo3oD3ATLn0lorqqzdbCiRNaax1XysN2w/MZ0JTl/iN/2XH9qr9rrE90aFH9myvfSef55pWQ==
X-Received: by 2002:a17:90a:fc90:: with SMTP id ci16mr1826415pjb.229.1597795550674;
        Tue, 18 Aug 2020 17:05:50 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:20fd])
        by smtp.gmail.com with ESMTPSA id l12sm958100pjq.31.2020.08.18.17.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 17:05:49 -0700 (PDT)
Date:   Tue, 18 Aug 2020 17:05:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf v2 1/3] bpf: fix a rcu_sched stall issue with bpf
 task/task_file iterator
Message-ID: <20200819000547.7qv32me2fxviwdkx@ast-mbp.dhcp.thefacebook.com>
References: <20200818222309.2181236-1-yhs@fb.com>
 <20200818222309.2181348-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818222309.2181348-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 03:23:09PM -0700, Yonghong Song wrote:
> 
> We did not use cond_resched() since for some iterators, e.g.,
> netlink iterator, where rcu read_lock critical section spans between
> consecutive seq_ops->next(), which makes impossible to do cond_resched()
> in the key while loop of function bpf_seq_read().

but after this patch we can, right?

>  
> +/* maximum visited objects before bailing out */
> +#define MAX_ITER_OBJECTS	1000000
> +
>  /* bpf_seq_read, a customized and simpler version for bpf iterator.
>   * no_llseek is assumed for this file.
>   * The following are differences from seq_read():
> @@ -79,7 +82,7 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>  {
>  	struct seq_file *seq = file->private_data;
>  	size_t n, offs, copied = 0;
> -	int err = 0;
> +	int err = 0, num_objs = 0;
>  	void *p;
>  
>  	mutex_lock(&seq->lock);
> @@ -135,6 +138,7 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>  	while (1) {
>  		loff_t pos = seq->index;
>  
> +		num_objs++;
>  		offs = seq->count;
>  		p = seq->op->next(seq, p, &seq->index);
>  		if (pos == seq->index) {
> @@ -153,6 +157,15 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>  		if (seq->count >= size)
>  			break;
>  
> +		if (num_objs >= MAX_ITER_OBJECTS) {
> +			if (offs == 0) {
> +				err = -EAGAIN;
> +				seq->op->stop(seq, p);
> +				goto done;
> +			}
> +			break;
> +		}
> +

should this block be after op->show() and error processing?
Otherwise bpf_iter_inc_seq_num() will be incorrectly incremented?

>  		err = seq->op->show(seq, p);
>  		if (err > 0) {
>  			bpf_iter_dec_seq_num(seq);

After op->stop() we can do cond_resched() in all cases,
since rhashtable walk does rcu_unlock in stop() callback, right?
I think copy_to_user() and mutex_unlock() don't do cond_resched()
equivalent work.
