Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019063DC14F
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 00:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhG3Wz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 18:55:28 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:3578 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhG3Wz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 18:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1627685723; x=1659221723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g5DdgJ6/Lv/ofM8QscbyIrNe0ICSENdBP97EHY1uHpc=;
  b=CfGy/Qu/k50reQRVs3TMMpNyoOjFIpjQPOEVr+Jvp0HAitT4atHX2yVD
   ou07P9u72xKsSMHJsHO2+lDoC0NohU8lZ2zHOtMwOaZqe7D3T1C7YS3LS
   nb39cQEUYktBdvpqMDCUnq+lc+PMThHKBBMD9fsDvXGeb3wyyc7R/r1V5
   Y=;
X-IronPort-AV: E=Sophos;i="5.84,283,1620691200"; 
   d="scan'208";a="130636570"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 30 Jul 2021 22:55:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 2E0E0A23F9;
        Fri, 30 Jul 2021 22:55:19 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 22:55:18 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.90) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 22:55:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <yhs@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>
Subject: Re: [PATCH bpf-next 2/2] selftest/bpf: Implement sample UNIX domain
Date:   Sat, 31 Jul 2021 07:55:09 +0900
Message-ID: <20210730225509.22516-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1994df05-8f01-371f-3c3b-d33d7836878c@fb.com>
References: <1994df05-8f01-371f-3c3b-d33d7836878c@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D12UWC002.ant.amazon.com (10.43.162.253) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Yonghong Song <yhs@fb.com>
Date:   Fri, 30 Jul 2021 09:22:32 -0700
> On 7/30/21 12:58 AM, Kuniyuki Iwashima wrote:
> > From:   Yonghong Song <yhs@fb.com>
> > Date:   Thu, 29 Jul 2021 23:54:26 -0700
> >> On 7/29/21 4:36 PM, Kuniyuki Iwashima wrote:
> >>> If there are no abstract sockets, this prog can output the same result
> >>> compared to /proc/net/unix.
> >>>
> >>>     # cat /sys/fs/bpf/unix | head -n 2
> >>>     Num       RefCount Protocol Flags    Type St Inode Path
> >>>     ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> >>>
> >>>     # cat /proc/net/unix | head -n 2
> >>>     Num       RefCount Protocol Flags    Type St Inode Path
> >>>     ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> >>>
> >>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> >>> ---
> >>>    .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++
> >>>    .../selftests/bpf/progs/bpf_iter_unix.c       | 75 +++++++++++++++++++
> >>>    2 files changed, 92 insertions(+)
> >>>    create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> >>>
> >>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> >>> index 1f1aade56504..4746bac68d36 100644
> >>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> >>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> >>> @@ -13,6 +13,7 @@
> >>>    #include "bpf_iter_tcp6.skel.h"
> >>>    #include "bpf_iter_udp4.skel.h"
> >>>    #include "bpf_iter_udp6.skel.h"
> >>> +#include "bpf_iter_unix.skel.h"
> >>>    #include "bpf_iter_test_kern1.skel.h"
> >>>    #include "bpf_iter_test_kern2.skel.h"
> >>>    #include "bpf_iter_test_kern3.skel.h"
> >>> @@ -313,6 +314,20 @@ static void test_udp6(void)
> >>>    	bpf_iter_udp6__destroy(skel);
> >>>    }
> >>>    
> >>> +static void test_unix(void)
> >>> +{
> >>> +	struct bpf_iter_unix *skel;
> >>> +
> >>> +	skel = bpf_iter_unix__open_and_load();
> >>> +	if (CHECK(!skel, "bpf_iter_unix__open_and_load",
> >>> +		  "skeleton open_and_load failed\n"))
> >>> +		return;
> >>> +
> >>> +	do_dummy_read(skel->progs.dump_unix);
> >>> +
> >>> +	bpf_iter_unix__destroy(skel);
> >>> +}
> >>> +
> >>>    /* The expected string is less than 16 bytes */
> >>>    static int do_read_with_fd(int iter_fd, const char *expected,
> >>>    			   bool read_one_char)
> >>> @@ -1255,6 +1270,8 @@ void test_bpf_iter(void)
> >>>    		test_udp4();
> >>>    	if (test__start_subtest("udp6"))
> >>>    		test_udp6();
> >>> +	if (test__start_subtest("unix"))
> >>> +		test_unix();
> >>>    	if (test__start_subtest("anon"))
> >>>    		test_anon_iter(false);
> >>>    	if (test__start_subtest("anon-read-one-char"))
> >>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> >>> new file mode 100644
> >>> index 000000000000..285ec2f7944d
> >>> --- /dev/null
> >>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> >>> @@ -0,0 +1,75 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>> +/* Copyright Amazon.com Inc. or its affiliates. */
> >>> +#include "bpf_iter.h"
> >>
> >> Could you add bpf_iter__unix to bpf_iter.h similar to bpf_iter__sockmap?
> >> The main purpose is to make test tolerating with old vmlinux.h.
> > 
> > Thank you for explanation!
> > I've understood why it is needed even when the same struct is defined.
> > I'll add it in the next spin.
> > 
> > 
> >>
> >>> +#include "bpf_tracing_net.h"
> >>> +#include <bpf/bpf_helpers.h>
> >>> +#include <bpf/bpf_endian.h>
> >>> +
> >>> +char _license[] SEC("license") = "GPL";
> >>> +
> >>> +#define __SO_ACCEPTCON		(1 << 16)
> >>> +#define UNIX_HASH_SIZE		256
> >>> +#define UNIX_ABSTRACT(unix_sk)	(unix_sk->addr->hash < UNIX_HASH_SIZE)
> >>
> >> Could you add the above three define's in bpf_tracing_net.h?
> >> We try to keep all these common defines in a common header for
> >> potential reusability.
> > 
> > Will do.
> > 
> > 
> >>
> >>> +
> >>> +static long sock_i_ino(const struct sock *sk)
> >>> +{
> >>> +	const struct socket *sk_socket = sk->sk_socket;
> >>> +	const struct inode *inode;
> >>> +	unsigned long ino;
> >>> +
> >>> +	if (!sk_socket)
> >>> +		return 0;
> >>> +
> >>> +	inode = &container_of(sk_socket, struct socket_alloc, socket)->vfs_inode;
> >>> +	bpf_probe_read_kernel(&ino, sizeof(ino), &inode->i_ino);
> >>> +	return ino;
> >>> +}
> >>> +
> >>> +SEC("iter/unix")
> >>> +int dump_unix(struct bpf_iter__unix *ctx)
> >>> +{
> >>> +	struct unix_sock *unix_sk = ctx->unix_sk;
> >>> +	struct sock *sk = (struct sock *)unix_sk;
> >>> +	struct seq_file *seq;
> >>> +	__u32 seq_num;
> >>> +
> >>> +	if (!unix_sk)
> >>> +		return 0;
> >>> +
> >>> +	seq = ctx->meta->seq;
> >>> +	seq_num = ctx->meta->seq_num;
> >>> +	if (seq_num == 0)
> >>> +		BPF_SEQ_PRINTF(seq, "Num       RefCount Protocol Flags    "
> >>> +			       "Type St Inode Path\n");
> >>> +
> >>> +	BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
> >>> +		       unix_sk,
> >>> +		       sk->sk_refcnt.refs.counter,
> >>> +		       0,
> >>> +		       sk->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,
> >>> +		       sk->sk_type,
> >>> +		       sk->sk_socket ?
> >>> +		       (sk->sk_state == TCP_ESTABLISHED ?
> >>> +			SS_CONNECTED : SS_UNCONNECTED) :
> >>> +		       (sk->sk_state == TCP_ESTABLISHED ?
> >>> +			SS_CONNECTING : SS_DISCONNECTING),
> >>> +		       sock_i_ino(sk));
> >>> +
> >>> +	if (unix_sk->addr) {
> >>> +		if (UNIX_ABSTRACT(unix_sk))
> >>> +			/* Abstract UNIX domain socket can contain '\0' in
> >>> +			 * the path, and it should be escaped.  However, it
> >>> +			 * requires loops and the BPF verifier rejects it.
> >>> +			 * So here, print only the escaped first byte to
> >>> +			 * indicate it is an abstract UNIX domain socket.
> >>> +			 * (See: unix_seq_show() and commit e7947ea770d0d)
> >>> +			 */
> >>> +			BPF_SEQ_PRINTF(seq, " @");
> >>> +		else
> >>> +			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
> >>> +	}
> >>
> >> I looked at af_unix.c, for the above "if (unix_sk->addr) { ... }" code,
> >> the following is the kernel source code,
> >>
> >>                   if (u->addr) {  // under unix_table_lock here
> >>                           int i, len;
> >>                           seq_putc(seq, ' ');
> >>
> >>                           i = 0;
> >>                           len = u->addr->len - sizeof(short);
> >>                           if (!UNIX_ABSTRACT(s))
> >>                                   len--;
> >>                           else {
> >>                                   seq_putc(seq, '@');
> >>                                   i++;
> >>                           }
> >>                           for ( ; i < len; i++)
> >>                                   seq_putc(seq, u->addr->name->sun_path[i] ?:
> >>                                            '@');
> >>                   }
> >>
> >> It does not seem to match bpf program non UNIX_ABSTRACT case.
> >> I am not familiar with unix socket so it would be good if you can
> >> explain a little more.
> > 
> > There is three kinds of unix sockets: pathname, unnamed, abstract.  The
> > first two terminate the addr with `\0`, but abstract must start with `\0`
> > and can contain `\0` anywhere in addr.  The `\0` in addr of abstract socket
> > does not have special meaning. [1]
> > 
> > They are inserted into the same hash table in unix_bind(), so the bpf prog
> > matches all of them.
> > 
> > ``` net/unix/af_unix.c
> >    1114		if (sun_path[0])
> >    1115			err = unix_bind_bsd(sk, addr);
> >    1116		else
> >    1117			err = unix_bind_abstract(sk, addr);
> > ```
> > 
> > [1]: https://man7.org/linux/man-pages/man7/unix.7.html
> > 
> > 
> >>
> >> For verifier issue with loops, do we have a maximum upper bound for
> >> u->addr->len? If yes, does bounded loop work?
> > 
> > That has a maximum length in unix_mkname(): sizeof(struct sockaddr_un).
> > 
> > ``` net/unix/af_unix.c
> >     223	/*
> >     224	 *	Check unix socket name:
> >     225	 *		- should be not zero length.
> >     226	 *	        - if started by not zero, should be NULL terminated (FS object)
> >     227	 *		- if started by zero, it is abstract name.
> >     228	 */
> >     229	
> >     230	static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp)
> >     231	{
> > ...
> >     234		if (len <= sizeof(short) || len > sizeof(*sunaddr))
> >     235			return -EINVAL;
> > ...
> >     253	}
> > ```
> > 
> > So, I rewrote the test like this, but it still causes an error.
> > 
> > ```
> > 	if (unix_sk->addr) {
> > 		int i, len;
> > 
> > 		len = unix_sk->addr->len - sizeof(short);
> > 
> > 		if (!UNIX_ABSTRACT(unix_sk)) {
> > 			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
> > 		} else {
> > 			BPF_SEQ_PRINTF(seq, " @");
> > 			i++;
> 
> i++ is not useful here and "i" is not initialized earlier.

Good catch.
I'll remove this.


> 
> > 
> > 			if (len < sizeof(struct sockaddr_un)) {
> > 				for (i = 1 ; i < len; i++)
> > 					BPF_SEQ_PRINTF(seq, "%c",
> > 						       unix_sk->addr->name->sun_path[i] ?:
> > 						       '@');
> > 			}
> > 		}
> > 	}
> > ```
> > 
> > ```
> > processed 196505 insns (limit 1000000) max_states_per_insn 4 total_states 1830 peak_states 1830 mark_read 3
> > ```
> 
> I did some debugging, the main reason is that llvm compiler used "!=" 
> instead of "<" for "i < len" comparison.
> 
>       107:       b4 05 00 00 08 00 00 00 w5 = 8
>       108:       85 00 00 00 7e 00 00 00 call 126
> ;                               for (i = 1 ; i < len; i++)
>       109:       07 09 00 00 01 00 00 00 r9 += 1
>       110:       5d 98 09 00 00 00 00 00 if r8 != r9 goto +9 <LBB0_18>
> 
> 
> Considering "len" is not a constant, for verifier, r8 will never be 
> equal to r9 in the above.
> 
> Digging into llvm compilation, it is llvm pass Induction Variable 
> simplication pass made this code change. I will try to dig more and
> find a solution. In your next revision, could you add the above code
> as a comment so once llvm code gen is improved, we can have proper
> implementation to match /proc/net/unix?

Thanks for debugging!
Ok, I'll include the code and add some note and this thread link in the
commit log.


> 
> > 
> >>
> >>> +
> >>> +	BPF_SEQ_PRINTF(seq, "\n");
> >>> +
> >>> +	return 0;
> >>> +}
