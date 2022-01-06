Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57923486B66
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 21:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243959AbiAFUrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 15:47:13 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:44492
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S243919AbiAFUrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 15:47:13 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2022 15:47:11 EST
Received: from integral2.. (unknown [36.68.70.227])
        by gnuweeb.org (Postfix) with ESMTPSA id 37135C1776;
        Thu,  6 Jan 2022 20:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1641501546;
        bh=rds8n0z9xQi7NBqRa6Qi8ixuKhzzrJqUCsLygjT6sEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iv5UVE0R+XCF7BW4mRCWqe7nVlC9O7ni5JPiFmZBKetHozp6DtFGAmxGO75358rwz
         7jTNNHDSCg52vVtzsLB5fKi11iDnxEciDBWLEnQIYPqNqP8hv+gDk/+LCHeAE3Il7w
         fraNUB+An7IF+lLS8wGu/dIYBoKe4LUyNy0jPJVSYqJMny3DiCcnr1iyFwKX8vUgPm
         4LMbzd76B+ANKoo/YCB2oI418l9t0NRTrALRmSGcJO5qBCG9kzEUVBJSW+yqjWOP/z
         +m3JNEbxzfIOdCW5nV7JNK58Hjm4SNyWfxYJxTP1CkPh2VywFikbSKJ1gzK82+zcWe
         DewrQpvaCkDLg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Praveen Kumar <kpraveen.lkml@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nugra <richiisei@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [RFC PATCH v3 3/3] io_uring: Add `sendto(2)` and `recvfrom(2)` support
