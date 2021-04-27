Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDD836C994
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbhD0QkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 12:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhD0QkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 12:40:13 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C0EC061574;
        Tue, 27 Apr 2021 09:39:29 -0700 (PDT)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 13RGKVOn023267;
        Tue, 27 Apr 2021 17:39:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=jan2016.eng;
 bh=2Hmcemlbo2jdNhBtz1dfxQfNTRWPflwor64mV9oC3bY=;
 b=YHclnd+WOBsM7kBwHhkyUJKnnEd6UwVFKnJc6JivvMpjhHpUKsLewU1w0jX2zHvdD6w8
 gIVx8xF0/+BT/SIvIyylrKE5xysQZ6bc6oDqxRWmnF6TmrEowVBQXD6fE/iYVfV91fuf
 wVOr2tk0cR4AUrgKVW8fvrzRkwsTEyLAGMRo7GRtf8MgZiSzveSMrVGeyyZhMmQ1rJu6
 uT4B4/3avj4ZJPbJd1xiCHKF1kJnefD1k/vPblqA9glkyPxAuaWWyLHBq5sphUCq2kc2
 VvA5DBMZOfDQGRzcy6RWp+IOv2mZShG79z4FENC3aVBhqMjM/346Ad6JkOQOG2L7sc5z Jw== 
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 386epsn1vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 17:39:00 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.1.2/8.16.1.2) with SMTP id 13RGJhxB026865;
        Tue, 27 Apr 2021 12:38:59 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint8.akamai.com with ESMTP id 384f9fs7jq-1;
        Tue, 27 Apr 2021 12:38:59 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id D41FA606B4;
        Tue, 27 Apr 2021 16:38:58 +0000 (GMT)
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210427034623.46528-1-kuniyu@amazon.co.jp>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <a10fdca5-7772-6edb-cbe6-c3fe66f57391@akamai.com>
Date:   Tue, 27 Apr 2021 12:38:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210427034623.46528-1-kuniyu@amazon.co.jp>
Content-Type: multipart/mixed;
 boundary="------------D5FF992BA3995099CE14D1FF"
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_10:2021-04-27,2021-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270112
X-Proofpoint-GUID: kU5llmi3grBFbRkn9wHlpra05wjvH3Pb
X-Proofpoint-ORIG-GUID: kU5llmi3grBFbRkn9wHlpra05wjvH3Pb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_10:2021-04-27,2021-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270112
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.34)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------D5FF992BA3995099CE14D1FF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit



On 4/26/21 11:46 PM, Kuniyuki Iwashima wrote:
> The SO_REUSEPORT option allows sockets to listen on the same port and to
> accept connections evenly. However, there is a defect in the current
> implementation [1]. When a SYN packet is received, the connection is tied
> to a listening socket. Accordingly, when the listener is closed, in-flight
> requests during the three-way handshake and child sockets in the accept
> queue are dropped even if other listeners on the same port could accept
> such connections.
> 
> This situation can happen when various server management tools restart
> server (such as nginx) processes. For instance, when we change nginx
> configurations and restart it, it spins up new workers that respect the new
> configuration and closes all listeners on the old workers, resulting in the
> in-flight ACK of 3WHS is responded by RST.

Hi Kuniyuki,

I had implemented a different approach to this that I wanted to get your
thoughts about. The idea is to use unix sockets and SCM_RIGHTS to pass the
listen fd (or any other fd) around. Currently, if you have an 'old' webserver
that you want to replace with a 'new' webserver, you would need a separate
process to receive the listen fd and then have that process send the fd to
the new webserver, if they are not running con-currently. So instead what
I'm proposing is a 'delayed close' for a unix socket. That is, one could do:

1) bind unix socket with path '/sockets'
2) sendmsg() the listen fd via the unix socket
2) setsockopt() some 'timeout' on the unix socket (maybe 10 seconds or so)
3) exit/close the old webserver and the listen socket
4) start the new webserver
5) create new unix socket and bind to '/sockets' (if has MAY_WRITE file permissions)
6) recvmsg() the listen fd

So the idea is that we set a timeout on the unix socket. If the new process
does not start and bind to the unix socket, it simply closes, thus releasing
the listen socket. However, if it does bind it can now call recvmsg() and
use the listen fd as normal. It can then simply continue to use the old listen
fds and/or create new ones and drain the old ones.

