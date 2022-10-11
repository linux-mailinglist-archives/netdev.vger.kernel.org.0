Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6167A5FB18D
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 13:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJKLfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 07:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJKLfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 07:35:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA4039BB6
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 04:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665488102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u1hbqqzbWNT/5E/BpvJ3/Vjrk7gdxHvHj9BLV42QDiA=;
        b=glq83Z8dhP1uWS8sC4OoBctI+edz3r9r1hZKMukahVlOog5dnhNMH1kg8gnBlWUgf3wCix
        czR+b+UDIZGDQRNAslSL+TWcCoLHzm7DnARYnNpBg1qh6T3OWUOlFK7AfbyC2xYw3gXQiy
        mEP5VeGBYwkFE8y2kwwuUOxTS66peJY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-161-y3lNrnnrMNmB9p2hbTYMvQ-1; Tue, 11 Oct 2022 07:35:01 -0400
X-MC-Unique: y3lNrnnrMNmB9p2hbTYMvQ-1
Received: by mail-wr1-f70.google.com with SMTP id e11-20020adfa74b000000b0022e39e5c151so3716375wrd.3
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 04:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u1hbqqzbWNT/5E/BpvJ3/Vjrk7gdxHvHj9BLV42QDiA=;
        b=g2jmL8+6InqITFRZnEFSvgRoc28ENkaFA+iDzOrR3PlI/p2ymawjdguf2PDw4RUVfx
         IqHwjQHlenS7WzV8RgyOqHO3ZWDbwTG2Baxm0mUePbHk/lYbL1fmoKqQm75SDgecSn4B
         I9iZWEzlS0RmUfRjVjRkWU0vtOD/tU8OWS6mCfTzXXwD7jyL9YgH1mi6JorQmI9JmJnF
         IaH93uQy3AqoS4y7jj9Gmg4ccW8Bi3f9XhXR8KcY27CSlcDXwnCYCBSV6U1HboCT2SWY
         YaNd/xjNIqMDL2Jb8HtDEFZgxX6evVGkm5b9wXgLBSTBXQnlHx22jwwgfYBONK3bp3e8
         ucVA==
X-Gm-Message-State: ACrzQf2RIvWB3nsPElvetgUMvErT6+H2vPRGyu14MmTdYemqZh+TsQue
        bwdeh5PGEKN9krhb5JXrByxMky2TdqQeO1u+H6Ad9UJxwZhz6H30zgK6Fmg02amgqIadAmUKbzt
        7XmgzBlRpgsnyOmNd
X-Received: by 2002:a05:600c:3d05:b0:3b4:9a42:10d0 with SMTP id bh5-20020a05600c3d0500b003b49a4210d0mr16370537wmb.135.1665488100048;
        Tue, 11 Oct 2022 04:35:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4GNttO+v8lYN9WcnBFtOhyzlLUXlKq0mIPF/dQKjXfNyBOISKFL4DjzUtptwimMmIXzNd+LQ==
X-Received: by 2002:a05:600c:3d05:b0:3b4:9a42:10d0 with SMTP id bh5-20020a05600c3d0500b003b49a4210d0mr16370520wmb.135.1665488099770;
        Tue, 11 Oct 2022 04:34:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id a8-20020a1cf008000000b003a6a3595edasm12193963wmb.27.2022.10.11.04.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 04:34:59 -0700 (PDT)
Message-ID: <dea1abff6baabfb8a5abc7cf4eb355eb36b0ef8c.camel@redhat.com>
Subject: Re: [PATCH v1 net 3/3] selftest: Add test for SO_INCOMING_CPU.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>
Cc:     Craig Gallek <kraig@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 11 Oct 2022 13:34:58 +0200
In-Reply-To: <20221010174351.11024-4-kuniyu@amazon.com>
References: <20221010174351.11024-1-kuniyu@amazon.com>
         <20221010174351.11024-4-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-10-10 at 10:43 -0700, Kuniyuki Iwashima wrote:
