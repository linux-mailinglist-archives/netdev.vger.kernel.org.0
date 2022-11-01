Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4113614AD8
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiKAMhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiKAMhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:37:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D09417E19;
        Tue,  1 Nov 2022 05:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667306265; x=1698842265;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=MC0hjxXwoWGv6hRCe3TqMTJ1teb2vm+7SSO2Mzd4qB4=;
  b=b3tR/HnLlOSBd3EpImSkLYXbXS335z+Y5vxqEB+B/eBimpt9br/KRMzd
   KXo9RHNt5Lp7qp6tfyfxdN0UD44UMaXOfrUKdEIafQ79nEw/r4Jwx5yrp
   b8sIt06vHvNOwpAJGSjZ3J3HkgmDvfHaxoym23USPRRzP4MA1ID5sbW3e
   pWGbRuPmRWFEiSwEqaC/5jjAyvu1OTHtZdwyS3yvWGHOsRXajDMV9cT8q
   GRpEnpp4lzGYDuxwpfHzm29XsAbXnbTltxzWPOi9iC4sMBbAiJgdJpZMX
   EAGNN1SDzQsTM+rs8NVgjKGVC7HS2E8CsORv9kWPntZCrlrePL0cwASfk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="309122722"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="309122722"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 05:37:45 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="776480659"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="776480659"
Received: from rsimofi-mobl.ger.corp.intel.com (HELO localhost) ([10.252.30.2])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 05:37:42 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     kuba@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        SeongJae Park <sj@kernel.org>,
        Bin Chen <bin.chen@corigine.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: hinic: Add control command support
 for VF PMD driver in DPDK
In-Reply-To: <20221101121734.GA6389@chq-T47>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221101060358.7837-1-cai.huoqing@linux.dev>
 <20221101060358.7837-2-cai.huoqing@linux.dev> <87iljz7y0n.fsf@intel.com>
 <20221101121734.GA6389@chq-T47>
Date:   Tue, 01 Nov 2022 14:37:39 +0200
Message-ID: <87a65a97fw.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Nov 2022, Cai Huoqing <cai.huoqing@linux.dev> wrote:
> On 01 11=E6=9C=88 22 12:46:32, Jani Nikula wrote:
>> On Tue, 01 Nov 2022, Cai Huoqing <cai.huoqing@linux.dev> wrote:
>> > HINIC has a mailbox for PF-VF communication and the VF driver
>> > could send port control command to PF driver via mailbox.
>> >
>> > The control command only can be set to register in PF,
>> > so add support in PF driver for VF PMD driver control
>> > command when VF PMD driver work with linux PF driver.
>> >
>> > Then there is no need to add handlers to nic_vf_cmd_msg_handler[],
>> > because the host driver just forwards it to the firmware.
>> > Actually the firmware works on a coprocessor MGMT_CPU(inside the NIC)
>> > which will recv and deal with these commands.
>> >
>> > Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
>>=20
>> Out of curiosity, what exactly compelled you to Cc me on this particular
>> patch? I mean there aren't a whole lot of places in the kernel that
>> would be more off-topic for me. :)
> run ./scripts/get_maintainer.pl this patch in net-next
> then get your email
> Jani Nikula <jani.nikula@intel.com> (commit_signer:1/8=3D12%)
> Maybe you have some commits in net subsystem ?

A grand total of 3 commits in drivers/net/wireless/ath/ two years ago,
adding 3 const keywords, nowhere near of what you're changing.

get_maintainer.pl is utterly broken to suggest I should be Cc'd.


BR,
Jani.


>>=20
>> BR,
>> Jani.
>>=20
>>=20
>> --=20
>> Jani Nikula, Intel Open Source Graphics Center

--=20
Jani Nikula, Intel Open Source Graphics Center
