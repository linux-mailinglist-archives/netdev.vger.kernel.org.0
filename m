Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B98B26986E
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgINV5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgINV5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:57:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8614C208DB;
        Mon, 14 Sep 2020 21:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600120619;
        bh=sShWXFA3jCWBDUm2Misg76zY77Tb2MyhrZ7JPIPcdw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g8CXVatVhVYmGBg9eENXTg3Hl/uN57qfpldAW+PyhHlsFCDOPHmW3c/9kq4O4cgoG
         MT3CB/jc2vs1jHRG6+AKD5fhN12jV7QIOakqNJG40dkcAwRw01OC8kI5qvMxZQgf/a
         XAfw/1KdHdWIg01UgfJMCnlNDRN+uY1M1U93N0a0=
Date:   Mon, 14 Sep 2020 14:56:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] ionic: dynamic interrupt moderation
Message-ID: <20200914145657.26fd2946@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <275d2c83-d85d-1b60-cd11-8b5760e67ce0@pensando.io>
References: <20200913212813.46736-1-snelson@pensando.io>
        <20200914141041.570370fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <275d2c83-d85d-1b60-cd11-8b5760e67ce0@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 14:50:19 -0700 Shannon Nelson wrote:
> >> +	struct ionic_qcq *qcq =3D container_of(dim, struct ionic_qcq, dim);
> >> +	u32 new_coal;
> >> +
> >> +	new_coal =3D ionic_coal_usec_to_hw(qcq->q.lif->ionic, cur_moder.usec=
);
> >> +	qcq->intr.dim_coal_hw =3D new_coal ? new_coal : 1;
> >> +	dim->state =3D DIM_START_MEASURE;
> >> +} =20
> > Interesting, it seem that you don't actually talk to FW to update
> > the parameters? DIM causes noticeable increase in scheduler pressure
> > with those work entries it posts. I'd be tempted to not use a work
> > entry if you don't have to sleep. =20
>=20
> net_dim() assumes a valid work_struct in struct dim, and would likely=20
> get annoyed if it wasn't set up.=C2=A0 I suppose we could teach net_dim()=
 to=20
> look into the work_struct to verify that .func is non-NULL before=20
> calling schedule_work(), but that almost feels like cheating.

Yeah, no strong feelings, DIM optimizations are probably best left to
someone with easy access to production workloads. Feel free to add my
ack on v2 with the nit above addressed.
