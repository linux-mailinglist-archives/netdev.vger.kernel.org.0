Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A6357D584
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbiGUVGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiGUVGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:06:39 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353A8904C2;
        Thu, 21 Jul 2022 14:06:37 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id q14so2340405iod.3;
        Thu, 21 Jul 2022 14:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UD6/PHsX06ls442kfkXr+sBUg1Zo13esPXVZU+zxxXo=;
        b=lr6SWiF1ovkDnMS4jHw8tSYu3+iWiLSMv3qzm78VAjM7sA8u4bvPxO6vGOdV5nqnwF
         /+Kw3jadBLbpDWck7WkFc/OJs2qZ6MNLLtRtWyKiQO3A8qLAqUQPCFazamo+5CLx2H1u
         QcAamcduJ+sznu75aQRU9jGDkc91SnXJYVAOINK2TVJqM52wESGPChkRIeM2RRF9NPPO
         uf8Tb8zAuDBhNA+SzREO2bI/zYGnnxbNte8DkFTx2ya06y7cnIp/KoCexh2UVcyn13O+
         oLA9as2GswecUrbZ5Rt8uKbCvhuLlaQyQs137wbHaXP7ok9VGCwn/oQRDsarBXxRUvFT
         U7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UD6/PHsX06ls442kfkXr+sBUg1Zo13esPXVZU+zxxXo=;
        b=koX5wUt/sw4VEwGrQwmn6oODJtt/6VC6PdUVUmScPJKKyfitj/MDYmmT1Y+CkVr71B
         tJrsi0HRz2PGoWMtvpisPWHQnGjj/+Xjx4M+34dDs2sLV3OdAw4gXwajuQ4u0ND8l1wJ
         QnFH1tFI91vVvZEpgqPpim5mX8G5VKtUD2SV5eRZkG3shtIrxC8FkJxXvsW6B+hJzI44
         4MfgZdG+RV8vUQo8uunpaIWUebE+dsvIHm8cKK/QNdqkK5l9bEJQjUWAGFGPqAw1lQ23
         JeJx2ip5lwiuCD5oxSrEhJyy4wkJ80SbH8Dk19wCqgghQQrA2ZluSoXkBDXuWP/R3NN4
         uFzQ==
X-Gm-Message-State: AJIora/REg+X8/QYadrC4lm0pP5wuFbicYXVsJ5e14vo7i0QL4w/EjfL
        GGOp/CSKpTRTkCRdpQFd0jS07fXVe8Qb3skDTPfIwzqTWyhvtw==
X-Google-Smtp-Source: AGRyM1uN8l37YfT8hkCKnvwVyvz74b+AfEG+kDrYj5DD7RVMo3dIntZFDDpXM7nlCrOMgEQKChUVSRyOQDvOU3VvY2o=
X-Received: by 2002:a05:6638:210b:b0:33f:5635:4c4b with SMTP id
 n11-20020a056638210b00b0033f56354c4bmr227538jaj.116.1658437596830; Thu, 21
 Jul 2022 14:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com> <20220721153625.1282007-6-benjamin.tissoires@redhat.com>
In-Reply-To: <20220721153625.1282007-6-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 21 Jul 2022 23:05:59 +0200
Message-ID: <CAP01T76_CEGR5Vn+7WCah4oLtv4GUYawhC2X5zUDugG1sTB28Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 05/24] bpf/verifier: allow kfunc to return an
 allocated mem
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 at 17:38, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> For drivers (outside of network), the incoming data is not statically
> defined in a struct. Most of the time the data buffer is kzalloc-ed
> and thus we can not rely on eBPF and BTF to explore the data.
>
> This commit allows to return an arbitrary memory, previously allocated by
> the driver.
> An interesting extra point is that the kfunc can mark the exported
> memory region as read only or read/write.
>
> So, when a kfunc is not returning a pointer to a struct but to a plain
> type, we can consider it is a valid allocated memory assuming that:
> - one of the arguments is either called rdonly_buf_size or
>   rdwr_buf_size
> - and this argument is a const from the caller point of view
>
> We can then use this parameter as the size of the allocated memory.
>
> The memory is either read-only or read-write based on the name
> of the size parameter.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
