Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DE4596BE5
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbiHQJOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiHQJOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:14:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42E95B7BD;
        Wed, 17 Aug 2022 02:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660727644; x=1692263644;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dlo8resWXHE77ag0jMUKXP8GvM2DlEojgRS8O8VitQs=;
  b=VR+Pa3fPoUDpwCTtXghAmHYDhaAe0yCEBuToKmFa3hD4e5GB1bKtcazb
   C8lDkvZE+COzvTYFQMDlXpknZCZD0cpruv/sqwwqOSGAKCT7LvkBWSnzs
   ue12El4mw7E9p71XYWRsnTvz7D6s375Jfme9OjNxiygM7HdkopCcupf6U
   ikQEAOkU9tgMBsGaDepIg3ocXZ6BXCwQEFwYHeWmTiMWdENI9LbXkmN5M
   tlwxlLGmSWNK+5IivfFbFBvTdOX5xhoOeoMr7dCnVp+uMjI43thHABJ3Z
   /1ZjfScg5ReG8A86MqKSZKsjf30SQhKRkzNTXEkZuLBsZxFaviVWjUniS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="378738041"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="378738041"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 02:14:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="667528658"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.30.246]) ([10.255.30.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 02:14:02 -0700
Message-ID: <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
Date:   Wed, 17 Aug 2022 17:13:59 +0800
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
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220817045406-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
>> Yes it is a little messy, and we can not check _F_VERSION_1 because of
>> transitional devices, so maybe this is the best we can do for now
> I think vhost generally needs an API to declare config space endian-ness
> to kernel. vdpa can reuse that too then.
Yes, I remember you have mentioned some IOCTL to set the endian-ness,
for vDPA, I think only the vendor driver knows the endian,
so we may need a new function vdpa_ops->get_endian().

In the last thread, we say maybe it's better to add a comment for now.
But if you think we should add a vdpa_ops->get_endian(), I can work
on it for sure!

Thanks
Zhu Lingshan
>

