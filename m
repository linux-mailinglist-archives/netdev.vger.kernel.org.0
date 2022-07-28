Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D64583D63
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiG1L3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiG1L3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:29:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C4A4C8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659007739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cZB1NG+wVsDb0xqERERb42QqEfgIFEymoWIE95OHxNE=;
        b=Oy00/r6MZDqaeBl8Qckd3Q5hFyco1JL9jybNudhxK0q36kR3CZbFR+T3u7IFfLTcrh0CDM
        Nd1XLMVfm3EJ7H8r6hvkTzk+xvhAynf42wQzLUUm3PoHnLC2j/HPZdgu0fLjZ+hsQOuKkI
        jzgIy5Eh/yr3atiz1nJaqV3eAKU/IIk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-01p_wwiKMfiFcG6gG4EPfQ-1; Thu, 28 Jul 2022 07:28:58 -0400
X-MC-Unique: 01p_wwiKMfiFcG6gG4EPfQ-1
Received: by mail-wm1-f69.google.com with SMTP id 189-20020a1c02c6000000b003a2d01897e4so816497wmc.9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:28:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=cZB1NG+wVsDb0xqERERb42QqEfgIFEymoWIE95OHxNE=;
        b=KuYYZ2+gP2qL/prZHrpgLEDjmj3q1tO7msId8prfIeiYvlfCi8ICkG5eH6UAm1lu9T
         9NpxiHhQoe6/YjnxEJxVZ2zv1ZGkHWX4PdfKOiIaLVkEtCRNbdiwPupjDJbNUWnhiuQ+
         qcys4w3ScSDes/4WRLHRRcmcDIIPDfDaSw2YibCiq6t0OesNGqX2iUY4sGl/F61P1ynN
         JrjNb6ZfAPYGMqEvIjqFWfzCtkKluiZOAHVCtexePCLSXll0qC1N6YwPMDdnxkHQgH6N
         0260Bgg5w5mRWsEt6ytcR5ssTl1MKUd4TkarRKA4iKe3DM663tWocq0kAgla0lhnsZav
         qmgQ==
X-Gm-Message-State: AJIora8xN77Q0G8p13SLlRYAGxSkV7e0YF1AmM9HyYb8EFrcoaH/Ebds
        JbYGMp5jg5FfQYiIARvDWzCjLSm32c1GCGMysz1uwnlpMG0VOtTZbhoHGt2fzX9df4+qkIXjl0Z
        EpGxGlfLJxl501K9j
X-Received: by 2002:a5d:6e88:0:b0:21a:3403:9aa0 with SMTP id k8-20020a5d6e88000000b0021a34039aa0mr17809330wrz.379.1659007736928;
        Thu, 28 Jul 2022 04:28:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vxboBdk2/f/LHiGoeMb/B/17fMKTO59R2yOdFyOV29cB/H+Dp+idgxc+NPtGMu/logDW1VrA==
X-Received: by 2002:a5d:6e88:0:b0:21a:3403:9aa0 with SMTP id k8-20020a5d6e88000000b0021a34039aa0mr17809298wrz.379.1659007736541;
        Thu, 28 Jul 2022 04:28:56 -0700 (PDT)
Received: from redhat.com ([2.54.183.236])
        by smtp.gmail.com with ESMTPSA id j10-20020adff54a000000b0021eddf38b2asm781887wrp.41.2022.07.28.04.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 04:28:55 -0700 (PDT)
Date:   Thu, 28 Jul 2022 07:28:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        virtio-comment@lists.oasis-open.org, virtio@lists.oasis-open.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: spec clarification (was Re: [PATCH V3 4/6] vDPA: !FEATURES_OK
 should not block querying device config space)
Message-ID: <20220728072137-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-5-lingshan.zhu@intel.com>
 <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00889067-50ac-d2cd-675f-748f171e5c83@oracle.com>
 <63242254-ba84-6810-dad8-34f900b97f2f@intel.com>
 <8002554a-a77c-7b25-8f99-8d68248a741d@oracle.com>
 <c8bd5396-84f2-e782-79d7-f493aca95781@redhat.com>
 <f3fd203d-a3ad-4c36-ddbc-01f061f4f99e@oracle.com>
 <CACGkMEtvVOtqAgY4Yzt_4=t8yfGJho4d9C=X8MQhW0ZKw1sDNA@mail.gmail.com>
 <2dfff5f3-3100-4a63-6da3-3e3d21ffb364@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dfff5f3-3100-4a63-6da3-3e3d21ffb364@oracle.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 01:20:26AM -0700, Si-Wei Liu wrote:
> Hi Michael,
> 
> Could you please comment on the different wording between "exist" and "valid"
> in spec? Having seen quite a few relevant discussions regarding MTU validation
> and VERSION_1 negotiation on s390, I was in the impression this is not the
> first time people getting confused because of ambiguity of random wording
> without detailed example helping to clarify around the context, or due lack of
> clear definition set ahead. I like your idea to keep things consistent
> (conditional depending on feature presence), however, without proper
> interpretation of how spec is supposed to work, we are on a slippery slope
> towards inconsistency.
> 
> On 7/28/2022 12:36 AM, Jason Wang wrote:
> 
>         And looking at:
> 
>         "The mac address field always exists (though is only valid if
>         VIRTIO_NET_F_MAC is set), and status only exists if VIRTIO_NET_F_STATUS
>         is set."
> 
>         It appears to me there's a border line set between "exist" and "valid".
>         If I understand the spec wording correctly, a spec-conforming device
>         implementation may or may not offer valid status value in the config
>         space when VIRTIO_NET_F_STATUS is offered, but before the feature is
>         negotiated.
> 
>     That's not what I read, maybe Michael can clarify this.
> 
> 
> 
> And Jason and I find below normatives are conflict with each other.
> 
>         "The device MUST allow reading of any device-specific configuration
>         field before FEATURES_OK is set by the driver. This includes fields
>         which are conditional on feature bits, as long as those feature bits are
>         offered by the device."


So I proposed this back in April:

https://lists.oasis-open.org/archives/virtio-comment/202201/msg00068.html

I intended this for 1.2 but it quickly became clear it won't make it
in time. Working on reviving the proposal and addressing the comments.




> 
>     ...
> 
>         And also there are special cases where the read of specific
>         configuration space field MUST be deferred to until FEATURES_OK is set:
> 
>         "If the VIRTIO_BLK_F_CONFIG_WCE feature is negotiated, the cache mode
>         can be read or set through the writeback field. 0 corresponds to a
>         writethrough cache, 1 to a writeback cache11. The cache mode after reset
>         can be either writeback or writethrough. The actual mode can be
>         determined by reading writeback after feature negotiation."
>         "The driver MUST NOT read writeback before setting the FEATURES_OK
>         device status bit."
> 
>     This seems to conflict with the normatives I quoted above, and I don't
>     get why we need this.
> 
> 
> 
> Thanks,
> -Siwei


The last one I take to mean writeback is special.
I am not sure why it should be. Paolo you proposed this text could
you comment please?

Thanks!

-- 
MST