Thus, the old and new webservers do not have to run concurrently. This doesn't
involve any changes to the tcp layer and can be used to pass any type of fd.
not sure if it's actually useful for anything else though.

I'm not sure if this solves your use-case or not but I thought I'd share it.
One can also inherit the fds like in systemd's socket activation model, but
that again requires another process to hold open the listen fd.

I have a very rough patch (emphasis on rough), that implements this idea that
I'm attaching below to explain it better. It would need a bunch of fixups and
it's against an older kernel, but hopefully gives this direction a better
explanation.

Thanks,

-Jason




> 
> To avoid such a situation, users have to know deeply how the kernel handles
> SYN packets and implement connection draining by eBPF [2]:
> 
>   1. Stop routing SYN packets to the listener by eBPF.
>   2. Wait for all timers to expire to complete requests
>   3. Accept connections until EAGAIN, then close the listener.
> 
>   or
> 
>   1. Start counting SYN packets and accept syscalls using the eBPF map.
>   2. Stop routing SYN packets.
>   3. Accept connections up to the count, then close the listener.
> 
> In either way, we cannot close a listener immediately. However, ideally,
> the application need not drain the not yet accepted sockets because 3WHS
> and tying a connection to a listener are just the kernel behaviour. The
> root cause is within the kernel, so the issue should be addressed in kernel
> space and should not be visible to user space. This patchset fixes it so
> that users need not take care of kernel implementation and connection
> draining. With this patchset, the kernel redistributes requests and
> connections from a listener to the others in the same reuseport group
> at/after close or shutdown syscalls.
> 
> Although some software does connection draining, there are still merits in
> migration. For some security reasons, such as replacing TLS certificates,
> we may want to apply new settings as soon as possible and/or we may not be
> able to wait for connection draining. The sockets in the accept queue have
> not started application sessions yet. So, if we do not drain such sockets,
> they can be handled by the newer listeners and could have a longer
> lifetime. It is difficult to drain all connections in every case, but we
> can decrease such aborted connections by migration. In that sense,
> migration is always better than draining. 
> 
> Moreover, auto-migration simplifies user space logic and also works well in
> a case where we cannot modify and build a server program to implement the
> workaround.
> 
> Note that the source and destination listeners MUST have the same settings
> at the socket API level; otherwise, applications may face inconsistency and
> cause errors. In such a case, we have to use the eBPF program to select a
> specific listener or to cancel migration.
> 
> Special thanks to Martin KaFai Lau for bouncing ideas and exchanging code
> snippets along the way.
> 
> 
> Link:
>  [1] The SO_REUSEPORT socket option
>  https://urldefense.com/v3/__https://lwn.net/Articles/542629/__;!!GjvTz_vk!EfhfOTCU_7XOxhuo8yW-66aU3Arq_7mkRIloYIyJYvsuGuFYTPYMmHvYbG59iA$ 
> 
>  [2] Re: [PATCH 1/1] net: Add SO_REUSEPORT_LISTEN_OFF socket option as drain mode
>  https://urldefense.com/v3/__https://lore.kernel.org/netdev/1458828813.10868.65.camel@edumazet-glaptop3.roam.corp.google.com/__;!!GjvTz_vk!EfhfOTCU_7XOxhuo8yW-66aU3Arq_7mkRIloYIyJYvsuGuFYTPYMmHv5_PVAcw$ 
> 
> 
> Changelog:
>  v4:
>   * Make some functions and variables 'static' in selftest
>   * Remove 'scalability' from the cover letter because it is not
>     primarily reason to use SO_REUSEPORT
> 
>  v3:
>  https://urldefense.com/v3/__https://lore.kernel.org/bpf/20210420154140.80034-1-kuniyu@amazon.co.jp/__;!!GjvTz_vk!EfhfOTCU_7XOxhuo8yW-66aU3Arq_7mkRIloYIyJYvsuGuFYTPYMmHtKFGgFOg$ 
>   * Add sysctl back for reuseport_grow()
>   * Add helper functions to manage socks[]
>   * Separate migration related logic into functions: reuseport_resurrect(),
>     reuseport_stop_listen_sock(), reuseport_migrate_sock()
>   * Clone request_sock to be migrated
>   * Migrate request one by one
>   * Pass child socket to eBPF prog
> 
>  v2:
>  https://urldefense.com/v3/__https://lore.kernel.org/netdev/20201207132456.65472-1-kuniyu@amazon.co.jp/__;!!GjvTz_vk!EfhfOTCU_7XOxhuo8yW-66aU3Arq_7mkRIloYIyJYvsuGuFYTPYMmHtxujEgug$ 
>   * Do not save closed sockets in socks[]
>   * Revert 607904c357c61adf20b8fd18af765e501d61a385
>   * Extract inet_csk_reqsk_queue_migrate() into a single patch
>   * Change the spin_lock order to avoid lockdep warning
>   * Add static to __reuseport_select_sock
>   * Use refcount_inc_not_zero() in reuseport_select_migrated_sock()
>   * Set the default attach type in bpf_prog_load_check_attach()
>   * Define new proto of BPF_FUNC_get_socket_cookie
>   * Fix test to be compiled successfully
>   * Update commit messages
> 
>  v1:
>  https://urldefense.com/v3/__https://lore.kernel.org/netdev/20201201144418.35045-1-kuniyu@amazon.co.jp/__;!!GjvTz_vk!EfhfOTCU_7XOxhuo8yW-66aU3Arq_7mkRIloYIyJYvsuGuFYTPYMmHsPqhRjHg$ 
>   * Remove the sysctl option
>   * Enable migration if eBPF progam is not attached
>   * Add expected_attach_type to check if eBPF program can migrate sockets
>   * Add a field to tell migration type to eBPF program
>   * Support BPF_FUNC_get_socket_cookie to get the cookie of sk
>   * Allocate an empty skb if skb is NULL
>   * Pass req_to_sk(req)->sk_hash because listener's hash is zero
>   * Update commit messages and coverletter
> 
>  RFC:
>  https://urldefense.com/v3/__https://lore.kernel.org/netdev/20201117094023.3685-1-kuniyu@amazon.co.jp/__;!!GjvTz_vk!EfhfOTCU_7XOxhuo8yW-66aU3Arq_7mkRIloYIyJYvsuGuFYTPYMmHsn-5vckQ$ 
> 
> 
> Kuniyuki Iwashima (11):
>   net: Introduce net.ipv4.tcp_migrate_req.
>   tcp: Add num_closed_socks to struct sock_reuseport.
>   tcp: Keep TCP_CLOSE sockets in the reuseport group.
>   tcp: Add reuseport_migrate_sock() to select a new listener.
>   tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
>   tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.
>   tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.
>   bpf: Support BPF_FUNC_get_socket_cookie() for
>     BPF_PROG_TYPE_SK_REUSEPORT.
>   bpf: Support socket migration by eBPF.
>   libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
>   bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
> 
>  Documentation/networking/ip-sysctl.rst        |  20 +
>  include/linux/bpf.h                           |   1 +
>  include/linux/filter.h                        |   2 +
>  include/net/netns/ipv4.h                      |   1 +
>  include/net/request_sock.h                    |   2 +
>  include/net/sock_reuseport.h                  |   9 +-
>  include/uapi/linux/bpf.h                      |  16 +
>  kernel/bpf/syscall.c                          |  13 +
>  net/core/filter.c                             |  23 +-
>  net/core/request_sock.c                       |  38 ++
>  net/core/sock_reuseport.c                     | 337 ++++++++++--
>  net/ipv4/inet_connection_sock.c               | 147 +++++-
>  net/ipv4/inet_hashtables.c                    |   2 +-
>  net/ipv4/sysctl_net_ipv4.c                    |   9 +
>  net/ipv4/tcp_ipv4.c                           |  20 +-
>  net/ipv6/tcp_ipv6.c                           |  14 +-
>  tools/include/uapi/linux/bpf.h                |  16 +
>  tools/lib/bpf/libbpf.c                        |   5 +-
>  tools/testing/selftests/bpf/network_helpers.c |   2 +-
>  tools/testing/selftests/bpf/network_helpers.h |   1 +
>  .../bpf/prog_tests/migrate_reuseport.c        | 484 ++++++++++++++++++
>  .../bpf/progs/test_migrate_reuseport.c        |  51 ++
>  22 files changed, 1151 insertions(+), 62 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
> 

