Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC255A0285
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 22:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239947AbiHXUMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 16:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiHXUMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 16:12:31 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02FC18351;
        Wed, 24 Aug 2022 13:12:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661371910; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=C8kXq44ddm3iaKNd1oRbVUneTC5/YlLrbJKbYJFrSyOwIJMx/hjq0CgILBvnIFJPAVQSicL+m8qOpokoVw3ZMaPWfY1DqHUgDEFlLM4BR9i89XFS87vmf19Y8fqV0KN/bA2q4Xjyd0rqGh14dB9VWNk7WC1qPeTFNuguiIM83M8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1661371910; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=o8+2mxY1s6gN8Aqlaw9vhuuz0VwD5wwLUGg9+r5eCc8=; 
        b=a2y/UZCDL2gII40gkzMEX9teyJwQWRpdW3QqwSBCO0+lko9tBStKMq5Y9iXI32kmFCGqO+zsYv0vipLJ0JM4ZtGxGEIimp76gV0RiAH+uLPsBv7xo6taYzrPvLNRJKjocfXPwGu9qkAnzZxJ8hvAraFh47hj1R4DbRzuU/D72L8=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661371910;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=o8+2mxY1s6gN8Aqlaw9vhuuz0VwD5wwLUGg9+r5eCc8=;
        b=f6VU8o9ZHQIjTgQ3f038x8f+Fkqlna8W0jgLN3dR6uixc8bnzogi1i9up8y56WTy
        RDBnD0ONbiYGEnVYm/gCbndaiFK/AmidbOtlavg2JYTJHdgCJ7krSJGUL/6L26Ttrcr
        6Nbi62weq+h7ahrASJ+PzNuuJedi/aX/74v2u5QI=
Received: from localhost.localdomain (103.249.233.18 [103.249.233.18]) by mx.zoho.in
        with SMTPS id 1661371907172679.3555503675442; Thu, 25 Aug 2022 01:41:47 +0530 (IST)
From:   Siddh Raman Pant <code@siddh.me>
To:     Siddh Raman Pant <code@siddh.me>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com
Message-ID: <20220824201136.182039-1-code@siddh.me>
Subject: Re: [PATCH] wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected
Date:   Thu, 25 Aug 2022 01:41:36 +0530
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814151512.9985-1-code@siddh.me>
References: <20220814151512.9985-1-code@siddh.me>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Aug 2022 20:45:12 +0530  Siddh Raman Pant  wrote:
> When we are not connected to a channel, sending channel "switch"
> announcement doesn't make any sense.
>=20
> The BSS list is empty in that case. This causes the for loop in
> cfg80211_get_bss() to be bypassed, so the function returns NULL
> (check line 1424 of net/wireless/scan.c), causing the WARN_ON()
> in ieee80211_ibss_csa_beacon() to get triggered (check line 500
> of net/mac80211/ibss.c), which was consequently reported on the
> syzkaller dashboard.
>=20
> Thus, check if we have an existing connection before generating
> the CSA beacon in ieee80211_ibss_finish_csa().
>=20
> Fixes: cd7760e62c2a ("mac80211: add support for CSA in IBSS mode")
> Bug report: https://syzkaller.appspot.com/bug?id=3D05603ef4ae8926761b678d=
2939a3b2ad28ab9ca6
> Reported-by: syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org

Tested-by: syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com

Syzbot is now booting properly and the test ran successfully.

Thanks,
Siddh

> Signed-off-by: Siddh Raman Pant <code@siddh.me>
> ---
> The fixes commit is old, and syzkaller shows the problem exists for
> 4.19 and 4.14 as well, so CC'd stable list.
>=20
>  net/mac80211/ibss.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index d56890e3fabb..9b283bbc7bb4 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -530,6 +530,10 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_i=
f_data *sdata)
> =20
>  =09sdata_assert_lock(sdata);
> =20
> +=09/* When not connected/joined, sending CSA doesn't make sense. */
> +=09if (ifibss->state !=3D IEEE80211_IBSS_MLME_JOINED)
> +=09=09return -ENOLINK;
> +
>  =09/* update cfg80211 bss information with the new channel */
>  =09if (!is_zero_ether_addr(ifibss->bssid)) {
>  =09=09cbss =3D cfg80211_get_bss(sdata->local->hw.wiphy,
> --=20
> 2.35.1

