Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB4E56D435
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 07:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiGKFOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 01:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKFOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 01:14:53 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE7414030
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 22:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657516492; x=1689052492;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z3dFTVzHzSzd7vwxP7q1pE/Q3wL6XRKlmhvEKQM6j1I=;
  b=OfqPExttbf5/+SQzX8No0etC7KKuvNUPLGFISv2L1g1/32dlr+IjIjtN
   IhAyPiyeFWyLJmrOTRlUER35lXwq5wm7t7CNocybf9SAGs40CSsEu4bXg
   7Cwzx7YG1wM+I4BA386C/k+g4ld/wiXqpAx6Rfr9TgJQp0QdK8eygazFi
   P5BpGo/TAXiAh1klf7gfZj+ONiPgatrWTk6dNH3w5qid5bkj16NPzJSgZ
   r7yB6xczuaANfoTsBfDctUk0aLJ++feN5H6NbtMBScF2NG1uQ+9Q0Avg6
   8Qg4g2pLepSqWKhBYVxJ8bshbLldyYAyFGW8E+oEHQ3dJL7wZbioKRzpx
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="282128336"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="282128336"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 22:14:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="544874759"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.11.253]) ([10.13.11.253])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 22:14:49 -0700
Message-ID: <fb5b6665-0a49-7f05-ec4b-02eb090335e8@linux.intel.com>
Date:   Mon, 11 Jul 2022 08:14:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [Intel-wired-lan] [PATCH net-next] igc: Lift TAPRIO schedule
 restriction
Content-Language: en-US
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220606092747.16730-1-kurt@linutronix.de>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20220606092747.16730-1-kurt@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/2022 12:27, Kurt Kanzenbach wrote:
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
>   drivers/net/ethernet/intel/igc/igc_main.c | 23 +++++++++++++++++------
>   1 file changed, 17 insertions(+), 6 deletions(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
