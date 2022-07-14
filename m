Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE4D574889
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbiGNJWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237895AbiGNJV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:21:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3AC8AE78
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 02:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657790304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AJRbQGWX8SYyAfc3m01uLHkDl0rW2ZcQ5fGpMApxPFI=;
        b=Cqck6KGTuFiNtnJO/RuJJyVxr9Cxf1ps65jE6Km4aQS9ExqMkPJRIQtJvC8fx70nuHNwnV
        n1bYqkBUvS9vtc8DH2zGz3/wS00aNizZCgKPO9m1jAkEVCkxfks2SUhEjqxuAolOcPHMg2
        HwJ4yRzQiXjltujnX4AyOhLYEj0UvLY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-ANZPKx9FPTiyLXRccYextQ-1; Thu, 14 Jul 2022 05:18:22 -0400
X-MC-Unique: ANZPKx9FPTiyLXRccYextQ-1
Received: by mail-wm1-f72.google.com with SMTP id 130-20020a1c0288000000b003a2fe999093so1477156wmc.6
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 02:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AJRbQGWX8SYyAfc3m01uLHkDl0rW2ZcQ5fGpMApxPFI=;
        b=lmbJXBNPY+gbY2flhZxpsb8yDUjnu+YmJ18zWoQWY2+B0Azw+dY6oz5J607CDSN++W
         r+G0U3si9XleWkW99ZiIqGLU+WReQMGcD7HYBfp4Cbea1dQL2GORTjmPAx30gMlPf9kt
         VqJviFQcYRR1hVv+u7l88ed0OocLPXe0Llwl+ymKI/wOyzJSBuMdgMkxTyuZHmCIURcF
         t6P/5myX6d+3sW4P9zT26zVup8xjqXyPdAdYVcnjvn5TbdKK42oDzLq1tRaSRp7C08fj
         aTIdDyHweQEbvwjcBKzgSb2+8MI6Hk3a3UO7FJZF5jPqN4TzjqsnVH4M5O7ngnXkltge
         rvdA==
X-Gm-Message-State: AJIora+X2fwalu/uYEG8STA0juJmxgC6UJLkL0FRMzr++iBNn3NusLEv
        WyMrLRCYwkdjNG7Aj0uzHRgxTEbJWfTNtpbBwTWHrzugI+Wzwiku7nfJVvbjjwpFUMFY8XOU9/E
        AJEvoqTUpSKCjOCCM
X-Received: by 2002:adf:ea50:0:b0:21d:6547:1154 with SMTP id j16-20020adfea50000000b0021d65471154mr6960188wrn.186.1657790301359;
        Thu, 14 Jul 2022 02:18:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tuwtPZU9nQeBs7cQ2M4VYIz9H31BreqnK5vLz6M5wgDTgW10mYp1xRsT6qPazdbvllCNe/6g==
X-Received: by 2002:adf:ea50:0:b0:21d:6547:1154 with SMTP id j16-20020adfea50000000b0021d65471154mr6960167wrn.186.1657790301127;
        Thu, 14 Jul 2022 02:18:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id bp17-20020a5d5a91000000b0021d7d251c76sm914407wrb.46.2022.07.14.02.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 02:18:20 -0700 (PDT)
Message-ID: <5185dff4656a6e4830739c90feeaa3a15a472243.camel@redhat.com>
Subject: Re: [PATCH net-next v2 2/3] selftests/net: Add test for timing a
 bind request to a port with a populated bhash entry
From:   Paolo Abeni <pabeni@redhat.com>
To:     Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net
Date:   Thu, 14 Jul 2022 11:18:19 +0200
In-Reply-To: <20220712235310.1935121-3-joannelkoong@gmail.com>
References: <20220712235310.1935121-1-joannelkoong@gmail.com>
         <20220712235310.1935121-3-joannelkoong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-12 at 16:53 -0700, Joanne Koong wrote:
