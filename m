Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0902491FD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgHSAuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgHSAuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 20:50:01 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90400C061389;
        Tue, 18 Aug 2020 17:50:00 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id i92so399521pje.0;
        Tue, 18 Aug 2020 17:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jygbgrnQenGEuGov4ivBCZFA8Viy7yd7/y09kWCsgZ8=;
        b=adovtIMoWmZphfDLeuJGrsGbIqbbRcjQG5o5P+p3AXrSflMrTjtchUYyGwNmIMYECR
         2N4PNenPUKY2mXw0jYqkK9P/aRBlCOcET1C+bNiKh6uhO8p0csJbz60qiNYWnPERP9KI
         UjKdjf2vprPbn9rzDD1We7ayVTLN4Fe3XeMChSzh5UB0ziXb43EwOsrNSPBYfdRvla/w
         loAZ/I3MXgTPlYA7WSJKnjPXbBCxGAvGM9BVNGiKLvklhYgig40KPutmgeO8CbQvQzjR
         mNxU5uYn5YHgRSAsYfZ4ywvzvBChs9p8+I26ANs7vxdc5uNMzrf5oL70yIxV9/o4v3Mn
         K9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jygbgrnQenGEuGov4ivBCZFA8Viy7yd7/y09kWCsgZ8=;
        b=JZzfDjnU2fJEpyavgh+G9Uh+Hm8fOgz/ByLRGfhyIzRKQ80OFH5RADr7YCBLbPNVL0
         /TJUWKUj0mG+138UQf5Gtpv1EuDn1US6EUjVJeuAJZ0l6z53UNpQK13fWzyc7BV/ws6Z
         HOj2mrHDx3AQTh67c1Qz4JSnnEvtkWbbGvqLTa7tULjXDe7DL4UrckvhuaucQO7HbmQa
         oDCsyQR60TTi1ei7dflsMB4rDrWv5gE40zZZ7CvxIo2AG7lnJULstfjHtyrHxEmEQawc
         eewexDgZ3LXUvXwA3n53uCon/2OhAKqqWsmuWJhzsMIAGKUSC+HmlWX53fmQsXDsaMIf
         gFKA==
X-Gm-Message-State: AOAM533y/F8VK6u7TSKxngIpPGK6SrYdL5VFmYUVR3BG35DQirqZbgej
        adUj9oN8Y8w0pm00zVDDIXg=
X-Google-Smtp-Source: ABdhPJziEw0zviXGYfoqHwgN/kZiVL1IkULJ4LUGZjk4NvgQoeMq/GGu6rvI1tGDIox1/tz/QQwh8w==
X-Received: by 2002:a17:90a:644b:: with SMTP id y11mr2078305pjm.13.1597798199621;
        Tue, 18 Aug 2020 17:49:59 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:20fd])
        by smtp.gmail.com with ESMTPSA id u62sm25860766pfb.4.2020.08.18.17.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 17:49:58 -0700 (PDT)
Date:   Tue, 18 Aug 2020 17:49:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf v2 1/3] bpf: fix a rcu_sched stall issue with bpf
 task/task_file iterator
Message-ID: <20200819004957.tvx6el2lblfp6kb7@ast-mbp.dhcp.thefacebook.com>
References: <20200818222309.2181236-1-yhs@fb.com>
 <20200818222309.2181348-1-yhs@fb.com>
 <20200819000547.7qv32me2fxviwdkx@ast-mbp.dhcp.thefacebook.com>
 <ac2c7081-8e6b-76c6-e032-ed2be3727e4d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac2c7081-8e6b-76c6-e032-ed2be3727e4d@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 05:30:37PM -0700, Yonghong Song wrote:
> 
> 
> On 8/18/20 5:05 PM, Alexei Starovoitov wrote:
> > On Tue, Aug 18, 2020 at 03:23:09PM -0700, Yonghong Song wrote:
> > > 
> > > We did not use cond_resched() since for some iterators, e.g.,
> > > netlink iterator, where rcu read_lock critical section spans between
> > > consecutive seq_ops->next(), which makes impossible to do cond_resched()
> > > in the key while loop of function bpf_seq_read().
> > 
> > but after this patch we can, right?
> 
> We can do cond_resched() after seq->op->stop(). See more below.
> 
> > 
> > > +/* maximum visited objects before bailing out */
> > > +#define MAX_ITER_OBJECTS	1000000
> > > +
> > >   /* bpf_seq_read, a customized and simpler version for bpf iterator.
> > >    * no_llseek is assumed for this file.
> > >    * The following are differences from seq_read():
> > > @@ -79,7 +82,7 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
> > >   {
> > >   	struct seq_file *seq = file->private_data;
> > >   	size_t n, offs, copied = 0;
> > > -	int err = 0;
> > > +	int err = 0, num_objs = 0;
> > >   	void *p;
> > >   	mutex_lock(&seq->lock);
> > > @@ -135,6 +138,7 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
> > >   	while (1) {
> > >   		loff_t pos = seq->index;
> > > +		num_objs++;
> > >   		offs = seq->count;
> > >   		p = seq->op->next(seq, p, &seq->index);
> > >   		if (pos == seq->index) {
> > > @@ -153,6 +157,15 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
> > >   		if (seq->count >= size)
> > >   			break;
> > > +		if (num_objs >= MAX_ITER_OBJECTS) {
> > > +			if (offs == 0) {
> > > +				err = -EAGAIN;
> > > +				seq->op->stop(seq, p);
> > > +				goto done;
> > > +			}
> > > +			break;
> > > +		}
> > > +
> > 
> > should this block be after op->show() and error processing?
> > Otherwise bpf_iter_inc_seq_num() will be incorrectly incremented?
> 
> The purpose of op->next() is to calculate the "next" object position,
> stored in the seq private data. So for next read() syscall, start()
> will try to fetch the data based on the info in seq private data.
> 
> This is true for conditions "if (seq->count >= size) break"
> in the above so next op->start() can try to locate the correct
> object. The same is for this -EAGAIN thing.
> 
> > 
> > >   		err = seq->op->show(seq, p);
> > >   		if (err > 0) {
> > >   			bpf_iter_dec_seq_num(seq);
> > 
> > After op->stop() we can do cond_resched() in all cases,
> > since rhashtable walk does rcu_unlock in stop() callback, right?
> 
> Yes, we can. I am thinking since we return to user space,
> cond_resched() might not be needed since returning to user space
> will trigger some kind of scheduling. This patch fixed
> the rcu stall issue. But if my understanding is incorrect,
> I am happy to add cond_reched().

ahh. you're correct on both counts. Applied all three patches to bpf tree. thanks!
