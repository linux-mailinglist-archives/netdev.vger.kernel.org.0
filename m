Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A063D1AE639
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbgDQTu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730449AbgDQTu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 15:50:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209CFC061A0C;
        Fri, 17 Apr 2020 12:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oZFKaAEx7x9RM0yplSN83xASDmB3ff/b3yogXeNlHSg=; b=MHwDf9SXtGhOxDOC9x1npNeXsu
        dLvd8csRf6Q/wv1NcXob0gmK6bvBDyGUpM8ox6iV59gyXMbwRY6oI/dse4DNj7svbiPiGjz8KxWp3
        CmSDdKo+QA+LAOHozOfSCUOoQ3cEHroZsR1k4tAtpc3ZAciJSxF6NSGzvl9hENveamfdch5oSSdT4
        q4IniJbR9Cdze+AE4xNE2Td8S6Ug7viKtRySWJKbtp9IdTXYOPQ2uwVAZymcePdNcTbGv7UqPCOPB
        Q6I5e8bI6GEtYRzpLT5qa6uBCrCu2I7OuTTlWhi2+rbXJdAx+sGsWGweKO0WeZSbxuhumFeWWwtTw
        5f9T8OtQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPX0B-0007D5-JD; Fri, 17 Apr 2020 19:50:15 +0000
Date:   Fri, 17 Apr 2020 12:50:15 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 6/6] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200417195015.GO5820@bombadil.infradead.org>
References: <20200417064146.1086644-1-hch@lst.de>
 <20200417064146.1086644-7-hch@lst.de>
 <20200417193910.GA7011@rdna-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417193910.GA7011@rdna-mbp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 12:39:10PM -0700, Andrey Ignatov wrote:
> Though it breaks tools/testing/selftests/bpf/test_sysctl.c. I spent some
> time debugging and found a couple of problems -- see below. But there is
> something else .. Still I figured it's a good idea to give an early
> heads-up.

"see below"?  Really?  You're going to say that and then make people
scroll through thousands of lines of quoted material to find your new
contributions?  Please, learn to trim appropriately.

Here's about what you should have sent:

> > @@ -1156,52 +1153,41 @@ const struct bpf_verifier_ops cg_dev_verifier_ops = {
> >   */
> >  int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
> >  				   struct ctl_table *table, int write,
> > -				   void __user *buf, size_t *pcount,
> > -				   loff_t *ppos, void **new_buf,
> > -				   enum bpf_attach_type type)
> > +				   void **buf, size_t *pcount,
> > +				   loff_t *ppos, enum bpf_attach_type type)
> >  {
> >  	struct bpf_sysctl_kern ctx = {
> >  		.head = head,
> >  		.table = table,
> >  		.write = write,
> >  		.ppos = ppos,
> > -		.cur_val = NULL,
> > +		.cur_val = *buf,
> 
> 
> cur_val is allocated separately below to read current value of sysctl
> and not interfere with user-passed buffer. 
> 
> >  		.cur_len = PAGE_SIZE,
> >  		.new_val = NULL,
> >  		.new_len = 0,
> >  		.new_updated = 0,
> >  	};
> >  	struct cgroup *cgrp;
> > +	loff_t pos = 0;
> >  	int ret;
> >  
> > -	ctx.cur_val = kmalloc_track_caller(ctx.cur_len, GFP_KERNEL);
> > -	if (ctx.cur_val) {
> > -		mm_segment_t old_fs;
> > -		loff_t pos = 0;
> > -
> > -		old_fs = get_fs();
> > -		set_fs(KERNEL_DS);
> > -		if (table->proc_handler(table, 0, (void __user *)ctx.cur_val,
> > -					&ctx.cur_len, &pos)) {
> > -			/* Let BPF program decide how to proceed. */
> > -			ctx.cur_len = 0;
> > -		}
> > -		set_fs(old_fs);
> > -	} else {
> > +	if (table->proc_handler(table, 0, ctx.cur_val, &ctx.cur_len, &pos)) {
> 
> This call reads current value of sysclt into cur_val buffer.
> 
> Since you made cur_val point to kernel copy of user-passed buffer, this
> call will always override whatever is there in that kernel copy.
> 
> For example, if user is writing to sysclt, then *buf is a pointer to new
> value, but this call will override this new value and, corresondingly
> new value will be lost.
> 
> I think cur_val should still be allocated separately.
> 
> 
> >  		/* Let BPF program decide how to proceed. */
> >  		ctx.cur_len = 0;
> >  	}
> >  
> > -	if (write && buf && *pcount) {
> > +	if (write && *pcount) {
> >  		/* BPF program should be able to override new value with a
> >  		 * buffer bigger than provided by user.
> >  		 */
> >  		ctx.new_val = kmalloc_track_caller(PAGE_SIZE, GFP_KERNEL);
> > -		ctx.new_len = min_t(size_t, PAGE_SIZE, *pcount);
> > -		if (!ctx.new_val ||
> > -		    copy_from_user(ctx.new_val, buf, ctx.new_len))
> > +		if (ctx.new_val) {
> > +			ctx.new_len = min_t(size_t, PAGE_SIZE, *pcount);
> > +			memcpy(ctx.new_val, buf, ctx.new_len);
> 
> This should be *buf, not buf. A typo I guess?
> 
> 
> I applied the whole patchset to bpf-next tree and run selftests. This
> patch breaks 4 of them:
> 
> 	% cd tools/testing/selftests/bpf/
> 	% ./test_sysctl
> 	...
> 	Test case: sysctl_get_new_value sysctl:write ok .. [FAIL]
> 	Test case: sysctl_get_new_value sysctl:write ok long .. [FAIL]
> 	Test case: sysctl_get_new_value sysctl:write E2BIG .. [FAIL]
> 	Test case: sysctl_set_new_value sysctl:read EINVAL .. [PASS]
> 	Test case: sysctl_set_new_value sysctl:write ok .. [FAIL]
> 	...
> 	Summary: 36 PASSED, 4 FAILED
> 
> I applied both changes I suggested above and it reduces number of broken
> selftests to one:
> 
> Test case: sysctl_set_new_value sysctl:write ok .. [FAIL]
> 
> I haven't debugged this last one though yet ..
> 
> All these tests are available in
> tools/testing/selftests/bpf/test_sysctl.c.
> 
> I think it's a good idea to run these tests locally before sending the
> next version of the patch set.
> 
