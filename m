Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500DB3F82D0
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 08:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbhHZG7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 02:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhHZG7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 02:59:09 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D961FC061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 23:58:22 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id f7so1440363qvt.8
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 23:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w3nkwQCYA8hQLlrfFQ79j9BbqcfXcYl/uI38LOU3bFE=;
        b=RylRED59lGjjpuxH3Pwkl29B08MNiCyEKQhGj1nebBM1QjWp0XBeRhVHtZcFTwVa8l
         QwVwiMpuM9/ruv0dgAKnV//wlw4wfLPT/QF3j1pGv/qMdmefmzkeoLoelGoVr6i4miVh
         bz60wVhzoa4F96Ja12f7qlnmUIyxyFvQErg1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w3nkwQCYA8hQLlrfFQ79j9BbqcfXcYl/uI38LOU3bFE=;
        b=MaysvMv3N5s0uR67jq/rZiDvrZ7yZ11sQ+aqKJ5nHIi65Z9yTR2MGi4a9Sw5FblI0D
         F2qTkvc/GA/5XtUg5jahURl+VlEdzkqGtENN2QL6cIpJj8qrzwmfqrWzkOpopPd86JjM
         dkV0+t011QCo3xPa0zZh2ZnWUeQF6igBWFlPYADQJxPm8EZw66feeHFfD6vnI/G//Zrl
         u6wS8G9y5/OYiXJfJ94Em6oF7hNeXdU06CBYEY6lD6MlatAvMSdFMFvwtlWL/anL4NPL
         BtX/RhxlNgCmDGqLmFNE+v4kWSvgg3s9PvDGdK/OD4G0Vhc9MxbwjnQizEZmzjfJY9dH
         /cBw==
X-Gm-Message-State: AOAM531Zj4w0P/18zWyzuXUuVahRinci8o0KpP2Ec7XCx6PfItduscsU
        4PPmJI5aTzyLHdSq1EPDpq/00wyPmytFnb/RpGfNhw==
X-Google-Smtp-Source: ABdhPJwA9WeQMHMiDNQsxdYUtncNfdG/TgoaXRP/2+auQl7gVjQLQbd0R28mOtMF47RDpFRei7WK/B5CpF1GST48V/E=
X-Received: by 2002:a0c:d801:: with SMTP id h1mr2601058qvj.60.1629961101733;
 Wed, 25 Aug 2021 23:58:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210826014731.2764066-1-kuba@kernel.org> <20210826014731.2764066-3-kuba@kernel.org>
In-Reply-To: <20210826014731.2764066-3-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 25 Aug 2021 23:58:10 -0700
Message-ID: <CACKFLinV5Ca_rReE6-cgXjwdnHX1SHwykJahTqxJLRK76ySmrQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] bnxt: count packets discarded because of netpoll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, olteanv@gmail.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007f8fa705ca70e4a7"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007f8fa705ca70e4a7
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 25, 2021 at 6:47 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> bnxt may discard packets if Rx completions are consumed
> in an attempt to let netpoll make progress. It should be
> exteremely rare in practice but nonetheless such events
> should be counted.
>
> Since completion ring memory is allocated dynamically use
> a similar scheme to what is done for HW stats to save them.
>
> Report the stats in rx_dropped and per-netdev ethtool
> counter. Chances that users care which ring dropped are
> very low.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 31 ++++++++++++++-----
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 ++
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  6 ++++
>  3 files changed, 32 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index d39449e7b236..d12a9052388f 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -2003,6 +2003,7 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
>         struct rx_cmp *rxcmp;
>         u16 cp_cons;
>         u8 cmp_type;
> +       int ret;
>
>         cp_cons = RING_CMP(tmp_raw_cons);
>         rxcmp = (struct rx_cmp *)
> @@ -2031,7 +2032,10 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
>                 tpa_end1->rx_tpa_end_cmp_errors_v2 |=
>                         cpu_to_le32(RX_TPA_END_CMP_ERRORS);
>         }
> -       return bnxt_rx_pkt(bp, cpr, raw_cons, event);
> +       ret = bnxt_rx_pkt(bp, cpr, raw_cons, event);
> +       if (ret != -EBUSY)
> +               cpr->sw_stats.rx.rx_netpoll_discards += 1;

To be more accurate, we should also skip counting if ret is 0.  0
means it is a TPA_START completion for the start of an aggregated
packet.  We haven't dropped this aggregated packet yet until we
process the TPA_END completion.

> +       return ret;
>  }
>
>  u32 bnxt_fw_health_readl(struct bnxt *bp, int reg_idx)

--0000000000007f8fa705ca70e4a7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIK3qR7Z7fKvzBH8rTXwn5h8gn3xK8pRd
oannyMO7/Q9iMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
NjA2NTgyMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDVqnlh5rqHo8GXlLBodm907DG6wuV5YHCKJ+Jqk0yBetZVzCNv
s/1Ui1I6z/nNomOZ5kAcXWcCCNzMNiLSYVCNW35lpYBlBMaajWrZuNaTuz0aaSAAFreVzTJB0ZIM
nPQ25tFNepyu35B9jiK3CNXo0c5HpiEIXFHHkQTy087bzmGtpRyvufKoOx3xBqo8D93r5qbtNAcz
GTjdPv6BrIfqkif+CUWYe5eLzeOfYYiBBQryHUP5Hxr+Ev5GqAIoD5me2zyCMHAhBLZ6ANjr+x1a
IQZyCZUik90yZrLkAp9jYi/l/re1SHFm0SVwAgjDVFSaP5s6QCmdq9oMjK4SDBJd
--0000000000007f8fa705ca70e4a7--
