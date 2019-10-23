Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205E0E19AA
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 14:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391213AbfJWMMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 08:12:34 -0400
Received: from proxmox-new.maurer-it.com ([212.186.127.180]:10505 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389256AbfJWMMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 08:12:34 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Oct 2019 08:12:32 EDT
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 9E7FC46109;
        Wed, 23 Oct 2019 14:04:48 +0200 (CEST)
Date:   Wed, 23 Oct 2019 14:04:46 +0200
From:   Wolfgang Bumiller <w.bumiller@proxmox.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting
 files table
Message-ID: <20191023120446.75oxdwom34nhe3l5@olga.proxmox.com>
References: <20191017212858.13230-1-axboe@kernel.dk>
 <20191017212858.13230-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017212858.13230-2-axboe@kernel.dk>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 03:28:56PM -0600, Jens Axboe wrote:
> This is in preparation for adding opcodes that need to modify files
> in a process file table, either adding new ones or closing old ones.
> 
> If an opcode needs this, it must set REQ_F_NEED_FILES in the request
> structure. If work that needs to get punted to async context have this
> set, they will grab a reference to the process file table. When the
> work is completed, the reference is dropped again.

I think IORING_OP_SENDMSG and _RECVMSG need to set this flag due to
SCM_RIGHTS control messages.
Thought I'd reply here since I just now ran into the issue that I was
getting ever-increasing wrong file descriptor numbers on pretty much
ever "other" async recvmsg() call I did via io-uring while receiving
file descriptors from lxc for the seccomp-notify proxy. (I'm currently
running an ubuntu based 5.3.1 kernel)
I ended up finding them in /proc - they show up in all kernel threads,
eg.:

root:/root # grep Name /proc/9/status
Name:   mm_percpu_wq
root:/root # ls -l /proc/9/fd
total 0
lr-x------ 1 root root 64 Oct 23 12:00 0 -> '/proc/512 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 1 -> /proc/512/mem
lr-x------ 1 root root 64 Oct 23 12:00 10 -> '/proc/11782 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 11 -> /proc/11782/mem
lr-x------ 1 root root 64 Oct 23 12:00 12 -> '/proc/12210 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 13 -> /proc/12210/mem
lr-x------ 1 root root 64 Oct 23 12:00 14 -> '/proc/12298 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 15 -> /proc/12298/mem
lr-x------ 1 root root 64 Oct 23 12:00 16 -> '/proc/13955 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 17 -> /proc/13955/mem
lr-x------ 1 root root 64 Oct 23 12:00 18 -> '/proc/13989 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 19 -> /proc/13989/mem
lr-x------ 1 root root 64 Oct 23 12:00 2 -> '/proc/584 (deleted)'
lr-x------ 1 root root 64 Oct 23 12:00 20 -> '/proc/15502 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 21 -> /proc/15502/mem
lr-x------ 1 root root 64 Oct 23 12:00 22 -> '/proc/15510 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 23 -> /proc/15510/mem
lr-x------ 1 root root 64 Oct 23 12:00 24 -> '/proc/17833 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 25 -> /proc/17833/mem
lr-x------ 1 root root 64 Oct 23 12:00 26 -> '/proc/17836 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 27 -> /proc/17836/mem
lr-x------ 1 root root 64 Oct 23 12:00 28 -> '/proc/21929 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 29 -> /proc/21929/mem
lrwx------ 1 root root 64 Oct 23 12:00 3 -> /proc/584/mem
lr-x------ 1 root root 64 Oct 23 12:00 30 -> '/proc/22214 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 31 -> /proc/22214/mem
lr-x------ 1 root root 64 Oct 23 12:00 32 -> '/proc/22283 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 33 -> /proc/22283/mem
lr-x------ 1 root root 64 Oct 23 12:00 34 -> '/proc/29795 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 35 -> /proc/29795/mem
lr-x------ 1 root root 64 Oct 23 12:00 36 -> '/proc/30124 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 37 -> /proc/30124/mem
lr-x------ 1 root root 64 Oct 23 12:00 38 -> '/proc/31016 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 39 -> /proc/31016/mem
lr-x------ 1 root root 64 Oct 23 12:00 4 -> '/proc/1632 (deleted)'
lr-x------ 1 root root 64 Oct 23 12:00 40 -> '/proc/4137 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 41 -> /proc/4137/mem
lrwx------ 1 root root 64 Oct 23 12:00 5 -> /proc/1632/mem
lr-x------ 1 root root 64 Oct 23 12:00 6 -> '/proc/3655 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 7 -> /proc/3655/mem
lr-x------ 1 root root 64 Oct 23 12:00 8 -> '/proc/7075 (deleted)'
lrwx------ 1 root root 64 Oct 23 12:00 9 -> /proc/7075/mem
root:/root #

Those are the fds I expected to receive, and I get fd numbers
consistently increasing with them.
lxc sends the syscall-executing process' pidfd and its 'mem' fd via a
socket, but instead of making it to the receiver, they end up there...

I suspect that an async sendmsg() call could potentially end up
accessing those instead of the ones from the sender process, but I
haven't tested it...

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 635856023fdf..ad462237275e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -267,10 +267,11 @@ struct io_ring_ctx {
>  struct sqe_submit {
>  	const struct io_uring_sqe	*sqe;
>  	unsigned short			index;
> +	bool				has_user : 1;
> +	bool				in_async : 1;
> +	bool				needs_fixed_file : 1;
>  	u32				sequence;
> -	bool				has_user;
> -	bool				in_async;
> -	bool				needs_fixed_file;
> +	struct files_struct		*files;
>  };
>  
>  /*
> @@ -323,6 +324,7 @@ struct io_kiocb {
>  #define REQ_F_FAIL_LINK		256	/* fail rest of links */
>  #define REQ_F_SHADOW_DRAIN	512	/* link-drain shadow req */
>  #define REQ_F_TIMEOUT		1024	/* timeout request */
> +#define REQ_F_NEED_FILES	2048	/* needs to assume file table */
>  	u64			user_data;
>  	u32			result;
>  	u32			sequence;
> @@ -2191,6 +2193,7 @@ static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
>  static void io_sq_wq_submit_work(struct work_struct *work)
>  {
>  	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
> +	struct files_struct *old_files = NULL;
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct mm_struct *cur_mm = NULL;
>  	struct async_list *async_list;
> @@ -2220,6 +2223,10 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>  				set_fs(USER_DS);
>  			}
>  		}
> +		if (s->files && !old_files) {
> +			old_files = current->files;
> +			current->files = s->files;
> +		}
>  
>  		if (!ret) {
>  			s->has_user = cur_mm != NULL;
> @@ -2312,6 +2319,11 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>  		unuse_mm(cur_mm);
>  		mmput(cur_mm);
>  	}
> +	if (old_files) {
> +		struct files_struct *files = current->files;
> +		current->files = old_files;
> +		put_files_struct(files);
> +	}
>  }
>  
>  /*
> @@ -2413,6 +2425,8 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  
>  			s->sqe = sqe_copy;
>  			memcpy(&req->submit, s, sizeof(*s));
> +			if (req->flags & REQ_F_NEED_FILES)
> +				req->submit.files = get_files_struct(current);
>  			list = io_async_list_from_sqe(ctx, s->sqe);
>  			if (!io_add_to_prev_work(list, req)) {
>  				if (list)
> @@ -2633,6 +2647,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
>  		s->index = head;
>  		s->sqe = &ctx->sq_sqes[head];
>  		s->sequence = ctx->cached_sq_head;
> +		s->files = NULL;
>  		ctx->cached_sq_head++;
>  		return true;
>  	}
> -- 
> 2.17.1

