Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A37C45F617
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbhKZU4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:56:05 -0500
Received: from sender4-op-o13.zoho.com ([136.143.188.13]:17348 "EHLO
        sender4-op-o13.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhKZUyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 15:54:04 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637931451; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=fgI3YSi5v83dF9kYhFY1vM1HjebT6UT5/xWxah1DHTvdouH0f6I5RwjmK7ZVmIx4EbmLK0kFK0xraDWbb6yXAgUgmRWHpHC7E+v8to30Ai8gi1rL95knexIrXaz+a1kHS7Aynj0yri6uyrXmaLl47V/tWwnWNxDWExXAUE5PnHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1637931451; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=uUoJmVabYiqmYCRYGKBn/s9kqyNDOLiX94fmlwy2OKg=; 
        b=BFlGZczFmsBLNd8vfXL5ZQjb5K6si/THNIny4pVvZsOC5Sh2aN7qno0XhcaY9t87Pudu2ZYSiQFZ0lm4vg4Bhc2lKePoTmqULcWwY3F0Uj7UKfNUcfjVl5ufm8VgTcs6gK9DagUbrGkHoNJJVToPxuLLp6wTXHEAfoUQ5gLL/is=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1637931451;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Content-Type:Content-Transfer-Encoding:From:Mime-Version:Subject:Date:Message-Id:References:Cc:In-Reply-To:To;
        bh=uUoJmVabYiqmYCRYGKBn/s9kqyNDOLiX94fmlwy2OKg=;
        b=D7uwZ7AJnD/V/uhuNDN8ElIZ1RqIKE28AvTV76Ybdmff3aPNTFs8UmhOFlnYJ+PO
        JebNo99iI64AgWG4Vc3T/aS4UPG31/1hSB+8cqndTFpNTdU8Sp7JnkF6TQKh1KTwE7i
        rx8wP1icOh0l9IaurSOuXKqJXQm/OfoucA+tuu8o=
Received: from [10.10.9.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1637931449553968.1568334094624; Fri, 26 Nov 2021 04:57:29 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH net 3/3] net: dsa: rtl8365mb: set RGMII RX delay in steps of 0.3 ns
Date:   Fri, 26 Nov 2021 15:57:23 +0300
Message-Id: <8F46AA41-9B98-4EFA-AB2E-03990632D75C@arinc9.com>
References: <20211126125007.1319946-3-alvin@pqrs.dk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        =?utf-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
In-Reply-To: <20211126125007.1319946-3-alvin@pqrs.dk>
To:     =?utf-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
X-Mailer: iPhone Mail (17H35)
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 26 Nov 2021, at 15:50, Alvin =C5=A0ipraga <alvin@pqrs.dk> wrote:
>=20
> =EF=BB=BFFrom: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
>=20
> A contact at Realtek has clarified what exactly the units of RGMII RX
> delay are. The answer is that the unit of RX delay is "about 0.3 ns".
> Take this into account when parsing rx-internal-delay-ps by
> approximating the closest step value. Delays of more than 2.1 ns are
> rejected.
>=20
> This obviously contradicts the previous assumption in the driver that a
> step value of 4 was "about 2 ns", but Realtek also points out that it is
> easy to find more than one RX delay step value which makes RGMII work.
>=20
> Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for R=
TL8365MB-VC")
> Cc: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>

Acked-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>=

