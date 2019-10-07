Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E721CEDA3
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 22:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbfJGUjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 16:39:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:37738 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbfJGUjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 16:39:05 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iHZmS-0005Sc-02; Mon, 07 Oct 2019 22:38:56 +0200
Date:   Mon, 7 Oct 2019 22:38:55 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/5] bpf: Add support for setting chain call
 sequence for programs
Message-ID: <20191007203855.GE27307@pc-66.home>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883723.2092443.3902769602513209987.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157046883723.2092443.3902769602513209987.stgit@alrua-x1>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25595/Mon Oct  7 10:28:44 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 07:20:37PM +0200, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> This adds support for setting and deleting bpf chain call programs through
> a couple of new commands in the bpf() syscall. The CHAIN_ADD and CHAIN_DEL
> commands take two eBPF program fds and a return code, and install the
> 'next' program to be chain called after the 'prev' program if that program
> returns 'retcode'. A retcode of -1 means "wildcard", so that the program
> will be executed regardless of the previous program's return code.
> 
> 
> The syscall command names are based on Alexei's prog_chain example[0],
> which Alan helpfully rebased on current bpf-next. However, the logic and
> program storage is obviously adapted to the execution logic in the previous
> commit.
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf.git/commit/?h=prog_chain&id=f54f45d00f91e083f6aec2abe35b6f0be52ae85b&context=15
> 
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  include/uapi/linux/bpf.h |   10 ++++++
>  kernel/bpf/syscall.c     |   78 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 88 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 1ce80a227be3..b03c23963af8 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -107,6 +107,9 @@ enum bpf_cmd {
>  	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
>  	BPF_MAP_FREEZE,
>  	BPF_BTF_GET_NEXT_ID,
> +	BPF_PROG_CHAIN_ADD,
> +	BPF_PROG_CHAIN_DEL,
> +	BPF_PROG_CHAIN_GET,
>  };
>  
>  enum bpf_map_type {
> @@ -516,6 +519,13 @@ union bpf_attr {
>  		__u64		probe_offset;	/* output: probe_offset */
>  		__u64		probe_addr;	/* output: probe_addr */
>  	} task_fd_query;
> +
> +	struct { /* anonymous struct used by BPF_PROG_CHAIN_* commands */
> +		__u32		prev_prog_fd;
> +		__u32		next_prog_fd;
> +		__u32		retcode;
> +		__u32		next_prog_id;   /* output: prog_id */
> +	};
>  } __attribute__((aligned(8)));
>  
>  /* The description below is an attempt at providing documentation to eBPF
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b8a203a05881..be8112e08a88 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2113,6 +2113,79 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
>  	return ret;
>  }
>  
> +#define BPF_PROG_CHAIN_LAST_FIELD next_prog_id
> +
> +static int bpf_prog_chain(int cmd, const union bpf_attr *attr,
> +			  union bpf_attr __user *uattr)
> +{
> +	struct bpf_prog *prog, *next_prog, *old_prog;
> +	struct bpf_prog **array;
> +	int ret = -EOPNOTSUPP;
> +	u32 index, prog_id;
> +
> +	if (CHECK_ATTR(BPF_PROG_CHAIN))
> +		return -EINVAL;
> +
> +	/* Index 0 is wildcard, encoded as ~0 by userspace */
> +	if (attr->retcode == ((u32) ~0))
> +		index = 0;
> +	else
> +		index = attr->retcode + 1;
> +
> +	if (index >= BPF_NUM_CHAIN_SLOTS)
> +		return -E2BIG;
> +
> +	prog = bpf_prog_get(attr->prev_prog_fd);
> +	if (IS_ERR(prog))
> +		return PTR_ERR(prog);
> +
> +	/* If the chain_calls bit is not set, that's because the chain call flag
> +	 * was not set on program load, and so we can't support chain calls.
> +	 */
> +	if (!prog->chain_calls)
> +		goto out;
> +
> +	array = prog->aux->chain_progs;
> +
> +	switch (cmd) {
> +	case BPF_PROG_CHAIN_ADD:
> +		next_prog = bpf_prog_get(attr->next_prog_fd);
> +		if (IS_ERR(next_prog)) {
> +			ret = PTR_ERR(next_prog);
> +			break;
> +		}
> +		old_prog = xchg(array + index, next_prog);
> +		if (old_prog)
> +			bpf_prog_put(old_prog);
> +		ret = 0;
> +		break;

How are circular dependencies resolved here? Seems the situation is
not prevented, so progs unloaded via XDP won't get the __bpf_prog_free()
call where they then drop the references of all the other progs in the
chain.

> +	case BPF_PROG_CHAIN_DEL:
> +		old_prog = xchg(array + index, NULL);
> +		if (old_prog) {
> +			bpf_prog_put(old_prog);
> +			ret = 0;
> +		} else {
> +			ret = -ENOENT;
> +		}
> +		break;
> +	case BPF_PROG_CHAIN_GET:
> +		old_prog = READ_ONCE(array[index]);
> +		if (old_prog) {
> +			prog_id = old_prog->aux->id;
> +			if (put_user(prog_id, &uattr->next_prog_id))
> +				ret = -EFAULT;
> +			else
> +				ret = 0;
> +		} else
> +			ret = -ENOENT;
> +		break;
> +	}
> +
> +out:
> +	bpf_prog_put(prog);
> +	return ret;
> +}
> +
>  #define BPF_OBJ_GET_NEXT_ID_LAST_FIELD next_id
>  
>  static int bpf_obj_get_next_id(const union bpf_attr *attr,
> @@ -2885,6 +2958,11 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>  	case BPF_PROG_TEST_RUN:
>  		err = bpf_prog_test_run(&attr, uattr);
>  		break;
> +	case BPF_PROG_CHAIN_ADD:
> +	case BPF_PROG_CHAIN_DEL:
> +	case BPF_PROG_CHAIN_GET:
> +		err = bpf_prog_chain(cmd, &attr, uattr);
> +		break;
>  	case BPF_PROG_GET_NEXT_ID:
>  		err = bpf_obj_get_next_id(&attr, uattr,
>  					  &prog_idr, &prog_idr_lock);
> 
