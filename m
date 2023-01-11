Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287C066527A
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjAKDpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjAKDpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:45:33 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6FA2B1;
        Tue, 10 Jan 2023 19:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673408732; x=1704944732;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BUvk+JooDXJ4fqkO3tc2bcOgUJc5ZVpvc/wqa5I1FIg=;
  b=XHhjy7pusW8BD3nUAg14tlE6S6eUiQRzYlWHJ46VO1GLhJhuvtw7CAFc
   4cmpswNOkvXQozk9OAqqiVZ/E1HP2bfyQR9X0zbwZGg/cyH30GCYrYFeT
   w2497x5USxkmnD35bfedtloM+46UPwhGx8Xibo+XlELn+rM/HiNq9O2Ug
   xAvoAhrNZmxTA6hvOpgHvmwaSX6kmsFXSPEClHvUrRCzqsYnd5X2FhlME
   XXmt3UYmSLvLtoHYfUd9DbqK9pHBo2AXPccbI5Z63kF8gpBEI/F506H2x
   BxvvxuPzAo7zuIxioyWuh+ObamsI7tJ4koBLcrGn4tf6PQ31iLIeEgdBD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="321012455"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="321012455"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 19:45:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="689642271"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="689642271"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 10 Jan 2023 19:45:31 -0800
Received: from linux.intel.com (noorazur1-iLBPG12.png.intel.com [10.88.229.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 8EBFA5807C8;
        Tue, 10 Jan 2023 19:45:27 -0800 (PST)
Date:   Wed, 11 Jan 2023 11:32:03 +0800
From:   Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tan Tee Min <tee.min.tan@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH net 1/1] net: stmmac: add aux timestamps fifo clearance
 wait
Message-ID: <20230111033202.GA893@linux.intel.com>
References: <20230109151546.26247-1-noor.azura.ahmad.tarmizi@intel.com>
 <b87cdb13baab2a02be2fb3ffc54c581d097cbe7d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b87cdb13baab2a02be2fb3ffc54c581d097cbe7d.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 11:27:47AM +0100, Paolo Abeni wrote:
> On Mon, 2023-01-09 at 23:15 +0800, Noor Azura Ahmad Tarmizi wrote:
> > Add timeout polling wait for auxiliary timestamps snapshot FIFO clear bit
> > (ATSFC) to clear. This is to ensure no residue fifo value is being read
> > erroneously.
> > 
> > Cc: <stable@vger.kernel.org> # 5.10.x
> > Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> 
> Please post a new revision of this patch including a suitable 'Fixes'
> tag, thanks!
> 
> Paolo
>

Ok Paolo, sorry i missed that out. Will send out v2 ASAP.
Thanks!

Azura
 
