Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3763226199
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 12:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfEVKUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 06:20:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44971 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbfEVKUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 06:20:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id w13so1616043wru.11
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 03:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PT7scLgi4rOTE4CkJS6hF9kBal+Np5uh5KOr7GqkdNI=;
        b=D8OtjW1xdboeHSXCL/gOljJsXZeiUQ+YQ05SJ7SfvRgRbWeGN8FjSGvfex3aVwgbeN
         NOIFoAOlIrG8J5Y+BlBO+7nanRXI1wOHMS4D85icSFELrCgHsliT/5rOAgXrZfTAZMyI
         PcXuiWg9LTgb1EMK9wJBHQBFN40HnUSnpfDlCnvzKx/8cMD0h7VWHJoDZ9nNH36ISVk5
         6rw+pvo9KcdIjL8nJQ3I83MrNgmLUjkFViWuxt9UuSqvbk+bXTeouoCq0yYqSNoF52So
         DBNdEo4vYG0LmnSZHjaOb61OITfpTugsZKRiBji8Js1b+fiaELTnFQ3eTwrNYWU+uzdR
         OvUQ==
X-Gm-Message-State: APjAAAWRDfVp7H2sdjcCuOsuzAazQjchFVW9vImSqb1Y2oJGpD4PvD3S
        LZgvB/ykl23e8lTaIeacRe0GAttE15c=
X-Google-Smtp-Source: APXvYqyb5IryJpkKonAtl+3IMOUKai5+cthQksJnLgWGIWA6AIc0Qysepj2yPIVtjpjzaCWcxsjTgA==
X-Received: by 2002:adf:eb02:: with SMTP id s2mr48216319wrn.29.1558520417177;
        Wed, 22 May 2019 03:20:17 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id g11sm20074355wrx.62.2019.05.22.03.20.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 03:20:16 -0700 (PDT)
Date:   Wed, 22 May 2019 12:20:14 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us
Subject: Re: [PATCH net] net: sched: sch_ingress: do not report ingress
 filter info in egress path
Message-ID: <20190522102013.GA3467@localhost.localdomain>
References: <cover.1558442828.git.lorenzo.bianconi@redhat.com>
 <738244fd5863e6228275ee8f71e81d6baafca243.1558442828.git.lorenzo.bianconi@redhat.com>
 <365843b0b605d272a7ec3cf4ebf4cb5ea70b42e6.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <365843b0b605d272a7ec3cf4ebf4cb5ea70b42e6.camel@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 2019-05-21 at 14:59 +0200, Lorenzo Bianconi wrote:
> > Currently if we add a filter to the ingress qdisc (e.g matchall) the
> > filter data are reported even in the egress path. The issue can be
> > triggered with the following reproducer:
> >=20

[...]

> > diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> > index 0bac926b46c7..1825347fed3a 100644
> > --- a/net/sched/sch_ingress.c
> > +++ b/net/sched/sch_ingress.c
> > @@ -31,7 +31,7 @@ static struct Qdisc *ingress_leaf(struct Qdisc *sch, =
unsigned long arg)
> > =20
> >  static unsigned long ingress_find(struct Qdisc *sch, u32 classid)
> >  {
> > -	return TC_H_MIN(classid) + 1;
> > +	return TC_H_MIN(classid);
>=20
> probably this breaks a command that was wrong before, but it's worth
> mentioning. Because of the above hunk, the following command
>=20
> # tc qdisc add dev test0 ingress
> # tc filter add dev test0 parent ffff:fff1 matchall action drop
> # tc filter add dev test0 parent ffff: matchall action continue
>=20
> gave no errors, and dropped packets on unpatched kernel. With this patch,
> the kernel refuses to add the 'matchall' rules (and because of that,
> traffic passes).
>=20
> running TDC, it seems that a patched kernel does not pass anymore
> some of the test cases belonging to the 'filter' category:
>=20
> # ./tdc.py -e 901f
> Test 901f: Add fw filter with prio at 32-bit maxixum
> exit: 2
> exit: 0
> RTNETLINK answers: Invalid argument
> We have an error talking to the kernel, -1
>=20
> All test results:
> 1..1
> not ok 1 901f - Add fw filter with prio at 32-bit maxixum
>         Command exited with 2, expected 0
> RTNETLINK answers: Invalid argument
> We have an error talking to the kernel, -1
>=20
> (the same test is passing on a unpatched kernel)
>=20
> Do you think it's worth fixing those test cases too?
>=20
> thanks a lot!
> --=20
> davide

Hi Davide,

thx to point this out. Applying this patch the ingress qdisc has the same
behaviour of clsact one.

$tc qdisc add dev lo clsact
$tc filter add dev lo parent ffff:fff1 matchall action drop
Error: Specified class doesn't exist.
We have an error talking to the kernel, -1
$tc filter add dev lo parent ffff:fff2 matchall action drop

$tc qdisc add dev lo ingress
$tc filter add dev lo parent ffff:fff2 matchall action drop

is it acceptable? If so I can fix the tests as well
If not, is there another way to verify the filter is for the ingress path if
parent identifier is not constant? (ingress_find() reports the TC_H_MIN of
parent identifier)

Regards,
Lorenzo

>=20
> >  }
> > =20
> >  static unsigned long ingress_bind_filter(struct Qdisc *sch,
> > @@ -53,7 +53,12 @@ static struct tcf_block *ingress_tcf_block(struct Qd=
isc *sch, unsigned long cl,
> >  {
> >  	struct ingress_sched_data *q =3D qdisc_priv(sch);
> > =20
> > -	return q->block;
> > +	switch (cl) {
> > +	case TC_H_MIN(TC_H_MIN_INGRESS):
> > +		return q->block;
> > +	default:
> > +		return NULL;
> > +	}
> >  }
> > =20
> >  static void clsact_chain_head_change(struct tcf_proto *tp_head, void *=
priv)
>=20
>=20

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXOUiWAAKCRA6cBh0uS2t
rM20AQDxW/9Q9bMVDSGdGNFSejkhO+UUtxBOZ1K960+AnysC+AEA+vaxHz2/r1fD
Y7dg3z1Fm2leNaXq/xwZ9M66E21vNgM=
=BozJ
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
