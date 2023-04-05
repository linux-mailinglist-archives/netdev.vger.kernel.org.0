Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01A76D8428
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbjDEQym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjDEQyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:54:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9D7188
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680713630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TEbJfA2XN3YS2bVTA2W3okmrsaJKbACj3JMzRKlRxcU=;
        b=af/BDPQj9/5LxiaTkl2I5tolr3vDmeKIJJFmwjaw5UYzKQQMOUontz17tBzZWI43bgmDhk
        z5+nggVuu5GS0WmIdHa93z6588XAPsXGBx0Yo2SSiAhfZOCgSWYPqCKucHl3MIsjn+o11t
        HCPgClMhsxfT+Kyeg0BJEgmFbCtpQaQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-Ma9Js4ofNX2CEUj3eZmXIg-1; Wed, 05 Apr 2023 12:53:48 -0400
X-MC-Unique: Ma9Js4ofNX2CEUj3eZmXIg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADC8B3823A04;
        Wed,  5 Apr 2023 16:53:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CAB2202701F;
        Wed,  5 Apr 2023 16:53:45 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH net-next v4 01/20] net: Add samples for network I/O and splicing
Date:   Wed,  5 Apr 2023 17:53:20 +0100
Message-Id: <20230405165339.3468808-2-dhowells@redhat.com>
In-Reply-To: <20230405165339.3468808-1-dhowells@redhat.com>
References: <20230405165339.3468808-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some small sample programs for doing network I/O including splicing.

There are three IPv4/IPv6 servers: tcp-sink, tls-sink and udp-sink.  They
can be given a port number by passing "-p <port>" and will listen on an
IPv6 socket unless given a "-4" flag, in which case they'll listen for IPv4
only.

There are three IPv4/IPv6 clients: tcp-send, tls-send and udp-send.  They
are given a file to get data from (or "-" for stdin) and the name of a
server to talk to.  They can also be given a port number by passing "-p
<port>", "-4" or "-6" to force the use of IPv4 or IPv6, "-s" to indicate
they should use splice/sendfile to transfer the data and "-z" to specify
how much data to copy.  If "-s" is given, the input will be spliced if it's
a pipe and sendfiled otherwise.

A driver program, splice-out, is provided to splice data from a file/stdin
to stdout and can be used to pipe into the aforementioned clients for
testing splice.  This takes the name of the file to splice from (or "-" for
stdin).  It can also be given "-w <size>" to indicate the maximum size of
each splice, "-k <size>" if a chunk of the input should be skipped between
splices to prevent coalescence and "-s" if sendfile should be used instead
of splice.

Additionally, there is an AF_UNIX client and server.  These are similar to
the IPv[46] programs, except both take a socket path and there is no option
to change the port number.

And then there are two AF_ALG clients (there is no server).  These are
similar to the other clients, except no destination is specified.  One
exercised skcipher encryption and the other hashing.

Examples include:

	./splice-out -w0x400 /foo/16K 4K | ./alg-encrypt -s -
	./splice-out -w0x400 /foo/1M | ./unix-send -s - /tmp/foo
	./splice-out -w0x400 /foo/16K 16K -w1 | ./tls-send -s6 -z16K - servbox
	./tcp-send /bin/ls 192.168.6.1
	./udp-send -4 -p5555 /foo/4K localhost

where, for example, /foo/16K is a 16KiB file.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: netdev@vger.kernel.org
---
 samples/Kconfig           |   6 ++
 samples/Makefile          |   1 +
 samples/net/Makefile      |  13 +++
 samples/net/alg-encrypt.c | 201 ++++++++++++++++++++++++++++++++++++++
 samples/net/alg-hash.c    | 143 +++++++++++++++++++++++++++
 samples/net/splice-out.c  | 142 +++++++++++++++++++++++++++
 samples/net/tcp-send.c    | 154 +++++++++++++++++++++++++++++
 samples/net/tcp-sink.c    |  76 ++++++++++++++
 samples/net/tls-send.c    | 176 +++++++++++++++++++++++++++++++++
 samples/net/tls-sink.c    |  98 +++++++++++++++++++
 samples/net/udp-send.c    | 151 ++++++++++++++++++++++++++++
 samples/net/udp-sink.c    |  82 ++++++++++++++++
 samples/net/unix-send.c   | 147 ++++++++++++++++++++++++++++
 samples/net/unix-sink.c   |  51 ++++++++++
 14 files changed, 1441 insertions(+)
 create mode 100644 samples/net/Makefile
 create mode 100644 samples/net/alg-encrypt.c
 create mode 100644 samples/net/alg-hash.c
 create mode 100644 samples/net/splice-out.c
 create mode 100644 samples/net/tcp-send.c
 create mode 100644 samples/net/tcp-sink.c
 create mode 100644 samples/net/tls-send.c
 create mode 100644 samples/net/tls-sink.c
 create mode 100644 samples/net/udp-send.c
 create mode 100644 samples/net/udp-sink.c
 create mode 100644 samples/net/unix-send.c
 create mode 100644 samples/net/unix-sink.c

diff --git a/samples/Kconfig b/samples/Kconfig
index 30ef8bd48ba3..14051e9f7532 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -273,6 +273,12 @@ config SAMPLE_CORESIGHT_SYSCFG
 	  This demonstrates how a user may create their own CoreSight
 	  configurations and easily load them into the system at runtime.
 
+config SAMPLE_NET
+	bool "Build example programs that drive network protocols"
+	depends on NET
+	help
+	  Build example userspace programs that drive network protocols.
+
 source "samples/rust/Kconfig"
 
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 7cb632ef88ee..22c1d6244eaf 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -37,3 +37,4 @@ obj-$(CONFIG_DEBUG_KMEMLEAK_TEST)	+= kmemleak/
 obj-$(CONFIG_SAMPLE_CORESIGHT_SYSCFG)	+= coresight/
 obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
