Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F4B5785BC
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiGROql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiGROql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:46:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4A72BCE
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 07:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658155600; x=1689691600;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=ew4Wtu4O4sQJvl9BxuElFGEFRvg43uMfAM4rlKC3aiM=;
  b=ESsaLdsPDUbhP7njMecA4uW3xNHYb6PnOohPfHtsKiecs45QpUR3SHvg
   kysspKDQkvfF/1/B6FpyQP8VOFVF5VNnhjy8ryHnuPjEgoK80MQlsAzbz
   mgfwWURJZ3wfnaP11VwBanl7+6BPUdjo2LKaY3gs4n0G1JIMzsclG+B2m
   PKRr+Pqq9IPnh0AjqZVfiMxazj8YU3QvsyN29IAsg7xvyGQhM8sqi4MTe
   t/y/Ls7I3qHzkijtvs6cpvK04nzFchvOA3rLGCE3A1sJH80yKZhfklYo/
   Z6msdi2ujYb3HbzKQgfru7RZFaADNsq0yDj1rKguwdTguJgm/xuZP4AJ1
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="286257313"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="286257313"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 07:46:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="572433143"
Received: from npande-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.52.138])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 07:46:37 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: Re: igc: missing HW timestamps at TX
In-Reply-To: <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
Date:   Mon, 18 Jul 2022 11:46:34 -0300
Message-ID: <87tu7emqb9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ferenc,

Ferenc Fejes <ferenc.fejes@ericsson.com> writes:

> (Ctrl+Enter'd by mistake)
>
> My question here: is there anything I can quickly try to avoid that
> behavior? Even when I send only a few (like 10) packets but on fast
> rate (5us between packets) I get missing TX HW timestamps. The receive
> side looks much more roboust, I cannot noticed missing HW timestamps
> there.

There's a limitation in the i225/i226 in the number of "in flight" TX
timestamps they are able to handle. The hardware has 4 sets of registers
to handle timestamps.

There's an aditional issue that the driver as it is right now, only uses
one set of those registers.

I have one only briefly tested series that enables the driver to use the
full set of TX timestamp registers. Another reason that it was not
proposed yet is that I still have to benchmark it and see what is the
performance impact.

If you are feeling adventurous and feel like helping test it, here is
the link:

https://github.com/vcgomes/net-next/tree/igc-multiple-tstamp-timers-lock-new


Cheers,
-- 
Vinicius
