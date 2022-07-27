Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36225581FB2
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiG0GB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiG0GBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:01:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08FD8B499
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658901684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8xtXdluvgXBSpfS+jXxthX445YwgzUazMcxwBGlNiPo=;
        b=Gnddv+waQTykhZpK65Qiyv44AaxsodPt0eERf78FbvXMxKHr47gVYMMG20WDwfqrbqOs6Q
        9RDp2XMquhryfdggWOb0mGETM1O6N4q5qPdwrCkPZjRomwbKcPxRgSIdxam7pd5yQKbSzJ
        bl6l6q0EnE6tEr7Ms8sEmLxOq5CAUto=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-F33YBDDeO9-2Tb1-NqHljg-1; Wed, 27 Jul 2022 02:01:22 -0400
X-MC-Unique: F33YBDDeO9-2Tb1-NqHljg-1
Received: by mail-wm1-f70.google.com with SMTP id r82-20020a1c4455000000b003a300020352so8608568wma.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=8xtXdluvgXBSpfS+jXxthX445YwgzUazMcxwBGlNiPo=;
        b=k4rHvM2ovKVVPPii55K2bxTEqV4n0tHvg+9um4pcnizxG12fGn0IJP6rhfL2ohC4dN
         sv9ESod6OFtK9D3GWvvSCIbmZCkg25N6XgzlHSOo3w3faCanAekOsS+yRupMfUkutBNP
         xdwXJ5on9JCjJ2g/fSZYkFXDcIr9DF45TPk85+M44BDflXgwRAoOD7fh5OEtR/Zd+h4O
         4/kN8uqGg5ovSlsba4Nl/zng1bw8l0UfdCBQfJwIhtCz8rjceYjqMuaeACvVJJzIAXUI
         ePVCtZOcw0WL6Mle+QS3KwmxUp5AlsNcVb5UVJf1We26UYOUwNRS5qKVumLtj5NmlWpi
         mdEQ==
X-Gm-Message-State: AJIora9Dk+gfaozT8akqhbZsYS1Y4fm+kU0vPBqNOT9R/PfGmIsocC+V
        IkxHsxc1u1SpK4OgD/5jCaIENQDQYCDNFoFZWskDQx7w9lFWSWMcTyiz07g25BnnmxlJncfpWzU
        O3vozeqxaZOk13WwU
X-Received: by 2002:a5d:4650:0:b0:21e:9ddc:12c with SMTP id j16-20020a5d4650000000b0021e9ddc012cmr4689277wrs.596.1658901681370;
        Tue, 26 Jul 2022 23:01:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vOTbqWpRU/40fypnlbnuUalUXC628tK3i1DrsZNBw0v1zxLs5MSuXJ/M5aG8OlYITs8NAf9w==
X-Received: by 2002:a5d:4650:0:b0:21e:9ddc:12c with SMTP id j16-20020a5d4650000000b0021e9ddc012cmr4689262wrs.596.1658901681084;
        Tue, 26 Jul 2022 23:01:21 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7424:0:3d16:86dc:de54:5671])
        by smtp.gmail.com with ESMTPSA id q2-20020adff502000000b0021ece43e1besm690698wro.114.2022.07.26.23.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 23:01:20 -0700 (PDT)
Date:   Wed, 27 Jul 2022 02:01:17 -0400
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
Message-ID: <20220727015626-mutt-send-email-mst@kernel.org>
References: <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> 
> > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > Sent: Tuesday, July 26, 2022 10:53 PM
> > 
> > On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > >> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > >> Sent: Tuesday, July 26, 2022 10:15 PM
> > >>
> > >> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > >>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > >>>> Sent: Tuesday, July 12, 2022 11:46 PM
> > >>>>> When the user space which invokes netlink commands, detects that
> > >> _MQ
> > >>>> is not supported, hence it takes max_queue_pair = 1 by itself.
> > >>>> I think the kernel module have all necessary information and it is
> > >>>> the only one which have precise information of a device, so it
> > >>>> should answer precisely than let the user space guess. The kernel
> > >>>> module should be reliable than stay silent, leave the question to
> > >>>> the user space
> > >> tool.
> > >>> Kernel is reliable. It doesn’t expose a config space field if the
> > >>> field doesn’t
> > >> exist regardless of field should have default or no default.
> > >> so when you know it is one queue pair, you should answer one, not try
> > >> to guess.
> > >>> User space should not guess either. User space gets to see if _MQ
> > >> present/not present. If _MQ present than get reliable data from kernel.
> > >>> If _MQ not present, it means this device has one VQ pair.
> > >> it is still a guess, right? And all user space tools implemented this
> > >> feature need to guess
> > > No. it is not a guess.
> > > It is explicitly checking the _MQ feature and deriving the value.
> > > The code you proposed will be present in the user space.
> > > It will be uniform for _MQ and 10 other features that are present now and
> > in the future.
> > MQ and other features like RSS are different. If there is no _RSS_XX, there
> > are no attributes like max_rss_key_size, and there is not a default value.
> > But for MQ, we know it has to be 1 wihtout _MQ.
> "we" = user space.
> To keep the consistency among all the config space fields.

Actually I looked and the code some more and I'm puzzled:


	struct virtio_net_config config = {};
	u64 features;
	u16 val_u16;

	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));

	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
		    config.mac))
		return -EMSGSIZE;


Mac returned even without VIRTIO_NET_F_MAC


	val_u16 = le16_to_cpu(config.status);
	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
		return -EMSGSIZE;


status returned even without VIRTIO_NET_F_STATUS

	val_u16 = le16_to_cpu(config.mtu);
	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
		return -EMSGSIZE;


MTU returned even without VIRTIO_NET_F_MTU


What's going on here?


-- 
MST

