Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A060E6C0623
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 23:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjCSWvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 18:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjCSWvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 18:51:37 -0400
X-Greylist: delayed 259 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Mar 2023 15:51:35 PDT
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA0B1C7F5;
        Sun, 19 Mar 2023 15:51:34 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 32JMkhYq239283;
        Sun, 19 Mar 2023 23:46:44 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 32JMkhYq239283
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1679266004;
        bh=b9dTk5NOXyTFFIHkZd2DhX7ofwKk9EJlfg2Sf7A/y9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dVNcxxGnhKRuImHxlNntnIu5i0jmc4uSXrktqp4JwxBBm6nNWqDb5bGkRqOTY4889
         F6Uq1BwDxLkONirVmBoPpHbglOpfevQmm+iCRjvVwF/7AhkFsXyiw5nKwSeQ/0EJYK
         Hoehg+81nT/37o1UHpvcHSrztLc5EnGiIyPgo2To=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 32JMkgFi239282;
        Sun, 19 Mar 2023 23:46:42 +0100
Date:   Sun, 19 Mar 2023 23:46:42 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        wei.liu@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, leon@kernel.org, longli@microsoft.com,
        ssengar@linux.microsoft.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Add support for jumbo frame
Message-ID: <20230319224642.GA239003@electric-eye.fr.zoreil.com>
References: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Haiyang Zhang <haiyangz@microsoft.com> :
[...]
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 492474b4d8aa..07738b7e85f2 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -427,6 +427,34 @@ static u16 mana_select_queue(struct net_device *ndev, struct sk_buff *skb,
>  	return txq;
>  }
>  
> +static int mana_change_mtu(struct net_device *ndev, int new_mtu)
> +{
> +	unsigned int old_mtu = ndev->mtu;
> +	int err, err2;
> +
> +	err = mana_detach(ndev, false);
> +	if (err) {
> +		netdev_err(ndev, "mana_detach failed: %d\n", err);
> +		return err;
> +	}
> +
> +	ndev->mtu = new_mtu;
> +
> +	err = mana_attach(ndev);
> +	if (!err)
> +		return 0;
> +
> +	netdev_err(ndev, "mana_attach failed: %d\n", err);
> +
> +	/* Try to roll it back to the old configuration. */
> +	ndev->mtu = old_mtu;
> +	err2 = mana_attach(ndev);
> +	if (err2)
> +		netdev_err(ndev, "mana re-attach failed: %d\n", err2);
> +
> +	return err;
> +}

I do not see where the driver could depend on the MTU. Even if it fails,
a single call to mana_change_mtu should thus never wreck the old working
state/configuration.

Stated differently, the detach/attach implementation is simple but
it makes the driver less reliable than it could be.

No ?

-- 
Ueimor
