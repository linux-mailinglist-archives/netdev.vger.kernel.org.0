Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409E926387
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 14:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfEVMNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 08:13:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40578 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfEVMNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 08:13:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id 15so1953179wmg.5
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 05:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bJ/T2gYKVNslQdPNYfkMQEjQ6hpfjvxWlwmhVEqRBCQ=;
        b=R7zLzO36Rej5x/02PCozvilfVmSIc+19Zz5RYA0zIwvzPguOxkz97/cXwcYhOTudho
         WdAHLaOuyUO+Zpzdk/j04hcUi4JzMjJgRLRIwzZoxeHXSfK2CByEpWlv5+a6eI4XaW5O
         pLEftFy9JtpEYwjON94OiK+pXb30hMO+pZ4XcPgfLqw8GsUSiN+qY7gbejOz+aykbOJj
         LrUERe+NO6J6y6Z6vAmq53WW7kJlogecebvFaCRn6rUnnf5SakJVHzErsWo0yNP1ZWC+
         YHDUs1OuZ+NOTolgb3QgFb7DDxiof9WQnkNbnWRs1GIKBMRDXvyBYfI9224l6NXGNvvI
         zggg==
X-Gm-Message-State: APjAAAUQKD2W5RvUgAC1DIg5FAddoB5bpNoqjR8M5mffMGTa+n9urlN7
        DBWEqYcnR/ExkK/vlJtcHgLOIQ==
X-Google-Smtp-Source: APXvYqwtYhADN3+XJPVDq05kW20Ju3rAuy3AsEehEBSQFPEByY1YBQ2sDy5ZaB7sFOqgKZ5zAHAi3A==
X-Received: by 2002:a1c:3c2:: with SMTP id 185mr7458907wmd.91.1558527197474;
        Wed, 22 May 2019 05:13:17 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id h6sm2944088wrm.47.2019.05.22.05.13.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 05:13:16 -0700 (PDT)
Date:   Wed, 22 May 2019 14:13:14 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net] net: sched: sch_ingress: do not report ingress
 filter info in egress path
Message-ID: <20190522121313.GB3467@localhost.localdomain>
References: <cover.1558442828.git.lorenzo.bianconi@redhat.com>
 <738244fd5863e6228275ee8f71e81d6baafca243.1558442828.git.lorenzo.bianconi@redhat.com>
 <365843b0b605d272a7ec3cf4ebf4cb5ea70b42e6.camel@redhat.com>
 <20190522102013.GA3467@localhost.localdomain>
 <ac3120ae-245b-05ab-2abf-6c0710827fc5@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <ac3120ae-245b-05ab-2abf-6c0710827fc5@iogearbox.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 05/22/2019 12:20 PM, Lorenzo Bianconi wrote:
