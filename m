Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E12670D55
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjAQX1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjAQX0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:26:20 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458C13928B;
        Tue, 17 Jan 2023 13:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=McmG1jOzMvtt3wWGVUxfmdV8HITDF3CT0GifJJycbDo=;
        t=1673990620; x=1675200220; b=a5A3n4e1neWfxsl2W6TZND28yoyzhnQpQ0Mk8NdmkZW+zOE
        IoffS3G6g1pd/RODnv9FGQ1vkfn0tZmrDn6TIUtcGTxRsA6vVOrdZg01EgVvl1eH8kSTzmk69kfKg
        EDSguKCnJOroVj6aM6oTl+Y7aS3eBzaW9WmF9Jq5lZ1Iqx1DJAg8JtCK+wC4sIfB9zlRIXZXhJOD2
        hLXqBCkVuBfqlPoswgNdWYl24cuS9JxYlIBtm8IRcsJ5C46AR6OdGp2gQo885mycWvB03nOg+ICGl
        C7OLsO0v53Pxvvt1dxygDnsZ7qNtdhDPtHN3hVIZIK/tx+fL3F7icD64N5nJ9iVQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pHtQV-004oup-0p;
        Tue, 17 Jan 2023 22:23:27 +0100
Message-ID: <6fb9fc37203bab5082603caf4b4fbecdd3241541.camel@sipsolutions.net>
Subject: Re: [PATCH net-next] wifi: ipw2200: use strscpy() to instead of
 strncpy()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     yang.yang29@zte.com.cn, stas.yakovlev@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.panda@zte.com.cn
Date:   Tue, 17 Jan 2023 22:23:25 +0100
In-Reply-To: <202212231056165052797@zte.com.cn>
References: <202212231056165052797@zte.com.cn>
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

On Fri, 2022-12-23 at 10:56 +0800, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
>=20
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL-terminated strings.
>=20
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/w=
ireless/intel/ipw2x00/ipw2200.c
> index ca802af8cddc..6656cea496b1 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> @@ -1483,8 +1483,7 @@ static ssize_t scan_age_store(struct device *d, str=
uct device_attribute *attr,
>=20
>  	IPW_DEBUG_INFO("enter\n");
>=20
> -	strncpy(buffer, buf, len);
> -	buffer[len] =3D 0;
> +	strncpy(buffer, buf, len + 1);
>=20

Ummm?

But anyway - why bother ... ancient drivers, clearly OK code.

johannes
