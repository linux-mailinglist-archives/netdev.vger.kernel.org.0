Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E7452FFB3
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 00:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346980AbiEUWDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 18:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237130AbiEUWDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 18:03:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE042AE36;
        Sat, 21 May 2022 15:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=X2QiFRx18wNfTyWdsQdhMiUxFGO1668qCcTCYqN/IwY=;
        t=1653170613; x=1654380213; b=KUv7m5Sq7sJloroatvUchKkmjRHQIYIkNP0CXnVg1id1vRp
        rIqgUMnmCdEEzghYwU84bOiRfzFEI56FWy79C7HH9oShsk6jXPLBnyIEUkXeAy7u39C5M8t7aVe+M
        jIFSF6b1OBKzAP/BjnwAuIv6OZuOMglf6Kif10GvCjTCctiBGPALks/SZ8IcSlROfDd9GV/AOeLzS
        WxTdXJM9SACys8nfmaQpNh25klHsusg7q0OTMCgUaF05RrYLsZWnwyDK39RGrssjK7zqaknDplwkD
        3uDQKkSqdPCzHIfBD1LZR7Nlokmxu2Z42Nl4VH/FFSqKfc7a3W3H/am0W/YtFZnw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nsXC1-000qir-E1;
        Sun, 22 May 2022 00:03:28 +0200
Message-ID: <dfc9d27acf3eaf6222b920701e478c3e9c22fefc.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 7/8] wifi: libertas: silence a GCC 12
 -Warray-bounds warning
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, kvalo@kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        libertas-dev@lists.infradead.org
Date:   Sun, 22 May 2022 00:03:22 +0200
In-Reply-To: <20220520194320.2356236-8-kuba@kernel.org>
References: <20220520194320.2356236-1-kuba@kernel.org>
         <20220520194320.2356236-8-kuba@kernel.org>
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

On Fri, 2022-05-20 at 12:43 -0700, Jakub Kicinski wrote:
> This driver does a lot of casting of smaller buffers to
> a larger command response struct, GCC 12 does not like that:
>=20
> drivers/net/wireless/marvell/libertas/cfg.c:1198:63: warning: array subsc=
ript =E2=80=98struct cmd_ds_802_11_associate_response[0]=E2=80=99 is partly=
 outside array bounds of =E2=80=98unsigned char[203]=E2=80=99 [-Warray-boun=
ds]
>  1198 |                       "aid 0x%04x\n", status, le16_to_cpu(resp->s=
tatuscode),
>       |                                                               ^~
>=20

I had a similar issue in our driver, and I could work around it there
with a simple cast ... here not, but perhaps we should consider
something like the below?

johannes

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c
b/drivers/net/wireless/marvell/libertas/cfg.c
index 4e3de684928b..b0b3f59dabc6 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1053,7 +1053,6 @@ static int lbs_set_authtype(struct lbs_private
*priv,
  */
 #define LBS_ASSOC_MAX_CMD_SIZE                     \
 	(sizeof(struct cmd_ds_802_11_associate)    \
-	 - 512 /* cmd_ds_802_11_associate.iebuf */ \
 	 + LBS_MAX_SSID_TLV_SIZE                   \
 	 + LBS_MAX_CHANNEL_TLV_SIZE                \
 	 + LBS_MAX_CF_PARAM_TLV_SIZE               \
@@ -1130,8 +1129,7 @@ static int lbs_associate(struct lbs_private *priv,
 	if (sme->ie && sme->ie_len)
 		pos +=3D lbs_add_wpa_tlv(pos, sme->ie, sme->ie_len);
=20
-	len =3D (sizeof(*cmd) - sizeof(cmd->iebuf)) +
-		(u16)(pos - (u8 *) &cmd->iebuf);
+	len =3D sizeof(*cmd) + (u16)(pos - (u8 *) &cmd->iebuf);
 	cmd->hdr.size =3D cpu_to_le16(len);
=20
 	lbs_deb_hex(LBS_DEB_ASSOC, "ASSOC_CMD", (u8 *) cmd,
diff --git a/drivers/net/wireless/marvell/libertas/host.h
b/drivers/net/wireless/marvell/libertas/host.h
index ceff4b92e7a1..a202b716ad5d 100644
--- a/drivers/net/wireless/marvell/libertas/host.h
+++ b/drivers/net/wireless/marvell/libertas/host.h
@@ -528,7 +528,8 @@ struct cmd_ds_802_11_associate {
 	__le16 listeninterval;
 	__le16 bcnperiod;
 	u8 dtimperiod;
-	u8 iebuf[512];    /* Enough for required and most optional IEs
*/
+	/* 512 permitted - enough for required and most optional IEs */
+	u8 iebuf[];
 } __packed;
=20
 struct cmd_ds_802_11_associate_response {
@@ -537,7 +538,8 @@ struct cmd_ds_802_11_associate_response {
 	__le16 capability;
 	__le16 statuscode;
 	__le16 aid;
-	u8 iebuf[512];
+	/* max 512 */
+	u8 iebuf[];
 } __packed;
=20
 struct cmd_ds_802_11_set_wep {

