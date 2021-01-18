Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58022F9F7A
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 13:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391372AbhARMTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 07:19:51 -0500
Received: from foss.arm.com ([217.140.110.172]:34462 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391341AbhARMTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 07:19:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DBB031B;
        Mon, 18 Jan 2021 04:18:22 -0800 (PST)
Received: from e107158-lin (unknown [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DCF403F719;
        Mon, 18 Jan 2021 04:18:20 -0800 (PST)
Date:   Mon, 18 Jan 2021 12:18:18 +0000
From:   Qais Yousef <qais.yousef@arm.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 2/2] selftests: bpf: Add a new test for bare
 tracepoints
Message-ID: <20210118121818.muifeogh4hvakfeb@e107158-lin>
References: <20210116182133.2286884-1-qais.yousef@arm.com>
 <20210116182133.2286884-3-qais.yousef@arm.com>
 <e9d4b132-288d-594f-308c-132e89fcf63f@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e9d4b132-288d-594f-308c-132e89fcf63f@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/16/21 18:11, Yonghong Song wrote:
> 
> 
> On 1/16/21 10:21 AM, Qais Yousef wrote:
> > Reuse module_attach infrastructure to add a new bare tracepoint to check
> > we can attach to it as a raw tracepoint.
> > 
> > Signed-off-by: Qais Yousef <qais.yousef@arm.com>
> > ---
> >   .../bpf/bpf_testmod/bpf_testmod-events.h      |  6 +++++
> >   .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 21 ++++++++++++++-
> >   .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  6 +++++
> >   .../selftests/bpf/prog_tests/module_attach.c  | 27 +++++++++++++++++++
> >   .../selftests/bpf/progs/test_module_attach.c  | 10 +++++++
> >   5 files changed, 69 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> > index b83ea448bc79..89c6d58e5dd6 100644
> > --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> > +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> > @@ -28,6 +28,12 @@ TRACE_EVENT(bpf_testmod_test_read,
> >   		  __entry->pid, __entry->comm, __entry->off, __entry->len)
> >   );
> > +/* A bare tracepoint with no event associated with it */
> > +DECLARE_TRACE(bpf_testmod_test_write_bare,
> > +	TP_PROTO(struct task_struct *task, struct bpf_testmod_test_write_ctx *ctx),
> > +	TP_ARGS(task, ctx)
> > +);
> > +
> >   #endif /* _BPF_TESTMOD_EVENTS_H */
> >   #undef TRACE_INCLUDE_PATH
> > diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > index 2df19d73ca49..e900adad2276 100644
> > --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > @@ -28,9 +28,28 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
> >   EXPORT_SYMBOL(bpf_testmod_test_read);
> >   ALLOW_ERROR_INJECTION(bpf_testmod_test_read, ERRNO);
> > +noinline ssize_t
> > +bpf_testmod_test_write(struct file *file, struct kobject *kobj,
> > +		      struct bin_attribute *bin_attr,
> > +		      char *buf, loff_t off, size_t len)
> > +{
> > +	struct bpf_testmod_test_write_ctx ctx = {
> > +		.buf = buf,
> > +		.off = off,
> > +		.len = len,
> > +	};
> > +
> > +	trace_bpf_testmod_test_write_bare(current, &ctx);
> > +
> > +	return -EIO; /* always fail */
> > +}
> > +EXPORT_SYMBOL(bpf_testmod_test_write);
> > +ALLOW_ERROR_INJECTION(bpf_testmod_test_write, ERRNO);
> > +
> >   static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
> 
> Do we need to remove __ro_after_init?

I don't think so. The structure should still remain RO AFAIU.

> 
> > -	.attr = { .name = "bpf_testmod", .mode = 0444, },
> > +	.attr = { .name = "bpf_testmod", .mode = 0666, },
> >   	.read = bpf_testmod_test_read,
> > +	.write = bpf_testmod_test_write,
> >   };
> >   static int bpf_testmod_init(void)
> > diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
> > index b81adfedb4f6..b3892dc40111 100644
> > --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
> > +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
> > @@ -11,4 +11,10 @@ struct bpf_testmod_test_read_ctx {
> >   	size_t len;
> >   };
> > +struct bpf_testmod_test_write_ctx {
> > +	char *buf;
> > +	loff_t off;
> > +	size_t len;
> > +};
> > +
> >   #endif /* _BPF_TESTMOD_H */
> > diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> > index 50796b651f72..e4605c0b5af1 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> > @@ -21,9 +21,34 @@ static int trigger_module_test_read(int read_sz)
> >   	return 0;
> >   }
> > +static int trigger_module_test_write(int write_sz)
> > +{
> > +	int fd, err;
> 
> Init err = 0?

I don't see what difference this makes.

> 
> > +	char *buf = malloc(write_sz);
> > +
> > +	if (!buf)
> > +		return -ENOMEM;
> 
> Looks like we already non-negative value, so return ENOMEM?

We already set err=-errno. So shouldn't we return negative too?

> 
> > +
> > +	memset(buf, 'a', write_sz);
> > +	buf[write_sz-1] = '\0';
> > +
> > +	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
> > +	err = -errno;
> > +	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
> > +		goto out;
> 
> Change the above to
> 	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
> 	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", errno)) {
> 		err = -errno;
> 		goto out;
> 	}

I kept the code consistent with the definition of trigger_module_test_read().

I'll leave it up to the maintainer to pick up the style changes if they prefer
it this way.

Thanks for the ack and for the review.

Cheers

--
Qais Yousef
