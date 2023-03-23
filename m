Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE776C705B
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 19:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjCWSjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 14:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbjCWSjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 14:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FD465A0;
        Thu, 23 Mar 2023 11:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0C5E626DD;
        Thu, 23 Mar 2023 18:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED723C433EF;
        Thu, 23 Mar 2023 18:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679596786;
        bh=J1tuQBO7/NjxMfKdV01NRxEWxZt9Yl5LPJ9WZFCA3f8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i5a/Tksrk2VCYncC8YQR/q/Ma+j17gKS1GEz/NcKydCEPTHeMxkTO3wCBV5JDYKyv
         Skf9XwdkthCVfI5pWEZ2tKszF0BCN1UgMxWwJejw03Mt5I3E/gaE3iC5s/O3XofxVs
         mcBe6CZETTLgpbsRJ6yYBuubkYnL1hsQcUKJoTkFokXpmhMOyrIj7a3/w/+qJHLSQw
         2nSu7JtDPk1f+09pOaf/i88NtZbxoN9kPBGWxiw8K80DLmGKSzhFtPxiaBzIRTxgoo
         DGo2wBHFrKDCdZQ8efET+4JtgVvAAaTVXZZGdNY/fpWUcK2CzkUrXFixDg9xAnqABG
         pE4lcUqSDodGg==
Date:   Thu, 23 Mar 2023 11:39:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net v3 1/2] smsc911x: only update stats when interface
 is up
Message-ID: <20230323113945.0915029d@kernel.org>
In-Reply-To: <20230322071959.9101-2-wsa+renesas@sang-engineering.com>
References: <20230322071959.9101-1-wsa+renesas@sang-engineering.com>
        <20230322071959.9101-2-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 08:19:58 +0100 Wolfram Sang wrote:
> -	smsc911x_tx_update_txcounters(dev);
> -	dev->stats.rx_dropped += smsc911x_reg_read(pdata, RX_DROP);
> +
> +	if (netif_running(dev)) {
> +		smsc911x_tx_update_txcounters(dev);
> +		dev->stats.rx_dropped += smsc911x_reg_read(pdata, RX_DROP);
> +	}

Same problem as on the renesas patch, netif_running() can return true
before ndo->open() is called. And stats can be read with just the RCU
lock (via procfs).

Maybe we should add a false-negative version of netif_running() ?
__LINK_STATE_START*ED* ?
