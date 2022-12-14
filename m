Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921C164D3A3
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiLNXq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiLNXqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:46:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616E7B67
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671061568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=78LWSsIPJ1XVGL0zlNrTSoo4bL68pZNIsDEq2wZNj8A=;
        b=bRNqntr7d54F+Kajl0rClsCSM2ufcITtEuQFQUhDSI0+aXt2D7ct+G8Mo/eWDWxZ/JSbjN
        x0JXhdaIHG9c2M/RkRTJL66+1WO8M2/yZvv5M13aSVj0T0qpzoKvGaBErKCBr8j753J6HB
        nvxzJXJScSGtnbl7+t010qnK/H4ypos=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-601-Dn1_IGxlMmm-_GLmi4sHDg-1; Wed, 14 Dec 2022 18:46:07 -0500
X-MC-Unique: Dn1_IGxlMmm-_GLmi4sHDg-1
Received: by mail-ed1-f72.google.com with SMTP id y2-20020a056402440200b0047369d5e65cso319208eda.11
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:46:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=78LWSsIPJ1XVGL0zlNrTSoo4bL68pZNIsDEq2wZNj8A=;
        b=KhhL4yywmA4JsDqJUTXZ7tAZjAKa/uuhEUAnUB+XVyS5Zp0wD71/TelhPu5OC/z23b
         o1HYnZtfebvlQo8/McR0tgrM2ncae9v8TQ1hzkIrHap8k9MY169Jk2JUdT0SqmqtRmWi
         DBJfftq0hxfbq09+XY8J4+wxQOViOkqABfDluDi98UkqIhplBhGbSVyg9jZMl3Y46r9N
         4SjkbWYQjx6V/axJQ5PS6gjhZRrQrMO1h7a7Bskcr5HPgh9orwWMWJ5VTSMDqfcMqJPR
         13ArLqGQ37mEEBuLkV1Va1e6aFPBT5DBDW6KuDqKBxm+4n7cQtXXtHBdOI+ZySs48iuu
         c2sw==
X-Gm-Message-State: ANoB5pnuhojPbW7clHnUZYGqaDe5mnRzXDZqUmFoL4QNpbl+3z7Suhw9
        7HXzO/RgKM+4H8OgAswPHzDU5ftuhAUkT8QG24cGrbgKL1WSvvJxUm0xbRb4zj+33BbmS0hHOQI
        1ciahYnOX0Enwtomd
X-Received: by 2002:a17:906:2284:b0:7c0:4030:ae20 with SMTP id p4-20020a170906228400b007c04030ae20mr23372479eja.24.1671061565174;
        Wed, 14 Dec 2022 15:46:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6Kj2IAiZK6tBE55SMpMMy5/RbSQAJVRnIh9peLku4AtIQs4/zPgn0O75+ZteBEVeLMyv2/KQ==
X-Received: by 2002:a17:906:2284:b0:7c0:4030:ae20 with SMTP id p4-20020a170906228400b007c04030ae20mr23372449eja.24.1671061564314;
        Wed, 14 Dec 2022 15:46:04 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x22-20020a170906711600b007be3aa82543sm6461002ejj.35.2022.12.14.15.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:46:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1B59982F66F; Thu, 15 Dec 2022 00:46:02 +0100 (CET)
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
Subject: Re: [xdp-hints] [PATCH bpf-next v4 01/15] bpf: Document XDP RX
 metadata
In-Reply-To: <20221213023605.737383-2-sdf@google.com>
References: <20221213023605.737383-1-sdf@google.com>
 <20221213023605.737383-2-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 15 Dec 2022 00:46:02 +0100
Message-ID: <87tu1xeeh1.fsf@toke.dk>
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

> Document all current use-cases and assumptions.

Below is a set of slightly more constructive suggestions for how to edit
this so it's not confusing the metadata area description with the kfunc
list:

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
>  Documentation/bpf/xdp-rx-metadata.rst | 90 +++++++++++++++++++++++++++
>  1 file changed, 90 insertions(+)
>  create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
>
> diff --git a/Documentation/bpf/xdp-rx-metadata.rst b/Documentation/bpf/xdp-rx-metadata.rst
> new file mode 100644
> index 000000000000..498eae718275
> --- /dev/null
> +++ b/Documentation/bpf/xdp-rx-metadata.rst
> @@ -0,0 +1,90 @@
> +===============
> +XDP RX Metadata
> +===============
> +
> +XDP programs support creating and passing custom metadata via
> +``bpf_xdp_adjust_meta``. This metadata can be consumed by the following
> +entities:
> +
> +1. ``AF_XDP`` consumer.
> +2. Kernel core stack via ``XDP_PASS``.
> +3. Another device via ``bpf_redirect_map``.
> +4. Other BPF programs via ``bpf_tail_call``.

