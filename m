Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184E94FC824
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 01:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiDKXi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 19:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiDKXi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 19:38:58 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A88255BB
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 16:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649720203; x=1681256203;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=NzZt4IBwnWx6owLRJPhA+huTplPrlQZy3WYXyAwpsSA=;
  b=YCJm8N1Cqk4YbrNzpdHtR57cxzX7tgHCQmDrx3QmfrhZVGBRGgCqYMNq
   OcpLNSApQoiDq/XS/y13lWcEoJB6fOop6ck3go20McZu3cKLIL44xeTE2
   wNRPwqEyzs1OHxwiGBzyBtQMUBKrPkhpV5ud7acP6JO+qAj30b4MqbZJJ
   uQxlq1qK+I37ha8ijUoxvPtWhOZKulJ3Y6kZ5FUPefymiE+DhqrZiuHxS
   q0HC4HWjr0P5WvS5Pzize2OrCKd3QGw8OZy43IabGa3ydZjc4wihviKhj
   aNaA3hsFjbhKZEqlBMCcLj2Lj9PreB2y8ZkWnRZXYpTMEjztiiKqTubiR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="249521315"
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="249521315"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 16:36:42 -0700
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="572469523"
Received: from vcostago-mobl3.jf.intel.com (HELO vcostago-mobl3) ([10.24.14.61])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 16:36:42 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 11/12] igc: Check incompatible configs for
 Frame Preemption
In-Reply-To: <20210628092003.bribdjfaxwnpdt5f@skbuf>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
 <20210626003314.3159402-12-vinicius.gomes@intel.com>
 <20210628092003.bribdjfaxwnpdt5f@skbuf>
Date:   Mon, 11 Apr 2022 16:36:42 -0700
Message-ID: <87wnfvchv9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Jun 25, 2021 at 05:33:13PM -0700, Vinicius Costa Gomes wrote:
>> Frame Preemption and LaunchTime cannot be enabled on the same queue.
>> If that situation happens, emit an error to the user, and log the
>> error.
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>
> This is a very interesting limitation, considering the fact that much of
> the frame preemption validation that I did was in conjunction with
> tc-etf and SO_TXTIME (send packets on 2 queues, one preemptible and one
> express, and compare the TX timestamps of the express packets with their
> scheduled TX times). The base-time offset between the ET and the PT
> packets is varied in small increments in the order of 20 ns or so.
> If this is not possible with hardware driven by igc, how do you know it
> works properly? :)

Good question. My tests were much less accurate than what you were
doing, I was basically flooding the link with preemptable packets, and
sending some number of express packets, and counting them using some
debug counters on the receiving side.


Cheers,
-- 
Vinicius
