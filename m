Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C455B0699
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 16:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiIGOad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 10:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiIGOaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 10:30:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3F6224
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 07:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662560998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MoUHys1NJY1cE4G48Sz0iIP7SXECYYGzs4Ze1KZp2/s=;
        b=i6IVvxc4x4Aa2RbE9dORS+fQdZXA+pju4oZeR5nE5vxot4BB4pmaNFaL37HMyad5RfF3nV
        pIpcVcqhgZ6XXyOPB5etdcXgX2ER4J6yOaUMOtApjJmD5OtngRtWhNUjmaSYuggLxj2VA0
        jGEY67EP8CZG4dS3J9qDQSTSnuzrNUU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-4sMOidqnM5-Ru6SNHuH26Q-1; Wed, 07 Sep 2022 10:29:57 -0400
X-MC-Unique: 4sMOidqnM5-Ru6SNHuH26Q-1
Received: by mail-wr1-f70.google.com with SMTP id c14-20020adfa30e000000b00228655c4208so3002517wrb.1
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 07:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=MoUHys1NJY1cE4G48Sz0iIP7SXECYYGzs4Ze1KZp2/s=;
        b=y3EYYPONQcQT0R86CWoH4APq0SGRqHHOho/I4r37BxwvYwoIKZ893ylvXl4THIpHYm
         EfR2+bDn1KXHwmO8a8QpVtFpwduSFT/RnuaFOYeLmaGKT5F74lm/iUmIEnSIheemieQB
         M8dAaXSdUeTr3BaqnJgobsafiEIWAqCv1bJ6wiLgvu7HkSpoqKcREP8F9pSOM+IjKBYL
         oJFl6k+/9A4Bo4EUqwaMr3qkbKJI/zrmE+PuA9WQqgVqzL9zXjVZRWLUhxWRa9BtzpWv
         U9oZbZdNtT1wYQFu9oA9DodiGo3tZzYD6YGSsOm/Ecd9B4hHj6tyiW5iBUI2Tyw7vSn9
         Hzvw==
X-Gm-Message-State: ACgBeo2cawzjkJuyj+JBCPzwQ32GV9SxH7Sxw1V4uwEYSZdoZoahGH7J
        qAkK2WBXvl5ZImTF1f7AA2CHpWlLanQN7XZO2VAUYsVhim5w0ysQU+xSEz5PDKNVMaXX3VnuDra
        hOvF6/i2YH2IagUv/
X-Received: by 2002:a05:6000:1245:b0:228:6aa7:dbb2 with SMTP id j5-20020a056000124500b002286aa7dbb2mr2429208wrx.77.1662560996458;
        Wed, 07 Sep 2022 07:29:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6uBFNaKZ8WzHJqqF93TRlwkGSRikP4atFIcAqZemkXVub+w1K7DukaThEBIPlHPmnmzeKp+g==
X-Received: by 2002:a05:6000:1245:b0:228:6aa7:dbb2 with SMTP id j5-20020a056000124500b002286aa7dbb2mr2429195wrx.77.1662560996203;
        Wed, 07 Sep 2022 07:29:56 -0700 (PDT)
Received: from redhat.com ([2.52.135.118])
        by smtp.gmail.com with ESMTPSA id bt24-20020a056000081800b0022377df817fsm18034503wrb.58.2022.09.07.07.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 07:29:55 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:29:50 -0400
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
Message-ID: <20220907101335-mutt-send-email-mst@kernel.org>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
 <20220907012608-mutt-send-email-mst@kernel.org>
 <0355d1e4-a3cf-5b16-8c7f-b39b1ec14ade@nvidia.com>
 <20220907052317-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54812EC7F4711C1EA4CAA119DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH0PR12MB54812EC7F4711C1EA4CAA119DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 02:08:18PM +0000, Parav Pandit wrote:
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Wednesday, September 7, 2022 5:27 AM
> > 
> > On Wed, Sep 07, 2022 at 04:08:54PM +0800, Gavin Li wrote:
> > >
> > > On 9/7/2022 1:31 PM, Michael S. Tsirkin wrote:
> > > > External email: Use caution opening links or attachments
> > > >
> > > >
> > > > On Thu, Sep 01, 2022 at 05:10:38AM +0300, Gavin Li wrote:
> > > > > Currently add_recvbuf_big() allocates MAX_SKB_FRAGS segments for
> > > > > big packets even when GUEST_* offloads are not present on the
> > device.
> > > > > However, if guest GSO is not supported, it would be sufficient to
> > > > > allocate segments to cover just up the MTU size and no further.
> > > > > Allocating the maximum amount of segments results in a large waste
> > > > > of buffer space in the queue, which limits the number of packets
> > > > > that can be buffered and can result in reduced performance.
> > 
> > actually how does this waste space? Is this because your device does not
> > have INDIRECT?
> VQ is 256 entries deep.
> Driver posted total of 256 descriptors.
> Each descriptor points to a page of 4K.
> These descriptors are chained as 4K * 16.

