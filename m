Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A128211315
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 20:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgGASv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 14:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgGASv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 14:51:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2AC2082F;
        Wed,  1 Jul 2020 18:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593629488;
        bh=9dORJ4lkLGQQDx/SHm8POzeANy5Lq/SpKfcy+d/9xoo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PF99PXGvApSfZdH8Hd5JiOlzWHumyT1EDfVhnCZjkP5upo+BloWfggxrFMRSU2WHN
         uwsZBYsr3LEM4QyDyeCkF7Gj419cZIKi9kNBmv1Be/DHpaC1phBlnolm/grjc5ooXm
         ZNBKKNkVejzCqaa0TTnMGby7LNNkl3Iteq2UtNAw=
Date:   Wed, 1 Jul 2020 11:51:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        snelson@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 3/9] devlink: Replace devlink_port_attrs_set
 parameters with a struct
Message-ID: <20200701115126.4ba0915a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200701143251.456693-4-idosch@idosch.org>
References: <20200701143251.456693-1-idosch@idosch.org>
        <20200701143251.456693-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Jul 2020 17:32:45 +0300 Ido Schimmel wrote:
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> index 2bd610fafc58..3af4e7397263 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> @@ -691,6 +691,9 @@ static void bnxt_dl_params_unregister(struct bnxt *bp)
>  
>  int bnxt_dl_register(struct bnxt *bp)
>  {
> +	struct devlink_port_attrs attrs = {};
> +	const unsigned char *switch_id;
> +	unsigned char switch_id_len;
>  	struct devlink *dl;
>  	int rc;
>  
> @@ -719,9 +722,13 @@ int bnxt_dl_register(struct bnxt *bp)
>  	if (!BNXT_PF(bp))
>  		return 0;
>  
> -	devlink_port_attrs_set(&bp->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
> -			       bp->pf.port_id, false, 0, bp->dsn,
> -			       sizeof(bp->dsn));
> +	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
> +	attrs.phys.port_number = bp->pf.port_id;
> +	switch_id = bp->dsn;
> +	switch_id_len = sizeof(bp->dsn);

Why do you create those local variables everywhere?

> +	memcpy(attrs.switch_id.id, switch_id, switch_id_len);
> +	attrs.switch_id.id_len = switch_id_len;
> +	devlink_port_attrs_set(&bp->dl_port, &attrs);
>  	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
>  	if (rc) {
>  		netdev_err(bp->dev, "devlink_port_register failed\n");
