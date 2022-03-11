Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0014D56C8
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345440AbiCKAea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344995AbiCKAe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:34:27 -0500
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9320EC3C;
        Thu, 10 Mar 2022 16:33:25 -0800 (PST)
Received: by mail-lf1-f52.google.com with SMTP id h14so12326996lfk.11;
        Thu, 10 Mar 2022 16:33:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bfFy1fRIg2or8wayuoUDmkiMKNG8jANUhiazblpam7E=;
        b=nNEcLy/+ncUaskQuorGMDKk1zWJvpD216iuHZl+Ez0Vdr86FfnRDFOQS0cb6FluwsW
         g2jHzpB1xMfM1YlSMF4Vrc0sYIM7YfDI13tTfSNurCc/WsiiDkcUls6ZMp+6TEx6ih4K
         5ycwCjYXir1tFRIThOOhcJEK+JqQkA7M/WA6y22MXNSyKks8emAJYJOjS+ejIzjv2Rfu
         LTH31exVhPYFPMAXAiSY6qm+bvq7mdCRs9ISI4MMuwybq37N4oJINtfCLOwzR61/1h7I
         HCwaKAy0Vqs08hm2htNLioGO0ksDnaGem89FbLYNHNlTI77NkDMDo5pYZ+ist3jGQEVR
         OpSQ==
X-Gm-Message-State: AOAM530nH1kAHktPfUeUqxnOn4HOuVNzdSfhKeLGcKSh6oZQD54IhE8h
        X1PEjPJwRE1zIbjLIHlgG2vDQg3847ouZlOGulUE8YJf
X-Google-Smtp-Source: ABdhPJwfyfWhzBQSSgjOz+8SBg/y6iurVRSOvyqziwcbivA2QtTq4aTrwBMDVEnbFmCvQ7IO8wbyIm85yFiWz86mfzM=
X-Received: by 2002:a05:6512:3983:b0:448:53c6:7023 with SMTP id
 j3-20020a056512398300b0044853c67023mr4535074lfu.481.1646958803953; Thu, 10
 Mar 2022 16:33:23 -0800 (PST)
MIME-Version: 1.0
References: <20220310082202.1229345-1-namhyung@kernel.org> <d2af0d13-68cf-ad8c-5b16-af76201452c4@fb.com>
 <CA+khW7ieO9QbGYdJQvg8vpYLi-yoUQcZDze8wtpf5qqSiNxosQ@mail.gmail.com>
In-Reply-To: <CA+khW7ieO9QbGYdJQvg8vpYLi-yoUQcZDze8wtpf5qqSiNxosQ@mail.gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Thu, 10 Mar 2022 16:33:13 -0800
Message-ID: <CAM9d7ciKCXD0vcC7rhZFOaXOFTAAWb5w1bXYEee-FZowwzEX9w@mail.gmail.com>
Subject: Re: [PATCH 1/2] bpf: Adjust BPF stack helper functions to accommodate
 skip > 0
To:     Hao Luo <haoluo@google.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Eugene Loh <eugene.loh@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hao,

On Thu, Mar 10, 2022 at 4:24 PM Hao Luo <haoluo@google.com> wrote:
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index b0383d371b9a..77f4a022c60c 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -2975,8 +2975,8 @@ union bpf_attr {
> > >    *
> > >    *                  # sysctl kernel.perf_event_max_stack=<new value>
> > >    *  Return
> > > - *           A non-negative value equal to or less than *size* on success,
> > > - *           or a negative error in case of failure.
> > > + *           The non-negative copied *buf* length equal to or less than
> > > + *           *size* on success, or a negative error in case of failure.
> > >    *
> > >    * long bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *to, u32 len, u32 start_header)
>
> Namhyung, I think you also need to mirror the change in
> tools/include/uapi/linux/bpf.h

Oh, right.  Will update.

Thanks,
Namhyung
