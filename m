Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B5155A51C
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 01:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiFXX40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 19:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiFXX4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 19:56:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DA58AC3A
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 16:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656114984; x=1687650984;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=Zz07mbh9YfRoTYX5tVtIlDjpohvOvHEpK3Dp4+QSLvI=;
  b=aiE2XpME7MV3Y+y5AV5rEafsIPzsKIHernMXE1mDrBmCGdm3AbJBEuE8
   skZen9T0/SHQAbeMQHliI5GNktTJWVczg+tFGFaMuMAIURVpqAbPjDxYk
   4KFL+FZdY6thUKieHvnWOCXYkcpbI+I0p2upQRw9XgfMxA0psFTWN2BK/
   h5P9SIVveg6tneIsz3p5C4LxI2qjLG0ngocfUso86t9+txu4pxxnXNOH4
   Fvrg0XCakZydY8Anp8F4z4ac3J6QXnlXKPCB+HSkzvN4bvDHkNSUGPtNo
   AADEpDTR3Olt62SeIIk7vgeiEB0qdtphkx580oWrABy6RZ4Y9X+IN6bnH
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="261541296"
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="261541296"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 16:56:24 -0700
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="593442823"
Received: from jzhan12-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.38.121])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 16:56:23 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net-next] igc: Lift TAPRIO schedule restriction
In-Reply-To: <20220606092747.16730-1-kurt@linutronix.de>
References: <20220606092747.16730-1-kurt@linutronix.de>
Date:   Fri, 24 Jun 2022 16:56:23 -0700
Message-ID: <87pmixy5so.fsf@intel.com>
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

Hi,

Kurt Kanzenbach <kurt@linutronix.de> writes:

> Add support for Qbv schedules where one queue stays open
> in consecutive entries. Currently that's not supported.
>
> Example schedule:
>
> |tc qdisc replace dev ${INTERFACE} handle 100 parent root taprio num_tc 3 \
> |   map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
> |   queues 1@0 1@1 2@2 \
> |   base-time ${BASETIME} \
> |   sched-entry S 0x01 300000 \ # Stream High/Low
> |   sched-entry S 0x06 500000 \ # Management and Best Effort
> |   sched-entry S 0x04 200000 \ # Best Effort
> |   flags 0x02
>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Finally did a few rounds of testing here, everything worked as expected:

Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
-- 
Vinicius
