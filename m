Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DD8694BAA
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjBMPvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjBMPvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:51:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971961A650
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 07:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676303459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=waKIkPjy2BjIb2453VodOnzMT6YoEk7RGddIfQ01TIQ=;
        b=X+jtXkhxqUU/9mZFfsZy7P4Hkn8LWgcG5eo2DkNS6VV0JTp+Wo/9oKIeJ+I3xQUovZhvGi
        AOGQUmyordTi9yVABa2IMXHG9gt3TsSh6uKvRY83VQws4m6c5PNsr3qU68n9PSDA0Qn0MH
        QObx62NsRHdE25f6utwkqHLG8ICxMIQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-vcj_7i6_OVm_UD7NfTsiXw-1; Mon, 13 Feb 2023 10:50:53 -0500
X-MC-Unique: vcj_7i6_OVm_UD7NfTsiXw-1
Received: by mail-ej1-f69.google.com with SMTP id l18-20020a1709067d5200b008af415fdd80so7295038ejp.21
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 07:50:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=waKIkPjy2BjIb2453VodOnzMT6YoEk7RGddIfQ01TIQ=;
        b=gQ8pCfACJfm2vYQxVKV94ZSupUvXuQjq3RtN/nwqYQxEBa097xUSK05GsZR/H5pTqI
         YmORnmg6YC7Tw+l2JAE3pdad0d135obmNRP0o5ooYzIe8PzjiFMPAes9stVywAt/EapU
         93BYkzcSaIHAxi6ai0raBEeMnjsX5dNA1XPWMZnqiu2U4tBRASqiJLy+6Fgp7NDHXjnV
         tzL6I/5f6h3Nve1uT3QekookbPTNjSbq4CwXKVw+1ABwXwfiJSmIV+HOKejx54DIWeGj
         irImIX317I6Y5eSrb2wT/b0TDXe5dhcWsyD8r3vyIC8SIjO1PAHmY2xYByF9Z+6V0Aor
         IS+w==
X-Gm-Message-State: AO0yUKV8morkYy82owh7ifb/3lN9ZNNLcN/+F/qmQPdGMdMG9DQhlVY9
        eM/ljKlYUDqapt8EJhUSVo1pLOZvPGMdKrPGTVJAY/RVkmuHKJrWAPztPiYKr2CsohTFi9ThmDj
        NUqK8Pon+LOTFmZ5h
X-Received: by 2002:a50:9f28:0:b0:4a1:e4fa:7db2 with SMTP id b37-20020a509f28000000b004a1e4fa7db2mr7631459edf.17.1676303450473;
        Mon, 13 Feb 2023 07:50:50 -0800 (PST)
X-Google-Smtp-Source: AK7set86Q7XS9flhhE5EKG0Hdzx2zkd1tOl6Im0F0NMP3L5JBU0A36n6ugozmT1ox0uV1s0cOm+vXg==
X-Received: by 2002:a50:9f28:0:b0:4a1:e4fa:7db2 with SMTP id b37-20020a509f28000000b004a1e4fa7db2mr7631429edf.17.1676303449961;
        Mon, 13 Feb 2023 07:50:49 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id w8-20020a50c448000000b0049668426aa6sm6804603edf.24.2023.02.13.07.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 07:50:49 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 699B4973FC2; Mon, 13 Feb 2023 16:33:56 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
In-Reply-To: <20230213142747.3225479-1-alexandr.lobakin@intel.com>
References: <20230213142747.3225479-1-alexandr.lobakin@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 13 Feb 2023 16:33:56 +0100
Message-ID: <87ilg5vau3.fsf@toke.dk>
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

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> &xdp_buff and &xdp_frame are bound in a way that
>
> xdp_buff->data_hard_start =3D=3D xdp_frame
>
> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
> this.
> IOW, the following:
>
> 	for (u32 i =3D 0; i < 0xdead; i++) {
> 		xdpf =3D xdp_convert_buff_to_frame(&xdp);
> 		xdp_convert_frame_to_buff(xdpf, &xdp);
> 	}
>
> shouldn't ever modify @xdpf's contents or the pointer itself.
> However, "live packet" code wrongly treats &xdp_frame as part of its
> context placed *before* the data_hard_start. With such flow,
> data_hard_start is sizeof(*xdpf) off to the right and no longer points
> to the XDP frame.
>
> Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
> places and praying that there are no more miscalcs left somewhere in the
> code, unionize ::frm with ::data in a flex array, so that both starts
> pointing to the actual data_hard_start and the XDP frame actually starts
> being a part of it, i.e. a part of the headroom, not the context.
> A nice side effect is that the maximum frame size for this mode gets
> increased by 40 bytes, as xdp_buff::frame_sz includes everything from
> data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
> info.
>
> Minor: align `&head->data` with how `head->frm` is assigned for
> consistency.
> Minor #2: rename 'frm' to 'frame' in &xdp_page_head while at it for
> clarity.
>
> (was found while testing XDP traffic generator on ice, which calls
>  xdp_convert_frame_to_buff() for each XDP frame)
>
> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN=
")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
> From v1[0]:
> - align `&head->data` with how `head->frm` is assigned for consistency
>   (Toke);
> - rename 'frm' to 'frame' in &xdp_page_head (Jakub);
> - no functional changes.
>
> [0]
> https://lore.kernel.org/bpf/20230209172827.874728-1-alexandr.lobakin@inte=
l.com

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

