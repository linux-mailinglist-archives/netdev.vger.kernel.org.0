Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10FB646585
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLGX5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLGX46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:56:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6075F8B39A
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:56:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09D00B82193
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 23:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B780C433D6;
        Wed,  7 Dec 2022 23:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670457414;
        bh=76cJLuFv+TlbDHYYeLFulHsL22WGakQedrbLQvB4XMc=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=MbXKK4ARdEQ48I4ACoWnYgamNYQw3/NQg9E4saMzZEs6TG5HUgauzo12Kols5MRXP
         ErSS64LzAp+oMXy8o4bBXhaSprZvWUEvV8042eclxTsRkPV5Epevo5hjG9CUHjlLI/
         3PaStYfGcXeHIasMVlxYYdhHfW5Xd2aKHmDIQ77WTQ+c0dTxt6Bkfav7G8gehyqz3p
         sDMmeC89SWO8GdkL5FKEE/oBOw8FtLMPzoAXTzj6wLVbAvSccace3xCPEst7v+FUUS
         SOvPXBy/u3p93Os7KZLKJyFZxGIGs9ggg2/+Wl2naQYTXc7Je8cQxDS2zknprh3B8Z
         p0g9WbwnxzHCw==
Date:   Wed, 7 Dec 2022 15:56:53 -0800
From:   Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com, leon@kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next v2 12/15] ice: handle flushing stale Tx
 timestamps in ice_ptp_tx_tstamp
Message-ID: <Y5EoRXaFs3mjrTLE@x130>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
 <20221207210937.1099650-13-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221207210937.1099650-13-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 Dec 13:09, Tony Nguyen wrote:
>From: Jacob Keller <jacob.e.keller@intel.com>
>
>In the event of a PTP clock time change due to .adjtime or .settime, the
>ice driver needs to update the cached copy of the PHC time and also discard
>any outstanding Tx timestamps.
>

[...]

>+static void
>+ice_ptp_mark_tx_tracker_stale(struct ice_ptp_tx *tx)
>+{
>+	u8 idx;
>+
>+	spin_lock(&tx->lock);
>+	for_each_set_bit(idx, tx->in_use, tx->len)
>+		set_bit(idx, tx->stale);

nit: bitmap_or()? 


