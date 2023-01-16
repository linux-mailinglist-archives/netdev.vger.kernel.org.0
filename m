Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E9866BF47
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjAPNOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbjAPNNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:13:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A0F21A3C
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673874594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jc4OJeoBzIgA4pINC3NorQcQX/ENG9cQlOJuRsKHw4A=;
        b=CVS7MhlrjleisjfnUtimehuER2SJZqVYH4sfkKKZ6AjAUhh8QybT0nIMzBH0M3lEpP3W+B
        V1AzvlA1pB0oWj65cPPkq64M9/kTjh0zvMLPsvSq7DXJwxJZQYIyeVauCvvOqLm8g07Hco
        1hDncqtd5PHwjDfjxLIEbo53cxmhsN4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-66-Vg9VL1kWN--6myDwecWzkA-1; Mon, 16 Jan 2023 08:09:53 -0500
X-MC-Unique: Vg9VL1kWN--6myDwecWzkA-1
Received: by mail-ej1-f72.google.com with SMTP id sb39-20020a1709076da700b0086b1cfb06f0so5516694ejc.4
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:09:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jc4OJeoBzIgA4pINC3NorQcQX/ENG9cQlOJuRsKHw4A=;
        b=1ASW1TiGhWpoiZTbqilnusKd6NTWhXSm8GLGO9Ge3kgBOS2CHTqJUP027NatN8bxu7
         rPYElTR81sGCRuMR5DLxMrYdnY0HqNCLOT8ecv3+tU5a7L13VbteG5iZ7nSFb0XDOww9
         ktUMVfYZprOklmZyJQcKHD9FBTOYNiwJzWsJKVN0+3YmpHDexDOswNezFH2Y2OpAs/v/
         NegwvCnLbdVJrKbUODKdrNm1GPLeyaB4LZL/aK98uzrmoDfNAPeCfJTBT5nLXmHqLpa7
         rRgU/J+ABcdPgDkz6uRXEV7E/PYqOkXGhP/+P0eccWctQiSpZhg26oOES6E8e1d4Hkzf
         N1qQ==
X-Gm-Message-State: AFqh2kpz2iUoyelXADGIS/UeK/xCXzQm+lXqH1YBcZP30JzSrnzNwbcz
        DyTmYyr//1q8t4lffMtexy1M2owdkX+F/ZK8SCB3KBHGgv1Msksrxg/l/lgBzILdZgb2dyQpKKe
        sB8vq54e2ZVtPPmAc
X-Received: by 2002:a05:6402:d71:b0:498:5cfe:da81 with SMTP id ec49-20020a0564020d7100b004985cfeda81mr33319393edb.3.1673874592277;
        Mon, 16 Jan 2023 05:09:52 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv2K1R7SKjG8Ag4i9+ZhuIVH/paecDngj97ILQwmPZLuLLhNRnEVSY1o3G3I7DvFi/2QD8zZw==
X-Received: by 2002:a05:6402:d71:b0:498:5cfe:da81 with SMTP id ec49-20020a0564020d7100b004985cfeda81mr33319375edb.3.1673874592051;
        Mon, 16 Jan 2023 05:09:52 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090676d200b00857c2c29553sm7510010ejn.197.2023.01.16.05.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 05:09:51 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <affeb1e3-69e6-9783-0012-6d917972ba30@redhat.com>
Date:   Mon, 16 Jan 2023 14:09:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, David Vernet <void@manifault.com>
Subject: Re: [PATCH bpf-next v7 01/17] bpf: Document XDP RX metadata
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
References: <20230112003230.3779451-1-sdf@google.com>
 <20230112003230.3779451-2-sdf@google.com>
In-Reply-To: <20230112003230.3779451-2-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/01/2023 01.32, Stanislav Fomichev wrote:
> Document all current use-cases and assumptions.
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
> Acked-by: David Vernet <void@manifault.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   Documentation/networking/index.rst           |   1 +
>   Documentation/networking/xdp-rx-metadata.rst | 108 +++++++++++++++++++
>   2 files changed, 109 insertions(+)
>   create mode 100644 Documentation/networking/xdp-rx-metadata.rst
> 
> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> index 4f2d1f682a18..4ddcae33c336 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -120,6 +120,7 @@ Refer to :ref:`netdev-FAQ` for a guide on netdev development process specifics.
>      xfrm_proc
>      xfrm_sync
>      xfrm_sysctl
> +   xdp-rx-metadata
>   
>   .. only::  subproject and html
>   
> diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
> new file mode 100644
> index 000000000000..b6c8c77937c4
> --- /dev/null
> +++ b/Documentation/networking/xdp-rx-metadata.rst
> @@ -0,0 +1,108 @@
> +===============
> +XDP RX Metadata
> +===============
> +
> +This document describes how an eXpress Data Path (XDP) program can access
> +hardware metadata related to a packet using a set of helper functions,
> +and how it can pass that metadata on to other consumers.
> +
> +General Design
> +==============
> +
> +XDP has access to a set of kfuncs to manipulate the metadata in an XDP frame.
> +Every device driver that wishes to expose additional packet metadata can
> +implement these kfuncs. The set of kfuncs is declared in ``include/net/xdp.h``
> +via ``XDP_METADATA_KFUNC_xxx``.
> +
> +Currently, the following kfuncs are supported. In the future, as more
> +metadata is supported, this set will grow:
> +
> +.. kernel-doc:: net/core/xdp.c
> +   :identifiers: bpf_xdp_metadata_rx_timestamp bpf_xdp_metadata_rx_hash
> +
> +An XDP program can use these kfuncs to read the metadata into stack
> +variables for its own consumption. Or, to pass the metadata on to other
> +consumers, an XDP program can store it into the metadata area carried
> +ahead of the packet.
> +
> +Not all kfuncs have to be implemented by the device driver; when not
> +implemented, the default ones that return ``-EOPNOTSUPP`` will be used.
> +
> +Within an XDP frame, the metadata layout is as follows::

