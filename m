Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD516BBE05
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjCOUhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCOUhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:37:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1483B672;
        Wed, 15 Mar 2023 13:37:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5E72B81ED5;
        Wed, 15 Mar 2023 20:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F77C433D2;
        Wed, 15 Mar 2023 20:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678912621;
        bh=6QsTEZ7MzRaqxYFMfxTLjFQG93K0tiVTqbdz5yuvDIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mkMCIWpBLn4SffAiYb/xhKqJlUuLVsUKWncq34uKtSNS8DB44QMU5sWdSepLCFQZN
         BX5ogD8wtIwZxQHcB2yBmfQkRkuOIcbdnpApr56tRuaZhop/a4l12XhfCDzEOYWy+x
         cu+0HM14DweGLnwZIStStDPMSNBZ2LNaDJjk860Yq3gVcni3H1AwBw40UZ5knV73ov
         WKMfl/GXPHq562VEOxVrCqVXyPpi0NF6iUncJsvFjmoXi8ZjkMN4+soaMGeDXN27ZU
         O872FI3jJqw1R9Sj5XmV55kvYPD4sALN/HUOgBSKCtprWMwnPR+YnfKbFkJzXQZ8Oz
         C4tVzcHSWVZJg==
Date:   Wed, 15 Mar 2023 13:36:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>, David Ahern <dsahern@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch V2 1/4] net: dst: Prevent false sharing vs.
 dst_entry::__refcnt
Message-ID: <20230315133659.4d608eb0@kernel.org>
In-Reply-To: <20230307125538.818862491@linutronix.de>
References: <20230307125358.772287565@linutronix.de>
        <20230307125538.818862491@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Mar 2023 13:57:42 +0100 (CET) Thomas Gleixner wrote:
> Move the rt[6i]_uncached[_list] members out of struct rtable and struct
> rt6_info into struct dst_entry to provide padding and move the lwtstate
> member after that so it ends up in the same cache line.

Eric, David, looks reasonable? 
