Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC87D6E2E35
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 03:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjDOB2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 21:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDOB2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 21:28:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C405040E1;
        Fri, 14 Apr 2023 18:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CE506450A;
        Sat, 15 Apr 2023 01:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D26C433D2;
        Sat, 15 Apr 2023 01:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681522132;
        bh=uUG02w5CTk2pu7MbMecz7O9Xu7eY0dFcJmlanh3cLkI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RxVMv/1YlIFlLsLS1dxTIIsePbxn3H7U946n43Ybk9yTXqpHdkhsyRncgWRWocH9L
         vgDqyeIYUzQVilW6N1sQ29GOmBHAX0r3RtF63NLDrK+AyotZO6u/B+VfuGrLJdmXxO
         1ayPk8CPjLbAyiqEsT6yf0d/BkfbKIba6BNevRr52y0IFM4STlGUAAqMCy+dE/1Yd6
         0u+pfXs+Hr4YQVm65Ov5JhQNCo06T0smwFNLC6YzZVt9O1a7IZGF30oroLfwm1Qtt3
         713ikRYeXgKXGt20uX+XaolKCE0A0jsd7Vbfg78Hw84Pu9WL6nETlwoCbPTkPH3/ly
         Nc/keyrMLaRCA==
Date:   Fri, 14 Apr 2023 18:28:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: lan966x: Fix lan966x_ifh_get
Message-ID: <20230414182851.6f776cb7@kernel.org>
In-Reply-To: <06722642-f934-db3a-f88e-94263592b216@intel.com>
References: <20230414082047.1320947-1-horatiu.vultur@microchip.com>
        <06722642-f934-db3a-f88e-94263592b216@intel.com>
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

On Fri, 14 Apr 2023 19:00:20 +0200 Alexander Lobakin wrote:
> > @@ -608,6 +608,7 @@ static u64 lan966x_ifh_get(u8 *ifh, size_t pos, size_t length)
> >  			val |= (1 << i);  
> 
> Alternatively, you can change that to (pick one that you like the most):
> 
> 			val |= 1ULL << i;
> 			// or
> 			val |= BIT_ULL(i);

	// or 
	(u64)1 << i
	// or, since you're only concerned about sign extension, even
	1U << i

having the correct type of the lval seems cleaner than masking, indeed.
