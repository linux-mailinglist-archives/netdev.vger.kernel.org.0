Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76B150C387
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiDVWxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbiDVWwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:52:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717F93AA87B;
        Fri, 22 Apr 2022 15:15:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7465CB83272;
        Fri, 22 Apr 2022 22:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2762C385A4;
        Fri, 22 Apr 2022 22:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650665667;
        bh=OBcxSR9xi8xcrAi/LuWUvS+xg1jLOhXBymc5euRWtvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vxp3cZDongmz0cuL/Uq7z3oAQEThdZyXloJYSjDrME+6Sc2UXKCBMT5RWtp9sZdEr
         ZA3VB5Xx6se4O0cDs4APAktjZ8Iv29pnuNCxF3Yx7eyE5zaMc4xWqFUEgTQN3fkJKJ
         rmR+aMwcDhFyY06JiVfwlv5mtEziLkJx++OnYV3pySFXCMA5/yP1R3MnrjbsC0s9cw
         fcYNvq0pySITAQMLZwj2Sv5oQ3LFHwk6OT8Kduspy+wCXCmejYTSgXqrqgt5b0cTRh
         6cpYzTJuMTAGA82EuswOhRY9SwNryS8qgmfs66Au7Fx7fVWhlbjcQJQL+XLp7CCxjJ
         G4qaidBDIpgIQ==
Date:   Fri, 22 Apr 2022 15:14:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bridge: switchdev: check br_vlan_group()
 return value
Message-ID: <20220422151425.7a3f90d4@kernel.org>
In-Reply-To: <c945ebff-02fe-f2d5-656f-6bdfc46416f1@blackwall.org>
References: <20220421101247.121896-1-clement.leger@bootlin.com>
        <c945ebff-02fe-f2d5-656f-6bdfc46416f1@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Apr 2022 13:17:51 +0300 Nikolay Aleksandrov wrote:
> On 21/04/2022 13:12, Cl=C3=A9ment L=C3=A9ger wrote:
> > br_vlan_group() can return NULL and thus return value must be checked
> > to avoid dereferencing a NULL pointer.
> >=20
> > Fixes: 6284c723d9b9 ("net: bridge: mst: Notify switchdev drivers of VLA=
N MSTI migrations")
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> >  net/bridge/br_switchdev.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> > index 81400e0b26ac..8f3d76c751dd 100644
> > --- a/net/bridge/br_switchdev.c
> > +++ b/net/bridge/br_switchdev.c
> > @@ -354,6 +354,8 @@ static int br_switchdev_vlan_attr_replay(struct net=
_device *br_dev,
> >  	attr.orig_dev =3D br_dev;
> > =20
> >  	vg =3D br_vlan_group(br);
> > +	if (!vg)
> > +		return 0;
> > =20
> >  	list_for_each_entry(v, &vg->vlan_list, vlist) {
> >  		if (v->msti) { =20
>=20
> Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

Thanks! Applying to net tho, the patch in question is already=20
in Linus's tree.
