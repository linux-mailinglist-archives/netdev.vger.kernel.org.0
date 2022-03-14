Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888B14D88C5
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbiCNQIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242922AbiCNQID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:08:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E5B3ED3D
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 386A2B80E70
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 16:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C01C340E9;
        Mon, 14 Mar 2022 16:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647274009;
        bh=ZsIKdb/F1LpManjzY2IALzUqS3L5zm7HEqqQarnTUGE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gh84oCuU/Wrh33QBQQHdrGJrlp3pOv0yBmckwFP+BHDqYt/WSJhNGF4o5Gns7DrlN
         fo7q3p+zm1PjQqOhWuArHQTjgZzMkR71I8P+hZ8aF1BY/l4WjZZYrMO/yCUb6EGd9T
         gr5YIsLELbOcM7yHLmjGbVfvSUpKnJAzam4WmdLyjsHdkMI36uaZ5tVHNXXWut74P3
         0t7wlwZHFchH6Gpa55jYjmK6SxUwlcJwXbY9FmR01eEwt/5Vj7/wC7rB8vyxJ1rjap
         V2D3B36HijbPMkpS7PGx5D7hBekJgfkfNxRhqyvZXddnIcTojRYOY+GvcZpzykXd5C
         VMpVmNe/DE/Lw==
Date:   Mon, 14 Mar 2022 17:06:45 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jan =?UTF-8?B?QsSbdMOtaw==?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
Message-ID: <20220314170645.0df5e5c9@dellmb>
In-Reply-To: <20220314154533.blqbjpqvh2apxycz@skbuf>
References: <20220314153410.31744-1-kabel@kernel.org>
        <20220314154533.blqbjpqvh2apxycz@skbuf>
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

On Mon, 14 Mar 2022 15:45:33 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Mon, Mar 14, 2022 at 04:34:10PM +0100, Marek Beh=C3=BAn wrote:
> > Fix a data structure breaking / NULL-pointer dereference in
> > dsa_switch_bridge_leave().
> >=20
> > When a DSA port leaves a bridge, dsa_switch_bridge_leave() is called by
> > notifier for every DSA switch that contains ports that are in the
> > bridge.
> >=20
> > But the part of the code that unsets vlan_filtering expects that the ds
> > argument refers to the same switch that contains the leaving port.
> >=20
> > This leads to various problems, including a NULL pointer dereference,
> > which was observed on Turris MOX with 2 switches (one with 8 user ports
> > and another with 4 user ports).
> >=20
> > Thus we need to move the vlan_filtering change code to the non-crosschip
> > branch.
> >=20
> > Fixes: d371b7c92d190 ("net: dsa: Unset vlan_filtering when ports leave =
the bridge")
> > Reported-by: Jan B=C4=9Bt=C3=ADk <hagrid@svine.us>
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > --- =20
>=20
> Ah, wait a minute, you're missing Tobias' patch
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commi=
t/?id=3D108dc8741c203e9d6ce4e973367f1bac20c7192b
>=20
> What happened is that it was applied to "net-next" instead of "net",
> despite being correctly targeted.
> https://patchwork.kernel.org/project/netdevbpf/patch/20220124210944.37492=
35-3-tobias@waldekranz.com/
> Hmmm...

OK thx.

Marek
