Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B4C4F7593
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbiDGGEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiDGGEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:04:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9B61760CE;
        Wed,  6 Apr 2022 23:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CDE661CEE;
        Thu,  7 Apr 2022 06:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3BBC385A4;
        Thu,  7 Apr 2022 06:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649311333;
        bh=BgaoYC9KZxn0Wvwf28Pr/nfsxJngtamJAwW8EUBDJDE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W4EgE0vqt3708h/Y4wutArGRl5uSfqQN1wNoUCyczzDxUizUPppb0Fe0nndPt2ZGH
         SxEqZnw/1mMUCKmYsKnsnr0gtEJ50h58N6zPrs934avYOk3zYQdq0CPEJd/VdDP/2g
         QDhZILVA7xELVGlqBhY5J8uS7d+P91b+m5nlBMGfJgjubVDra5ZzLVgNJQm9IdnwU0
         rRlkhQKxXQWmEo6TRFwOUdib55HQ9dfQQezMYKuBCQuEus2GiFg59CvGeBxbKtk/Ic
         MKh24V93uCOlGKgAGaZzv0xetxOimB8LkoifQMsL3stSzTTuuTY9rqWtlhW8WhXQVb
         uFcJT6VyEDhvg==
Date:   Wed, 6 Apr 2022 23:02:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Manish Chopra <manish.chopra@cavium.com>,
        Ariel Elior <ariel.elior@cavium.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] qede: confirm skb is allocated before using
Message-ID: <20220406230212.2763b868@kernel.org>
In-Reply-To: <b86829347bc923c3b48487a941925292f103588d.1649210237.git.jamie.bainbridge@gmail.com>
References: <b86829347bc923c3b48487a941925292f103588d.1649210237.git.jamie.bainbridge@gmail.com>
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

On Wed,  6 Apr 2022 11:58:09 +1000 Jamie Bainbridge wrote:
> qede_build_skb() assumes build_skb() always works and goes straight
> to skb_reserve(). However, build_skb() can fail under memory pressure.
> This results in a kernel panic because the skb to reserve is NULL.
> 
> Add a check in case build_skb() failed to allocate and return NULL.
> 
> The NULL return is handled correctly in callers to qede_build_skb().
> 
> Fixes: 8a8633978b842 ("qede: Add build_skb() support.")
> Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>

FTR commit 4e910dbe3650 ("qede: confirm skb is allocated before using")
in net.