> This test populates the bhash table for a given port with
> MAX_THREADS * MAX_CONNECTIONS sockets, and then times how long
> a bind request on the port takes.
> 
> When populating the bhash table, we create the sockets and then bind
> the sockets to the same address and port (SO_REUSEADDR and SO_REUSEPORT
> are set). When timing how long a bind on the port takes, we bind on a
> different address without SO_REUSEPORT set. We do not set SO_REUSEPORT
> because we are interested in the case where the bind request does not
> go through the tb->fastreuseport path, which is fragile (eg
> tb->fastreuseport path does not work if binding with a different uid).
> 
> On my local machine, I see:
> ipv4:
> before - 0.002317 seconds
> with bhash2 - 0.000020 seconds
> 
> ipv6:
> before - 0.002431 seconds
> with bhash2 - 0.000021 seconds
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  tools/testing/selftests/net/.gitignore    |   3 +-
>  tools/testing/selftests/net/Makefile      |   3 +
>  tools/testing/selftests/net/bind_bhash.c  | 119 ++++++++++++++++++++++
>  tools/testing/selftests/net/bind_bhash.sh |  23 +++++
>  4 files changed, 147 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/net/bind_bhash.c
>  create mode 100755 tools/testing/selftests/net/bind_bhash.sh
> 
> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> index 1257baa79286..5b1adf6e29ae 100644
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@ -37,4 +37,5 @@ gro
>  ioam6_parser
>  toeplitz
>  cmsg_sender
> -unix_connect
> \ No newline at end of file
> +unix_connect
> +bind_bhash
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index ddad703ace34..e678fc3030a2 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -39,6 +39,7 @@ TEST_PROGS += vrf_strict_mode_test.sh
>  TEST_PROGS += arp_ndisc_evict_nocarrier.sh
>  TEST_PROGS += ndisc_unsolicited_na_test.sh
>  TEST_PROGS += stress_reuseport_listen.sh
> +TEST_PROGS += bind_bhash.sh
>  TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
>  TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
>  TEST_GEN_FILES =  socket nettest
> @@ -59,6 +60,7 @@ TEST_GEN_FILES += toeplitz
>  TEST_GEN_FILES += cmsg_sender
>  TEST_GEN_FILES += stress_reuseport_listen
>  TEST_PROGS += test_vxlan_vnifiltering.sh
> +TEST_GEN_FILES += bind_bhash
>  
>  TEST_FILES := settings
>  
> @@ -70,3 +72,4 @@ include bpf/Makefile
>  $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
>  $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread
>  $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
> +$(OUTPUT)/bind_bhash: LDLIBS += -lpthread
> diff --git a/tools/testing/selftests/net/bind_bhash.c b/tools/testing/selftests/net/bind_bhash.c
> new file mode 100644
> index 000000000000..252e73754e76
> --- /dev/null
> +++ b/tools/testing/selftests/net/bind_bhash.c
> @@ -0,0 +1,119 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * This times how long it takes to bind to a port when the port already
> + * has multiple sockets in its bhash table.
> + *
> + * In the setup(), we populate the port's bhash table with
> + * MAX_THREADS * MAX_CONNECTIONS number of entries.
> + */
> +
> +#include <unistd.h>
> +#include <stdio.h>
> +#include <netdb.h>
> +#include <pthread.h>
> +
> +#define MAX_THREADS 600
> +#define MAX_CONNECTIONS 40
> +
> +static const char *bind_addr = "::1";
> +static const char *port;
> +
> +static int fd_array[MAX_THREADS][MAX_CONNECTIONS];
> +
> +static int bind_socket(int opt, const char *addr)
> +{
> +	struct addrinfo *res, hint = {};
> +	int sock_fd, reuse = 1, err;
> +
> +	sock_fd = socket(AF_INET6, SOCK_STREAM, 0);
> +	if (sock_fd < 0) {
> +		perror("socket fd err");
> +		return -1;
> +	}
> +
> +	hint.ai_family = AF_INET6;
> +	hint.ai_socktype = SOCK_STREAM;
> +
> +	err = getaddrinfo(addr, port, &hint, &res);
> +	if (err) {
> +		perror("getaddrinfo failed");
> +		return -1;
> +	}
> +
> +	if (opt) {
> +		err = setsockopt(sock_fd, SOL_SOCKET, opt, &reuse, sizeof(reuse));
> +		if (err) {
> +			perror("setsockopt failed");
> +			return -1;
> +		}
> +	}
> +
> +	err = bind(sock_fd, res->ai_addr, res->ai_addrlen);
> +	if (err) {
> +		perror("failed to bind to port");
> +		return -1;
> +	}
> +
> +	return sock_fd;
> +}
> +
> +static void *setup(void *arg)
> +{
> +	int sock_fd, i;
> +	int *array = (int *)arg;
> +
> +	for (i = 0; i < MAX_CONNECTIONS; i++) {
> +		sock_fd = bind_socket(SO_REUSEADDR | SO_REUSEPORT, bind_addr);
> +		if (sock_fd < 0)
> +			return NULL;
> +		array[i] = sock_fd;
> +	}
> +
> +	return NULL;
> +}
> +
> +int main(int argc, const char *argv[])
> +{
> +	int listener_fd, sock_fd, i, j;
> +	pthread_t tid[MAX_THREADS];
> +	clock_t begin, end;
> +
> +	if (argc != 2) {
> +		printf("Usage: listener <port>\n");
> +		return -1;
> +	}
> +
> +	port = argv[1];
> +
> +	listener_fd = bind_socket(SO_REUSEADDR | SO_REUSEPORT, bind_addr);
> +	if (listen(listener_fd, 100) < 0) {
> +		perror("listen failed");
> +		return -1;
> +	}
> +
> +	/* Set up threads to populate the bhash table entry for the port */
> +	for (i = 0; i < MAX_THREADS; i++)
> +		pthread_create(&tid[i], NULL, setup, fd_array[i]);
> +
> +	for (i = 0; i < MAX_THREADS; i++)
> +		pthread_join(tid[i], NULL);
> +
> +	begin = clock();
> +
> +	/* Bind to the same port on a different address */
> +	sock_fd  = bind_socket(0, "2001:0db8:0:f101::1");

I think it's better/nicer if you make this address configurable from
the command line, instead of hard-codying it here.
> +
> +	end = clock();
> +
> +	printf("time spent = %f\n", (double)(end - begin) / CLOCKS_PER_SEC);
> +
> +	/* clean up */
> +	close(sock_fd);
> +	close(listener_fd);
> +	for (i = 0; i < MAX_THREADS; i++) {
> +		for (j = 0; i < MAX_THREADS; i++)
> +			close(fd_array[i][j]);
> +	}
> +
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/net/bind_bhash.sh b/tools/testing/selftests/net/bind_bhash.sh
> new file mode 100755
> index 000000000000..f7794d63efd2
> --- /dev/null
> +++ b/tools/testing/selftests/net/bind_bhash.sh
> @@ -0,0 +1,23 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +NR_FILES=32768
> +SAVED_NR_FILES=$(ulimit -n)
> +
> +setup() {
> +	ip addr add dev eth0 2001:0db8:0:f101::1

If you add the 'nodad' option here...

> +	ulimit -n $NR_FILES
> +	sleep 1

... this should not be needed

Also what about ipv4 tests?


Thanks!

Paolo

