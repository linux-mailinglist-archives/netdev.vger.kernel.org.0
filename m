Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B69A6DA6E1
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbjDGBVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238839AbjDGBVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:21:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E6D9779
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 18:21:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF72261007
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07876C433D2;
        Fri,  7 Apr 2023 01:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680830504;
        bh=E8IBCHckihs5jm00bL6lgLsAIBGeCNLspjguikQJc1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eTH47rF5TrcepzyuU/lP+BdToPKemFVxbX0uG00qT9ETWssttcmP1vZpA56oXeWx0
         iLbp/JeinCOrueXJab9UBAUM5CU2WzfW+A2Sd50oZKs65zst52poG5rd79L22n8Z2v
         LFz6Jv8IbrMiWFQ46hlmhbj2ib5LP3liYpjr+enmniZlgNYkYMfRh8/8ZBgv7nIX0U
         hB1BV/gO5Xc9R6q1HqgvGRPNVhTB5pDty1uU9MOD68uuQl6gfupLoqVCv2LR0+vyPy
         08rh37IGzZDuKAhW88r1lPGpjbyRS2mIyn711S55tbAq1ozChyaMudys2XqiaZ7QL9
         qzSruuAil7SZw==
Date:   Thu, 6 Apr 2023 18:21:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230406182143.38581902@kernel.org>
In-Reply-To: <ZC9ueqlByZyf0HUO@gondor.apana.org.au>
References: <20230403085601.44f04cd2@kernel.org>
        <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
        <20230403120345.0c02232c@kernel.org>
        <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
        <1e9bbdde-df97-4319-a4b7-e426c4351317@paulmck-laptop>
        <ZC5VbfkTIluwKYDn@gondor.apana.org.au>
        <dba8aec7-f236-4cb6-b53b-fabefcfa295a@paulmck-laptop>
        <20230406074648.4c26a795@kernel.org>
        <ZC9qns9e33LUuO8q@gondor.apana.org.au>
        <20230406180337.599b6362@kernel.org>
        <ZC9ueqlByZyf0HUO@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Apr 2023 09:14:34 +0800 Herbert Xu wrote:
> Right, netconsole is the one exception that can occur in any
> context.  However, as I said in the previous email I don't see
> how this can break the wake logic and leave the queue stopped
> forever.

Yup, agreed! just wanted to check I'm not missing some netpoll detail :)
