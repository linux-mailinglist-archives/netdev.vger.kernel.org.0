Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AFA3DB4C7
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 09:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbhG3H6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 03:58:33 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:63519 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237851AbhG3H6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 03:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1627631908; x=1659167908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Seg20H61FP6EoR0CLITcEsQA41nqrcOuSz+c1tUaV18=;
  b=jCFIfT2dPdwTGhK97lDjzEIKiD4e9Xmvcod++DvsC+JyVdE7x/D46sq9
   5HWhP4kmvK1d9O8+cd4ik4yivFAiEjpag/hzrqXomNqH9bariRlPyzRHG
   7I3sd6CqJteHpk6pOk4xJg1GCutPuz6i+0Xjpisi54qgpZcHYq+ZWQjPI
   w=;
X-IronPort-AV: E=Sophos;i="5.84,281,1620691200"; 
   d="scan'208";a="139024773"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 30 Jul 2021 07:58:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 6E5A6A1859;
        Fri, 30 Jul 2021 07:58:24 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 07:58:23 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.69) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 07:58:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <yhs@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>
Subject: Re: [PATCH bpf-next 2/2] selftest/bpf: Implement sample UNIX domain
Date:   Fri, 30 Jul 2021 16:58:06 +0900
Message-ID: <20210730075806.48560-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <0a16fcbb-1c17-dfe2-24b0-6f1d1e6a91bd@fb.com>
References: <0a16fcbb-1c17-dfe2-24b0-6f1d1e6a91bd@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D35UWC003.ant.amazon.com (10.43.162.130) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Yonghong Song <yhs@fb.com>
Date:   Thu, 29 Jul 2021 23:54:26 -0700
> On 7/29/21 4:36 PM, Kuniyuki Iwashima wrote:
> > If there are no abstract sockets, this prog can output the same result
> > compared to /proc/net/unix.
> > 
> >    # cat /sys/fs/bpf/unix | head -n 2
> >    Num       RefCount Protocol Flags    Type St Inode Path
> >    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> > 
> >    # cat /proc/net/unix | head -n 2
> >    Num       RefCount Protocol Flags    Type St Inode Path
> >    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >   .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++
> >   .../selftests/bpf/progs/bpf_iter_unix.c       | 75 +++++++++++++++++++
> >   2 files changed, 92 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> > index 1f1aade56504..4746bac68d36 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> > @@ -13,6 +13,7 @@
> >   #include "bpf_iter_tcp6.skel.h"
> >   #include "bpf_iter_udp4.skel.h"
> >   #include "bpf_iter_udp6.skel.h"
> > +#include "bpf_iter_unix.skel.h"
> >   #include "bpf_iter_test_kern1.skel.h"
> >   #include "bpf_iter_test_kern2.skel.h"
> >   #include "bpf_iter_test_kern3.skel.h"
> > @@ -313,6 +314,20 @@ static void test_udp6(void)
> >   	bpf_iter_udp6__destroy(skel);
> >   }
> >   
> > +static void test_unix(void)
> > +{
> > +	struct bpf_iter_unix *skel;
> > +
> > +	skel = bpf_iter_unix__open_and_load();
> > +	if (CHECK(!skel, "bpf_iter_unix__open_and_load",
> > +		  "skeleton open_and_load failed\n"))
> > +		return;
> > +
> > +	do_dummy_read(skel->progs.dump_unix);
> > +
> > +	bpf_iter_unix__destroy(skel);
> > +}
> > +
> >   /* The expected string is less than 16 bytes */
> >   static int do_read_with_fd(int iter_fd, const char *expected,
> >   			   bool read_one_char)
> > @@ -1255,6 +1270,8 @@ void test_bpf_iter(void)
> >   		test_udp4();
> >   	if (test__start_subtest("udp6"))
> >   		test_udp6();
> > +	if (test__start_subtest("unix"))
> > +		test_unix();
> >   	if (test__start_subtest("anon"))
> >   		test_anon_iter(false);
> >   	if (test__start_subtest("anon-read-one-char"))
> > diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> > new file mode 100644
> > index 000000000000..285ec2f7944d
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> > @@ -0,0 +1,75 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright Amazon.com Inc. or its affiliates. */
> > +#include "bpf_iter.h"
> 
> Could you add bpf_iter__unix to bpf_iter.h similar to bpf_iter__sockmap?
> The main purpose is to make test tolerating with old vmlinux.h.

Thank you for explanation!
I've understood why it is needed even when the same struct is defined.
I'll add it in the next spin. 


> 
> > +#include "bpf_tracing_net.h"
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_endian.h>
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +#define __SO_ACCEPTCON		(1 << 16)
> > +#define UNIX_HASH_SIZE		256
> > +#define UNIX_ABSTRACT(unix_sk)	(unix_sk->addr->hash < UNIX_HASH_SIZE)
> 
> Could you add the above three define's in bpf_tracing_net.h?
> We try to keep all these common defines in a common header for
> potential reusability.

Will do.