Date:   Fri,  7 Jan 2022 03:38:50 +0700
Message-Id: <20220106203850.1133211-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <597c1bfc-f8ab-d513-4916-dbd93b05e66a@gmail.com>
References: <20211230115057.139187-3-ammar.faizi@intel.com> <20211230173126.174350-1-ammar.faizi@intel.com> <20211230173126.174350-4-ammar.faizi@intel.com> <597c1bfc-f8ab-d513-4916-dbd93b05e66a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 6 Jan 2022 at 23:01:59 +0530, Praveen Kumar <kpraveen.lkml@gmail.com> wrote:
> On 30-12-2021 23:22, Ammar Faizi wrote:
>> This adds sendto(2) and recvfrom(2) support for io_uring.
>> 
>> New opcodes:
>>   IORING_OP_SENDTO
>>   IORING_OP_RECVFROM
>> 
>> Cc: Nugra <richiisei@gmail.com>
>> Tested-by: Nugra <richiisei@gmail.com>
>> Link: https://github.com/axboe/liburing/issues/397
>> Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
>> ---
>> 
>> v3:
>>   - Fix build error when CONFIG_NET is undefined should be done in
>>     the first patch, not this patch.
>> 
>>   - Add Tested-by tag from Nugra.
>> 
>> v2:
>>   - In `io_recvfrom()`, mark the error check of `move_addr_to_user()`
>>     call as unlikely.
>> 
>>   - Fix build error when CONFIG_NET is undefined.
>> 
>>   - Added Nugra to CC list (tester).
>> ---
>>  fs/io_uring.c                 | 80 +++++++++++++++++++++++++++++++++--
>>  include/uapi/linux/io_uring.h |  2 +
>>  2 files changed, 78 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 7adcb591398f..3726958f8f58 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -575,7 +575,15 @@ struct io_sr_msg {
>>  	union {
>>  		struct compat_msghdr __user	*umsg_compat;
>>  		struct user_msghdr __user	*umsg;
>> -		void __user			*buf;
>> +
>> +		struct {
>> +			void __user		*buf;
>> +			struct sockaddr __user	*addr;
>> +			union {
>> +				int		sendto_addr_len;
>> +				int __user	*recvfrom_addr_len;
>> +			};
>> +		};
>>  	};
>>  	int				msg_flags;
>>  	int				bgid;
>> @@ -1133,6 +1141,19 @@ static const struct io_op_def io_op_defs[] = {
>>  		.needs_file = 1
>>  	},
>>  	[IORING_OP_GETXATTR] = {},
>> +	[IORING_OP_SENDTO] = {
>> +		.needs_file		= 1,
>> +		.unbound_nonreg_file	= 1,
>> +		.pollout		= 1,
>> +		.audit_skip		= 1,
>> +	},
>> +	[IORING_OP_RECVFROM] = {
>> +		.needs_file		= 1,
>> +		.unbound_nonreg_file	= 1,
>> +		.pollin			= 1,
>> +		.buffer_select		= 1,
>> +		.audit_skip		= 1,
>> +	},
>>  };
>>  
>>  /* requests with any of those set should undergo io_disarm_next() */
>> @@ -5216,12 +5237,24 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>  		return -EINVAL;
>>  
>> +	/*
>> +	 * For IORING_OP_SEND{,TO}, the assignment to @sr->umsg
>> +	 * is equivalent to an assignment to @sr->buf.
>> +	 */
>>  	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +
>>  	sr->len = READ_ONCE(sqe->len);
>>  	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
>>  	if (sr->msg_flags & MSG_DONTWAIT)
>>  		req->flags |= REQ_F_NOWAIT;
>>  
>> +	if (req->opcode == IORING_OP_SENDTO) {
>> +		sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>> +		sr->sendto_addr_len = READ_ONCE(sqe->addr3);
>> +	} else {
>> +		sr->addr = (struct sockaddr __user *) NULL;
> 
> Let's have sendto_addr_len  = 0  

Will do in the RFC v5.

> 
>> +	}
>> +
>>  #ifdef CONFIG_COMPAT
>>  	if (req->ctx->compat)
>>  		sr->msg_flags |= MSG_CMSG_COMPAT;
>> @@ -5275,6 +5308,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>  
>>  static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
>>  {
>> +	struct sockaddr_storage address;
>>  	struct io_sr_msg *sr = &req->sr_msg;
>>  	struct msghdr msg;
>>  	struct iovec iov;
>> @@ -5291,10 +5325,20 @@ static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
>>  	if (unlikely(ret))
>>  		return ret;
>>  
>> -	msg.msg_name = NULL;
>> +
>>  	msg.msg_control = NULL;
>>  	msg.msg_controllen = 0;
>> -	msg.msg_namelen = 0;
>> +	if (sr->addr) {
>> +		ret = move_addr_to_kernel(sr->addr, sr->sendto_addr_len,
>> +					  &address);
>> +		if (unlikely(ret < 0))
>> +			goto fail;
>> +		msg.msg_name = (struct sockaddr *) &address;
>> +		msg.msg_namelen = sr->sendto_addr_len;
>> +	} else {
>> +		msg.msg_name = NULL;
>> +		msg.msg_namelen = 0;
>> +	}
>>  
>>  	flags = req->sr_msg.msg_flags;
>>  	if (issue_flags & IO_URING_F_NONBLOCK)
>> @@ -5309,6 +5353,7 @@ static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
>>  			return -EAGAIN;
>>  		if (ret == -ERESTARTSYS)
>>  			ret = -EINTR;
>> +	fail:
>>  		req_set_fail(req);
> 
> I think there is a problem with "fail" goto statement. Not getting
> full clarity on this change. With latest kernel, I see
> req_set_fail(req) inside if check, which I don't see here. Can you
> please resend the patch on latest kernel version. Thanks.

I will send the v5 on top of "for-next" branch in Jens' tree soon.

That is already inside an "if check" anyway. We go to that label when
the move_addr_to_kernel() fails (most of the time it is -EFAULT or
-EINVAL).

That part looks like this (note the if check before the goto):
----------------------------------------------------------------------
	msg.msg_control = NULL;
	msg.msg_controllen = 0;
	if (sr->addr) {
		ret = move_addr_to_kernel(sr->addr, sr->sendto_addr_len,
					  &address);
		if (unlikely(ret < 0))
			goto fail;
		msg.msg_name = (struct sockaddr *) &address;
		msg.msg_namelen = sr->sendto_addr_len;
	} else {
		msg.msg_name = NULL;
		msg.msg_namelen = 0;
	}

	flags = req->sr_msg.msg_flags;
	if (issue_flags & IO_URING_F_NONBLOCK)
		flags |= MSG_DONTWAIT;
	if (flags & MSG_WAITALL)
		min_ret = iov_iter_count(&msg.msg_iter);

	msg.msg_flags = flags;
	ret = sock_sendmsg(sock, &msg);
	if (ret < min_ret) {
		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
			return -EAGAIN;
		if (ret == -ERESTARTSYS)
			ret = -EINTR;
	fail:
		req_set_fail(req);
	}
	__io_req_complete(req, issue_flags, ret, 0);
	return 0;
----------------------------------------------------------------------

>>  	}
>>  	__io_req_complete(req, issue_flags, ret, 0);
>> @@ -5427,13 +5472,25 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>  		return -EINVAL;
>>  
>> +	/*
>> +	 * For IORING_OP_RECV{,FROM}, the assignment to @sr->umsg
>> +	 * is equivalent to an assignment to @sr->buf.
>> +	 */
>>  	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +
>>  	sr->len = READ_ONCE(sqe->len);
>>  	sr->bgid = READ_ONCE(sqe->buf_group);
>>  	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
>>  	if (sr->msg_flags & MSG_DONTWAIT)
>>  		req->flags |= REQ_F_NOWAIT;
>>  
>> +	if (req->opcode == IORING_OP_RECVFROM) {
>> +		sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>> +		sr->recvfrom_addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr3));
>> +	} else {
>> +		sr->addr = (struct sockaddr __user *) NULL;
> 
> I think recvfrom_addr_len should also be pointed to NULL, instead of
> garbage for this case.

Will do in the RFC v5.

> 
>> +	}
>> +
>>  #ifdef CONFIG_COMPAT
>>  	if (req->ctx->compat)
>>  		sr->msg_flags |= MSG_CMSG_COMPAT;
>> @@ -5509,6 +5566,7 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
>>  	struct iovec iov;
>>  	unsigned flags;
>>  	int ret, min_ret = 0;
>> +	struct sockaddr_storage address;
>>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>  
>>  	sock = sock_from_file(req->file);
>> @@ -5526,7 +5584,7 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
>>  	if (unlikely(ret))
>>  		goto out_free;
>>  
>> -	msg.msg_name = NULL;
>> +	msg.msg_name = sr->addr ? (struct sockaddr *) &address : NULL;
>>  	msg.msg_control = NULL;
>>  	msg.msg_controllen = 0;
>>  	msg.msg_namelen = 0;
> 
> I think namelen should also be updated ?

