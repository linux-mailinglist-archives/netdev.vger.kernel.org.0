Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04065FCECF
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 01:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiJLXSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 19:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJLXSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 19:18:00 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BEE12C896;
        Wed, 12 Oct 2022 16:17:58 -0700 (PDT)
Message-ID: <611e9bed-df6a-0da9-fbf9-4046f4211a7d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665616676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XOuJ7J4AXKe3c2xjfQLYvSiF4wv25bV1J+/a3durzkE=;
        b=ss3SZKmv5qqRSFdRJIkW6XkbNiHsncJBhMMqUUPKhF/GsqJ4FxMhfCZt4iC/U1y5AiIoVD
        PqslwXqf9d7tcBZ1fJgav1ZAh+KlPm/LP3w2pm6O803ahiVBUyqbm+OAKmNeKLn4hUx//l
        0D2MBZ4NtN/Zr6ZlnnhluC0qO1uJlDk=
Date:   Wed, 12 Oct 2022 16:17:51 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v4 5/6] selftests/bpf: Fix error failure of case
 test_xdp_adjust_tail_grow
Content-Language: en-US
To:     Xu Kuohai <xukuohai@huaweicloud.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221011120108.782373-1-xukuohai@huaweicloud.com>
 <20221011120108.782373-6-xukuohai@huaweicloud.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221011120108.782373-6-xukuohai@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/22 5:01 AM, Xu Kuohai wrote:
> From: Xu Kuohai <xukuohai@huawei.com>
> 
> test_xdp_adjust_tail_grow failed with ipv6:
>    test_xdp_adjust_tail_grow:FAIL:ipv6 unexpected error: -28 (errno 28)
> 
> The reason is that this test case tests ipv4 before ipv6, and when ipv4
> test finished, topts.data_size_out was set to 54, which is smaller than the
> ipv6 output data size 114, so ipv6 test fails with NOSPC error.
> 
> Fix it by reset topts.data_size_out to sizeof(buf) before testing ipv6.
> 
> Fixes: 04fcb5f9a104 ("selftests/bpf: Migrate from bpf_prog_test_run")
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> ---
>   tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
> index 9b9cf8458adf..009ee37607df 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
> @@ -63,6 +63,7 @@ static void test_xdp_adjust_tail_grow(void)
>   	expect_sz = sizeof(pkt_v6) + 40; /* Test grow with 40 bytes */
>   	topts.data_in = &pkt_v6;
>   	topts.data_size_in = sizeof(pkt_v6);
> +	topts.data_size_out = sizeof(buf);

lgtm but how was it working before... weird.

>   	err = bpf_prog_test_run_opts(prog_fd, &topts);
>   	ASSERT_OK(err, "ipv6");
>   	ASSERT_EQ(topts.retval, XDP_TX, "ipv6 retval");

