Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B380D2806
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 13:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfJJLhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 07:37:37 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44500 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfJJLhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 07:37:37 -0400
Received: by mail-lf1-f65.google.com with SMTP id q12so4105327lfc.11
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 04:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=hiy5AVBqTzFPdMykXPXdntwcxs9Lxc3BOJl02HMVZEc=;
        b=w+PO4u8W5CvO0zUt4uJmoXKN24jUmFfBbtlAgNdTtbPj9hyYVrBUhE47HIdKcGGTxC
         K3uupyLZKrn94WtS1bqBP/hnecvKPNGl92GjhlVSfxTc+L+anjO9/khHaUZdVxBqL7C/
         CG+E942yLOpUijkDea+X5T90VI0H8Iih9VvYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=hiy5AVBqTzFPdMykXPXdntwcxs9Lxc3BOJl02HMVZEc=;
        b=tYIBYMYxpsTRlV813mol7kPs0baBJFK17t9/L33C7i7qZjMgcZmkaCfT6+DE7LqFOO
         Y6l+UnSe3rgnKWPsNZxBv6iYKi0Q47KRRDMl5GrSPY2AA6DkBkDKZqcxY9TWT8AmBAOg
         NqzLPrcR8W/izYjxnKzxYqRUqweuNnI6mWkkvnYtNaJr6VN0/iQdne1FvQ+FWv1G+EAQ
         RVRJlTNE1b1jdvi/ASBV1o9F5E0ehNI3jDk0FMaBqVOHUqdGVLrpSY4f2Nuz8alMNCyf
         BcO/9EC8ToY6Lbqau0hasfZN4E+hL/yypqMW6cknkmHbNjZ/ChVbFGWbSlLMpYjKYyXu
         b6Cg==
X-Gm-Message-State: APjAAAU1C9zqkQrJuW0/h9n79SAD8WpS0eZtHo18s+dfbSez5UR7dJ9V
        1dSHLjj7dl1tW5DvlKDpIddVeQ==
X-Google-Smtp-Source: APXvYqxPUNwbQL9yrPB2N10+CEb8trzM9kyMSKcXTsalGadl9YhtEvvuXMfvfAWgjHwuCkzpXMpEYw==
X-Received: by 2002:a19:ad4a:: with SMTP id s10mr5667108lfd.159.1570707454386;
        Thu, 10 Oct 2019 04:37:34 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id j17sm1183166lfb.11.2019.10.10.04.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 04:37:33 -0700 (PDT)
References: <20191009094312.15284-1-jakub@cloudflare.com> <20191009094312.15284-2-jakub@cloudflare.com> <20191009163341.GE2096@mini-arch>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATH bpf-next 2/2] selftests/bpf: Check that flow dissector can be re-attached
In-reply-to: <20191009163341.GE2096@mini-arch>
Date:   Thu, 10 Oct 2019 13:37:33 +0200
Message-ID: <87lfts25mq.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 06:33 PM CEST, Stanislav Fomichev wrote:
> On 10/09, Jakub Sitnicki wrote:
>> Make sure a new flow dissector program can be attached to replace the old
>> one with a single syscall. Also check that attaching the same program twice
>> is prohibited.
> Overall the series looks good, left a bunch of nits/questions below.

Thanks for the comments.

>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  .../bpf/prog_tests/flow_dissector_reattach.c  | 93 +++++++++++++++++++
>>  1 file changed, 93 insertions(+)
>>  create mode 100644 tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
>> new file mode 100644
>> index 000000000000..0f0006c93956
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
>> @@ -0,0 +1,93 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Test that the flow_dissector program can be updated with a single
>> + * syscall by attaching a new program that replaces the existing one.
>> + *
>> + * Corner case - the same program cannot be attached twice.
>> + */
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <stdbool.h>
>> +#include <unistd.h>
>> +
>> +#include <linux/bpf.h>
>> +#include <bpf/bpf.h>
>> +
>> +#include "test_progs.h"
>> +
> [..]
>> +/* Not used here. For CHECK macro sake only. */
>> +static int duration;
> nit: you can use CHECK_FAIL macro instead which doesn't require this.
>
> if (CHECK_FAIL(expr)) {
> 	printf("something bad has happened\n");
> 	return/goto;
> }
>
> It may be more verbose than doing CHECK() with its embedded error
> message, so I leave it up to you to decide on whether you want to switch
> to CHECK_FAIL or stick to CHECK.
>

I wouldn't mind switching to CHECK_FAIL. It reads better than CHECK with
error message stuck in the if expression. (There is a side-issue with
printf(). Will explain at the end [*].)

Another thing to consider is that with CHECK the message indicating a
failure ("<test>:FAIL:<lineno>") and the actual explanation message are
on the same line. This makes the error log easier to reason.

