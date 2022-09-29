Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135BE5EEEE7
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbiI2HYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbiI2HYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:24:14 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481E2118B18;
        Thu, 29 Sep 2022 00:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664436232; x=1695972232;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=51Zl+NOBedzejTddDYPD6LxG7uWtRAFlIesrelk0QbU=;
  b=ZiGIl+WGhKKPd/G9cYZnceLXZ6JGPmvtZgP6iMxHKa49v3t1gk6z+MT+
   2qYILAXu4BAZr3ScWF0YF+mMHK+ws+QN0WrEegpNd0fyHCKoNmsUmu8YG
   Wicg3i/910GVFpKXn9DPjHDhOpav4JF4arA1b2U2SFyZ6cdaNIHlk7NTN
   AKia5uT7hIiQY/1XeLbnC3AogIKgPhe1OHtBDflQYL5HMq6DoJzzsZWKe
   vgeQzrNgw534LWJRvKWjHDRVJVHYbd+gwVaOh7OIkY90D98vcl1bwm1MQ
   ZM5FFejbYUwPOmfA36Q78H9wBYbezIYx0QqrcpGoZD810/mSB2wK4r1Jb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="328191761"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="328191761"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:23:51 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="573352319"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="573352319"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.168.227]) ([10.249.168.227])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:23:48 -0700
Message-ID: <896fe0b9-5da2-2bc6-0e46-219aa4b9f44f@intel.com>
Date:   Thu, 29 Sep 2022 15:23:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [PATCH V3 0/6] Conditionally read fields in dev cfg space
Content-Language: en-US
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220929014555.112323-1-lingshan.zhu@intel.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220929014555.112323-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

Jason starts his vacation this afternoon, and next week is our national 
holiday.
He has acked 3 ~ 6 of this series before, and I have made improvements 
based on his comments.
Do you have any comments on patches 1 and 2?

Thanks,
Zhu Lingshan
On 9/29/2022 9:45 AM, Zhu Lingshan wrote:
> This series intends to read the fields in virtio-net device
> configuration space conditionally on the feature bits,
> this means:
>
> MTU exists if VIRTIO_NET_F_MTU is set
> MAC exists if VIRTIO_NET_F_NET is set
> MQ exists if VIRTIO_NET_F_MQ or VIRTIO_NET_F_RSS is set.
>
> This series report device features to userspace and invokes
> vdpa_config_ops.get_config() rather than
> vdpa_get_config_unlocked() to read the device config spcae,
> so no races in vdpa_set_features_unlocked()
>
> Thanks!
>
> Changes form V2:
> remove unnacessary checking for vdev->config->get_status (Jason)
>
> Changes from V1:
> 1)Better comments for VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,
> only in the header file(Jason)
> 2)Split original 3/4 into separate patches(Jason)
> 3)Check FEATURES_OK for reporting driver features
> in vdpa_dev_config_fill (Jason)
> 4) Add iproute2 example for reporting device features
>
> Zhu Lingshan (6):
>    vDPA: allow userspace to query features of a vDPA device
>    vDPA: only report driver features if FEATURES_OK is set
>    vDPA: check VIRTIO_NET_F_RSS for max_virtqueue_paris's presence
>    vDPA: check virtio device features to detect MQ
>    vDPA: fix spars cast warning in vdpa_dev_net_mq_config_fill
>    vDPA: conditionally read MTU and MAC in dev cfg space
>
>   drivers/vdpa/vdpa.c       | 68 ++++++++++++++++++++++++++++++---------
>   include/uapi/linux/vdpa.h |  4 +++
>   2 files changed, 56 insertions(+), 16 deletions(-)
>

