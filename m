Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126686E9BCC
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjDTSkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDTSkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:40:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D867D8
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 11:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682015964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GXtC/sVk1W7H+fsLDKJXUd2xWw5ZJzD/Qr53ie94Xh4=;
        b=CMf3EHo9Pk8KqTVpEr/O3D3gs1gy4goyMyNFi56W9QXA4dkPXudxDquJFetqPYM0bpK8ej
        jLyOU5p7dGM2SDRhb0HO1KIeGz3Xx9vVdlMyISE3bKAa2SBysWAAnME/EIkO2pIhYgUBWk
        NWVAtr3wt6TVyWJFIcIrHatNVA2tSBg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-U4OJLZuAMFSUb-X-KSCuUQ-1; Thu, 20 Apr 2023 14:39:23 -0400
X-MC-Unique: U4OJLZuAMFSUb-X-KSCuUQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-5ef67855124so858586d6.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 11:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682015963; x=1684607963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXtC/sVk1W7H+fsLDKJXUd2xWw5ZJzD/Qr53ie94Xh4=;
        b=ehMhwqsLiY4iQVD5vrmboUY/H1AOgKqf/iqV7CBro1z1z/ie5URpbnQN1Fp+JX1ogz
         k0QhTbw8v4Jt3T+i2TPRYSAkhc9Sog59X1WfxKhNve8MneeG3DFKsKvZPh351kf5ifaT
         Frv4bQXDo6kxuCFIP8on1Nd3JK65N2dK4HrUpT8lxng069lg8TjqseRz/NMc77RKkiAH
         IvsE7/mat0OywYngwRtlFTy1IUO5g3f1P4r28HgMGyUcFr5vEUu1ReAN6JPBcoQeoV1G
         21PgL3KLQ+uauMJGu0QogX0qEO0tPO6mb58CzVqZd/Zmq8G+0cFs9VezP/DrTE36Cpzs
         ixIA==
X-Gm-Message-State: AAQBX9d/qgH3oZXD1Fwb0mJ8AWY/LEzO6jyl+QxY9TQdRqKeK50kWfGu
        3RY6VUk/LbGPlfpb0PFjfObptwQddpf4nG2DRcZ2/RBK5yAfJemoA7+bWLFTwDYmVbvd3QOxTQl
        olJURrVL32oVEum+v
X-Received: by 2002:a05:6214:5195:b0:5aa:14b8:e935 with SMTP id kl21-20020a056214519500b005aa14b8e935mr3573718qvb.2.1682015963032;
        Thu, 20 Apr 2023 11:39:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350aKi5xgA2plkiWriD1Mvo1IbP57XENG4+e0T19/igecmwtmBejG9uHeDR/BWWRWuuq3iyfbAA==
X-Received: by 2002:a05:6214:5195:b0:5aa:14b8:e935 with SMTP id kl21-20020a056214519500b005aa14b8e935mr3573691qvb.2.1682015962750;
        Thu, 20 Apr 2023 11:39:22 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id g19-20020a0caad3000000b005dd8b93457csm570316qvb.20.2023.04.20.11.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 11:39:21 -0700 (PDT)
Date:   Thu, 20 Apr 2023 14:39:20 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Maxime Coquelin <maxime.coquelin@redhat.com>,
        xieyongji@bytedance.com, mst@redhat.com, david.marchand@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com
Subject: Re: [RFC 0/2] vduse: add support for networking devices
Message-ID: <ZEGG2GJw2DQk689j@x1n>
References: <20230419134329.346825-1-maxime.coquelin@redhat.com>
 <CACGkMEuiHqPkqYk1ZG3RZXLjm+EM3bmR0v1T1yH-ADEazOwTMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACGkMEuiHqPkqYk1ZG3RZXLjm+EM3bmR0v1T1yH-ADEazOwTMA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 12:34:06PM +0800, Jason Wang wrote:
> > 3. Coredump:
> >   In order to be able to perform post-mortem analysis, DPDK
> >   Vhost library marks pages used for vrings and descriptors
> >   buffers as MADV_DODUMP using madvise(). However with
> >   VDUSE it fails with -EINVAL. My understanding is that we
> >   set VM_DONTEXPAND flag to the VMAs and madvise's
> >   MADV_DODUMP fails if it is present. I'm not sure to
> >   understand why madvise would prevent MADV_DODUMP if
> >   VM_DONTEXPAND is set. Any thoughts?
> 
> Adding Peter who may know the answer.

I don't.. but I had a quick look, it seems that VM_DONTEXPAND was kind of
reused (and I'm not sure whether it's an abuse or not so far..) to
represent device driver pages since removal of VM_RESERVED:

https://lore.kernel.org/all/20120731103457.20182.88454.stgit@zurg/
https://lore.kernel.org/all/20120731103503.20182.94365.stgit@zurg/

But I think that change at least breaks hugetlb once so there's the
explicit hugetlb check to recover that behavior back:

https://lore.kernel.org/all/20180930054629.29150-1-daniel@linux.ibm.com/

Thanks,

-- 
Peter Xu

