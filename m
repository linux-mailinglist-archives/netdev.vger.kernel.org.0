Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67457572ACB
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiGMB0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiGMB0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:26:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC66BB1857
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 18:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83448B80B3C
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9122C3411C;
        Wed, 13 Jul 2022 01:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657675607;
        bh=Kg7GElQbAoCVeQwdPNd4pLIFK711KRhHX5wjuG3SI5Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uKQsN1Vv6Ux0rKwTtFOLmPC99cMaRZN61HlcjXPRy4p9QWWTibUJ3Vh9Q1KGLOMHN
         G2uJXFFYIScahXtgaek+a4jEGsbcJ02NSSH6I9ZMGj2jiRhKYQTRL1LaCPb3kLLigB
         41FJFvu8Mc3gfBL/V82uExNXEPJ3np+h68f7lkOdWm0CXyYo9WG/qOYIZOhr6pydY2
         qBLe/R5TIVqPVM9EKGtbDL9Js7AeMegkzNddnJl7FAvqdiRNcqOyK4Kvt6NZRiWyWL
         30IQlPDlVG+Sw1fAbj1YQ4L++kUPiVRQh+Vb1M0ScH825mrCjsOlkF8fusLaRO63VP
         wGwPFoSIvSvJg==
Date:   Tue, 12 Jul 2022 18:26:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: Re: [PATCH net 4/7] iavf: Fix NULL pointer dereference in
 iavf_get_link_ksettings
Message-ID: <20220712182636.53a957cc@kernel.org>
In-Reply-To: <20220711230243.3123667-5-anthony.l.nguyen@intel.com>
References: <20220711230243.3123667-1-anthony.l.nguyen@intel.com>
        <20220711230243.3123667-5-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 16:02:40 -0700 Tony Nguyen wrote:
> +	/* if VF failed initialization during __IAVF_INIT_GET_RESOURCES,
> +	 * it is possible for this variable to be freed there.
> +	 */
> +	if (!adapter->vf_res)
> +		return -EAGAIN;

I think I already rejected a similar patch in the past.

ethtool APIs should not return -EAGAIN, if the driver needs to wait 
for some init or reset to finish -- it should just wait, we can't 
throw errors at user space and hope it will retry.

