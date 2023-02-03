Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B6368A022
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 18:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbjBCRSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 12:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbjBCRSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 12:18:14 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F01422DC0
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 09:18:12 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id on9-20020a17090b1d0900b002300a96b358so5571974pjb.1
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 09:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K70GwBbxm76u0ZHh9QualBnSNVhMmwCaA4xLAgTOsU4=;
        b=R00Jv7r0nGI0Ztnp5TNHhM+FfJ5zmFRR/yKaJPFf48QgjKh7tXSwGMmQnOoqu8Xid4
         wge7CmaLgfoEKprgizb7/sm8rwZ8EQ9OCoyJKMGvTA4kiktJCR4NV/cva7qvSGWATdmE
         /2uT8roACaKsn4YLwQl6hQkgbKX7IYcNLKQL5KVRHggoW1I8XImpl9s6MfEiMUSpHo9Y
         S5fkZix1iQi2f9FmnThOmhtEMaBrJr9ePfucBJOf0enZnaK+aBn2RScZgWLk6sLYtLKJ
         6yN94xDkDiQ62CShnA6PepLuiQAIJ+UkyAdk860JzMBR19PnaXvBFKHmerQBvkix95On
         9+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K70GwBbxm76u0ZHh9QualBnSNVhMmwCaA4xLAgTOsU4=;
        b=1QGlm8bFdZDESmHH69M9QZMlwNrB2XiHyAx8KDG5j+Ih3EeSPliyOh7UPh4WsZ5CEH
         1jprqRlrDjGu8bD9r+E4tuhPu1IY/UxP+ex7YOKvxw2N9O9chqJPWFASIjiiHtUmudby
         d1XfxyWYy90Rk/uU8ZCWN73imCKplT6L4r99vVguOd8ayLtYC38pHbh9K/KvQoo+fStI
         zMPSX8NdTeDwDnyj26Ev74kGFyP6PBvvoDYwyLHD2k5k6z73mXuKalb+20R8B2SqEBTb
         plBIZm5K9qtd06S2mdF5KAAcquzu0gSKmIeL6lUUtGW8QN/IksVnumJjlnZFynQT2TsD
         vVhg==
X-Gm-Message-State: AO0yUKWPyUBytGZCz9lXKnGwOmMZuibP3YhUkSphtlBwoBt60TkYWbYK
        /dwpN5cfeAVZHDKQWA4ufZ/ZgQ==
X-Google-Smtp-Source: AK7set/8QyEeOBS5HCdwVVv3pX8pLqYaYDC09KN7ZX0YiSUh3tCWtH5sa+Lu+Eay2bGB3phfSCaeYw==
X-Received: by 2002:a17:90a:3c83:b0:22b:afef:9228 with SMTP id g3-20020a17090a3c8300b0022bafef9228mr8980675pjc.4.1675444691816;
        Fri, 03 Feb 2023 09:18:11 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s1-20020a17090a6e4100b0021900ba8eeesm5189271pjm.2.2023.02.03.09.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:18:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
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
In-Reply-To: <20230203150634.3199647-1-hch@lst.de>
References: <20230203150634.3199647-1-hch@lst.de>
Subject: Re: add bvec initialization helpers v2
Message-Id: <167544468926.66559.8388961280734694655.b4-ty@kernel.dk>
Date:   Fri, 03 Feb 2023 10:18:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 03 Feb 2023 16:06:11 +0100, Christoph Hellwig wrote:
> this series adds the helpers to initalize a bvec.  These remove open coding of
> bvec internals and help with experimenting with other representations like
> a phys_addr_t instead of page + offset.
> 
> Changes since v1:
>  - fix a typo
>  - simplify the code in ceph's __iter_get_bvecs a little bit further
>  - fix two subject prefixes
> 
> [...]

Applied, thanks!

[01/23] block: factor out a bvec_set_page helper
        commit: d58cdfae6a22e5079656c487aad669597a0635c8
[02/23] block: add a bvec_set_folio helper
        commit: 26db5ee158510108c819aa7be6eb8c75accf85d7
[03/23] block: add a bvec_set_virt helper
        commit: 666e6550cb74e3a7206b5699409c9f31e123887e
[04/23] sd: factor out a sd_set_special_bvec helper
        commit: f1e117cbb01a38f764db2f292174b93eab7c2db2
[05/23] target: use bvec_set_page to initialize bvecs
        commit: 3c7ebe952fefb646c56b60f1c3e3388f3b938cc7
[06/23] nvmet: use bvec_set_page to initialize bvecs
        commit: fc41c97a3a7b08131e6998bc7692f95729f9d359
[07/23] nvme: use bvec_set_virt to initialize special_vec
        commit: 4bee16daf13225d6b109bb95d613fd691b04a757
[08/23] rbd: use bvec_set_page to initialize the copy up bvec
        commit: 7df2af0bb4912cf360045d065f88fe4ed2f702ca
[09/23] virtio_blk: use bvec_set_virt to initialize special_vec
        commit: b831f3a1031664ae2443bab63d35c416ed30c91d
[10/23] zram: use bvec_set_page to initialize bvecs
        commit: 13ae4db0c05107814db4e774856aa83e72e8bf04
[11/23] afs: use bvec_set_folio to initialize a bvec
        commit: a8173be1863e57393edb5c158860ec43a1f21ed7
[12/23] ceph: use bvec_set_page to initialize a bvec
        commit: 5c6542b6612f635eaa001c54af22018f1e996418
[13/23] cifs: use bvec_set_page to initialize bvecs
        commit: 220ae4a5c2ba10333b3b01fbf3dea0d759e77a76
[14/23] coredump: use bvec_set_page to initialize a bvec
        commit: cd598003206839ed1354902805b52c3a4f6ead2e
[15/23] nfs: use bvec_set_page to initialize bvecs
        commit: 8bb7cd842c44b299586bfed6aadde8863c48b415
[16/23] orangefs: use bvec_set_{page,folio} to initialize bvecs
        commit: 8ead80b2c5f8c59d6ca18cd7fb582a3ffc7ea5b7
[17/23] splice: use bvec_set_page to initialize a bvec
        commit: 664e40789abaad892737a696102052dae199a029
[18/23] io_uring: use bvec_set_page to initialize a bvec
        commit: cc342a21930f0e3862c5fd0871cd5a65c5b59e27
[19/23] swap: use bvec_set_page to initialize bvecs
        commit: 8976fa6d79d70502181fa16b5e023645c0f44ec4
[20/23] rxrpc: use bvec_set_page to initialize a bvec
        commit: efde918ac66958c568926120841e7692b1e9bd9d
[21/23] sunrpc: use bvec_set_page to initialize bvecs
        commit: 9088151f1bfe670ae9e28b77095f974196bb2343
[22/23] vringh: use bvec_set_page to initialize a bvec
        commit: 58dfe14073846e416d5b3595314a4f37e1a89c50
[23/23] libceph: use bvec_set_page to initialize bvecs
        commit: 1eb9cd15004fa91b6d1911af9fbaff299d8e9e45

Best regards,
-- 
Jens Axboe



