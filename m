Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086676779EB
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjAWLPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjAWLPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:15:47 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D909AB767;
        Mon, 23 Jan 2023 03:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674472545; x=1706008545;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xCgElu63hiEX8PZSg1x7apvUzWPg+SYGm2cwSlK2h8o=;
  b=mQht+VhseaxpAEdImy9qCkuv7cf1HXxXNTyG068/qUE1bj3XTCuZkc5V
   4/aYuYU/DBSXSMLbz+Q10m13QlRDu/Bw/FbFE0SfBR3Urd0ohi62noYIt
   B0cTuvifb1gF4ciOTF02J1BJQ0EbZ8G9j7nHwdzJ0JCArkoEX21vjRgEV
   DpVlKplZpWYZNkqxqCZX39XPQc3nm6wLLc99GRedqM29l+2rCIQUfjRZw
   yIsvQPd3/WxOSUcI9xJDF8dF3JK0Hjmdyw85tztV+Zsmdk0wd8jwsnrBC
   fIhv244uqbAlkPBj+ISe6bdfkeF2uSddqO2hFLmpmaZ0QVwnLZjrlNyrz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10598"; a="309595483"
X-IronPort-AV: E=Sophos;i="5.97,239,1669104000"; 
   d="scan'208";a="309595483"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 03:15:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10598"; a="804055292"
X-IronPort-AV: E=Sophos;i="5.97,239,1669104000"; 
   d="scan'208";a="804055292"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.12.3]) ([10.13.12.3])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 03:15:41 -0800
Message-ID: <59a81c79-7770-7673-5ebd-d79c44824554@linux.intel.com>
Date:   Mon, 23 Jan 2023 13:15:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH] igc: return an error if the mac type is
 unknown in igc_ptp_systim_to_hwtstamp()
To:     Tom Rix <trix@redhat.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, nathan@kernel.org,
        ndesaulniers@google.com, vinicius.gomes@intel.com,
        jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, llvm@lists.linux.dev,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
References: <20230114140412.3975245-1-trix@redhat.com>
Content-Language: en-US
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20230114140412.3975245-1-trix@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/2023 16:04, Tom Rix wrote:
> clang static analysis reports
> drivers/net/ethernet/intel/igc/igc_ptp.c:673:3: warning: The left operand of
>    '+' is a garbage value [core.UndefinedBinaryOperatorResult]
>     ktime_add_ns(shhwtstamps.hwtstamp, adjust);
>     ^            ~~~~~~~~~~~~~~~~~~~~
> 
> igc_ptp_systim_to_hwtstamp() silently returns without setting the hwtstamp
> if the mac type is unknown.  This should be treated as an error.
> 
> Fixes: 81b055205e8b ("igc: Add support for RX timestamping")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_ptp.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