+obj-$(CONFIG_SAMPLE_NET)		+= net/
diff --git a/samples/net/Makefile b/samples/net/Makefile
new file mode 100644
index 000000000000..0ccd68a36edf
--- /dev/null
+++ b/samples/net/Makefile
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only
+userprogs-always-y += \
+	alg-hash \
+	alg-encrypt \
+	splice-out \
+	tcp-send \
+	tcp-sink \
+	tls-send \
+	tls-sink \
+	udp-send \
+	udp-sink \
+	unix-send \
+	unix-sink
diff --git a/samples/net/alg-encrypt.c b/samples/net/alg-encrypt.c
new file mode 100644
index 000000000000..34a62a9c480a
--- /dev/null
+++ b/samples/net/alg-encrypt.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* AF_ALG hash test
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <getopt.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/un.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/sendfile.h>
+#include <linux/if_alg.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+#define min(x, y) ((x) < (y) ? (x) : (y))
+
+static unsigned char buffer[4096 * 32] __attribute__((aligned(4096)));
+static unsigned char iv[16];
+static unsigned char key[16];
+
+static const struct sockaddr_alg sa = {
+	.salg_family	= AF_ALG,
+	.salg_type	= "skcipher",
+	.salg_name	= "cbc(aes)",
+};
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "alg-send [-s] [-z<size>] <file>|-\n");
+	exit(2);
+}
+
+static void algif_add_set_op(struct msghdr *msg, unsigned int op)
+{
+	struct cmsghdr *__cmsg;
+
+	__cmsg = msg->msg_control + msg->msg_controllen;
+	__cmsg->cmsg_len	= CMSG_LEN(sizeof(unsigned int));
+	__cmsg->cmsg_level	= SOL_ALG;
+	__cmsg->cmsg_type	= ALG_SET_OP;
+	*(unsigned int *)CMSG_DATA(__cmsg) = op;
+	msg->msg_controllen += CMSG_ALIGN(__cmsg->cmsg_len);
+}
+
+static void algif_add_set_iv(struct msghdr *msg, const void *iv, size_t ivlen)
+{
+	struct af_alg_iv *ivbuf;
+	struct cmsghdr *__cmsg;
+
+	printf("%zx\n", msg->msg_controllen);
+	__cmsg = msg->msg_control + msg->msg_controllen;
+	__cmsg->cmsg_len	= CMSG_LEN(sizeof(*ivbuf) + ivlen);
+	__cmsg->cmsg_level	= SOL_ALG;
+	__cmsg->cmsg_type	= ALG_SET_IV;
+	ivbuf = (struct af_alg_iv *)CMSG_DATA(__cmsg);
+	ivbuf->ivlen = ivlen;
+	memcpy(ivbuf->iv, iv, ivlen);
+	msg->msg_controllen += CMSG_ALIGN(__cmsg->cmsg_len);
+}
+
+int main(int argc, char *argv[])
+{
+	struct msghdr msg;
+	struct stat st;
+	const char *filename;
+	unsigned char ctrl[4096];
+	ssize_t r, w, o, ret;
+	size_t size = LONG_MAX, total = 0, i, out = 160;
+	char *end;
+	bool use_sendfile = false, all = true;
+	int opt, alg, sock, fd = 0;
+
+	while ((opt = getopt(argc, argv, "sz:")) != EOF) {
+		switch (opt) {
+		case 's':
+			use_sendfile = true;
+			break;
+		case 'z':
+			size = strtoul(optarg, &end, 0);
+			switch (*end) {
+			case 'K':
+			case 'k':
+				size *= 1024;
+				break;
+			case 'M':
+			case 'm':
+				size *= 1024 * 1024;
+				break;
+			}
+			all = false;
+			break;
+		default:
+			format();
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+	if (argc != 1)
+		format();
+	filename = argv[0];
+
+	alg = socket(AF_ALG, SOCK_SEQPACKET, 0);
+	OSERROR(alg, "AF_ALG");
+	OSERROR(bind(alg, (struct sockaddr *)&sa, sizeof(sa)), "bind");
+	OSERROR(setsockopt(alg, SOL_ALG, ALG_SET_KEY, key, sizeof(key)), "ALG_SET_KEY");
+	sock = accept(alg, NULL, 0);
+	OSERROR(sock, "accept");
+
+	if (strcmp(filename, "-") != 0) {
+		fd = open(filename, O_RDONLY);
+		OSERROR(fd, filename);
+		OSERROR(fstat(fd, &st), filename);
+		size = st.st_size;
+	} else {
+		OSERROR(fstat(fd, &st), argv[2]);
+	}
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_control = ctrl;
+	algif_add_set_op(&msg, ALG_OP_ENCRYPT);
+	algif_add_set_iv(&msg, iv, sizeof(iv));
+
+	OSERROR(sendmsg(sock, &msg, MSG_MORE), "sock/sendmsg");
+
+	if (!use_sendfile) {
+		bool more = false;
+
+		while (size) {
+			r = read(fd, buffer, sizeof(buffer));
+			OSERROR(r, filename);
+			if (r == 0)
+				break;
+			size -= r;
+
+			o = 0;
+			do {
+				more = size > 0;
+				w = send(sock, buffer + o, r - o,
+					 more ? MSG_MORE : 0);
+				OSERROR(w, "sock/send");
+				total += w;
+				o += w;
+			} while (o < r);
+		}
+
+		if (more)
+			send(sock, NULL, 0, 0);
+	} else if (S_ISFIFO(st.st_mode)) {
+		do {
+			r = splice(fd, NULL, sock, NULL, size,
+				   size > 0 ? SPLICE_F_MORE : 0);
+			OSERROR(r, "sock/splice");
+			size -= r;
+			total += r;
+		} while (r > 0 && size > 0);
+		if (size && !all) {
+			fprintf(stderr, "Short splice\n");
+			exit(1);
+		}
+	} else {
+		r = sendfile(sock, fd, NULL, size);
+		OSERROR(r, "sock/sendfile");
+		if (r != size) {
+			fprintf(stderr, "Short sendfile\n");
+			exit(1);
+		}
+		total = r;
+	}
+
+	while (total > 0) {
+		ret = read(sock, buffer, min(sizeof(buffer), total));
+		OSERROR(ret, "sock/read");
+		if (ret == 0)
+			break;
+		total -= ret;
+
+		if (out > 0) {
+			ret = min(out, ret);
+			out -= ret;
+			for (i = 0; i < ret; i++)
+				printf("%02x", (unsigned char)buffer[i]);
+		}
+		printf("...\n");
+	}
+
+	OSERROR(close(sock), "sock/close");
+	OSERROR(close(alg), "alg/close");
+	OSERROR(close(fd), "close");
+	return 0;
+}
diff --git a/samples/net/alg-hash.c b/samples/net/alg-hash.c
new file mode 100644
index 000000000000..842a8016acb3
--- /dev/null
+++ b/samples/net/alg-hash.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* AF_ALG hash test
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <getopt.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/un.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/sendfile.h>
+#include <linux/if_alg.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+
+static unsigned char buffer[4096 * 32] __attribute__((aligned(4096)));
+
+static const struct sockaddr_alg sa = {
+	.salg_family	= AF_ALG,
+	.salg_type	= "hash",
+	.salg_name	= "sha1",
+};
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "alg-send [-s] [-z<size>] <file>|-\n");
+	exit(2);
+}
+
+int main(int argc, char *argv[])
+{
+	struct stat st;
+	const char *filename;
+	ssize_t r, w, o, ret;
+	size_t size = LONG_MAX, i;
+	char *end;
+	int use_sendfile = 0;
+	int opt, alg, sock, fd = 0;
+
+	while ((opt = getopt(argc, argv, "sz:")) != EOF) {
+		switch (opt) {
+		case 's':
+			use_sendfile = true;
+			break;
+		case 'z':
+			size = strtoul(optarg, &end, 0);
+			switch (*end) {
+			case 'K':
+			case 'k':
+				size *= 1024;
+				break;
+			case 'M':
+			case 'm':
+				size *= 1024 * 1024;
+				break;
+			}
+			break;
+		default:
+			format();
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+	if (argc != 1)
+		format();
+	filename = argv[0];
+
+	alg = socket(AF_ALG, SOCK_SEQPACKET, 0);
+	OSERROR(alg, "AF_ALG");
+	OSERROR(bind(alg, (struct sockaddr *)&sa, sizeof(sa)), "bind");
+	sock = accept(alg, NULL, 0);
+	OSERROR(sock, "accept");
+
+	if (strcmp(filename, "-") != 0) {
+		fd = open(filename, O_RDONLY);
+		OSERROR(fd, filename);
+		OSERROR(fstat(fd, &st), filename);
+		size = st.st_size;
+	} else {
+		OSERROR(fstat(fd, &st), argv[2]);
+	}
+
+	if (!use_sendfile) {
+		bool more = false;
+
+		while (size) {
+			r = read(fd, buffer, sizeof(buffer));
+			OSERROR(r, filename);
+			if (r == 0)
+				break;
+			size -= r;
+
+			o = 0;
+			do {
+				more = size > 0;
+				w = send(sock, buffer + o, r - o,
+					 more ? MSG_MORE : 0);
+				OSERROR(w, "sock/send");
+				o += w;
+			} while (o < r);
+		}
+
+		if (more)
+			send(sock, NULL, 0, 0);
+	} else if (S_ISFIFO(st.st_mode)) {
+		r = splice(fd, NULL, sock, NULL, size, 0);
+		OSERROR(r, "sock/splice");
+		if (r != size) {
+			fprintf(stderr, "Short splice\n");
+			exit(1);
+		}
+	} else {
+		r = sendfile(sock, fd, NULL, size);
+		OSERROR(r, "sock/sendfile");
+		if (r != size) {
+			fprintf(stderr, "Short sendfile\n");
+			exit(1);
+		}
+	}
+
+	ret = read(sock, buffer, sizeof(buffer));
+	OSERROR(ret, "sock/read");
+
+	for (i = 0; i < ret; i++)
+		printf("%02x", (unsigned char)buffer[i]);
+	printf("\n");
+
+	OSERROR(close(sock), "sock/close");
+	OSERROR(close(alg), "alg/close");
+	OSERROR(close(fd), "close");
+	return 0;
+}
diff --git a/samples/net/splice-out.c b/samples/net/splice-out.c
new file mode 100644
index 000000000000..07bc0d774779
--- /dev/null
+++ b/samples/net/splice-out.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Splice or sendfile from the given file/stdin to stdout.
+ *
+ * Format: splice-out [-s] <file>|- [<size>]
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <sys/stat.h>
+#include <sys/sendfile.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+#define min(x, y) ((x) < (y) ? (x) : (y))
+
+static unsigned char buffer[4096] __attribute__((aligned(4096)));
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "splice-out [-kN][-s][-wN] <file>|- [<size>]\n");
+	exit(2);
+}
+
+int main(int argc, char *argv[])
+{
+	const char *filename;
+	struct stat st;
+	ssize_t r;
+	size_t size = 1024 * 1024, skip = 0, unit = 0, part;
+	char *end;
+	bool use_sendfile = false, all = true;
+	int opt, fd = 0;
+
+	while ((opt = getopt(argc, argv, "k:sw:")),
+	       opt != -1) {
+		switch (opt) {
+		case 'k':
+			/* Skip size - prevent coalescence. */
+			skip = strtoul(optarg, &end, 0);
+			if (skip < 1 || skip >= 4096) {
+				fprintf(stderr, "-kN must be 0<N<4096\n");
+				exit(2);
+			}
+			break;
+		case 's':
+			use_sendfile = 1;
+			break;
+		case 'w':
+			/* Write unit size */
+			unit = strtoul(optarg, &end, 0);
+			if (!unit) {
+				fprintf(stderr, "-wN must be >0\n");
+				exit(2);
+			}
+			switch (*end) {
+			case 'K':
+			case 'k':
+				unit *= 1024;
+				break;
+			case 'M':
+			case 'm':
+				unit *= 1024 * 1024;
+				break;
+			}
+			break;
+		default:
+			format();
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+
+	if (argc != 1 && argc != 2)
+		format();
+
+	filename = argv[0];
+	if (argc == 2) {
+		size = strtoul(argv[1], &end, 0);
+		switch (*end) {
+		case 'K':
+		case 'k':
+			size *= 1024;
+			break;
+		case 'M':
+		case 'm':
+			size *= 1024 * 1024;
+			break;
+		}
+		all = false;
+	}
+
+	OSERROR(fstat(1, &st), "stdout");
+	if (!S_ISFIFO(st.st_mode)) {
+		fprintf(stderr, "stdout must be a pipe\n");
+		exit(3);
+	}
+
+	if (strcmp(filename, "-") != 0) {
+		fd = open(filename, O_RDONLY);
+		OSERROR(fd, filename);
+		OSERROR(fstat(fd, &st), filename);
+		if (!all && size > st.st_size) {
+			fprintf(stderr, "%s: Specified size larger than file\n", filename);
+			exit(3);
+		}
+	}
+
+	do {
+		if (skip) {
+			part = skip;
+			do {
+				r = read(fd, buffer, skip);
+				OSERROR(r, filename);
+				part -= r;
+			} while (part > 0 && r > 0);
+		}
+
+		part = unit ? min(size, unit) : size;
+		if (use_sendfile) {
+			r = sendfile(1, fd, NULL, part);
+			OSERROR(r, "sendfile");
+		} else {
+			r = splice(fd, NULL, 1, NULL, part, 0);
+			OSERROR(r, "splice");
+		}
+		if (!all)
+			size -= r;
+	} while (r > 0 && size > 0);
+
+	OSERROR(close(fd), "close");
+	return 0;
+}
diff --git a/samples/net/tcp-send.c b/samples/net/tcp-send.c
new file mode 100644
index 000000000000..153105f6a30a
--- /dev/null
+++ b/samples/net/tcp-send.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * TCP send client.  Pass -s to splice.
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <getopt.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <netdb.h>
+#include <netinet/in.h>
+#include <sys/stat.h>
+#include <sys/sendfile.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+
+static unsigned char buffer[4096] __attribute__((aligned(4096)));
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "tcp-send [-46s][-p<port>][-z<size>] <file>|- <server>\n");
+	exit(2);
+}
+
+int main(int argc, char *argv[])
+{
+	struct addrinfo *addrs = NULL, hints = {};
+	struct stat st;
+	const char *filename, *sockname, *service = "5555";
+	ssize_t r, w, o;
+	size_t size = LONG_MAX;
+	char *end;
+	bool use_sendfile = false;
+	int opt, sock, fd = 0, gai;
+
+	hints.ai_family   = AF_UNSPEC;
+	hints.ai_socktype = SOCK_STREAM;
+
+	while ((opt = getopt(argc, argv, "46p:sz:")) != EOF) {
+		switch (opt) {
+		case '4':
+			hints.ai_family = AF_INET;
+			break;
+		case '6':
+			hints.ai_family = AF_INET6;
+			break;
+		case 'p':
+			service = optarg;
+			break;
+		case 's':
+			use_sendfile = true;
+			break;
+		case 'z':
+			size = strtoul(optarg, &end, 0);
+			switch (*end) {
+			case 'K':
+			case 'k':
+				size *= 1024;
+				break;
+			case 'M':
+			case 'm':
+				size *= 1024 * 1024;
+				break;
+			}
+			break;
+		default:
+			format();
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+	if (argc != 2)
+		format();
+	filename = argv[0];
+	sockname = argv[1];
+
+	gai = getaddrinfo(sockname, service, &hints, &addrs);
+	if (gai) {
+		fprintf(stderr, "%s: %s\n", sockname, gai_strerror(gai));
+		exit(3);
+	}
+
+	if (!addrs) {
+		fprintf(stderr, "%s: No addresses\n", sockname);
+		exit(3);
+	}
+
+	sockname = addrs->ai_canonname;
+	sock = socket(addrs->ai_family, addrs->ai_socktype, addrs->ai_protocol);
+	OSERROR(sock, "socket");
+	OSERROR(connect(sock, addrs->ai_addr, addrs->ai_addrlen), "connect");
+
+	if (strcmp(filename, "-") != 0) {
+		fd = open(filename, O_RDONLY);
+		OSERROR(fd, filename);
+		OSERROR(fstat(fd, &st), filename);
+		if (size > st.st_size)
+			size = st.st_size;
+	} else {
+		OSERROR(fstat(fd, &st), filename);
+	}
+
+	if (!use_sendfile) {
+		bool more = false;
+
+		while (size) {
+			r = read(fd, buffer, sizeof(buffer));
+			OSERROR(r, filename);
+			if (r == 0)
+				break;
+			size -= r;
+
+			o = 0;
+			do {
+				more = size > 0;
+				w = send(sock, buffer + o, r - o,
+					 more ? MSG_MORE : 0);
+				OSERROR(w, "sock/send");
+				o += w;
+			} while (o < r);
+		}
+
+		if (more)
+			send(sock, NULL, 0, 0);
+	} else if (S_ISFIFO(st.st_mode)) {
+		r = splice(fd, NULL, sock, NULL, size, 0);
+		OSERROR(r, "sock/splice");
+		if (r != size) {
+			fprintf(stderr, "Short splice\n");
+			exit(1);
+		}
+	} else {
+		r = sendfile(sock, fd, NULL, size);
+		OSERROR(r, "sock/sendfile");
+		if (r != size) {
+			fprintf(stderr, "Short sendfile\n");
+			exit(1);
+		}
+	}
+
+	OSERROR(close(sock), "sock/close");
+	OSERROR(close(fd), "close");
+	return 0;
+}
diff --git a/samples/net/tcp-sink.c b/samples/net/tcp-sink.c
new file mode 100644
index 000000000000..33d949d0e9aa
--- /dev/null
+++ b/samples/net/tcp-sink.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * TCP sink server
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <getopt.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <netinet/in.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+
+static unsigned char buffer[512 * 1024] __attribute__((aligned(4096)));
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "tcp-sink [-4][-p<port>]\n");
+	exit(2);
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned int port = 5555;
+	bool ipv6 = true;
+	int opt, server_sock, sock;
+
+
+	while ((opt = getopt(argc, argv, "4p:")) != EOF) {
+		switch (opt) {
+		case '4':
+			ipv6 = false;
+			break;
+		case 'p':
+			port = atoi(optarg);
+			break;
+		default:
+			format();
+		}
+	}
+
+	if (!ipv6) {
+		struct sockaddr_in sin = {
+			.sin_family = AF_INET,
+			.sin_port   = htons(port),
+		};
+		server_sock = socket(AF_INET, SOCK_STREAM, 0);
+		OSERROR(server_sock, "socket");
+		OSERROR(bind(server_sock, (struct sockaddr *)&sin, sizeof(sin)), "bind");
+		OSERROR(listen(server_sock, 1), "listen");
+	} else {
+		struct sockaddr_in6 sin6 = {
+			.sin6_family = AF_INET6,
+			.sin6_port   = htons(port),
+		};
+		server_sock = socket(AF_INET6, SOCK_STREAM, 0);
+		OSERROR(server_sock, "socket");
+		OSERROR(bind(server_sock, (struct sockaddr *)&sin6, sizeof(sin6)), "bind");
+		OSERROR(listen(server_sock, 1), "listen");
+	}
+
+	for (;;) {
+		sock = accept(server_sock, NULL, NULL);
+		if (sock != -1) {
+			while (read(sock, buffer, sizeof(buffer)) > 0) {}
+			close(sock);
+		}
+	}
+}
diff --git a/samples/net/tls-send.c b/samples/net/tls-send.c
new file mode 100644
index 000000000000..b3b8a0a3b41f
--- /dev/null
+++ b/samples/net/tls-send.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * TLS-over-TCP send client.  Pass -s to splice.
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <getopt.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <netdb.h>
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+#include <sys/stat.h>
+#include <sys/sendfile.h>
+#include <linux/tls.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+
+static unsigned char buffer[4096] __attribute__((aligned(4096)));
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "tls-send [-46s][-p<port>][-z<size>] <file>|- <server>\n");
+	exit(2);
+}
+
+static void set_tls(int sock)
+{
+	struct tls12_crypto_info_aes_gcm_128 crypto_info;
+
+	crypto_info.info.version = TLS_1_2_VERSION;
+	crypto_info.info.cipher_type = TLS_CIPHER_AES_GCM_128;
+	memset(crypto_info.iv,		0, TLS_CIPHER_AES_GCM_128_IV_SIZE);
+	memset(crypto_info.rec_seq,	0, TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
+	memset(crypto_info.key,		0, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	memset(crypto_info.salt,	0, TLS_CIPHER_AES_GCM_128_SALT_SIZE);
+
+	OSERROR(setsockopt(sock, SOL_TCP, TCP_ULP, "tls", sizeof("tls")),
+		"TCP_ULP");
+	OSERROR(setsockopt(sock, SOL_TLS, TLS_TX, &crypto_info, sizeof(crypto_info)),
+		"TLS_TX");
+	OSERROR(setsockopt(sock, SOL_TLS, TLS_RX, &crypto_info, sizeof(crypto_info)),
+		"TLS_RX");
+}
+
+int main(int argc, char *argv[])
+{
+	struct addrinfo *addrs = NULL, hints = {};
+	struct stat st;
+	const char *filename, *sockname, *service = "5556";
+	ssize_t r, w, o;
+	size_t size = LONG_MAX;
+	char *end;
+	bool use_sendfile = false;
+	int opt, sock, fd = 0, gai;
+
+	hints.ai_family   = AF_UNSPEC;
+	hints.ai_socktype = SOCK_STREAM;
+
+	while ((opt = getopt(argc, argv, "46p:sz:")) != EOF) {
+		switch (opt) {
+		case '4':
+			hints.ai_family = AF_INET;
+			break;
+		case '6':
+			hints.ai_family = AF_INET6;
+			break;
+		case 'p':
+			service = optarg;
+			break;
+		case 's':
+			use_sendfile = true;
+			break;
+		case 'z':
+			size = strtoul(optarg, &end, 0);
+			switch (*end) {
+			case 'K':
+			case 'k':
+				size *= 1024;
+				break;
+			case 'M':
+			case 'm':
+				size *= 1024 * 1024;
+				break;
+			}
+			break;
+		default:
+			format();
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+	if (argc != 2)
+		format();
+	filename = argv[0];
+	sockname = argv[1];
+
+	gai = getaddrinfo(sockname, service, &hints, &addrs);
+	if (gai) {
+		fprintf(stderr, "%s: %s\n", sockname, gai_strerror(gai));
+		exit(3);
+	}
+
+	if (!addrs) {
+		fprintf(stderr, "%s: No addresses\n", sockname);
+		exit(3);
+	}
+
+	sockname = addrs->ai_canonname;
+	sock = socket(addrs->ai_family, addrs->ai_socktype, addrs->ai_protocol);
+	OSERROR(sock, "socket");
+	OSERROR(connect(sock, addrs->ai_addr, addrs->ai_addrlen), "connect");
+	set_tls(sock);
+
+	if (strcmp(filename, "-") != 0) {
+		fd = open(filename, O_RDONLY);
+		OSERROR(fd, filename);
+		OSERROR(fstat(fd, &st), filename);
+		if (size > st.st_size)
+			size = st.st_size;
+	} else {
+		OSERROR(fstat(fd, &st), filename);
+	}
+
+	if (!use_sendfile) {
+		bool more = false;
+
+		while (size) {
+			r = read(fd, buffer, sizeof(buffer));
+			OSERROR(r, filename);
+			if (r == 0)
+				break;
+			size -= r;
+
+			o = 0;
+			do {
+				more = size > 0;
+				w = send(sock, buffer + o, r - o,
+					 more ? MSG_MORE : 0);
+				OSERROR(w, "sock/send");
+				o += w;
+			} while (o < r);
+		}
+
+		if (more)
+			send(sock, NULL, 0, 0);
+	} else if (S_ISFIFO(st.st_mode)) {
+		r = splice(fd, NULL, sock, NULL, size, 0);
+		OSERROR(r, "sock/splice");
+		if (r != size) {
+			fprintf(stderr, "Short splice\n");
+			exit(1);
+		}
+	} else {
+		r = sendfile(sock, fd, NULL, size);
+		OSERROR(r, "sock/sendfile");
+		if (r != size) {
+			fprintf(stderr, "Short sendfile\n");
+			exit(1);
+		}
+	}
+
+	OSERROR(close(sock), "sock/close");
+	OSERROR(close(fd), "close");
+	return 0;
+}
diff --git a/samples/net/tls-sink.c b/samples/net/tls-sink.c
new file mode 100644
index 000000000000..1d6d4ed07101
--- /dev/null
+++ b/samples/net/tls-sink.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * TLS-over-TCP sink server
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <getopt.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+#include <linux/tls.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+
+static unsigned char buffer[512 * 1024] __attribute__((aligned(4096)));
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "tls-sink [-4][-p<port>]\n");
+	exit(2);
+}
+
+static void set_tls(int sock)
+{
+	struct tls12_crypto_info_aes_gcm_128 crypto_info;
+
+	crypto_info.info.version = TLS_1_2_VERSION;
+	crypto_info.info.cipher_type = TLS_CIPHER_AES_GCM_128;
+	memset(crypto_info.iv,		0, TLS_CIPHER_AES_GCM_128_IV_SIZE);
+	memset(crypto_info.rec_seq,	0, TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
+	memset(crypto_info.key,		0, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	memset(crypto_info.salt,	0, TLS_CIPHER_AES_GCM_128_SALT_SIZE);
+
+	OSERROR(setsockopt(sock, SOL_TCP, TCP_ULP, "tls", sizeof("tls")),
+		"TCP_ULP");
+	OSERROR(setsockopt(sock, SOL_TLS, TLS_TX, &crypto_info, sizeof(crypto_info)),
+		"TLS_TX");
+	OSERROR(setsockopt(sock, SOL_TLS, TLS_RX, &crypto_info, sizeof(crypto_info)),
+		"TLS_RX");
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned int port = 5556;
+	bool ipv6 = true;
+	int opt, server_sock, sock;
+
+
+	while ((opt = getopt(argc, argv, "4p:")) != EOF) {
+		switch (opt) {
+		case '4':
+			ipv6 = false;
+			break;
+		case 'p':
+			port = atoi(optarg);
+			break;
+		default:
+			format();
+		}
+	}
+
+	if (!ipv6) {
+		struct sockaddr_in sin = {
+			.sin_family = AF_INET,
+			.sin_port   = htons(port),
+		};
+		server_sock = socket(AF_INET, SOCK_STREAM, 0);
+		OSERROR(server_sock, "socket");
+		OSERROR(bind(server_sock, (struct sockaddr *)&sin, sizeof(sin)), "bind");
+		OSERROR(listen(server_sock, 1), "listen");
+	} else {
+		struct sockaddr_in6 sin6 = {
+			.sin6_family = AF_INET6,
+			.sin6_port   = htons(port),
+		};
+		server_sock = socket(AF_INET6, SOCK_STREAM, 0);
+		OSERROR(server_sock, "socket");
+		OSERROR(bind(server_sock, (struct sockaddr *)&sin6, sizeof(sin6)), "bind");
+		OSERROR(listen(server_sock, 1), "listen");
+	}
+
+	for (;;) {
+		sock = accept(server_sock, NULL, NULL);
+		if (sock != -1) {
+			set_tls(sock);
+			while (read(sock, buffer, sizeof(buffer)) > 0) {}
+			close(sock);
+		}
+	}
+}
diff --git a/samples/net/udp-send.c b/samples/net/udp-send.c
new file mode 100644
index 000000000000..31abd6b2d9fd
--- /dev/null
+++ b/samples/net/udp-send.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * UDP send client.  Pass -s to splice.
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <getopt.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <netdb.h>
+#include <netinet/in.h>
+#include <sys/stat.h>
+#include <sys/sendfile.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+#define min(x, y) ((x) < (y) ? (x) : (y))
+
+static unsigned char buffer[65536] __attribute__((aligned(4096)));
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "udp-send [-46s][-p<port>][-z<size>] <file>|- <server>\n");
+	exit(2);
+}
+
+int main(int argc, char *argv[])
+{
+	struct addrinfo *addrs = NULL, hints = {};
+	struct stat st;
+	const char *filename, *sockname, *service = "5555";
+	unsigned int len;
+	ssize_t r, o, size = 65535;
+	char *end;
+	bool use_sendfile = false;
+	int opt, sock, fd = 0, gai;
+
+	hints.ai_family   = AF_UNSPEC;
+	hints.ai_socktype = SOCK_DGRAM;
+
+	while ((opt = getopt(argc, argv, "46p:sz:")) != EOF) {
+		switch (opt) {
+		case '4':
+			hints.ai_family = AF_INET;
+			break;
+		case '6':
+			hints.ai_family = AF_INET6;
+			break;
+		case 'p':
+			service = optarg;
+			break;
+		case 's':
+			use_sendfile = true;
+			break;
+		case 'z':
+			size = strtoul(optarg, &end, 0);
+			switch (*end) {
+			case 'K':
+			case 'k':
+				size *= 1024;
+				break;
+			}
+			if (size > 65535) {
+				fprintf(stderr, "Too much data for UDP packet\n");
+				exit(2);
+			}
+			break;
+		default:
+			format();
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+	if (argc != 2)
+		format();
+	filename = argv[0];
+	sockname = argv[1];
+
+	gai = getaddrinfo(sockname, service, &hints, &addrs);
+	if (gai) {
+		fprintf(stderr, "%s: %s\n", sockname, gai_strerror(gai));
+		exit(3);
+	}
+
+	if (!addrs) {
+		fprintf(stderr, "%s: No addresses\n", sockname);
+		exit(3);
+	}
+
+	sockname = addrs->ai_canonname;
+	sock = socket(addrs->ai_family, addrs->ai_socktype, addrs->ai_protocol);
+	OSERROR(sock, "socket");
+	OSERROR(connect(sock, addrs->ai_addr, addrs->ai_addrlen), "connect");
+
+	if (strcmp(filename, "-") != 0) {
+		fd = open(filename, O_RDONLY);
+		OSERROR(fd, filename);
+		OSERROR(fstat(fd, &st), filename);
+		if (size > st.st_size)
+			size = st.st_size;
+	} else {
+		OSERROR(fstat(fd, &st), filename);
+	}
+
+	len = htonl(size);
+	OSERROR(send(sock, &len, 4, MSG_MORE), "sock/send");
+
+	if (!use_sendfile) {
+		while (size) {
+			r = read(fd, buffer, sizeof(buffer));
+			OSERROR(r, filename);
+			if (r == 0)
+				break;
+			size -= r;
+
+			o = 0;
+			do {
+				ssize_t w = send(sock, buffer + o, r - o,
+						 size > 0 ? MSG_MORE : 0);
+				OSERROR(w, "sock/send");
+				o += w;
+			} while (o < r);
+		}
+	} else if (S_ISFIFO(st.st_mode)) {
+		r = splice(fd, NULL, sock, NULL, size, 0);
+		OSERROR(r, "sock/splice");
+		if (r != size) {
+			fprintf(stderr, "Short splice\n");
+			exit(1);
+		}
+	} else {
+		r = sendfile(sock, fd, NULL, size);
+		OSERROR(r, "sock/sendfile");
+		if (r != size) {
+			fprintf(stderr, "Short sendfile\n");
+			exit(1);
+		}
+	}
+
+	OSERROR(close(sock), "sock/close");
+	OSERROR(close(fd), "close");
+	return 0;
+}
diff --git a/samples/net/udp-sink.c b/samples/net/udp-sink.c
new file mode 100644
index 000000000000..b98f45b64296
--- /dev/null
+++ b/samples/net/udp-sink.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * UDP sink server
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <getopt.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <netinet/in.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+
+static unsigned char buffer[512 * 1024] __attribute__((aligned(4096)));
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "udp-sink [-4][-p<port>]\n");
+	exit(2);
+}
+
+int main(int argc, char *argv[])
+{
+	struct iovec iov[1] = {
+		[0] = {
+			.iov_base	= buffer,
+			.iov_len	= sizeof(buffer),
+		},
+	};
+	struct msghdr msg = {
+		.msg_iov	= iov,
+		.msg_iovlen	= 1,
+	};
+	unsigned int port = 5555;
+	bool ipv6 = true;
+	int opt, sock;
+
+	while ((opt = getopt(argc, argv, "4p:")) != EOF) {
+		switch (opt) {
+		case '4':
+			ipv6 = false;
+			break;
+		case 'p':
+			port = atoi(optarg);
+			break;
+		default:
+			format();
+		}
+	}
+
+	if (!ipv6) {
+		struct sockaddr_in sin = {
+			.sin_family = AF_INET,
+			.sin_port   = htons(port),
+		};
+		sock = socket(AF_INET, SOCK_DGRAM, 0);
+		OSERROR(sock, "socket");
+		OSERROR(bind(sock, (struct sockaddr *)&sin, sizeof(sin)), "bind");
+	} else {
+		struct sockaddr_in6 sin6 = {
+			.sin6_family = AF_INET6,
+			.sin6_port   = htons(port),
+		};
+		sock = socket(AF_INET6, SOCK_DGRAM, 0);
+		OSERROR(sock, "socket");
+		OSERROR(bind(sock, (struct sockaddr *)&sin6, sizeof(sin6)), "bind");
+	}
+
+	for (;;) {
+		ssize_t r;
+
+		r = recvmsg(sock, &msg, 0);
+		printf("rx %zd\n", r);
+	}
+}
diff --git a/samples/net/unix-send.c b/samples/net/unix-send.c
new file mode 100644
index 000000000000..88fae776985c
--- /dev/null
+++ b/samples/net/unix-send.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * AF_UNIX stream send client.  Pass -s to splice.
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <getopt.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/un.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/sendfile.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+#define min(x, y) ((x) < (y) ? (x) : (y))
+
+static unsigned char buffer[4096] __attribute__((aligned(4096)));
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "unix-send [-s] [-z<size>] <file>|- <socket-file>\n");
+	exit(2);
+}
+
+int main(int argc, char *argv[])
+{
+	struct sockaddr_un sun = { .sun_family = AF_UNIX, };
+	struct stat st;
+	const char *filename, *sockname;
+	ssize_t r, w, o, size = LONG_MAX;
+	size_t plen, total = 0;
+	char *end;
+	bool use_sendfile = false, all = true;
+	int opt, sock, fd = 0;
+
+	while ((opt = getopt(argc, argv, "sz:")) != EOF) {
+		switch (opt) {
+		case 's':
+			use_sendfile = true;
+			break;
+		case 'z':
+			size = strtoul(optarg, &end, 0);
+			switch (*end) {
+			case 'K':
+			case 'k':
+				size *= 1024;
+				break;
+			case 'M':
+			case 'm':
+				size *= 1024 * 1024;
+				break;
+			}
+			all = false;
+			break;
+		default:
+			format();
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+	if (argc != 2)
+		format();
+	filename = argv[0];
+	sockname = argv[1];
+
+	plen = strlen(sockname);
+	if (plen == 0 || plen > sizeof(sun.sun_path) - 1) {
+		fprintf(stderr, "socket filename too short or too long\n");
+		exit(2);
+	}
+	memcpy(sun.sun_path, sockname, plen + 1);
+
+	sock = socket(AF_UNIX, SOCK_STREAM, 0);
+	OSERROR(sock, "socket");
+	OSERROR(connect(sock, (struct sockaddr *)&sun, sizeof(sun)), "connect");
+
+	if (strcmp(filename, "-") != 0) {
+		fd = open(filename, O_RDONLY);
+		OSERROR(fd, filename);
+		OSERROR(fstat(fd, &st), filename);
+		if (size > st.st_size)
+			size = st.st_size;
+	} else {
+		OSERROR(fstat(fd, &st), argv[2]);
+	}
+
+	if (!use_sendfile) {
+		bool more = false;
+
+		while (size) {
+			r = read(fd, buffer, min(sizeof(buffer), size));
+			OSERROR(r, filename);
+			if (r == 0)
+				break;
+			size -= r;
+
+			o = 0;
+			do {
+				more = size > 0;
+				w = send(sock, buffer + o, r - o,
+					 more ? MSG_MORE : 0);
+				OSERROR(w, "sock/send");
+				o += w;
+				total += w;
+			} while (o < r);
+		}
+
+		if (more)
+			send(sock, NULL, 0, 0);
+	} else if (S_ISFIFO(st.st_mode)) {
+		do {
+			r = splice(fd, NULL, sock, NULL, size,
+				   size > 0 ? SPLICE_F_MORE : 0);
+			OSERROR(r, "sock/splice");
+			size -= r;
+			total += r;
+		} while (r > 0 && size > 0);
+		if (size && !all) {
+			fprintf(stderr, "Short splice\n");
+			exit(1);
+		}
+	} else {
+		r = sendfile(sock, fd, NULL, size);
+		OSERROR(r, "sock/sendfile");
+		if (r != size) {
+			fprintf(stderr, "Short sendfile\n");
+			exit(1);
+		}
+		total += r;
+	}
+
+	printf("Sent %zu bytes\n", total);
+	OSERROR(close(sock), "sock/close");
+	OSERROR(close(fd), "close");
+	return 0;
+}
diff --git a/samples/net/unix-sink.c b/samples/net/unix-sink.c
new file mode 100644
index 000000000000..3c75979dc52a
--- /dev/null
+++ b/samples/net/unix-sink.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * UNIX stream sink server
+ *
+ * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/un.h>
+#include <sys/socket.h>
+
+#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)
+
+static unsigned char buffer[512 * 1024] __attribute__((aligned(4096)));
+
+int main(int argc, char *argv[])
+{
+	struct sockaddr_un sun = { .sun_family = AF_UNIX, };
+	size_t plen;
+	int server_sock, sock;
+
+	if (argc != 2) {
+		fprintf(stderr, "unix-sink <socket-file>\n");
+		exit(2);
+	}
+
+	plen = strlen(argv[1]);
+	if (plen == 0 || plen > sizeof(sun.sun_path) - 1) {
+		fprintf(stderr, "socket filename too short or too long\n");
+		exit(2);
+	}
+	memcpy(sun.sun_path, argv[1], plen + 1);
+
+	server_sock = socket(AF_UNIX, SOCK_STREAM, 0);
+	OSERROR(server_sock, "socket");
+	OSERROR(bind(server_sock, (struct sockaddr *)&sun, sizeof(sun)), "bind");
+	OSERROR(listen(server_sock, 1), "listen");
+
+	for (;;) {
+		sock = accept(server_sock, NULL, NULL);
+		if (sock != -1) {
+			while (read(sock, buffer, sizeof(buffer)) > 0) {}
+			close(sock);
+		}
+	}
+}

