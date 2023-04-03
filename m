Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858176D40C3
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbjDCJhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbjDCJhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:37:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CBE113C9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 02:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680514476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ulg/F/r820dRfA6FQkFXL5bHXxB5mNDwPgL2A7xP1ZE=;
        b=F7VZDA5pgKzf6YKJ8cV0jPWur72P42oDIdCxu1rgf14XSlQwZID1B4Ub6CmTUL2Y/CJwGk
        lndd6z1h8dnbvdevbItBP410p7utsSHMv7fSa0xrLU0KeMXTaSuHFdknSu5epX403L3CFK
        3E2RHr0EGJftBVUo1dJuIA8KHwUyKkM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-uoDUZXZiOZiE_dWbWKljmw-1; Mon, 03 Apr 2023 05:34:33 -0400
X-MC-Unique: uoDUZXZiOZiE_dWbWKljmw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F1BA1C05147;
        Mon,  3 Apr 2023 09:34:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A26AF1121314;
        Mon,  3 Apr 2023 09:34:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-34-dhowells@redhat.com>
References: <20230331160914.1608208-34-dhowells@redhat.com> <20230331160914.1608208-1-dhowells@redhat.com>
To:     Tom Herbert <tom@herbertland.com>, Tom Herbert <tom@quantonium.net>
Cc:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Is AF_KCM functional?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1817940.1680514468.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 03 Apr 2023 10:34:28 +0100
Message-ID: <1817941.1680514468@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Okay, I have a test program for AF_KCM that builds and works up to a point=
.
However, it doesn't seem to work for two reasons:

 (1) When it clones a socket with SIOCKCMCLONE, it doesn't set the LSM con=
text
     on the new socket.  This results in EACCES if, say, SELinux is enforc=
ing.

	ioctl(8, SIOCPROTOPRIVATE, 0x7ffe17cc3b24) =3D 0
	ioctl(9, SIOCPROTOPRIVATE, 0x7ffe17cc3b24) =3D -1 EACCES (Permission deni=
ed)

     from the SIOCKCMATTACH ioctl, so this won't work on a number of Linux
     distributions, such as Fedora and RHEL.

 (2) Assuming SELinux is set to non-enforcing mode, it then fails when try=
ing
     to attach the cloned KCM socket to the TCP socket:

	ioctl(8, SIOCPROTOPRIVATE, 0x7ffddfb64f84) =3D 0
	ioctl(9, SIOCPROTOPRIVATE, 0x7ffddfb64f84) =3D -1 EALREADY (Operation alr=
eady in progress)

     again from the SIOCKCMATTACH ioctl.  This seems to be because the TCP
     socket (csock in kcm_attach() in the kernel) has already got sk_user_=
data
     set from the first ioctl on fd 8:

	if (csk->sk_user_data) {
		write_unlock_bh(&csk->sk_callback_lock);
		kmem_cache_free(kcm_psockp, psock);
		err =3D -EALREADY;
		goto out;
	}

Now, this could be a bug in the test program.  Since both fds 8 and 9 shou=
ld
correspond to the same multiplexor, presumably the TCP socket only needs
attaching once (note that the TCP socket is obtained from accept() in this
case).

David
---
/*
 * A sample program of KCM.
 *
 * $ gcc -lbcc kcm-sample.c
 * $ ./a.out 10000
 *
 * https://gist.github.com/dhowells/24b87fdf731884ed9ca19e9840c0c894
 */
#include <err.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <netdb.h>
#include <poll.h>

#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <netinet/in.h>

/* libbcc */
#include <bcc/bcc_common.h>
#include <bcc/libbpf.h>
#include <bpf/bpf.h>

#include <linux/bpf.h>

/* From linux/kcm.h */
struct kcm_clone {
	int fd;
};

struct kcm_attach {
	int fd;
	int bpf_fd;
};

#ifndef AF_KCM
/* From linux/socket.h */
#define AF_KCM		41	/* Kernel Connection Multiplexor*/
#endif

#ifndef KCMPROTO_CONNECTED
/* From linux/kcm.h */
#define KCMPROTO_CONNECTED	0
#endif

