Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D974B4D2D2B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 11:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiCIKgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 05:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiCIKgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 05:36:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34EABEA34C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 02:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646822117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=92tkil4B/YfMjsRlwMuANtc0Vrgq6z66WglTSkkwlNA=;
        b=OtAHwAOoLqNwbQ7yQBXKYmF/bH9ncCmQXrrkP8okVnQWzuCq4+1b7IfkqNZvkL8XSHDMNL
        gG+zwWKS0+GXWUJ3sOHY2rvZ6RrPzvm2vlDNymy/DNRBwMPaCxtmu6gQrFvVeG48IirSl3
        KAfeHhgAPIqkDTbE64fXz0sM+rluzzo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-SyOOxvSHPAmPA-9z1Q9T1Q-1; Wed, 09 Mar 2022 05:35:16 -0500
X-MC-Unique: SyOOxvSHPAmPA-9z1Q9T1Q-1
Received: by mail-ed1-f71.google.com with SMTP id co2-20020a0564020c0200b00415f9fa6ca8so1061895edb.6
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 02:35:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=92tkil4B/YfMjsRlwMuANtc0Vrgq6z66WglTSkkwlNA=;
        b=za2YDij3Oy1sVVXr31lQu1VoS39Pz6JCOtJ8C5FjNlH4ibl1RQUAKg66sDCXo5WhsQ
         uZ0FVvZ1sveK1jX6qJ9Np/QpLBM0F/qju2n/jtfzDqbDJhK96XlDSj59KgeSq4z7Ezm1
         0FNp1j3FLA7EfDKzA2sjzqbezAP9168Z04np2FF3E5UzQzF+1KZQvDqo9zdz1zbYvOvl
         i3zxcXGv+OoI38ADT5a3onHCXACsYjHFHi38zbFEtT96uvoFkTb2GO1p1+VOigvIufRZ
         rIEG4wq4/61OlvFzWfpkwcyINceuj974m4WfXrpTmHpzG4wNE0i+dtlgIjpVzsWLlvG/
         xwMA==
X-Gm-Message-State: AOAM532xENnG9U3TZVlaEDpX141iM7iIswVe/zLwlkJe7fsReJZdnISZ
        dnGdI9TEjpRuOQTIfvua5GMazQnJA0LATA+IB55HoilkseVxCFsH4aV0XLbxyEZKFZflrWC2nbr
        tmbzSznvRSLe6q/dY
X-Received: by 2002:a17:906:b50:b0:6d6:e503:131c with SMTP id v16-20020a1709060b5000b006d6e503131cmr16974944ejg.597.1646822114619;
        Wed, 09 Mar 2022 02:35:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwAPWJSjo0iYiBtPlfXi30N80hLtsRGajYqQqdLwzPHV7Uo+j8kWTXXkYw1BdTVNR4RbtXXtA==
X-Received: by 2002:a17:906:b50:b0:6d6:e503:131c with SMTP id v16-20020a1709060b5000b006d6e503131cmr16974912ejg.597.1646822114188;
        Wed, 09 Mar 2022 02:35:14 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id fy1-20020a1709069f0100b006d229ed7f30sm570156ejc.39.2022.03.09.02.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 02:35:13 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ECC3E192A9F; Wed,  9 Mar 2022 11:35:12 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 1/5] bpf: Add "live packet" mode for XDP in
 BPF_PROG_RUN
In-Reply-To: <20220309061018.wn5tddiguywdeyra@kafai-mbp.dhcp.thefacebook.com>
References: <20220308145801.46256-1-toke@redhat.com>
 <20220308145801.46256-2-toke@redhat.com>
 <20220309061018.wn5tddiguywdeyra@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 09 Mar 2022 11:35:12 +0100
Message-ID: <87h787wh0f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Tue, Mar 08, 2022 at 03:57:57PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> +static int xdp_test_run_batch(struct xdp_test_data *xdp, struct bpf_pro=
g *prog,
>> +			      u32 repeat)
>> +{
>> +	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
>> +	int err =3D 0, act, ret, i, nframes =3D 0, batch_sz;
>> +	struct xdp_frame **frames =3D xdp->frames;
>> +	struct xdp_page_head *head;
>> +	struct xdp_frame *frm;
>> +	bool redirect =3D false;
>> +	struct xdp_buff *ctx;
>> +	struct page *page;
>> +
>> +	batch_sz =3D min_t(u32, repeat, xdp->batch_size);
>> +
>> +	local_bh_disable();
>> +	xdp_set_return_frame_no_direct();
>> +
>> +	for (i =3D 0; i < batch_sz; i++) {
>> +		page =3D page_pool_dev_alloc_pages(xdp->pp);
>> +		if (!page) {
>> +			err =3D -ENOMEM;
>> +			goto out;
>> +		}
>> +
>> +		head =3D phys_to_virt(page_to_phys(page));
>> +		reset_ctx(head);
>> +		ctx =3D &head->ctx;
>> +		frm =3D &head->frm;
>> +		xdp->frame_cnt++;
>> +
>> +		act =3D bpf_prog_run_xdp(prog, ctx);
>> +
>> +		/* if program changed pkt bounds we need to update the xdp_frame */
>> +		if (unlikely(ctx_was_changed(head))) {
>> +			ret =3D xdp_update_frame_from_buff(ctx, frm);
>> +			if (ret) {
>> +				xdp_return_buff(ctx);
>> +				continue;
>> +			}
>> +		}
>> +
>> +		switch (act) {
>> +		case XDP_TX:
>> +			/* we can't do a real XDP_TX since we're not in the
>> +			 * driver, so turn it into a REDIRECT back to the same
>> +			 * index
>> +			 */
>> +			ri->tgt_index =3D xdp->dev->ifindex;
>> +			ri->map_id =3D INT_MAX;
>> +			ri->map_type =3D BPF_MAP_TYPE_UNSPEC;
>> +			fallthrough;
>> +		case XDP_REDIRECT:
>> +			redirect =3D true;
>> +			ret =3D xdp_do_redirect_frame(xdp->dev, ctx, frm, prog);
>> +			if (ret)
>> +				xdp_return_buff(ctx);
>> +			break;
>> +		case XDP_PASS:
>> +			frames[nframes++] =3D frm;
>> +			break;
>> +		default:
>> +			bpf_warn_invalid_xdp_action(NULL, prog, act);
>> +			fallthrough;
>> +		case XDP_DROP:
>> +			xdp_return_buff(ctx);
>> +			break;
>> +		}
>> +	}
>> +
>> +out:
>> +	if (redirect)
>> +		xdp_do_flush();
>> +	if (nframes)
>> +		err =3D xdp_recv_frames(frames, nframes, xdp->skbs, xdp->dev);
> This may overwrite the -ENOMEM with 0.

Argh, oops! And here I thought I was being clever by getting rid of the
indirection through 'ret'. Will fix, thanks!

-Toke

