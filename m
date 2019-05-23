Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4997028C51
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbfEWV2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:28:10 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47726 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387447AbfEWV2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:28:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AD4NZR/68n/eae4yMH9JcHzF1CA+OtYq+eNdsVj7hKo=; b=UR41rexfQ361qyWm2lTbew0hn
        uDrwdZSgT4T5Mt6ZGhriBVT8Uy211WaHMRrO9PFTvqp9E9p+KMzsMRjrpgJjDXAfBICEV8gxdesJW
        H9QjYsn+dcKoaoPtRIlKOIWKCXiIZ0WwW0CHnMixeH09g+wAcOMdVhLXMn9WfQHf1m5NrEH9k2I0L
        whQ7tjpGAIvNUv0AcrKnMMX7UccLfh5dpGY/8cMWLCCAMwIKKCctMpmfc6/M2nxnZp6FGsiMZlGD7
        2WaiAPqB94mNZ4EySXaCjF5Uw6EKG/ZTvjVNe3VgnvHdY6VR4Tzkw+EXbPtAbuG1MXfMnI2a/Sjpg
        QogWKptxQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38262)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hTvFp-0008De-Eq; Thu, 23 May 2019 22:28:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hTvFk-0007tM-De; Thu, 23 May 2019 22:27:56 +0100
Date:   Thu, 23 May 2019 22:27:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
Message-ID: <20190523212756.4b25giji4vkxdl5q@shell.armlinux.org.uk>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-6-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523011958.14944-6-ioana.ciornei@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 01:20:40AM +0000, Ioana Ciornei wrote:
> @@ -111,7 +114,16 @@ static const char *phylink_an_mode_str(unsigned int mode)
>  static int phylink_validate(struct phylink *pl, unsigned long *supported,
>  			    struct phylink_link_state *state)
>  {
> -	pl->ops->validate(pl->netdev, supported, state);
> +	struct phylink_notifier_info info = {
> +		.supported = supported,
> +		.state = state,
> +	};
> +
> +	if (pl->ops)
> +		pl->ops->validate(pl->netdev, supported, state);
> +	else
> +		blocking_notifier_call_chain(&pl->notifier_chain,
> +					     PHYLINK_VALIDATE, &info);

I don't like this use of notifiers for several reasons:

1. It becomes harder to grep for users of this.
2. We lose documentation about what is passed for each method.
3. We lose const-ness for parameters, which then allows users to
   modify phylink-internal data structures inappropriately from
   these notifier calls.

Please find another way.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