#ifndef SIOCKCMCLONE
/* From linux/sockios.h */
#define SIOCPROTOPRIVATE	0x89E0 /* to 89EF */
/* From linux/kcm.h */
#define SIOCKCMATTACH		(SIOCPROTOPRIVATE + 0)
#define SIOCKCMCLONE		(SIOCPROTOPRIVATE + 2)
#endif

struct my_proto {
	struct _hdr {
		uint32_t len;
	} hdr;
	char data[32];
};

const char *bpf_prog_string =3D "			\
ssize_t bpf_prog1(struct __sk_buff *skb)	\
{						\
	return load_half(skb, 0) + 4;		\
}						\
";

int servsock_init(int port)
{
	int s, error;
	struct sockaddr_in addr;

	s =3D socket(AF_INET, SOCK_STREAM, 0);

	addr.sin_family =3D AF_INET;
	addr.sin_port =3D htons(port);
	addr.sin_addr.s_addr =3D INADDR_ANY;
	error =3D bind(s, (struct sockaddr *)&addr, sizeof(addr));
	if (error =3D=3D -1)
		err(EXIT_FAILURE, "bind");

	error =3D listen(s, 10);
	if (error =3D=3D -1)
		err(EXIT_FAILURE, "listen");

	return s;
}

int bpf_init(void)
{
	int fd, map_fd;
	void *mod;
	int key;
	long long value =3D 0;

	mod =3D bpf_module_create_c_from_string(bpf_prog_string, 0, NULL, 0, 0, N=
ULL);
	fd =3D bcc_prog_load(
		BPF_PROG_TYPE_SOCKET_FILTER,
		"bpf_prog1",
		bpf_function_start(mod, "bpf_prog1"),
		bpf_function_size(mod, "bpf_prog1"),
		bpf_module_license(mod),
		bpf_module_kern_version(mod),
		0, NULL, 0);

	if (fd =3D=3D -1)
		exit(1);
	return fd;
}

void client(int port)
{
	int s, error;
	struct sockaddr_in addr;
	struct hostent *host;
	struct my_proto my_msg;
	int len;

	printf("client is starting\n");

	s =3D socket(AF_INET, SOCK_STREAM, 0);
	if (s =3D=3D -1)
		err(EXIT_FAILURE, "socket");

	memset(&addr, 0, sizeof(addr));
	addr.sin_family =3D AF_INET;
	addr.sin_port =3D htons(port);
	host =3D gethostbyname("localhost");
	if (host =3D=3D NULL)
		err(EXIT_FAILURE, "gethostbyname");
	memcpy(&addr.sin_addr, host->h_addr, host->h_length);

	error =3D connect(s, (struct sockaddr *)&addr, sizeof(addr));
	if (error =3D=3D -1)
		err(EXIT_FAILURE, "connect");

	len =3D sprintf(my_msg.data, "hello");
	my_msg.data[len] =3D '\0';
	my_msg.hdr.len =3D htons(len + 1);

	len =3D write(s, &my_msg, sizeof(my_msg.hdr) + len + 1);
	if (error =3D=3D -1)
		err(EXIT_FAILURE, "write");
	printf("client sent data\n");

	printf("client is waiting a reply\n");
	len =3D read(s, &my_msg, sizeof(my_msg));
	if (error =3D=3D -1)
		err(EXIT_FAILURE, "read");

	printf("\"%s\" from server\n", my_msg.data);
	printf("client received data\n");

	close(s);
}

int kcm_init(void)
{
	int kcmfd;

	kcmfd =3D socket(AF_KCM, SOCK_DGRAM, KCMPROTO_CONNECTED);
	if (kcmfd =3D=3D -1)
		err(EXIT_FAILURE, "socket(AF_KCM)");

	return kcmfd;
}

int kcm_clone(int kcmfd)
{
	int error;
	struct kcm_clone clone_info;

	memset(&clone_info, 0, sizeof(clone_info));
	error =3D ioctl(kcmfd, SIOCKCMCLONE, &clone_info);
	if (error =3D=3D -1)
		err(EXIT_FAILURE, "ioctl(SIOCKCMCLONE)");

	return clone_info.fd;
}

