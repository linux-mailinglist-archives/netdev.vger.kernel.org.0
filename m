Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9555829F9
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 17:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiG0Psz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 11:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234157AbiG0Psw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 11:48:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C113649B59
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 08:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658936930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NGWBRPKhQ0fhVaizU+EBcoZQesGUO5nyCUz66Nsm49c=;
        b=JkDM3xC409Nh3MnuW25ubmOIe3IgYjup17WIrNOsfiHFWcHtvOvuH/8O+cyw0yi0GRq5sn
        bcw7DbSb1SyLjkJ+8KYlDsWixS9zz4hm9XrMFEmC0/eq1KUumXxwpYWBqJE/YUNEyqAqg+
        QZz1n2wLODK8/ew/Ji+RskC+wHYy8Hk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-ZBTiRp8xMFuBtt-wY0YejA-1; Wed, 27 Jul 2022 11:48:49 -0400
X-MC-Unique: ZBTiRp8xMFuBtt-wY0YejA-1
Received: by mail-wr1-f69.google.com with SMTP id t13-20020adfe10d000000b0021bae3def1eso3104840wrz.3
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 08:48:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=NGWBRPKhQ0fhVaizU+EBcoZQesGUO5nyCUz66Nsm49c=;
        b=ysXQgizu0PoOjUzObRpKGbH4UNR9S6uo64JR5+CjgKb5WCH1j7Sl+fMNTxfynsxqT8
         5GmmMxsQM1BEwRzrqIW/ZnrB9oRTC3aXJ2R6ZCkV9+Dj2dAvMLGA9tQt54fiZHVHTc5N
         QFvfOKDKshwKRH8Y4/VC6qhWQlalqBPu48o7InpD8Xv2gqjrkbBN0CtucBX73jVVofIE
         bJ7f939soIbFNGBar9SpRGNdZKl6mBMlMc5Sq6VZqGhwIM8pZV3W4GxLT5iFv6FAPyIT
         P/OXKoq3634OwNGRMLjQ8vEJCtjvsiBXFm7wcJHJj3xW+igBR5G14ebAfEsrvCv0DSih
         ZZfg==
X-Gm-Message-State: AJIora+ewp+qgkXOG0LvJmbI8aOKe558sizYtbu8Bn9wUFe2Mrn4Vk08
        9sv4OGC0WjEEw+U8bYFz0Uj078bmuEYMdCnwlCqkXintybUnbuFeUqTcA1yAm/PNdPBkzv9TXAa
        L4JpqyaNcQF3NggFq
X-Received: by 2002:a05:600c:410c:b0:3a3:2d78:f07f with SMTP id j12-20020a05600c410c00b003a32d78f07fmr3560385wmi.130.1658936928564;
        Wed, 27 Jul 2022 08:48:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1utiKu7DvaK8PDHamMkME+2Z3wyhvX8bXVnILjhxBYs/vzPTAen9awZCX2/C526G81ZXCP6dw==
X-Received: by 2002:a05:600c:410c:b0:3a3:2d78:f07f with SMTP id j12-20020a05600c410c00b003a32d78f07fmr3560359wmi.130.1658936928113;
        Wed, 27 Jul 2022 08:48:48 -0700 (PDT)
Received: from redhat.com ([2.52.132.243])
        by smtp.gmail.com with ESMTPSA id e10-20020adfe38a000000b0021b970a68f9sm621502wrm.26.2022.07.27.08.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 08:48:47 -0700 (PDT)
Date:   Wed, 27 Jul 2022 11:48:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Message-ID: <20220727114602-mutt-send-email-mst@kernel.org>
References: <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
 <66291287-fcb3-be8d-2c1b-dd44533ed8b3@oracle.com>
 <20220727050102-mutt-send-email-mst@kernel.org>
 <6d5b03ee-5362-8534-5881-a34c9ea626f0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d5b03ee-5362-8534-5881-a34c9ea626f0@oracle.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 03:09:43AM -0700, Si-Wei Liu wrote:
