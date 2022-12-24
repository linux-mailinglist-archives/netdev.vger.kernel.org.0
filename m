Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC12565587A
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 06:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiLXFgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 00:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiLXFg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 00:36:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E252B2
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 21:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671860142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9inerhQQEwTB9gS95jFKFAYGecKLrmD2EeG2lXh213o=;
        b=XVBiQH0HjGknBolDo1qf968foUuhnAqhnQHfOPMcNvOaaEx39yZALcwqP13EYa0tc37rB/
        bzOLHbb3u71x/kzwuaKAzPZ0xw96A/UIo3gyesrvjA/CC09gWtz/RAeEcrbFcreJhXjA1C
        wBiFWyYjhjnEc66OAeRemGT+vNVKtyo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-284-NjX6qA3mME2qZ-yZE0Urtg-1; Sat, 24 Dec 2022 00:35:40 -0500
X-MC-Unique: NjX6qA3mME2qZ-yZE0Urtg-1
Received: by mail-ej1-f69.google.com with SMTP id qa18-20020a170907869200b007df87611618so4434410ejc.1
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 21:35:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9inerhQQEwTB9gS95jFKFAYGecKLrmD2EeG2lXh213o=;
        b=oh1FkuXTCg5NgwrrG2jpNWFHVpa82AaIIKR2DKbVSsH8/EsAjMECg+IBRbaDphyEHo
         JPwSq34ClADf+vY1D5/mzxB5qfEhmBQ+eV1lLRg3SrJgqi3vCOoCJnuw87ts/k8TOTW1
         576IETXGmNnn5LwlmTYNJJm/89AORhRqZY3DAaQAREJIwuX6cLpoZiIX53Y/kIHuQRVB
         7aI2zkyj221PjHmYK2/eedlCvoVxygB5xxCymqPwRepvzj6b71ytRIbwJw/SQmVbmP7V
         iE84r7uhokroTpuZVUfz/7aYOUTmStFyRq6/Y4IQCI2qno/IO2TRg/zKbP/YSffXIYI9
         kyLA==
X-Gm-Message-State: AFqh2kp2dB5JFaWIDGiH7X9f5DYB/prboYjqx+ryqEfezeZ7XeoEkoGh
        KUXhCwyutlmu0dSQIy9IXl03kDs3HAebyepna1jCw9yDDQsxZ2DkE3Xwp5ZzV5DPTnTHHYaDrmA
        YI772sWuUEIzPn7rO
X-Received: by 2002:a17:906:65a:b0:7c1:7045:1a53 with SMTP id t26-20020a170906065a00b007c170451a53mr9229026ejb.15.1671860137871;
        Fri, 23 Dec 2022 21:35:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXud/Fb0wtBmXHI4TVa1R5iStbJI7HVjmtxNzdJlo5vEGwnAH05ulhj4IafppoZeQFZu1DEQKg==
X-Received: by 2002:a17:906:65a:b0:7c1:7045:1a53 with SMTP id t26-20020a170906065a00b007c170451a53mr9229005ejb.15.1671860137631;
        Fri, 23 Dec 2022 21:35:37 -0800 (PST)
Received: from redhat.com ([2.55.175.215])
        by smtp.gmail.com with ESMTPSA id a1-20020a170906684100b007c0f90a9cc5sm2140091ejs.105.2022.12.23.21.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 21:35:36 -0800 (PST)
Date:   Sat, 24 Dec 2022 00:35:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, angus.chen@jaguarmicro.com,
        bobby.eshleman@bytedance.com, colin.i.king@gmail.com,
        dave@stgolabs.net, dengshaomin@cdjrlc.com, dmitry.fomichev@wdc.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        harshit.m.mogalapalli@oracle.com, jasowang@redhat.com,
        leiyang@redhat.com, lingshan.zhu@intel.com, lkft@linaro.org,
        lulu@redhat.com, m.szyprowski@samsung.com, nathan@kernel.org,
        pabeni@redhat.com, pizhenwei@bytedance.com, rafaelmendsr@gmail.com,
        ricardo.canuelo@collabora.com, ruanjinjie@huawei.com,
        sammler@google.com, set_pte_at@outlook.com, sfr@canb.auug.org.au,
        sgarzare@redhat.com, shaoqin.huang@intel.com,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        sunnanyong@huawei.com, wangjianli@cdjrlc.com,
        wangrong68@huawei.com, weiyongjun1@huawei.com,
        xuanzhuo@linux.alibaba.com, yuancan@huawei.com
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
Message-ID: <20221224003445-mutt-send-email-mst@kernel.org>
References: <20221222144343-mutt-send-email-mst@kernel.org>
 <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
 <20221223172549-mutt-send-email-mst@kernel.org>
 <CAHk-=whpdP7X+L8RtGsonthr7Ffug=FhR+TrFe3JUyb5-zaYCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whpdP7X+L8RtGsonthr7Ffug=FhR+TrFe3JUyb5-zaYCA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 02:36:46PM -0800, Linus Torvalds wrote:
> On Fri, Dec 23, 2022 at 2:27 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > They were all there, just not as these commits, as I squashed fixups to
> > avoid bisect breakages with some configs. Did I do wrong?
> 
> I am literally looking at the next-20221214 state right now, doing
> 
>     git log linus/master.. -- drivers/vhost/vsock.c
>     git log linus/master.. -- drivers/vdpa/mlx5/
>     git log --grep="temporary variable type tweak"
> 
> and seeing nothing.
> 
> So none of these commits - in *any* form - were in linux-next last
> week as far as I can tell.
> 
>              Linus


They were in  next-20221220 though.

-- 
MST

