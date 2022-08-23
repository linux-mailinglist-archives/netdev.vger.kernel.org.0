Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E97059EEE2
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbiHWWR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiHWWR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:17:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A3B303
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 15:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76E22B82190
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 22:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC3AC433D6;
        Tue, 23 Aug 2022 22:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661293066;
        bh=UtcQgpw08WQTBwbUBvkZDpCzaab5er0XXV9k5g8yEVQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M5ydJ3irKtzbcbzI6pkeS8oxl8SNmHYxQB+8XSsX/5FWg9q4bKnSS8qvLXwJxsaHp
         iytoxBOPtPQRwC+oXbNSMamG0cgrBs6BnEfDyfUI1i756ZX1pICZAHIcc4INOQGEXp
         oJ+9UxZ67gVZC9ff/xoFc97f6I2NyGCgPoR17e300jOJybTiHEv5qBogSzzFXvDFRr
         1NmnKdX4wgS3AWENRewFSrAw5Za7qKkny08bE/3j8xH48h6PkxG4cP+tuC2KKk2NVO
         mcUKrvUg2YhOqIYTSm6QjL4B/sLVSyUECgpVwxQoic9V8udUV6BP+VZPyKlkhyzJJw
         hXiRtaoiXQiDg==
Date:   Tue, 23 Aug 2022 15:17:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Paul Greenwalt <paul.greenwalt@intel.com>
Subject: Re: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC
 disabled via ETHTOOL_SFECPARAM
Message-ID: <20220823151745.3b6b67cb@kernel.org>
In-Reply-To: <20220823150438.3613327-3-jacob.e.keller@intel.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <20220823150438.3613327-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 08:04:38 -0700 Jacob Keller wrote:
> The default Link Establishment State Machine (LESM) behavior does not

LESM is the algo as specified by the IEEE standard? If so could you add
the citation (section of the spec where it's defined)?

Is disabling the only customization we may want?

> allow the use of FEC disabled if the media does not support FEC
> disabled. However users may want to override this behavior.
> 
> To support this, accept the ETHTOOL_FEC_AUTO | ETHTOOL_FEC_OFF as a request
> to automatically select an appropriate FEC mode including potentially
> disabling FEC.
> 
> This is distinct from ETHTOOL_FEC_AUTO because that will not allow the LESM
> to select FEC disabled. It is distinct from ETHTOOL_FEC_OFF because
> FEC_OFF will always disable FEC without any LESM automatic selection.
> 
> This *does* mean that ice is now accepting one "bitwise OR" set for FEC
> configuration, which is somewhat against the recommendations made in
> 6dbf94b264e6 ("ethtool: clarify the ethtool FEC interface"), but I am not
> sure if the addition of an entirely new ETHTOOL_FEC_AUTO_DIS would make any
> sense here.
> 
> With this change, users can opt to allow automatic FEC disable via
> 
>   ethtool --set-fec ethX encoding auto off

