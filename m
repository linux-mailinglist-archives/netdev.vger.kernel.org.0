Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D32691255
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 21:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjBIU7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 15:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjBIU7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 15:59:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2D76ADC1
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 12:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675976295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BDZuMv0cyMgXrbGMVIJjQf6uurXxR3KvzMvBCEl1dG8=;
        b=SotnV0Z74keSJNARjHf+zhMzItCkoshZlMVw9Tj/gi1FTwTxQqvziw3iv2ENIhxwe5Vd2x
        UqDHyJBvbQBE4TStm7eQrqwHKOmG1JK98Ly+zXElRQqfKT5xZJ4kbTuUH/FTmykiwz/nQp
        6Mjxdsj47jMIyT3eqBjZS0VczSfYuwg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-367-Qi2FR7RSOeasHp6jVxrt8Q-1; Thu, 09 Feb 2023 15:58:14 -0500
X-MC-Unique: Qi2FR7RSOeasHp6jVxrt8Q-1
Received: by mail-ed1-f69.google.com with SMTP id s20-20020a05640217d400b004ab46449f12so87831edy.23
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 12:58:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDZuMv0cyMgXrbGMVIJjQf6uurXxR3KvzMvBCEl1dG8=;
        b=WJliBZ2YnQcijP3Jf4c3k9oB4lDaFWAcKnYf8HGd5MJpGMoJkrr5ICEPaHz+HFx9B+
         EBYAFDd4pKmcNfHIbkSNakhAZFr4SeEM8Kkg866i8c8GJFRQgb7f0RBlSuWREai4Dx7W
         TdszalNngDDVmfqLRk266wvsrgO0W5/OlCJiPqD3uK1s0fp0poJYReYRsWrOmHbsO2eh
         Y5AWbmD49LYOmol0kChBpG/U4Cqo3Jx8nBGvrTs2G2zOQwOIjwyWWv12lw+jUpty1QrS
         RE7jeUE9n473g9IDAkNaGtclUjFmn3Hb4JAeI/Te3eI/S6ov+MXMWX0GSfaesjjFDi6C
         dSrg==
X-Gm-Message-State: AO0yUKVUlMytBGJTHqcpgGbz1krsC0KIm434U7i94Qki8YoSF+5aphCe
        70w40y2FHcWW06AL5f1zymDaNrjDD4id2n+g9GHWWHfSXYQR0jPq/BouvjLNDygVxdujAnYXTh2
        N7NRlZDHyhVDvenNA
X-Received: by 2002:a50:f609:0:b0:4ab:25a3:6657 with SMTP id c9-20020a50f609000000b004ab25a36657mr1864566edn.22.1675976291201;
        Thu, 09 Feb 2023 12:58:11 -0800 (PST)
X-Google-Smtp-Source: AK7set/JDa5gJ8k53X+CCbIN/HJHEPavoZU81+194X/Y87Dd0W6io3LHdig3Q/hqN0QRQg4e6o93KQ==
X-Received: by 2002:a50:f609:0:b0:4ab:25a3:6657 with SMTP id c9-20020a50f609000000b004ab25a36657mr1864513edn.22.1675976290346;
        Thu, 09 Feb 2023 12:58:10 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 18-20020a508e12000000b004aacac472f7sm1280115edw.27.2023.02.09.12.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 12:58:09 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BFE36973E3B; Thu,  9 Feb 2023 21:58:07 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
In-Reply-To: <6db57eb4-02c2-9443-b9eb-21c499142c98@intel.com>
References: <20230209172827.874728-1-alexandr.lobakin@intel.com>
 <6db57eb4-02c2-9443-b9eb-21c499142c98@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 09 Feb 2023 21:58:07 +0100
Message-ID: <87sffe7e00.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> Date: Thu, 9 Feb 2023 18:28:27 +0100
>
>> &xdp_buff and &xdp_frame are bound in a way that
>> 
>> xdp_buff->data_hard_start == xdp_frame
>
> [...]
>
>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>> index 2723623429ac..c3cce7a8d47d 100644
>> --- a/net/bpf/test_run.c
>> +++ b/net/bpf/test_run.c
>> @@ -97,8 +97,11 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, int iterations,
>>  struct xdp_page_head {
>>  	struct xdp_buff orig_ctx;
>>  	struct xdp_buff ctx;
>> -	struct xdp_frame frm;
>> -	u8 data[];
>> +	union {
>> +		/* ::data_hard_start starts here */
>> +		DECLARE_FLEX_ARRAY(struct xdp_frame, frm);
>> +		DECLARE_FLEX_ARRAY(u8, data);
>> +	};
>
> BTW, xdp_frame here starts at 112 byte offset, i.e. in 16 bytes a
> cacheline boundary is hit, so xdp_frame gets sliced into halves: 16
> bytes in CL1 + 24 bytes in CL2. Maybe we'd better align this union to
> %NET_SKB_PAD / %SMP_CACHE_BYTES / ... to avoid this?

Hmm, IIRC my reasoning was that both those cache lines will be touched
by the code in xdp_test_run_batch(), so it wouldn't matter? But if
there's a performance benefit I don't mind adding an explicit alignment
annotation, certainly!

> (but in bpf-next probably)

Yeah...

-Toke