> Some highly optimised applications use SO_INCOMING_CPU to make them
> efficient, but they didn't test if it's working correctly by getsockopt()
> to avoid slowing down.  As a result, no one noticed it had been broken
> for years, so it's a good time to add a test to catch future regression.
> 
> The test does
> 
>   1) Create $(nproc) TCP listeners associated with each CPU.
> 
>   2) Create 32 child sockets for each listener by calling
>      sched_setaffinity() for each CPU.
> 
>   3) Check if accept()ed sockets' sk_incoming_cpu matches
>      listener's one.
> 
> If we see -EAGAIN, SO_INCOMING_CPU is broken.  However, we might not see
> any error even if broken; the kernel could miraculously distribute all SYN
> to correct listeners.  Not to let that happen, we must increase the number
> of clients and CPUs to some extent, so the test requires $(nproc) >= 2 and
> creates 64 sockets at least.
> 
> Test:
>   $ nproc
>   96
>   $ ./so_incoming_cpu
> 
> Before the previous patch:
> 
>   # Starting 1 tests from 2 test cases.
>   #  RUN           so_incoming_cpu.test1 ...
>   # so_incoming_cpu.c:129:test1:Expected cpu (82) == i (0)
>   # test1: Test terminated by assertion
>   #          FAIL  so_incoming_cpu.test1
>   not ok 1 so_incoming_cpu.test1
>   # FAILED: 0 / 1 tests passed.
>   # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> 
> After:
> 
>   # Starting 1 tests from 2 test cases.
>   #  RUN           so_incoming_cpu.test1 ...
>   # so_incoming_cpu.c:137:test1:SO_INCOMING_CPU is very likely to be working correctly with 3072 sockets.
>   #            OK  so_incoming_cpu.test1
>   ok 1 so_incoming_cpu.test1
>   # PASSED: 1 / 1 tests passed.
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  tools/testing/selftests/net/.gitignore        |   1 +
>  tools/testing/selftests/net/Makefile          |   1 +
>  tools/testing/selftests/net/so_incoming_cpu.c | 148 ++++++++++++++++++
>  3 files changed, 150 insertions(+)
>  create mode 100644 tools/testing/selftests/net/so_incoming_cpu.c
> 
> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> index 3d7adee7a3e6..ff8807cc9c2e 100644
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@ -25,6 +25,7 @@ rxtimestamp
>  sk_bind_sendto_listen
>  sk_connect_zero_addr
>  socket
> +so_incoming_cpu
>  so_netns_cookie
>  so_txtime
>  stress_reuseport_listen
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index 2a6b0bc648c4..ba57e7e7dc86 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -70,6 +70,7 @@ TEST_PROGS += io_uring_zerocopy_tx.sh
>  TEST_GEN_FILES += bind_bhash
>  TEST_GEN_PROGS += sk_bind_sendto_listen
>  TEST_GEN_PROGS += sk_connect_zero_addr
> +TEST_GEN_PROGS += so_incoming_cpu
>  
>  TEST_FILES := settings
>  
> diff --git a/tools/testing/selftests/net/so_incoming_cpu.c b/tools/testing/selftests/net/so_incoming_cpu.c
> new file mode 100644
> index 000000000000..0ee0f2e393eb
> --- /dev/null
> +++ b/tools/testing/selftests/net/so_incoming_cpu.c
> @@ -0,0 +1,148 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Amazon.com Inc. or its affiliates. */
> +#define _GNU_SOURCE
> +#include <sched.h>
> +
> +#include <netinet/in.h>
> +#include <sys/socket.h>
> +#include <sys/sysinfo.h>
> +
> +#include "../kselftest_harness.h"
> +
> +#define CLIENT_PER_SERVER	32 /* More sockets, more reliable */
> +#define NR_SERVER		self->nproc
> +#define NR_CLIENT		(CLIENT_PER_SERVER * NR_SERVER)
> +
> +FIXTURE(so_incoming_cpu)
> +{
> +	int nproc;
> +	int *servers;
> +	union {
> +		struct sockaddr addr;
> +		struct sockaddr_in in_addr;
> +	};
> +	socklen_t addrlen;
> +};
> +
> +FIXTURE_SETUP(so_incoming_cpu)
> +{
> +	self->nproc = get_nprocs();
> +	ASSERT_LE(2, self->nproc);
> +
> +	self->servers = malloc(sizeof(int) * NR_SERVER);
> +	ASSERT_NE(self->servers, NULL);
> +
> +	self->in_addr.sin_family = AF_INET;
> +	self->in_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
> +	self->in_addr.sin_port = htons(0);
> +	self->addrlen = sizeof(struct sockaddr_in);
> +}
> +
> +FIXTURE_TEARDOWN(so_incoming_cpu)
> +{
> +	int i;
> +
> +	for (i = 0; i < NR_SERVER; i++)
> +		close(self->servers[i]);
> +
> +	free(self->servers);
> +}
> +
> +void create_servers(struct __test_metadata *_metadata,
> +		    FIXTURE_DATA(so_incoming_cpu) *self)
> +{
> +	int i, fd, ret;
> +
> +	for (i = 0; i < NR_SERVER; i++) {
> +		fd = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
> +		ASSERT_NE(fd, -1);
> +
> +		ret = setsockopt(fd, SOL_SOCKET, SO_INCOMING_CPU, &i, sizeof(int));
> +		ASSERT_EQ(ret, 0);
> +
> +		ret = setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &(int){1}, sizeof(int));
> +		ASSERT_EQ(ret, 0);
> +
> +		ret = bind(fd, &self->addr, self->addrlen);
> +		ASSERT_EQ(ret, 0);
> +
> +		if (i == 0) {
> +			ret = getsockname(fd, &self->addr, &self->addrlen);
> +			ASSERT_EQ(ret, 0);
> +		}
> +
> +		/* We don't use CLIENT_PER_SERVER here not to block
> +		 * this test at connect() if SO_INCOMING_CPU is broken.
> +		 */
> +		ret = listen(fd, NR_CLIENT);
> +		ASSERT_EQ(ret, 0);
> +
> +		self->servers[i] = fd;
> +	}
> +}
> +
> +void create_clients(struct __test_metadata *_metadata,
> +		    FIXTURE_DATA(so_incoming_cpu) *self)
> +{
> +	cpu_set_t cpu_set;
> +	int i, j, fd, ret;
> +
> +	for (i = 0; i < NR_SERVER; i++) {
> +		CPU_ZERO(&cpu_set);
> +
> +		CPU_SET(i, &cpu_set);
> +		ASSERT_EQ(CPU_COUNT(&cpu_set), 1);
> +		ASSERT_NE(CPU_ISSET(i, &cpu_set), 0);
> +
> +		/* Make sure SYN will be processed on the i-th CPU
> +		 * and finally distributed to the i-th listener.
> +		 */
> +		sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
> +		ASSERT_EQ(ret, 0);
> +
> +		for (j = 0; j < CLIENT_PER_SERVER; j++) {
> +			fd  = socket(AF_INET, SOCK_STREAM, 0);
> +			ASSERT_NE(fd, -1);
> +
> +			ret = connect(fd, &self->addr, self->addrlen);
> +			ASSERT_EQ(ret, 0);
> +
> +			close(fd);
> +		}
> +	}
> +}
> +
> +void verify_incoming_cpu(struct __test_metadata *_metadata,
> +			 FIXTURE_DATA(so_incoming_cpu) *self)
> +{
> +	int i, j, fd, cpu, ret, total = 0;
> +	socklen_t len = sizeof(int);
> +
> +	for (i = 0; i < NR_SERVER; i++) {
> +		for (j = 0; j < CLIENT_PER_SERVER; j++) {
> +			/* If we see -EAGAIN here, SO_INCOMING_CPU is broken */
> +			fd = accept(self->servers[i], &self->addr, &self->addrlen);
> +			ASSERT_NE(fd, -1);
> +
> +			ret = getsockopt(fd, SOL_SOCKET, SO_INCOMING_CPU, &cpu, &len);
> +			ASSERT_EQ(ret, 0);
> +			ASSERT_EQ(cpu, i);
> +
> +			close(fd);
> +			total++;
> +		}
> +	}
> +
> +	ASSERT_EQ(total, NR_CLIENT);
> +	TH_LOG("SO_INCOMING_CPU is very likely to be "
> +	       "working correctly with %d sockets.", total);
> +}
> +
> +TEST_F(so_incoming_cpu, test1)
> +{
> +	create_servers(_metadata, self);
> +	create_clients(_metadata, self);
> +	verify_incoming_cpu(_metadata, self);
> +}

I think it would be nicer if you could add more test-cases, covering
e.g.:
- set SO_INCOMING_CPU after SO_REUSE_PORT, 
- initially including a socket without SO_INCOMING_CPU and the removing
it from the soreuseport set

Thanks,

Paolo

