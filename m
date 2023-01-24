Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFAB67A118
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjAXSZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAXSZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:25:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5373D0BA
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 10:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674584705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HRelYoJaP8t/xyvtmxLfxZp0DMi2jUFCk5XwwodX4jg=;
        b=C9JK1HVOOOQPsIrHUL6EL6akQLgzwnnt8ptROz4Rr+FiMEYCLrCrthHcYhRAN578RvjjJ+
        InFHmNEpQ4bN9rJ093ndS4IlNxz53nMXlZIeoM3DayBxRrx/fAy3r+WdQ0I2u0gTiDH0CI
        FzTrOdgzPybmX+5uLDnx1pHBvScyNv8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-83D_fQ85PeuaErfHcqV9Ow-1; Tue, 24 Jan 2023 13:25:01 -0500
X-MC-Unique: 83D_fQ85PeuaErfHcqV9Ow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 787BC2805590;
        Tue, 24 Jan 2023 18:24:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.22.50.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14DA91121330;
        Tue, 24 Jan 2023 18:24:56 +0000 (UTC)
Message-ID: <57e98e3b6542e20a7a0a4b974a13cdf67b834f26.camel@redhat.com>
Subject: Re: [PATCH v4 0/4] wifi: libertas: IE handling fixes
From:   Dan Williams <dcbw@redhat.com>
To:     Doug Brown <doug@schmorgal.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 24 Jan 2023 12:24:56 -0600
In-Reply-To: <20230123053132.30710-1-doug@schmorgal.com>
References: <20230123053132.30710-1-doug@schmorgal.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-01-22 at 21:31 -0800, Doug Brown wrote:
> This series implements two fixes for the libertas driver that restore
> compatibility with modern wpa_supplicant versions, and adds (or at
> least
> improves) support for WPS in the process.
>=20
> 1) Better handling of the RSN/WPA IE in association requests:
> =C2=A0=C2=A0 The previous logic was always just grabbing the first one, a=
nd
> didn't
> =C2=A0=C2=A0 handle multiple IEs properly, which wpa_supplicant adds nowa=
days.
>=20
> 2) Support for IEs in scan requests:
> =C2=A0=C2=A0 Modern wpa_supplicant always adds an "extended capabilities"=
 IE,
> =C2=A0=C2=A0 which violates max_scan_ie_len in this driver. Go ahead and =
allow
> =C2=A0=C2=A0 scan IEs, and handle WPS based on the info that Dan provided=
.
>=20
> These changes have been tested on a Marvell PXA168-based device with
> a
> Marvell 88W8686 Wi-Fi chipset. I've confirmed that with these changes
> applied, modern wpa_supplicant versions connect properly and WPS also
> works correctly (tested with "wpa_cli -i wlan0 wps_pbc any").

Tested with a usb8388 (fw 9.34.3p23), x86, wpa_supplicant 2.10.
Scanning and connecting to a WPA2 AP works. Doesn't panic when I pull
the dongle out. Ship it!

Reviewed-by: Dan Williams <dcbw@redhat.com>
Tested-by: Dan Williams <dcbw@redhat.com>

Dan

>=20
> Changes since V3:
> - Do more extensive code style fixes suggested by Ping-Ke Shih
>=20
> Changes since V2:
> - Add missing cpu_to_le16 as suggested by Simon Horman
>=20
> Changes since V1 (which was a single patch linked here [1]):
>=20
> - Switch to cfg80211_find_*_elem when looking for specific IEs,
> =C2=A0 resulting in cleaner/safer code.
> - Use mrvl_ie_data struct for cleaner manipulation of TLV buffer, and
> =C2=A0 fix capitalization of the "data" member to avoid checkpatch
> warnings.
> - Implement idea suggested by Dan to change max_scan_ie_len to be
> =C2=A0 nonzero and enable WPS support in probe requests while we're at it=
.
> - Remove "Fixes:" tag; I'm not sure if it's still appropriate or not
> =C2=A0 with it depending on the capitalization fix.
> - Clarify comments.
>=20
> [1]
> https://lore.kernel.org/all/20230102234714.169831-1-doug@schmorgal.com/
>=20
> Doug Brown (4):
> =C2=A0 wifi: libertas: fix code style in Marvell structs
> =C2=A0 wifi: libertas: only add RSN/WPA IE in lbs_add_wpa_tlv
> =C2=A0 wifi: libertas: add new TLV type for WPS enrollee IE
> =C2=A0 wifi: libertas: add support for WPS enrollee IE in probe requests
>=20
> =C2=A0drivers/net/wireless/marvell/libertas/cfg.c=C2=A0=C2=A0 | 76 ++++++=
+++++++++--
> --
> =C2=A0drivers/net/wireless/marvell/libertas/types.h | 21 ++---
> =C2=A02 files changed, 74 insertions(+), 23 deletions(-)
>=20

