Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4C44C2293
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 04:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiBXDo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 22:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiBXDo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 22:44:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7ED25A315;
        Wed, 23 Feb 2022 19:44:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F23C1615E6;
        Thu, 24 Feb 2022 03:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE95C340E9;
        Thu, 24 Feb 2022 03:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645674268;
        bh=jZ6awLcE6M5IwYTyD00u231l2Hv6lyuBrW+r29jU1AU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=InANoN3hy8jAhaH2B3j97Zd8hO6j23VdWyYcfJ9Wsp07n9vZdFBPvgkMSpv6u4jCV
         xfPjW2tmBsKmRAbyVSDNWHleKvVxbtWB5XL/i9djj0io+zeo0rXe9KPzvgP37/y7Ii
         hmXRoo2wrXQazsfVWHejRSM/TplI4Qk3/Tu/DXwS8k6Z5uiLopl/4l+zrTbB5tgTcX
         KckeDPWP5At6RQWXepyTRojXoFjQ22mcOAEL7S4T4/5EBjTjbTngreaeDTg2RGYhpo
         QXSiNFsOuq1S1/JjueU14B2dynucftb9jssvKCpbbuwEmDIyp09sVSLY08VfzD4IJz
         YyAUofYAHx3Wg==
Date:   Wed, 23 Feb 2022 19:44:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek =?UTF-8?B?TWFyY3p5a293c2tpLUfDs3JlY2tp?= 
        <marmarek@invisiblethingslab.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Brown <mcb30@ipxe.org>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        xen-devel@lists.xenproject.org (moderated list:XEN NETWORK BACKEND
        DRIVER),
        netdev@vger.kernel.org (open list:XEN NETWORK BACKEND DRIVER)
Subject: Re: [PATCH v2 1/2] Revert "xen-netback: remove 'hotplug-status'
 once it has served its purpose"
Message-ID: <20220223194426.6948b28c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222001817.2264967-1-marmarek@invisiblethingslab.com>
References: <20220222001817.2264967-1-marmarek@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Feb 2022 01:18:16 +0100 Marek Marczykowski-G=C3=B3recki wrote:
> This reverts commit 1f2565780e9b7218cf92c7630130e82dcc0fe9c2.
>=20
> The 'hotplug-status' node should not be removed as long as the vif
> device remains configured. Otherwise the xen-netback would wait for
> re-running the network script even if it was already called (in case of
> the frontent re-connecting). But also, it _should_ be removed when the
> vif device is destroyed (for example when unbinding the driver) -
> otherwise hotplug script would not configure the device whenever it
> re-appear.
>=20
> Moving removal of the 'hotplug-status' node was a workaround for nothing
> calling network script after xen-netback module is reloaded. But when
> vif interface is re-created (on xen-netback unbind/bind for example),
> the script should be called, regardless of who does that - currently
> this case is not handled by the toolstack, and requires manual
> script call. Keeping hotplug-status=3Dconnected to skip the call is wrong
> and leads to not configured interface.
>=20
> More discussion at
> https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ip=
xe.org/T/#u
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingsl=
ab.com>

Wei, Paul, do these look good?
