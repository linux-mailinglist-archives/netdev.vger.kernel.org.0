Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8F34D65E7
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349459AbiCKQT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348767AbiCKQT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:19:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5969F1965EA;
        Fri, 11 Mar 2022 08:18:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2E90B82A09;
        Fri, 11 Mar 2022 16:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA18CC340E9;
        Fri, 11 Mar 2022 16:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647015497;
        bh=MtSfFafo4fW56NZknW5da1zjtvVYaxI2+8q8/FKCwDg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hyODFLCWFhfgwMCC2kUZM0jFfymAIh6K/MjInSDjjFLY4JFpiWF0kdBA1vGhtehx5
         /iMk9a1IdpI567GuQmZmOG6c0r2UvR+DNsDRPrA7EB8J45CrK2ECqkMDFtfcO6lWHJ
         Lqd3bIEnmg1Kl/tnP4NBUXBSzxQs5Ef+RaSJsAgzzMmjYz43ekxc9j9Adp4XVQMEzw
         mkSFpSMFAeGOLkYesvZJQcfeKONRxKXOcv4P7F01aekV7CJLH9Jht6XEBXBX6sAc3b
         BOIBLoW/WqqjR/5Dd/6apfaVXVKQzD94Q7sPgC5WGBb+xT2J2UkJidDvaKPWmMps6u
         rLFFsDpH7XENA==
Date:   Fri, 11 Mar 2022 08:18:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mingbao Sun <sunmingbao@tom.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tyler.sun@dell.com,
        ping.gan@dell.com, yanxiu.cai@dell.com, libin.zhang@dell.com,
        ao.sun@dell.com
Subject: Re: [PATCH] tcp: export symbol tcp_set_congestion_control
Message-ID: <20220311081815.20e26640@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220311071930.GA18301@lst.de>
References: <20220310134830.130818-1-sunmingbao@tom.com>
        <20220310124825.159ce624@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220311071930.GA18301@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 08:19:30 +0100 Christoph Hellwig wrote:
> On Thu, Mar 10, 2022 at 12:48:25PM -0800, Jakub Kicinski wrote:
> > On Thu, 10 Mar 2022 21:48:30 +0800 Mingbao Sun wrote: =20
> > > Since the kernel API 'kernel_setsockopt' was removed, and since the
> > > function =E2=80=98tcp_set_congestion_control=E2=80=99 is just the rea=
l underlying guy
> > > handling this job, so it makes sense to get it exported. =20
> >=20
> > Do you happen to have a reference to the commit which removed
> > kernel_setsockopt and the justification?  My knee jerk reaction
> > would the that's a better path than allowing in-kernel socket users=20
> > to poke at internal functions even if that works as of today. =20
>=20
> This was part of the set_fs() removal. Back then we decided we'd rather
> have type-safe APIs for in-kernel users, which in total was a major
> removal of code lines.

I see, thanks. I guess no point speculating, we can revisit if
any bugs due to direct callers actually materialize.
