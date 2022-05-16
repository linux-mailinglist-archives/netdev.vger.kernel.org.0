Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456DB5294B8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 01:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348696AbiEPXKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 19:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346400AbiEPXKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 19:10:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CB546641
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 16:10:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A26960B6C
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 23:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A378EC385B8;
        Mon, 16 May 2022 23:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652742602;
        bh=ODus1vdJs/mmBcG7lsJ/w6IvJXmqeUpwcaI4m5SNt94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UMI/N3XkK97RCkAXUHjpowM67ldPkdDpnt2WA0Rxm8/FE/hLprALdwTKUzoppDAri
         AQSBSYEqlsj8Om2DgtahdxwKpKObnCUpo6xTRkqzG2goZLP+KA1JP55ZrZBJJYbXNg
         fzLbXPASiMGWorLDVRxfiqJEHt/2m+GiNIwx3RJHJXpQzP9ZtglLdDhMcBoXhGB09K
         ibvIIsT4HKp3NQZY8HZbjQkkXIpKA2+x20A4LDUaTYbg/n+RHyjBrndN56oDKd3+Vt
         Y8y7lJinp93m8FaHfPlCVFOGSG+1XMvnewdaC46a9EzNKvPNA6gypvx+GNg/U/8+Vp
         aKIMNo8JWdrbg==
Date:   Mon, 16 May 2022 16:10:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] amt: fix gateway mode stuck
Message-ID: <20220516161001.78b3b49b@kernel.org>
In-Reply-To: <20220514131346.17045-1-ap420073@gmail.com>
References: <20220514131346.17045-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 May 2022 13:13:46 +0000 Taehee Yoo wrote:
> -			if (amt_advertisement_handler(amt, skb))
> +			err = amt_advertisement_handler(amt, skb);
> +			if (err)
>  				amt->dev->stats.rx_dropped++;
> -			goto out;
> +			break;

There's another amt->dev->stats.rx_dropped++; before the end of this
function which now won't be skipped, I think you're counting twice.
