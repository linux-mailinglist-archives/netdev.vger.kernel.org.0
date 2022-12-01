Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F382E63ECB3
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiLAJnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiLAJmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:42:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0420E56EC8
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669887704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d/lP/MUpumH1puWMFQWuZ/iuRBdPRSaGxJGkZdBzweg=;
        b=GLEfBzRvRE6gr32rxNEqKFxnbPS0eXOQvVW5kNkJNJCmH4AZlZmGU4ho00x9nxdfE5xdh+
        EnQBo0H0QPuRIvmZwND87MFkOcIvucikECKN4Hko8vfdo0Qy0Bc8encdLWpeuoCVJQeTYv
        f+IfUfDlXrf3vvQjyGVyo25gKx/CvrU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-652-0YuNW-O0ObeMTMLyqC5o9Q-1; Thu, 01 Dec 2022 04:41:43 -0500
X-MC-Unique: 0YuNW-O0ObeMTMLyqC5o9Q-1
Received: by mail-wr1-f71.google.com with SMTP id j29-20020adfb31d000000b0024237066261so239389wrd.14
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 01:41:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d/lP/MUpumH1puWMFQWuZ/iuRBdPRSaGxJGkZdBzweg=;
        b=BIrafA8U5/tH9SftlIUCD1fgNtDoHv2jPBSCfsBneFtpEFxxo1LLoGhLml/GpvEEz8
         lqKSnI0L9Qk/HB1+K0LVhCfSsXQjR+byaoRv3l3H1Q3si9US8eMwd+jybrqc4q4szXwA
         sh6Rum6wfIUnQsra01fjvHQTft2REmjNtosAF6y/mYuA2eJoKbqVhpkBoYq8M9k1CQrn
         wjeb7rd0MUjNPZ40jWE9CWDFLBr0RtT9n+r/WeRy9qJdy0lWlSb4ww+LkVUIs3+Wu8Ok
         IVVKu1VX0a81loEYgu0YntRPLhA3OpClhfsOjSqiF0csVAYaF/g29qq84ZNFpcwDzKyN
         AEvA==
X-Gm-Message-State: ANoB5pl35MK4R/GnAvXjAwy2GLkOlI7z9RTC86wu3qDIsHqSuJtMt2+x
        tQdIK+1yY9rqeh+4AKAZv+D2aDbtYbAOuOYqsojN2E69P8VEkRf9vvj+4/BC0qWLj0X+QJg3bj+
        4ral8PZK8YmyAObjo
X-Received: by 2002:a1c:f617:0:b0:3cf:e0ef:1f69 with SMTP id w23-20020a1cf617000000b003cfe0ef1f69mr34437828wmc.163.1669887701734;
        Thu, 01 Dec 2022 01:41:41 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6kI3TJlPqj596F8g6taBAnv03vejDjuPchx/hnOpqbtf/e5VhTFtctzxfc29O9sqpjJLLbvw==
X-Received: by 2002:a1c:f617:0:b0:3cf:e0ef:1f69 with SMTP id w23-20020a1cf617000000b003cfe0ef1f69mr34437799wmc.163.1669887701525;
        Thu, 01 Dec 2022 01:41:41 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id l12-20020a5d668c000000b00235da296623sm4266712wru.31.2022.12.01.01.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 01:41:40 -0800 (PST)
Date:   Thu, 1 Dec 2022 10:41:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 4/6] test/vsock: rework message bounds test
Message-ID: <20221201094122.7gcyjfsf7kng4f7q@sgarzare-redhat>
References: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
 <eb898b5f-72d7-47d3-82e7-75e3c7879744@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <eb898b5f-72d7-47d3-82e7-75e3c7879744@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 05:10:35PM +0000, Arseniy Krasnov wrote:
