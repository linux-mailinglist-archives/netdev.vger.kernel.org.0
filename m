Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B79860A5F7
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 14:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiJXMao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 08:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiJXM3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 08:29:24 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0ED13F8F;
        Mon, 24 Oct 2022 05:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666613003; x=1698149003;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CfmKsPPFEZz3JYfcGzvUpUe5DGAdjt5IdWHUUS6XAEs=;
  b=dmWZYRFA91f6Ed2pGUxy8ykbOWmOEk7oyxmtZEGToGJX7N6oCdh01SwU
   RU++LYZ3H7nn/rfUBvUp3n4MIBcTS9XBxeknyfQYwiD9FRT8dkfMOPf9C
   NJY7taDADtXIc1Y1fpdOsWpYAkpcvo/ocThsvoZVZrpZk5nBvo3a1xu1Z
   LRRL++tix6RmgTGQBwh2gXW+KRyDtIurTfQ0IYurR70v9dhlNrB9axGNi
   enTJnD/Ug9zhCMKGYTtchYBs34JHisP07s8zHxzfY+PTzqZjPAbUJpPgT
   dZ1qkMQilZlMDg5hlseGWpkejtooGpK4yKJONeMtkIbEm/t94GxlF1n3k
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="305008264"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="305008264"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 05:00:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="633684800"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="633684800"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007.fm.intel.com with ESMTP; 24 Oct 2022 05:00:31 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1omw84-001QQC-1P;
        Mon, 24 Oct 2022 15:00:28 +0300
Date:   Mon, 24 Oct 2022 15:00:28 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Wolfram Sang <wsa@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Gerhard Sittig <gsi@denx.de>,
        Anatolij Gustschin <agust@denx.de>,
        Mark Brown <broonie@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mscan: mpc5xxx: fix error handling code in
 mpc5xxx_can_probe
Message-ID: <Y1Z+XHdOozjBFBzF@smile.fi.intel.com>
References: <20221024114810.732168-1-dzm91@hust.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024114810.732168-1-dzm91@hust.edu.cn>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 07:48:07PM +0800, Dongliang Mu wrote:
> The commit 1149108e2fbf ("can: mscan: improve clock API use
> ") only adds put_clock in mpc5xxx_can_remove function, forgetting to add

Strange indentation. Why the '")' part can't be on the previous line?

> put_clock in the error handling code.
> 
> Fix this bug by adding put_clock in the error handling code.

-- 
With Best Regards,
Andy Shevchenko


