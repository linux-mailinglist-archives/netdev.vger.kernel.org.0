Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D9765DABC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjADQuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240174AbjADQsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:48:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDCD43A1F
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 08:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672850694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6EzsGSC3holClBSPQw8EocT+rCm9w6LTUpG8IqXLKaM=;
        b=WxwgsSgtV/aUyKxpMinNBr0WvgK2Zmd8TgA3cR6rxwn+KkF47DkRl6eZrYoRR6BK58TVUu
        2zEeBmdhd58UT4Oxci+Z0hZNMVglItFZJJ5tSvM4l21CAh/KJLxY3ZWEmknr0kb1Z2www/
        CiNvzeKsjuoWnmoZQptFStcyZzh4Z2k=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-ALPSqnt7N-aOpLeBBPeYRA-1; Wed, 04 Jan 2023 11:44:52 -0500
X-MC-Unique: ALPSqnt7N-aOpLeBBPeYRA-1
Received: by mail-qk1-f200.google.com with SMTP id u11-20020a05620a430b00b007052a66d201so10433231qko.23
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 08:44:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EzsGSC3holClBSPQw8EocT+rCm9w6LTUpG8IqXLKaM=;
        b=xtyEZTAB804fx4f5FGyHMtzZwv/NsT33tTrTXTVIWjY+QBKju2M8bQ3nNKwZy5/yct
         YCPzC2RX4LkSzQM7NpkZq3mCURMepBc+pTZrxyLt+uB68fasd+qj+Sv4SbHHmlO6hYnj
         SrPXRa2peHYUMmcE0rbvywX3x8oayuC6GH/gRoAee2DQDDjZNBJPsQfYTKnoRWhh3tmW
         BmQA3yg2zJnSRdhI18EEbaBWDeBQDLHndykA85P6Iufw4elT7SjSJGh8sjnlLzKXZMkN
         Bu7TRV+hargND8CAS+ate55ygKpZ3+CLI6M0pshEM7kdGELxnh2kg+I/12Ekk4St+cO9
         CWSQ==
X-Gm-Message-State: AFqh2krogb0ouSLhzTBOvO6jAzG9wEGywGqgsmae332W30UhT58Ovh05
        rujvLnrmD3/KZGGBDmV65GtESqhIOdWd8LIuj+f6YmwyuYpvE++MkZd6rRbPzk0pjPAv58YNMUm
        WfVU/QzBp8QUDr8g5
X-Received: by 2002:a05:622a:124b:b0:3ab:7bb3:4707 with SMTP id z11-20020a05622a124b00b003ab7bb34707mr50094175qtx.64.1672850692363;
        Wed, 04 Jan 2023 08:44:52 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtC6/5x1TZXjNxaTZni/mgmGgEGvHrxdB4Ldf1ggEJ59TT3GmI7MMZ8cyzI4+MP/hbyTOvkqA==
X-Received: by 2002:a05:622a:124b:b0:3ab:7bb3:4707 with SMTP id z11-20020a05622a124b00b003ab7bb34707mr50094133qtx.64.1672850692030;
        Wed, 04 Jan 2023 08:44:52 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-39-70-52-228-144.dsl.bell.ca. [70.52.228.144])
        by smtp.gmail.com with ESMTPSA id u22-20020a05620a455600b006fb112f512csm24300165qkp.74.2023.01.04.08.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:44:51 -0800 (PST)
Date:   Wed, 4 Jan 2023 11:44:49 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christian Brauner <brauner@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: remove zap_page_range and create zap_vma_pages
Message-ID: <Y7WtAXpZM3Mxi95N@x1n>
References: <20230104002732.232573-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230104002732.232573-1-mike.kravetz@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 04:27:32PM -0800, Mike Kravetz wrote:
> zap_page_range was originally designed to unmap pages within an address
> range that could span multiple vmas.  While working on [1], it was
> discovered that all callers of zap_page_range pass a range entirely within
> a single vma.  In addition, the mmu notification call within zap_page
> range does not correctly handle ranges that span multiple vmas.  When
> crossing a vma boundary, a new mmu_notifier_range_init/end call pair
> with the new vma should be made.
> 
> Instead of fixing zap_page_range, do the following:
> - Create a new routine zap_vma_pages() that will remove all pages within
>   the passed vma.  Most users of zap_page_range pass the entire vma and
>   can use this new routine.
> - For callers of zap_page_range not passing the entire vma, instead call
>   zap_page_range_single().
> - Remove zap_page_range.
> 
> [1] https://lore.kernel.org/linux-mm/20221114235507.294320-2-mike.kravetz@oracle.com/
> Suggested-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

