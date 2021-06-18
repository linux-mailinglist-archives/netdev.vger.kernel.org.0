Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41FB3AD4BE
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 00:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbhFRWE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 18:04:57 -0400
Received: from novek.ru ([213.148.174.62]:34888 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234699AbhFRWE5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 18:04:57 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C11FA50053A;
        Sat, 19 Jun 2021 01:00:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C11FA50053A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1624053655; bh=2BM+IBth0i+23PTMvcaWDgFd2UbCMYzB7VDJhYUIhHM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Pa1QSBTnn9y9qOSG64thdt91pCkxAMv+iyVO9lF2+nHfB8aDDLXYnxuMOCmYY5GTH
         o/AvNyyVaW2Y95eU4ap0ankGNvCzoauVfnnb4RdrosppSL7w5XBwda3TAEdA/aYIka
         +v0jOJDFopjoQeK06nnY6tae30oJXPcIXcdkvt3w=
Subject: Re: [PATCH net 1/2] selftests: tls: clean up uninitialized warnings
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org
References: <20210618202504.1435179-1-kuba@kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <b92c5196-2a8d-e2ea-2739-73f623d6af9b@novek.ru>
Date:   Fri, 18 Jun 2021 23:02:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210618202504.1435179-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.06.2021 21:25, Jakub Kicinski wrote:
> A bunch of tests uses uninitialized stack memory as random
> data to send. This is harmless but generates compiler warnings.
> Explicitly init the buffers with random data.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   tools/testing/selftests/net/tls.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
> index 426d07875a48..58fea6eb588d 100644
> --- a/tools/testing/selftests/net/tls.c
> +++ b/tools/testing/selftests/net/tls.c
> @@ -25,6 +25,18 @@
>   #define TLS_PAYLOAD_MAX_LEN 16384
>   #define SOL_TLS 282
>   
> +static void memrnd(void *s, size_t n)
> +{
> +	int *dword = s;
> +	char *byte;
> +
> +	for (; n >= 4; n -= 4)
> +		*dword++ = rand();
> +	byte = (void *)dword;
> +	while (n--)
> +		*byte++ = rand();
> +}
> +
>   FIXTURE(tls_basic)
>   {
>   	int fd, cfd;
> @@ -308,6 +320,8 @@ TEST_F(tls, recv_max)
>   	char recv_mem[TLS_PAYLOAD_MAX_LEN];
>   	char buf[TLS_PAYLOAD_MAX_LEN];
>   
> +	memrnd(buf, sizeof(buf));
> +
>   	EXPECT_GE(send(self->fd, buf, send_len, 0), 0);
>   	EXPECT_NE(recv(self->cfd, recv_mem, send_len, 0), -1);
>   	EXPECT_EQ(memcmp(buf, recv_mem, send_len), 0);
> @@ -588,6 +602,8 @@ TEST_F(tls, recvmsg_single_max)
>   	struct iovec vec;
>   	struct msghdr hdr;
>   
> +	memrnd(send_mem, sizeof(send_mem));
> +
>   	EXPECT_EQ(send(self->fd, send_mem, send_len, 0), send_len);
>   	vec.iov_base = (char *)recv_mem;
>   	vec.iov_len = TLS_PAYLOAD_MAX_LEN;
> @@ -610,6 +626,8 @@ TEST_F(tls, recvmsg_multiple)
>   	struct msghdr hdr;
>   	int i;
>   
> +	memrnd(buf, sizeof(buf));
> +
>   	EXPECT_EQ(send(self->fd, buf, send_len, 0), send_len);
>   	for (i = 0; i < msg_iovlen; i++) {
>   		iov_base[i] = (char *)malloc(iov_len);
> @@ -634,6 +652,8 @@ TEST_F(tls, single_send_multiple_recv)
>   	char send_mem[TLS_PAYLOAD_MAX_LEN * 2];
>   	char recv_mem[TLS_PAYLOAD_MAX_LEN * 2];
>   
> +	memrnd(send_mem, sizeof(send_mem));
> +
>   	EXPECT_GE(send(self->fd, send_mem, total_len, 0), 0);
>   	memset(recv_mem, 0, total_len);
>   
> 

Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>

