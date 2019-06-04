Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A323412B
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 10:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfFDIHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 04:07:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:36616 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfFDIHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 04:07:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 01:07:30 -0700
X-ExtLoop1: 1
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.255.41.153])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jun 2019 01:07:26 -0700
Subject: Re: [RFC PATCH bpf-next 3/4] libbpf: move xdp program removal to
 libbpf
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com,
        bpf <bpf@vger.kernel.org>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-4-maciej.fijalkowski@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <cf7cf390-39b4-7430-107e-97f068f9c3d9@intel.com>
Date:   Tue, 4 Jun 2019 10:07:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603131907.13395-4-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> Since xsk support in libbpf loads the xdp program interface, make it
> also responsible for its removal. Store the prog id in xsk_socket_config
> so when removing the program we are still able to compare the current
> program id with the id from the attachment time and make a decision
> onward.
> 
> While at it, remove the socket/umem in xdpsock's error path.
>

We're loading a new, or reusing an existing XDP program at socket
creation, but tearing it down at *socket delete* is explicitly left to
the application.

For a per-queue XDP program (tied to the socket), this kind cleanup would
make sense.

The intention with the libbpf AF_XDP support was to leave the XDP
handling to whatever XDP orchestration process availble. It's not part
of libbpf. For convenience, *loading/lookup of the XDP program* was
added even though this was an asymmetry.

For the sample application, this makes sense, but for larger/real
applications?

OTOH I like the idea of a scoped cleanup "when all sockets are gone",
the XDP program + maps are removed.

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>   samples/bpf/xdpsock_user.c | 33 ++++++++++-----------------------
>   tools/lib/bpf/xsk.c        | 32 ++++++++++++++++++++++++++++++++
>   tools/lib/bpf/xsk.h        |  1 +
>   3 files changed, 43 insertions(+), 23 deletions(-)
> 
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index e9dceb09b6d1..123862b16dd4 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -68,7 +68,6 @@ static int opt_queue;
>   static int opt_poll;
>   static int opt_interval = 1;
>   static u32 opt_xdp_bind_flags;
> -static __u32 prog_id;
>   
>   struct xsk_umem_info {
>   	struct xsk_ring_prod fq;
> @@ -170,22 +169,6 @@ static void *poller(void *arg)
>   	return NULL;
>   }
>   
> -static void remove_xdp_program(void)
> -{
> -	__u32 curr_prog_id = 0;
> -
> -	if (bpf_get_link_xdp_id(opt_ifindex, &curr_prog_id, opt_xdp_flags)) {
> -		printf("bpf_get_link_xdp_id failed\n");
> -		exit(EXIT_FAILURE);
> -	}
> -	if (prog_id == curr_prog_id)
> -		bpf_set_link_xdp_fd(opt_ifindex, -1, opt_xdp_flags);
> -	else if (!curr_prog_id)
> -		printf("couldn't find a prog id on a given interface\n");
> -	else
> -		printf("program on interface changed, not removing\n");
> -}
> -
>   static void int_exit(int sig)
>   {
>   	struct xsk_umem *umem = xsks[0]->umem->umem;
> @@ -195,7 +178,6 @@ static void int_exit(int sig)
>   	dump_stats();
>   	xsk_socket__delete(xsks[0]->xsk);
>   	(void)xsk_umem__delete(umem);
> -	remove_xdp_program();
>   
>   	exit(EXIT_SUCCESS);
>   }
> @@ -206,7 +188,16 @@ static void __exit_with_error(int error, const char *file, const char *func,
>   	fprintf(stderr, "%s:%s:%i: errno: %d/\"%s\"\n", file, func,
>   		line, error, strerror(error));
>   	dump_stats();
> -	remove_xdp_program();
> +
> +	if (xsks[0]->xsk)
> +		xsk_socket__delete(xsks[0]->xsk);
> +
> +	if (xsks[0]->umem) {
> +		struct xsk_umem *umem = xsks[0]->umem->umem;
> +
> +		(void)xsk_umem__delete(umem);
> +	}
> +
>   	exit(EXIT_FAILURE);
>   }
>   
> @@ -312,10 +303,6 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
>   	if (ret)
>   		exit_with_error(-ret);
>   
> -	ret = bpf_get_link_xdp_id(opt_ifindex, &prog_id, opt_xdp_flags);
> -	if (ret)
> -		exit_with_error(-ret);
> -
>   	return xsk;
>   }
>   
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 514ab3fb06f4..e28bedb0b078 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -259,6 +259,8 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
>   static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>   {
>   	static const int log_buf_size = 16 * 1024;
> +	struct bpf_prog_info info = {};
> +	__u32 info_len = sizeof(info);
>   	char log_buf[log_buf_size];
>   	int err, prog_fd;
>   
> @@ -321,6 +323,14 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>   		return err;
>   	}
>   
> +	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
> +	if (err) {
> +		pr_warning("can't get prog info - %s\n", strerror(errno));
> +		close(prog_fd);
> +		return err;
> +	}
> +	xsk->config.prog_id = info.id;
> +
>   	xsk->prog_fd = prog_fd;
>   	return 0;
>   }
> @@ -483,6 +493,25 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
>   	return err;
>   }
>   
> +static void xsk_remove_xdp_prog(struct xsk_socket *xsk)
> +{
> +	__u32 prog_id = xsk->config.prog_id;
> +	__u32 curr_prog_id = 0;
> +	int err;
> +
> +	err = bpf_get_link_xdp_id(xsk->ifindex, &curr_prog_id,
> +				  xsk->config.xdp_flags);
> +	if (err)
> +		return;
> +
> +	if (prog_id == curr_prog_id)
> +		bpf_set_link_xdp_fd(xsk->ifindex, -1, xsk->config.xdp_flags);
> +	else if (!curr_prog_id)
> +		pr_warning("couldn't find a prog id on a given interface\n");
> +	else
> +		pr_warning("program on interface changed, not removing\n");
> +}
> +
>   static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>   {
>   	__u32 prog_id = 0;
> @@ -506,6 +535,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>   		err = xsk_lookup_bpf_maps(xsk);
>   		if (err)
>   			goto out_load;
> +		xsk->config.prog_id = prog_id;
>   	}
>   
>   	err = xsk_set_bpf_maps(xsk);
> @@ -744,6 +774,8 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>   
>   	}
>   
> +	xsk_remove_xdp_prog(xsk);
> +
>   	xsk->umem->refcount--;
>   	/* Do not close an fd that also has an associated umem connected
>   	 * to it.
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 82ea71a0f3ec..e1b23e9432c9 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -186,6 +186,7 @@ struct xsk_socket_config {
>   	__u32 tx_size;
>   	__u32 libbpf_flags;
>   	__u32 xdp_flags;
> +	__u32 prog_id;
>   	__u16 bind_flags;
>   };
>   
> 
