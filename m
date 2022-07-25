Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01F3580354
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 19:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbiGYRIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 13:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbiGYRIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 13:08:34 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D59717A8C;
        Mon, 25 Jul 2022 10:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658768913; x=1690304913;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sSdI+BU9e3YX5dM7OgmzfeHQiDsLJgc/tN6SHdRbQbE=;
  b=K3egCreI9cpkezxpMXJbaL/YMPbWhdJ6lhTl6x5qj+BT80VX2BE7S5li
   oqfp+d5LPU6/4b3LhX3UU41Vbx1N0OK7jZa441wVx8xCdIkXMFuDnl0Bl
   U9d6VwkhIjFDoEazKH2YoFG68d7XMVIZ0/wioeCpnfeBhfVgFHnt37wFj
   2PpMsrJ4RKTBX040pRjMSdMjeZwgeujJn8xjUyX24EKjwIYJuFABda97o
   zfBOXCzTVJpzp2Q7xz+R7CBOx7A3LA6mFQx0GO7NgUKXkaNCbkaTjReca
   SqICogQniHWApMeKY635Q1pBRtc1caS1VhU/fPWrp9PMwqdrAvYHJdgiv
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="287760223"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="287760223"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 10:08:33 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="550062694"
Received: from jxzhao-mobl.amr.corp.intel.com (HELO [10.212.0.178]) ([10.212.0.178])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 10:08:31 -0700
Message-ID: <148f6cb9-aafc-4fd5-9e30-24078866d3fd@linux.intel.com>
Date:   Mon, 25 Jul 2022 10:32:27 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [BISECTED] igb initialization failure on Bay Trail
Content-Language: en-US
To:     "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        hdegoede@redhat.com
Cc:     andriy.shevchenko@linux.intel.com, carlo@endlessm.com,
        davem@davemloft.net, hkallweit1@gmail.com, js@sig21.net,
        linux-clk@vger.kernel.org, linux-wireless@vger.kernel.org,
        mturquette@baylibre.com, netdev@vger.kernel.org, sboyd@kernel.org
References: <20180912093456.23400-4-hdegoede@redhat.com>
 <20220724210037.3906-1-matwey.kornilov@gmail.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20220724210037.3906-1-matwey.kornilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/22 16:00, Matwey V. Kornilov wrote:
> Hello,
> 
> I've just found that the following commit
> 
>     648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
> 
> breaks the ethernet on my Lex 3I380CW (Atom E3845) motherboard. The board is
> equipped with dual Intel I211 based 1Gbps copper ethernet.

It's not going to be simple, it's 4 yr old commit that fixes other
issues with S0i3...

> 
> Before the commit I see the following:
> 
>      igb 0000:01:00.0: added PHC on eth0
>      igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
>      igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
>      igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
>      igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
>      igb 0000:02:00.0: added PHC on eth1
>      igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
>      igb 0000:02:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e5
>      igb 0000:02:00.0: eth1: PBA No: FFFFFF-0FF
>      igb 0000:02:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
> 
> while when the commit is applied I see the following:
> 
>      igb 0000:01:00.0: added PHC on eth0
>      igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
>      igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
>      igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
>      igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
>      igb: probe of 0000:02:00.0 failed with error -2
> 
> Please note, that the second ethernet initialization is failed.
> 
> 
> See also: http://www.lex.com.tw/products/pdf/3I380A&3I380CW.pdf
