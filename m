Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E01165C556
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 18:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbjACRsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 12:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233872AbjACRsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 12:48:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E4FDFF2
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 09:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672768034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JcDL45STgo7kPl7hgic4aRnVFa75JoH1GQIrzXPMHcU=;
        b=X+OoRHIHm2LXoKSlTO9SBvnK6AU48rQhx+VyBjjb7ZZ1rLxQuDh56FDa7e5nRkKAMLfL0C
        /4OhxO9EOQi7S6eB6SUWqZUdClbmpWzUPa5+Xvj4aGX57JkmOLsZF46XsQqvWZGi838WxE
        CohSqjBMF7/A+RFnanhDgtK5TUHnP0g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-1d32DzAvNc2sEMUKMsyGeg-1; Tue, 03 Jan 2023 12:47:12 -0500
X-MC-Unique: 1d32DzAvNc2sEMUKMsyGeg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81BA7101B44E;
        Tue,  3 Jan 2023 17:47:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.22.50.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C6BF140EBF4;
        Tue,  3 Jan 2023 17:47:10 +0000 (UTC)
Message-ID: <657adc8e514d4486853ef90cdf97bd75f55b44fa.camel@redhat.com>
Subject: Re: [PATCH] wifi: libertas: return consistent length in
 lbs_add_wpa_tlv()
From:   Dan Williams <dcbw@redhat.com>
To:     Doug Brown <doug@schmorgal.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 03 Jan 2023 11:47:09 -0600
In-Reply-To: <20230102234714.169831-1-doug@schmorgal.com>
References: <20230102234714.169831-1-doug@schmorgal.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-01-02 at 15:47 -0800, Doug Brown wrote:
> The existing code only converts the first IE to a TLV, but it returns
> a
> value that takes the length of all IEs into account. When there is
> more
> than one IE (which happens with modern wpa_supplicant versions for
> example), the returned length is too long and extra junk TLVs get
> sent
> to the firmware, resulting in an association failure.
>=20
> Fix this by returning a length that only factors in the single IE
> that
> was converted. The firmware doesn't seem to support the additional
> IEs,
> so there is no value in trying to convert them to additional TLVs.
>=20
> Fixes: e86dc1ca4676 ("Libertas: cfg80211 support")
> Signed-off-by: Doug Brown <doug@schmorgal.com>
> ---
> =C2=A0drivers/net/wireless/marvell/libertas/cfg.c | 7 +++----
> =C2=A01 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/wireless/marvell/libertas/cfg.c
> b/drivers/net/wireless/marvell/libertas/cfg.c
> index 3e065cbb0af9..fcc5420ec7ea 100644
> --- a/drivers/net/wireless/marvell/libertas/cfg.c
> +++ b/drivers/net/wireless/marvell/libertas/cfg.c
> @@ -432,10 +432,9 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8
> *ie, u8 ie_len)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*tlv++ =3D 0;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0tlv_len =3D *tlv++ =3D *i=
e++;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*tlv++ =3D 0;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0while (tlv_len--)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0*tlv++ =3D *ie++;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* the TLV is two bytes larger=
 than the IE */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ie_len + 2;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memcpy(tlv, ie, tlv_len);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* the TLV has a four-byte hea=
der */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return tlv_len + 4;

Since you're removing ie_len usage in the function, you might as well
remove it from the function's arguments.

Can you also update the comments to say something like "only copy the
first IE into the command buffer".

Lastly, should you check the IE to make sure you're copying the WPA or
WMM IE that the firmware expects? What other IEs does
wpa_supplicant/cfg80211 add these days?

Dan

> =C2=A0}
> =C2=A0
> =C2=A0/*