I'm torn here, and considering another alternative to address at least
the readability issue:

if (fail_expr) {
        CHECK(1, "action", "explanation");
        return;
}

It doesn't address the extra variable problem. Maybe we need another
CHECK variant.

>> +static bool is_attached(void)
>> +{
>> +	bool attached = true;
>> +	int err, net_fd = -1;
> nit: maybe don't need to initialize net_fd to -1 here as well.

Will fix.

>
>> +	__u32 cnt;
>> +
>> +	net_fd = open("/proc/self/ns/net", O_RDONLY);
>> +	if (net_fd < 0)
>> +		goto out;
>> +
>> +	err = bpf_prog_query(net_fd, BPF_FLOW_DISSECTOR, 0, NULL, NULL, &cnt);
>> +	if (CHECK(err, "bpf_prog_query", "ret %d errno %d\n", err, errno))
>> +		goto out;
>> +
>> +	attached = (cnt > 0);
>> +out:
>> +	close(net_fd);
>> +	return attached;
>> +}
>> +
>> +static int load_prog(void)
>> +{
>> +	struct bpf_insn prog[] = {
>> +		BPF_MOV64_IMM(BPF_REG_0, BPF_OK),
>> +		BPF_EXIT_INSN(),
>> +	};
>> +	int fd;
>> +
>> +	fd = bpf_load_program(BPF_PROG_TYPE_FLOW_DISSECTOR, prog,
>> +			      ARRAY_SIZE(prog), "GPL", 0, NULL, 0);
>> +	CHECK(fd < 0, "bpf_load_program", "ret %d errno %d\n", fd, errno);
>> +
>> +	return fd;
>> +}
>> +
>> +void test_flow_dissector_reattach(void)
>> +{
>> +	int prog_fd[2] = { -1, -1 };
>> +	int err;
>> +
>> +	if (is_attached())
>> +		return;
> Should we call test__skip() here to indicate that the test has been
> skipped?
> Also, do we need to run this test against non-root namespace as well?

Makes sense. Skip the test if anything is attached to root
namespace. Otherwise test twice, once in non-root and once in root
namespace.

[*] The printf() issue.

I've noticed that stdio hijacking that test_progs runner applies doesn't
quite work. printf() seems to skip the FILE stream buffer and write
whole lines directly to stdout. This results in reordered messages on
output.

Here's a distilled reproducer for what test_progs does:

int main(void)
{
	FILE *stream;
	char *buf;
	size_t cnt;

	stream = stdout;
	stdout = open_memstream(&buf, &cnt);
	if (!stdout)
		error(1, errno, "open_memstream");

	printf("foo");
	printf("bar\n");
	printf("baz");
	printf("qux\n");

	fflush(stdout);
	fclose(stdout);

	buf[cnt] = '\0';
	fprintf(stream, "<<%s>>", buf);
	if (buf[cnt-1] != '\n')
		fprintf(stream, "\n");

	free(buf);
	return 0;
}

On output we get:

$ ./hijack_stdout
bar
qux
<<foobaz>>
$

Not sure what's a good fix.

Ideally - dup2(STDOUT_FILENO, ...). But memstream doesn't have an FD.
We can switch to fprintf(stdout, ...) which works for some reason.

-Jakub

>
>> +	prog_fd[0] = load_prog();
>> +	if (prog_fd[0] < 0)
>> +		return;
>> +
>> +	prog_fd[1] = load_prog();
>> +	if (prog_fd[1] < 0)
>> +		goto out_close;
>> +
>> +	err = bpf_prog_attach(prog_fd[0], 0, BPF_FLOW_DISSECTOR, 0);
>> +	if (CHECK(err, "bpf_prog_attach-0", "ret %d errno %d\n", err, errno))
>> +		goto out_close;
>> +
>> +	/* Expect success when attaching a different program */
>> +	err = bpf_prog_attach(prog_fd[1], 0, BPF_FLOW_DISSECTOR, 0);
>> +	if (CHECK(err, "bpf_prog_attach-1", "ret %d errno %d\n", err, errno))
>> +		goto out_detach;
>> +
>> +	/* Expect failure when attaching the same program twice */
>> +	err = bpf_prog_attach(prog_fd[1], 0, BPF_FLOW_DISSECTOR, 0);
>> +	CHECK(!err || errno != EINVAL, "bpf_prog_attach-2",
>> +	      "ret %d errno %d\n", err, errno);
>> +
>> +out_detach:
>> +	err = bpf_prog_detach(0, BPF_FLOW_DISSECTOR);
>> +	CHECK(err, "bpf_prog_detach", "ret %d errno %d\n", err, errno);
>> +
>> +out_close:
>> +	close(prog_fd[1]);
>> +	close(prog_fd[0]);
>> +}
>> --
>> 2.20.1
>>
