Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54349614ED3
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiKAQHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiKAQH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:07:28 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEF91A06E;
        Tue,  1 Nov 2022 09:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667318848; x=1698854848;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=EQcFxapb17YQhzuTIeBrPhOZsWVpDavoU3S/ubxgLvQ=;
  b=D7DCDr83R83dT6Et8bIO5mERsHP0XxZSHFkR3/rX2TVMzgfuLKB5T65u
   xj0rk58xW2zRPoGxCvMYdxPXE+ev7AQd8RemKxO9rVlzdujhkZ57QciVu
   K8W7peuNYpigu5Ac9SNwWSMkGrWI3QfJKNZsUVhJEXpnNSj9WqTx509oG
   C1jhq0qLFpWWE96NO+iDlH5/UEpKttnH8mYU7LwzUQKJ2B6gWGJJMf0SE
   lUmxqQ8Rwug1cSbYN71nGdF5Bq/qBBI+dVthKDRPZOJgEndmSty/U8SJb
   72fR3l/wV1/781hB9Qb3D3OqgM9m+7EmnEOQsk1z6OcMthoBnNv59iW7F
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="395483721"
X-IronPort-AV: E=Sophos;i="5.95,231,1661842800"; 
   d="scan'208";a="395483721"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 09:06:48 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="697449213"
X-IronPort-AV: E=Sophos;i="5.95,231,1661842800"; 
   d="scan'208";a="697449213"
Received: from rsimofi-mobl.ger.corp.intel.com (HELO localhost) ([10.252.30.2])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 09:06:45 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        SeongJae Park <sj@kernel.org>,
        Bin Chen <bin.chen@corigine.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: hinic: Add control command support
 for VF PMD driver in DPDK
In-Reply-To: <20221101083744.7b0e9e5a@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221101060358.7837-1-cai.huoqing@linux.dev>
 <20221101060358.7837-2-cai.huoqing@linux.dev> <87iljz7y0n.fsf@intel.com>
 <20221101121734.GA6389@chq-T47> <87a65a97fw.fsf@intel.com>
 <20221101083744.7b0e9e5a@kernel.org>
Date:   Tue, 01 Nov 2022 18:06:42 +0200
Message-ID: <871qqm8xrh.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Nov 2022, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 01 Nov 2022 14:37:39 +0200 Jani Nikula wrote:
>> On Tue, 01 Nov 2022, Cai Huoqing <cai.huoqing@linux.dev> wrote:
>> > On 01 11=E6=9C=88 22 12:46:32, Jani Nikula wrote:=20=20
>> >> Out of curiosity, what exactly compelled you to Cc me on this particu=
lar
>> >> patch? I mean there aren't a whole lot of places in the kernel that
>> >> would be more off-topic for me. :)=20=20
>> > run ./scripts/get_maintainer.pl this patch in net-next
>> > then get your email
>> > Jani Nikula <jani.nikula@intel.com> (commit_signer:1/8=3D12%)
>> > Maybe you have some commits in net subsystem ?=20=20
>>=20
>> A grand total of 3 commits in drivers/net/wireless/ath/ two years ago,
>> adding 3 const keywords, nowhere near of what you're changing.
>>=20
>> get_maintainer.pl is utterly broken to suggest I should be Cc'd.
>
> Apparently is because you acked commit 8581fd402a0c ("treewide: Add
> missing includes masked by cgroup -> bpf dependency").
> This random driver is obviously was not the part you were acking but
> heuristics :/

*rolls eyes* :D


>
> Cai Huoqing FWIW we recommend adding --git-min-percent 25 when running
> get_maintainers, otherwise there's all sorts of noise that gets in.

--=20
Jani Nikula, Intel Open Source Graphics Center
