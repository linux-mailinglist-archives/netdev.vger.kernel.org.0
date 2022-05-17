Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10743529B73
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241947AbiEQHv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241863AbiEQHvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:51:48 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E581A820;
        Tue, 17 May 2022 00:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=MTfV3kZGVnrkxCsO0XjhCr2AVmWu4f7IQB0vynHt5bc=;
        t=1652773907; x=1653983507; b=Iksef+KOCnq+3mNmxusCzl0JP88zn0RrjEyA/SMxFs/zMhm
        TDz62cpP1Z80ZRipT8I8EU7rCMxOsWmCL7wiRsoCKyvjBevGuvD/aL3NzfeknNrtyJTrJmqA5AH43
        yuAnqiskM8vJQSwnZOgqiXmK2zKAi9/8vyDp/BNvoIvPVb3HpWtmlScSqP5oicbQ3ficg7W9OYLM9
        dO47E1O+08qdj+NBu9aCJAugdyhrp3je2/ieHV1k9Icq82fqvH4U5cCuwtAUmrKOMKuVcwb20vfyD
        bSIye2257Q5/q4hIY71iqzaX3tI+V+sGg7Sx1paw9c0shW7HVuNBbWjoBLj4NTdA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nqrzQ-00EGgL-Rf;
        Tue, 17 May 2022 09:51:33 +0200
Message-ID: <8b9d18e351cc58aed65c4a4c7f12f167984ee088.camel@sipsolutions.net>
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct
 net_device
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan@vger.kernel.org
Date:   Tue, 17 May 2022 09:51:31 +0200
In-Reply-To: <20220516215638.1787257-1-kuba@kernel.org>
References: <20220516215638.1787257-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-05-16 at 14:56 -0700, Jakub Kicinski wrote:
>=20
> +#if IS_ENABLED(CONFIG_WIRELESS)
>  	struct wireless_dev	*ieee80211_ptr;
> +#endif

Technically, you should be able to use CONFIG_CFG80211 here, but in
practice I'd really hope nobody enables WIRELESS without CFG80211 :)

> +++ b/include/net/cfg80211.h
> @@ -8004,10 +8004,7 @@ int cfg80211_register_netdevice(struct net_device =
*dev);
>   *
>   * Requires the RTNL and wiphy mutex to be held.
>   */
> -static inline void cfg80211_unregister_netdevice(struct net_device *dev)
> -{
> -	cfg80211_unregister_wdev(dev->ieee80211_ptr);
> -}
> +void cfg80211_unregister_netdevice(struct net_device *dev);

Exported functions aren't free either - I think in this case I'd
(slightly) prefer the extra ifdef.


Anyway, we can do this, but I also like Florian's suggestion about the
union, and sent an attempt at a disambiguation patch there.

johannes
