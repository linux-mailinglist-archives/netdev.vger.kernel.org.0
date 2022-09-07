Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEA85B0062
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiIGJ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIGJ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:26:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407FC7EFFC
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 02:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662542800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0YqY98OOdpwJPpqkeTlOBIKos4yfiX6vJ0r50FwcjCY=;
        b=VqTX3PvtKmPhB9wk7rg7jkOQvleqW6CI4kHrexi0D2eQnh/WA1MjUxtu4C9edNhheE0lSs
        Ht4E32blMa0t0hBcDkFmx0bnGpUQoViE1w2IOzdXskkdE8Sf/TIEBMwNGXD3Psh85WM6Xq
        kPnt9TLQrwbEJNLVmSIMSXNcvp0Vz5A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-495-yZMRsySNNReHYqaZBH1qJg-1; Wed, 07 Sep 2022 05:26:39 -0400
X-MC-Unique: yZMRsySNNReHYqaZBH1qJg-1
Received: by mail-ej1-f71.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso4625344ejb.14
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 02:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0YqY98OOdpwJPpqkeTlOBIKos4yfiX6vJ0r50FwcjCY=;
        b=Di0fLA8PoZdWAXeB0iOVoCJPYVY350QNwwenptG9FSlVzi89kTcf0JzCZ+592/tD38
         RIQ+XlwlgaTZTu5iXUyGFGTEvB4ZpI50FPC4WpKQabI/GBNJnZD8xNej1HJIMUQSor6L
         h3YlDz9Gkhfe7TmNXI1rTMPB+LCnf71aahXjuljDW1YY+ZB8dGgK4F0cx0LQQ4DjNfOZ
         C4IVZbKuyaB+dnWsBxOWPFndkwyhzyOotcp3QxkHCZhTiLaJFtrdrLFQnPh7tMTmMXM7
         BncFsvGyXbEDrh5UansxODblbflHN45yHnCWMGrMoL67CCNxoClSKjOmfyMGbMFXzbi6
         kNiA==
X-Gm-Message-State: ACgBeo1lMbb+irLnpWLdjYxVlV0C1q2OxnRT1e2eu7BakxPRjM9/U4kT
        FG1KF8Yzl3R+pjMXQnTuohqK1ArtSEgELGaVoh7ncimMcOgyQcZ+kEV0bmy5Rs/DrE9NGEUgjSl
        xkEQbi+XF68IP7biq
X-Received: by 2002:a17:906:8a70:b0:730:9c9e:edb2 with SMTP id hy16-20020a1709068a7000b007309c9eedb2mr1728845ejc.41.1662542798031;
        Wed, 07 Sep 2022 02:26:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4L/fSV1pEM10gy1elhCNdmY3LbDKgfX0Th9sVFkt5011rnXIzUPG7wLtJ0VCFBv1rbM1LCJw==
X-Received: by 2002:a17:906:8a70:b0:730:9c9e:edb2 with SMTP id hy16-20020a1709068a7000b007309c9eedb2mr1728828ejc.41.1662542797748;
        Wed, 07 Sep 2022 02:26:37 -0700 (PDT)
Received: from redhat.com ([2.52.135.118])
        by smtp.gmail.com with ESMTPSA id w21-20020aa7dcd5000000b0044f0a2b9363sm1351048edu.41.2022.09.07.02.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 02:26:37 -0700 (PDT)
Date:   Wed, 7 Sep 2022 05:26:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, alexander.h.duyck@intel.com,
        kuba@kernel.org, sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, gavi@nvidia.com, parav@nvidia.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Message-ID: <20220907052317-mutt-send-email-mst@kernel.org>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
 <20220907012608-mutt-send-email-mst@kernel.org>
 <0355d1e4-a3cf-5b16-8c7f-b39b1ec14ade@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0355d1e4-a3cf-5b16-8c7f-b39b1ec14ade@nvidia.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 04:08:54PM +0800, Gavin Li wrote:
> 
> On 9/7/2022 1:31 PM, Michael S. Tsirkin wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Thu, Sep 01, 2022 at 05:10:38AM +0300, Gavin Li wrote:
> > > Currently add_recvbuf_big() allocates MAX_SKB_FRAGS segments for big
> > > packets even when GUEST_* offloads are not present on the device.
> > > However, if guest GSO is not supported, it would be sufficient to
> > > allocate segments to cover just up the MTU size and no further.
> > > Allocating the maximum amount of segments results in a large waste of
> > > buffer space in the queue, which limits the number of packets that can
> > > be buffered and can result in reduced performance.

actually how does this waste space? Is this because your
device does not have INDIRECT?

> > > 
> > > Therefore, if guest GSO is not supported, use the MTU to calculate the
> > > optimal amount of segments required.
> > > 
> > > When guest offload is enabled at runtime, RQ already has packets of bytes
> > > less than 64K. So when packet of 64KB arrives, all the packets of such
> > > size will be dropped. and RQ is now not usable.
> > > 
> > > So this means that during set_guest_offloads() phase, RQs have to be
> > > destroyed and recreated, which requires almost driver reload.
> > > 
> > > If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS has been negotiated, then it should
> > > always treat them as GSO enabled.
> > > 
> > > Accordingly, for now the assumption is that if guest GSO has been
> > > negotiated then it has been enabled, even if it's actually been disabled
> > > at runtime through VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > > 
> > > Below is the iperf TCP test results over a Mellanox NIC, using vDPA for
> > > 1 VQ, queue size 1024, before and after the change, with the iperf
> > > server running over the virtio-net interface.
> > > 
> > > MTU(Bytes)/Bandwidth (Gbit/s)
> > >               Before   After
> > >    1500        22.5     22.4
> > >    9000        12.8     25.9


