Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A4D6147E0
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 11:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiKAKql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 06:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKAKqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 06:46:39 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DC1193C7;
        Tue,  1 Nov 2022 03:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667299599; x=1698835599;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=uituX6EfEuLj0s1j7ECFATXPhjO7z9j9nwhPYjeinlY=;
  b=czdMxmH9sVFQG2XnQE1F2wdaRawkPy56yUOkWj4VIBDw/AOtnm5Uy3Yu
   QXaH2l/HVNrGGzTrIVB7PG3HALHQsyYlgp7AdVwkHimWRoR/OLm65WoAM
   cKpro8FCEzF2VbF5er0bE6R0cVWhyhnoN8zh7eGvBEwIXU5TNEJgYo0Ho
   K+e4QM4kKRhM9cPl1URLZxCCeBbyeMyFLZjg6U+fRpoRlJDhJXyCmqwuQ
   mrPGJ+e9+0x+Xj+/ez/YAcWrsxLFPm860RPZHVQCfxfSUnClr+VkwULgB
   ofsuryZ7LxdKbknTTWJJQK05N+ArDrdouNCfxwEsZoJJ7CoMh1PW4S4ac
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="310816950"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="310816950"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 03:46:38 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="739288553"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="739288553"
Received: from rsimofi-mobl.ger.corp.intel.com (HELO localhost) ([10.252.30.2])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 03:46:35 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Cai Huoqing <cai.huoqing@linux.dev>, kuba@kernel.org
Cc:     Cai Huoqing <cai.huoqing@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        SeongJae Park <sj@kernel.org>,
        Bin Chen <bin.chen@corigine.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: hinic: Add control command support
 for VF PMD driver in DPDK
In-Reply-To: <20221101060358.7837-2-cai.huoqing@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221101060358.7837-1-cai.huoqing@linux.dev>
 <20221101060358.7837-2-cai.huoqing@linux.dev>
Date:   Tue, 01 Nov 2022 12:46:32 +0200
Message-ID: <87iljz7y0n.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Nov 2022, Cai Huoqing <cai.huoqing@linux.dev> wrote:
> HINIC has a mailbox for PF-VF communication and the VF driver
> could send port control command to PF driver via mailbox.
>
> The control command only can be set to register in PF,
> so add support in PF driver for VF PMD driver control
> command when VF PMD driver work with linux PF driver.
>
> Then there is no need to add handlers to nic_vf_cmd_msg_handler[],
> because the host driver just forwards it to the firmware.
> Actually the firmware works on a coprocessor MGMT_CPU(inside the NIC)
> which will recv and deal with these commands.
>
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>

Out of curiosity, what exactly compelled you to Cc me on this particular
patch? I mean there aren't a whole lot of places in the kernel that
would be more off-topic for me. :)

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