So without indirect then? with indirect each descriptor can
point to 16 entries.

> So total packets that can be serviced are 256/16 = 16.
> So effective queue depth = 16.
> 
> So, when GSO is off, for 9K mtu, packet buffer needed = 3 pages. (12k).
> So, 13 descriptors (= 13 x 4K =52K) per packet buffer is wasted.
> 
> After this improvement, these 13 descriptors are available, increasing the effective queue depth = 256/3 = 85.
> 
> [..]
> > > > >
> > > > > MTU(Bytes)/Bandwidth (Gbit/s)
> > > > >               Before   After
> > > > >    1500        22.5     22.4
> > > > >    9000        12.8     25.9
> > 
> > 
> > is this buffer space?
> Above performance numbers are showing improvement in bandwidth. In Gbps/sec.
> 
> > just the overhead of allocating/freeing the buffers?
> > of using INDIRECT?
> The effective queue depth is so small, device cannot receive all the packets at given bw-delay product.
> 
> > > >
> > > > Which configurations were tested?
> > > I tested it with DPDK vDPA + qemu vhost. Do you mean the feature set
> > > of the VM?
> > 
> The configuration of interest is mtu, not the backend.
> Which is different mtu as shown in above perf numbers.
> 
> > > > Did you test devices without VIRTIO_NET_F_MTU ?
> > > No.  It will need code changes.
> No. It doesn't need any code changes. This is misleading/vague.
> 
> This patch doesn't have any relation to a device which doesn't offer VIRTIO_NET_F_MTU.
> Just the code restructuring is touching this area, that may require some existing tests.
> I assume virtio tree will have some automation tests for such a device?

I have some automated tests but I also expect developer to do testing.

> > > > >
> > > > > @@ -3853,12 +3866,10 @@ static int virtnet_probe(struct
> > > > > virtio_device *vdev)
> > > > >
> > > > >                dev->mtu = mtu;
> > > > >                dev->max_mtu = mtu;
> > > > > -
> > > > > -             /* TODO: size buffers correctly in this case. */
> > > > > -             if (dev->mtu > ETH_DATA_LEN)
> > > > > -                     vi->big_packets = true;
> > > > >        }
> > > > >
> > > > > +     virtnet_set_big_packets_fields(vi, mtu);
> > > > > +
> > > > If VIRTIO_NET_F_MTU is off, then mtu is uninitialized.
> > > > You should move it to within if () above to fix.
> > > mtu was initialized to 0 at the beginning of probe if VIRTIO_NET_F_MTU
> > > is off.
> > >
> > > In this case,  big_packets_num_skbfrags will be set according to guest gso.
> > >
> > > If guest gso is supported, it will be set to MAX_SKB_FRAGS else
> > > zero---- do you
> > >
> > > think this is a bug to be fixed?
> > 
> > 
> > yes I think with no mtu this should behave as it did historically.
> > 
> Michael is right.
> It should behave as today. There is no new bug introduced by this patch.
> dev->mtu and dev->max_mtu is set only when VIRTIO_NET_F_MTU is offered with/without this patch.
> 
> Please have mtu related fix/change in different patch.
> 
> > > >
> > > > >        if (vi->any_header_sg)
> > > > >                dev->needed_headroom = vi->hdr_len;
> > > > >
> > > > > --
> > > > > 2.31.1

