Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A48E251DEF
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgHYROX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:14:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:25175 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbgHYROQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 13:14:16 -0400
IronPort-SDR: 7oUqoaeicKEPRh4aV7qdt5/GYxepyuSonCSjgTmkLXOjdDjx5qzDz04TSaiA8LNkrSMGqhI99c
 /DkZKqBMu/Xw==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="240976846"
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="240976846"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 10:14:13 -0700
IronPort-SDR: 2ZItQ/zfr0Grb0WpnjNLmHmlmW7Om09pW78aitNxty0HE0IsHtNmXEiF/H2Zsm4ZOk5/JkdwDU
 qTrct/2H7JFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="322834728"
Received: from bartholt-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.53.74])
  by fmsmga004.fm.intel.com with ESMTP; 25 Aug 2020 10:14:10 -0700
Subject: Re: [PATCH net v2 3/3] ice: avoid premature Rx buffer reuse
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
References: <20200825121323.20239-1-bjorn.topel@gmail.com>
 <20200825121323.20239-4-bjorn.topel@gmail.com>
 <20200825084959.69e0bb0d@kicinski-fedora-PC1C0HJN>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <9590fe12-55a5-69fd-0737-32a6c9aceca3@intel.com>
Date:   Tue, 25 Aug 2020 19:14:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200825084959.69e0bb0d@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-25 17:49, Jakub Kicinski wrote:
> On Tue, 25 Aug 2020 14:13:23 +0200 Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> The page recycle code, incorrectly, relied on that a page fragment
>> could not be freed inside xdp_do_redirect(). This assumption leads to
>> that page fragments that are used by the stack/XDP redirect can be
>> reused and overwritten.
>>
>> To avoid this, store the page count prior invoking xdp_do_redirect().
>>
>> Fixes: efc2214b6047 ("ice: Add support for XDP")
>> Reported-and-analyzed-by: Li RongQing <lirongqing@baidu.com>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> 
> Gotta adjust the kdoc:
> 
> drivers/net/ethernet/intel/ice/ice_txrx.c:773: warning: Function parameter or member 'rx_buf_pgcnt' not described in 'ice_can_reuse_rx_page'
> drivers/net/ethernet/intel/ice/ice_txrx.c:885: warning: Function parameter or member 'rx_buf_pgcnt' not described in 'ice_get_rx_buf'
> drivers/net/ethernet/intel/ice/ice_txrx.c:1033: warning: Function parameter or member 'rx_buf_pgcnt' not described in 'ice_put_rx_buf'
> 

Thanks! I'll spin a v3.
