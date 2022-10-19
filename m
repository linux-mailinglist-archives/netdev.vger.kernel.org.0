Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8BB604BF6
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbiJSPpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiJSPpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:45:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1695931EEF
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 08:40:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A01D618E8
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 15:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C2EC433C1;
        Wed, 19 Oct 2022 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666193954;
        bh=xtBOQtBhgH4Xk41gXCrXEWt2P44azlT3ZLHoxg80dS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oXpLodJxMMz/uo/DuGDMDpmHWuZsM3KAB48k60livmZ7Y9Rb9YZeAPcJEGeCoiO+Y
         a/F/lEGz+5cL9J9xf1aC/aLda1S2UeY6r6EqxeCf8q8FXJTSC6xljSShKM15Y+7U4c
         ss8A3V1CRXDGC8Jb2dof7tIEAyEOMftrj9OpOYcjV+AyGrY9CjffwSJGBrII8GKzLH
         QenvlZosQKbCLuYtXt9xHyMv2xC5YaHPgtiHSgcFyt4aRSkiI7qIzJPhAK7ac/6kh+
         QX9Dk9ekhzEWcsBr1B28dddoEn7pfN7WGrHe5JKFEulevXus9mWNE8+zjRxebwnahZ
         V0uZfg4FkU1og==
Date:   Wed, 19 Oct 2022 08:39:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, irusskikh@marvell.com,
        dbogdanov@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
Message-ID: <20221019083913.09437041@kernel.org>
In-Reply-To: <CACT4oud9B-yCD5jVWRt9c4JXq2_Ap-qMkr9y3xJ5cgTTggYT1w@mail.gmail.com>
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
        <20221018085906.76f70073@kernel.org>
        <CACT4oud9B-yCD5jVWRt9c4JXq2_Ap-qMkr9y3xJ5cgTTggYT1w@mail.gmail.com>
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

On Wed, 19 Oct 2022 08:18:29 +0200 =C3=8D=C3=B1igo Huguet wrote:
> Yes, now I get it.
>=20
> However, I think I won't use this strategy this time: rtnl_lock is
> only needed in the work task if IS_ENABLED(CONFIG_MACSEC). Acquiring
> rtnl_lock every time if macsec is not enabled wouldn't be protecting
> anything, so it would be a waste. I think that the strategy suggested
> by Andrew of adding a dedicated mutex to protect atlantic's macsec
> operations makes more sense in this case. Do you agree?

Dunno, locks don't protect operations, they protect state (as the link
Andrew sent probably explains?), so it's hard to say how easily you can
inject a new lock into this driver covering relevant bits. My gut
feeling is that refcounting would be less error prone. But I don't feel
strongly enough to force one choice over the other.
