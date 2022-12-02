Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EA2640010
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 06:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiLBF4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 00:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiLBF4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 00:56:37 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77FDD5860
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 21:56:36 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d1so6227544wrs.12
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 21:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4u58HOUPda4k4nxgLaNlIjDc0+Ai0uGttioRbJu0jHc=;
        b=CPWISx4nRoubArlqFFC/r9DAMRVGLRl3xT/ldehkQ0PhDyX4SvzG09fzLAuEpovVKX
         fSZneabPFtpTkEgX6Ib8HTQq5TI3wpebxqensKSpf704XZPpbKf7oydkDTFbBA+lu3go
         RRseexR58yo/ejzCs9BdC+wxbQjaMXhH2yzdk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4u58HOUPda4k4nxgLaNlIjDc0+Ai0uGttioRbJu0jHc=;
        b=qgETiCJIFliznxpZ3dI6rvCYfCLwCmnMpdbTmfMrNkD0l9n5s3XbMkazCQjmRKluhz
         e1dPl+otO6SAGdkKAPmgL+a86Ii8XNG1tBHZD+3KROZhr1lz3bahzaG0wYkvEQi+7rHi
         SldOF0g7oAksGukVpH8Dqnq6w2LSiYC1yPOQ5QS5Xydab+WQCchlZRl784+Cond/WSm8
         lXCiu3Y9nGZwtaBavxr7nKY2tvwzZRu0p6DeCF8M57sUuBRArRHBE6YaipAxIxRve5qb
         X0EJlgWHK7y31xMfBaiqxHyuw20lvG+jt6MUVS6kNbmjBmrzx6yPPqDyU5dOiuxsRLRW
         Phhw==
X-Gm-Message-State: ANoB5pkAex9QhCaHGkaM2WPho91nR+ofLZl281Q5J7BY+TNo4nlpAaDI
        0DTAVNjv+ZQE9zq9ju+eGIUicPA3V/M7CUYvkMKQBw==
X-Google-Smtp-Source: AA0mqf4SeuQ/wz1+wECsPrhXiTiOpYb3p3qB9+9Sld15oAe6CQAiLAqdgt5+exNvmR1L7Cp+HqpqmelhO92qS9YyNtk=
X-Received: by 2002:adf:e103:0:b0:241:e2d5:8ef2 with SMTP id
 t3-20020adfe103000000b00241e2d58ef2mr29304251wrz.630.1669960595022; Thu, 01
 Dec 2022 21:56:35 -0800 (PST)
MIME-Version: 1.0
References: <20221129200653.962019-1-lixiaoyan@google.com> <20221129200653.962019-2-lixiaoyan@google.com>
 <CACKFLi=qu7KBNPAST0fffxu1TC7-PAX2QzMM6b-1C0X5OCNFqQ@mail.gmail.com> <CADjXwjgJtXQx14h4_aSYiEHgZjGsYVGEs+LKm13BkweZFAtUUQ@mail.gmail.com>
In-Reply-To: <CADjXwjgJtXQx14h4_aSYiEHgZjGsYVGEs+LKm13BkweZFAtUUQ@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 1 Dec 2022 21:56:23 -0800
Message-ID: <CACKFLi=-q+JTrL9RXGwVdQmU9Vw3GWOi5awP-bs9Zeaikre8bw@mail.gmail.com>
Subject: Re: [RFC net-next v3 2/2] bnxt: Use generic HBH removal helper in tx path
To:     Coco Li <lixiaoyan@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000155f6205eed2004d"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000155f6205eed2004d
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 1, 2022 at 6:03 PM Coco Li <lixiaoyan@google.com> wrote:
>
> On Tue, Nov 29, 2022 at 12:42 PM Michael Chan <michael.chan@broadcom.com> wrote:
> >
> > On Tue, Nov 29, 2022 at 12:07 PM Coco Li <lixiaoyan@google.com> wrote:
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > index 0fe164b42c5d..f144a5ef2e04 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > @@ -389,6 +389,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >                         return NETDEV_TX_BUSY;
> > >         }
> > >
> > > +       if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
> > > +               goto tx_free;
> > > +
> > >         length = skb->len;
> > >         len = skb_headlen(skb);
> > >         last_frag = skb_shinfo(skb)->nr_frags;
> > > @@ -11342,9 +11345,15 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
> > >
> > >                 if (hdrlen > 64)
> > >                         return false;
> > > +
> > > +               /* The ext header may be a hop-by-hop header inserted for
> > > +                * big TCP purposes. This will be removed before sending
> > > +                * from NIC, so do not count it.
> > > +                */
> > > +               if (!(*nexthdr == NEXTHDR_HOP && ipv6_has_hopopt_jumbo(skb)))
> >
> > To be more efficient, why not just check the header's tlv_type here
> > instead of calling ipv6_has_hopopt_jumbo()?
> >
>
> It may be possible that the next header is Hop_by_hop but the packet
> is not tcp, meaning that it would not be removed and we'd still want
> to count this header towards the limit.
> ipv6_has_hopopt_jumbo checks for the big tcp case (gso, skb len
> reaches a certain size) particularly.
>

We can add all the additional checks here and it will still be more
efficient because we already know this is ipv6 and we are looking at
the extension header.  This is fast path so I think we want to be as
efficient as possible.

--000000000000155f6205eed2004d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILc67FrTIxN4/m3nDApDsbWJnfZYHCAx
YB7VoeG5wxUrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIw
MjA1NTYzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAHplREFPTgAGGV3yp6QSxYwqFWrt9LjRFop2ZeXaCkqFodpsOl
bZ/gyyALu+k03NhnazPP7crowfEnK4KflZMwhiIHceaaBzjPrCeCkNRdJ3xZHYySQuEuYGZshfbI
0VTrjqYBTrr0jGfTmy+LxvGhn87wJ1GQKJNP3hI0JP+h+GNzYEwsvmqNPGXn/auJGLDxFFA9xuoq
lCZP5D22IqVO3/CK5tpCSu5saDz1CfdMaYSXh0VqqEEekZClRpAqsWULOS1yWBLeBNUUZDI4qvbP
d4QVs6/mzVHNPMxxnH0rnu8V/OpH+jjsishvSwUkZSJ3LpPkDxLEmuKvq+3G975K
--000000000000155f6205eed2004d--
