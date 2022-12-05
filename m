Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C97E64262A
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiLEJyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiLEJyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:54:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3379B17431;
        Mon,  5 Dec 2022 01:54:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D92FFB80DF4;
        Mon,  5 Dec 2022 09:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0F1C4314D;
        Mon,  5 Dec 2022 09:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670234075;
        bh=l5UI0q8kSpY84KyEu7Y/77uR3TbLPhENS6WECvOjWSE=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=EhF6gDeorbo4ileQxQ+4jT71c//LYFCbjfsiLgGGfzJf/8Roockq2A8H1K2oc4eiK
         hCnhgCvJvDEbkNCieHghWO/liVLl/nyH4B/YQKa7BvGaRnRUPW42ZiIXw174SpwIna
         o78Uit8yD+FVzlWfkl8sjIH5DbPCus/pTVMs85I8BVrmSTuUN+TpmkOpjzc5HlEw93
         syh7j/7jrQZjs5hWY33KXxwpeKz/zkIP9THyQ+b2W9nFhch/z5iGtuFTyuayf5HHrT
         THEaZ1doUiKnpkPiLeQCJTwtqcOExeqns8rgO5gbXHUImyrxtETk+V1OgBesPNoT3Q
         qkyNnLNO1s9AQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221204100653.19019-1-ehakim@nvidia.com>
References: <20221204100653.19019-1-ehakim@nvidia.com>
Subject: Re: [PATCH net-next] macsec: Add support for IFLA_MACSEC_OFFLOAD in the netlink layer
From:   Antoine Tenart <atenart@kernel.org>
Cc:     raeds@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        sd@queasysnail.net, Emeel Hakim <ehakim@nvidia.com>
To:     ehakim@nvidia.com, linux-kernel@vger.kernel.org
Date:   Mon, 05 Dec 2022 10:54:30 +0100
Message-ID: <167023407010.4545.3574025885845288724@kwain.local>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Quoting ehakim@nvidia.com (2022-12-04 11:06:53)
> =20
> +static int macsec_changelink_upd_offload(struct net_device *dev, struct =
nlattr *data[])
> +{
> +       enum macsec_offload offload, prev_offload;
> +       const struct macsec_ops *ops;
> +       struct macsec_context ctx;
> +       struct macsec_dev *macsec;
> +       int ret =3D 0;
> +
> +       macsec =3D macsec_priv(dev);
> +       offload =3D nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
> +
> +       /* Check if the offloading mode is supported by the underlying la=
yers */
> +       if (offload !=3D MACSEC_OFFLOAD_OFF &&
> +           !macsec_check_offload(offload, macsec))
> +               return -EOPNOTSUPP;
> +
> +       /* Check if the net device is busy. */
> +       if (netif_running(dev))
> +               return -EBUSY;
> +
> +       if (macsec->offload =3D=3D offload)
> +               return 0;
> +
> +       prev_offload =3D macsec->offload;
> +
> +       /* Check if the device already has rules configured: we do not su=
pport
> +        * rules migration.
> +        */
> +       if (macsec_is_configured(macsec))
> +               return -EBUSY;
> +
> +       ops =3D __macsec_get_ops(offload =3D=3D MACSEC_OFFLOAD_OFF ? prev=
_offload : offload,
> +                              macsec, &ctx);
> +       if (!ops)
> +               return -EOPNOTSUPP;
> +
> +       macsec->offload =3D offload;
> +
> +       ctx.secy =3D &macsec->secy;
> +       ret =3D (offload =3D=3D MACSEC_OFFLOAD_OFF) ? macsec_offload(ops-=
>mdo_del_secy, &ctx) :
> +                     macsec_offload(ops->mdo_add_secy, &ctx);
> +
> +       if (ret)
> +               macsec->offload =3D prev_offload;
> +
> +       return ret;
> +}

The logic above is very close to what is done in macsec_upd_offload,
except for the use of the rtnl lock. You can merge the two in a common
helper and use that to avoid duplication.

Thanks,
Antoine