Below diagram describes XDP buff (xdp_buff), but text says 'XDP frame'.
So XDP frame isn't referring literally to xdp_frame, which I find 
slightly confusing.
It is likely because I think too much about the code and the different 
objects, xdp_frame, xdp_buff, xdp_md (xdp ctx seen be bpf-prog).

I tried to grep in the (recent added) bpf/xdp docs to see if there is a
definition of a XDP "packet" or "frame".  Nothing popped up, except that
Documentation/bpf/map_cpumap.rst talks about raw ``xdp_frame`` objects.

Perhaps we can improve this doc by calling out xdp_buff here, like:

  Within an XDP frame, the metadata layout (accessed via ``xdp_buff``) 
is as follows::

> +
> +  +----------+-----------------+------+
> +  | headroom | custom metadata | data |
> +  +----------+-----------------+------+
> +             ^                 ^
> +             |                 |
> +   xdp_buff->data_meta   xdp_buff->data
> +
> +An XDP program can store individual metadata items into this ``data_meta``
> +area in whichever format it chooses. Later consumers of the metadata
> +will have to agree on the format by some out of band contract (like for
> +the AF_XDP use case, see below).
> +
> +AF_XDP
> +======
> +
> +:doc:`af_xdp` use-case implies that there is a contract between the BPF
> +program that redirects XDP frames into the ``AF_XDP`` socket (``XSK``) and
> +the final consumer. Thus the BPF program manually allocates a fixed number of
> +bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
> +of kfuncs to populate it. The userspace ``XSK`` consumer computes
> +``xsk_umem__get_data() - METADATA_SIZE`` to locate that metadata.
> +Note, ``xsk_umem__get_data`` is defined in ``libxdp`` and
> +``METADATA_SIZE`` is an application-specific constant.

The main problem with AF_XDP and metadata is that, the AF_XDP descriptor
doesn't contain any info about the length METADATA_SIZE.

The text does says this, but in a very convoluted way.
I think this challenge should be more clearly spelled out.

(p.s. This was something that XDP-hints via BTF have a proposed solution 
for)

> +
> +Here is the ``AF_XDP`` consumer layout (note missing ``data_meta`` pointer)::

The "note" also hint to this issue.

> +
> +  +----------+-----------------+------+
> +  | headroom | custom metadata | data |
> +  +----------+-----------------+------+
> +                               ^
> +                               |
> +                        rx_desc->address
> +
> +XDP_PASS
> +========
> +
> +This is the path where the packets processed by the XDP program are passed
> +into the kernel. The kernel creates the ``skb`` out of the ``xdp_buff``
> +contents. Currently, every driver has custom kernel code to parse
> +the descriptors and populate ``skb`` metadata when doing this ``xdp_buff->skb``
> +conversion, and the XDP metadata is not used by the kernel when building
> +``skbs``. However, TC-BPF programs can access the XDP metadata area using
> +the ``data_meta`` pointer.
> +
> +In the future, we'd like to support a case where an XDP program
> +can override some of the metadata used for building ``skbs``.

Happy this is mentioned as future work.

> +
> +bpf_redirect_map
> +================
> +
> +``bpf_redirect_map`` can redirect the frame to a different device.
> +Some devices (like virtual ethernet links) support running a second XDP
> +program after the redirect. However, the final consumer doesn't have
> +access to the original hardware descriptor and can't access any of
> +the original metadata. The same applies to XDP programs installed
> +into devmaps and cpumaps.
> +
> +This means that for redirected packets only custom metadata is
> +currently supported, which has to be prepared by the initial XDP program
> +before redirect. If the frame is eventually passed to the kernel, the
> +``skb`` created from such a frame won't have any hardware metadata populated
> +in its ``skb``. If such a packet is later redirected into an ``XSK``,
> +that will also only have access to the custom metadata.
> +

Good that this is documented, but I hope we can fix/improve this as
future work.

> +bpf_tail_call
> +=============
> +
> +Adding programs that access metadata kfuncs to the ``BPF_MAP_TYPE_PROG_ARRAY``
> +is currently not supported.
> +
> +Example
> +=======
> +
> +See ``tools/testing/selftests/bpf/progs/xdp_metadata.c`` and
> +``tools/testing/selftests/bpf/prog_tests/xdp_metadata.c`` for an example of
> +BPF program that handles XDP metadata.


--Jesper