> 
> > +
> > +static long sock_i_ino(const struct sock *sk)
> > +{
> > +	const struct socket *sk_socket = sk->sk_socket;
> > +	const struct inode *inode;
> > +	unsigned long ino;
> > +
> > +	if (!sk_socket)
> > +		return 0;
> > +
> > +	inode = &container_of(sk_socket, struct socket_alloc, socket)->vfs_inode;
> > +	bpf_probe_read_kernel(&ino, sizeof(ino), &inode->i_ino);
> > +	return ino;
> > +}
> > +
> > +SEC("iter/unix")
> > +int dump_unix(struct bpf_iter__unix *ctx)
> > +{
> > +	struct unix_sock *unix_sk = ctx->unix_sk;
> > +	struct sock *sk = (struct sock *)unix_sk;
> > +	struct seq_file *seq;
> > +	__u32 seq_num;
> > +
> > +	if (!unix_sk)
> > +		return 0;
> > +
> > +	seq = ctx->meta->seq;
> > +	seq_num = ctx->meta->seq_num;
> > +	if (seq_num == 0)
> > +		BPF_SEQ_PRINTF(seq, "Num       RefCount Protocol Flags    "
> > +			       "Type St Inode Path\n");
> > +
> > +	BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
> > +		       unix_sk,
> > +		       sk->sk_refcnt.refs.counter,
> > +		       0,
> > +		       sk->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,
> > +		       sk->sk_type,
> > +		       sk->sk_socket ?
> > +		       (sk->sk_state == TCP_ESTABLISHED ?
> > +			SS_CONNECTED : SS_UNCONNECTED) :
> > +		       (sk->sk_state == TCP_ESTABLISHED ?
> > +			SS_CONNECTING : SS_DISCONNECTING),
> > +		       sock_i_ino(sk));
> > +
> > +	if (unix_sk->addr) {
> > +		if (UNIX_ABSTRACT(unix_sk))
> > +			/* Abstract UNIX domain socket can contain '\0' in
> > +			 * the path, and it should be escaped.  However, it
> > +			 * requires loops and the BPF verifier rejects it.
> > +			 * So here, print only the escaped first byte to
> > +			 * indicate it is an abstract UNIX domain socket.
> > +			 * (See: unix_seq_show() and commit e7947ea770d0d)
> > +			 */
> > +			BPF_SEQ_PRINTF(seq, " @");
> > +		else
> > +			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
> > +	}
> 
> I looked at af_unix.c, for the above "if (unix_sk->addr) { ... }" code,
> the following is the kernel source code,
> 
>                  if (u->addr) {  // under unix_table_lock here
>                          int i, len;
>                          seq_putc(seq, ' ');
> 
>                          i = 0;
>                          len = u->addr->len - sizeof(short);
>                          if (!UNIX_ABSTRACT(s))
>                                  len--;
>                          else {
>                                  seq_putc(seq, '@');
>                                  i++;
>                          }
>                          for ( ; i < len; i++)
>                                  seq_putc(seq, u->addr->name->sun_path[i] ?:
>                                           '@');
>                  }
> 
> It does not seem to match bpf program non UNIX_ABSTRACT case.
> I am not familiar with unix socket so it would be good if you can 
> explain a little more.

There is three kinds of unix sockets: pathname, unnamed, abstract.  The
first two terminate the addr with `\0`, but abstract must start with `\0`
and can contain `\0` anywhere in addr.  The `\0` in addr of abstract socket
does not have special meaning. [1]

They are inserted into the same hash table in unix_bind(), so the bpf prog
matches all of them.

``` net/unix/af_unix.c
  1114		if (sun_path[0])
  1115			err = unix_bind_bsd(sk, addr);
  1116		else
  1117			err = unix_bind_abstract(sk, addr);
```

[1]: https://man7.org/linux/man-pages/man7/unix.7.html


> 
> For verifier issue with loops, do we have a maximum upper bound for 
> u->addr->len? If yes, does bounded loop work?

That has a maximum length in unix_mkname(): sizeof(struct sockaddr_un).

``` net/unix/af_unix.c
   223	/*
   224	 *	Check unix socket name:
   225	 *		- should be not zero length.
   226	 *	        - if started by not zero, should be NULL terminated (FS object)
   227	 *		- if started by zero, it is abstract name.
   228	 */
   229	
   230	static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp)
   231	{
...
   234		if (len <= sizeof(short) || len > sizeof(*sunaddr))
   235			return -EINVAL;
...
   253	}
```

So, I rewrote the test like this, but it still causes an error.

```
	if (unix_sk->addr) {
		int i, len;

		len = unix_sk->addr->len - sizeof(short);

		if (!UNIX_ABSTRACT(unix_sk)) {
			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
		} else {
			BPF_SEQ_PRINTF(seq, " @");
			i++;

			if (len < sizeof(struct sockaddr_un)) {
				for (i = 1 ; i < len; i++)
					BPF_SEQ_PRINTF(seq, "%c",
						       unix_sk->addr->name->sun_path[i] ?:
						       '@');
			}
		}
	}
```

```
processed 196505 insns (limit 1000000) max_states_per_insn 4 total_states 1830 peak_states 1830 mark_read 3
```


> 
> > +
> > +	BPF_SEQ_PRINTF(seq, "\n");
> > +
> > +	return 0;
> > +}
