Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C585A5B0C59
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiIGSPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiIGSPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:15:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B28A7D7A0
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 11:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662574550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hwCc5OVCwETdEXk66j8frveKB6iuiO/N5iPy75mlvlU=;
        b=aoqFH3329/FUQvrCCF0m1Fh619aJAToHh4EZZlrkJGMXFpFG3CJhh5gxGnhLBD/9P9Zp83
        jcSAqhKuYqR683tXPElrmVe8R/8WKiKOhGyEd7L5TXh7oj/Qo2jKcM6Pp87RoSc5Tbbmik
        /OIowaEZh72LZylIUTQesiW46Zi/0Gw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-31-TuEAMCXJNCO4AGeH0eT8hQ-1; Wed, 07 Sep 2022 14:15:49 -0400
X-MC-Unique: TuEAMCXJNCO4AGeH0eT8hQ-1
Received: by mail-wr1-f69.google.com with SMTP id b17-20020adfc751000000b00228732b437aso3198112wrh.5
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 11:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=hwCc5OVCwETdEXk66j8frveKB6iuiO/N5iPy75mlvlU=;
        b=QzS4MQaUxHMoWWNXvoeLW4rMG12KXSacVmbftAFxYemAArzubpZ3T+01DfnFg/iyog
         nlOIliGytp171P1zA++6UGWgF9jZuik6U/6d9WwmOq5aWQxQtwJsIAB9Kqcy5HGgI0tz
         3ISwL2fPP65Ne0cG8dC6BpnU9umUJGOBPZyLCXikmoi5VoRCB8jK7Czo228UJFx1wKl1
         V8jJZOfCYuD3/efTCgGoYPDZhqF0tO/p/uATzVQC8mMYzafXduBoFirYYcsAm9EZ3GJb
         33owjxw6bq7t0YllMOBLLCArRCejInKdHTMf63bt+U+61pfwXxkcskhT5q6aFDYoFsbm
         DXwg==
X-Gm-Message-State: ACgBeo1s3aZeYzIQcR3yrw9ZIu39WfEpWIdNw0+lWOu6ZMsVCdAD0DVR
        U1fuVJxsg8/6tfnfHSmmh7QNNM3+zxX6cSTffE4DTKSq09U8eYID2WQGHJlWJnqMfKTEdfT+aCD
        WlFc6nYDnJd5mfGJt
X-Received: by 2002:a05:600c:42c3:b0:3a6:431:91bf with SMTP id j3-20020a05600c42c300b003a6043191bfmr16669886wme.188.1662574548022;
        Wed, 07 Sep 2022 11:15:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR60X15NZZusBD9CpMjdLM/YZyIbX5InDgusEWqWVRMHukuNbGQvE1G3ZdYkDEZA9weO2xn3Jg==
X-Received: by 2002:a05:600c:42c3:b0:3a6:431:91bf with SMTP id j3-20020a05600c42c300b003a6043191bfmr16669873wme.188.1662574547840;
        Wed, 07 Sep 2022 11:15:47 -0700 (PDT)
Received: from redhat.com ([2.52.30.234])
        by smtp.gmail.com with ESMTPSA id f25-20020a1c6a19000000b003a840690609sm29938661wmc.36.2022.09.07.11.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 11:15:47 -0700 (PDT)
Date:   Wed, 7 Sep 2022 14:15:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Message-ID: <20220907141447-mutt-send-email-mst@kernel.org>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
 <20220907012608-mutt-send-email-mst@kernel.org>
 <0355d1e4-a3cf-5b16-8c7f-b39b1ec14ade@nvidia.com>
 <20220907052317-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54812EC7F4711C1EA4CAA119DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 04:12:47PM +0000, Parav Pandit wrote:
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Wednesday, September 7, 2022 10:40 AM
> > 
> > On Wed, Sep 07, 2022 at 02:33:02PM +0000, Parav Pandit wrote:
> > >
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > Sent: Wednesday, September 7, 2022 10:30 AM
> > >
> > > [..]
> > > > > > actually how does this waste space? Is this because your device
> > > > > > does not have INDIRECT?
> > > > > VQ is 256 entries deep.
> > > > > Driver posted total of 256 descriptors.
> > > > > Each descriptor points to a page of 4K.
> > > > > These descriptors are chained as 4K * 16.
> > > >
> > > > So without indirect then? with indirect each descriptor can point to
> > > > 16 entries.
> > > >
> > > With indirect, can it post 256 * 16 size buffers even though vq depth is 256
> > entries?
> > > I recall that total number of descriptors with direct/indirect descriptors is
> > limited to vq depth.
> > 
> > 
> > > Was there some recent clarification occurred in the spec to clarify this?
> > 
> > 
> > This would make INDIRECT completely pointless.  So I don't think we ever
> > had such a limitation.
> > The only thing that comes to mind is this:
> > 
> > 	A driver MUST NOT create a descriptor chain longer than the Queue
> > Size of
> > 	the device.
> > 
> > but this limits individual chain length not the total length of all chains.
> > 
> Right.
> I double checked in virtqueue_add_split() which doesn't count table entries towards desc count of VQ for indirect case.
> 
> With indirect descriptors without this patch the situation is even worse with memory usage.
> Driver will allocate 64K * 256 = 16MB buffer per VQ, while needed (and used) buffer is only 2.3 Mbytes.

Yes. So just so we understand the reason for the performance improvement
is this because of memory usage? Or is this because device does not
have INDIRECT?

Thanks,

-- 
MST

