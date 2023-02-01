Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E47686D5B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjBARrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjBARq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:46:58 -0500
Received: from out-111.mta0.migadu.com (out-111.mta0.migadu.com [IPv6:2001:41d0:1004:224b::6f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F44C7E06D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:46:49 -0800 (PST)
Message-ID: <484ca75b-d5f0-31db-6f81-2fb17ce0702e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675273607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+Zuzz/eG7rfVrQVnPkpNvhb87iYoOFZHxh0vAcr8AI=;
        b=VpC0XOi/C/dpXZ97CaNwz+7J40h7DqmoIj4xsb6MDRIHxb/E9iLSUV8lCXmWotAQj/tx3N
        U/wE60ZNTUYtIdWteYxdcieANAR8XQ1AFW3nLnAuyUi1cEKi5Bo2Ndjd3/JOw9QH3CwgUu
        vt4siNxvdDlSECwekKf8MnFQflAh5jc=
Date:   Wed, 1 Feb 2023 09:46:36 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next V2 2/4] selftests/bpf: xdp_hw_metadata cleanup
 cause segfault
Content-Language: en-US
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, martin.lau@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net, bpf@vger.kernel.org
References: <167527267453.937063.6000918625343592629.stgit@firesoul>
 <167527271533.937063.5717065138099679142.stgit@firesoul>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <167527271533.937063.5717065138099679142.stgit@firesoul>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/23 9:31 AM, Jesper Dangaard Brouer wrote:
> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> index 3823b1c499cc..438083e34cce 100644
> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> @@ -121,7 +121,7 @@ static void close_xsk(struct xsk *xsk)
>   		xsk_umem__delete(xsk->umem);
>   	if (xsk->socket)
>   		xsk_socket__delete(xsk->socket);
> -	munmap(xsk->umem, UMEM_SIZE);
> +	munmap(xsk->umem_area, UMEM_SIZE);

Ah. Good catch. This should also explain a similar issue that CI is seeing in 
the prog_tests/xdp_metadata.c.

