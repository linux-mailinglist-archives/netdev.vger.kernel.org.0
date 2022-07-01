Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C4C562A16
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 06:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbiGAEEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 00:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbiGAEER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 00:04:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2811EEC1
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 21:02:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABC43B82CEF
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 04:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0EEC341C6;
        Fri,  1 Jul 2022 04:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656648124;
        bh=KsZMvmejxxo7OyL1FKSVs/gUuPJ56brAAuVXfm/GpzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a8qTTghRvaR6Qt9CnnVuKLY6CAYMhqDk0V1/JXuVFQzTmZMglcZduMFDjOe6uSACW
         cJLPepE0QdRwvE88o1Vr0hV32ICgPuRguCD+KT5xY0/zaVc6HzNeHMPkFzx023N924
         TeFd0oW37xC4q6G/ST0Ld4kBMBsHzD+ArLz53XGXw+hvOju7KmbvgCDWO+K5MjMMGN
         MkioGYFuJ6VR1DY8XlGLMkDYpIHpTK7q1Go3ROAucK1INUH1CY94zXZhvdZvwt7JsT
         KHgMzAqlHKxhFUUJjtmVJSnnCkMaQURCQB2FmPxWT30/SzS+CFE13vZJB/RX0gCXjr
         opi6nHnw13gDA==
Date:   Thu, 30 Jun 2022 21:02:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Lukasz Cieplicki <lukaszx.cieplicki@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 1/2] i40e: Fix dropped jumbo frames statistics
Message-ID: <20220630210202.23165f16@kernel.org>
In-Reply-To: <20220630214940.3036250-2-anthony.l.nguyen@intel.com>
References: <20220630214940.3036250-1-anthony.l.nguyen@intel.com>
        <20220630214940.3036250-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 14:49:39 -0700 Tony Nguyen wrote:
> From: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
> 
> Dropped packets caused by too large frames were not included in
> dropped RX packets statistics.
> Issue was caused by not reading the GL_RXERR1 register. That register
> stores count of packet which was have been dropped due to too large
> size.
> 
> Fix it by reading GL_RXERR1 register for each interface.
> 
> Repro steps:
> Send a packet larger than the set MTU to SUT
> Observe rx statists: ethtool -S <interface> | grep rx | grep -v ": 0"

You should count oversized frames to rx_length_errors.
