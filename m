Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B896D5ED1FC
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiI1A0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiI1A0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:26:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097F5D4AAE;
        Tue, 27 Sep 2022 17:26:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A92CB81E3B;
        Wed, 28 Sep 2022 00:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18053C433D6;
        Wed, 28 Sep 2022 00:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664324779;
        bh=jGniGtl3LSg2UQcTQAQhK2coEuaQhXHf8hbCfu07B4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fEP2im6sdl2dYYrSH86YGCJEIh+7whof9wI0Hg7ln6oaJsq+cxtAMKX4vXc8uetHY
         Hpepo9+BxVpVOagPPULpB+cQTNcx+8V30lGXkeedxiccGCzjGU69cbpZ3BKXlL3tNg
         +LiekR2dFQF+ENi0BhFTaEmzlFhEhFuCRDQzn+K2RW5H9Hge8cluznZEbEvvaZHgZ1
         xhg8nWPc7Eso4c5FVj5gzuUXUM6EJkCE+LykTpsvjAFCiJWZ+6s0IKbIpePI/9hPM7
         N4InSs3TjSvNQ8fEMlPSjK/REY4NENNBXzCgu2/PXTi4e85RAAyeS7i2g0RUttD3Lj
         obiFCiG4WP19A==
Date:   Tue, 27 Sep 2022 17:26:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de
Subject: Re: [PATCH V3] mISDN: fix use-after-free bugs in l1oip timer
 handlers
Message-ID: <20220927172618.58f238d6@kernel.org>
In-Reply-To: <20220924021842.71754-1-duoming@zju.edu.cn>
References: <20220924021842.71754-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Sep 2022 10:18:42 +0800 Duoming Zhou wrote:
> +	del_timer_sync(&hc->keep_tl);
> +	del_timer_sync(&hc->timeout_tl);
> +	cancel_work_sync(&hc->workq);
> +	del_timer_sync(&hc->keep_tl);
>  	cancel_work_sync(&hc->workq);

Why not add a bit which will indicate that the device is shutting 
down and check it in places which schedule the timer?
I think that's much easier to reason about and we won't need to do 
this rep cancel procedure.
