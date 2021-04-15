Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08A8360FB1
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhDOQEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:04:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233682AbhDOQE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 12:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618502643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Y79IGuOtq9K0+3NdYsvcAEnwc5UxsAQ/GxhVXEpoGM=;
        b=bytempy6UuBQXC63uPsAovPfBpUpNa4euF0IGX2RzThQuSnzJpkQknVjSUeZWu36Gg6F/X
        N5BlSuKlLS6u0uhJsIYqQrt+hTF1NMXEEBB3PqFKPOT90ISHSdPCqfTDew6ujEjt0cYeq+
        8gjmDjUveWyiXXpjATzSctttRxeM2lo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-QHCqNnLjNZ-4HEDFtbLWnw-1; Thu, 15 Apr 2021 12:04:00 -0400
X-MC-Unique: QHCqNnLjNZ-4HEDFtbLWnw-1
Received: by mail-ed1-f70.google.com with SMTP id w15-20020a056402268fb02903828f878ec5so5436276edd.5
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 09:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+Y79IGuOtq9K0+3NdYsvcAEnwc5UxsAQ/GxhVXEpoGM=;
        b=dkNRjCAvsNXaagU2Mx5rwUhK4z0sN+BdYXuEZ8UYbKZ7h0dI+7o/Lhii1VSHBrSPQj
         H1NcxgmZ5svSLHgsfb5JnmvhZwg5lxbcdvcFFxB4+GBJjzXzJuoztp9Rs0MVX97d5qmG
         UiAc2y1lPoHx/Y6trDY1bj+spK1LeX3ZzkZqtaXnqJKMzynRMvPQWub3SAAGyBKYXnI2
         iGUbCcbFucukTyEozjKlDT32X7N9JL95zNADBoNqF4p9qvFPUFMhY7XaEkoJi+0tmMwj
         28Z2ZZKiMOuDpeW7H7t3BJ7qndVK6wE+RsIr7oYlusJAMSI3KWf7Sqd7KWvUF23bb8+u
         nuUA==
X-Gm-Message-State: AOAM531ZKX4/Ovl09XLN9H+DVl4sxK+GKotTzwfCVW9B5OC95oJqB+1o
        CnTiXBqg+wd3g37UXfeMUQUI2JP+24C2hIjIshwdDv47uLjmSh4QrgwNdlxwmPJAksWoAqNdsq2
        qUK74l+PNaAE95wgN
X-Received: by 2002:a05:6402:48c:: with SMTP id k12mr5102794edv.237.1618502639585;
        Thu, 15 Apr 2021 09:03:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFEKOhWoxcde4FwNbW2fDCrUQ1O9HV4XoN11Awb/tLFaITPWZ49fI6pvUla7wJjsYvdDlAZA==
X-Received: by 2002:a05:6402:48c:: with SMTP id k12mr5102757edv.237.1618502639360;
        Thu, 15 Apr 2021 09:03:59 -0700 (PDT)
Received: from localhost ([151.66.38.94])
        by smtp.gmail.com with ESMTPSA id z6sm2181819ejp.86.2021.04.15.09.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 09:03:58 -0700 (PDT)
Date:   Thu, 15 Apr 2021 18:03:55 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, brouer@redhat.com, song@kernel.org
Subject: Re: [PATCH v2 bpf-next] cpumap: bulk skb using netif_receive_skb_list
Message-ID: <YHhj61rDPai8YKjL@lore-desk>
References: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
 <252403c5-d3a7-03fb-24c3-0f328f8f8c70@iogearbox.net>
 <47f3711d-e13a-a537-4e0e-13c3c5ff6822@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ztOcW2VeYSs9vFIg"
Content-Disposition: inline
In-Reply-To: <47f3711d-e13a-a537-4e0e-13c3c5ff6822@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ztOcW2VeYSs9vFIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 4/15/21 8:05 AM, Daniel Borkmann wrote:

[...]
> >> &stats);
> >=20
> > Given we stop counting drops with the netif_receive_skb_list(), we
> > should then
> > also remove drops from trace_xdp_cpumap_kthread(), imho, as otherwise it
> > is rather
> > misleading (as in: drops actually happening, but 0 are shown from the
> > tracepoint).
> > Given they are not considered stable API, I would just remove those to
> > make it clear
> > to users that they cannot rely on this counter anymore anyway.
> >=20
>=20
> What's the visibility into drops then? Seems like it would be fairly
> easy to have netif_receive_skb_list return number of drops.
>=20

In order to return drops from netif_receive_skb_list() I guess we need to i=
ntroduce
some extra checks in the hot path. Moreover packet drops are already accoun=
ted
in the networking stack and this is currently the only consumer for this in=
fo.
Does it worth to do so?

Regards,
Lorenzo

--ztOcW2VeYSs9vFIg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYHhj6QAKCRA6cBh0uS2t
rEQHAQCMp7U2VOiFgWscimxXkWctHZdQ8pTkKIGFDqLHqECu+AEA68KZmwUam7KF
21c7X92gk6jzx0shPpjPfKHHQ/VEDAM=
=u7Y2
-----END PGP SIGNATURE-----

--ztOcW2VeYSs9vFIg--

