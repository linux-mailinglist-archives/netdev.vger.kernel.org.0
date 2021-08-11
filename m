Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6202A3E9B4A
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 01:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhHKXjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 19:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbhHKXjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 19:39:18 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF27C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 16:38:54 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id m12so2146844qvt.1
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 16:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8UXNm/aO0w65kk7gKAq65GEnTJuz2IPEoAIBva1F9w=;
        b=UsAyEyM9j3sVtm+024bJMNDSDVez/xAiAXE52MqK1HXwebgdqHBwrxaaROjmnrCmSw
         Bdn1WK2tVeMX4JpnbATPVMliP7uSe4F3dnLFqNrnwB5WS+cVYVjb+E31eqyLLHhjC/57
         5Ire+pCUtrp/BtUOcahNZjlB897RDfsMKZpF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8UXNm/aO0w65kk7gKAq65GEnTJuz2IPEoAIBva1F9w=;
        b=XDkMi/tS8NlX05NlfpRSKnGebedQboZWjmJjowk4v3T8kemISORsgWzgzIN/axdzJa
         QPkw1gG+5sFjATVEe3Pbf3Q0a47BOo7nL8qCYhFVhYTtQqtfMdq0iHt9Sjz90tZ9ALBN
         EDJG4USrtcQ1S1qdgNHWVv60kDQ29O+0RaEXrjum0ZrhWNI47tcnXspOZTQRjeMnwXUz
         sv8VSdc/TNBGeoiySXJgGClQUYchmBjSXsr0X2F/GjlmALgbKHtRAaRCLuz53xIJLY7h
         yRD/PsWF9f7ZMDv+oKlrCiMz602WjC0nRZgGaKid2a2z8Qj/LEBBx8k9efZjIauPIX0F
         rURw==
X-Gm-Message-State: AOAM531ksJp+AV4py93S5AIis5ggTnq/moCU+DooSBn/1F6dCyqjNQY6
        lbvzKazrqOmu0l++WWNmm4Lbl2KbSeuTPyf6ULLJOQ==
X-Google-Smtp-Source: ABdhPJxZXzkAHP+ycjJA1pep3dmWHtK16U6A7LP+ft/nD4PHSDbuV1vCzcCWWzds4fwDE1VqOgYQA0unsSyi+QWsD1o=
X-Received: by 2002:a0c:d801:: with SMTP id h1mr1244407qvj.60.1628725133226;
 Wed, 11 Aug 2021 16:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210811213749.3276687-1-kuba@kernel.org> <20210811213749.3276687-4-kuba@kernel.org>
 <CACKFLinMd6a9Lwq_H1yNp8PFpvNmBsG5R+YGAYuCiF+i0OF+3w@mail.gmail.com>
 <20210811154441.3b593d94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACKFLikXmSem_anENYaxh63e9uQNf-9W3cUtMmBoDUoZ+XsOkQ@mail.gmail.com> <20210811161658.64551a1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811161658.64551a1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 11 Aug 2021 16:38:42 -0700
Message-ID: <CACKFLimUFpvLg2dY3P-gYdrn8A1DA7_aNj8BbBPiU9denG3ysw@mail.gmail.com>
Subject: Re: [PATCH net v2 3/4] bnxt: make sure xmit_more + errors does not
 miss doorbells
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jeffrey Huang <huangjw@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Andrew Gospodarek <gospo@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Edwin Peer <edwin.peer@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000669cb05c9511f78"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000669cb05c9511f78
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 11, 2021 at 4:17 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 11 Aug 2021 16:00:52 -0700 Michael Chan wrote:
> > On Wed, Aug 11, 2021 at 3:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 11 Aug 2021 15:36:34 -0700 Michael Chan wrote:
> > > > On Wed, Aug 11, 2021 at 2:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > @@ -367,6 +368,13 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
> > > > >         return md_dst->u.port_info.port_id;
> > > > >  }
> > > > >
> > > > > +static void bnxt_txr_db_kick(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
> > > > > +                            u16 prod)
> > > > > +{
> > > > > +       bnxt_db_write(bp, &txr->tx_db, prod);
> > > > > +       txr->kick_pending = 0;
> > > > > +}
> > > > > +
> > > > >  static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > > >  {
> > > > >         struct bnxt *bp = netdev_priv(dev);
> > > > > @@ -396,6 +404,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > > >         free_size = bnxt_tx_avail(bp, txr);
> > > > >         if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
> > > > >                 netif_tx_stop_queue(txq);
> > > > > +               if (net_ratelimit() && txr->kick_pending)
> > > > > +                       netif_warn(bp, tx_err, dev, "bnxt: ring busy!\n");
> > > >
> > > > You forgot to remove this.
> > >
> > > I changed my mind. I added the && txr->kick_pending to the condition,
> > > if there is a race and napi starts the queue unnecessarily the kick
> > > can't be pending.
> >
> > I don't understand.  The queue should be stopped if we have <=
> > MAX_SKB_FRAGS + 1 descriptors left.  If there is a race and the queue
> > is awake, the first TX packet may slip through if
> > skb_shinfo(skb)->nr_frags is small and we have enough descriptors for
> > it.  Let's say xmit_more is set for this packet and so kick is
> > pending.  The next packet may not fit anymore and it will hit this
> > check here.
>
> But even if we slip past this check we can only do it once, the check
> at the end of start_xmit() will see we have fewer slots than MAX_FRAGS
> + 2, ring the doorbell and stop.

Yeah, I think you're right.

--0000000000000669cb05c9511f78
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINHvIcrBxWyXNVATHNNVFrWsv8e0ul2G
5f/zcxqKUd4lMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgx
MTIzMzg1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBz4kAYVZFXzwgyBAK+y0qD1QzX1rylX+Hr94RPd7A5aa6y+6ry
KPhxP5ciQB4mrADyeAkeiKHXzo3sNsIZ4ihpE2iWNcPXmyk35JyTsK+uvSSQtSekYvUzi18z/TY/
NpjFYMlw5l1y6WXUlJYVVT9dbx8eexD+6wZZIt9FqOeApyIBHnBW9dJM9apeMdp49A/FsicFThok
Vfp+vzZ43ptR8mCH49g3AOvK2PQEMPlOKXQdv9340hwY+lnPxeG5xWGxb1/Isvxe+Z04ouU43VmI
bC5X+9ZVjY4adPYc6E5IuPuybejl504wiFqzH4C1hUux9WgYp80Wi/CUfDHaYJfG
--0000000000000669cb05c9511f78--
