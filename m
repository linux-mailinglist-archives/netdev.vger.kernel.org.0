Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A4D670D64
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjAQX2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAQX1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:27:43 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCF15B474;
        Tue, 17 Jan 2023 13:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=0pP+pN1M5uU+rh2BuIa07VvA0EQmkYWSfKV/yjrljRU=;
        t=1673990894; x=1675200494; b=yIfEx+dXdtMUSaUaWXJ0nyjAMqBqQ4jwhC2bYMGl37FB8N3
        0gAed30N1xGlDu8kTtnU5Jas47j9GKE8gALGQXuUm4VxdA2Yby9W+lreC+SA2mTwxf4b7nO+VLIDT
        7PVkrLtOdvYPMKyl0WzJB6TV7Uzgxbm221b5i7jNoK+CJYcvx/MgcDprLK/bOT2sdzSiEWMXHVjX4
        xYru9cLH55Hp/2ba4vn+0LMR00njs2/kr5W5My2hZUJZOYgGNednjRhhWGnEdNLfA+h1O8LOwMpwn
        c4+UHnQsvOY9hnyHcedF4XPU00AYjHW1bIxdw0oAwBBP4AeiA28/KMOYq8022W/A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pHtUs-004p1v-37;
        Tue, 17 Jan 2023 22:27:59 +0100
Message-ID: <a81cb8cd088e715936895ec6bb07cfdc8fec37c1.camel@sipsolutions.net>
Subject: Re: [PATCH net-next] wifi: airo: use strscpy() to instead of
 strncpy()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     yang.yang29@zte.com.cn, kvalo@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, akpm@linux-foundation.org,
        songmuchun@bytedance.com, brauner@kernel.org,
        julia.lawall@inria.fr, gustavoars@kernel.org, jason@zx2c4.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Date:   Tue, 17 Jan 2023 22:27:57 +0100
In-Reply-To: <202212231052044562664@zte.com.cn>
References: <202212231052044562664@zte.com.cn>
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

On Fri, 2022-12-23 at 10:52 +0800, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
>=20
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL-terminated strings.
>=20
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>
> ---
>  drivers/net/wireless/cisco/airo.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cis=
co/airo.c
> index 7c4cc5f5e1eb..600a64f671ce 100644
> --- a/drivers/net/wireless/cisco/airo.c
> +++ b/drivers/net/wireless/cisco/airo.c
> @@ -6067,8 +6067,7 @@ static int airo_get_nick(struct net_device *dev,
>  	struct airo_info *local =3D dev->ml_priv;
>=20
>  	readConfigRid(local, 1);
> -	strncpy(extra, local->config.nodeName, 16);
> -	extra[16] =3D '\0';
> +	strscpy(extra, local->config.nodeName, 17);
>  	dwrq->length =3D strlen(extra);
>=20

Again, why bother. But is this even correct/identical behaviour?
Wouldn't it potentially read 17 input bytes before forcing NUL-
termination?

johannes
