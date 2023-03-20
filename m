Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B713C6C20E7
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjCTTIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjCTTIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:08:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180D24AFF4
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 12:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62AA1B80E64
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 18:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D74C433EF;
        Mon, 20 Mar 2023 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679338752;
        bh=WbO+w6YvDfc8wCgChg8bFHLaX3xQ97m48IEY76moR7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tNSkq3uA04UiMnUm6bwu/+NcqzaO3a74ietJb6rRXaHqBtve4ZKj3YPw/d9FBi5cr
         39vyXEAbXn85ltkuJyoX8Pe9/6/mvej+hjJ46zMGK6NiqHTrZKO8RC090je+ApjfJ2
         xkWL/paswDzkuQCDYxo7GpcZ1h7bxTY2jx3G6a/ILS27LQwH+QMJbnz+JKor+fhoLH
         7xSwQ80QQ9cNgUto3oIfjZd07kej39gCTZ1AlpX2OMZDJjDXLO/56CyYCk8V6zJhpT
         y6j1Xqwmco2FVNsd56OERGrH0fgnTe7MmqH4tSVj1ftycc6/Jz8QEXW9sOVPBcDD9r
         5SN1IdnhrNsaA==
Date:   Mon, 20 Mar 2023 11:59:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 2/4] ynl: populate most of the ethtool spec
Message-ID: <20230320115910.50374a67@kernel.org>
In-Reply-To: <CAKH8qBvkFvyyPwah7uDiJP2tm7k4NZ10Kgw2ykDs8jqOs4gXtg@mail.gmail.com>
References: <20230318002340.1306356-1-sdf@google.com>
        <20230318002340.1306356-3-sdf@google.com>
        <20230317213304.2010ed71@kernel.org>
        <CAKH8qBvkFvyyPwah7uDiJP2tm7k4NZ10Kgw2ykDs8jqOs4gXtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 11:03:33 -0700 Stanislav Fomichev wrote:
> On Fri, Mar 17, 2023 at 9:33=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> =
wrote:
> > On Fri, 17 Mar 2023 17:23:38 -0700 Stanislav Fomichev wrote: =20
> > > Things that are not implemented:
> > > - cable tests
> > > - bitmaks in the requests don't work (needs multi-attr support in ynl=
.py)
> > > - stats-get seems to return nonsense =20
> >
> > Hm. What kind of nonsense? =20
>=20
> {'grp': {'id': 1, 'ss-id': 18}}
>=20
> But I guess that's because I'm not passing the group bitmask correctly?

Hm, or the driver you're trying does not have any _structured_ stats?
Does

  ethtool -S \* --all-groups

show anything? Note that these are not all the old ethtool -S stats.

> > > - notifications are not tested
> > > - features-nft has hard-coded value:13, not sure why it skews =20
> >
> > ETHTOOL_MSG_FEATURES_SET_REPLY exists but there is no reply:
> > section in the spec. =20
>=20
> Ah, good catch, I guess something like this would do? It doesn't have
> to be a new empty msg?
> reply:
>   attributes: *feature

Oh right, there's an actual reply to features. I thought it was just
reserved but we need to return to the user space what we managed to
set and what we didn't. Makes sense.
