Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC2A5917B9
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 02:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiHMAFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 20:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiHMAFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 20:05:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDBB28F
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 17:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660349153; x=1691885153;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=/unn/GWSSxZQI3S+V3HdZHplY4oCOpStK/WAzsbYOiU=;
  b=PnYKDi3Tx5CU86CfnHL+x34yLRBn+F0CrPpG50HrnO+F+HuZWVimmgwu
   9pTn1M29c/LXK4KughBFoLPGoNHUtvhJInf2oSr8SGR9r61jNzE3TcrKK
   FqaHQLgQINNHWXZbMdkUXtqli0AlFbmhoFqPVqJxZ9w1bYTZW42I55N/H
   UiaVvf5AppaeFyV3vhQ9ARP3/3FchaMfD00MrnCcg71vYU07wyM6n8jxO
   T7dy2GPXcWWVH5xXUmwFblWRu7FNW6WDiaouTkhd6rN14cqfH05mxgBIC
   4xi7SJp9U2GPvlGlqv35J9z6CiQsYCw2KVPBLKXXlV6p4W5Grd93nBdvV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="378000635"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="378000635"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 17:05:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="933897974"
Received: from vedsingh-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.2.208])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 17:05:52 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     James Hogan <jhogan@kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Subject: Re: [WIP v2] igc: fix deadlock caused by taking RTNL in RPM resume
 path
In-Reply-To: <4759452.31r3eYUQgx@saruman>
References: <20220811151342.19059-1-vinicius.gomes@intel.com>
 <20220811202524.78323-1-vinicius.gomes@intel.com>
 <4759452.31r3eYUQgx@saruman>
Date:   Fri, 12 Aug 2022 21:05:41 -0300
Message-ID: <87o7wpxb1m.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi James,

James Hogan <jhogan@kernel.org> writes:

> On Thursday, 11 August 2022 21:25:24 BST Vinicius Costa Gomes wrote:
>> It was reported a RTNL deadlock in the igc driver that was causing
>> problems during suspend/resume.
>> 
>> The solution is similar to commit ac8c58f5b535 ("igb: fix deadlock
>> caused by taking RTNL in RPM resume path").
>> 
>> Reported-by: James Hogan <jhogan@kernel.org>
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>> Sorry for the noise earlier, my kernel config didn't have runtime PM
>> enabled.
>
> Thanks for looking into this.
>
> This is identical to the patch I've been running for the last week. The 
> deadlock is avoided, however I now occasionally see an assertion from 
> netif_set_real_num_tx_queues due to the lock not being taken in some cases via 
> the runtime_resume path, and a suspicious rcu_dereference_protected() warning 
> (presumably due to the same issue of the lock not being taken). See here for 
> details:
> https://lore.kernel.org/netdev/4765029.31r3eYUQgx@saruman/

Oh, sorry. I missed the part that the rtnl assert splat was already
using similar/identical code to what I got/copied from igb.

So what this seems to be telling us is that the "fix" from igb is only
hiding the issue, and we would need to remove the need for taking the
RTNL for the suspend/resume paths in igc and igb? (as someone else said
in that igb thread, iirc)


Cheers,
-- 
Vinicius
