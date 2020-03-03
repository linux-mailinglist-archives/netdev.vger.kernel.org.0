Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4DC177A8F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbgCCPgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:36:06 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:35695 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729588AbgCCPgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:36:06 -0500
Received: by mail-qv1-f65.google.com with SMTP id u10so1865167qvi.2
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 07:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RZ3u1ymiEOZCYHkXaCjP+k9MxgIQsITaRkDqBuIXEG0=;
        b=UJRBXMFmrs6G84YWmNg0gAlIiZRorMZytGmI17ZUYspEmc9tR11Sm7S5c5mFlQ3bw7
         enKvmzFKafjDSkC7pAVk/dGyGJDtgLvSYM253kX9lAX6rLnSqa/oY+jdkGa+tMuWgRa2
         XxxvvPpUOkK167vu/FGHzOUSMvF6abAGbjCOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RZ3u1ymiEOZCYHkXaCjP+k9MxgIQsITaRkDqBuIXEG0=;
        b=iSmTiO3vBHSqqhZHYebPcGTJ+MCc1oAPVT2O79CTOe+kI3rrJkHkOTYCQDjBTX8vpF
         HJQMGW0Z0+19Ko57NpWfuoy6Quu37SsSGKSyKR7GWRvSIyu4S7d4xnEhg/M9F2HkpEss
         XNVrV0lPa8swVu4oMCCTC/YhK2zzUMX9vOUuDH2Ug1Tf8EY4TKsDPtTu5VbjSentDxqh
         G8Drk+Z2aDQtiQvnVcNxBN88gTxSLTBQh3jYEqNG54mrS7iuKANSIu8JBgC0v4Tvzfe3
         4vYLbd4gscrX0cnQJcLo7I22GuJVOrZovgOMRogztFf/rSa2gjV9ODAVL3wgKyCkXq5/
         /+4A==
X-Gm-Message-State: ANhLgQ0gwRug4/idH94PIXShFqspHDOzQ5qrcF9+v6EbOURrWa1aavZQ
        Mk1lNvWFDSVxtn4Tket15Silkg==
X-Google-Smtp-Source: ADFU+vtECMzZQSduoM4LhGR+wzuaIt4tLJwnD/MPqnzRIPtWkZovWM6SCUSI65YGs3whLoj5AsoWNA==
X-Received: by 2002:a0c:f6c8:: with SMTP id d8mr4624836qvo.234.1583249765211;
        Tue, 03 Mar 2020 07:36:05 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:29f0:2f5d:cfa7:1ce8? ([2601:282:803:7700:29f0:2f5d:cfa7:1ce8])
        by smtp.gmail.com with ESMTPSA id j18sm11969260qka.95.2020.03.03.07.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 07:36:04 -0800 (PST)
Subject: Re: [PATCH RFC v4 bpf-next 08/11] tun: Support xdp in the Tx path for
 skb
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-9-dsahern@kernel.org> <20200303114619.1b5b52bc@carbon>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <cc03fcd1-5a12-283a-db90-cbf17658365a@digitalocean.com>
Date:   Tue, 3 Mar 2020 08:36:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303114619.1b5b52bc@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 3:46 AM, Jesper Dangaard Brouer wrote:
> On Wed, 26 Feb 2020 20:20:10 -0700
> David Ahern <dsahern@kernel.org> wrote:
> 
>> +static u32 tun_do_xdp_tx_generic(struct tun_struct *tun,
>> +				 struct net_device *dev,
>> +				 struct sk_buff *skb)
>> +{
>> +	struct bpf_prog *xdp_prog;
>> +	u32 act = XDP_PASS;
>> +
>> +	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
>> +	if (xdp_prog) {
>> +		struct xdp_txq_info txq = { .dev = dev };
>> +		struct xdp_buff xdp;
>> +
>> +		skb = tun_prepare_xdp_skb(skb);
>> +		if (!skb) {
>> +			act = XDP_DROP;
>> +			goto out;
>> +		}
>> +
>> +		xdp.txq = &txq;
>> +
>> +		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
>> +		switch (act) {
>> +		case XDP_TX:    /* for Tx path, XDP_TX == XDP_PASS */
>> +			act = XDP_PASS;
>> +			break;
>> +		case XDP_PASS:
>> +			break;
>> +		case XDP_REDIRECT:
>> +			/* fall through */
>> +		default:
>> +			bpf_warn_invalid_xdp_action(act);
>> +			/* fall through */
>> +		case XDP_ABORTED:
>> +			trace_xdp_exception(tun->dev, xdp_prog, act);
> 
> Hmm, don't we need to extend the trace_xdp_exception() to give users a
> hint that this happened on the TX/egress path?

tracepoint has the program id, unsupported action and device. Seems like
the program id is sufficient. I do need to update libbpf to account for
the attach type.
