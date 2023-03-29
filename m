Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015F66CF587
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 23:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjC2VrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 17:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjC2VrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 17:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C46840FE
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 14:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680126375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TLdrrjYrVuiWJorDb/815Wq1wAW83zbfu/IRhqAaimY=;
        b=iinkoUto8UFAExzvOpTklyVaDrWM56Z/lUuxmho02D4qt1juhtnMV+YG5OJXk9FFOvCCTf
        Dn1Ng/JUC1OTxwmUPUWAC1N0ZfXPQ5Z4QN+WvJHf2SBfkyg5kw9XVra83+FUN3n97HiNDG
        IarHIWw1GBkB8Gtu3IXWqjqqmZ1fWbU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-ASkrij5mOYOIxpjuVQYmeg-1; Wed, 29 Mar 2023 17:46:11 -0400
X-MC-Unique: ASkrij5mOYOIxpjuVQYmeg-1
Received: by mail-ed1-f70.google.com with SMTP id p36-20020a056402502400b004bb926a3d54so23978967eda.2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 14:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680126370;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TLdrrjYrVuiWJorDb/815Wq1wAW83zbfu/IRhqAaimY=;
        b=RMSBShDgd8U9qJ536pI/qkM8aSLem3IghEPIpTJGsu8OzCSnx2JUPLEhg7x6AqPBkm
         +eRcpG1iDesC8mFeoocW7Ro2KILtJPG6TMrwhckDsCvfKcKGZ4VJOLnc0WU+JUesmLNF
         8ox2DMsla745A0kD3rVV9I+n6hZkwad8GOh/s44FoA4gz3hQreQvw3vSqNkGDY4hiTqp
         /9hmvRVxdfg77pwHQp86Swh+5IqEtxlVVNpucpJlDNaIGc5hMe19joy/FFfRuc+zu9ek
         rzfbB2k2cSUZfgTWrejWMkXxRbdBbl3jtnkxdJAxk4ihhyTUQqosiBpE/18Op1xlu7pA
         WZnA==
X-Gm-Message-State: AAQBX9cd2Fe8K3bU0q096DHuUGccRDL1qIDGMqLaUVqlH1No8RrLoV4n
        X7cLgAlePktSkoJOP+4Wx2KUNCt8mtoKaHvA5sjcxZErpfn86YBUQkioEfejzl4aRDl3VbYV6sz
        I26KRDvqrPbvZMYQC/3uzw4Ds
X-Received: by 2002:a17:907:7f86:b0:926:9c33:ea4 with SMTP id qk6-20020a1709077f8600b009269c330ea4mr23062343ejc.27.1680126370362;
        Wed, 29 Mar 2023 14:46:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZGQUYQJeTXwnRV15le8g2e5F6QxBAZ5bivkYpLnhuEBXno6vpJg9RQt0C5heMRA6NQh8z/2A==
X-Received: by 2002:a17:907:7f86:b0:926:9c33:ea4 with SMTP id qk6-20020a1709077f8600b009269c330ea4mr23062308ejc.27.1680126369951;
        Wed, 29 Mar 2023 14:46:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z26-20020a17090674da00b009310d4dece9sm16869157ejl.62.2023.03.29.14.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:46:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 974C8A22B54; Wed, 29 Mar 2023 23:46:08 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Subject: Re: [xdp-hints] [PATCH bpf RFC-V2 1/5] xdp: rss hash types
 representation
In-Reply-To: <168010734324.3039990.16454026957159811204.stgit@firesoul>
References: <168010726310.3039990.2753040700813178259.stgit@firesoul>
 <168010734324.3039990.16454026957159811204.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 29 Mar 2023 23:46:08 +0200
Message-ID: <87355nnsdb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 7133017bcd74..81d41df30695 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -721,12 +721,14 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
>   * @hash: Return value pointer.
>   *
>   * Return:
> - * * Returns 0 on success or ``-errno`` on error.
> + * * Returns (positive) RSS hash **type** on success or ``-errno`` on error.

This change is going to break any BPF program that does:

if (!bpf_xdp_metadata_rx_hash(ctx, &hash))
  /* do something with hash */


so I think adding a second argument is better; that way, at least
breakage will be explicit instead of being a hidden change in semantics
(and the CO-RE style checking for kfuncs Alexei introduced should
trigger correctly).

But really, what we should do anyway is merge this during the -rc phase
to minimise any breakage :)

-Toke

