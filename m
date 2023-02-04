Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7E068A823
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 05:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbjBDETd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 23:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjBDET2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 23:19:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5F91115E;
        Fri,  3 Feb 2023 20:19:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9916360691;
        Sat,  4 Feb 2023 04:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258C8C433D2;
        Sat,  4 Feb 2023 04:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675484366;
        bh=+HQM6p4jd+8+N3fwrlSrbPWiaG3Sifyj6ZmwA/9SoJI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GA3PaC6gRBXUzC1hOOIiTK7rNIvk51SaFjeKTgLkH/11CVbUpd5peVFKFjs00QMVu
         Bur9xU/7awGBFvNR2kc+ZvFEAKxdTzcTBm9SDBXtMjyh02z0wskzamTnYuZVAaZhBg
         MLD1nLicGV5DGlf/mqQzzXgMXMCEDgsSjIFPruki3ogJ3mVqoNeiO2pxGKlI7mMa/z
         8F0teD0OKG8rYOxSkV0E0rnc5jM90IrxTwAVPpOAeOUW1TbrNqFUQeqJ5rBbbbOEto
         beOulxxlOmYoT1cRYJ8OUnuXEpZOqukTy534DjUrpvnfE1IEKcwFgv/Cur5ef3fXan
         MjgNZNRcpueDA==
Date:   Fri, 3 Feb 2023 20:19:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20230203201923.6de5c692@kernel.org>
In-Reply-To: <20221129160046.538864-2-miquel.raynal@bootlin.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Nov 2022 17:00:41 +0100 Miquel Raynal wrote:
> +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *=
info)
> +{
> +	struct cfg802154_registered_device *rdev =3D info->user_ptr[0];
> +	struct net_device *dev =3D info->user_ptr[1];
> +	struct wpan_dev *wpan_dev =3D dev->ieee802154_ptr;
> +	struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> +	struct cfg802154_scan_request *request;
> +	u8 type;
> +	int err;
> +
> +	/* Monitors are not allowed to perform scans */
> +	if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR)

extack ?

> +		return -EPERM;
> +
> +	request =3D kzalloc(sizeof(*request), GFP_KERNEL);
> +	if (!request)
> +		return -ENOMEM;
> +
> +	request->wpan_dev =3D wpan_dev;
> +	request->wpan_phy =3D wpan_phy;
> +
> +	type =3D nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE]);

what checks info->attrs[NL802154_ATTR_SCAN_TYPE] is not NULL?

> +	switch (type) {
> +	case NL802154_SCAN_PASSIVE:
> +		request->type =3D type;
> +		break;
> +	default:
> +		pr_err("Unsupported scan type: %d\n", type);
> +		err =3D -EINVAL;

extack (printfs are now supported)

> +		goto free_request;
> +	}
> +
> +	if (info->attrs[NL802154_ATTR_PAGE]) {
> +		request->page =3D nla_get_u8(info->attrs[NL802154_ATTR_PAGE]);
> +		if (request->page > IEEE802154_MAX_PAGE) {

bound check should be part of the policy NLA_POLICY_MAX()

> +			pr_err("Invalid page %d > %d\n",
> +			       request->page, IEEE802154_MAX_PAGE);
> +			err =3D -EINVAL;

extack

> +			goto free_request;
> +		}
> +	} else {
> +		/* Use current page by default */
> +		request->page =3D wpan_phy->current_page;
> +	}
> +
> +	if (info->attrs[NL802154_ATTR_SCAN_CHANNELS]) {
> +		request->channels =3D nla_get_u32(info->attrs[NL802154_ATTR_SCAN_CHANN=
ELS]);
> +		if (request->channels >=3D BIT(IEEE802154_MAX_CHANNEL + 1)) {

policy as well

> +			pr_err("Invalid channels bitfield %x =E2=89=A5 %lx\n",
> +			       request->channels,
> +			       BIT(IEEE802154_MAX_CHANNEL + 1));
> +			err =3D -EINVAL;
> +			goto free_request;
> +		}
> +	} else {
> +		/* Scan all supported channels by default */
> +		request->channels =3D wpan_phy->supported.channels[request->page];
> +	}
> +
> +	if (info->attrs[NL802154_ATTR_SCAN_PREAMBLE_CODES] ||
> +	    info->attrs[NL802154_ATTR_SCAN_MEAN_PRF]) {
> +		pr_err("Preamble codes and mean PRF not supported yet\n");

NLA_REJECT also in policy

> +		err =3D -EINVAL;
> +		goto free_request;
> +	}
> +
> +	if (info->attrs[NL802154_ATTR_SCAN_DURATION]) {
> +		request->duration =3D nla_get_u8(info->attrs[NL802154_ATTR_SCAN_DURATI=
ON]);
> +		if (request->duration > IEEE802154_MAX_SCAN_DURATION) {
> +			pr_err("Duration is out of range\n");
> +			err =3D -EINVAL;
> +			goto free_request;
> +		}
> +	} else {
> +		/* Use maximum duration order by default */
> +		request->duration =3D IEEE802154_MAX_SCAN_DURATION;
> +	}
> +
> +	if (wpan_dev->netdev)
> +		dev_hold(wpan_dev->netdev);

Can we put a tracker in the request and use netdev_hold() ?

> +
> +	err =3D rdev_trigger_scan(rdev, request);
> +	if (err) {
> +		pr_err("Failure starting scanning (%d)\n", err);
> +		goto free_device;
> +	}
