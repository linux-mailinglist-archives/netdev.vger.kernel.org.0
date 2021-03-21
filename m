Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340E63435BB
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 00:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhCUXaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 19:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhCUXaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 19:30:08 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD1DC061574;
        Sun, 21 Mar 2021 16:30:08 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4F3Ykv2PJhzQjmj;
        Mon, 22 Mar 2021 00:29:59 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1616369397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=50cYCeVlrh1Bo+m7NApfVjw9OP50QjF3PYCv6BlLhYA=;
        b=EoZhWCVYnnuH/0oGnhC0Z7dwQGfVaaWpiv5JCD42UfwedSXMmqLDl0o6N+fGa5TX4KZmUF
        k33iMTYqtzzg8C8wOyeWs3MKhpAyGImnKc43kBnZualvHBaDcq7cvEIYjrajgyRoYQMJRS
        h1pEo+v1qlBDhJL0Js9K/rcA6TZxAfhLg8TrOSur4o2hZtBzNqbIEMeIeJImK2Fy1wHr6Y
        1kr+gEntllY2eT121rdrQfHmSK/lviy7yMc1RQF/eCwf96Nn138b9MuB3AuMDgrDGLHjql
        89wbcsSJXCKMvGQKZcH+cPHCXQGawZceTrDR0SLG1QgsXr44vS81HGqmy0tqTg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id IKCv1c8jp2BY; Mon, 22 Mar 2021 00:29:56 +0100 (CET)
Subject: Re: [PATCH v3 1/3] net: dsa: lantiq: allow to use all GPHYs on xRX300
 and xRX330
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210321173922.2837-1-olek2@wp.pl>
 <20210321173922.2837-2-olek2@wp.pl>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <d25b473a-6f4e-63d9-1a4b-7d0afe27e270@hauke-m.de>
Date:   Mon, 22 Mar 2021 00:29:53 +0100
MIME-Version: 1.0
In-Reply-To: <20210321173922.2837-2-olek2@wp.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.28 / 15.00 / 15.00
X-Rspamd-Queue-Id: 3F14B1700
X-Rspamd-UID: c999f5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/21 6:39 PM, Aleksander Jan Bajkowski wrote:
> This patch allows to use all PHYs on GRX300 and GRX330. The ARX300
> has 3 and the GRX330 has 4 integrated PHYs connected to different
> ports compared to VRX200. Each integrated PHY can work as single
> Gigabit Ethernet PHY (GMII) or as double Fast Ethernet PHY (MII).
> 
> Allowed port configurations:
> 
> xRX200:
> GMAC0: RGMII, MII, REVMII or RMII port
> GMAC1: RGMII, MII, REVMII or RMII port
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII port
> 
> xRX300:
> GMAC0: RGMII port
> GMAC1: GPHY2 (GMII)
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII port
> 
> xRX330:
> GMAC0: RGMII, GMII or RMII port
> GMAC1: GPHY2 (GMII)
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII) or GPHY3 (GMII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII), RGMII or RMII port
> 
> Tested on D-Link DWR966 (xRX330) with OpenWRT.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
