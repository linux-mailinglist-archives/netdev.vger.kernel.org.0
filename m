Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCE76DCE74
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 02:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjDKA0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 20:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDKA03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 20:26:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4D926A1
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 17:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41FF26160D
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 00:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BACC433D2;
        Tue, 11 Apr 2023 00:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681172787;
        bh=8gBSBvod+gQ/7iANhZZc8iPwUleKzGG5aqSzo9bR2Ks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R6eY3Gz6v3r5t3PiYDcoJDWQHRRn/SgDRwAieifUQN/k3UP3ACIC4Rug3Y1yuL+Uq
         QLglH8UN612Xu34VcXZM5xSeSMSwHOkNn+EicVK2bPtuEf5qeg27nyLbM9Dvz2My0N
         jaBZULL3/QI4yH2Vu/fQVlos6Ro3/9PLIY3wAUjHOnDn3fWGSlSi3r4HojmbgDzdZS
         quu8Ir7oiS1B1A8UrYZR9zW63dR5ehvCU8TYFSYIN+WJzoncgjD94W8ORfpXCfQa4h
         SPXY0CKpLPTKm9LVx/4aW613sNG7pNWVIosYZBjsmmOvpzrBwa6rK8Cf+D508CgdmM
         rKYT03jImIS+Q==
Date:   Mon, 10 Apr 2023 17:26:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing
 SKBs
Message-ID: <20230410172626.443a00ca@kernel.org>
In-Reply-To: <20230404074733.22869-1-liangchen.linux@gmail.com>
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Apr 2023 15:47:33 +0800 Liang Chen wrote:
> -	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
> +	if ((to->pp_recycle != from->pp_recycle)
> +		|| (from->pp_recycle && skb_cloned(from)))
>  		return false;

It should be formatted like this:

	if (to->pp_recycle != from->pp_recycle ||
	    (from->pp_recycle && skb_cloned(from)))
