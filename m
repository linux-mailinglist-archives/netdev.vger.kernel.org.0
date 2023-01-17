Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EF366DC0F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbjAQLPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236824AbjAQLOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:14:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B88A2BF09
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673954013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vVeaTGASPv1kGBiW2cadKKQWQOpTUI7wfN8iiDBz0BA=;
        b=O+ck+DY3SXlWOlOX5mxlNHJ1E6ywHRGddpjfhInmC/vnDBVhQwtaD8Tq3I8BVsvd/rDg8n
        zx/arQgkpsWUF220iog6FS5Pa8Xw49XzUl2xDYR1dPAdQmryiF9EUWc5Efn7gEINu7YYh6
        0OVdy1V8rx9vx2SQIfYnkGddpMqcVZs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-437-cwwqgmozNQG8U1ChQEJ03A-1; Tue, 17 Jan 2023 06:13:32 -0500
X-MC-Unique: cwwqgmozNQG8U1ChQEJ03A-1
Received: by mail-ed1-f69.google.com with SMTP id r14-20020a05640251ce00b0047d67ab2019so20973757edd.12
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:13:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vVeaTGASPv1kGBiW2cadKKQWQOpTUI7wfN8iiDBz0BA=;
        b=UlJp+dn4hI8q1p38nWrslHfZ1dkEFN5tpZ8tP1gXxw9/b4bJ3L+bHNzb0yK9JQQNho
         ujFm69wq2mf+mKsvTVibtutODepsRvVr0laZ3sbeKhZJPMsxrVvuZeoVwI6elaqRztUx
         Icu7gvwB7KsdTpS3QMlVQRqDwL+vDdyIgJ1bp6c3EC3QaVJfoYavmtcSQJWr6horTwpA
         y57Y2yoo12htUoIBAOBKfmI8JoBcbojk0E+kORaFESacTQ+zIl/As2Jvs5+AuamDB3QN
         qrbxL+VzIakkNbPizNWTuZtqN67AE31/0ayMYOz3qRbGvCEXqwOt5Nyojo8UgwsE5mx4
         AN7g==
X-Gm-Message-State: AFqh2krW3q2xW46BRRFdp0gfXcZGl1YHEuiggZF2uEx2z/nLkY29sZzc
        FR+3lNws791V1amddshuSdcC38qBE1AiGrnHLNBqZ/p0FD7HjmJnQ00868vRuqNuVvC9b/Lfox3
        WZTb3txl/+DJT1VF7
X-Received: by 2002:a17:907:a710:b0:7c0:f71b:8b3 with SMTP id vw16-20020a170907a71000b007c0f71b08b3mr2466713ejc.57.1673954011075;
        Tue, 17 Jan 2023 03:13:31 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtPZDixG9TLpun/SMNQnX17ICdLTjoy+jxl4m2jO1TWNjWpvZPz4AV1mc28x6gsOj1074jdtg==
X-Received: by 2002:a17:907:a710:b0:7c0:f71b:8b3 with SMTP id vw16-20020a170907a71000b007c0f71b08b3mr2466686ejc.57.1673954010746;
        Tue, 17 Jan 2023 03:13:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y19-20020a1709060a9300b0084debc351b3sm9763012ejf.20.2023.01.17.03.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 03:13:30 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B26F39010E0; Tue, 17 Jan 2023 12:13:29 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com, ioana.ciornei@nxp.com,
        madalin.bucur@nxp.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net 0/5] net: xdp: execute xdp_do_flush() before
 napi_complete_done()
In-Reply-To: <20230117092533.5804-1-magnus.karlsson@gmail.com>
References: <20230117092533.5804-1-magnus.karlsson@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 17 Jan 2023 12:13:29 +0100
Message-ID: <87lem1ct2e.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> Make sure that xdp_do_flush() is always executed before
> napi_complete_done(). This is important for two reasons. First, a
> redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
> napi context X on CPU Y will be follwed by a xdp_do_flush() from the

Typo in 'followed' here (and in all the copy-pasted commit messages).

> same napi context and CPU. This is not guaranteed if the
> napi_complete_done() is executed before xdp_do_flush(), as it tells
> the napi logic that it is fine to schedule napi context X on another
> CPU. Details from a production system triggering this bug using the
> veth driver can be found in [1].
>
> The second reason is that the XDP_REDIRECT logic in itself relies on
> being inside a single NAPI instance through to the xdp_do_flush() call
> for RCU protection of all in-kernel data structures. Details can be
> found in [2].
>
> The drivers have only been compile-tested since I do not own any of
> the HW below. So if you are a manintainer, please make sure I did not

And another typo in 'maintainer' here.

> mess something up. This is a lousy excuse for virtio-net though, but
> it should be much simpler for the vitio-net maintainers to test this,
> than me trying to find test cases, validation suites, instantiating a
> good setup, etc. Michael and Jason can likely do this in minutes.
>
> Note that these were the drivers I found that violated the ordering by
> running a simple script and manually checking the ones that came up as
> potential offenders. But the script was not perfect in any way. There
> might still be offenders out there, since the script can generate
> false negatives.
>
> [1] https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare=
.com
> [2] https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/

Otherwise LGTM!

For the series:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

