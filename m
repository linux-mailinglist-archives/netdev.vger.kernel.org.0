Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73B6629ED1
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238627AbiKOQTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238629AbiKOQTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:19:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC6F2F67F
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668529066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dDNdu3Y9fr5FOdr8MTcDO+pL9js6k+/irqVmUcE/IG0=;
        b=Xw+vMsLqLP9L7542ruzEvg/e4oo6xevorFsm9LwpVaYmXo25l7FJUDvuMqN+2KwgPD2tIb
        qCO1KW8LTsT2imo6rc45KsbMTRvp7hDU4XS+0QE7h4vDRNHYsI2JeEIpuo49+ChWK9bNjM
        BbWHlVQXhvpwW8RGZlYStvpYOQpQYTg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-p7K0WqEGMOmUx3cWV-dDVA-1; Tue, 15 Nov 2022 11:17:45 -0500
X-MC-Unique: p7K0WqEGMOmUx3cWV-dDVA-1
Received: by mail-ej1-f72.google.com with SMTP id xj11-20020a170906db0b00b0077b6ecb23fcso7592371ejb.5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:17:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dDNdu3Y9fr5FOdr8MTcDO+pL9js6k+/irqVmUcE/IG0=;
        b=kAY7aQFTxK3nq6lG5DSgYXMqPGHb6hJFnGG4FgeaLIouaO6KAVXi3JI3ds5IDBDqVl
         hdjKenlGXpEZWF9+Qg4seYse5iOWPQ5g4IzCFFHK4eDUNEBMx2qCYZ9tkdExd6whrdLU
         w7rZNzYNOMt1R/uN+2g5aw/9QATsUbuFk7Ze2CUL/Fr3f0Lk3giuYKLhmzvkHFyO2gx0
         S59qEatMOBmYdH2KtyZp1mIvhyau21YaoGyd03VEHMJHzYN5JktE0EJTnCQ+SIBH+6i9
         LPZlj1iRquCp3zKKflvVN2YDkz5CLtAgIAMjcMF5gno3AZLcU8lhBJQP4KexQhnGECD/
         Zdzw==
X-Gm-Message-State: ANoB5pmr+dLwS8S9QXs/YnkRva+1R0vpyLlhhimRyF7ngvrLyYkNp1+T
        whr966ssPUm1IUHDZRrNMb5r8oZ8rKvRuhUDQo6xEjM4KJfaN6bnvc//2EwOYf11T4bjFvLhvsD
        Vh3qAIArJRUe9mCiq
X-Received: by 2002:a17:906:4dd6:b0:7ad:a030:487e with SMTP id f22-20020a1709064dd600b007ada030487emr14892573ejw.508.1668529063847;
        Tue, 15 Nov 2022 08:17:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4cIst8+Ig0NZcClVeIsQkF2jZkdjAmTbe5xwQCO1YruIKHoWA/N3/mXPzzpNeqf2RQNQE7OA==
X-Received: by 2002:a17:906:4dd6:b0:7ad:a030:487e with SMTP id f22-20020a1709064dd600b007ada030487emr14892527ejw.508.1668529063454;
        Tue, 15 Nov 2022 08:17:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r7-20020aa7cfc7000000b004610899742asm6234653edy.13.2022.11.15.08.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 08:17:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4A90F7A6CDA; Tue, 15 Nov 2022 17:17:42 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
In-Reply-To: <20221115030210.3159213-6-sdf@google.com>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-6-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 15 Nov 2022 17:17:42 +0100
Message-ID: <87h6z0i449.fsf@toke.dk>
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

Stanislav Fomichev <sdf@google.com> writes:

> The goal is to enable end-to-end testing of the metadata
> for AF_XDP. Current rx_timestamp kfunc returns current
> time which should be enough to exercise this new functionality.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  drivers/net/veth.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 2a4592780141..c626580a2294 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -25,6 +25,7 @@
>  #include <linux/filter.h>
>  #include <linux/ptr_ring.h>
>  #include <linux/bpf_trace.h>
> +#include <linux/bpf_patch.h>
>  #include <linux/net_tstamp.h>
>  
>  #define DRV_NAME	"veth"
> @@ -1659,6 +1660,18 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>  	}
>  }
>  
> +static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
> +			      struct bpf_patch *patch)
> +{
> +	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> +		/* return true; */
> +		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
> +	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
> +		/* return ktime_get_mono_fast_ns(); */
> +		bpf_patch_append(patch, BPF_EMIT_CALL(ktime_get_mono_fast_ns));
> +	}
> +}

So these look reasonable enough, but would be good to see some examples
of kfunc implementations that don't just BPF_CALL to a kernel function
(with those helper wrappers we were discussing before).

-Toke

