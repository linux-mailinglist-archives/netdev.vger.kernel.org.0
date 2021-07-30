Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D083DB4D6
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 10:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbhG3IFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 04:05:24 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:31876 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhG3IFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 04:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1627632320; x=1659168320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KAlOcCd82kniQYzTtnceru5A5CP47vZdJfURd1mMe8E=;
  b=eP5ZHzGTaA/fLWTBunZ0pVmG1FjRQatVNuaa3oZsg/k5ExtcPGD8U6jz
   8kWvRbSkgmBpP6s3bjrQ7GDN7GL7twSjLRBEq6qoLbfHNZhqj3WGeAFBc
   Xo43JAfPAlPXXszwMPKedB06ObBsuSJI6xFS4oy5Q+JKg2C4eVYLvdGj8
   Y=;
X-IronPort-AV: E=Sophos;i="5.84,281,1620691200"; 
   d="scan'208";a="130453350"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 30 Jul 2021 08:05:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id F281622039E;
        Fri, 30 Jul 2021 08:05:16 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 08:05:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.229) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 08:05:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <yhs@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: af_unix: Implement BPF iterator for UNIX domain socket.
Date:   Fri, 30 Jul 2021 17:05:05 +0900
Message-ID: <20210730080505.48959-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <65fa9a82-6e1b-da0f-9cad-9b26771980fd@fb.com>
References: <65fa9a82-6e1b-da0f-9cad-9b26771980fd@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.229]
X-ClientProxiedBy: EX13D19UWA001.ant.amazon.com (10.43.160.169) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Yonghong Song <yhs@fb.com>
Date:   Fri, 30 Jul 2021 00:09:08 -0700
> On 7/29/21 11:53 PM, Kuniyuki Iwashima wrote:
> > From:   Yonghong Song <yhs@fb.com>
> > Date:   Thu, 29 Jul 2021 23:24:41 -0700
> >> On 7/29/21 4:36 PM, Kuniyuki Iwashima wrote:
> >>> This patch implements the BPF iterator for the UNIX domain socket.
> >>>
> >>> Currently, the batch optimization introduced for the TCP iterator in the
> >>> commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
> >>> applied.  It will require replacing the big lock for the hash table with
> >>> small locks for each hash list not to block other processes.
> >>
> >> Thanks for the contribution. The patch looks okay except
> >> missing seq_ops->stop implementation, see below for more explanation.
> >>
> >>>
> >>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> >>> ---
> >>>    include/linux/btf_ids.h |  3 +-
> >>>    net/unix/af_unix.c      | 78 +++++++++++++++++++++++++++++++++++++++++
> >>>    2 files changed, 80 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> >>> index 57890b357f85..bed4b9964581 100644
> >>> --- a/include/linux/btf_ids.h
> >>> +++ b/include/linux/btf_ids.h
> >>> @@ -172,7 +172,8 @@ extern struct btf_id_set name;
> >>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
> >>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
> >>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
> >>> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
> >>> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)			\
> >>> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)
> >>>    
> >>>    enum {
> >>>    #define BTF_SOCK_TYPE(name, str) name,
> >>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> >>> index 89927678c0dc..d45ad87e3a49 100644
> >>> --- a/net/unix/af_unix.c
> >>> +++ b/net/unix/af_unix.c
> >>> @@ -113,6 +113,7 @@
> >>>    #include <linux/security.h>
> >>>    #include <linux/freezer.h>
> >>>    #include <linux/file.h>
> >>> +#include <linux/btf_ids.h>
> >>>    
> >>>    #include "scm.h"
> >>>    
> >>> @@ -2935,6 +2936,49 @@ static const struct seq_operations unix_seq_ops = {
> >>>    	.stop   = unix_seq_stop,
> >>>    	.show   = unix_seq_show,
> >>>    };
> >>> +
> >>> +#ifdef CONFIG_BPF_SYSCALL
> >>> +struct bpf_iter__unix {
> >>> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> >>> +	__bpf_md_ptr(struct unix_sock *, unix_sk);
> >>> +	uid_t uid __aligned(8);
> >>> +};
> >>> +
> >>> +static int unix_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
> >>> +			      struct unix_sock *unix_sk, uid_t uid)
> >>> +{
> >>> +	struct bpf_iter__unix ctx;
> >>> +
> >>> +	meta->seq_num--;  /* skip SEQ_START_TOKEN */
> >>> +	ctx.meta = meta;
> >>> +	ctx.unix_sk = unix_sk;
> >>> +	ctx.uid = uid;
> >>> +	return bpf_iter_run_prog(prog, &ctx);
> >>> +}
> >>> +
> >>> +static int bpf_iter_unix_seq_show(struct seq_file *seq, void *v)
> >>> +{
> >>> +	struct bpf_iter_meta meta;
> >>> +	struct bpf_prog *prog;
> >>> +	struct sock *sk = v;
> >>> +	uid_t uid;
> >>> +
> >>> +	if (v == SEQ_START_TOKEN)
> >>> +		return 0;
> >>> +
> >>> +	uid = from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk));
> >>> +	meta.seq = seq;
> >>> +	prog = bpf_iter_get_info(&meta, false);
> >>> +	return unix_prog_seq_show(prog, &meta, v, uid);
> >>> +}
> >>> +
> >>> +static const struct seq_operations bpf_iter_unix_seq_ops = {
> >>> +	.start	= unix_seq_start,
> >>> +	.next	= unix_seq_next,
> >>> +	.stop	= unix_seq_stop,
> >>
> >> Although it is not required for /proc/net/unix, we should still
> >> implement bpf_iter version of seq_ops->stop here. The main purpose
> >> of bpf_iter specific seq_ops->stop is to call bpf program one
> >> more time after ALL elements have been traversed. Such
> >> functionality is implemented in all other bpf_iter variants.
> > 
> > Thanks for your review!
> > I will implement the extra call in the next spin.
> > 
> > Just out of curiosity, is there a specific use case for the last call?
> 
> We don't have use cases for dumps similar to /proc/net/... etc.
> The original thinking is to permit in-kernel aggregation and the
> seq_ops->stop() bpf program will have an indication as the last
> bpf program invocation for the iterator at which point bpf program
> may wrap up aggregation and send/signal the result to user space.
> I am not sure whether people already used this feature or not, or
> people may have different way to do that (e.g., from user space
> directly checking map value if read() length is 0). But
> bpf seq_ops->stop() provides an in-kernel way for bpf program
> to respond to the end of iterating.

Aggregation, that makes sense.
Thank you!