int kcm_attach(int kcmfd, int csock, int bpf_prog_fd)
{
	int error;
	struct kcm_attach attach_info;

	memset(&attach_info, 0, sizeof(attach_info));
	attach_info.fd =3D csock;
	attach_info.bpf_fd =3D bpf_prog_fd;

	error =3D ioctl(kcmfd, SIOCKCMATTACH, &attach_info);
	if (error =3D=3D -1)
		err(EXIT_FAILURE, "ioctl(SIOCKCMATTACH)");
}

void process(int kcmfd0, int kcmfd1)
{
	struct my_proto my_msg;
	int error, len;
	struct pollfd fds[2];
	struct msghdr msg;
	struct iovec iov;
	int fd;

	fds[0].fd =3D kcmfd0;
	fds[0].events =3D POLLIN;
	fds[0].revents =3D 0;
	fds[1].fd =3D kcmfd1;
	fds[1].events =3D POLLIN;
	fds[1].revents =3D 0;

	printf("server is waiting data\n");
	error =3D poll(fds, 1, -1);
	if (error =3D=3D -1)
		err(EXIT_FAILURE, "poll");

	if (fds[0].revents & POLLIN)
		fd =3D fds[0].fd;
	else if (fds[1].revents & POLLIN)
		fd =3D fds[1].fd;
	iov.iov_base =3D &my_msg;
	iov.iov_len =3D sizeof(my_msg);

	memset(&msg, 0, sizeof(msg));
	msg.msg_iov =3D &iov;
	msg.msg_iovlen =3D 1;

	printf("server is receiving data\n");
	len =3D recvmsg(fd, &msg, 0);
	if (len =3D=3D -1)
		err(EXIT_FAILURE, "recvmsg");
	printf("\"%s\" from client\n", my_msg.data);
	printf("server received data\n");

	len =3D sprintf(my_msg.data, "goodbye");
	my_msg.data[len] =3D '\0';
	my_msg.hdr.len =3D htons(len + 1);

	len =3D sendmsg(fd, &msg, 0);
	if (len =3D=3D -1)
		err(EXIT_FAILURE, "sendmsg");
}

void server(int tcpfd, int bpf_prog_fd)
{
	int kcmfd0, error, kcmfd1;
	struct sockaddr_in client;
	int len, csock;

	printf("server is starting\n");

	kcmfd0 =3D kcm_init();
	kcmfd1 =3D kcm_clone(kcmfd0);

	len =3D sizeof(client);
	csock =3D accept(tcpfd, (struct sockaddr *)&client, &len);
	if (csock =3D=3D -1)
		err(EXIT_FAILURE, "accept");

	kcm_attach(kcmfd0, csock, bpf_prog_fd);
	kcm_attach(kcmfd1, csock, bpf_prog_fd);

	process(kcmfd0, kcmfd1);

	close(kcmfd0);
	close(kcmfd1);
}

int main(int argc, char **argv)
{
	int error, tcpfd, bpf_prog_fd;
	pid_t pid;
	int pipefd[2];
	int dummy;

	if (argc !=3D 2) {
		fprintf(stderr, "Format %s <port>\n", argv[0]);
		exit(2);
	}

	error =3D pipe(pipefd);
	if (error =3D=3D -1)
		err(EXIT_FAILURE, "pipe");

	pid =3D fork();
	if (pid =3D=3D -1)
		err(EXIT_FAILURE, "fork");

	if (pid =3D=3D 0) {
		/* wait for server's ready */
		read(pipefd[0], &dummy, sizeof(dummy));

		client(atoi(argv[1]));

		exit(0);
	}

	tcpfd =3D servsock_init(atoi(argv[1]));
	bpf_prog_fd =3D bpf_init();

	/* tell ready */
	write(pipefd[1], &dummy, sizeof(dummy));

	server(tcpfd, bpf_prog_fd);

	waitpid(pid, NULL, 0);

	close(bpf_prog_fd);
	close(tcpfd);

	return 0;
}