>This updates message bound test making it more complex. Instead of
>sending 1 bytes messages with one MSG_EOR bit, it sends messages of
>random length(one half of messages are smaller than page size, second
>half are bigger) with random number of MSG_EOR bits set. Receiver
>also don't know total number of messages.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/control.c    |  28 +++++++
> tools/testing/vsock/control.h    |   2 +
> tools/testing/vsock/util.c       |  13 ++++
> tools/testing/vsock/util.h       |   1 +
> tools/testing/vsock/vsock_test.c | 124 +++++++++++++++++++++++++++----
> 5 files changed, 155 insertions(+), 13 deletions(-)
>
>diff --git a/tools/testing/vsock/control.c b/tools/testing/vsock/control.c
>index 4874872fc5a3..d2deb4b15b94 100644
>--- a/tools/testing/vsock/control.c
>+++ b/tools/testing/vsock/control.c
>@@ -141,6 +141,34 @@ void control_writeln(const char *str)
> 	timeout_end();
> }
>
>+void control_writeulong(unsigned long value)
>+{
>+	char str[32];
>+
>+	if (snprintf(str, sizeof(str), "%lu", value) >= sizeof(str)) {
>+		perror("snprintf");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln(str);
>+}
>+
>+unsigned long control_readulong(void)
>+{
>+	unsigned long value;
>+	char *str;
>+
>+	str = control_readln();
>+
>+	if (!str)
>+		exit(EXIT_FAILURE);
>+
>+	value = strtoul(str, NULL, 10);
>+	free(str);
>+
>+	return value;
>+}
>+
> /* Return the next line from the control socket (without the trailing newline).
>  *
>  * The program terminates if a timeout occurs.
>diff --git a/tools/testing/vsock/control.h b/tools/testing/vsock/control.h
>index 51814b4f9ac1..c1f77fdb2c7a 100644
>--- a/tools/testing/vsock/control.h
>+++ b/tools/testing/vsock/control.h
>@@ -9,7 +9,9 @@ void control_init(const char *control_host, const char *control_port,
> void control_cleanup(void);
> void control_writeln(const char *str);
> char *control_readln(void);
>+unsigned long control_readulong(void);
> void control_expectln(const char *str);
> bool control_cmpln(char *line, const char *str, bool fail);
>+void control_writeulong(unsigned long value);
>
> #endif /* CONTROL_H */
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 2acbb7703c6a..01b636d3039a 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -395,3 +395,16 @@ void skip_test(struct test_case *test_cases, size_t test_cases_len,
>
> 	test_cases[test_id].skip = true;
> }
>+
>+unsigned long hash_djb2(const void *data, size_t len)
>+{
>+	unsigned long hash = 5381;
>+	int i = 0;
>+
>+	while (i < len) {
>+		hash = ((hash << 5) + hash) + ((unsigned char *)data)[i];
>+		i++;
>+	}
>+
>+	return hash;
>+}
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index a3375ad2fb7f..fb99208a95ea 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -49,4 +49,5 @@ void run_tests(const struct test_case *test_cases,
> void list_tests(const struct test_case *test_cases);
> void skip_test(struct test_case *test_cases, size_t test_cases_len,
> 	       const char *test_id_str);
>+unsigned long hash_djb2(const void *data, size_t len);
> #endif /* UTIL_H */
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index bb6d691cb30d..12ef0cca6f93 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -284,10 +284,14 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>-#define MESSAGES_CNT 7
>-#define MSG_EOR_IDX (MESSAGES_CNT / 2)
>+#define SOCK_BUF_SIZE (2 * 1024 * 1024)
>+#define MAX_MSG_SIZE (32 * 1024)
>+
> static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
> {
>+	unsigned long curr_hash;
>+	int page_size;
>+	int msg_count;
> 	int fd;
>
> 	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>@@ -296,18 +300,78 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
> 		exit(EXIT_FAILURE);
> 	}
>
>-	/* Send several messages, one with MSG_EOR flag */
>-	for (int i = 0; i < MESSAGES_CNT; i++)
>-		send_byte(fd, 1, (i == MSG_EOR_IDX) ? MSG_EOR : 0);
>+	/* Wait, until receiver sets buffer size. */
>+	control_expectln("SRVREADY");
>+
>+	curr_hash = 0;
>+	page_size = getpagesize();
>+	msg_count = SOCK_BUF_SIZE / MAX_MSG_SIZE;
>+
>+	for (int i = 0; i < msg_count; i++) {
>+		ssize_t send_size;
>+		size_t buf_size;
>+		int flags;
>+		void *buf;
>+
>+		/* Use "small" buffers and "big" buffers. */
>+		if (i & 1)
>+			buf_size = page_size +
>+					(rand() % (MAX_MSG_SIZE - page_size));
>+		else
>+			buf_size = 1 + (rand() % page_size);
>+
>+		buf = malloc(buf_size);
>+
>+		if (!buf) {
>+			perror("malloc");
>+			exit(EXIT_FAILURE);
>+		}
>+
>+		/* Set at least one MSG_EOR + some random. */
>+		if (i == (msg_count / 2) || (rand() & 1)) {
>+			flags = MSG_EOR;
>+			curr_hash++;
>+		} else {
>+			flags = 0;
>+		}
>+
>+		send_size = send(fd, buf, buf_size, flags);
>+
>+		if (send_size < 0) {
>+			perror("send");
>+			exit(EXIT_FAILURE);
>+		}
>+
>+		if (send_size != buf_size) {
>+			fprintf(stderr, "Invalid send size\n");
>+			exit(EXIT_FAILURE);
>+		}
>+
>+		/*
>+		 * Hash sum is computed at both client and server in
>+		 * the same way: H = hash(H + 'message length'). Idea
>+		 * is simple: such hash "accumulates" length and order
>+		 * of every sent/received message. After data exchange,
>+		 * both sums are compared using control socket, and if
>+		 * message bounds wasn't broken - two values must be
>+		 * equal.
>+		 */
>+		curr_hash += send_size;

Sorry, I thought about it now, but instead of hashing the size, couldn't 
we just fill the buffer with a pattern (maybe random?) and hash the 
content?

That way we see both that the bounds were met and that the content was 
transferred correctly.

What do you think?

The rest LGTM!

Stefano

>+		curr_hash = hash_djb2(&curr_hash, sizeof(curr_hash));
>+	}
>
> 	control_writeln("SENDDONE");
>+	control_writeulong(curr_hash);
> 	close(fd);
> }
>
> static void test_seqpacket_msg_bounds_server(const struct test_opts *opts)
> {
>+	unsigned long sock_buf_size;
>+	unsigned long remote_hash;
>+	unsigned long curr_hash;
> 	int fd;
>-	char buf[16];
>+	char buf[MAX_MSG_SIZE];
> 	struct msghdr msg = {0};
> 	struct iovec iov = {0};
>
>@@ -317,25 +381,58 @@ static void test_seqpacket_msg_bounds_server(const struct test_opts *opts)
> 		exit(EXIT_FAILURE);
> 	}
>
>+	sock_buf_size = SOCK_BUF_SIZE;
>+
>+	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
>+		       &sock_buf_size, sizeof(sock_buf_size))) {
>+		perror("getsockopt");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>+		       &sock_buf_size, sizeof(sock_buf_size))) {
>+		perror("getsockopt");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Ready to receive data. */
>+	control_writeln("SRVREADY");
>+	/* Wait, until peer sends whole data. */
> 	control_expectln("SENDDONE");
> 	iov.iov_base = buf;
> 	iov.iov_len = sizeof(buf);
> 	msg.msg_iov = &iov;
> 	msg.msg_iovlen = 1;
>
>-	for (int i = 0; i < MESSAGES_CNT; i++) {
>-		if (recvmsg(fd, &msg, 0) != 1) {
>-			perror("message bound violated");
>-			exit(EXIT_FAILURE);
>-		}
>+	curr_hash = 0;
>
>-		if ((i == MSG_EOR_IDX) ^ !!(msg.msg_flags & MSG_EOR)) {
>-			perror("MSG_EOR");
>+	while (1) {
>+		ssize_t recv_size;
>+
>+		recv_size = recvmsg(fd, &msg, 0);
>+
>+		if (!recv_size)
>+			break;
>+
>+		if (recv_size < 0) {
>+			perror("recvmsg");
> 			exit(EXIT_FAILURE);
> 		}
>+
>+		if (msg.msg_flags & MSG_EOR)
>+			curr_hash++;
>+
>+		curr_hash += recv_size;
>+		curr_hash = hash_djb2(&curr_hash, sizeof(curr_hash));
> 	}
>
> 	close(fd);
>+	remote_hash = control_readulong();
>+
>+	if (curr_hash != remote_hash) {
>+		fprintf(stderr, "Message bounds broken\n");
>+		exit(EXIT_FAILURE);
>+	}
> }
>
> #define MESSAGE_TRUNC_SZ 32
>@@ -837,6 +934,7 @@ int main(int argc, char **argv)
> 		.peer_cid = VMADDR_CID_ANY,
> 	};
>
>+	srand(time(NULL));
> 	init_signals();
>
> 	for (;;) {
>-- 
>2.25.1

