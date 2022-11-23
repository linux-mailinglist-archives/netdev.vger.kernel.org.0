Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE91B634F2B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbiKWErI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235618AbiKWEqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:46:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E4DD0892
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:46:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D6B161A3F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8281BC433D7;
        Wed, 23 Nov 2022 04:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669178805;
        bh=472RKi8WT/+k1aIlYXSIHcY63CifdCtUNEiTwsCu+j0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k/nuOTRhIRWIDZ1xxb8I2fHVxLOMS9UXKoO0s8p7rM4u5LU2flD5Ak4Ti2W3TzyZS
         px+BWGIpJR5LikuWJDyshdw4K9vwB1lFTkS02BdL2DOlw5Ku1pccn8AM4MtFNjIiMY
         zcl6UgaN9O4qBKGVlssruZVMmSmGayhe1+VwD/WhS3OYbjfDGmu0kskQgrpwSXBP8J
         agC1mHeR/4+prqLOy6vgyXNTUqEjJmujs12CfsB0bKluG9uzr58axEK4f244z3L9lM
         xsr2qqPhj/5XEQs3vwPYuCjHCcFzYQTj0Fvt/LRyhF6Q4Nve4XcSoSe3xh4ME2JQwQ
         Jwf/hwy87WSoQ==
Date:   Tue, 22 Nov 2022 20:46:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     m.chetan.kumar@linux.intel.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, linuxwwan@intel.com, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net 4/4] net: wwan: iosm: fix incorrect skb length
Message-ID: <20221122204644.7bfd48d1@kernel.org>
In-Reply-To: <20221122174746.3496864-1-m.chetan.kumar@linux.intel.com>
References: <20221122174746.3496864-1-m.chetan.kumar@linux.intel.com>
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

On Tue, 22 Nov 2022 23:17:46 +0530 m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> skb passed to network layer contains incorrect length.
> 
> In mux aggregation protocol, the datagram block received
> from device contains block signature, packet & datagram
> header. The right skb len to be calculated by subracting
> datagram pad len from datagram length.
> 
> Whereas in mux lite protocol, the skb contains single
> datagram so skb len is calculated by subtracting the
> packet offset from datagram header.

Sparse says:

drivers/net/wwan/iosm/iosm_ipc_mux_codec.c:478:38: warning: restricted __le16 degrades to integer
drivers/net/wwan/iosm/iosm_ipc_mux_codec.c:571:52: warning: restricted __le16 degrades to integer
