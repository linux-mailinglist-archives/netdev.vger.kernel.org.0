Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC5F5829E8
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 17:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbiG0Ppy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 11:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiG0Ppw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 11:45:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A45922299
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 08:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658936750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o5Z5mK4bBTNHE1Hrnus23LuaetCSMzbXo8U4tgW3Uug=;
        b=TA2/9pdGJJX0pcsVWYvRsepW2DvnE3HMOUepvJFf0/ItQQWmjbD5qwxzOQPExoZM14rLEN
        3lH1+YcgF3hPS0F1181Ir7uQLFyL/H5+zWDTHDxFzEZKa9o+pW0JxxiKcXIKxUcsSrWWjx
        zJWJ7ye7ouaOqEp+qLTui/YFVZFd+h8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-wfenCt61OSidISdFZMxzkQ-1; Wed, 27 Jul 2022 11:45:49 -0400
X-MC-Unique: wfenCt61OSidISdFZMxzkQ-1
Received: by mail-wr1-f70.google.com with SMTP id t13-20020adfe10d000000b0021bae3def1eso3099511wrz.3
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 08:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=o5Z5mK4bBTNHE1Hrnus23LuaetCSMzbXo8U4tgW3Uug=;
        b=7ccbrDG6ULx7IAeF1dLKyqdrvmDlze4eTfpZvOQ6Yb7YDFLVpkOsQeBky5RbmryAx2
         tNBAnSIAu+FZvNLoAhiMATSA7O+lZUCttHi9fk2z/mxKv2S7BIEd88Alg2bVI4bYHu8u
         2rBg6ZumxaqE7YC3FQMDk1j3m436UvS98lrZmM577zQdYgAePHFlJF5BshQbWO4jZ6Rm
         XVzW4Ny8BPHEb7qayq1CHMvCU0YA+CxcOaKms61QcYcTwlT7mS4gBbhUKWyuFxRhFd5Q
         U5/9MfrcdAUNHTjAEDHsMT2ay0uBXlL7XsBnRQQ3QtY7V2BJKHIh6fsY+PdX2rOUHi7j
         EyMw==
X-Gm-Message-State: AJIora+qiZ/iAUFgX6ehk8EVOaW05Qk9qYD/Tnr41eTOm53MUjRmSKdF
        LvJt83bVjy57IOcbWDRVY5z7rmpM1awsIb2weUhMcPdGYaMMDEU3Ed9bei72BSAhQhhgNdF8ZwF
        vv9cu9RkMSX4WODD5
X-Received: by 2002:adf:fd42:0:b0:21e:4357:3f38 with SMTP id h2-20020adffd42000000b0021e43573f38mr14305530wrs.620.1658936747690;
        Wed, 27 Jul 2022 08:45:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sn2LcWK0FEjuooFusX6mom51Dfi0VsB51W4X3fJT9i5PzY53tHwJhmFAZ9La2UW1Hd6GOjJw==
X-Received: by 2002:adf:fd42:0:b0:21e:4357:3f38 with SMTP id h2-20020adffd42000000b0021e43573f38mr14305507wrs.620.1658936747379;
        Wed, 27 Jul 2022 08:45:47 -0700 (PDT)
Received: from redhat.com ([2.52.132.243])
        by smtp.gmail.com with ESMTPSA id f11-20020adfe90b000000b0021e43650e6asm17825915wrm.86.2022.07.27.08.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 08:45:46 -0700 (PDT)
Date:   Wed, 27 Jul 2022 11:45:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Message-ID: <20220727114419-mutt-send-email-mst@kernel.org>
References: <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
 <CACGkMEv62tuOP3ra0GBhjCH=syFWxP+GVfGL_i0Ce0iD4uMY=Q@mail.gmail.com>
 <20220727050222-mutt-send-email-mst@kernel.org>
 <CACGkMEtDFUGX17giwYdF58QJ1ccZJDJg1nFVDkSeB27sfZz28g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtDFUGX17giwYdF58QJ1ccZJDJg1nFVDkSeB27sfZz28g@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 05:50:59PM +0800, Jason Wang wrote:
> On Wed, Jul 27, 2022 at 5:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jul 27, 2022 at 02:54:13PM +0800, Jason Wang wrote:
> > > On Wed, Jul 27, 2022 at 2:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> > > > >
> > > > > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > Sent: Tuesday, July 26, 2022 10:53 PM
> > > > > >
> > > > > > On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > > > > > >> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > >> Sent: Tuesday, July 26, 2022 10:15 PM
> > > > > > >>
> > > > > > >> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > > > > > >>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > >>>> Sent: Tuesday, July 12, 2022 11:46 PM
> > > > > > >>>>> When the user space which invokes netlink commands, detects that
> > > > > > >> _MQ
> > > > > > >>>> is not supported, hence it takes max_queue_pair = 1 by itself.
> > > > > > >>>> I think the kernel module have all necessary information and it is
> > > > > > >>>> the only one which have precise information of a device, so it
> > > > > > >>>> should answer precisely than let the user space guess. The kernel
> > > > > > >>>> module should be reliable than stay silent, leave the question to
> > > > > > >>>> the user space
> > > > > > >> tool.
> > > > > > >>> Kernel is reliable. It doesn’t expose a config space field if the
> > > > > > >>> field doesn’t
> > > > > > >> exist regardless of field should have default or no default.
> > > > > > >> so when you know it is one queue pair, you should answer one, not try
> > > > > > >> to guess.
> > > > > > >>> User space should not guess either. User space gets to see if _MQ
> > > > > > >> present/not present. If _MQ present than get reliable data from kernel.
> > > > > > >>> If _MQ not present, it means this device has one VQ pair.
> > > > > > >> it is still a guess, right? And all user space tools implemented this
> > > > > > >> feature need to guess
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
> > > >
> > > > Actually I looked and the code some more and I'm puzzled:
> > > >
> > > >
> > > >         struct virtio_net_config config = {};
> > > >         u64 features;
> > > >         u16 val_u16;
> > > >
> > > >         vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> > > >
> > > >         if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> > > >                     config.mac))
> > > >                 return -EMSGSIZE;
> > > >
> > > >
> > > > Mac returned even without VIRTIO_NET_F_MAC
> > > >
> > > >
> > > >         val_u16 = le16_to_cpu(config.status);
> > > >         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> > > >                 return -EMSGSIZE;
> > > >
> > > >
> > > > status returned even without VIRTIO_NET_F_STATUS
> > > >
> > > >         val_u16 = le16_to_cpu(config.mtu);
> > > >         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> > > >                 return -EMSGSIZE;
> > > >
> > > >
> > > > MTU returned even without VIRTIO_NET_F_MTU
> > > >
> > > >
> > > > What's going on here?
> > >
> > > Probably too late to fix, but this should be fine as long as all
> > > parents support STATUS/MTU/MAC.
> >
> > Why is this too late to fix.
> 
> If we make this conditional on the features. This may break the
> userspace that always expects VDPA_ATTR_DEV_NET_CFG_MTU?
> 
> Thanks

Well only on devices without MTU. I'm saying said userspace
was reading trash on such devices anyway.
We don't generally maintain bug for bug compatiblity on a whim,
only if userspace is actually known to break if we fix a bug.


> >
> > > I wonder if we can add a check in the core and fail the device
> > > registration in this case.
> > >
> > > Thanks
> > >
> > > >
> > > >
> > > > --
> > > > MST
> > > >
> >

