Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E0158229E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiG0JCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiG0JCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:02:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F04B013E87
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658912521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnz/l1vyI26hB+xzTJcH/see5OEfLpEz0rao0B1ZdFA=;
        b=JTP0rAr/KJTqHWi8xWIhdK6Rfir8QPpXuGtGj0GcXHfyynWuivusx8bGnKatglf8cfS+H2
        h8GfgZLQ61tpS5PJiCxyQo7+ph2HpSlmq7SQLYnJtOVI/+vqUxoUUlGG+BYfsl6Mj25CR+
        66AZYxgI+UGca6hP9CjTK/LizBb1A4c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-azST3R0-NpmD_GS0aJhndw-1; Wed, 27 Jul 2022 05:01:59 -0400
X-MC-Unique: azST3R0-NpmD_GS0aJhndw-1
Received: by mail-wm1-f72.google.com with SMTP id r10-20020a05600c284a00b003a2ff6c9d6aso877165wmb.4
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=fnz/l1vyI26hB+xzTJcH/see5OEfLpEz0rao0B1ZdFA=;
        b=rNmIwTlrIvN+okkeJaNBRHshzLjq78aKypT20WgwR5Kcx2Unoy1f+meUoXNBsbD4tt
         j4gfqytz2QZMpQF6oDqQTrO8+8cKaIZiITGDBBA8I/iPfMcgOBC2uDZlk0oDbKPU8GiG
         tF1hsNNpNtEGaFW8KhcHjYQfzdXb6bHHFfEe9Q4SGQk7yLZ3YRqagkQqZYDIJUzfmTKO
         wTdsTs5rq9viRnS281Zj7gFj4uSArnFy+nedbAYmGxj0iZ1KWz5y34VC88Nq/GI7jk7T
         1i1OIVXH+UBsdGmA4LJEX3LI4ImI35/d5J5v3E2ufvoGA94fm9RxaBuehJALC/p7npd7
         VFxg==
X-Gm-Message-State: AJIora/k4LbIk4hHxf73LY4mhk/ygNMeeKL0X3P12kI1/dmpXMLvMq1Q
        Ax2ioG1er9YaqLB55D5zqBFnjvmgxmKp1SDHppy5XauwDnkm8rE+h4cII0kZUk5LUQ0zxrPzRA5
        pzzemkJtDaeAmiPhf
X-Received: by 2002:adf:de0d:0:b0:21d:66a1:ad4d with SMTP id b13-20020adfde0d000000b0021d66a1ad4dmr13502456wrm.17.1658912518394;
        Wed, 27 Jul 2022 02:01:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tVHx8Qq4yGkkemZ0F7sscnPqzddBsU8pEYcy1hR1jX0pHa/ArofkEzuzCBxPnilQlg8zqdGw==
X-Received: by 2002:adf:de0d:0:b0:21d:66a1:ad4d with SMTP id b13-20020adfde0d000000b0021d66a1ad4dmr13502441wrm.17.1658912518175;
        Wed, 27 Jul 2022 02:01:58 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7424:0:3d16:86dc:de54:5671])
        by smtp.gmail.com with ESMTPSA id l25-20020a05600c1d1900b003a33227e49bsm1781904wms.4.2022.07.27.02.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 02:01:57 -0700 (PDT)
Date:   Wed, 27 Jul 2022 05:01:46 -0400
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
Message-ID: <20220727050102-mutt-send-email-mst@kernel.org>
References: <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
 <66291287-fcb3-be8d-2c1b-dd44533ed8b3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66291287-fcb3-be8d-2c1b-dd44533ed8b3@oracle.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 12:50:33AM -0700, Si-Wei Liu wrote:
> 
> 
> On 7/26/2022 11:01 PM, Michael S. Tsirkin wrote:
> > On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> > > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > Sent: Tuesday, July 26, 2022 10:53 PM
> > > > 
> > > > On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > > > > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > Sent: Tuesday, July 26, 2022 10:15 PM
> > > > > > 
> > > > > > On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > > > > > > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > > > Sent: Tuesday, July 12, 2022 11:46 PM
> > > > > > > > > When the user space which invokes netlink commands, detects that
> > > > > > _MQ
> > > > > > > > is not supported, hence it takes max_queue_pair = 1 by itself.
> > > > > > > > I think the kernel module have all necessary information and it is
> > > > > > > > the only one which have precise information of a device, so it
> > > > > > > > should answer precisely than let the user space guess. The kernel
> > > > > > > > module should be reliable than stay silent, leave the question to
> > > > > > > > the user space
> > > > > > tool.
> > > > > > > Kernel is reliable. It doesn’t expose a config space field if the
> > > > > > > field doesn’t
> > > > > > exist regardless of field should have default or no default.
> > > > > > so when you know it is one queue pair, you should answer one, not try
> > > > > > to guess.
> > > > > > > User space should not guess either. User space gets to see if _MQ
> > > > > > present/not present. If _MQ present than get reliable data from kernel.
> > > > > > > If _MQ not present, it means this device has one VQ pair.
> > > > > > it is still a guess, right? And all user space tools implemented this
> > > > > > feature need to guess
> > > > > No. it is not a guess.
> > > > > It is explicitly checking the _MQ feature and deriving the value.
> > > > > The code you proposed will be present in the user space.
> > > > > It will be uniform for _MQ and 10 other features that are present now and
> > > > in the future.
> > > > MQ and other features like RSS are different. If there is no _RSS_XX, there
> > > > are no attributes like max_rss_key_size, and there is not a default value.
> > > > But for MQ, we know it has to be 1 wihtout _MQ.
> > > "we" = user space.
> > > To keep the consistency among all the config space fields.
> > Actually I looked and the code some more and I'm puzzled:
> > 
> > 
> > 	struct virtio_net_config config = {};
> > 	u64 features;
> > 	u16 val_u16;
> > 
> > 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> > 
> > 	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> > 		    config.mac))
> > 		return -EMSGSIZE;
> > 
> > 
> > Mac returned even without VIRTIO_NET_F_MAC
> > 
> > 
> > 	val_u16 = le16_to_cpu(config.status);
> > 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> > 		return -EMSGSIZE;
> > 
> > 
> > status returned even without VIRTIO_NET_F_STATUS
> > 
> > 	val_u16 = le16_to_cpu(config.mtu);
> > 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> > 		return -EMSGSIZE;
> > 
> > 
> > MTU returned even without VIRTIO_NET_F_MTU
> > 
> > 
> > What's going on here?
> > 
> > 
> I guess this is spec thing (historical debt), I vaguely recall these fields
> are always present in config space regardless the existence of corresponding
> feature bit.
> 
> -Siwei

Nope:

2.5.1  Driver Requirements: Device Configuration Space

...

For optional configuration space fields, the driver MUST check that the corresponding feature is offered
before accessing that part of the configuration space.


-- 
MST