--------------D5FF992BA3995099CE14D1FF
Content-Type: text/x-patch; charset=UTF-8;
 name="unix-persist.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="unix-persist.patch"

commit 834f8a8dca1f508a67dbb36422549901a6df62fc
Author: Jason Baron <jbaron@akamai.com>
Date:   Wed May 24 01:32:33 2017 +0000

    delay close

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index fd60ecc..739cddf 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -27,6 +27,15 @@ struct unix_address {
 	struct sockaddr_un name[0];
 };
 
+struct unix_persist {
+        struct path             path;
+        struct list_head        link;
+        /* queue all packets on here */
+        struct sk_buff_head     receive_queue;
+        struct delayed_work     dw;
+	int			delay;
+};
+
 struct unix_skb_parms {
 	struct pid		*pid;		/* Skb credentials	*/
 	kuid_t			uid;
@@ -63,6 +72,7 @@ struct unix_sock {
 #define UNIX_GC_MAYBE_CYCLE	1
 	struct socket_wq	peer_wq;
 	wait_queue_t		peer_wake;
+	struct unix_persist	*persist;
 };
 
 static inline struct unix_sock *unix_sk(const struct sock *sk)
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 6a7fe76..18a7924 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -124,7 +124,8 @@ EXPORT_SYMBOL_GPL(unix_socket_table);
 DEFINE_SPINLOCK(unix_table_lock);
 EXPORT_SYMBOL_GPL(unix_table_lock);
 static atomic_long_t unix_nr_socks;
-
+LIST_HEAD(unix_persist_head);
+DEFINE_SPINLOCK(unix_persist_lock);
 
 static struct hlist_head *unix_sockets_unbound(void *addr)
 {
@@ -508,6 +509,27 @@ static void unix_sock_destructor(struct sock *sk)
 #endif
 }
 
+static void unix_persist_delayed_work(struct work_struct *work)
+{
+	struct delayed_work *delay = to_delayed_work(work);
+	struct unix_persist *persist = container_of(delay, struct unix_persist, dw);
+	bool del = false;
+
+	spin_lock(&unix_persist_lock);
+	if (!list_empty(&persist->link)) {
+		del = true;
+		list_del_init(&persist->link);
+	}
+	spin_unlock(&unix_persist_lock);
+
+	if (!del)
+		return;
+	
+	skb_queue_purge(&persist->receive_queue);		
+	path_put(&persist->path);
+	kfree(persist);
+}
+
 static void unix_release_sock(struct sock *sk, int embrion)
 {
 	struct unix_sock *u = unix_sk(sk);
@@ -515,6 +537,8 @@ static void unix_release_sock(struct sock *sk, int embrion)
 	struct sock *skpair;
 	struct sk_buff *skb;
 	int state;
+	struct unix_persist *persist;
+	bool do_persist = false;
 
 	unix_remove_socket(sk);
 
@@ -550,12 +574,29 @@ static void unix_release_sock(struct sock *sk, int embrion)
 		unix_peer(sk) = NULL;
 	}
 
-	/* Try to flush out this socket. Throw out buffers at least */
+	persist = u->persist;
+	if (persist) {
+		if (persist->delay && path.dentry) {
+			do_persist = true;
+			path_get(&path);
+			persist->path = path;
+			skb_queue_head_init(&persist->receive_queue);
+			INIT_DELAYED_WORK(&persist->dw, unix_persist_delayed_work);
+			schedule_delayed_work(&persist->dw, msecs_to_jiffies(persist->delay));
+		} else
+			kfree(persist);
+	} 
 
+	/* Try to flush out this socket. Throw out buffers at least */
 	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
+		/* FIXME: persists anything special for listen ??? */
 		if (state == TCP_LISTEN)
 			unix_release_sock(skb->sk, 1);
 		/* passed fds are erased in the kfree_skb hook	      */
+		if (do_persist) {
+			skb_queue_tail(&persist->receive_queue, skb);
+			continue;
+		}
 		UNIXCB(skb).consumed = skb->len;
 		kfree_skb(skb);
 	}
