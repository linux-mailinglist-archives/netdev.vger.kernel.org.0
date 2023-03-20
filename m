Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C3B6C1F8D
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjCTSY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCTSYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:24:01 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11C92F05D;
        Mon, 20 Mar 2023 11:17:07 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 4ADCD5FD2B;
        Mon, 20 Mar 2023 21:16:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679336170;
        bh=Z0sIPCgypIi4TJB1GHQVuu6GyCfp9PpEyQgtrxUo/uE=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=nUayYhiu9fWaTn9R7yZrd1X5dNwV3wQEnj4/V5MWZVPxKkk9qO0/MfMCQ9LMVI1n2
         7r6skOA2qFMqgBysM+fHLH66/ljkFXXQ2ZeT5XiHlXdxMhWSmWeSESgrR7LkiAREU9
         h2tGH/Vb5YCeqrbsPVDHeFLE0Pa6IJWlgUUlJ1lVN5MfpBz3oTOqVFNKz7XwM9ZnFr
         L9sgdTb+JWMabL8bS1Tm9Q5wV8sujgI+EPvdVPkrtJ06cMiN6m3q2DOTivyT2UKEyq
         HNFUaa0amH8HU+cIkTykxEapLy22gqgBf3WhNTx3C1JM3YkPfPZjC4JMNimYXgMJbU
         tRheMUtc26WjQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 20 Mar 2023 21:16:09 +0300 (MSK)
Message-ID: <77cab994-5ef6-0561-0faf-4510ec5f3d79@sberdevices.ru>
Date:   Mon, 20 Mar 2023 21:12:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 3/3] test/vsock: skbuff merging test
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
 <14ca87d1-3e07-85e9-d11c-39789a9d17d4@sberdevices.ru>
 <20230320153132.o3xvwxmn3722lin4@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230320153132.o3xvwxmn3722lin4@sgarzare-redhat>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/20 09:56:00 #20977321
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.03.2023 18:31, Stefano Garzarella wrote:
> On Sun, Mar 19, 2023 at 09:53:54PM +0300, Arseniy Krasnov wrote:
>> This adds test which checks case when data of newly received skbuff is
>> appended to the last skbuff in the socket's queue.
>>
>> This test is actual only for virtio transport.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> tools/testing/vsock/vsock_test.c | 81 ++++++++++++++++++++++++++++++++
>> 1 file changed, 81 insertions(+)
>>
>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> index 3de10dbb50f5..00216c52d8b6 100644
>> --- a/tools/testing/vsock/vsock_test.c
>> +++ b/tools/testing/vsock/vsock_test.c
>> @@ -968,6 +968,82 @@ static void test_seqpacket_inv_buf_server(const struct test_opts *opts)
>>     test_inv_buf_server(opts, false);
>> }
>>
>> +static void test_stream_virtio_skb_merge_client(const struct test_opts *opts)
>> +{
>> +    ssize_t res;
>> +    int fd;
>> +
>> +    fd = vsock_stream_connect(opts->peer_cid, 1234);
>> +    if (fd < 0) {
>> +        perror("connect");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
> 
> Please use a macro for "HELLO" or a variabile, e.g.
> 
>         char *buf;
>         ...
> 
>         buf = "HELLO";
>         res = send(fd, buf, strlen(buf), 0);
>         ...
> 
>> +    res = send(fd, "HELLO", strlen("HELLO"), 0);
>> +    if (res != strlen("HELLO")) {
>> +        fprintf(stderr, "unexpected send(2) result %zi\n", res);
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_writeln("SEND0");
>> +    /* Peer reads part of first packet. */
>> +    control_expectln("REPLY0");
>> +
>> +    /* Send second skbuff, it will be merged. */
>> +    res = send(fd, "WORLD", strlen("WORLD"), 0);
> 
> Ditto.
> 
>> +    if (res != strlen("WORLD")) {
>> +        fprintf(stderr, "unexpected send(2) result %zi\n", res);
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_writeln("SEND1");
>> +    /* Peer reads merged skbuff packet. */
>> +    control_expectln("REPLY1");
>> +
>> +    close(fd);
>> +}
>> +
>> +static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
>> +{
>> +    unsigned char buf[64];
>> +    ssize_t res;
>> +    int fd;
>> +
>> +    fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>> +    if (fd < 0) {
>> +        perror("accept");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_expectln("SEND0");
>> +
>> +    /* Read skbuff partially. */
>> +    res = recv(fd, buf, 2, 0);
>> +    if (res != 2) {
>> +        fprintf(stderr, "expected recv(2) failure, got %zi\n", res);
> 
> We don't expect a failure, so please update the error message and make
> it easy to figure out which recv() is failing. For example by saying
> how many bytes you expected and how many you received.
> 
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_writeln("REPLY0");
>> +    control_expectln("SEND1");
>> +
>> +
>> +    res = recv(fd, buf, sizeof(buf), 0);
> 
> Perhaps a comment here to explain why we expect only 8 bytes.
> 
>> +    if (res != 8) {
>> +        fprintf(stderr, "expected recv(2) failure, got %zi\n", res);
> 
> Ditto.
> 
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    res = recv(fd, buf, sizeof(buf), MSG_DONTWAIT);
>> +    if (res != -1) {
>> +        fprintf(stderr, "expected recv(2) success, got %zi\n", res);
> 
> It's the other way around, isn't it?
> Here you expect it to fail instead it is not failing.
> 
>> +        exit(EXIT_FAILURE);
>> +    }
> 
> Moving the pointer correctly, I would also check that there is
> HELLOWORLD in the buffer.
> 
> Thanks for adding tests in this suite!
> Stefano

Thanks for review, i didn't pay any attention on this test, because it is
just bug reproducer. But if we are going to add it, of course i'll clean
it's code.

Thanks, Arseniy

> 
>> +
>> +    control_writeln("REPLY1");
>> +
>> +    close(fd);
>> +}
>> +
>> static struct test_case test_cases[] = {
>>     {
>>         .name = "SOCK_STREAM connection reset",
>> @@ -1038,6 +1114,11 @@ static struct test_case test_cases[] = {
>>         .run_client = test_seqpacket_inv_buf_client,
>>         .run_server = test_seqpacket_inv_buf_server,
>>     },
>> +    {
>> +        .name = "SOCK_STREAM virtio skb merge",
>> +        .run_client = test_stream_virtio_skb_merge_client,
>> +        .run_server = test_stream_virtio_skb_merge_server,
>> +    },
>>     {},
>> };
>>
>> -- 
>> 2.25.1
>>
> 
