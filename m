Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D28581A8B
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 21:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbiGZTwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 15:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiGZTwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 15:52:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD5F73134F
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 12:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658865127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6CZKvjEOWarDPKvw674EQUQEiUqD5ev91Kf4ytKkJWM=;
        b=AaIRRL94sgYbEcAwlWyBWRhGcmTLUeqbiNWHNdYp2rDSEh6cPZzkn5in4lxNDJVWyT56zj
        gocn4BvLPK63SUJF65A+FYy2GcLZKvs86bUtQ1av9vhB5ATtBoV4D+NaJPAulfNbNeVzMk
        hEBRIUUgn2jHUyAtG44AREGBwJZx9Ho=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-2tZaqe4yNI22gjLtvItaig-1; Tue, 26 Jul 2022 15:52:06 -0400
X-MC-Unique: 2tZaqe4yNI22gjLtvItaig-1
Received: by mail-wm1-f71.google.com with SMTP id i184-20020a1c3bc1000000b003a026f48333so8041268wma.4
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 12:52:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=6CZKvjEOWarDPKvw674EQUQEiUqD5ev91Kf4ytKkJWM=;
        b=vBIL4n9YHFP46OmHtFqXPwhZkVc0EZcr0YNLo5Hx/dtTKryypO24BDL3s7c8VvbRes
         Zw4C1fLQB/5FXNIV7HSjItaN05MR2RTsSQa4AVw6Y75isEjear7lW3x+nKpEmjAUdhw8
         dm744tGqHgbbznxHkT0yBKwOz4rmOU036dV2mYkcZ+NmAyULW54+dTzdY2aCTZh2UNP3
         tFFNngUg0IIsHQYKSYYa0LJx2NvhFdnDO8NbzOxUBGCLARB9jKGlA8vqkuMtGtUnoiIY
         hQG0TJsjVrBfEF8Ysm1yfzjBc0BwvVuW4B1PY2KiTmPntrmBhuoNhpwqUBxM7uY09ioq
         ZOkg==
X-Gm-Message-State: AJIora8zkw4QomR/kEN/j18nlvsMGAipvqrJvxQm3t3o5hr70GLUeneM
        bS2MmzDV4mCzthHzEtdYee6xEs9L7ujph0DPtt1BESXlJhPqVhwkIKwQzz4jr6G7Bu1EDkSdnCo
        aYm7Fx7SmgmRa7Rln
X-Received: by 2002:a5d:46c7:0:b0:21e:3c82:2df with SMTP id g7-20020a5d46c7000000b0021e3c8202dfmr12145050wrs.519.1658865125315;
        Tue, 26 Jul 2022 12:52:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vDBuORhAbQFR+DTzJRgUoP8PjptZcpyG6r4ergrYBtY3opWPHGede0qqU+ohFSqoQtmnZbzA==
X-Received: by 2002:a5d:46c7:0:b0:21e:3c82:2df with SMTP id g7-20020a5d46c7000000b0021e3c8202dfmr12145024wrs.519.1658865124814;
        Tue, 26 Jul 2022 12:52:04 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7424:0:3d16:86dc:de54:5671])
        by smtp.gmail.com with ESMTPSA id i6-20020a5d5226000000b0021d6d9c0bd9sm15158827wra.82.2022.07.26.12.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 12:52:04 -0700 (PDT)
Date:   Tue, 26 Jul 2022 15:52:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Message-ID: <20220726154930-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ef1c42e8-2350-dd9c-c6c0-2e9bbe85adb4@intel.com>
 <PH0PR12MB5481FF0AE64F3BB24FF8A869DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 03:56:32PM +0000, Parav Pandit wrote:
> 
> > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > Sent: Tuesday, July 12, 2022 11:46 PM
> > > When the user space which invokes netlink commands, detects that _MQ
> > is not supported, hence it takes max_queue_pair = 1 by itself.
> > I think the kernel module have all necessary information and it is the only
> > one which have precise information of a device, so it should answer precisely
> > than let the user space guess. The kernel module should be reliable than stay
> > silent, leave the question to the user space tool.
> Kernel is reliable. It doesn’t expose a config space field if the field doesn’t exist regardless of field should have default or no default.
> User space should not guess either. User space gets to see if _MQ present/not present. If _MQ present than get reliable data from kernel.
> If _MQ not present, it means this device has one VQ pair.

Yes that's fine. And if we just didn't return anything without MQ that
would be fine.  But IIUC netlink reports the # of pairs regardless, it
just puts 0 there.

-- 
MST

