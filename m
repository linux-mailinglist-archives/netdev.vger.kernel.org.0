Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691D82F622E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 14:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbhANNkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 08:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbhANNkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 08:40:14 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B93C061574
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 05:39:33 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id w1so8161186ejf.11
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 05:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=M6XCUTAkK+DaDUHEox+jtL0gwVh67PLD83wnz5MIKkU=;
        b=KqlhJm4iWWGPtCE5VzqhLdCXSbKjIRlD3Qj9L84fZCqtukRWkzTRqfxQM5EX/9Vz0r
         KxF9MHdz9dYiTn52qrgQ9nP0T6+zdqWLwgEeBhNnoPw8rVai23e7ziGVCZ95ka0tamFA
         mrlVz5Nw8uBoqjz7SP07HK9bIhnu0Fh55sBNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=M6XCUTAkK+DaDUHEox+jtL0gwVh67PLD83wnz5MIKkU=;
        b=dZ9Chgxxf7M6lOUAYCpCM4HudC8axgfnOtzKlG19NrDSy53toT6f5WZHt01AWP5fcx
         wD//F8e5gRmlc1yM4iwFTVNLN5MmReSG93waRIARAfs6V8s9Me7PQEoUOD77CnceOiWs
         y4mlRpzLmJu1uJpwoSdxpOFUaUBfRnHoYmmyUb7Q2CATQ3hwc0vB/ygRHyYhTp3KTmgt
         9uWn29O8hW/Px9N6y0h6G5eVyzJzj58Tbf2G7EAJ1FOxZgVQ/e7RStevzHIdwt8j9pIz
         tXhFQfbFNTg0B0OM/m2tTYlJ1aXUe2P6ccVh3ZRicM7ZJegEK0wRhqboaEBRcgCquBi7
         x1XA==
X-Gm-Message-State: AOAM5333O+efxmNuQooXSKj+l3orGqhf8YJACJpyzBBecNonymc5Db6u
        VU0osv2LoQwTfnE9AfPr1AKNlcINgUXo2+5NDuB8ch248EdzPVUAMjEu7RfSIS9FqqaFddmQMxk
        Fhw6i/Rw=
X-Google-Smtp-Source: ABdhPJxCW1Cb3abc/O8Ny8BTsgKfOIBjX0FlhknCR4wUJ5p9W78T8Evxgrdy39X08+POOGMi79maWQ==
X-Received: by 2002:a17:906:804c:: with SMTP id x12mr5171762ejw.42.1610631571971;
        Thu, 14 Jan 2021 05:39:31 -0800 (PST)
Received: from [192.168.178.17] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id t16sm1971141eje.109.2021.01.14.05.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 05:39:31 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: add support for CQM RSSI notifications
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210112111253.4176340-1-alsi@bang-olufsen.dk>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d97fcbc5-a0d1-40af-58d8-428f50282eed@broadcom.com>
Date:   Thu, 14 Jan 2021 14:39:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112111253.4176340-1-alsi@bang-olufsen.dk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bb939605b8dc623e"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000bb939605b8dc623e
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12-01-2021 12:13, 'Alvin =C5=A0ipraga' via BRCM80211-DEV-LIST,PDL wrote:
> Add support for CQM RSSI measurement reporting and advertise the
> NL80211_EXT_FEATURE_CQM_RSSI_LIST feature. This enables a userspace
> supplicant such as iwd to be notified of changes in the RSSI for roaming
> and signal monitoring purposes.

Needs a bit of rework. See my comments below...

> Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
> ---
>   .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 82 +++++++++++++++++++
>   .../broadcom/brcm80211/brcmfmac/cfg80211.h    |  6 ++
>   .../broadcom/brcm80211/brcmfmac/fwil_types.h  | 28 +++++++
>   3 files changed, 116 insertions(+)
>=20
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c =
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 0ee421f30aa2..21b53bd27f7f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -5196,6 +5196,41 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct=
 wireless_dev *wdev,
