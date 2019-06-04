Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACB634130
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 10:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfFDIIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 04:08:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:39488 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfFDIIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 04:08:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 01:08:08 -0700
X-ExtLoop1: 1
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.255.41.153])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jun 2019 01:08:04 -0700
Subject: Re: [RFC PATCH bpf-next 4/4] libbpf: don't remove eBPF resources when
 other xsks are present
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com,
        bpf <bpf@vger.kernel.org>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-5-maciej.fijalkowski@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <470fba94-a47f-83bd-d2c4-83d424dafb38@intel.com>
Date:   Tue, 4 Jun 2019 10:08:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603131907.13395-5-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> In case where multiple xsk sockets are attached to a single interface
> and one of them gets detached, the eBPF maps and program are removed.
> This should not happen as the rest of xsksocks are still using these
> resources.
> 
> In order to fix that, let's have an additional eBPF map with a single
> entry that will be used as a xsks count. During the xsk_socket__delete,
> remove the resources only when this count is equal to 0.  This map is
> not being accessed from eBPF program, so the verifier is not associating
> it with the prog, which in turn makes bpf_obj_get_info_by_fd not
> reporting this map in nr_map_ids field of struct bpf_prog_info. The
> described behaviour brings the need to have this map pinned, so in
> case when socket is being created and the libbpf detects the presence of
> bpf resources, it will be able to access that map.
>

This commit is only needed after #3 is applied, right? So, this is a way 
of refcounting XDP socks?


> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>   tools/lib/bpf/xsk.c | 59 +++++++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index e28bedb0b078..88d2c931ad14 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -44,6 +44,8 @@
>    #define PF_XDP AF_XDP
>   #endif
>   
> +#define XSKS_CNT_MAP_PATH "/sys/fs/bpf/xsks_cnt_map"
> +
>   struct xsk_umem {
>   	struct xsk_ring_prod *fill;
>   	struct xsk_ring_cons *comp;
> @@ -65,6 +67,7 @@ struct xsk_socket {
>   	int prog_fd;
>   	int qidconf_map_fd;
>   	int xsks_map_fd;
> +	int xsks_cnt_map_fd;
>   	__u32 queue_id;
>   	char ifname[IFNAMSIZ];
>   };
> @@ -372,7 +375,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
>   static int xsk_create_bpf_maps(struct xsk_socket *xsk)
>   {
>   	int max_queues;
> -	int fd;
> +	int fd, ret;
>   
>   	max_queues = xsk_get_max_queues(xsk);
>   	if (max_queues < 0)
> @@ -392,6 +395,24 @@ static int xsk_create_bpf_maps(struct xsk_socket *xsk)
>   	}
>   	xsk->xsks_map_fd = fd;
>   
> +	fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "xsks_cnt_map",
> +				 sizeof(int), sizeof(int), 1, 0);
> +	if (fd < 0) {
> +		close(xsk->qidconf_map_fd);
> +		close(xsk->xsks_map_fd);
> +		return fd;
> +	}
> +
> +	ret = bpf_obj_pin(fd, XSKS_CNT_MAP_PATH);
> +	if (ret < 0) {
> +		pr_warning("pinning map failed; is bpffs mounted?\n");
> +		close(xsk->qidconf_map_fd);
> +		close(xsk->xsks_map_fd);
> +		close(fd);
> +		return ret;
> +	}
> +	xsk->xsks_cnt_map_fd = fd;
> +
>   	return 0;
>   }
>   
> @@ -456,8 +477,10 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
>   		close(fd);
>   	}
>   
> +	xsk->xsks_cnt_map_fd = bpf_obj_get(XSKS_CNT_MAP_PATH);
>   	err = 0;
> -	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
> +	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0 ||
> +	    xsk->xsks_cnt_map_fd < 0) {
>   		err = -ENOENT;
>   		xsk_delete_bpf_maps(xsk);
>   	}
> @@ -467,17 +490,25 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
>   	return err;
>   }
>   
> -static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
> +static void xsk_clear_bpf_maps(struct xsk_socket *xsk, long *xsks_cnt_ptr)
>   {
> +	long xsks_cnt, key = 0;
>   	int qid = false;
>   
>   	bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
>   	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
> +	bpf_map_lookup_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt);
> +	if (xsks_cnt)
> +		xsks_cnt--;
> +	bpf_map_update_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt, 0);
> +	if (xsks_cnt_ptr)
> +		*xsks_cnt_ptr = xsks_cnt;

This refcount scheme will not work; There's no synchronization between 
the updates (cross process)!

>   }
>   
>   static int xsk_set_bpf_maps(struct xsk_socket *xsk)
>   {
>   	int qid = true, fd = xsk->fd, err;
> +	long xsks_cnt, key = 0;
>   
>   	err = bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
>   	if (err)
> @@ -487,9 +518,18 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
>   	if (err)
>   		goto out;
>   
> +	err = bpf_map_lookup_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt);
> +	if (err)
> +		goto out;
> +
> +	xsks_cnt++;
> +	err = bpf_map_update_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt, 0);
> +	if (err)
> +		goto out;
> +

Dito.

>   	return 0;
>   out:
> -	xsk_clear_bpf_maps(xsk);
> +	xsk_clear_bpf_maps(xsk, NULL);
>   	return err;
>   }
>   
> @@ -752,13 +792,18 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>   	size_t desc_sz = sizeof(struct xdp_desc);
>   	struct xdp_mmap_offsets off;
>   	socklen_t optlen;
> +	long xsks_cnt;
>   	int err;
>   
>   	if (!xsk)
>   		return;
>   
> -	xsk_clear_bpf_maps(xsk);
> -	xsk_delete_bpf_maps(xsk);
> +	xsk_clear_bpf_maps(xsk, &xsks_cnt);
> +	unlink(XSKS_CNT_MAP_PATH);
> +	if (!xsks_cnt) {
> +		xsk_delete_bpf_maps(xsk);
> +		xsk_remove_xdp_prog(xsk);
> +	}
>   
>   	optlen = sizeof(off);
>   	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
> @@ -774,8 +819,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>   
>   	}
>   
> -	xsk_remove_xdp_prog(xsk);
> -
>   	xsk->umem->refcount--;
>   	/* Do not close an fd that also has an associated umem connected
>   	 * to it.
> 
