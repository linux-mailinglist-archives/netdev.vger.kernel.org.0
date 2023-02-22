Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62B269F384
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 12:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjBVLjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 06:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjBVLi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 06:38:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F42F227AF
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 03:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677065892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OOrjE79P0ibWh7OPv+FSVRu3Yy2o4wjQCW+0gG81NzY=;
        b=PATQS+Nk51r8eiAGzMKnLiziG9CV/lXLAD1xOSb1Pp22nx32EU8prrmMZNqls9OY4iHJxP
        dz+OppIFk2w59dHZ9PZtI9WG9guAwV39H+VoDIO9eoiR7RqU46OJIS+gnxQB99yjJ9uf7q
        ks0+hH3x/ZnU6gGkIzCdqTgRrj05uc4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-386-ORE3_SB_N9eFi9uEkIVj3A-1; Wed, 22 Feb 2023 06:38:05 -0500
X-MC-Unique: ORE3_SB_N9eFi9uEkIVj3A-1
Received: by mail-wr1-f71.google.com with SMTP id v18-20020adfedd2000000b002c3f0a93825so1757940wro.15
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 03:38:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OOrjE79P0ibWh7OPv+FSVRu3Yy2o4wjQCW+0gG81NzY=;
        b=mmZsQzODdUDYOi+MCducHrN69xzzjKslSCvkMrLSzBuAxDXgtCuuQb+ThmLKzkV+7y
         In7eEJOkkp9rG8aG3dKXJcJGM2qvD/IB8OPKe8sbXK77dzAxL6qVRb2w0ChLf6Tipu66
         PCoML1ziVQIegEfbuO82BynsFfPGjFOiV0NyILJwBWpHQcVcVkv8kIYjT1iBx/eXTZ6A
         plBNtBXmMS+322kK6YMu1Y7MjyMGHgdbDaJI9K6B8+2At9PnmsenpYubtBYv8HNzAE/w
         zuHAEUmzN0EkxRTpFtdIQJCmEribmU+i7E9VTyGF4soa9KYHSZcrMFQb0NBgqLsx2yPR
         ee4Q==
X-Gm-Message-State: AO0yUKW4LYqFOzKdPtQ2E2XYokg46z9RF6mesFK38G6gTL0Ork7oZATL
        ETBffC1Up5PaDQrqL1LZ2jB9Bc8DhF8Sjg30whIkghmHV5K1EN10qYTSLteBG+z7XUl57WWe54a
        EaL7MNrPj0zD5JdeJioj2rw==
X-Received: by 2002:a05:600c:1c0a:b0:3dc:506e:6559 with SMTP id j10-20020a05600c1c0a00b003dc506e6559mr6195465wms.37.1677065883983;
        Wed, 22 Feb 2023 03:38:03 -0800 (PST)
X-Google-Smtp-Source: AK7set/mEISrFwRQZyNMEpEp28SRuugQRmPj6ucCor9H4EXIsxbKnHXb7JH3wydkT98q79isOlapqQ==
X-Received: by 2002:a05:600c:1c0a:b0:3dc:506e:6559 with SMTP id j10-20020a05600c1c0a00b003dc506e6559mr6195450wms.37.1677065883620;
        Wed, 22 Feb 2023 03:38:03 -0800 (PST)
Received: from redhat.com ([2.52.2.78])
        by smtp.gmail.com with ESMTPSA id t6-20020a1c7706000000b003e1fee8baacsm6713672wmi.25.2023.02.22.03.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 03:38:03 -0800 (PST)
Date:   Wed, 22 Feb 2023 06:37:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     =?utf-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, jasowang@redhat.com,
        =?utf-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Subject: Re: [PATCH 2/2] net/packet: send and receive pkt with given
 vnet_hdr_sz
