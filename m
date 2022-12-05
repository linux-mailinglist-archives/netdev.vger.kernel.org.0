Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508A4643853
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 23:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiLEWsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 17:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbiLEWr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 17:47:59 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDEF1AD97
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 14:47:57 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id t17so2057191eju.1
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 14:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XfFAyOlM8sL0V5u16YiCeUktzs+JplDJjb/OWdcCFj8=;
        b=d/vFpO2d2Q+As6+/S/aQl8gkVXgJkf2Ms5hixWpiGFOL8uJDlJ6WwAvIjGGKmADUPs
         rzdQKXZsRAkN47IZ5XO2oQPmLXhGIPG3n2ABU8Wpml1gB6bqpyftLqIDZzBx3VJjjXUC
         4jrjSUGZB1lTvh5h0KdYpWARD017XfLmEPlNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XfFAyOlM8sL0V5u16YiCeUktzs+JplDJjb/OWdcCFj8=;
        b=g2Np9X8b8KdqTd20w9b0KeBYYFoPNdW3r/W7gFuCSWfH0p0fR7oS6aE+ccaEMiaNDV
         aBkfD4TvAq8tCiu48fFvY9ikK1v9CILeS8Ml46z+Mb7aHJYGRqrAxcO9c1gyCsD0y8aw
         ACtCqNR3fwZWUYZ/perh+l9lFqYIwGbFFUVdZ6o0S0xGuZzKH4wf/5G2lsDrw2lNiHIu
         kHt8HQAsoaQJNZmEo+rYlaDcpd5ndRib7PfgHwyqsJ1wN6KegxJL3f2P2/iBpLBL9ZON
         NFVlRYbsRdWKLz6LS+KJi1KZMf3G5rXe8jJLhAb5RPeMW7WZk+K9NByrSULrwDX6QaEG
         O9Gg==
X-Gm-Message-State: ANoB5pmxZt/gYQZBW6UTYrRQEGrz3xyjFde+AwYGOdYaPqD8YX9PvUGW
        Ux5YKfAexKok+ix/06f+9iyHWiakiK9Rq69gU45KUw==
X-Google-Smtp-Source: AA0mqf6KfyHLvTLy7V/yXKihGXqIoAHlH8gDzlbZkod9defz/Pv7pAhiHoAo1801sGm/yi80AMKDSJUex28FefdMDi8=
X-Received: by 2002:a17:906:fc9:b0:7ae:ef99:6fb2 with SMTP id
 c9-20020a1709060fc900b007aeef996fb2mr70279585ejk.761.1670280475805; Mon, 05
 Dec 2022 14:47:55 -0800 (PST)
MIME-Version: 1.0
References: <20221202221213.236564-1-lixiaoyan@google.com> <20221202221213.236564-2-lixiaoyan@google.com>
 <CANn89iLx7WM4ih6EM8LAdXHN6W2Pd61awPz4FLL82FEBbXeRuA@mail.gmail.com>
In-Reply-To: <CANn89iLx7WM4ih6EM8LAdXHN6W2Pd61awPz4FLL82FEBbXeRuA@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 5 Dec 2022 14:47:44 -0800
Message-ID: <CACKFLi=nJgVLC+PaXsyGFd4x+QbbMrk6_hRY9APqshrP0xo31w@mail.gmail.com>
Subject: Re: [RFC net-next v4 2/2] bnxt: Use generic HBH removal helper in tx path
To:     Eric Dumazet <edumazet@google.com>
Cc:     Coco Li <lixiaoyan@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000076702a05ef1c7a75"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000076702a05ef1c7a75
Content-Type: text/plain; charset="UTF-8"

On Sun, Dec 4, 2022 at 9:14 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Dec 2, 2022 at 11:12 PM Coco Li <lixiaoyan@google.com> wrote:
> >
> > Eric Dumazet implemented Big TCP that allowed bigger TSO/GRO packet sizes
> > for IPv6 traffic. See patch series:
> > 'commit 89527be8d8d6 ("net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes")'
> >
> > This reduces the number of packets traversing the networking stack and
> > should usually improves performance. However, it also inserts a
> > temporary Hop-by-hop IPv6 extension header.
> >
> > Using the HBH header removal method in the previous path, the extra header
> > be removed in bnxt drivers to allow it to send big TCP packets (bigger
> > TSO packets) as well.
> >
> > Tested:
> > Compiled locally
> >
> > To further test functional correctness, update the GSO/GRO limit on the
> > physical NIC:
> >
> > ip link set eth0 gso_max_size 181000
> > ip link set eth0 gro_max_size 181000
> >
> > Note that if there are bonding or ipvan devices on top of the physical
> > NIC, their GSO sizes need to be updated as well.
> >
> > Then, IPv6/TCP packets with sizes larger than 64k can be observed.
> >
> > Big TCP functionality is tested by Michael, feature checks not yet.
> >
> > Tested by Michael:
> > I've confirmed with our hardware team that this is supported by our
> > chips, and I've tested it up to gso_max_size of 524280.  Thanks.
> >
> > Tested-by: Michael Chan <michael.chan@broadcom.com>
> > Reviewed-by: Michael Chan <michael.chan@broadcom.com>
> > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > ---
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 26 ++++++++++++++++++++++-
> >  1 file changed, 25 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > index 0fe164b42c5d..c2713cb5debd 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > @@ -389,6 +389,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >                         return NETDEV_TX_BUSY;
> >         }
> >
> > +       if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
> > +               goto tx_free;
> > +
> >         length = skb->len;
> >         len = skb_headlen(skb);
> >         last_frag = skb_shinfo(skb)->nr_frags;
> > @@ -11342,9 +11345,28 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
> >
> >                 if (hdrlen > 64)
> >                         return false;
> > +
> > +               /* The ext header may be a hop-by-hop header inserted for
> > +                * big TCP purposes. This will be removed before sending
> > +                * from NIC, so do not count it.
> > +                */
> > +               if (*nexthdr == NEXTHDR_HOP) {
> > +                       if (likely(skb->len <= GRO_LEGACY_MAX_SIZE))
> > +                               goto increment_hdr;
> > +
> > +                       struct hop_jumbo_hdr *jhdr = (struct hop_jumbo_hdr *)(nexthdr + hdrlen);
>
> We discourage adding a variable declaration in the middle of code.
>

This doesn't work.  Initially nexthdr points to the nexthdr in the
ipv6 header.  It should be coded like this:

struct hop_jumbo_hdr *jhdr = (struct hop_jumbo_hdr *)hp;

Thanks.

--00000000000076702a05ef1c7a75
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILjsxREZK4LyHn0lBCgTnMB73fDLVzyy
TH2jgLBa/3/oMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIw
NTIyNDc1NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQA3Pvy4/ARfeiAqBx29pmdRrcQL5Tl5dlMk0kPdQN2JrZypRexW
Pjixy9OOk9n8hoI6HrAyKqVliY6sRwJVFL+E+z3Z3rO5XHCKawFwXuklP3RwXSDPn9t8iC3scN7W
86bcEVzzZHb7ZJ7kCgvMcwCKNK2/xqcRPCo7pZerJzcaDhWlQKWQkD/BFmGVnyxxnngLssOviRQQ
Qy82oX0aCbg5ZFXoY2zMlmrG/m+DHqC5BHB/18/pS5PGHDAs9jmWLo23RCnNPklwT1H1KHV2QYBF
Uw+g7+JGN9LrdGJQCIUBGDc3ixEHd9iSxeIOkHkxNQZ9d6YfccuvWjYHeWj8+weW
--00000000000076702a05ef1c7a75--
