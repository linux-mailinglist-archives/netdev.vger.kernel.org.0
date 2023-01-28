Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8531A67F7EF
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbjA1NPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjA1NPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:15:12 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F949038;
        Sat, 28 Jan 2023 05:15:11 -0800 (PST)
Received: from [192.168.2.51] (p4fe71212.dip0.t-ipconnect.de [79.231.18.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 8F9E6C03F6;
        Sat, 28 Jan 2023 14:15:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1674911708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPThA8F8arioRGKvheey6dkfAb8Qhp88RQrjp407wvY=;
        b=PUzpKQEch93i20zMYOSP3iSZUoOjChzzHMyCw8mHsGs7m71RTdA4HpQeRqk1eGFA9rf/Wi
        swtqSDU6jr7hJI0xBNQXtYM0y6VpBMkguW8nv5oGKlfTrlQP/I5cG1k+2h8cSL4B8TXTPH
        s8d3YLYiKLe+2ipeoZoCleoebA1+v5mI65lGS6kFHqo0ievl5dZZ6Kgk3NCfqk6n1cj8fR
        /LvbvYJlRhrcNHbYL/2rQRPxlOfWb7ESSRLBRtp4uoWX8d5WuP7A5SUBYomVilXpCONTa0
        0+n/xbIide+lk0qpOsqLtkdT0ro1xMBvFe+v7MX2FDB8+te7AgfhoBXup+ZcKg==
Message-ID: <d17b1f40-b878-28fa-f93d-37f7e5ba856c@datenfreihafen.org>
Date:   Sat, 28 Jan 2023 14:15:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH wpan-next v2 0/2] ieee802154: Beaconing support
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20230125102923.135465-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230125102923.135465-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 25.01.23 11:29, Miquel Raynal wrote:
> Scanning being now supported, we can eg. play with hwsim to verify
> everything works as soon as this series including beaconing support gets
> merged.
> 
> Thanks,
> Miquèl
> 
> Changes in v2:
> * Clearly state in the commit log llsec is not supported yet.
> * Do not use mlme transmission helpers because we don't really need to
>    stop the queue when sending a beacon, as we don't expect any feedback
>    from the PHY nor from the peers. However, we don't want to go through
>    the whole net stack either, so we bypass it calling the subif helper
>    directly.
> 
> Miquel Raynal (2):
>    ieee802154: Add support for user beaconing requests
>    mac802154: Handle basic beaconing
> 
>   include/net/cfg802154.h         |  23 +++++
>   include/net/ieee802154_netdev.h |  16 ++++
>   include/net/nl802154.h          |   3 +
>   net/ieee802154/header_ops.c     |  24 +++++
>   net/ieee802154/nl802154.c       |  93 ++++++++++++++++++++
>   net/ieee802154/nl802154.h       |   1 +
>   net/ieee802154/rdev-ops.h       |  28 ++++++
>   net/ieee802154/trace.h          |  21 +++++
>   net/mac802154/cfg.c             |  31 ++++++-
>   net/mac802154/ieee802154_i.h    |  18 ++++
>   net/mac802154/iface.c           |   3 +
>   net/mac802154/llsec.c           |   5 +-
>   net/mac802154/main.c            |   1 +
>   net/mac802154/scan.c            | 151 ++++++++++++++++++++++++++++++++
>   14 files changed, 415 insertions(+), 3 deletions(-)

These patches have been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
