Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD09C68A012
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 18:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjBCROi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 12:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbjBCROg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 12:14:36 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2A98D42F;
        Fri,  3 Feb 2023 09:14:34 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id lu11so17227703ejb.3;
        Fri, 03 Feb 2023 09:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=piXirJB1ocWVRzhs3blzzKk9+m92CHpoGy9Z2k+SCeM=;
        b=Fb0zwCwCJOeiTQEIlhQwff7G7k9ElObO1R+33i0wPXCrqwIBrpEt840BslhPeWvhej
         RNm1AhkBApvOqVaG8WlS647E04HIjv8QXHbrx4efowZpI0TaabZ8LMgSoh/aq8KjxxRH
         ymR8pWmWjw/LsMUWJ9rofMDzzzyZxS3bG6pr5yuXBaSNOMLnBMDA9JK7UsqZLm4fTbdz
         3JONOsnKCVpep3uis1ESPNXO4PXE5PboF2NqB2yAqmji5Wmfqm6IMWogBRXHCGUo+evy
         5FIXmxmK0Q+tgY6yH5xQu0jB1ogx5Xoz2NijnyXZiUzSOhVkO+fo8Fi/9WHvdy2fnh/f
         yg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=piXirJB1ocWVRzhs3blzzKk9+m92CHpoGy9Z2k+SCeM=;
        b=jdmnbkrMiyjXQk7PKMylQSXxePDm20sjtJjN0YfXIUoGbcu/Q+SLGejPF3zXgLYmMy
         cWAxD1LTIOz5kILKRqorGt5Mg4zqonWs6UvUk1vl0RAyFjCMM9MlbeEDee+hA+19L8s0
         diIzEEqd8eLKqHjmDCny5ScmQ6KF8RUv7Y+WuwPLaD9MqWyV88k8EVNtjmtMiClx79JB
         /ANrJeyiGsanxGMrQHH1Cue1SBzva+TXbhEg4e/9alVQNIEO/lGXsPltm04uKFKasjMx
         /vU9kcJVd/QvpB5nO+RhDbIo4CUAI31tLFsyJxWMSAc17ttYKUxVwfg+IcVVBhtXuAyG
         eipA==
X-Gm-Message-State: AO0yUKUKIQkAoGv+aEVboqAHc8lyX6KBEvwFhjvLF7OWMvaeJHvFkasU
        HsRqE0+NWIcin8KsPEhS3OyECsk2vEZOLSLDHQI=
X-Google-Smtp-Source: AK7set/+j+io9+OTuTc3zxO0OENdkhbzE8/JIAWcegXUIkecBeeVYLPG3d1104QBp1VROkgVOtVScA3k2o3zdZ2WZFo=
X-Received: by 2002:a17:907:9917:b0:878:5f93:e797 with SMTP id
 ka23-20020a170907991700b008785f93e797mr2680768ejc.4.1675444473257; Fri, 03
 Feb 2023 09:14:33 -0800 (PST)
MIME-Version: 1.0
References: <20230203150634.3199647-1-hch@lst.de> <20230203150634.3199647-13-hch@lst.de>
In-Reply-To: <20230203150634.3199647-13-hch@lst.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 3 Feb 2023 18:14:21 +0100
Message-ID: <CAOi1vP-HNmphq-_KakcGnmGYDY3rWbqmu0vWWS9vmYMLxgj1DQ@mail.gmail.com>
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

On Fri, Feb 3, 2023 at 4:07 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Use the bvec_set_page helper to initialize a bvec.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/ceph/file.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 764598e1efd91f..90b2aa7963bf29 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -103,14 +103,10 @@ static ssize_t __iter_get_bvecs(struct iov_iter *iter, size_t maxsize,
>                 size += bytes;
>
>                 for ( ; bytes; idx++, bvec_idx++) {
> -                       struct bio_vec bv = {
> -                               .bv_page = pages[idx],
> -                               .bv_len = min_t(int, bytes, PAGE_SIZE - start),
> -                               .bv_offset = start,
> -                       };
> -
> -                       bvecs[bvec_idx] = bv;
> -                       bytes -= bv.bv_len;
> +                       int len = min_t(int, bytes, PAGE_SIZE - start);
> +
> +                       bvec_set_page(&bvecs[bvec_idx], pages[idx], len, start);
> +                       bytes -= len;
>                         start = 0;
>                 }
>         }
> --
> 2.39.0
>

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
