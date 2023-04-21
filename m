Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830686EA458
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDUHKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjDUHJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:09:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8DA1FC6
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682060953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YvNqSawyJ3nJ/vCXn5tWx+RQcufZPyD2kLszhPcCGec=;
        b=UHEgtF4ZoDdnDu7Dc7lUPlo6BjlNHyvhsIpKzvWI+rlYtgvCQIMTgZKTQrfDeSLdgmmBi9
        q/1bPAVwci2brL8cFuHkbCsslJVhZV4xDUNei/Ex1hVmU2nbZc6opmZVebPsiy+UCReuLz
        CQF8NnPlXlM5q1slEbYXCLLEyEkbDdQ=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-qwwzWpKvMde4pUxy8Y63Pg-1; Fri, 21 Apr 2023 03:09:11 -0400
X-MC-Unique: qwwzWpKvMde4pUxy8Y63Pg-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-38be23b9905so1375480b6e.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:09:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682060951; x=1684652951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YvNqSawyJ3nJ/vCXn5tWx+RQcufZPyD2kLszhPcCGec=;
        b=LdheWQnqANOUcIVW1163X9ZMyN0J6toAY9T1DT1BlQExI8wMtx3+LE8tiaujQx1TJs
         qR/ZNxufrwprgiCKf+SBi0t+kIcQV0qRswiNmVqYSfoyozLiZTp1JV4ZqEiaqlgeMheI
         IassFDbnTXtZT06RHbPuFuEhJmmFRb9+aYQVYhgOSooX8w1xD0NNDhWrXaga1/cGBrvR
         raNHX0Nvxame/q4TjiIP4Wk19h4zn4+NGxdTbvLKgGpu6h+92EK8i+uR99NralheKF0d
         4wRQK701OzEadzU0ICeiIeU1sCgEIHwJ5mwqObROeGkjprW4+a+evqQpstt+yskns7gN
         2uQA==
X-Gm-Message-State: AAQBX9eKc3bveKx/mIqdrnTF+AFuNPSxkjjJvs9B5qRGXKc4QIgdar11
        /RI4bj2UcuV4+00hB03hX7+3PsdLKgUAMU9XTPO/Y6J+WuwVpqVVyZjlZiBose/BkN4MP8Td4CI
        sVZeDiwE3fXYDACKAIyPeKx3OYMTuxSuE
X-Received: by 2002:a05:6870:428e:b0:177:b62d:cc1c with SMTP id y14-20020a056870428e00b00177b62dcc1cmr3330127oah.0.1682060950842;
        Fri, 21 Apr 2023 00:09:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZUnxaXgksNu0d9L0Wy5hrT6fYbh4k+ofySxdJolQXrJne1N1iwbOSJoXTrNObqrrmgHYlJIYKcUn7cD+PIHKQ=
X-Received: by 2002:a05:6870:428e:b0:177:b62d:cc1c with SMTP id
 y14-20020a056870428e00b00177b62dcc1cmr3330122oah.0.1682060950649; Fri, 21 Apr
 2023 00:09:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230419134329.346825-1-maxime.coquelin@redhat.com>
 <CACGkMEuiHqPkqYk1ZG3RZXLjm+EM3bmR0v1T1yH-ADEazOwTMA@mail.gmail.com> <ZEGG2GJw2DQk689j@x1n>
In-Reply-To: <ZEGG2GJw2DQk689j@x1n>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 21 Apr 2023 15:08:59 +0800
Message-ID: <CACGkMEvtBQg5fTTzSaMRwZH7P3WiDx0=eov9RdCtSFaHVtbh1w@mail.gmail.com>
Subject: Re: [RFC 0/2] vduse: add support for networking devices
To:     Peter Xu <peterx@redhat.com>
Cc:     Maxime Coquelin <maxime.coquelin@redhat.com>,
        xieyongji@bytedance.com, mst@redhat.com, david.marchand@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 2:39=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Thu, Apr 20, 2023 at 12:34:06PM +0800, Jason Wang wrote:
> > > 3. Coredump:
> > >   In order to be able to perform post-mortem analysis, DPDK
> > >   Vhost library marks pages used for vrings and descriptors
> > >   buffers as MADV_DODUMP using madvise(). However with
> > >   VDUSE it fails with -EINVAL. My understanding is that we
> > >   set VM_DONTEXPAND flag to the VMAs and madvise's
> > >   MADV_DODUMP fails if it is present. I'm not sure to
> > >   understand why madvise would prevent MADV_DODUMP if
> > >   VM_DONTEXPAND is set. Any thoughts?
> >
> > Adding Peter who may know the answer.
>
> I don't.. but I had a quick look, it seems that VM_DONTEXPAND was kind of
> reused (and I'm not sure whether it's an abuse or not so far..) to
> represent device driver pages since removal of VM_RESERVED:

Interesting, but there're indeed cases where VM_DONTEXPAND is used by
non-driver codes. The pages mapped by VDUSE are not device driver
pages but the IOTLB and virtqueue.

Btw the definition of VM_SPECIAL doesn't say anything related to dump:

/*
 * Special vmas that are non-mergable, non-mlock()able.
 */
#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)

>
> https://lore.kernel.org/all/20120731103457.20182.88454.stgit@zurg/
> https://lore.kernel.org/all/20120731103503.20182.94365.stgit@zurg/
>
> But I think that change at least breaks hugetlb once so there's the
> explicit hugetlb check to recover that behavior back:
>
> https://lore.kernel.org/all/20180930054629.29150-1-daniel@linux.ibm.com/

This seems similar to the case of VDUSE.

Thanks

>
> Thanks,
>
> --
> Peter Xu
>