is this buffer space?
just the overhead of allocating/freeing the buffers?
of using INDIRECT?


> > > 
> > > Signed-off-by: Gavin Li <gavinl@nvidia.com>
> > > Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> > > Reviewed-by: Parav Pandit <parav@nvidia.com>
> > > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > 
> > Which configurations were tested?
> I tested it with DPDK vDPA + qemu vhost. Do you mean the feature set of the
> VM?

yes

> > Did you test devices without VIRTIO_NET_F_MTU ?
> No.  It will need code changes.


Testing to make sure nothing broke should not require changes.

> > 
> > > ---
> > > changelog:
> > > v4->v5
> > > - Addressed comments from Michael S. Tsirkin
> > > - Improve commit message
> > > v3->v4
> > > - Addressed comments from Si-Wei
> > > - Rename big_packets_sg_num with big_packets_num_skbfrags
> > > v2->v3
> > > - Addressed comments from Si-Wei
> > > - Simplify the condition check to enable the optimization
> > > v1->v2
> > > - Addressed comments from Jason, Michael, Si-Wei.
> > > - Remove the flag of guest GSO support, set sg_num for big packets and
> > >    use it directly
> > > - Recalculate sg_num for big packets in virtnet_set_guest_offloads
> > > - Replace the round up algorithm with DIV_ROUND_UP
> > > ---
> > >   drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++-------------
> > >   1 file changed, 24 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index f831a0290998..dbffd5f56fb8 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -225,6 +225,9 @@ struct virtnet_info {
> > >        /* I like... big packets and I cannot lie! */
> > >        bool big_packets;
> > > 
> > > +     /* number of sg entries allocated for big packets */
> > > +     unsigned int big_packets_num_skbfrags;
> > > +
> > >        /* Host will merge rx buffers for big packets (shake it! shake it!) */
> > >        bool mergeable_rx_bufs;
> > > 
> > > @@ -1331,10 +1334,10 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
> > >        char *p;
> > >        int i, err, offset;
> > > 
> > > -     sg_init_table(rq->sg, MAX_SKB_FRAGS + 2);
> > > +     sg_init_table(rq->sg, vi->big_packets_num_skbfrags + 2);
> > > 
> > > -     /* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
> > > -     for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
> > > +     /* page in rq->sg[vi->big_packets_num_skbfrags + 1] is list tail */
> > > +     for (i = vi->big_packets_num_skbfrags + 1; i > 1; --i) {
> > >                first = get_a_page(rq, gfp);
> > >                if (!first) {
> > >                        if (list)
> > > @@ -1365,7 +1368,7 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
> > > 
> > >        /* chain first in list head */
> > >        first->private = (unsigned long)list;
> > > -     err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
> > > +     err = virtqueue_add_inbuf(rq->vq, rq->sg, vi->big_packets_num_skbfrags + 2,
> > >                                  first, gfp);
> > >        if (err < 0)
> > >                give_pages(rq, first);
> > > @@ -3690,13 +3693,27 @@ static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
> > >                virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
> > >   }
> > > 
> > > +static void virtnet_set_big_packets_fields(struct virtnet_info *vi, const int mtu)
> > 
> > I'd rename this to just virtnet_set_big_packets.
> ACK
> > 
> > 
> > > +{
> > > +     bool guest_gso = virtnet_check_guest_gso(vi);
> > > +
> > > +     /* If device can receive ANY guest GSO packets, regardless of mtu,
> > > +      * allocate packets of maximum size, otherwise limit it to only
> > > +      * mtu size worth only.
> > > +      */
> > > +     if (mtu > ETH_DATA_LEN || guest_gso) {
> > > +             vi->big_packets = true;
> > > +             vi->big_packets_num_skbfrags = guest_gso ? MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
> > > +     }
> > > +}
> > > +
> > >   static int virtnet_probe(struct virtio_device *vdev)
> > >   {
> > >        int i, err = -ENOMEM;
> > >        struct net_device *dev;
> > >        struct virtnet_info *vi;
> > >        u16 max_queue_pairs;
> > > -     int mtu;
> > > +     int mtu = 0;
> > > 
> > >        /* Find if host supports multiqueue/rss virtio_net device */
> > >        max_queue_pairs = 1;
> > > @@ -3784,10 +3801,6 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >        INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > >        spin_lock_init(&vi->refill_lock);
> > > 
> > > -     /* If we can receive ANY GSO packets, we must allocate large ones. */
> > > -     if (virtnet_check_guest_gso(vi))
> > > -             vi->big_packets = true;
> > > -
> > >        if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> > >                vi->mergeable_rx_bufs = true;
> > > 
> > > @@ -3853,12 +3866,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > 
> > >                dev->mtu = mtu;
> > >                dev->max_mtu = mtu;
> > > -
> > > -             /* TODO: size buffers correctly in this case. */
> > > -             if (dev->mtu > ETH_DATA_LEN)
> > > -                     vi->big_packets = true;
> > >        }
> > > 
> > > +     virtnet_set_big_packets_fields(vi, mtu);
> > > +
> > If VIRTIO_NET_F_MTU is off, then mtu is uninitialized.
> > You should move it to within if () above to fix.
> mtu was initialized to 0 at the beginning of probe if VIRTIO_NET_F_MTU is
> off.
> 
> In this case,  big_packets_num_skbfrags will be set according to guest gso.
> 
> If guest gso is supported, it will be set to MAX_SKB_FRAGS else zero---- do
> you
> 
> think this is a bug to be fixed?


yes I think with no mtu this should behave as it did
historically.

> > 
> > >        if (vi->any_header_sg)
> > >                dev->needed_headroom = vi->hdr_len;
> > > 
> > > --
> > > 2.31.1

