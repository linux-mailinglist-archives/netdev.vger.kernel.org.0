Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D538B4D8A22
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiCNQue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244294AbiCNQtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:49:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF9C28993
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:47:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0EF3B80DAF
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 16:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44913C340E9;
        Mon, 14 Mar 2022 16:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647276424;
        bh=y6ve0JQmIubH7lp/f5mBP7QvjBZzSLWz7zy4rk0W5Sg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gHzZ+rsHOWYMbjQtMi7whEUGzkheVQAEA91x3c8kk7MkaH/qPtOYMnlxjTBP0qy5a
         cSjU/fuP4XSGzTpy/OY51pIOo2EOd973dCEtRKK1rSfQSu9/Ks8yrwwY/TBQNK4q6L
         Fb8CKE+ggy6J5ReWS/3awC54dNh8ey3HyhKpKzQC9l8V3LFJ7Zd6w7fD1OSdeIWpxs
         WFij86aAGhApruWgwoeq1QXucWxmGGskQe0Pg+bS9K/XNcar5ExGo3KaU7VA8cWfU2
         ILonTQ//0S4C9TauRXENeC8cj7qh4UjyqukLOMehZ/13KewzAlptySYXffAtUGrogi
         4Na4PV6WxF12A==
Date:   Mon, 14 Mar 2022 17:47:00 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Jan =?UTF-8?B?QsSbdMOtaw==?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
Message-ID: <20220314174700.56feb3da@dellmb>
In-Reply-To: <87tuc0lelc.fsf@waldekranz.com>
References: <20220314153410.31744-1-kabel@kernel.org>
        <87tuc0lelc.fsf@waldekranz.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 16:48:47 +0100
Tobias Waldekranz <tobias@waldekranz.com> wrote:

> On Mon, Mar 14, 2022 at 16:34, Marek Beh=C3=BAn <kabel@kernel.org> wrote:
> > Fix a data structure breaking / NULL-pointer dereference in
> > dsa_switch_bridge_leave().
> >
> > When a DSA port leaves a bridge, dsa_switch_bridge_leave() is called by
> > notifier for every DSA switch that contains ports that are in the
> > bridge.
> >
> > But the part of the code that unsets vlan_filtering expects that the ds
> > argument refers to the same switch that contains the leaving port.
> >
> > This leads to various problems, including a NULL pointer dereference,
> > which was observed on Turris MOX with 2 switches (one with 8 user ports
> > and another with 4 user ports).
> >
> > Thus we need to move the vlan_filtering change code to the non-crosschip
> > branch.
> >
> > Fixes: d371b7c92d190 ("net: dsa: Unset vlan_filtering when ports leave =
the bridge")
> > Reported-by: Jan B=C4=9Bt=C3=ADk <hagrid@svine.us>
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > --- =20
>=20
> Hi Marek,
>=20
> I ran into the same issue a while back and fixed it (or at least thought
> I did) in 108dc8741c20. Has that been applied to your tree? Maybe I
> missed some tag that caused it to not be back-ported?

Tobias, I can backport these patches to 5.4+ stable. Or have you
already prepared backports?

Marek