I'd replace the above with a short introduction, like:

"This document describes how an XDP program can access hardware metadata
related to a packet using a set of helper functions, and how it can pass
that metadata on to other consumers."

> +General Design
> +==============
> +
> +XDP has access to a set of kfuncs to manipulate the metadata. Every
> +device driver implements these kfuncs. The set of kfuncs is
> +declared in ``include/net/xdp.h`` via ``XDP_METADATA_KFUNC_xxx``.
> +
> +Currently, the following kfuncs are supported. In the future, as more
> +metadata is supported, this set will grow:
> +
> +- ``bpf_xdp_metadata_rx_timestamp_supported`` returns true/false to
> +  indicate whether the device supports RX timestamps
> +- ``bpf_xdp_metadata_rx_timestamp`` returns packet RX timestamp
> +- ``bpf_xdp_metadata_rx_hash_supported`` returns true/false to
> +  indicate whether the device supports RX hash
> +- ``bpf_xdp_metadata_rx_hash`` returns packet RX hash

Keep the above (with David's comments), then add a bit of extra text,
here:

"The XDP program can use these kfuncs to read the metadata into stack
variables for its own consumption. Or, to pass the metadata on to other
consumers, an XDP program can store it into the metadata area carried
ahead of the packet.

> +Within the XDP frame, the metadata layout is as follows::
> +
> +  +----------+-----------------+------+
> +  | headroom | custom metadata | data |
> +  +----------+-----------------+------+
> +             ^                 ^
> +             |                 |
> +   xdp_buff->data_meta   xdp_buff->data

Add:

"The XDP program can store individual metadata items into this data_meta
area in whichever format it chooses. Later consumers of the metadata
will have to agree on the format by some out of band contract (like for
the AF_XDP use case, see below)."

> +AF_XDP
> +======
> +
> +``AF_XDP`` use-case implies that there is a contract between the BPF program
> +that redirects XDP frames into the ``XSK`` and the final consumer.
> +Thus the BPF program manually allocates a fixed number of
> +bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
> +of kfuncs to populate it. User-space ``XSK`` consumer, looks
> +at ``xsk_umem__get_data() - METADATA_SIZE`` to locate its metadata.
> +
> +Here is the ``AF_XDP`` consumer layout (note missing ``data_meta`` pointer)::
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
> +into the kernel. The kernel creates ``skb`` out of the ``xdp_buff`` contents.
> +Currently, every driver has a custom kernel code to parse the descriptors and
> +populate ``skb`` metadata when doing this ``xdp_buff->skb`` conversion.

Add: ", and the XDP metadata is not used by the kernel when building
skbs. However, TC-BPF programs can access the XDP metadata area using
the data_meta pointer."

> +In the future, we'd like to support a case where XDP program can override
> +some of that metadata.

s/some of that metadata/some of the metadata used for building skbs/.

> +The plan of record is to make this path similar to ``bpf_redirect_map``
> +so the program can control which metadata is passed to the skb layer.

I'm not sure we are quite agreed on this part, just drop for now (it's
sorta covered by the above)?

> +bpf_redirect_map
> +================
> +
> +``bpf_redirect_map`` can redirect the frame to a different device.
> +In this case we don't know ahead of time whether that final consumer
> +will further redirect to an ``XSK`` or pass it to the kernel via ``XDP_PASS``.
> +Additionally, the final consumer doesn't have access to the original
> +hardware descriptor and can't access any of the original metadata.

Replace this paragraph with: "``bpf_redirect_map`` can redirect the
frame to a different device. Some devices (like virtual ethernet links)
support running a second XDP program after the redirect. However, the
final consumer doesn't have access to the original hardware descriptor
and can't access any of the original metadata. The same applies to XDP
programs installed into devmaps and cpumaps."

> +For this use-case, only custom metadata is currently supported. If
> +the frame is eventually passed to the kernel, the skb created from such
> +a frame won't have any skb metadata. The ``XSK`` consumer will only
> +have access to the custom metadata.

Reword as:

"This means that for redirected packets only custom metadata is
currently supported, which has to be prepared by the initial XDP program
before redirect. If +the frame is eventually passed to the kernel, the
skb created from such a frame won't have any hardware metadata populated
in its skb. And if such a packet is later redirected into an ``XSK``,
that will also only have access to the custom metadata."

> +bpf_tail_call
> +=============
> +
> +No special handling here. Tail-called program operates on the same context
> +as the original one.

Replace this with a statement that it is in fact *not* supported in tail
maps :)

-Toke

