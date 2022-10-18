Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51141603066
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 17:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJRP71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 11:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiJRP7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 11:59:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCA3C97F7
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 08:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F352B81E8F
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 15:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F067AC433D6;
        Tue, 18 Oct 2022 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666108748;
        bh=rjrUbHLaZN5f2R/gvig9BxR9nepn3CO42tejBn7K1CM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KgDJLeRHPG1KMYft4H/kUrIAYigOE292+wPuIrW6ey7wE2XK+GqryJGozQ6N6JDHN
         1d5KN3B0KLcYvdnHZOjFzdvBPJ1j5b/Wjkgi+Ysunub0cR0eM1uSX3sqqfdGY2iNr2
         IsL7gvFJe7uE/QwVVW7T7R7q8WAx07MKwQ4EmRunkuwDJoTQG0rE/1yOvftcqlAUFi
         mFQjcNQ1tYwN3mvKgKJS5BPrBBe7mgj1LbhlOLQrcBcOUWA3LQGk3DtO1iS8ID8GDE
         GG2xj6erYR/YG1GTtewiHlNzvWhMlpsSMwTBN60504GNbCi3ustyHNZV1KTVVtmuSS
         2v4THYliNSxOA==
Date:   Tue, 18 Oct 2022 08:59:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, irusskikh@marvell.com,
        dbogdanov@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
Message-ID: <20221018085906.76f70073@kernel.org>
In-Reply-To: <CACT4oueGEDLzZLXdd_Pt+tK=CpkMM7uE9ubVL9i6wTO7VkzccA@mail.gmail.com>
References: <20221014103443.138574-1-ihuguet@redhat.com>
        <Y0lSYQ99lBSqk+eH@lunn.ch>
        <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
        <Y0llmkQqmWLDLm52@lunn.ch>
        <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
        <Y0rNLpmCjHVoO+D1@lunn.ch>
        <CACT4oucrz5gDazdAF3BpEJX8XTRestZjiLAOxSHGAxSqf_o+LQ@mail.gmail.com>
        <Y03y/D8WszbjmSwZ@lunn.ch>
        <20221017194404.0f841a52@kernel.org>
        <CACT4oueGEDLzZLXdd_Pt+tK=CpkMM7uE9ubVL9i6wTO7VkzccA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 08:15:38 +0200 =C3=8D=C3=B1igo Huguet wrote:
> Interesting solution, I didn't even think of something like this.
> However, despite not being 100% sure, I think that it's not valid in
> this case because the work's task communicates with fw and uses
> resources that are deinitialized at ndo_stop. That's why I think that
> just holding a reference to the device is not enough.

You hold a reference to the netdev just to be able to take rtnl_lock()
and check if it's still running. If it is UP you're protected from it
going down due to rtnl_lock you took. If it's DOWN, as you say, it's not
safe to access all the bits so just unlock and return.

But because you're holding the reference it's safe to cancel_work()
without _sync on down, because the work itself will check if it should
have been canceled.

Dunno if that's a good explanation :S
