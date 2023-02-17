Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C82D69B3FD
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjBQUeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBQUeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:34:18 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73577498BF;
        Fri, 17 Feb 2023 12:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=gzsWJo/nC86N1LakkM00hNY0DyClKKk9IamwNeJcMqU=; b=YHmUXa6J9VpG1M3quumlKBL4vm
        0A2Ula4audOe28+Q6J8S1rGr+jnaWDvlkm+tp4/Hv9PlDc0u/EL4wDv/obHY9iEFLENnMvUDC4Ezj
        uuXegET6ARz+Jw6SQz1XcLmU4PsCWtwavyULLtWkBWlyX1B7cp/Vz7s0DZVZvM4tV7MxWHew97nuj
        sMr+BfvwhppE6QvRvIUWBEvHiphd4CcE3VYd3JlpccmbHb+eZEK/XzvUBfh4tbW7yy2uv6immasic
        DP7Du0xPi/OPbYFdNzb4jNLGaXFo04O2SABoSAzN3zkNnwO7AlgHIq7M4W5NXnbR3QigeZG3uHibp
        kdRTn8ag==;
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pT7Qs-000Daj-9V; Fri, 17 Feb 2023 21:34:14 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pT7Qs-0002Ch-2W; Fri, 17 Feb 2023 21:34:14 +0100
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for
 bpf_fib_lookup
To:     Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        netdev@vger.kernel.org, kernel-team@meta.com
References: <20230217181224.2320704-1-martin.lau@linux.dev>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1c275189-e693-18eb-444d-b125193af615@iogearbox.net>
Date:   Fri, 17 Feb 2023 21:34:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20230217181224.2320704-1-martin.lau@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26815/Fri Feb 17 09:41:01 2023)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 7:12 PM, Martin KaFai Lau wrote:
[...]
>   include/uapi/linux/bpf.h       |  1 +
>   net/core/filter.c              | 39 ++++++++++++++++++++++------------
>   tools/include/uapi/linux/bpf.h |  1 +
>   3 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 1503f61336b6..6c1956e36c97 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6750,6 +6750,7 @@ struct bpf_raw_tracepoint_args {
>   enum {
>   	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
>   	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
> +	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),

Sry, just noticed this now, but this would also need a uapi helper comment
to describe the new BPF_FIB_LOOKUP_SKIP_NEIGH flag.

>   };
>   
