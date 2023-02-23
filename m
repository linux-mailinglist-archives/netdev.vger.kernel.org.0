Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9A76A0250
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 06:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjBWFR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 00:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbjBWFRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 00:17:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14B43D934
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 21:17:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96985B811EC
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 05:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DB2C433EF;
        Thu, 23 Feb 2023 05:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677129464;
        bh=RUHLDq+BwbTgrH2AUtwXvSW4iEa6Ln7BXuRs6xH1iSw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g0elYqauO5caCzGeCrmOL4AtbSzAa9qSJNFIanZxRVXSKMvFkMvgil8FdqSqSNQnK
         tT1axI8lp+SmKfvxmoI/OU3ZadX7PvD47Tl28v/FacYNAf8yBffOsWLyy9seguwZ0N
         K7NXR0exlvQ7jNlOCUoewMbNzCLd32lpKsFIjJG2zZwi7e2XOW/NB1Gckz6XGYsffk
         l4ZF8HMuhyauCYBM4vvjqJTEKm0dov7XTL0St9LoJE7fldX6KupnEEmOcOzEdizDVc
         QPsTSyJB7YazscZDa8ZH5yoZ3AeHYhpPrkH9YIXo1s9UWi2wSuzsvlfRdRw9FH9IMC
         m9CpNVRlxlK3g==
Date:   Wed, 22 Feb 2023 21:17:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Anthony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [intel-net] ice: remove unnecessary CONFIG_ICE_GNSS
Message-ID: <20230222211742.4000f650@kernel.org>
In-Reply-To: <20230222223558.2328428-1-jacob.e.keller@intel.com>
References: <20230222223558.2328428-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Feb 2023 14:35:58 -0800 Jacob Keller wrote:
> I'm sending to both Intel-wired-lan and netdev lists since this was
> discussed publicly on the netdev list. I'm not sure how we want to queue it
> up, so I currently have it tagged as intel-net to go through Tony's IWL
> tree. I'm happy however it gets pulled. I believe this is the best solution
> as the total number of #ifdefs is the same as with CONFIG_ICE_GNSS, as is
> the Makefile line. As far as I can tell the Kbuild just does the right thing
> here so there is no need for an additional flag.
> 
> I'm happy to respin with a "depends" check if we think the flag has other
> value.

Sorry for late response. Do you mean depends as in keeping the separate
Kconfig? IS_REACHABLE() is a bit of a hack, makes figuring out what
gets built a lot harder for users. How about we keep the IS_ENABLED()
but add a dependency to ICE as a whole?

I mean instead of s/IS_ENABLED/IS_REACHABLE/ do this:

index 3facb55b7161..198995b3eab5 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -296,6 +296,7 @@ config ICE
        default n
        depends on PCI_MSI
        depends on PTP_1588_CLOCK_OPTIONAL
+       depends on GNSS || GNSS=n
        select AUXILIARY_BUS
        select DIMLIB
        select NET_DEVLINK

Or do you really care about building ICE with no GNSS.. ?
