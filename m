Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7BE3FAF99
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 03:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbhH3Bnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 21:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbhH3Bni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 21:43:38 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E54C061575;
        Sun, 29 Aug 2021 18:42:45 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GyY3h4vvKz9sWX;
        Mon, 30 Aug 2021 11:42:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1630287762;
        bh=Qi5vY41gqvI+YbCMR1tvGMc2hhVEx4i13/Wa66euOcM=;
        h=Date:From:To:Cc:Subject:From;
        b=HrYp+Ypw7s70+TKDHnwIdjeqJuxxOUGxNbg+4PYwHIM9HI0TZnr7zC3JpvKJi8TwR
         uKZHyd1h++ElL4RK7IqdQRuj6N8Z0wZ0CODKC5vcR87JQlIEv2I/IkUAIlllbR62JB
         vE4B6cFEeBCy0Wki0sFISgPUB08RJcPyRp4fOhjwPczwv53YM8pSlb/d5erQbxYFXT
         +UPVIxjLZ7TtUSpObxiovSrA5WahTwpO2aSLcUZKtibt0QbXsPGQ729rn5+MiBPAtk
         1prfy+WQKW/MUSNEQxZ/WcU9KC4/QFoIIrKixottLQzG3rFhEJxucI90x/mZurzQu4
         Mu3+JzVWb6F/g==
Date:   Mon, 30 Aug 2021 11:42:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the staging tree
Message-ID: <20210830114238.7c322caa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vAJJ2hZgXqTugHQyrKvV2TW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vAJJ2hZgXqTugHQyrKvV2TW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/staging/rtl8723bs/os_dep/ioctl_linux.c

between commit:

  174ac41a7aaf ("staging: rtl8723bs: remove obsolete wext support")

from the staging tree and commit:

  89939e890605 ("staging: rtlwifi: use siocdevprivate")

from the net-next tree.

