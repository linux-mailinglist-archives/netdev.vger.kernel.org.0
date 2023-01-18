Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E15672338
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjARQ3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjARQ2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:28:55 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8493259E63;
        Wed, 18 Jan 2023 08:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=daHAY+DebOZfhDvBIyF627C8PzCUTWvqdFX/bjJDLm0=;
        t=1674059189; x=1675268789; b=sNNQ8oeIrM5h1QIu3XyOdGocibYdVzHlyQImpgljf8mKlnS
        X/TJlypvgvgkTjUs1dGnOFwvyEodD99f20hFEzamWGPTc0Pb7GqTtPlCELOUM0rviQP+v8Nt+Nl1+
        CZcZG8ppVgJaQBibwpfx5cd/MaKmOOY+cUy+6xs/QCxQ8MRfX00AyhQCbiSelJjmj1ExTXAyuj7yA
        j4mqiIRK5w1vPC3AzcbBbqrXiFTPZSjlZICHMoy3rF5pt0JU4JdXyPPHgOQ43rya+oZYQlOtTOprc
        EBLhjHDLxgDmsLFLCq6we44ByG3q3ZMrcYkT8OADmULUo4MjGxR4KhLVuoed3BFw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pIBGW-005fj9-0Y;
        Wed, 18 Jan 2023 17:26:20 +0100
Message-ID: <c7eac35785bf672b3b9da45c41baa4149a632daa.camel@sipsolutions.net>
Subject: Re: [PATCH next] wifi: nl80211: emit CMD_START_AP on multicast
 group when an AP is started
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alvin =?UTF-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alvin =?UTF-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 18 Jan 2023 17:26:19 +0100
In-Reply-To: <20221209152836.1667196-1-alvin@pqrs.dk>
References: <20221209152836.1667196-1-alvin@pqrs.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-12-09 at 16:28 +0100, Alvin =C5=A0ipraga wrote:
>=20
> This is problematic because it is possible that the network
> configuration that should be applied is a function of the AP's
> properties such as SSID (cf. SSID=3D in systemd.network(5)). As
> illustrated in the above diagram, it may be that the AP with SSID "bar"
> ends up being configured as though it had SSID "foo".
>=20

You might not care if you want the SSID, but it still seems wrong:

> +static void nl80211_send_ap_started(struct wireless_dev *wdev)
> +{
> +	struct wiphy *wiphy =3D wdev->wiphy;
> +	struct cfg80211_registered_device *rdev =3D wiphy_to_rdev(wiphy);
> +	struct sk_buff *msg;
> +	void *hdr;
> +
> +	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		return;
> +
> +	hdr =3D nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_START_AP);
> +	if (!hdr)
> +		goto out;
> +
> +	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
> +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex) ||
> +	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
> +			      NL80211_ATTR_PAD) ||
> +	    (wdev->u.ap.ssid_len &&
> +	     nla_put(msg, NL80211_ATTR_SSID, wdev->u.ap.ssid_len,
> +		     wdev->u.ap.ssid)))
> +		goto out;
> +
> +	genlmsg_end(msg, hdr);
> +
> +	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(wiphy), msg, 0,
> +				NL80211_MCGRP_MLME, GFP_KERNEL);
> +	return;
> +out:
> +	nlmsg_free(msg);
> +}

This has no indication of the link, but with multi-link you could
actually be sending this event multiple times to userspace on the same
netdev.

>  static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct cfg80211_registered_device *rdev =3D info->user_ptr[0];
> @@ -6050,6 +6083,8 @@ static int nl80211_start_ap(struct sk_buff *skb, st=
ruct genl_info *info)
> =20
>  		if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
>  			wdev->conn_owner_nlportid =3D info->snd_portid;
> +
> +		nl80211_send_ap_started(wdev);
>  	}

because this can be called multiple times, once for each link.

Seems like you should include the link ID or something?

johannes
