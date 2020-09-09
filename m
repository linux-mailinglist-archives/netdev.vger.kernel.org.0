Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BD02632FA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgIIP4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:56:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52385 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730463AbgIIPzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599666903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2VaXpUx2RgFYaGXvPxTF0x5NFUabOVTHG+USRhiruLc=;
        b=i53HO3r3SPcLzM7AYb97AHgK3Im5qD7ih1rwfmMvFBgt9IBN6dgEJMs3ZBhQWpeF9CPwI+
        MQxd7KwRuRSefvGVlOC190i1DVh99xfNqjgwnpx9XlQke49EeWgk/v41Xf0k38PJ4wJ7So
        x3pU9nm/Vxxx3S3K2n+0k7qdGoMNfnM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-sc9VSMeGPe-OwSzeIJs8iA-1; Wed, 09 Sep 2020 11:55:01 -0400
X-MC-Unique: sc9VSMeGPe-OwSzeIJs8iA-1
Received: by mail-wr1-f72.google.com with SMTP id j7so1127182wro.14
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 08:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2VaXpUx2RgFYaGXvPxTF0x5NFUabOVTHG+USRhiruLc=;
        b=gbyhTjHQXHu3FN1RbtB7pdZ36V9Cd1/5XPRtBVa9JRSYaPl0/GGXBWsVJJoPZwEvSA
         THwVYlAqmdPCqIZxYB3g8vBxyiF8JqClYmOBTH3NeQLs5K/uVraUniBuJ0uNjAFsFUj+
         3Ta1x3o3S/wXtGMw0dBvi5nLWLTDQvjZtnWaXIX+9ix5JiuzhbN6ocjjrbxSlZM5tY5B
         UjewODajukVC6qnaWqqwrowdl8jzBivQs5QCi0yyJ/3OpdrTtycgehxO3LiirXiolMh6
         SNidhZBsFZPxh3V0P1jgv12XZaPCpUeoD7Rsbdun6RppmI6wQeAZAMu56H4YxFkxrKIr
         2yRw==
X-Gm-Message-State: AOAM533uVJ0K6UjzgBsbfx3RP4YzwKB/AtnGVYeF0XLJFcbvCtnZ9jcK
        y2kxnEezXsMhtSW1cQI5BUiio7geLXwLn2Heu9SmAcPnqZeks0HzGE80Hx3WsoWpxR3HIDUfQXR
        i6ptAGnuiOIhSdA9S
X-Received: by 2002:a5d:608a:: with SMTP id w10mr4501727wrt.48.1599666899949;
        Wed, 09 Sep 2020 08:54:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaMzx/VEi+OD4KdcdvBWVIyUWE9NHTFTuqvs+ds8e6vK9qDG97AejivLuFgbBm5xOBHbzs9w==
X-Received: by 2002:a5d:608a:: with SMTP id w10mr4501693wrt.48.1599666899595;
        Wed, 09 Sep 2020 08:54:59 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h184sm4718859wmh.41.2020.09.09.08.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 08:54:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 68F4D1829D4; Wed,  9 Sep 2020 17:54:58 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Fix context type resolving for
 extension programs
In-Reply-To: <20200909151115.1559418-1-jolsa@kernel.org>
References: <20200909151115.1559418-1-jolsa@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 09 Sep 2020 17:54:58 +0200
Message-ID: <871rjbc5d9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa <jolsa@kernel.org> writes:

> Eelco reported we can't properly access arguments if the tracing
> program is attached to extension program.
>
> Having following program:
>
>   SEC("classifier/test_pkt_md_access")
>   int test_pkt_md_access(struct __sk_buff *skb)
>
> with its extension:
>
>   SEC("freplace/test_pkt_md_access")
>   int test_pkt_md_access_new(struct __sk_buff *skb)
>
> and tracing that extension with:
>
>   SEC("fentry/test_pkt_md_access_new")
>   int BPF_PROG(fentry, struct sk_buff *skb)
>
> It's not possible to access skb argument in the fentry program,
> with following error from verifier:
>
>   ; int BPF_PROG(fentry, struct sk_buff *skb)
>   0: (79) r1 = *(u64 *)(r1 +0)
>   invalid bpf_context access off=0 size=8
>
> The problem is that btf_ctx_access gets the context type for the
> traced program, which is in this case the extension.
>
> But when we trace extension program, we want to get the context
> type of the program that the extension is attached to, so we can
> access the argument properly in the trace program.
>
> Reported-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/btf.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index f9ac6935ab3c..37ad01c32e5a 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3859,6 +3859,14 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>  	}
>  
>  	info->reg_type = PTR_TO_BTF_ID;
> +
> +	/* When we trace extension program, we want to get the context
> +	 * type of the program that the extension is attached to, so
> +	 * we can access the argument properly in the trace program.
> +	 */
> +	if (tgt_prog && tgt_prog->type == BPF_PROG_TYPE_EXT)
> +		tgt_prog = tgt_prog->aux->linked_prog;
> +

In the discussion about multi-attach for freplace we kinda concluded[0]
that this linked_prog pointer was going away after attach. I have this
basically working, but need to test a bit more before posting it (see
[1] for current status).

But with this I guess we'll need to either do something different? Maybe
go chase down the target via the bpf_link or something?

-Toke

[0] https://lore.kernel.org/bpf/20200722002918.574pruibvlxfblyq@ast-mbp.dhcp.thefacebook.com/
[1] https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=bpf-freplace-multi-attach-alt-03

