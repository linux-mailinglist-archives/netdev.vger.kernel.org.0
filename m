Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008E5682386
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 05:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjAaEsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 23:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjAaEsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 23:48:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3250C975E;
        Mon, 30 Jan 2023 20:48:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA54DB81986;
        Tue, 31 Jan 2023 04:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0504C433D2;
        Tue, 31 Jan 2023 04:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675140481;
        bh=CWgleLhFsY7fdAWz2/GYSNCWb5dkQP977u3wpy/hMGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dARP7ELm0JDZUtfdf/aZ8jH1JD0CLl7hoXoH78TsDhjc1mmn8JFRG1IigOhyzOTIR
         8LpgawDRtBw86IFXj6i1YkeRts+SWuJNykJYmlH/aIgncIrOZjAf+V+/CmtP/KRDAr
         VQCKDZAbOX7gqYp11J79NeVN8tSKvri14UKFB/PyE8wFl5jc+kE8t46/tFsmTWzcUR
         7y905w/ePF+771Ea1UzytT2Miv5ypO2Q07DAhG9UQz+0Eikry/PkH6GHvO2153a1Tl
         gFsQ/iFj+f+SWMdPgkH2tVoOS0Nrv5jbsqd1Sdse8+GqnLYQ5xf/0l8xGGH0jIGlb6
         ELagiuszQyNWQ==
Date:   Mon, 30 Jan 2023 20:47:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
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
Subject: Re: [PATCH 01/23] block: factor out a bvec_set_page helper
Message-ID: <20230130204758.38f4c6b9@kernel.org>
In-Reply-To: <20230130092157.1759539-2-hch@lst.de>
References: <20230130092157.1759539-1-hch@lst.de>
        <20230130092157.1759539-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Jan 2023 10:21:35 +0100 Christoph Hellwig wrote:
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 35c25dff651a5e..9e3dac51eb26b6 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -35,6 +35,21 @@ struct bio_vec {
>  	unsigned int	bv_offset;
>  };
>  
> +/**
> + * bvec_set_page - initialize a bvec based off a struct page
> + * @bv:		bvec to initialize
> + * @page:	page the bvec should point to
> + * @len:	length of the bvec
> + * @offset:	offset into the page
> + */
> +static inline void bvec_set_page(struct bio_vec *bv, struct page *page,
> +		unsigned int len, unsigned int offset)
> +{
> +	bv->bv_page = page;
> +	bv->bv_len = len;
> +	bv->bv_offset = offset;
> +}

kinda random thought but since we're touching this area - could we
perhaps move the definition of struct bio_vec and trivial helpers 
like this into a new header? bvec.h pulls in mm.h which is a right
behemoth :S