@@ -563,6 +604,12 @@ static void unix_release_sock(struct sock *sk, int embrion)
 	if (path.dentry)
 		path_put(&path);
 
+	if (do_persist) {
+		spin_lock(&unix_persist_lock);
+		list_add(&u->persist->link, &unix_persist_head);
+		spin_unlock(&unix_persist_lock);
+	}
+
 	sock_put(sk);
 
 	/* ---- Socket is dead now and most probably destroyed ---- */
@@ -671,6 +718,93 @@ static int unix_set_peek_off(struct sock *sk, int val)
 	return 0;
 }
 
+#define UNIX_DELAY_CLOSE 1
+#define UNIX_REBIND 2
+#define SOL_UNIX 5
+
+int unix_setsockopt(struct socket *sock, int level, int optname,
+			  char __user *optval, unsigned int optlen)
+{
+	struct sock *sk = sock->sk;
+	struct unix_sock *u = unix_sk(sk);
+	int val;
+	int err = 0;
+
+	/* FIXME lock sock for allocations */
+
+	if (level != SOL_UNIX) {
+		/* FIXME: check return */
+		return -ENOPROTOOPT;
+	}
+	
+	if (optlen < sizeof(int))
+		return -EINVAL;
+
+	if (get_user(val, (int __user *)optval))
+		return -EFAULT;
+
+	switch(optname) {
+	case UNIX_DELAY_CLOSE: {
+		struct unix_persist *tmp;
+		/* limit to 1 minute? */
+		if (val <= 0 || val > 60000)
+			err = -EINVAL;
+		printk("set delay: %d\n", val);
+		if (!u->persist) {
+			tmp = kmalloc(sizeof(struct unix_persist), GFP_KERNEL);
+			if (!tmp) {
+				err = -ENOMEM;
+				break;
+			}
+			if (cmpxchg(&u->persist, NULL, tmp))
+				kfree(tmp);
+		}
+		u->persist->delay = val;
+		break;
+	}
+	default:
+		err = -ENOPROTOOPT;
+		break;
+	}
+	return err;
+}
+
+int unix_getsockopt(struct socket *sock, int level, int optname,
+		    	  char __user *optval, int __user *optlen)
+
+{
+	struct sock *sk = sock->sk;
+	struct unix_sock *u = unix_sk(sk);
+	int val, len;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+	
+	if (len < 0)
+		return -EINVAL;
+
+	switch(optname) {
+	case UNIX_DELAY_CLOSE:
+		if (u->persist)
+			val = u->persist->delay;
+		else
+			val = 0;
+		break;
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	if (len > sizeof(int))
+		len = sizeof(int);
+
+	if (copy_to_user(optval, &val, len))
+		return -EFAULT;
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+
+	return 0;
+}
 
 static const struct proto_ops unix_stream_ops = {
 	.family =	PF_UNIX,
@@ -685,8 +819,8 @@ static const struct proto_ops unix_stream_ops = {
 	.ioctl =	unix_ioctl,
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
-	.setsockopt =	sock_no_setsockopt,
-	.getsockopt =	sock_no_getsockopt,
+	.setsockopt =	unix_setsockopt,
+	.getsockopt =	unix_getsockopt,
 	.sendmsg =	unix_stream_sendmsg,
 	.recvmsg =	unix_stream_recvmsg,
 	.mmap =		sock_no_mmap,
@@ -708,8 +842,8 @@ static const struct proto_ops unix_dgram_ops = {
 	.ioctl =	unix_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
-	.setsockopt =	sock_no_setsockopt,
-	.getsockopt =	sock_no_getsockopt,
+	.setsockopt =	unix_setsockopt,
+	.getsockopt =	unix_getsockopt,
 	.sendmsg =	unix_dgram_sendmsg,
 	.recvmsg =	unix_dgram_recvmsg,
 	.mmap =		sock_no_mmap,
@@ -730,8 +864,8 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.ioctl =	unix_ioctl,
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
-	.setsockopt =	sock_no_setsockopt,
-	.getsockopt =	sock_no_getsockopt,
+	.setsockopt =	unix_setsockopt,
+	.getsockopt =	unix_getsockopt,
 	.sendmsg =	unix_seqpacket_sendmsg,
 	.recvmsg =	unix_seqpacket_recvmsg,
 	.mmap =		sock_no_mmap,
@@ -985,6 +1119,64 @@ static int unix_mknod(const char *sun_path, umode_t mode, struct path *res)
 	return err;
 }
 
+static struct unix_persist *unix_get_persist(struct net *net,
+					struct sockaddr_un *sunname, int len,
+					int type, unsigned int hash)
+{
+	struct inode *inode;
+	struct unix_persist *entry, *res = NULL;
+	struct path path;
+	int err = 0;
+		
+	printk("unix_get_persist: enter\n");
+
+	if (!sunname->sun_path[0]) {
+		printk("unix_get_persist 1\n");
+		return NULL;
+	}
+
+	err = kern_path(sunname->sun_path, LOOKUP_FOLLOW, &path);
+	if (err) {
+		printk("unix_get_persist 2: %s %d\n", sunname->sun_path, err);
+		return NULL;
+	}
+	inode = d_backing_inode(path.dentry);
+	err = inode_permission(inode, MAY_WRITE);
+	if (err) {
+		printk("unix_get_persist 3\n");
+		goto out;
+	}
+	
+	if (!S_ISSOCK(inode->i_mode)) {
+		printk("unix_get_persist 4\n");
+		spin_lock(&unix_persist_lock);
+		list_for_each_entry(entry, &unix_persist_head, link) {
+			struct dentry *dentry = entry->path.dentry;	
+
+			printk("unix_get_persist: %p %p\n", d_backing_inode(dentry), inode);
+		}
+		spin_unlock(&unix_persist_lock);
+		goto out;
+	}
+
+	spin_lock(&unix_persist_lock);
+	list_for_each_entry(entry, &unix_persist_head, link) {
+		struct dentry *dentry = entry->path.dentry;	
+
+		printk("unix_get_delayed_close: %p %p\n", d_backing_inode(dentry), inode);
+		if (dentry && d_backing_inode(dentry) == inode) {
+			list_del_init(&entry->link);
+			res = entry;
+			break;
+		}
+	}
+	spin_unlock(&unix_persist_lock);
+
+out:
+	path_put(&path);
+	return res;
+}
+
 static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
 	struct sock *sk = sock->sk;
@@ -997,6 +1189,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	struct unix_address *addr;
 	struct hlist_head *list;
 	struct path path = { };
+	
 
 	err = -EINVAL;
 	if (sunaddr->sun_family != AF_UNIX)
@@ -1013,13 +1206,38 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	addr_len = err;
 
 	if (sun_path[0]) {
-		umode_t mode = S_IFSOCK |
-		       (SOCK_INODE(sock)->i_mode & ~current_umask());
-		err = unix_mknod(sun_path, mode, &path);
-		if (err) {
-			if (err == -EEXIST)
-				err = -EADDRINUSE;
-			goto out;
+		/* first check if we can bind to existing socket */
+		struct unix_persist *persist = unix_get_persist(net,
+					sunaddr, addr_len,
+					sock->type, hash); 
+		if (persist) {
+			struct sk_buff *skb = NULL;
+
+			cancel_delayed_work(&persist->dw);
+			unix_state_lock(sk);
+			if (skb_queue_len(&sk->sk_receive_queue) + skb_queue_len(&persist->receive_queue) > sk->sk_max_ack_backlog) {
+				unix_state_unlock(sk);
+				skb_queue_purge(&persist->receive_queue);
+				kfree(persist);
+				goto out;
+			}
+			while ((skb = skb_dequeue(&persist->receive_queue)) != NULL) {
+				skb_queue_tail(&sk->sk_receive_queue, skb);
+			}
+			unix_state_unlock(sk);
+			path = persist->path;
+			kfree(persist);
+			/* FIXME: test if queue is not empty */
+			sk->sk_data_ready(sk);
+		} else {
+			umode_t mode = S_IFSOCK |
+		       		(SOCK_INODE(sock)->i_mode & ~current_umask());
+			err = unix_mknod(sun_path, mode, &path);
+			if (err) {
+				if (err == -EEXIST)
+					err = -EADDRINUSE;
+				goto out;
+			}
 		}
 	}
 

--------------D5FF992BA3995099CE14D1FF--