> 
> 
> On 7/27/2022 2:01 AM, Michael S. Tsirkin wrote:
> > On Wed, Jul 27, 2022 at 12:50:33AM -0700, Si-Wei Liu wrote:
> > > 
> > > On 7/26/2022 11:01 PM, Michael S. Tsirkin wrote:
> > > > On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> > > > > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > Sent: Tuesday, July 26, 2022 10:53 PM
> > > > > > 
> > > > > > On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > > > > > > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > > > Sent: Tuesday, July 26, 2022 10:15 PM
> > > > > > > > 
> > > > > > > > On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > > > > > > > > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > > > > > Sent: Tuesday, July 12, 2022 11:46 PM
> > > > > > > > > > > When the user space which invokes netlink commands, detects that
> > > > > > > > _MQ
> > > > > > > > > > is not supported, hence it takes max_queue_pair = 1 by itself.
> > > > > > > > > > I think the kernel module have all necessary information and it is
> > > > > > > > > > the only one which have precise information of a device, so it
> > > > > > > > > > should answer precisely than let the user space guess. The kernel
> > > > > > > > > > module should be reliable than stay silent, leave the question to
> > > > > > > > > > the user space
> > > > > > > > tool.
> > > > > > > > > Kernel is reliable. It doesn’t expose a config space field if the
> > > > > > > > > field doesn’t
> > > > > > > > exist regardless of field should have default or no default.
> > > > > > > > so when you know it is one queue pair, you should answer one, not try
> > > > > > > > to guess.
> > > > > > > > > User space should not guess either. User space gets to see if _MQ
> > > > > > > > present/not present. If _MQ present than get reliable data from kernel.
> > > > > > > > > If _MQ not present, it means this device has one VQ pair.
> > > > > > > > it is still a guess, right? And all user space tools implemented this
> > > > > > > > feature need to guess
> > > > > > > No. it is not a guess.
> > > > > > > It is explicitly checking the _MQ feature and deriving the value.
> > > > > > > The code you proposed will be present in the user space.
> > > > > > > It will be uniform for _MQ and 10 other features that are present now and
> > > > > > in the future.
> > > > > > MQ and other features like RSS are different. If there is no _RSS_XX, there
> > > > > > are no attributes like max_rss_key_size, and there is not a default value.
> > > > > > But for MQ, we know it has to be 1 wihtout _MQ.
> > > > > "we" = user space.
> > > > > To keep the consistency among all the config space fields.
> > > > Actually I looked and the code some more and I'm puzzled:
> > > > 
> > > > 
> > > > 	struct virtio_net_config config = {};
> > > > 	u64 features;
> > > > 	u16 val_u16;
> > > > 
> > > > 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> > > > 
> > > > 	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> > > > 		    config.mac))
> > > > 		return -EMSGSIZE;
> > > > 
> > > > 
> > > > Mac returned even without VIRTIO_NET_F_MAC
> > > > 
> > > > 
> > > > 	val_u16 = le16_to_cpu(config.status);
> > > > 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> > > > 		return -EMSGSIZE;
> > > > 
> > > > 
> > > > status returned even without VIRTIO_NET_F_STATUS
> > > > 
> > > > 	val_u16 = le16_to_cpu(config.mtu);
> > > > 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> > > > 		return -EMSGSIZE;
> > > > 
> > > > 
> > > > MTU returned even without VIRTIO_NET_F_MTU
> > > > 
> > > > 
> > > > What's going on here?
> > > > 
> > > > 
> > > I guess this is spec thing (historical debt), I vaguely recall these fields
> > > are always present in config space regardless the existence of corresponding
> > > feature bit.
> > > 
> > > -Siwei
> > Nope:
> > 
> > 2.5.1  Driver Requirements: Device Configuration Space
> > 
> > ...
> > 
> > For optional configuration space fields, the driver MUST check that the corresponding feature is offered
> > before accessing that part of the configuration space.
> Well, this is driver side of requirement.


Well driver and device are the only two entities in the spec.

> As this interface is for host
> admin tool to query or configure vdpa device, we don't have to wait until
> feature negotiation is done on guest driver to extract vdpa
> attributes/parameters, say if we want to replicate another vdpa device with
> the same config on migration destination. I think what may need to be fix is
> to move off from using .vdpa_get_config_unlocked() which depends on feature
> negotiation. And/or expose config space register values through another set
> of attributes.
> 
> -Siwei
> 
> 

Sounds like something that might use the proposed admin queue maybe.
Hope that makes progress ...


-- 
MST