I fixed it up (see below - though it is probably better to get rid of
rtw_siocdevprivate() as well) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index 9d4a233a861e,aa7bd76bb5f1..000000000000
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@@ -1335,8 -3728,778 +1335,21 @@@ static int rtw_hostapd_ioctl(struct net
  	return ret;
  }
 =20
 -static int rtw_wx_set_priv(struct net_device *dev,
 -				struct iw_request_info *info,
 -				union iwreq_data *awrq,
 -				char *extra)
 -{
 -
 -#ifdef DEBUG_RTW_WX_SET_PRIV
 -	char *ext_dbg;
 -#endif
 -
 -	int ret =3D 0;
 -	int len =3D 0;
 -	char *ext;
 -
 -	struct adapter *padapter =3D rtw_netdev_priv(dev);
 -	struct iw_point *dwrq =3D (struct iw_point *)awrq;
 -
 -	if (dwrq->length =3D=3D 0)
 -		return -EFAULT;
 -
 -	len =3D dwrq->length;
 -	ext =3D vmalloc(len);
 -	if (!ext)
 -		return -ENOMEM;
 -
 -	if (copy_from_user(ext, dwrq->pointer, len)) {
 -		vfree(ext);
 -		return -EFAULT;
 -	}
 -
 -	#ifdef DEBUG_RTW_WX_SET_PRIV
 -	ext_dbg =3D vmalloc(len);
 -	if (!ext_dbg) {
 -		vfree(ext, len);
 -		return -ENOMEM;
 -	}
 -
 -	memcpy(ext_dbg, ext, len);
 -	#endif
 -
 -	/* added for wps2.0 @20110524 */
 -	if (dwrq->flags =3D=3D 0x8766 && len > 8) {
 -		u32 cp_sz;
 -		struct mlme_priv *pmlmepriv =3D &(padapter->mlmepriv);
 -		u8 *probereq_wpsie =3D ext;
 -		int probereq_wpsie_len =3D len;
 -		u8 wps_oui[4] =3D {0x0, 0x50, 0xf2, 0x04};
 -
 -		if ((WLAN_EID_VENDOR_SPECIFIC =3D=3D probereq_wpsie[0]) &&
 -			(!memcmp(&probereq_wpsie[2], wps_oui, 4))) {
 -			cp_sz =3D probereq_wpsie_len > MAX_WPS_IE_LEN ? MAX_WPS_IE_LEN : probe=
req_wpsie_len;
 -
 -			if (pmlmepriv->wps_probe_req_ie) {
 -				pmlmepriv->wps_probe_req_ie_len =3D 0;
 -				kfree(pmlmepriv->wps_probe_req_ie);
 -				pmlmepriv->wps_probe_req_ie =3D NULL;
 -			}
 -
 -			pmlmepriv->wps_probe_req_ie =3D rtw_malloc(cp_sz);
 -			if (pmlmepriv->wps_probe_req_ie =3D=3D NULL) {
 -				printk("%s()-%d: rtw_malloc() ERROR!\n", __func__, __LINE__);
 -				ret =3D  -EINVAL;
 -				goto FREE_EXT;
 -
 -			}
 -
 -			memcpy(pmlmepriv->wps_probe_req_ie, probereq_wpsie, cp_sz);
 -			pmlmepriv->wps_probe_req_ie_len =3D cp_sz;
 -
 -		}
 -
 -		goto FREE_EXT;
 -
 -	}
 -
 -	if (len >=3D WEXT_CSCAN_HEADER_SIZE
 -		&& !memcmp(ext, WEXT_CSCAN_HEADER, WEXT_CSCAN_HEADER_SIZE)) {
 -		ret =3D rtw_wx_set_scan(dev, info, awrq, ext);
 -		goto FREE_EXT;
 -	}
 -
 -FREE_EXT:
 -
 -	vfree(ext);
 -	#ifdef DEBUG_RTW_WX_SET_PRIV
 -	vfree(ext_dbg);
 -	#endif
 -
 -	return ret;
 -
 -}
 -
 -static int rtw_pm_set(struct net_device *dev,
 -		      struct iw_request_info *info,
 -		      union iwreq_data *wrqu, char *extra)
 -{
 -	int ret =3D 0;
 -	unsigned	mode =3D 0;
 -	struct adapter *padapter =3D rtw_netdev_priv(dev);
 -
 -	if (!memcmp(extra, "lps =3D", 4)) {
 -		sscanf(extra+4, "%u", &mode);
 -		ret =3D rtw_pm_set_lps(padapter, mode);
 -	} else if (!memcmp(extra, "ips =3D", 4)) {
 -		sscanf(extra+4, "%u", &mode);
 -		ret =3D rtw_pm_set_ips(padapter, mode);
 -	} else {
 -		ret =3D -EINVAL;
 -	}
 -
 -	return ret;
 -}
 -
 -static int rtw_test(
 -	struct net_device *dev,
 -	struct iw_request_info *info,
 -	union iwreq_data *wrqu, char *extra)
 -{
 -	u32 len;
 -	u8 *pbuf, *pch;
 -	char *ptmp;
 -	u8 *delim =3D ",";
 -	struct adapter *padapter =3D rtw_netdev_priv(dev);
 -
 -
 -	len =3D wrqu->data.length;
 -
 -	pbuf =3D rtw_zmalloc(len);
 -	if (!pbuf)
 -		return -ENOMEM;
 -
 -	if (copy_from_user(pbuf, wrqu->data.pointer, len)) {
 -		kfree(pbuf);
 -		return -EFAULT;
 -	}
 -
 -	ptmp =3D (char *)pbuf;
 -	pch =3D strsep(&ptmp, delim);
 -	if ((pch =3D=3D NULL) || (strlen(pch) =3D=3D 0)) {
 -		kfree(pbuf);
 -		return -EFAULT;
 -	}
 -
 -	if (strcmp(pch, "bton") =3D=3D 0)
 -		hal_btcoex_SetManualControl(padapter, false);
 -
 -	if (strcmp(pch, "btoff") =3D=3D 0)
 -		hal_btcoex_SetManualControl(padapter, true);
 -
 -	if (strcmp(pch, "h2c") =3D=3D 0) {
 -		u8 param[8];
 -		u8 count =3D 0;
 -		u32 tmp;
 -		u8 i;
 -		u32 pos;
 -		s32 ret;
 -
 -
 -		do {
 -			pch =3D strsep(&ptmp, delim);
 -			if ((pch =3D=3D NULL) || (strlen(pch) =3D=3D 0))
 -				break;
 -
 -			sscanf(pch, "%x", &tmp);
 -			param[count++] =3D (u8)tmp;
 -		} while (count < 8);
 -
 -		if (count =3D=3D 0) {
 -			kfree(pbuf);
 -			return -EFAULT;
 -		}
 -
 -		ret =3D rtw_hal_fill_h2c_cmd(padapter, param[0], count-1, &param[1]);
 -
 -		pos =3D sprintf(extra, "H2C ID =3D 0x%02x content =3D", param[0]);
 -		for (i =3D 1; i < count; i++)
 -			pos +=3D sprintf(extra+pos, "%02x,", param[i]);
 -		extra[pos] =3D 0;
 -		pos--;
 -		pos +=3D sprintf(extra+pos, " %s", ret =3D=3D _FAIL?"FAIL":"OK");
 -
 -		wrqu->data.length =3D strlen(extra) + 1;
 -	}
 -
 -	kfree(pbuf);
 -	return 0;
 -}
 -
 -static iw_handler rtw_handlers[] =3D {
 -	NULL,					/* SIOCSIWCOMMIT */
 -	rtw_wx_get_name,		/* SIOCGIWNAME */
 -	dummy,					/* SIOCSIWNWID */
 -	dummy,					/* SIOCGIWNWID */
 -	rtw_wx_set_freq,		/* SIOCSIWFREQ */
 -	rtw_wx_get_freq,		/* SIOCGIWFREQ */
 -	rtw_wx_set_mode,		/* SIOCSIWMODE */
 -	rtw_wx_get_mode,		/* SIOCGIWMODE */
 -	dummy,					/* SIOCSIWSENS */
 -	rtw_wx_get_sens,		/* SIOCGIWSENS */
 -	NULL,					/* SIOCSIWRANGE */
 -	rtw_wx_get_range,		/* SIOCGIWRANGE */
 -	rtw_wx_set_priv,		/* SIOCSIWPRIV */
 -	NULL,					/* SIOCGIWPRIV */
 -	NULL,					/* SIOCSIWSTATS */
 -	NULL,					/* SIOCGIWSTATS */
 -	dummy,					/* SIOCSIWSPY */
 -	dummy,					/* SIOCGIWSPY */
 -	NULL,					/* SIOCGIWTHRSPY */
 -	NULL,					/* SIOCWIWTHRSPY */
 -	rtw_wx_set_wap,		/* SIOCSIWAP */
 -	rtw_wx_get_wap,		/* SIOCGIWAP */
 -	rtw_wx_set_mlme,		/* request MLME operation; uses struct iw_mlme */
 -	dummy,					/* SIOCGIWAPLIST -- depricated */
 -	rtw_wx_set_scan,		/* SIOCSIWSCAN */
 -	rtw_wx_get_scan,		/* SIOCGIWSCAN */
 -	rtw_wx_set_essid,		/* SIOCSIWESSID */
 -	rtw_wx_get_essid,		/* SIOCGIWESSID */
 -	dummy,					/* SIOCSIWNICKN */
 -	rtw_wx_get_nick,		/* SIOCGIWNICKN */
 -	NULL,					/* -- hole -- */
 -	NULL,					/* -- hole -- */
 -	rtw_wx_set_rate,		/* SIOCSIWRATE */
 -	rtw_wx_get_rate,		/* SIOCGIWRATE */
 -	rtw_wx_set_rts,			/* SIOCSIWRTS */
 -	rtw_wx_get_rts,			/* SIOCGIWRTS */
 -	rtw_wx_set_frag,		/* SIOCSIWFRAG */
 -	rtw_wx_get_frag,		/* SIOCGIWFRAG */
 -	dummy,					/* SIOCSIWTXPOW */
 -	dummy,					/* SIOCGIWTXPOW */
 -	dummy,					/* SIOCSIWRETRY */
 -	rtw_wx_get_retry,		/* SIOCGIWRETRY */
 -	rtw_wx_set_enc,			/* SIOCSIWENCODE */
 -	rtw_wx_get_enc,			/* SIOCGIWENCODE */
 -	dummy,					/* SIOCSIWPOWER */
 -	rtw_wx_get_power,		/* SIOCGIWPOWER */
 -	NULL,					/*---hole---*/
 -	NULL,					/*---hole---*/
 -	rtw_wx_set_gen_ie,		/* SIOCSIWGENIE */
 -	NULL,					/* SIOCGWGENIE */
 -	rtw_wx_set_auth,		/* SIOCSIWAUTH */
 -	NULL,					/* SIOCGIWAUTH */
 -	rtw_wx_set_enc_ext,		/* SIOCSIWENCODEEXT */
 -	NULL,					/* SIOCGIWENCODEEXT */
 -	rtw_wx_set_pmkid,		/* SIOCSIWPMKSA */
 -	NULL,					/*---hole---*/
 -};
 -
 -static const struct iw_priv_args rtw_private_args[] =3D {
 -	{
 -		SIOCIWFIRSTPRIV + 0x0,
 -		IW_PRIV_TYPE_CHAR | 0x7FF, 0, "write"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x1,
 -		IW_PRIV_TYPE_CHAR | 0x7FF,
 -		IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_FIXED | IFNAMSIZ, "read"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x2, 0, 0, "driver_ext"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x3, 0, 0, "mp_ioctl"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x4,
 -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "apinfo"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x5,
 -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 2, 0, "setpid"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x6,
 -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "wps_start"
 -	},
 -/* for PLATFORM_MT53XX */
 -	{
 -		SIOCIWFIRSTPRIV + 0x7,
 -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "get_sensitivity"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x8,
 -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "wps_prob_req_ie"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x9,
 -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "wps_assoc_req_ie"
 -	},
 -
 -/* for RTK_DMP_PLATFORM */
 -	{
 -		SIOCIWFIRSTPRIV + 0xA,
 -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "channel_plan"
 -	},
 -
 -	{
 -		SIOCIWFIRSTPRIV + 0xB,
 -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 2, 0, "dbg"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0xC,
 -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 3, 0, "rfw"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0xD,
 -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 2, IW_PRIV_TYPE_CHAR | IW_PRIV_=
SIZE_FIXED | IFNAMSIZ, "rfr"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x10,
 -		IW_PRIV_TYPE_CHAR | 1024, 0, "p2p_set"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x11,
 -		IW_PRIV_TYPE_CHAR | 1024, IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_MASK, "p2p_g=
et"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x12, 0, 0, "NULL"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x13,
 -		IW_PRIV_TYPE_CHAR | 64, IW_PRIV_TYPE_CHAR | 64, "p2p_get2"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x14,
 -		IW_PRIV_TYPE_CHAR  | 64, 0, "tdls"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x15,
 -		IW_PRIV_TYPE_CHAR | 1024, IW_PRIV_TYPE_CHAR | 1024, "tdls_get"
 -	},
 -	{
 -		SIOCIWFIRSTPRIV + 0x16,
 -		IW_PRIV_TYPE_CHAR | 64, 0, "pm_set"
 -	},
 -
 -	{SIOCIWFIRSTPRIV + 0x18, IW_PRIV_TYPE_CHAR | IFNAMSIZ, 0, "rereg_nd_name=
"},
 -	{SIOCIWFIRSTPRIV + 0x1A, IW_PRIV_TYPE_CHAR | 1024, 0, "efuse_set"},
 -	{SIOCIWFIRSTPRIV + 0x1B, IW_PRIV_TYPE_CHAR | 128, IW_PRIV_TYPE_CHAR | IW=
_PRIV_SIZE_MASK, "efuse_get"},
 -	{
 -		SIOCIWFIRSTPRIV + 0x1D,
 -		IW_PRIV_TYPE_CHAR | 40, IW_PRIV_TYPE_CHAR | 0x7FF, "test"
 -	},
 -};
 -
 -static iw_handler rtw_private_handler[] =3D {
 -	rtw_wx_write32,					/* 0x00 */
 -	rtw_wx_read32,					/* 0x01 */
 -	rtw_drvext_hdl,					/* 0x02 */
 -	NULL,						/* 0x03 */
 -
 -/*  for MM DTV platform */
 -	rtw_get_ap_info,					/* 0x04 */
 -
 -	rtw_set_pid,						/* 0x05 */
 -	rtw_wps_start,					/* 0x06 */
 -
 -/*  for PLATFORM_MT53XX */
 -	rtw_wx_get_sensitivity,			/* 0x07 */
 -	rtw_wx_set_mtk_wps_probe_ie,	/* 0x08 */
 -	rtw_wx_set_mtk_wps_ie,			/* 0x09 */
 -
 -/*  for RTK_DMP_PLATFORM */
 -/*  Set Channel depend on the country code */
 -	rtw_wx_set_channel_plan,		/* 0x0A */
 -
 -	rtw_dbg_port,					/* 0x0B */
 -	rtw_wx_write_rf,					/* 0x0C */
 -	rtw_wx_read_rf,					/* 0x0D */
 -	rtw_wx_priv_null,				/* 0x0E */
 -	rtw_wx_priv_null,				/* 0x0F */
 -	rtw_p2p_set,					/* 0x10 */
 -	rtw_p2p_get,					/* 0x11 */
 -	NULL,							/* 0x12 */
 -	rtw_p2p_get2,					/* 0x13 */
 -
 -	NULL,						/* 0x14 */
 -	NULL,						/* 0x15 */
 -
 -	rtw_pm_set,						/* 0x16 */
 -	rtw_wx_priv_null,				/* 0x17 */
 -	rtw_rereg_nd_name,				/* 0x18 */
 -	rtw_wx_priv_null,				/* 0x19 */
 -	NULL,						/* 0x1A */
 -	NULL,						/* 0x1B */
 -	NULL,							/*  0x1C is reserved for hostapd */
 -	rtw_test,						/*  0x1D */
 -};
 -
 -static struct iw_statistics *rtw_get_wireless_stats(struct net_device *de=
v)
 -{
 -	struct adapter *padapter =3D rtw_netdev_priv(dev);
 -	struct iw_statistics *piwstats =3D &padapter->iwstats;
 -	int tmp_level =3D 0;
 -	int tmp_qual =3D 0;
 -	int tmp_noise =3D 0;
 -
 -	if (check_fwstate(&padapter->mlmepriv, _FW_LINKED) !=3D true) {
 -		piwstats->qual.qual =3D 0;
 -		piwstats->qual.level =3D 0;
 -		piwstats->qual.noise =3D 0;
 -	} else {
 -		tmp_level =3D padapter->recvpriv.signal_strength;
 -		tmp_qual =3D padapter->recvpriv.signal_qual;
 -		tmp_noise =3D padapter->recvpriv.noise;
 -
 -		piwstats->qual.level =3D tmp_level;
 -		piwstats->qual.qual =3D tmp_qual;
 -		piwstats->qual.noise =3D tmp_noise;
 -	}
 -	piwstats->qual.updated =3D IW_QUAL_ALL_UPDATED ;/* IW_QUAL_DBM; */
 -
 -	return &padapter->iwstats;
 -}
 -
 -struct iw_handler_def rtw_handlers_def =3D {
 -	.standard =3D rtw_handlers,
 -	.num_standard =3D ARRAY_SIZE(rtw_handlers),
 -#if defined(CONFIG_WEXT_PRIV)
 -	.private =3D rtw_private_handler,
 -	.private_args =3D (struct iw_priv_args *)rtw_private_args,
 -	.num_private =3D ARRAY_SIZE(rtw_private_handler),
 -	.num_private_args =3D ARRAY_SIZE(rtw_private_args),
 -#endif
 -	.get_wireless_stats =3D rtw_get_wireless_stats,
 -};
 -
 -/*  copy from net/wireless/wext.c start */
 -/* ---------------------------------------------------------------- */
 -/*
 - * Calculate size of private arguments
 - */
 -static const char iw_priv_type_size[] =3D {
 -	0,                              /* IW_PRIV_TYPE_NONE */
 -	1,                              /* IW_PRIV_TYPE_BYTE */
 -	1,                              /* IW_PRIV_TYPE_CHAR */
 -	0,                              /* Not defined */
 -	sizeof(__u32),                  /* IW_PRIV_TYPE_INT */
 -	sizeof(struct iw_freq),         /* IW_PRIV_TYPE_FLOAT */
 -	sizeof(struct sockaddr),        /* IW_PRIV_TYPE_ADDR */
 -	0,                              /* Not defined */
 -};
 -
 -static int get_priv_size(__u16 args)
 -{
 -	int num =3D args & IW_PRIV_SIZE_MASK;
 -	int type =3D (args & IW_PRIV_TYPE_MASK) >> 12;
 -
 -	return num * iw_priv_type_size[type];
 -}
  /*  copy from net/wireless/wext.c end */
 =20
 -static int rtw_ioctl_wext_private(struct net_device *dev, union iwreq_dat=
a *wrq_data)
 -{
 -	int err =3D 0;
 -	u8 *input =3D NULL;
 -	u32 input_len =3D 0;
 -	const char delim[] =3D " ";
 -	u8 *output =3D NULL;
 -	u32 output_len =3D 0;
 -	u32 count =3D 0;
 -	u8 *buffer =3D NULL;
 -	u32 buffer_len =3D 0;
 -	char *ptr =3D NULL;
 -	u8 cmdname[17] =3D {0}; /*  IFNAMSIZ+1 */
 -	u32 cmdlen;
 -	s32 len;
 -	u8 *extra =3D NULL;
 -	u32 extra_size =3D 0;
 -
 -	s32 k;
 -	const iw_handler *priv;		/* Private ioctl */
 -	const struct iw_priv_args *priv_args;	/* Private ioctl description */
 -	u32 num_priv_args;			/* Number of descriptions */
 -	iw_handler handler;
 -	int temp;
 -	int subcmd =3D 0;				/* sub-ioctl index */
 -	int offset =3D 0;				/* Space for sub-ioctl index */
 -
 -	union iwreq_data wdata;
 -
 -
 -	memcpy(&wdata, wrq_data, sizeof(wdata));
 -
 -	input_len =3D 2048;
 -	input =3D rtw_zmalloc(input_len);
 -	if (NULL =3D=3D input)
 -		return -ENOMEM;
 -	if (copy_from_user(input, wdata.data.pointer, input_len)) {
 -		err =3D -EFAULT;
 -		goto exit;
 -	}
 -	ptr =3D input;
 -	len =3D strlen(input);
 -
 -	sscanf(ptr, "%16s", cmdname);
 -	cmdlen =3D strlen(cmdname);
 -
 -	/*  skip command string */
 -	if (cmdlen > 0)
 -		cmdlen +=3D 1; /*  skip one space */
 -	ptr +=3D cmdlen;
 -	len -=3D cmdlen;
 -
 -	priv =3D rtw_private_handler;
 -	priv_args =3D rtw_private_args;
 -	num_priv_args =3D ARRAY_SIZE(rtw_private_args);
 -
 -	if (num_priv_args =3D=3D 0) {
 -		err =3D -EOPNOTSUPP;
 -		goto exit;
 -	}
 -
 -	/* Search the correct ioctl */
 -	k =3D -1;
 -	while ((++k < num_priv_args) && strcmp(priv_args[k].name, cmdname));
 -
 -	/* If not found... */
 -	if (k =3D=3D num_priv_args) {
 -		err =3D -EOPNOTSUPP;
 -		goto exit;
 -	}
 -
 -	/* Watch out for sub-ioctls ! */
 -	if (priv_args[k].cmd < SIOCDEVPRIVATE) {
 -		int j =3D -1;
 -
 -		/* Find the matching *real* ioctl */
 -		while ((++j < num_priv_args) && ((priv_args[j].name[0] !=3D '\0') ||
 -			(priv_args[j].set_args !=3D priv_args[k].set_args) ||
 -			(priv_args[j].get_args !=3D priv_args[k].get_args)));
 -
 -		/* If not found... */
 -		if (j =3D=3D num_priv_args) {
 -			err =3D -EINVAL;
 -			goto exit;
 -		}
 -
 -		/* Save sub-ioctl number */
 -		subcmd =3D priv_args[k].cmd;
 -		/* Reserve one int (simplify alignment issues) */
 -		offset =3D sizeof(__u32);
 -		/* Use real ioctl definition from now on */
 -		k =3D j;
 -	}
 -
 -	buffer =3D rtw_zmalloc(4096);
 -	if (NULL =3D=3D buffer) {
 -		err =3D -ENOMEM;
 -		goto exit;
 -	}
 -
 -	/* If we have to set some data */
 -	if ((priv_args[k].set_args & IW_PRIV_TYPE_MASK) &&
 -		(priv_args[k].set_args & IW_PRIV_SIZE_MASK)) {
 -		u8 *str;
 -
 -		switch (priv_args[k].set_args & IW_PRIV_TYPE_MASK) {
 -		case IW_PRIV_TYPE_BYTE:
 -			/* Fetch args */
 -			count =3D 0;
 -			do {
 -				str =3D strsep(&ptr, delim);
 -				if (NULL =3D=3D str)
 -					break;
 -				sscanf(str, "%i", &temp);
 -				buffer[count++] =3D (u8)temp;
 -			} while (1);
 -			buffer_len =3D count;
 -
 -			/* Number of args to fetch */
 -			wdata.data.length =3D count;
 -			if (wdata.data.length > (priv_args[k].set_args & IW_PRIV_SIZE_MASK))
 -				wdata.data.length =3D priv_args[k].set_args & IW_PRIV_SIZE_MASK;
 -
 -			break;
 -
 -		case IW_PRIV_TYPE_INT:
 -			/* Fetch args */
 -			count =3D 0;
 -			do {
 -				str =3D strsep(&ptr, delim);
 -				if (NULL =3D=3D str)
 -					break;
 -				sscanf(str, "%i", &temp);
 -				((s32 *)buffer)[count++] =3D (s32)temp;
 -			} while (1);
 -			buffer_len =3D count * sizeof(s32);
 -
 -			/* Number of args to fetch */
 -			wdata.data.length =3D count;
 -			if (wdata.data.length > (priv_args[k].set_args & IW_PRIV_SIZE_MASK))
 -				wdata.data.length =3D priv_args[k].set_args & IW_PRIV_SIZE_MASK;
 -
 -			break;
 -
 -		case IW_PRIV_TYPE_CHAR:
 -			if (len > 0) {
 -				/* Size of the string to fetch */
 -				wdata.data.length =3D len;
 -				if (wdata.data.length > (priv_args[k].set_args & IW_PRIV_SIZE_MASK))
 -					wdata.data.length =3D priv_args[k].set_args & IW_PRIV_SIZE_MASK;
 -
 -				/* Fetch string */
 -				memcpy(buffer, ptr, wdata.data.length);
 -			} else {
 -				wdata.data.length =3D 1;
 -				buffer[0] =3D '\0';
 -			}
 -			buffer_len =3D wdata.data.length;
 -			break;
 -
 -		default:
 -			err =3D -1;
 -			goto exit;
 -		}
 -
 -		if ((priv_args[k].set_args & IW_PRIV_SIZE_FIXED) &&
 -			(wdata.data.length !=3D (priv_args[k].set_args & IW_PRIV_SIZE_MASK))) {
 -			err =3D -EINVAL;
 -			goto exit;
 -		}
 -	} else { /* if args to set */
 -		wdata.data.length =3D 0L;
 -	}
 -
 -	/* Those two tests are important. They define how the driver
 -	* will have to handle the data */
 -	if ((priv_args[k].set_args & IW_PRIV_SIZE_FIXED) &&
 -		((get_priv_size(priv_args[k].set_args) + offset) <=3D IFNAMSIZ)) {
 -		/* First case : all SET args fit within wrq */
 -		if (offset)
 -			wdata.mode =3D subcmd;
 -		memcpy(wdata.name + offset, buffer, IFNAMSIZ - offset);
 -	} else {
 -		if ((priv_args[k].set_args =3D=3D 0) &&
 -			(priv_args[k].get_args & IW_PRIV_SIZE_FIXED) &&
 -			(get_priv_size(priv_args[k].get_args) <=3D IFNAMSIZ)) {
 -			/* Second case : no SET args, GET args fit within wrq */
 -			if (offset)
 -				wdata.mode =3D subcmd;
 -		} else {
 -			/* Third case : args won't fit in wrq, or variable number of args */
 -			if (copy_to_user(wdata.data.pointer, buffer, buffer_len)) {
 -				err =3D -EFAULT;
 -				goto exit;
 -			}
 -			wdata.data.flags =3D subcmd;
 -		}
 -	}
 -
 -	kfree(input);
 -	input =3D NULL;
 -
 -	extra_size =3D 0;
 -	if (IW_IS_SET(priv_args[k].cmd)) {
 -		/* Size of set arguments */
 -		extra_size =3D get_priv_size(priv_args[k].set_args);
 -
 -		/* Does it fits in iwr ? */
 -		if ((priv_args[k].set_args & IW_PRIV_SIZE_FIXED) &&
 -			((extra_size + offset) <=3D IFNAMSIZ))
 -			extra_size =3D 0;
 -	} else {
 -		/* Size of get arguments */
 -		extra_size =3D get_priv_size(priv_args[k].get_args);
 -
 -		/* Does it fits in iwr ? */
 -		if ((priv_args[k].get_args & IW_PRIV_SIZE_FIXED) &&
 -			(extra_size <=3D IFNAMSIZ))
 -			extra_size =3D 0;
 -	}
 -
 -	if (extra_size =3D=3D 0) {
 -		extra =3D (u8 *)&wdata;
 -		kfree(buffer);
 -		buffer =3D NULL;
 -	} else
 -		extra =3D buffer;
 -
 -	handler =3D priv[priv_args[k].cmd - SIOCIWFIRSTPRIV];
 -	err =3D handler(dev, NULL, &wdata, extra);
 -
 -	/* If we have to get some data */
 -	if ((priv_args[k].get_args & IW_PRIV_TYPE_MASK) &&
 -		(priv_args[k].get_args & IW_PRIV_SIZE_MASK)) {
 -		int j;
 -		int n =3D 0;	/* number of args */
 -		u8 str[20] =3D {0};
 -
 -		/* Check where is the returned data */
 -		if ((priv_args[k].get_args & IW_PRIV_SIZE_FIXED) &&
 -			(get_priv_size(priv_args[k].get_args) <=3D IFNAMSIZ))
 -			n =3D priv_args[k].get_args & IW_PRIV_SIZE_MASK;
 -		else
 -			n =3D wdata.data.length;
 -
 -		output =3D rtw_zmalloc(4096);
 -		if (NULL =3D=3D output) {
 -			err =3D  -ENOMEM;
 -			goto exit;
 -		}
 -
 -		switch (priv_args[k].get_args & IW_PRIV_TYPE_MASK) {
 -		case IW_PRIV_TYPE_BYTE:
 -			/* Display args */
 -			for (j =3D 0; j < n; j++) {
 -				len =3D scnprintf(str, sizeof(str), "%d  ", extra[j]);
 -				output_len =3D strlen(output);
 -				if ((output_len + len + 1) > 4096) {
 -					err =3D -E2BIG;
 -					goto exit;
 -				}
 -				memcpy(output+output_len, str, len);
 -			}
 -			break;
 -
 -		case IW_PRIV_TYPE_INT:
 -			/* Display args */
 -			for (j =3D 0; j < n; j++) {
 -				len =3D scnprintf(str, sizeof(str), "%d  ", ((__s32 *)extra)[j]);
 -				output_len =3D strlen(output);
 -				if ((output_len + len + 1) > 4096) {
 -					err =3D -E2BIG;
 -					goto exit;
 -				}
 -				memcpy(output+output_len, str, len);
 -			}
 -			break;
 -
 -		case IW_PRIV_TYPE_CHAR:
 -			/* Display args */
 -			memcpy(output, extra, n);
 -			break;
 -
 -		default:
 -			err =3D -1;
 -			goto exit;
 -		}
 -
 -		output_len =3D strlen(output) + 1;
 -		wrq_data->data.length =3D output_len;
 -		if (copy_to_user(wrq_data->data.pointer, output, output_len)) {
 -			err =3D -EFAULT;
 -			goto exit;
 -		}
 -	} else { /* if args to set */
 -		wrq_data->data.length =3D 0;
 -	}
 -
 -exit:
 -	kfree(input);
 -	kfree(buffer);
 -	kfree(output);
 -
 -	return err;
 -}
 -
+ int rtw_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+ 		       void __user *data, int cmd)
+ {
 -	struct iwreq *wrq =3D (struct iwreq *)rq;
 -
+ 	/* little hope of fixing this, better remove the whole function */
+ 	if (in_compat_syscall())
+ 		return -EOPNOTSUPP;
+=20
+ 	if (cmd !=3D SIOCDEVPRIVATE)
+ 		return -EOPNOTSUPP;
+=20
 -	return rtw_ioctl_wext_private(dev, &wrq->u);
++	return -EOPNOTSUPP;
+ }
+=20
  int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
  {
  	struct iwreq *wrq =3D (struct iwreq *)rq;

--Sig_/vAJJ2hZgXqTugHQyrKvV2TW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEsN44ACgkQAVBC80lX
0Gwv3QgAg4jFLeB27fhTJvhe2EXVhp0wWB9Uc3pY2HLXrtxEU2nEJP8RgQmFzRNm
5fYjjGP4FAsPK+qTkuJg41xct/IMmmvpla3MolpmlomdjEdIp1yTiaw9kJ0kjLbF
+iTeVk7w0Q5K7YIUDSmKSoyvFHcK77I8genSLEGryHDznuPUSU0IbMW+d4Iq/4Mb
mKRYtzwkLOXYvnbtfXVrjfB0VKvYUKJ8CGvt9z59pJkJjYY5CtgNtwe3/rmItlgE
HcooauGdVb7mSXAkhBVBOiw0bXtorigKKqffvCC4wWw344yOwLN8qzS5PC5l+DMf
NLZ6AZaDEa8PU13xg65BJHskrOkK0Q==
=QBVR
-----END PGP SIGNATURE-----

--Sig_/vAJJ2hZgXqTugHQyrKvV2TW--