>   	return err;
>   }
>  =20
> +static int brcmf_cfg80211_set_cqm_rssi_range_config(struct wiphy *wiphy,
> +						    struct net_device *ndev,
> +						    s32 rssi_low, s32 rssi_high)
> +{
> +	struct brcmf_cfg80211_vif *vif;
> +	struct brcmf_if *ifp;
> +	int err =3D 0;
> +
> +	brcmf_dbg(TRACE, "low=3D%d high=3D%d", rssi_low, rssi_high);
> +
> +	ifp =3D netdev_priv(ndev);
> +	vif =3D ifp->vif;
> +
> +	if (rssi_low !=3D vif->cqm_rssi_low || rssi_high !=3D vif->cqm_rssi_hig=
h) {
> +		struct brcmf_rssi_event_le config =3D {
> +			.rate_limit_msec =3D cpu_to_le32(0),
> +			.rssi_level_num =3D 2,
> +			.rssi_levels =3D {
> +				max_t(s32, rssi_low, S8_MIN),
> +				min_t(s32, rssi_high, S8_MAX),

The type should be s8 iso s32.

> +			},
> +		};

What is the expectation here? The firmware behavior for the above is=20
that you will get an event when the rssi is lower or equal to the level=20
and the previous rssi event was lower or equal to a different level.=20
There is another event RSSI_LQM that would be a better fit although that=20
is not available in every firmware image ("rssi_mon" firmware feature).

Another option would be to add a level, ie.:

	.rssi_levels =3D {
		max_t(s8, rssi_low, S8_MIN),
		min_t(s8, rssi_high, S8_MAX - 1),
		S8_MAX
	}

> +		err =3D brcmf_fil_iovar_data_set(ifp, "rssi_event", &config,
> +					       sizeof(config));
> +		if (err) {
> +			err =3D -EINVAL;
> +		} else {
> +			vif->cqm_rssi_low =3D rssi_low;
> +			vif->cqm_rssi_high =3D rssi_high;
> +		}
> +	}
> +
> +	return err;
> +}
>  =20
>   static int
>   brcmf_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
> @@ -5502,6 +5537,7 @@ static struct cfg80211_ops brcmf_cfg80211_ops =3D {
>   	.update_mgmt_frame_registrations =3D
>   		brcmf_cfg80211_update_mgmt_frame_registrations,
>   	.mgmt_tx =3D brcmf_cfg80211_mgmt_tx,
> +	.set_cqm_rssi_range_config =3D brcmf_cfg80211_set_cqm_rssi_range_config=
,
>   	.remain_on_channel =3D brcmf_p2p_remain_on_channel,
>   	.cancel_remain_on_channel =3D brcmf_cfg80211_cancel_remain_on_channel,
>   	.get_channel =3D brcmf_cfg80211_get_channel,
> @@ -6137,6 +6173,49 @@ brcmf_notify_mic_status(struct brcmf_if *ifp,
>   	return 0;
>   }
>  =20
> +static s32 brcmf_notify_rssi(struct brcmf_if *ifp,
> +			     const struct brcmf_event_msg *e, void *data)

align to the opening brace in the line above.

> +{
> +	struct brcmf_cfg80211_vif *vif =3D ifp->vif;
> +	struct brcmf_rssi_be *info =3D data;
> +	s32 rssi, snr, noise;
> +	s32 low, high, last;
> +
> +	if (e->datalen < sizeof(*info)) {
> +		brcmf_err("insufficient RSSI event data\n");
> +		return 0;
> +	}
> +
> +	rssi =3D be32_to_cpu(info->rssi);
> +	snr =3D be32_to_cpu(info->snr);
> +	noise =3D be32_to_cpu(info->noise);

Bit surprised to see this is BE, but it appears to be correct.

> +	low =3D vif->cqm_rssi_low;
> +	high =3D vif->cqm_rssi_high;
> +	last =3D vif->cqm_rssi_last;
> +
> +	brcmf_dbg(TRACE, "rssi=3D%d snr=3D%d noise=3D%d low=3D%d high=3D%d last=
=3D%d\n",
> +		  rssi, snr, noise, low, high, last);
> +
> +	if (rssi !=3D last) {

Given the firmware behavior I don't think you need this check.

> +		vif->cqm_rssi_last =3D rssi;
> +
> +		if (rssi <=3D low || rssi =3D=3D 0) {
> +			brcmf_dbg(INFO, "LOW rssi=3D%d\n", rssi);
> +			cfg80211_cqm_rssi_notify(ifp->ndev,
> +						 NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
> +						 rssi, GFP_KERNEL);
> +		} else if (rssi > high) {
> +			brcmf_dbg(INFO, "HIGH rssi=3D%d\n", rssi);
> +			cfg80211_cqm_rssi_notify(ifp->ndev,
> +						 NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
> +						 rssi, GFP_KERNEL);
> +		}
> +	}
> +
> +	return 0;

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--000000000000bb939605b8dc623e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pra5sIx/TR6gNtLG9MpND9zQt5j42hInkP81vqu9DG8lovoPMuR0JVpFRbPjHZ07cLqqbFMVS/8z
53iSewIDAQABo4IB0zCCAc8wDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggr
BgEFBQcwAoZBaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNp
Z24yc2hhMmczb2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNv
bS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAw
RAYDVR0fBD0wOzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2ln
bjJzaGEyZzMuY3JsMCcGA1UdEQQgMB6BHGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20wEwYD
VR0lBAwwCgYIKwYBBQUHAwQwHwYDVR0jBBgwFoAUaXKCYjFnlUSFd5GAxAQ2SZ17C2EwHQYDVR0O
BBYEFHAaaA+cRo3vYiA6aKVu1bOs4YAYMA0GCSqGSIb3DQEBCwUAA4IBAQCYLdyC8SuyQV6oa5uH
kGtqz9FCJC/9gSclQLM8dZLHF3FYX8LlcQg/3Ct5I29YLK3T/r35B2zGljtXqVOIeSEz7sDXfGNy
3dnLIafB1y04e7aR+thVn5Rp1YTF01FUWYbZrixlVuKvjn8vtKC+HhAoDCxvqnqEuA/8Usn7B0/N
uOA46oQTLe3kjdIgXWJ29JWVqFUavYdcK0+0zyfeMBCTO6heYABeMP3wzYHfcuFDhqldTCpumqhZ
WwHVQUbAn+xLMIQpycIQFoJIGJX4MeaTSMfLNP2w7nP2uLNgIeleF284vS0XVkBXSCgIGylP4SN+
HQYrv7fVCbtp+c7nFvP7MYICbzCCAmsCAQEwbTBdMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xv
YmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25hbFNpZ24gMiBDQSAtIFNI
QTI1NiAtIEczAgxR3m7Pj6LvQiWjJy0wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIE
INdz7Ffimv7pfEe5x3tmd7ckxTIuAf0y15N1u1ddkOkyMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
BwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDExNDEzMzkzMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgB
ZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQow
CwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAzsibs/lLAQDwPmFgf
9CGrzm4Qez9HZK59BVR6OIC/yNWuWJiYwuL9YKYr6bJE+vJ2olAVshPjucZM7Exy9cYJoe6Iertk
qtEAd1frmxoIDQg4dIKVaenjdd0E1sZAxN+LiD59LJhLFaJ2wbGQPiOSaEacQhSlZRNktl9Z8V28
103OjFq9I7q8DAGRv4ByotgzSOVjvo3LAg7yDJLgC0o4YWNm35FAiU0PnMTG4aorVHugZq+iXO+h
GFASaeWAs8k0qqPfIxzM5LW0jwq6fWTdZfFGdoSmURMwf+C6S0P4WYnb7MfbLe4ix93AvieT6gP7
6u2tWeww+WnLIWlG6iNd
--000000000000bb939605b8dc623e--