Message-ID: <20230222063242-mutt-send-email-mst@kernel.org>
References: <1675946595-103034-3-git-send-email-amy.saq@antgroup.com>
 <20230209080612-mutt-send-email-mst@kernel.org>
 <858f8db1-c107-1ac5-bcbc-84e0d36c981d@antgroup.com>
 <20230210030710-mutt-send-email-mst@kernel.org>
 <63e665348b566_1b03a820873@willemb.c.googlers.com.notmuch>
 <d759d787-4d76-c8e1-a5e2-233a097679b1@antgroup.com>
 <63eb9a7fe973e_310218208b4@willemb.c.googlers.com.notmuch>
 <a737c617-6722-7002-1ead-4c5bed452595@antgroup.com>
 <63f4dd3b98f0c_cdc03208ea@willemb.c.googlers.com.notmuch>
 <4b431f19-b5f2-6704-318e-6bde113a3e0a@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b431f19-b5f2-6704-318e-6bde113a3e0a@antgroup.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 04:04:34PM +0800, 沈安琪(凛玥) wrote:
> 
> 在 2023/2/21 下午11:03, Willem de Bruijn 写道:
> > 沈安琪(凛玥) wrote:
> > > 在 2023/2/14 下午10:28, Willem de Bruijn 写道:
> > > > 沈安琪(凛玥) wrote:
> > > > > 在 2023/2/10 下午11:39, Willem de Bruijn 写道:
> > > > > > Michael S. Tsirkin wrote:
> > > > > > > On Fri, Feb 10, 2023 at 12:01:03PM +0800, 沈安琪(凛玥) wrote:
> > > > > > > > 在 2023/2/9 下午9:07, Michael S. Tsirkin 写道:
> > > > > > > > > On Thu, Feb 09, 2023 at 08:43:15PM +0800, 沈安琪(凛玥) wrote:
> > > > > > > > > > From: "Jianfeng Tan" <henry.tjf@antgroup.com>
> > > > > > > > > > 
> > > > > > > > > > When raw socket is used as the backend for kernel vhost, currently it
> > > > > > > > > > will regard the virtio net header as 10-byte, which is not always the
> > > > > > > > > > case since some virtio features need virtio net header other than
> > > > > > > > > > 10-byte, such as mrg_rxbuf and VERSION_1 that both need 12-byte virtio
> > > > > > > > > > net header.
> > > > > > > > > > 
> > > > > > > > > > Instead of hardcoding virtio net header length to 10 bytes, tpacket_snd,
> > > > > > > > > > tpacket_rcv, packet_snd and packet_recvmsg now get the virtio net header
> > > > > > > > > > size that is recorded in packet_sock to indicate the exact virtio net
> > > > > > > > > > header size that virtio user actually prepares in the packets. By doing
> > > > > > > > > > so, it can fix the issue of incorrect mac header parsing when these
> > > > > > > > > > virtio features that need virtio net header other than 10-byte are
> > > > > > > > > > enable.
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> > > > > > > > > > Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> > > > > > > > > > Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> > > > > > > > > Does it handle VERSION_1 though? That one is also LE.
> > > > > > > > > Would it be better to pass a features bitmap instead?
> > > > > > > > Thanks for quick reply!
> > > > > > > > 
> > > > > > > > I am a little confused abot what "LE" presents here?
> > > > > > > LE == little_endian.
> > > > > > > Little endian format.
> > > > > > > 
> > > > > > > > For passing a features bitmap to af_packet here, our consideration is
> > > > > > > > whether it will be too complicated for af_packet to understand the virtio
> > > > > > > > features bitmap in order to get the vnet header size. For now, all the
> > > > > > > > virtio features stuff is handled by vhost worker and af_packet actually does
> > > > > > > > not need to know much about virtio features. Would it be better if we keep
> > > > > > > > the virtio feature stuff in user-level and let user-level tell af_packet how
> > > > > > > > much space it should reserve?
> > > > > > > Presumably, we'd add an API in include/linux/virtio_net.h ?
> > > > > > Better leave this opaque to packet sockets if they won't act on this
> > > > > > type info.
> > > > > > This patch series probably should be a single patch btw. As else the
> > > > > > socket option introduced in the first is broken at that commit, since
> > > > > > the behavior is only introduced in patch 2.
> > > > > Good point, will merge this patch series into one patch.
> > > > > 
> > > > > 
> > > > > Thanks for Michael's enlightening advice, we plan to modify current UAPI
> > > > > change of adding an extra socketopt from only setting vnet header size
> > > > > only to setting a bit-map of virtio features, and implement another
> > > > > helper function in include/linux/virtio_net.h to parse the feature
> > > > > bit-map. In this case, packet sockets have no need to understand the
> > > > > feature bit-map but only pass this bit-map to virtio_net helper and get
> > > > > back the information, such as vnet header size, it needs.
> > > > > 
> > > > > This change will make the new UAPI more general and avoid further
> > > > > modification if there are more virtio features to support in the future.
> > > > > 
> > > > Please also comment how these UAPI extension are intended to be used.
> > > > As that use is not included in this initial patch series.
> > > > 
> > > > If the only intended user is vhost-net, we can consider not exposing
> > > > outside the kernel at all. That makes it easier to iterate if
> > > > necessary (no stable ABI) and avoids accidentally opening up new
> > > > avenues for bugs and exploits (syzkaller has a history with
> > > > virtio_net_header options).
> > > 
> > > Our concern is, it seems there is no other solution than uapi to let
> > > packet sockets know the vnet header size they should use.
> > > 
> > > Receiving packets in vhost driver, implemented in drivers/vhost/net.c:
> > > 1109 handle_rx(), will abstract the backend device it uses and directly
> > > invoke the corresponding socket ops with no extra information indicating
> > > it is invoked by vhost worker. Vhost worker actually does not know the
> > > type of backend device it is using; only virito-user knows what type of
> > > backend device it uses. Therefore, it seems impossible to let vhost set
> > > the vnet header information to the target backend device.
> > > 
> > > Tap, another kind of backend device vhost may use, lets virtio-user set
> > > whether it needs vnet header and how long the vnet header is through
> > > ioctl. (implemented in drivers/net/tap.c:1066)
> > > 
> > > In this case, we wonder whether we should align with what tap does and
> > > set vnet hdr size through setsockopt for packet_sockets.
> > > 
> > > We really appreciate suggestions on if any, potential approachs to pass
> > > this vnet header size information from virtio-user to packet-socket.
> > You're right. This is configured from userspace before the FD is passed
> > to vhost-net, so indeed this will require packet socket UAPI support.
> 
> 
> Thanks for quick reply. We will go with adding an extra UAPI here then.
> 
> 
> Another discussion for designing this UAPI is, whether it will be better to
> support setting only vnet header size, just like what TAP does in its ioctl,
> or to support setting a virtio feature bit-map.
> 
> 
> UAPI setting only vnet header size
> 
> Pros:
> 
> 1. It aligns with how other virito backend devices communicate with
> virtio-user
> 
> 2. We can use the holes in struct packet_socket (net/packet/internal.h:120)
> to record the extra information since the size info only takes 8 bits.
> 
> Cons:
> 
> 1. It may have more information that virtio-user needs to communicate with
> packet socket in the future and needs to add more UAPI supports here.
> 
> To Michael: Is there any other information that backend device needs and
> will be given from virtio-user?


Yes e.g. I already mentioned virtio 1.0 wrt LE versus native endian
format.


> 
> UAPI setting a virtio feature bit-map
> 
> Pros:
> 
> 1. It is more general and may reduce future UAPI changes.
> 
> Cons:
> 
> 1. A virtio feature bit-map needs 64 bits, which needs to add an extra field
> in packet_sock struct
> 
> 2. Virtio-user needs to aware that using packet socket as backend supports
> different approach to negotiate the vnet header size.
> 
> 
> We really appreciate any suggestion or discussion on this design choice of
> UAPI.

In the end it's ok with just size too, you just probably shouldn't say
you support VERSION_1 if you are not passing that bit.

-- 
MST