> >> On Tue, 2019-05-21 at 14:59 +0200, Lorenzo Bianconi wrote:
> >>> Currently if we add a filter to the ingress qdisc (e.g matchall) the
> >>> filter data are reported even in the egress path. The issue can be
> >>> triggered with the following reproducer:
> >=20
> > [...]
> >=20
> >>> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> >>> index 0bac926b46c7..1825347fed3a 100644
> >>> --- a/net/sched/sch_ingress.c
> >>> +++ b/net/sched/sch_ingress.c
> >>> @@ -31,7 +31,7 @@ static struct Qdisc *ingress_leaf(struct Qdisc *sch=
, unsigned long arg)
> >>> =20
> >>>  static unsigned long ingress_find(struct Qdisc *sch, u32 classid)
> >>>  {
> >>> -	return TC_H_MIN(classid) + 1;
> >>> +	return TC_H_MIN(classid);
> >>
> >> probably this breaks a command that was wrong before, but it's worth
> >> mentioning. Because of the above hunk, the following command
> >>
> >> # tc qdisc add dev test0 ingress
> >> # tc filter add dev test0 parent ffff:fff1 matchall action drop
> >> # tc filter add dev test0 parent ffff: matchall action continue
> >>
> >> gave no errors, and dropped packets on unpatched kernel. With this pat=
ch,
> >> the kernel refuses to add the 'matchall' rules (and because of that,
> >> traffic passes).
> >>
> >> running TDC, it seems that a patched kernel does not pass anymore
> >> some of the test cases belonging to the 'filter' category:
> >>
> >> # ./tdc.py -e 901f
> >> Test 901f: Add fw filter with prio at 32-bit maxixum
> >> exit: 2
> >> exit: 0
> >> RTNETLINK answers: Invalid argument
> >> We have an error talking to the kernel, -1
> >>
> >> All test results:
> >> 1..1
> >> not ok 1 901f - Add fw filter with prio at 32-bit maxixum
> >>         Command exited with 2, expected 0
> >> RTNETLINK answers: Invalid argument
> >> We have an error talking to the kernel, -1
> >>
> >> (the same test is passing on a unpatched kernel)
> >>
> >> Do you think it's worth fixing those test cases too?
> >>
> >> thanks a lot!
> >> --=20
> >> davide
> >=20
> > Hi Davide,
> >=20
> > thx to point this out. Applying this patch the ingress qdisc has the sa=
me
> > behaviour of clsact one.
> >=20
> > $tc qdisc add dev lo clsact
> > $tc filter add dev lo parent ffff:fff1 matchall action drop
> > Error: Specified class doesn't exist.
> > We have an error talking to the kernel, -1
> > $tc filter add dev lo parent ffff:fff2 matchall action drop
> >=20
> > $tc qdisc add dev lo ingress
> > $tc filter add dev lo parent ffff:fff2 matchall action drop
> >=20
> > is it acceptable? If so I can fix the tests as well
> > If not, is there another way to verify the filter is for the ingress pa=
th if
> > parent identifier is not constant? (ingress_find() reports the TC_H_MIN=
 of
> > parent identifier)
>=20
> As far as I know this would break sch_ingress users ... For sch_ingress
> any minor should be accepted. For sch_clsact, only 0xFFF2U and 0xFFF3U
> are accepted, so it can be extended in future if needed. For old sch_ingr=
ess
> that ship has sailed, which is why sch_clsact was needed in order to have
> such selectors, see also 1f211a1b929c ("net, sched: add clsact qdisc").
> Meaning, minors for sch_ingress are a superset of sch_clsact and not
> compatible in that sense. If you adapt sch_ingress to the same behavior
> as sch_clsact, things might break indeed as Davide pointed out.

Hi Daniel,

right, thx the clarification. So for the moment let's just drop this patch
and I will investigate if it is possible to not dump ingress info on egress
path in a different way.

Regards,
Lorenzo

>=20
> > Regards,
> > Lorenzo
> >=20
> >>
> >>>  }
> >>> =20
> >>>  static unsigned long ingress_bind_filter(struct Qdisc *sch,
> >>> @@ -53,7 +53,12 @@ static struct tcf_block *ingress_tcf_block(struct =
Qdisc *sch, unsigned long cl,
> >>>  {
> >>>  	struct ingress_sched_data *q =3D qdisc_priv(sch);
> >>> =20
> >>> -	return q->block;
> >>> +	switch (cl) {
> >>> +	case TC_H_MIN(TC_H_MIN_INGRESS):
> >>> +		return q->block;
> >>> +	default:
> >>> +		return NULL;
> >>> +	}
> >>>  }
> >>> =20
> >>>  static void clsact_chain_head_change(struct tcf_proto *tp_head, void=
 *priv)
> >>
> >>
>=20

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXOU81gAKCRA6cBh0uS2t
rJlfAP9f/9gcMP6vVwcEcMjfJzShvCqrPnp4rerf/+uLCwbFFwEA+CF7Lzditraa
42Z/fa945sp1m18Edc59mkhuq7wG9QE=
=LPNK
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
