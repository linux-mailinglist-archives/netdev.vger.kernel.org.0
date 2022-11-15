Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5BF62AF5C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 00:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiKOXV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 18:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKOXVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 18:21:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F5512ACD
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 15:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668554432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HB6zekTxMq+hKIhJy2TlN2K0Ppt1J67WxSLXwQ7+MSo=;
        b=G/YtmS1OU+19gPNFFLzCsU03C4FL2/2pSK82ioBLl4u6315TshDtb9RO4VHcv8n3ReCp9W
        JoA/thgMi0f2om4RzySGy3ubROAL8Y/ZDSjZq3xungGpJg0CSiNHXQAE5dsNZPGZ+nMN+V
        HrX0+VhC9jyAv6fIVciNAJcoVMrhrvg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-488-tMu8jG1JNU2S-1N1ca5BJA-1; Tue, 15 Nov 2022 18:20:30 -0500
X-MC-Unique: tMu8jG1JNU2S-1N1ca5BJA-1
Received: by mail-ed1-f72.google.com with SMTP id w17-20020a056402269100b00461e28a75ccso10955935edd.8
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 15:20:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HB6zekTxMq+hKIhJy2TlN2K0Ppt1J67WxSLXwQ7+MSo=;
        b=tQgeZJmtkaIeneMvVR/+G0a4CpY4kqhswfqp3dpIK2GqIZ2lthGyo8UUqRF+ZJLZqz
         yBYGG/n9r16OkkfGm0pqE0wSspeRMsdznbAzK/LqHCIXxt85VEC/EPK0OR0cTiffj3dd
         Y+cRI2Mo4Ld4FMLFsvXqqF6rK4LPW5Yj4ejgzI8SGCCjH6dNRNDbDLRDUwiPU3YYH3Ef
         6/2hrVwfjIP5FalWz/l2L/9pNZFWjPElVYkEG/PL4OLR6mHFUBSVxerRWee5CzV2t9z0
         /JQ5W1YALimAE6ePQyQ9VG6dsHhqDNaAZ+Eh7LFV0EjQxRZKvBnECMgufAbeKPFLkTMv
         6hCw==
X-Gm-Message-State: ANoB5pkgjYvs+KgAOCd8lnKYXUSCJLwbMaGYLv3HRauMOqEcgpxehtB1
        QGQIChdSpWHDRsuFFrz0m8wra0sht/jQyNbfimy6nNih3TAtZTpyYNiyRt/Rb2WLBxw9OpgAyOs
        nmNktDDjJXf6dd5PO
X-Received: by 2002:a17:907:20c2:b0:7ae:967a:50bb with SMTP id qq2-20020a17090720c200b007ae967a50bbmr15745799ejb.383.1668554428719;
        Tue, 15 Nov 2022 15:20:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5trZODpBQ09vRtNhMWv8QUfUjuwKz3UoAgxjob/GtLbJSfb4HKBIn/zGAtCHtmuzYW+aASyw==
X-Received: by 2002:a17:907:20c2:b0:7ae:967a:50bb with SMTP id qq2-20020a17090720c200b007ae967a50bbmr15745759ejb.383.1668554427864;
        Tue, 15 Nov 2022 15:20:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id n5-20020a05640204c500b00457c85bd890sm6741473edw.55.2022.11.15.15.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 15:20:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3718C7A6D70; Wed, 16 Nov 2022 00:20:26 +0100 (CET)
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
Subject: Re: [xdp-hints] [PATCH bpf-next 06/11] xdp: Carry over xdp metadata
 into skb context
In-Reply-To: <20221115030210.3159213-7-sdf@google.com>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-7-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Nov 2022 00:20:26 +0100
Message-ID: <87wn7vdcud.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b444b1118c4f..71e3bc7ad839 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6116,6 +6116,12 @@ enum xdp_action {
>  	XDP_REDIRECT,
>  };
>  
> +/* Subset of XDP metadata exported to skb context.
> + */
> +struct xdp_skb_metadata {
> +	__u64 rx_timestamp;
> +};

Okay, so given Alexei's comment about __randomize_struct not actually
working, I think we need to come up with something else for this. Just
sticking this in a regular UAPI header seems like a bad idea; we'd just
be inviting people to use it as-is.

Do we actually need the full definition here? It's just a pointer
declaration below, so is an opaque forward-definition enough? Then we
could have the full definition in an internal header, moving the full
definition back to being in vmlinux.h only?

-Toke

