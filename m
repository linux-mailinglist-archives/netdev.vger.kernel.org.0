Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E4C53A43C
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244544AbiFALfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236784AbiFALfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:35:34 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C8D21806;
        Wed,  1 Jun 2022 04:35:33 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id rs12so3086043ejb.13;
        Wed, 01 Jun 2022 04:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/pBPOinGtWLSH0tnCokdF/Kl/XTivemcUrlGpG+X7lE=;
        b=IKEbHE4Wc5T+tzXdjWgU2qqm+VIhwmBP7Sme5ZXXXN3CJ3dd2ppLVWAOhhbpURD3nC
         H/MVQFZuZWYm730d7r2GtF9idFAvbo7+xI3z8DYZeHSvy0mA7gES9pp/fMXLQrlaTH9C
         EqhIOkjLIJTTu5A8V/kn0MsXo94Nf9R2dmV38cpjiSv16jJWLOOvPYRyjEv2TMY+ZJJG
         DAkAnlHO0+Xq4zjfcI5cN9AK2ixspikZu79en2tQufRYtK6iH3u3KuMa0KDFBuE8Hjjn
         bbE33IxrQCGbjhRuaZu7FtDIV54x94TgOxYlO1CM4DSEs/LUv/2WolH4UTiuAVwjdCjL
         QATA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/pBPOinGtWLSH0tnCokdF/Kl/XTivemcUrlGpG+X7lE=;
        b=HoAzeKjGc6laWa2Kz/MgnVYgJ4cbIs3T6SW2x2SlemNeV+xkl9g4dHUisWQSglwcBZ
         kWrQfQrn/SPVFl+iGixAX0aimaRXNJ2hw5laL3FbzuUdoukCykgilGETz7mJEieD5BOn
         EEn4XKoau4BVT9wQYZpDoi3gid3CnQcHzUky2JZv4/P1xaiAohcWB0k/f1IpprZEORyE
         4ZYTxboOF4unh1sXQZQYt+LUitB0Y76wR6iQoStPbNZafRfMZhrmAMh8qcFE5SU/HPng
         v7NTTbmENeBTmMhamMK3ptqDqRr8T8JY0U7Rc0ORXf3cZURa6n/FI3bu4DOFdrJb66u+
         dRSA==
X-Gm-Message-State: AOAM530O98M/o3YjsU8CCizFU+UrbhescVafE9pJLEB0J29SWJm1otdo
        N5xgxhoEbWvdoswfr5nWWLzhjtZB7w/9fGwcaN8=
X-Google-Smtp-Source: ABdhPJz70Qgd6nnUj8Z1KfB04N5m6rObafs/lLx84LTdiDQ4hMk6CRFLDiggSGF+/pOUnR8UUJ/G5n/yOjfHNAW6pIo=
X-Received: by 2002:a17:906:b816:b0:708:2e56:97d7 with SMTP id
 dv22-20020a170906b81600b007082e5697d7mr1269087ejb.502.1654083331508; Wed, 01
 Jun 2022 04:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220601084149.13097-1-zhoufeng.zf@bytedance.com>
 <20220601084149.13097-2-zhoufeng.zf@bytedance.com> <CAADnVQJcbDXtQsYNn=j0NzKx3SFSPE1YTwbmtkxkpzmFt-zh9Q@mail.gmail.com>
 <21ec90e3-2e89-09c1-fd22-de76e6794d68@bytedance.com>
In-Reply-To: <21ec90e3-2e89-09c1-fd22-de76e6794d68@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Jun 2022 13:35:19 +0200
Message-ID: <CAADnVQKdU-3uBE9tKifChUunmr=c=32M4GwP8qG1-S=Atf7fvw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v4 1/2] bpf: avoid grabbing spin_locks of
 all cpus when no free elems
To:     Feng Zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 1:11 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>
> =E5=9C=A8 2022/6/1 =E4=B8=8B=E5=8D=885:50, Alexei Starovoitov =E5=86=99=
=E9=81=93:
> > On Wed, Jun 1, 2022 at 10:42 AM Feng zhou <zhoufeng.zf@bytedance.com> w=
rote:
> >>   static inline void ___pcpu_freelist_push(struct pcpu_freelist_head *=
head,
> >> @@ -130,14 +134,19 @@ static struct pcpu_freelist_node *___pcpu_freeli=
st_pop(struct pcpu_freelist *s)
> >>          orig_cpu =3D cpu =3D raw_smp_processor_id();
> >>          while (1) {
> >>                  head =3D per_cpu_ptr(s->freelist, cpu);
> >> +               if (READ_ONCE(head->is_empty))
> >> +                       goto next_cpu;
> >>                  raw_spin_lock(&head->lock);
> >>                  node =3D head->first;
> >>                  if (node) {
> > extra bool is unnecessary.
> > just READ_ONCE(head->first)
>
> As for why to add is_empty instead of directly judging head->first, my
> understanding is this, head->first is frequently modified during updating
> map, which will lead to invalid other cpus's cache, and is_empty is after
> freelist having no free elems will be changed, the performance will be
> better.

maybe. pls benchmark it.
imo wasting a bool for the corner case is not a good trade off.