It doesn't have to be updated. From net/socket.c there is a comment
like this:

	/* We assume all kernel code knows the size of sockaddr_storage */
	msg.msg_namelen = 0;

Full __sys_recvfrom() source code, see here:
https://github.com/torvalds/linux/blob/v5.16-rc8/net/socket.c#L2085-L2088

I will add the same comment in next series to clarify this one.

> 
>> @@ -5540,6 +5598,16 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
>>  		min_ret = iov_iter_count(&msg.msg_iter);
>>  
>>  	ret = sock_recvmsg(sock, &msg, flags);
>> +
>> +	if (ret >= 0 && sr->addr != NULL) {
>> +		int tmp;
>> +
>> +		tmp = move_addr_to_user(&address, msg.msg_namelen, sr->addr,
>> +					sr->recvfrom_addr_len);
>> +		if (unlikely(tmp < 0))
>> +			ret = tmp;
>> +	}
>> +
>>  out_free:
>>  	if (ret < min_ret) {
>>  		if (ret == -EAGAIN && force_nonblock)
>> @@ -6778,9 +6846,11 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	case IORING_OP_SYNC_FILE_RANGE:
>>  		return io_sfr_prep(req, sqe);
>>  	case IORING_OP_SENDMSG:
>> +	case IORING_OP_SENDTO:
>>  	case IORING_OP_SEND:
>>  		return io_sendmsg_prep(req, sqe);
>>  	case IORING_OP_RECVMSG:
>> +	case IORING_OP_RECVFROM:
>>  	case IORING_OP_RECV:
>>  		return io_recvmsg_prep(req, sqe);
>>  	case IORING_OP_CONNECT:
>> @@ -7060,12 +7130,14 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>  	case IORING_OP_SENDMSG:
>>  		ret = io_sendmsg(req, issue_flags);
>>  		break;
>> +	case IORING_OP_SENDTO:
>>  	case IORING_OP_SEND:
>>  		ret = io_sendto(req, issue_flags);
>>  		break;
>>  	case IORING_OP_RECVMSG:
>>  		ret = io_recvmsg(req, issue_flags);
>>  		break;
>> +	case IORING_OP_RECVFROM:
>>  	case IORING_OP_RECV:
>>  		ret = io_recvfrom(req, issue_flags);
>>  		break;
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index efc7ac9b3a6b..a360069d1e8e 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -150,6 +150,8 @@ enum {
>>  	IORING_OP_SETXATTR,
>>  	IORING_OP_FGETXATTR,
>>  	IORING_OP_GETXATTR,
>> +	IORING_OP_SENDTO,
>> +	IORING_OP_RECVFROM,
>>  
>>  	/* this goes last, obviously */
>>  	IORING_OP_LAST,
> 
> 
> Regards,
> 
> ~Praveen.
> 

Thanks for the review. I will send the RFC v5 soon.

-- 
Ammar Faizi
