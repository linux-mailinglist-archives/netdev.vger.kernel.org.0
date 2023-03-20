Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557106C19FF
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbjCTPlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjCTPl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:41:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDA27EC2
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 08:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679326300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4kPJZ32Y+l53box6ko+ne5cwDvp4Win8rdXeR0QS2JU=;
        b=KiC1eayWKg2YeTykL514uXfV9GAqK1ADsxZOxC01/TPBCUd6REEa44h+tmlAaZUPVdXrQk
        H1GC8d4EUQCCXONe2QVbvYXQL55RiX4D8jxDmVWM1ZlPAmPt3c80W1xor+SQqjOQb0ZYuX
        Vg1ua08+/Liim25rQ2dJab22UEoHUek=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-O63fXQA0PM-SK5I0OEKMUg-1; Mon, 20 Mar 2023 11:31:39 -0400
X-MC-Unique: O63fXQA0PM-SK5I0OEKMUg-1
Received: by mail-wm1-f72.google.com with SMTP id iv10-20020a05600c548a00b003ee112e6df1so783574wmb.2
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 08:31:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679326298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kPJZ32Y+l53box6ko+ne5cwDvp4Win8rdXeR0QS2JU=;
        b=krzM9LKXmtYkQ6UVOxnJNRvnAc3Gs0tiRPzPH7Dqhu2EEeTO3JTvIXWX0MFs5ij+ns
         JV1Gx8gv1SC+Wl1/DSW54Kgz4UoywdHxLJcQ+LoUF4Zj3ABzleUm9Nvetmxzhx0yjjc6
         BfEDlbFZqmhc2SCpFBXntzC6qEaE3Dw66uQVLIwp1c+A5M7XfGU+KlVg+uQqT/3c0NzC
         g/P/Pq9WuY5PUiIp0KpmHQei0BQ40ltbJcCMLUI88+64EBPjJv5jkw+HE6/rGkGd/TqO
         kNb2dKF3VQIFV6cSWnOsH3ANEiGbpuOSXGHj0o/Rsa//bygl24f+eeRwYdn8UwDdQ18w
         P7Dg==
X-Gm-Message-State: AO0yUKUCQgz6LyfZyfP7Cr+x4wybCuv2Ca4S1fzeq1QXR7FPWr5WewjT
        qbD8NnPVFux5AhzuoqkgRbdGaguWiqfTnGvAp5ZbDmaNEkYZs1I2PnxdIoxt4hEFBrA84r2pBbh
        O7A1Xjj74xWZiK+o9
X-Received: by 2002:a05:600c:3aca:b0:3ed:6049:a5ae with SMTP id d10-20020a05600c3aca00b003ed6049a5aemr9662590wms.4.1679326298128;
        Mon, 20 Mar 2023 08:31:38 -0700 (PDT)
X-Google-Smtp-Source: AK7set+K/iSPqBhOxqnDWry6nMA6XFyLEMJvZ5BagJzhVQg80QiS5si7gT89jIVKwdv6jvS+LcnPCg==
X-Received: by 2002:a05:600c:3aca:b0:3ed:6049:a5ae with SMTP id d10-20020a05600c3aca00b003ed6049a5aemr9662575wms.4.1679326297864;
        Mon, 20 Mar 2023 08:31:37 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id h11-20020a05600c314b00b003e7c89b3514sm7332828wmo.23.2023.03.20.08.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 08:31:37 -0700 (PDT)
Date:   Mon, 20 Mar 2023 16:31:32 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 3/3] test/vsock: skbuff merging test
Message-ID: <20230320153132.o3xvwxmn3722lin4@sgarzare-redhat>
References: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
 <14ca87d1-3e07-85e9-d11c-39789a9d17d4@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <14ca87d1-3e07-85e9-d11c-39789a9d17d4@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 09:53:54PM +0300, Arseniy Krasnov wrote:
>This adds test which checks case when data of newly received skbuff is
>appended to the last skbuff in the socket's queue.
>
>This test is actual only for virtio transport.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 81 ++++++++++++++++++++++++++++++++
> 1 file changed, 81 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 3de10dbb50f5..00216c52d8b6 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -968,6 +968,82 @@ static void test_seqpacket_inv_buf_server(const struct test_opts *opts)
> 	test_inv_buf_server(opts, false);
> }
>
>+static void test_stream_virtio_skb_merge_client(const struct test_opts *opts)
>+{
>+	ssize_t res;
>+	int fd;
>+
>+	fd = vsock_stream_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+

Please use a macro for "HELLO" or a variabile, e.g.

         char *buf;
         ...

         buf = "HELLO";
         res = send(fd, buf, strlen(buf), 0);
         ...

>+	res = send(fd, "HELLO", strlen("HELLO"), 0);
>+	if (res != strlen("HELLO")) {
>+		fprintf(stderr, "unexpected send(2) result %zi\n", res);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("SEND0");
>+	/* Peer reads part of first packet. */
>+	control_expectln("REPLY0");
>+
>+	/* Send second skbuff, it will be merged. */
>+	res = send(fd, "WORLD", strlen("WORLD"), 0);

Ditto.

>+	if (res != strlen("WORLD")) {
>+		fprintf(stderr, "unexpected send(2) result %zi\n", res);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("SEND1");
>+	/* Peer reads merged skbuff packet. */
>+	control_expectln("REPLY1");
>+
>+	close(fd);
>+}
>+
>+static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
>+{
>+	unsigned char buf[64];
>+	ssize_t res;
>+	int fd;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("SEND0");
>+
>+	/* Read skbuff partially. */
>+	res = recv(fd, buf, 2, 0);
>+	if (res != 2) {
>+		fprintf(stderr, "expected recv(2) failure, got %zi\n", res);

We don't expect a failure, so please update the error message and make
it easy to figure out which recv() is failing. For example by saying
how many bytes you expected and how many you received.

>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("REPLY0");
>+	control_expectln("SEND1");
>+
>+
>+	res = recv(fd, buf, sizeof(buf), 0);

Perhaps a comment here to explain why we expect only 8 bytes.

>+	if (res != 8) {
>+		fprintf(stderr, "expected recv(2) failure, got %zi\n", res);

Ditto.

>+		exit(EXIT_FAILURE);
>+	}
>+
>+	res = recv(fd, buf, sizeof(buf), MSG_DONTWAIT);
>+	if (res != -1) {
>+		fprintf(stderr, "expected recv(2) success, got %zi\n", res);

It's the other way around, isn't it?
Here you expect it to fail instead it is not failing.

>+		exit(EXIT_FAILURE);
>+	}

Moving the pointer correctly, I would also check that there is
HELLOWORLD in the buffer.

Thanks for adding tests in this suite!
Stefano

>+
>+	control_writeln("REPLY1");
>+
>+	close(fd);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -1038,6 +1114,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_seqpacket_inv_buf_client,
> 		.run_server = test_seqpacket_inv_buf_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM virtio skb merge",
>+		.run_client = test_stream_virtio_skb_merge_client,
>+		.run_server = test_stream_virtio_skb_merge_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1
>

