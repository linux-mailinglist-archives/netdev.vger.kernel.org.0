Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83943638F63
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 18:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKYRyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 12:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiKYRyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 12:54:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0156155CA9
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 09:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669398792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UxymgvoRb75YnJ81c1gkcFnYTyArrxEPhdaiOtE1h3M=;
        b=GlrxIzrzGZEYbHo5FlKhLv6Wmnwa1q1Zc1ODfTKHNqb7zwoJtsGBbjUKvdzwPChRTxHsYK
        9pSHni8w1Et22orCaZzT0k20mkR1vPXEgWtbk4wGHOkAuhtzzu7ezXejwu42IphgX0JRp1
        iUlmv1PcwBaNnJw/jf2ik8SrByP0ka0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-BfjFq4lBOO6rWQMlJOZ5zA-1; Fri, 25 Nov 2022 12:53:10 -0500
X-MC-Unique: BfjFq4lBOO6rWQMlJOZ5zA-1
Received: by mail-ej1-f70.google.com with SMTP id dn14-20020a17090794ce00b007ae5d040ca8so2523448ejc.17
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 09:53:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UxymgvoRb75YnJ81c1gkcFnYTyArrxEPhdaiOtE1h3M=;
        b=ZxVOTCYed90ALUOgMYgHkceevqAcCzpAFbDLKc0iB4yn3xInToqDWdxGUdKb4gz2Cq
         tI9KYQjs1mooxW8CLDHZPP3ahLZJFUYn2y4ikR0kJJYNiditfLh/eTq7EhElgnuJK2E4
         3baNWVAtAHwumdk/EpOtTWacU6F9H7G4QrCrvDdfDzRZoUQ0hFETCKEjZGP9Lu3f2EGB
         r8DYJ/BLU6ji+/hy4iz0scnhM23YIDERYx3BnKSHqOnUWspe28mGO3w3egewhVjVatB3
         awTiyQUtL4b7dUaUk3Jo2v9YYW4iNkmSPW7SlAzx65OaWKAv40cd5F6Y02xDIurEpzrh
         Hb0A==
X-Gm-Message-State: ANoB5pnsq5bgDfJwX5g9rT4ukqsXcBb64VkB9nyMczzV5QJ5WbEM2rFv
        ekpQZvqoHRmNJ9TrNi+qNYyGx6Z5ADx8zkg5hsv1GAgAtOj5VjoMKzQ34sA80FIUKwIFMaMLR4m
        eQDUQygONGIz9RYwC
X-Received: by 2002:a05:6402:5406:b0:467:4b3d:f2ed with SMTP id ev6-20020a056402540600b004674b3df2edmr19275531edb.101.1669398787603;
        Fri, 25 Nov 2022 09:53:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5R8pWavkI3tbvmohJtTsOG5ZrCTcOHNS6Z8g5HUL9eMSaRf2lfX9ce0BuGT57XtBntrtFBSA==
X-Received: by 2002:a05:6402:5406:b0:467:4b3d:f2ed with SMTP id ev6-20020a056402540600b004674b3df2edmr19275310edb.101.1669398784850;
        Fri, 25 Nov 2022 09:53:04 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e22-20020a50ec96000000b00461aca1c7b6sm2027996edr.6.2022.11.25.09.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 09:53:04 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2D30B7EB86B; Fri, 25 Nov 2022 18:53:02 +0100 (CET)
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
Subject: Re: [xdp-hints] [PATCH bpf-next v2 2/8] bpf: XDP metadata RX kfuncs
In-Reply-To: <20221121182552.2152891-3-sdf@google.com>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-3-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 25 Nov 2022 18:53:02 +0100
Message-ID: <87mt8e2a69.fsf@toke.dk>
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

> There is an ndo handler per kfunc, the verifier replaces a call to the
> generic kfunc with a call to the per-device one.
>
> For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
> implements all possible metatada kfuncs. Not all devices have to
> implement them. If kfunc is not supported by the target device,
> the default implementation is called instead.

BTW, this "the default implementation is called instead" bit is not
included in this version... :)

[...]

> +#ifdef CONFIG_DEBUG_INFO_BTF
> +BTF_SET8_START(xdp_metadata_kfunc_ids)
> +#define XDP_METADATA_KFUNC(name, str) BTF_ID_FLAGS(func, str, 0)
> +XDP_METADATA_KFUNC_xxx
> +#undef XDP_METADATA_KFUNC
> +BTF_SET8_END(xdp_metadata_kfunc_ids)
> +
> +static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
> +	.owner = THIS_MODULE,
> +	.set   = &xdp_metadata_kfunc_ids,
> +};
> +
> +u32 xdp_metadata_kfunc_id(int id)
> +{
> +	return xdp_metadata_kfunc_ids.pairs[id].id;
> +}
> +EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);

So I was getting some really weird values when testing (always getting a
timestamp value of '1'), and it turns out to be because this way of
looking up the ID doesn't work: The set is always sorted by the BTF ID,
not the order it was defined. Which meant that the mapping code got the
functions mixed up, and would call a different one instead (so the
timestamp value I was getting was really the return value of
rx_hash_enabled()).

I fixed it by building a secondary lookup table as below; feel free to
incorporate that (or if you can come up with a better way, go ahead!).

-Toke

diff --git a/net/core/xdp.c b/net/core/xdp.c
index e43f7d4ef4cf..dc0a9644dacc 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -738,6 +738,15 @@ XDP_METADATA_KFUNC_xxx
 #undef XDP_METADATA_KFUNC
 BTF_SET8_END(xdp_metadata_kfunc_ids)
 
+static struct xdp_metadata_kfunc_map {
+       const char *fname;
+       u32 btf_id;
+} xdp_metadata_kfunc_lookup_map[MAX_XDP_METADATA_KFUNC] = {
+#define XDP_METADATA_KFUNC(name, str) { .fname = __stringify(str) },
+XDP_METADATA_KFUNC_xxx
+#undef XDP_METADATA_KFUNC
+};
+
 static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
        .owner = THIS_MODULE,
        .set   = &xdp_metadata_kfunc_ids,
@@ -745,13 +754,41 @@ static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
 
 u32 xdp_metadata_kfunc_id(int id)
 {
-       return xdp_metadata_kfunc_ids.pairs[id].id;
+       return xdp_metadata_kfunc_lookup_map[id].btf_id;
 }
 EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);
 
 static int __init xdp_metadata_init(void)
 {
-       return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
+       const struct btf *btf;
+       int i, j, ret;
+
+       ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
+       if (ret)
+               return ret;
+
+       btf = bpf_get_btf_vmlinux();
+
+       for (i = 0; i < MAX_XDP_METADATA_KFUNC; i++) {
+               u32 btf_id = xdp_metadata_kfunc_ids.pairs[i].id;
+               const struct btf_type *t;
+               const char *name;
+
+               t = btf_type_by_id(btf, btf_id);
+               if (WARN_ON_ONCE(!t || !t->name_off))
+                       continue;
+
+               name = btf_name_by_offset(btf, t->name_off);
+
+               for (j = 0; j < MAX_XDP_METADATA_KFUNC; j++) {
+                       if (!strcmp(name, xdp_metadata_kfunc_lookup_map[j].fname)) {
+                               xdp_metadata_kfunc_lookup_map[j].btf_id = btf_id;
+                               break;
+                       }
+               }
+       }
+
+       return 0;
 }
 late_initcall(xdp_metadata_init);
 #else /* CONFIG_DEBUG_INFO_BTF */

