Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4E034589E
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhCWHZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhCWHZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:25:30 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4003BC061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 00:25:30 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r12so25405179ejr.5
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 00:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xwa51kxw61uMIow80uqDkY+H/GARiTsVnf3Sas4+BxM=;
        b=K/Y1f+FygYeHZ5bZBkEb+W+x4FQXWevwHu7nVAHSjHVtzShBuR+2g4FsS0kJzfB6Vy
         VVwcas8GBISn7nl+PoNKFfW4EktWkZWdfe7V6IXLHkWp1zEZC6hF9n0f+y8hnWEnn678
         bM2VOCVidgBxJJ7sHbiL6YqHT7ClwnTp1H6GfexhjZX5TAd7sYmJYCVyVM3dPzNdgjXp
         +Qq1sveuTC1kxYnTl3bnJC7WJ+Z5RIIs1fHT6Tw3rQE53wfy5yPnAQ650qEzQBUAamIp
         o/HlhyEARhMSvBBR5AeMuhWpQd/mMgr22U1IrIO9bKFBljAaC/j6nTrbC+LGXrHLs8hF
         AVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xwa51kxw61uMIow80uqDkY+H/GARiTsVnf3Sas4+BxM=;
        b=tpC23C0jAzOCNacaFD2qTBsWYw3fJE1TBZwZExY9nPFb8p3rxmOX91DdacD2r+Lgjr
         nxHTUSgFv19fh0mqMVJe5Us/AxS8mkdt+KLayGezHt/2GyHnSyUBPUwXQH6La2X4fjPT
         H8PzR2jrLqzrb+6hdiLwDjEPSCliRjv+rBnfC8PKIvyn1+62qLcLWSit0ATzD1ONljV/
         j/s6Hr3KvghiWkvG8s5AHuK6ikPjDwOxlsuIOwYS9oxQu57RGVHfUuaQ+re6xqogVlt8
         qcKwovWFhRZKwZCwvIzn8o/7KvX9sLG7rJe7CFYVPjUI8BJKWsz0BYTbMKv9Yj+cdc3L
         CkrQ==
X-Gm-Message-State: AOAM532K9dsgua1KowzaJvFQqBvdUQ8nB2lMmuLLVAAMENwncD/Mzy+r
        1/b3JHWEYYVPCAtL688dWvChYN7u9yBnYCmBnjd0
X-Google-Smtp-Source: ABdhPJzJm68SUj19rBv+WCUqBy2FNifWaazEUCLQ3Uhyia48gmLbT4tJs0m9MQ2KYMXowDVwKahrwolbYciM+aEhnp8=
X-Received: by 2002:a17:907:a042:: with SMTP id gz2mr3554509ejc.174.1616484329008;
 Tue, 23 Mar 2021 00:25:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-4-xieyongji@bytedance.com>
 <38a2ae38-ebf7-3e3b-3439-d95a6f49b48b@redhat.com>
In-Reply-To: <38a2ae38-ebf7-3e3b-3439-d95a6f49b48b@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 23 Mar 2021 15:25:18 +0800
Message-ID: <CACycT3vg=+08YWLrVPHATwFvCjEzmKuTLdX3=stLQqrsm-+1Vg@mail.gmail.com>
Subject: Re: Re: [PATCH v5 03/11] vhost-vdpa: protect concurrent access to
 vhost device iotlb
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/15 =E4=B8=8B=E5=8D=881:37, Xie Yongji =E5=86=99=E9=81=93=
:
> > Use vhost_dev->mutex to protect vhost device iotlb from
> > concurrent access.
> >
> > Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Please cc stable for next version.
>

Sure.

Thanks,
Yongji
