Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37B56361B6
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbiKWO1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236380AbiKWO0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:26:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72FF8FE47
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669213468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+HXGpPooIMe6sNdUgSAzfW/8NtY/urg9PVU34CjlakY=;
        b=OBORLP989/dOAQ6smlajHowVC8lvpRL6wjZKpCCksfRLrFIUIX/YvR0/phep7PUmWv/GMd
        vXwEpbY7XRbcCtLICuYVMTvxk2DtmQXCdT5Ek8hQ7kT7p/icUVj2kD5L6kKu8YpN55WfzS
        n9muon6N1tamd7zD1WADJVsMA0ohv00=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-99-3SX68_FTPKOyntkq9caVxQ-1; Wed, 23 Nov 2022 09:24:26 -0500
X-MC-Unique: 3SX68_FTPKOyntkq9caVxQ-1
Received: by mail-ej1-f71.google.com with SMTP id jg27-20020a170907971b00b007ad9892f5f6so9993916ejc.7
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:24:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+HXGpPooIMe6sNdUgSAzfW/8NtY/urg9PVU34CjlakY=;
        b=ZIT3i5grooz2nHoO5WtC/O41S7pZs+WcChWVCuLOk1ORThFJstLab/NtyHTgmdlu1l
         Cs0PMFLwLmpm3MhKaM6CJysEfGeoHL9ujOnzLDNGHylzUbzhDEMAfAya6QH813gNUt36
         z3ZBbu2YjhhGA2+XoNmVFzCWeqpuToKv0jRlyVGTgWXyooZh7mHRCrv8xAwDxwDQRW7p
         MYt2KrmYXl5YirsutKebYnUEk27mA0PeEDz/OnsLUleL1Q8pwtTwgbgiypY3d8rcZH6R
         6TL6mKU25gzKOjbNS05WPN5Nq41OkCRLJYcZcbW8N+KO6MTCDrfG9LHPTnGl31mQiUin
         GqMA==
X-Gm-Message-State: ANoB5pl1d41aBG3trZTZM9eAtQOD1/Kt8/dBW/mXvw6eMS3b8RzcpD4a
        oXLOIB9bD6TGVF1tFiPEEao5dXxwI4E9aBeznaXeYU1SP4FQzZ4MxauyHSBbY5mmntGMT0RyisI
        WMU3576StXwWZMVkJ
X-Received: by 2002:a17:906:b749:b0:7b6:6e0a:17dd with SMTP id fx9-20020a170906b74900b007b66e0a17ddmr8326449ejb.590.1669213465279;
        Wed, 23 Nov 2022 06:24:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4TlTtotUdHzjVrM8lE5ZJ5PpqfjRzrePg1TyOkbZEtVq8E4QPMbh+AfzYYZrhKKTyMbjQLbQ==
X-Received: by 2002:a17:906:b749:b0:7b6:6e0a:17dd with SMTP id fx9-20020a170906b74900b007b66e0a17ddmr8326415ejb.590.1669213464920;
        Wed, 23 Nov 2022 06:24:24 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ee47-20020a056402292f00b00468f7bb4895sm7369868edb.43.2022.11.23.06.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:24:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 81EF07D5114; Wed, 23 Nov 2022 15:24:23 +0100 (CET)
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
Date:   Wed, 23 Nov 2022 15:24:23 +0100
Message-ID: <87a64hvje0.fsf@toke.dk>
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

>  static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  			    struct bpf_insn *insn_buf, int insn_idx, int *cnt)
>  {
> @@ -15181,6 +15200,15 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  		return -EINVAL;
>  	}
>  
> +	if (resolve_prog_type(env->prog) == BPF_PROG_TYPE_XDP) {
> +		int imm = fixup_xdp_kfunc_call(env, insn->imm);
> +
> +		if (imm) {
> +			insn->imm = imm;
> +			return 0;

This needs to also set *cnt = 0 before returning; otherwise the verifier
can do some really weird instruction rewriting that leads to the JIT
barfing on invalid instructions (as I just found out while trying to
test this).

-Toke

