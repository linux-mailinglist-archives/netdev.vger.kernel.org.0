Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFC2596132
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiHPRcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiHPRcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:32:17 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C9857557
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660671136; x=1692207136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gHPlIbOpQx/XBCZH0Hclm5MVd9BsY8O2bJfYBq42Tkw=;
  b=tLl595B6i5TxxSvLrb5WEi1Uj/dXbq0mED2bgqiSbBM/Jwh0SlsE0hrZ
   iPQ6zwZmaLO/XoMuzCZ0bSksQGOuCLX76iIKQFswn1Yp07QFdIhH65Z46
   1Lmpe0eDtW0FHVCyRhUjqjKFNr7lR6XdMIz3nocRELgTKtkzW+zS8xydQ
   4=;
X-IronPort-AV: E=Sophos;i="5.93,241,1654560000"; 
   d="scan'208";a="230340667"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 17:32:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id A203A828BA;
        Tue, 16 Aug 2022 17:32:02 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 17:32:02 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 17:32:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <tkhai@ya.ru>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <viro@zeniv.linux.org.uk>
Subject: [PATCH v2 2/2] af_unix: Add ioctl(SIOCUNIXGRABFDS) to grab files of receive queue skbs
Date:   Tue, 16 Aug 2022 10:31:52 -0700
Message-ID: <20220816173152.98866-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <7eb23b19-5136-ee5f-2027-b2cc85540675@ya.ru>
References: <7eb23b19-5136-ee5f-2027-b2cc85540675@ya.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D15UWA002.ant.amazon.com (10.43.160.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kirill Tkhai <tkhai@ya.ru>
Date:   Tue, 16 Aug 2022 00:22:07 +0300
> When a fd owning a counter of some critical resource, say, of a mount,
> it's impossible to umount that mount and disconnect related block device.
> That fd may be contained in some unix socket receive queue skb.
> 
> Despite we have an interface for detecting such the sockets queues
> (/proc/[PID]/fdinfo/[fd] shows non-zero scm_fds count if so) and
> it's possible to kill that process to release the counter, the problem is
> that there may be several processes, and it's not a good thing to kill
> each of them.
> 
> This patch adds a simple interface to grab files from receive queue,
> so the caller may analyze them, and even do that recursively, if grabbed
> file is unix socket itself. So, the described above problem may be solved
> by this ioctl() in pair with pidfd_getfd().
> 
> Note, that the existing recvmsg(,,MSG_PEEK) is not suitable for that
> purpose, since it modifies peek offset inside socket, and this results
> in a problem in case of examined process uses peek offset itself.
> Additional ptrace freezing of that task plus ioctl(SO_PEEK_OFF) won't help
> too, since that socket may relate to several tasks, and there is no
> reliable and non-racy way to detect that. Also, if the caller of such
> trick will die, the examined task will remain frozen forever. The new
> suggested ioctl(SIOCUNIXGRABFDS) does not have such problems.
> 
> The realization of ioctl(SIOCUNIXGRABFDS) is pretty simple. The only
> interesting thing is protocol with userspace. Firstly, we let userspace
> to know the number of all files in receive queue skbs.

Before calling SIOCUNIXGRABFDS, we have to know nr_all by reading
/proc/[PID]/fdinfo/[fd] to properly set nr_grab and nr_skip?

I'd use the same interface so that we can get it by passing 0 to
todo.


> Then we receive
> fds one by one starting from requested offset. We return number of
> received fds if there is a successfully received fd, and this number
> may be less in case of error or desired fds number lack. Userspace
> may detect that situations by comparison of returned value and
> out.nr_all minus in.nr_skip. Looking over different variant this one
> looks the best for me (I considered returning error in case of error
> and there is a received fd. Also I considered returning number of
> received files as one more member in struct unix_ioc_grab_fds).
> 
> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> ---
>  include/uapi/linux/un.h |   12 ++++++++
>  net/unix/af_unix.c      |   70 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 82 insertions(+)
> 
> diff --git a/include/uapi/linux/un.h b/include/uapi/linux/un.h
> index 0ad59dc8b686..995b358263dd 100644
> --- a/include/uapi/linux/un.h
> +++ b/include/uapi/linux/un.h
> @@ -11,6 +11,18 @@ struct sockaddr_un {
>  	char sun_path[UNIX_PATH_MAX];	/* pathname */
>  };
>  
> +struct unix_ioc_grab_fds {
> +	struct {
> +		int nr_grab;
> +		int nr_skip;

We can save the first validation by using unsigned int.


> +		int *fds;
> +	} in;
> +	struct {
> +		int nr_all;

unsigned int?


> +	} out;
> +};
> +
>  #define SIOCUNIXFILE (SIOCPROTOPRIVATE + 0) /* open a socket file with O_PATH */
> +#define SIOCUNIXGRABFDS (SIOCPROTOPRIVATE + 1) /* grab files from recv queue */
>  
>  #endif /* _LINUX_UN_H */
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index bf338b782fc4..3c7e8049eba1 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -3079,6 +3079,73 @@ static int unix_open_file(struct sock *sk)
>  	return fd;
>  }
>  
> +static int unix_ioc_grab_fds(struct sock *sk, struct unix_ioc_grab_fds __user *uarg)
> +{
> +	int i, todo, skip, count, all, err, done = 0;
> +	struct unix_sock *u = unix_sk(sk);
> +	struct unix_ioc_grab_fds arg;
> +	struct sk_buff *skb = NULL;
> +	struct scm_fp_list *fp;
> +
> +	if (copy_from_user(&arg, uarg, sizeof(arg)))
> +		return -EFAULT;
> +
> +	skip = arg.in.nr_skip;
> +	todo = arg.in.nr_grab;
> +
> +	if (skip < 0 || todo <= 0)

If we accept 0 as a special value for todo:

	if (skip < 0 || todo < 0)

And, unsigned int saves this.


> +		return -EINVAL;
> +	if (mutex_lock_interruptible(&u->iolock))
> +		return -EINTR;
> +
> +	all = atomic_read(&u->scm_stat.nr_fds);
> +	err = -EFAULT;
> +	/* Set uarg->out.nr_all before the first file is received. */
> +	if (put_user(all, &uarg->out.nr_all))
> +		goto unlock;
> +	err = 0;
> +	if (all <= skip)

If we accept 0 as a special value for todo:

	if (all <= skip || !todo)

> +		goto unlock;
> +	if (all - skip < todo)
> +		todo = all - skip;
> +	while (todo) {
> +		spin_lock(&sk->sk_receive_queue.lock);
> +		if (!skb)
> +			skb = skb_peek(&sk->sk_receive_queue);
> +		else
> +			skb = skb_peek_next(skb, &sk->sk_receive_queue);
> +		spin_unlock(&sk->sk_receive_queue.lock);
> +
> +		if (!skb)
> +			goto unlock;
> +
> +		fp = UNIXCB(skb).fp;
> +		count = fp->count;
> +		if (skip >= count) {
> +			skip -= count;
> +			continue;
> +		}
> +
> +		for (i = skip; i < count && todo; i++) {
> +			err = receive_fd_user(fp->fp[i], &arg.in.fds[done], 0);
> +			if (err < 0)
> +				goto unlock;
> +			done++;
> +			todo--;
> +		}
> +		skip = 0;
> +	}
> +unlock:
> +	mutex_unlock(&u->iolock);
> +
> +	/* Return number of fds (non-error) if there is a received file. */
> +	if (done)
> +		return done;

	return err;

You set 0 to err before the loop.

> +	if (err < 0)
> +		return err;
> +	return 0;
> +}
> +
>  static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>  {
>  	struct sock *sk = sock->sk;
> @@ -3113,6 +3180,9 @@ static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>  		}
>  		break;
>  #endif
> +	case SIOCUNIXGRABFDS:
> +		err = unix_ioc_grab_fds(sk, (struct unix_ioc_grab_fds __user *)arg);
> +		break;
>  	default:
>  		err = -ENOIOCTLCMD;
>  		break;
