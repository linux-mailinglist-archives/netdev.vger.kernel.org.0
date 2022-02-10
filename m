Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC864B05F5
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 07:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiBJF7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:59:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBJF7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:59:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF3B1C5
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 21:59:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A78C461C3F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF146C004E1;
        Thu, 10 Feb 2022 05:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644472785;
        bh=yqui7L/7F6X55A1yUi1OZ/5Q8jgUPUGVPNBYKWUhrwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hoAtn4NsXHRmwOruFPAo1X6Bm/P8gdkAESPtU0Y8S7W76Ps40KiYWoz35U65zPPGg
         SkDf3CGtH1hIhk4g646P7/0HUtaTykrrYT2eYSulmdbnrVMy6nJaLwqka6ozCVZC0O
         YvTW22VCKsc0bAiJbp3hhj3PTGilV1MGumGkacssvqA7axu+UKypQGX0jYQJ2wah52
         z+sQdpy9JXcwUgrsdrnqz5gR3h3Kn4tiM2m8fTM5a5ctVvKYJ5q0/LPeIDxNQZ5+YS
         PB/RvamjCv3sJTdVnbjDf6j6obHFLbbPdeX+urSG3xBlq/dSAIElEJTY6c6P8j7u4j
         R1cX/OZHdIJFg==
Date:   Wed, 9 Feb 2022 21:59:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: Re: [PATCH net 2/2] vlan: move dev_put into vlan_dev_uninit
Message-ID: <20220209215943.71ee15f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iLUhJz7pJRYmg3nBV0EOSFHM3ptcSbpKf=vdZPd+8MioA@mail.gmail.com>
References: <cover.1644394642.git.lucien.xin@gmail.com>
        <76c52badfdccaa7f094d959eaf24f422ae09dec6.1644394642.git.lucien.xin@gmail.com>
        <20220209175558.3117342d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADvbK_ckY31iZq+++z6kOdd5rBYMyZDNe8N_cHT2wAWu8ZzoZA@mail.gmail.com>
        <20220209212817.4fe52d3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iLUhJz7pJRYmg3nBV0EOSFHM3ptcSbpKf=vdZPd+8MioA@mail.gmail.com>
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

On Wed, 9 Feb 2022 21:49:51 -0800 Eric Dumazet wrote:
> > Feels like sooner or later we'll run into a scenario when reversing will
> > cause a problem. Or some data structure will stop preserving the order.
> >
> > Do you reckon rewriting netdev_run_todo() will be a lot of effort or
> > it's too risky?  
> 
> This is doable, and risky ;)
> 
> BTW, I have the plan of generalizing blackhole_netdev for IPv6,
> meaning that we could perhaps get rid of the dependency
> about loopback dev, being the last device in a netns being dismantled.

Oh, I see..

I have no great ideas then, we may need to go back to zeroing
vlan->real_dev and making sure the caller can deal with that.
At least for the time being. Xin this was discussed at some 
length in response to the patch under Fixes.
