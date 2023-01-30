Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94423681A51
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbjA3TYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjA3TYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:24:47 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC0B212E;
        Mon, 30 Jan 2023 11:24:45 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id cq16-20020a17090af99000b0022c9791ac39so4191032pjb.4;
        Mon, 30 Jan 2023 11:24:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0USauUwqY1SaOU2GvOVYD8aiTVQVkxSRI7nFSgwMtU=;
        b=H3uUYUYdL0zlowCOr8tyfXc4JDL3ZjZgc6OL1sEgm+4YEEqsZ3/MFUwp5DHIe4NXIt
         nGMOYHt2NPw5sfawWQG0G0sBA92lkpFnF2bsSgnbXdBnc1ekBPidTh41vkkWtvZyRxBg
         nW9BJefQmaAg3i0fpUXtK0TKG6oZnP44tHeK+aaUI6ZlNDDa//5cH0JSN1Ib/qWa53FO
         YdWhDHMnCcU6Hh8qC9F8VfiwE9AER9S4uXYAmpPetcx13RdNKhYJ0IPjYKNZL2ARstzc
         kNdAebX6e5PAB+Gxi3K4rzoII+iWmQugiMUcv4pNEdGwJHRDCdDkJfgnZ24ob2Irtxya
         0Eig==
X-Gm-Message-State: AO0yUKWDxMivhK+gCHffektmOv2mXfLY2MeuIryf8YW9zQ9VhjnmfKB6
        Q+vUJVtP1mW0MUbfSD5oQgQ=
X-Google-Smtp-Source: AK7set/rGKHetFHi+kM9ZonjZUNA4n9BoD4xsf4KlNV/nZP1isOdo/PYXU7cRl9F9xNCOZ6lx4KGGg==
X-Received: by 2002:a05:6a20:54a3:b0:be:a177:af43 with SMTP id i35-20020a056a2054a300b000bea177af43mr2872944pzk.24.1675106684718;
        Mon, 30 Jan 2023 11:24:44 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5016:3bcd:59fe:334b? ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id 69-20020a630248000000b0045ff216a0casm7117730pgc.3.2023.01.30.11.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 11:24:43 -0800 (PST)
Message-ID: <0a7739db-13e2-efac-2c1a-872d7f2fa7aa@acm.org>
Date:   Mon, 30 Jan 2023 11:24:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 01/23] block: factor out a bvec_set_page helper
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
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
 <2bab7050-dec7-3af8-b643-31b414b8c4b4@acm.org>
In-Reply-To: <2bab7050-dec7-3af8-b643-31b414b8c4b4@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/23 09:09, Bart Van Assche wrote:
> On 1/30/23 01:21, Christoph Hellwig wrote:
>> Add a helper to initialize a bvec based of a page pointer.  This will 
>> help
>> removing various open code bvec initializations.
> 
> Why do you want to remove the open-coded bvec initializations? What is 
> wrong with open-coding bvec initialization? This patch series modifies a 
> lot of code but does not improve code readability. Anyone who encounters 
> code that uses the new function bvec_set_page() has to look up the 
> definition of that function to figure out what it does.

Please ignore the above question - I just noticed that this question has 
been answered in the cover letter.

Bart.

