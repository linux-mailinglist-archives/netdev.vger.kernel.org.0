Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD19E389AC6
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 03:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhETBN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 21:13:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhETBN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 21:13:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RZIG+EM6uaRr+XUAlJqa/20a+V53ZRgGqq+rGOqK7Zg=; b=roctrtOBVOdkvin79RwbjUqOTs
        ve6RfqR6Q7KoG8DUkFkpxqb5+IyEjAxUTUe0bDTsTVGXgnksUPV0Ebn1yQBiwf6Ajv0QIYCm2hPqv
        I9tFW2aYHVsbI36wOymVyhxTSOIWmcsoNVxCSzkkMGmsxLo+oeHD8SO1QJ3Ke8j54zdQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ljXEI-0050ih-I7; Thu, 20 May 2021 03:12:02 +0200
Date:   Thu, 20 May 2021 03:12:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [RFC net-next 1/4] net: marvell: prestera: try to load previous
 fw version
Message-ID: <YKW3YhuDSHQtR4Tb@lunn.ch>
References: <20210519143321.849-1-vadym.kochan@plvision.eu>
 <20210519143321.849-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519143321.849-2-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int prestera_fw_get(struct prestera_fw *fw)
> +{
> +	int ver_maj = PRESTERA_SUPP_FW_MAJ_VER;
> +	int ver_min = PRESTERA_SUPP_FW_MIN_VER;
> +	char fw_path[128];
> +	int err;
> +
> +pick_fw_ver:
> +	snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
> +		 ver_maj, ver_min);
> +
> +	err = request_firmware_direct(&fw->bin, fw_path, fw->dev.dev);
> +	if (err) {
> +		if (ver_maj == PRESTERA_SUPP_FW_MAJ_VER) {
> +			ver_maj--;
> +			goto pick_fw_ver;
> +		} else {
> +			dev_err(fw->dev.dev, "failed to request firmware file\n");
> +			return err;
> +		}
> +	}

So lets say for the sake of the argument, you have version 3.0 and
2.42. It looks like this code will first try to load version 3.0. If
that fails, ver_maj is decremented, so it tries 2.0, which also fails
because it should be looking for 2.42. I don't think this decrement is
a good idea.

Also:

> +			dev_err(fw->dev.dev, "failed to request firmware file\n");

It would be useful to say what version you are actually looking for,
so the user can go find the correct firmware.

   Andrew
