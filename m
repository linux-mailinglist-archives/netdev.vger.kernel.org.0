Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A4B6DA6C6
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237645AbjDGBDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbjDGBDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:03:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FE683F2
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 18:03:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7646164DF9
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C478C4339C;
        Fri,  7 Apr 2023 01:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680829418;
        bh=iGMTsU2ty2QIMuG0VcY+/ff4vz9mwr9t5OBdQ7oME3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bweDL7wJiFxvmWedeo6SRs6zC/5dkNMLJVphIeCLd2TgVhLIDBJsz/cupVvQm5JHy
         IC/j43W73hDMvax1n30XK+ulBl4fa6U+WFFJPcOp/KsAKstOoK0AMmRCUMBU3Ka3+g
         ssm9LrneLtrA9qkLtWLiOcTYFXDMtvcqdJ5Oosf1YpMemo5D5hct13rsM5xljx/ePY
         D8/guTezxF8c2FMUkXjGkouq3/pQhVhKMh9HIL1jGRGl9Gh0TvoEZ81t9GeGkfXi+R
         Fmk9oT8uxrGC2lyoq+OYEB4Z0wKJvf8/mi1cfRn19+IAU2iNe2XH/7czzI4Uh6ShKZ
         DPYGKLjRAVHyg==
Date:   Thu, 6 Apr 2023 18:03:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230406180337.599b6362@kernel.org>
In-Reply-To: <ZC9qns9e33LUuO8q@gondor.apana.org.au>
References: <20230401115854.371a5b4c@kernel.org>
        <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
        <20230403085601.44f04cd2@kernel.org>
        <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
        <20230403120345.0c02232c@kernel.org>
        <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
        <1e9bbdde-df97-4319-a4b7-e426c4351317@paulmck-laptop>
        <ZC5VbfkTIluwKYDn@gondor.apana.org.au>
        <dba8aec7-f236-4cb6-b53b-fabefcfa295a@paulmck-laptop>
        <20230406074648.4c26a795@kernel.org>
        <ZC9qns9e33LUuO8q@gondor.apana.org.au>
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

On Fri, 7 Apr 2023 08:58:06 +0800 Herbert Xu wrote:
> Packet transmit can only occur in process context or softirq context

I couldn't find a check in netpoll/netconsole which would defer
when in hardirq. Does it defer?
