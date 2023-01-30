Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB46968182C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 19:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237658AbjA3SC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 13:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbjA3SCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 13:02:24 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1640F1EFF3;
        Mon, 30 Jan 2023 10:02:22 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id gr7so9606757ejb.5;
        Mon, 30 Jan 2023 10:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2e4q4vLnV4kvKyozPY83n3uJMaYkgSTzaraxFCK6VlE=;
        b=QjPHN5B6CALVYF8eJzNIPsG0g1pzceiE2hsCvWmpJNAGD1vrWbJvCZeCcjQ6eADy7X
         +rHhPzs8YzfZY27hQrxxOVws+NeMmpQzs2dZvJyF9ePDcY6pL5qFpcxv6Z3gjK7XJP8V
         cByRrvJBuUR2bPrhmi5d/WnmANG7Y6jQK9ldIaDSqBxh3ID4IGOHEOX0TaogXKy8B68f
         YdGt9CF227lvD+bRgHbXuA/ANtLnfNmLv2C8td08GoyJe+3J4zL8gQFKZUR4Wjx07grD
         jmy6zNmOrRAYNi0zk7CarTBn76RGSVuzRP3TFEnE334v1V1ZIQxbXypKDzhXSbc1rITc
         v3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2e4q4vLnV4kvKyozPY83n3uJMaYkgSTzaraxFCK6VlE=;
        b=GJIa4WvkGKZ88PB0p8X1zX1uWylaJLL2Bj+nscAyU5amcoy/P+WWn4d43arpjQ1doJ
         O5Al60N4NXlvgMsfUXi5SSCRsDvP6zn+6NPfTYoP0pHaQmu8uSz8HhIliTQG+m9ldTwe
         JVJRFgqRH0WNy0LxxwiwbwK4O1VIi5Gb2Amz2N/4eIaW54HVdI248qGAMtjYd4p6+JNm
         4ZHUcx/vvlVXimKUL+gg/KVpPDDU1BmUqKYi7LkXyPw1JaAmB8itxbCCzoGMHeTbz1aB
         mWhizaJgGRenKF5OWspL3cP91luTbk1vWzVJfHUkaMGnPZrhc9xFU6UARyG+6+2cJxCL
         uDlA==
X-Gm-Message-State: AFqh2kov34Uh6BHUvYOdgfbuBUaL2AF0DKWW2Yh2jiyxZ1NzKzCkMz6U
        8dE0sPEEGYsZWLmVqB73y7hK05/+nUB590thxDQ=
X-Google-Smtp-Source: AMrXdXt2v8RXnqr0n63brJW64DYfr9lJj0iX+IQ07lAj+juWDoh3rFhuQaZ3DIDSg0TjGFzZmicnL1ZkcXc8EtRtQFI=
X-Received: by 2002:a17:906:7754:b0:86f:2cc2:7028 with SMTP id
 o20-20020a170906775400b0086f2cc27028mr7689625ejn.133.1675101740519; Mon, 30
 Jan 2023 10:02:20 -0800 (PST)
MIME-Version: 1.0
References: <20230130092157.1759539-1-hch@lst.de> <20230130092157.1759539-13-hch@lst.de>
In-Reply-To: <20230130092157.1759539-13-hch@lst.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 30 Jan 2023 19:02:08 +0100
Message-ID: <CAOi1vP_b77Pq=hYmFMi1zGGRMee2uNjbAbHz_gCCoByOdbRqLw@mail.gmail.com>
Subject: Re: [PATCH 12/23] ceph: use bvec_set_page to initialize a bvec
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
> Use the bvec_set_page helper to initialize a bvec.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/ceph/file.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 764598e1efd91f..6419dce7c57987 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -103,11 +103,11 @@ static ssize_t __iter_get_bvecs(struct iov_iter *iter, size_t maxsize,
>                 size += bytes;
>
>                 for ( ; bytes; idx++, bvec_idx++) {
> -                       struct bio_vec bv = {
> -                               .bv_page = pages[idx],
> -                               .bv_len = min_t(int, bytes, PAGE_SIZE - start),
> -                               .bv_offset = start,
> -                       };
> +                       struct bio_vec bv;
> +
> +                       bvec_set_page(&bv, pages[idx],

Hi Christoph,

There is trailing whitespace on this line which git complains about
and it made me take a second look.  I think bvec_set_page() allows to
make this more compact:

        for ( ; bytes; idx++, bvec_idx++) {
                int len = min_t(int, bytes, PAGE_SIZE - start);

                bvec_set_page(&bvecs[bvec_idx], pages[idx], len, start);
                bytes -= len;
                start = 0;
        }

Thanks,

                Ilya
