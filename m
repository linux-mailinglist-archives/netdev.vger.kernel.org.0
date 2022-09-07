Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0285B0724
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 16:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiIGOka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 10:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiIGOkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 10:40:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED7645F78
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 07:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662561621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1I+mmxEc4W8pgNyOHb25c63UJY3eA7dquqzLpsq3wXo=;
        b=SMvxR2B5+IMhxaDCx2pFLVL/y2lbT1WGWe3yLfSWN5eroRPBaksaZL8VLw8EEfdKg2iSlg
        FqLrdWngiUUQvU7cGvC+XkxmO/bLdTIzpxvECpQRXk+mOi9aDa4yDLbTwQX18mkIxBXvEG
        KLc/IVO5onCawDgoMgeQuaOm2SA07/E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-314-aSIIjWqPMIiXlL4m9KGUGg-1; Wed, 07 Sep 2022 10:40:20 -0400
X-MC-Unique: aSIIjWqPMIiXlL4m9KGUGg-1
Received: by mail-wr1-f70.google.com with SMTP id e2-20020adfc842000000b0022861d95e63so3159774wrh.14
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 07:40:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1I+mmxEc4W8pgNyOHb25c63UJY3eA7dquqzLpsq3wXo=;
        b=cVba883kaYACod9gUiPKVQtudn4BKDPB1F1/ByEfNJR4diMQFaPy5BGlB6w0HJJsdd
         SM5wXcuTB2d3h8ek/U0QxuLoHBTzi+bCPDbP1oWTz+aDkji4bXztQ9MVt4zzb/DODl2I
         RvhVA4xfiK+dZD3k30b42LV3kzg4ar93P01gNZ1zUz7rFRNFukSeUEKpNYtueAKKt+Qn
         cxYxAvBxULyiHijsZylS6nfvB/H1jt5FSeTz1abqEHLVQaFBIqPU0b/E/fFdtBrqtQe6
         aGJjkhHQ2pRQ1ULfoRz2HNfwi4bPkl4hB2Pdu7brMkjdTXOf49ZyZemRvvE8+OvffHpl
         4utA==
X-Gm-Message-State: ACgBeo1Ug5mPrafm2WMrOn3Ok/0gK7K3uY7cMHvt41DsFY7OOI8ZU2f8
        xMfl6+aIQBtKV3Q0t8Tntd7XMr29m3AlmCmSngD491lBUReys5kPyaD7D0oxgbVM+VjyCQWpefm
        rv+fkTEuY69JNGXjz
X-Received: by 2002:a5d:47aa:0:b0:226:dbf6:680c with SMTP id 10-20020a5d47aa000000b00226dbf6680cmr2325762wrb.581.1662561618398;
        Wed, 07 Sep 2022 07:40:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7Ar7DT/A/B1M/OnVG85xAlKMimAFPyKe5R4Ua4FXozjUSRQVqhm4XYKvyRiC8+NGb64xiXtQ==
X-Received: by 2002:a5d:47aa:0:b0:226:dbf6:680c with SMTP id 10-20020a5d47aa000000b00226dbf6680cmr2325743wrb.581.1662561618193;
        Wed, 07 Sep 2022 07:40:18 -0700 (PDT)
Received: from redhat.com ([2.52.135.118])
        by smtp.gmail.com with ESMTPSA id i4-20020a05600c354400b003a2f6367049sm21410320wmq.48.2022.09.07.07.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 07:40:17 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:40:13 -0400
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
Message-ID: <20220907103420-mutt-send-email-mst@kernel.org>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
 <20220907012608-mutt-send-email-mst@kernel.org>
 <0355d1e4-a3cf-5b16-8c7f-b39b1ec14ade@nvidia.com>
 <20220907052317-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54812EC7F4711C1EA4CAA119DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 02:33:02PM +0000, Parav Pandit wrote:
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Wednesday, September 7, 2022 10:30 AM
> 
> [..]
> > > > actually how does this waste space? Is this because your device does
> > > > not have INDIRECT?
> > > VQ is 256 entries deep.
> > > Driver posted total of 256 descriptors.
> > > Each descriptor points to a page of 4K.
> > > These descriptors are chained as 4K * 16.
> > 
> > So without indirect then? with indirect each descriptor can point to 16
> > entries.
> > 
> With indirect, can it post 256 * 16 size buffers even though vq depth is 256 entries?
> I recall that total number of descriptors with direct/indirect descriptors is limited to vq depth.


> Was there some recent clarification occurred in the spec to clarify this?


This would make INDIRECT completely pointless.  So I don't think we ever
had such a limitation.
The only thing that comes to mind is this:

	A driver MUST NOT create a descriptor chain longer than the Queue Size of
	the device.

but this limits individual chain length not the total length
of all chains.

We have an open bug that we forgot to include this requirement
in the packed ring documentation.

-- 
MST

