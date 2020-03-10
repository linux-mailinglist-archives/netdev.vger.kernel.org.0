Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342D817EEF3
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 04:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCJDGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 23:06:36 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:43579 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJDGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 23:06:36 -0400
Received: by mail-qv1-f65.google.com with SMTP id c28so1975717qvb.10
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 20:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vlw3mVvi/+xI277Aeqy946e9FyCpmGADhHzRjQAtFxM=;
        b=I6r1rXpmKBsZjaPjUA/SXwt+T7CKAGlvNdky1ZViMRZWTjqbrGzqz8AcU0kCd0+J6F
         Aj7byRwuXP1qxMdxgNYkEa0hWhfXMnTjJVpa1ZkPSMF0k81qCPqOAIK05pLyUQPhpCgb
         s4VKqxYCWyPvVbFno51t51Eqh9Q62QStWJcac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vlw3mVvi/+xI277Aeqy946e9FyCpmGADhHzRjQAtFxM=;
        b=HqpgQmpO9whbhpNDbOmdqel2sd8PXvjv4o053o1zVXPWRkZ2HJYW5Jdu3hkJjfA5Jb
         Trsnsnf+w9HVwRhFUP65ucx3Givn4nkzv7ZPyLC/zKKIf5Y+7dPMnf0e8gW+vzSHM5/F
         S1XiBjWr9n6AgPoK4c76JoJDzPaH/BZYb1swHl4vR0oth39evgPnIHNzI905IBENpuZr
         ugdNj0fo9g2LzQUsuZGeMdXs+7//1tYhYY4aU5LOeNSwvvzgWvCiJtRj0CMHo/efZtlK
         n2/AQcAPYOkAbLVnBbkQ3SkSX5mWT0gpt9GTlOoCjEE+QVLyjv8dlHvdbCpivxHq5yzB
         DUpQ==
X-Gm-Message-State: ANhLgQ2g3kokgMKsPPtbZUSjW1HUhk4c70NQNfnqcRG0Q5Di4Q3Yeec0
        hn61gLihz9TMCvu0P2uXRDYLhw==
X-Google-Smtp-Source: ADFU+vv03jdeHJulIURjULqL1KTRA6eH7bFIwDw9NYAcWRHI/gs2wPuSzByu/57jhhQURgndoMkj7w==
X-Received: by 2002:a0c:8601:: with SMTP id p1mr3550075qva.59.1583809595392;
        Mon, 09 Mar 2020 20:06:35 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b876:5d04:c7e4:4480? ([2601:282:803:7700:b876:5d04:c7e4:4480])
        by smtp.gmail.com with ESMTPSA id x188sm14226287qka.53.2020.03.09.20.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 20:06:34 -0700 (PDT)
Subject: Re: [PATCH RFC v4 bpf-next 09/11] tun: Support xdp in the Tx path for
 xdp_frames
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-10-dsahern@kernel.org> <20200303114044.2c7482d5@carbon>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <14ef34c2-2fa6-f58c-6d63-e924d07e613f@digitalocean.com>
Date:   Mon, 9 Mar 2020 21:06:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303114044.2c7482d5@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 3:40 AM, Jesper Dangaard Brouer wrote:
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index dcae6521a39d..d3fc7e921c85 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -1359,10 +1359,50 @@ static void __tun_xdp_flush_tfile(struct tun_file *tfile)
>>  	tfile->socket.sk->sk_data_ready(tfile->socket.sk);
>>  }
>>  
>> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
>> +			 struct xdp_frame *frame, struct xdp_txq_info *txq)
>> +{
>> +	struct bpf_prog *xdp_prog;
>> +	u32 act = XDP_PASS;
>> +
>> +	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
>> +	if (xdp_prog) {
>> +		struct xdp_buff xdp;
>> +
>> +		xdp.data_hard_start = frame->data - frame->headroom;
> 
> This is correct, only because frame->headroom have been reduced with
> sizeof(*xdp_frame), as we want to avoid that the BPF-prog have access
> to xdp_frame memory.  Remember that memory storing xdp_frame in located
> in the top of the payload/page.
> 
> 
>> +		xdp.data = frame->data;
>> +		xdp.data_end = xdp.data + frame->len;
>> +		xdp_set_data_meta_invalid(&xdp);
>> +		xdp.txq = txq;
>> +
>> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> 
> The BPF-prog can change/adjust headroom and tailroom (tail only shrink,
> but I'm working on extending this).  Thus, you need to adjust the
> xdp_frame accordingly afterwards.

Why do I need to make any adjustments beyond what is done by
bpf_xdp_adjust_head and bpf_xdp_adjust_tail?

The frame is on its way out, so the stack will not see the frame after
any head or tail changes. (REDIRECT is not supported, only PASS or DROP)
