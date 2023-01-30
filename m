Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEED681748
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbjA3RJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjA3RJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:09:30 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9B03FF2B;
        Mon, 30 Jan 2023 09:09:29 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id be8so12290652plb.7;
        Mon, 30 Jan 2023 09:09:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VcAkkG+7EQ87q1yuQfzrNQ/CVfL1BPFACyrSB5AzC9E=;
        b=w+5Cau5Utuz+gsMlY/4IbiIdWNbKBkgQ4TrPVBcGE+SToUp0g/A05HkGbJ0FTYbWrP
         7HMVfgUXpIW+u5zTse9SWNWDyRgonY9hrNypvej9fDylpcs9wAb9JVkG2HsklLrXdaj9
         cl6J0eDzdmsWCJVz8RhP2TnkRWKmyRxEbZAOwrxGy/5HNpnGlLmc4IMKZg+C9KjWiF2r
         mJ3HvAjE/Gp/1Ltkk0W7/TNlWDF36YVeMBsfa2cl6snKDRnPCJax248GlvbcFB6ygEOG
         QZ98lgO/W1rfYmFeagoSmehxPYnKYZ2X+/DSnxrijZv46tR1n3VPe5fmZpnO6snY7Jng
         fthg==
X-Gm-Message-State: AFqh2kpwH6xITHx+G85I2f/DjV4Sj43aFIVFcyohQIef5YtYDf32z/pi
        KoR4et2qMeAMRJlHNdQXWa4=
X-Google-Smtp-Source: AMrXdXsoThEeXwb5X9zNdrMM/dBzAwAKgsQUh4DVjXEWAVyR5f6ZoR++CGV0u6k+ufH+Ks5WBdnq6g==
X-Received: by 2002:a17:902:f646:b0:194:46e0:1b61 with SMTP id m6-20020a170902f64600b0019446e01b61mr52496709plg.63.1675098568615;
        Mon, 30 Jan 2023 09:09:28 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5016:3bcd:59fe:334b? ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id y16-20020a170902b49000b0019602263feesm8042186plr.90.2023.01.30.09.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 09:09:27 -0800 (PST)
Message-ID: <2bab7050-dec7-3af8-b643-31b414b8c4b4@acm.org>
Date:   Mon, 30 Jan 2023 09:09:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 01/23] block: factor out a bvec_set_page helper
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
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
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-2-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230130092157.1759539-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/23 01:21, Christoph Hellwig wrote:
> Add a helper to initialize a bvec based of a page pointer.  This will help
> removing various open code bvec initializations.

Why do you want to remove the open-coded bvec initializations? What is 
wrong with open-coding bvec initialization? This patch series modifies a 
lot of code but does not improve code readability. Anyone who encounters 
code that uses the new function bvec_set_page() has to look up the 
definition of that function to figure out what it does.

> -	iv = bip->bip_vec + bip->bip_vcnt;
> -
>   	if (bip->bip_vcnt &&
>   	    bvec_gap_to_prev(&bdev_get_queue(bio->bi_bdev)->limits,
>   			     &bip->bip_vec[bip->bip_vcnt - 1], offset))
>   		return 0;
>   
> -	iv->bv_page = page;
> -	iv->bv_len = len;
> -	iv->bv_offset = offset;
> +	bvec_set_page(&bip->bip_vec[bip->bip_vcnt], page, len, offset);
>   	bip->bip_vcnt++;

Has it been considered to use structure assignment instead of 
introducing bvec_set_page(), e.g. as follows?

bip->bip_vec[bip->bip_vcnt] = (struct bio_vec) {
       .bv_page = page, .bv_len = len, .bv_offset = offset };

Thanks,

Bart.
