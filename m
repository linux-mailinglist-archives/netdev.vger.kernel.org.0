Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7CD6BBDA0
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjCOTw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbjCOTw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:52:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6793497FE6
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 12:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0301C61D43
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 19:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146D4C433EF;
        Wed, 15 Mar 2023 19:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678909965;
        bh=iQnIIa3j3jVCIFoKZPD3PBAOjjMIevquBxs1unHicG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rcyaNxz8/V6etm++j+h2h8xJXf2ngdv4qki9jVImZKCjTKdq6lIcn5ascWngjnfvX
         LQpNGe6KTTxgd0SSB54YVxzvR/JQ2D704YtvUob7HG0vw+PqnpLUBVPvBQ4y0l/fjS
         jLShhOWzY/UQ5cJbBXkKXInUg7zIXBGzJtRLu7FECfDr3BQEC9wJc3YSi97Yu9e+k5
         gwcu4dcHH/wGR/D8MDJVR1f7MgT0xFlQ6NyFO6HOwVWJ8vJmuMfKY5G3hrAG59KH+Y
         SA/3k/vSxKOt9tXTrBcLgFkF/I54Z0Pwws4FxuUEl8hzzXeJaAt65gKqIBT4l6WoN1
         n2GDpbbm0CgwQ==
Date:   Wed, 15 Mar 2023 12:52:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Paul Holzinger <pholzing@redhat.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
Subject: Re: [PATCH v1 net 1/2] tcp: Fix bind() conflict check for
 dual-stack wildcard address.
Message-ID: <20230315125244.1fa0610a@kernel.org>
In-Reply-To: <1f37c8d4-8a1d-bc06-5b65-9357a7766ad7@leemhuis.info>
References: <20230312031904.4674-1-kuniyu@amazon.com>
        <20230312031904.4674-2-kuniyu@amazon.com>
        <533d3c1a-db7e-6ff2-1fdf-fb8bbbb7a14c@leemhuis.info>
        <20230315002625.49bac132@kernel.org>
        <1f37c8d4-8a1d-bc06-5b65-9357a7766ad7@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 09:05:29 +0100 Thorsten Leemhuis wrote:
> On 15.03.23 08:26, Jakub Kicinski wrote:
> > On Sun, 12 Mar 2023 12:42:48 +0100 Linux regression tracking (Thorsten
> > Leemhuis) wrote:  
> >> Link:
> >> https://lore.kernel.org/netdev/CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com/
> >> [1]
> >> Fixes: 5456262d2baa ("net: Fix incorrect address comparison when
> >> searching for a bind2 bucket")
> >> Reported-by: Paul Holzinger <pholzing@redhat.com>
> >> Link:
> >> https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com/
> >> [0]  
> > 
> > I tried to fix this manually when applying but:
> >  - your email client wraps your replies
> >  - please don't reply to patches with tags which will look to scripts
> >    and patchwork like tags it should pull into the submission
> >    (Reported-by in particular, here)  
> 
> Sorry for the mixup and thx for letting me know, will simply quote my
> suggestion next time, that should avoid both problems.

FWIW indenting with spaces would work too, for our scripts at least.
We match on tags only at start of the line.
