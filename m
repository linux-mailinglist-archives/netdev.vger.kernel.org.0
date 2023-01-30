Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8396817FF
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbjA3RsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237237AbjA3RsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:48:00 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D749A302A9;
        Mon, 30 Jan 2023 09:47:57 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id k4so28601867eje.1;
        Mon, 30 Jan 2023 09:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M+UsnDYEEEOfyUbH/lXJAyb1YrNHDU89XvWY7p8gIqU=;
        b=CpIi7U8meqUvpwwHiSGd1IdVplT9N/wEXPlMlTsFFXyhK4irJaVCltXVoisRD4OtsJ
         Rp+GETx2zPi+LRHBbG7TedN9tCa2d44rv6ERS9LZ714bjXED6oA4tXrKaQgaZefoLEBT
         FmxpGFZB4292Hf7PShZjUN1dUJCt8d/dMntxKh5EE3vQ2/1IMSkKRPUher8dCYs0V1yG
         b8LfOHrulCQRh/AAOTrO0gUY89a5W9PLGsq/+xfSMRtf5+itz58cVqKOZLq6B2OfqfRh
         /PZRDDptgKbJtfY7tCnEgNDOmTGJa40XfEUjVp6cWOKwTJy7dVnFZRZFdHwf9raQ0FKA
         U+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M+UsnDYEEEOfyUbH/lXJAyb1YrNHDU89XvWY7p8gIqU=;
        b=OZaK53lemtiDOiWhwdIYjI0r8NMzehSVhSvb706oy24V1kiNil/9JMiwxUmiv0PFRm
         2zicxSDypaxiSBNK7knMH+jTxLN5/wm2rRJxwyv6m2WfRry5XceYax5CQmxc9Su0nl0I
         wcjCl5FAAYL95Ceyidg/PVIcjqFbBapiNJ4f3JdzOpjJSYCsKzmqFYvu4ZlOZYjEvz5O
         5qXAdkvPh/llF7EK55T8nr1XTPn+ScsYnDN1s4oAT32B1yriArhLhlQEuwHY8r04D2Qe
         wWgiC5Km1iWSDckB4kHnbfWKS/DAeiLR6yvoO0zQLi06JV3y7iSy4BZy1y0fkEqK8PQO
         ub3w==
X-Gm-Message-State: AFqh2krra0v7gz3bn+UMoAwU1vkLbWWPl+klwaXz9tXtu/eOtxwkvo6E
        +qOWTvAHzldg1dd7WdO4f9DeMwTUiZxXek/EyUA=
X-Google-Smtp-Source: AMrXdXuRX3iGxgJVTohVZn9PzXrmwlAnwYJ6yU/LKWcFrxKFgKe4FiyCZtPmYi+BznmfdmjECdu7m6UwdR7AVtAfqLc=
X-Received: by 2002:a17:906:3658:b0:872:68a:a17e with SMTP id
 r24-20020a170906365800b00872068aa17emr7392236ejb.159.1675100876297; Mon, 30
 Jan 2023 09:47:56 -0800 (PST)
MIME-Version: 1.0
References: <20230130092157.1759539-1-hch@lst.de> <20230130092157.1759539-9-hch@lst.de>
In-Reply-To: <20230130092157.1759539-9-hch@lst.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 30 Jan 2023 18:47:44 +0100
Message-ID: <CAOi1vP9AAQP7yqrXNRjvahy_t_Oz4+Z-CpT=uHscngC2OMWf5g@mail.gmail.com>
Subject: Re: [PATCH 08/23] rbd: use bvec_set_page to initialize the copy up bvec
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
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

On Mon, Jan 30, 2023 at 10:22 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Use the bvec_set_page helper to initialize the copy up bvec.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/rbd.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 04453f4a319cb4..1faca7e07a4d52 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -3068,13 +3068,12 @@ static int setup_copyup_bvecs(struct rbd_obj_request *obj_req, u64 obj_overlap)
>
>         for (i = 0; i < obj_req->copyup_bvec_count; i++) {
>                 unsigned int len = min(obj_overlap, (u64)PAGE_SIZE);
> +               struct page *page = alloc_page(GFP_NOIO);
>
> -               obj_req->copyup_bvecs[i].bv_page = alloc_page(GFP_NOIO);
> -               if (!obj_req->copyup_bvecs[i].bv_page)
> +               if (!page)
>                         return -ENOMEM;
>
> -               obj_req->copyup_bvecs[i].bv_offset = 0;
> -               obj_req->copyup_bvecs[i].bv_len = len;
> +               bvec_set_page(&obj_req->copyup_bvecs[i], page, len, 0);
>                 obj_overlap -= len;
>         }
>
> --
> 2.39.0
>

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
