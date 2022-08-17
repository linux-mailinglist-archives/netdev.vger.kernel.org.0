Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD08596C41
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbiHQJnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiHQJnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:43:35 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5509C6390;
        Wed, 17 Aug 2022 02:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660729413; x=1692265413;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UMzEsXBvLajAWw0qWAMJSiqZbYfa41i/NdTJQCTDMwQ=;
  b=JOVMR2JGuzzxXCwk0v/bocmP3R0lXloQLvGNmoyoNRa5xgvQPVz+knD2
   B+oMxZCVJ6/VvX+WzF0nMJmubJLRnOSqBJkFqbZKN74hfLpxh8x5+oiEP
   zuvuiVK5xUbii182G9YejqGKGTkZGdEwtnmFo5V3swqKVmG24M/R7dgvu
   HRnhbZ2c2npoPr7YThWYXOHpo+pNAvpi3e+RQLRFtLDd6Ivv2qDsRxiP4
   Ng1fvBd26nPB2LgIGUJhEri2JZlUhhEgB0xYmNhtLTB4QMCivVNP5qP4K
   8VVxIYmUHP+CR9EVNQgZTnELjLwauZRWZ7ymBjIZF5NvCeD31CjGAd3qp
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="292447810"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="292447810"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 02:43:27 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="667539581"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.30.246]) ([10.255.30.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 02:43:25 -0700
Message-ID: <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com>
Date:   Wed, 17 Aug 2022 17:43:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
 <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
 <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
 <20220817053821-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220817053821-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
>>
>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
>>>> Yes it is a little messy, and we can not check _F_VERSION_1 because of
>>>> transitional devices, so maybe this is the best we can do for now
>>> I think vhost generally needs an API to declare config space endian-ness
>>> to kernel. vdpa can reuse that too then.
>> Yes, I remember you have mentioned some IOCTL to set the endian-ness,
>> for vDPA, I think only the vendor driver knows the endian,
>> so we may need a new function vdpa_ops->get_endian().
>> In the last thread, we say maybe it's better to add a comment for now.
>> But if you think we should add a vdpa_ops->get_endian(), I can work
>> on it for sure!
>>
>> Thanks
>> Zhu Lingshan
> I think QEMU has to set endian-ness. No one else knows.
Yes, for SW based vhost it is true. But for HW vDPA, only
the device & driver knows the endian, I think we can not
"set" a hardware's endian.

So if you think we should add a vdpa_ops->get_endian(),
I will drop these comments in the next version of
series, and work on a new patch for get_endian().

Thanks,
Zhu Lingshan
>

