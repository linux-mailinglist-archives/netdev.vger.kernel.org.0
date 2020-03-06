Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4210817C7DD
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 22:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCFV22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 16:28:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCFV22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 16:28:28 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C25FE206D7;
        Fri,  6 Mar 2020 21:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583530108;
        bh=O2etK/SY8vfFXaEqDy/bIMBEAzjmTE2D2rT0cjeLSjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qlXxo4vTvWDKcOGgknZgNGTobUzFFW0Nqi6pvUdNPDfGtPrP1gfozJIq7fVYIFFyW
         uAOG53nQ1zogpBxTfxWdpss31OB7iw68ZkDoQzMRaT3srZ/ZHRSSi1mJWc50ssUepy
         q09BXDKmZalnJZeTKx2GqkrZsaP3fVBtP/Kukfsw=
Date:   Fri, 6 Mar 2020 13:28:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v3 net-next 7/8] ionic: add support for device id 0x1004
Message-ID: <20200306132825.2568127a@kicinski-fedora-PC1C0HJN>
In-Reply-To: <5ac3562b-47b1-a684-c7f2-61da1a233859@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
        <20200305052319.14682-8-snelson@pensando.io>
        <20200305140322.2dc86db0@kicinski-fedora-PC1C0HJN>
        <d9df0828-91d6-9089-e1b4-d82c6479d44c@pensando.io>
        <20200305171834.6c52b5e9@kicinski-fedora-PC1C0HJN>
        <3b85a630-8387-2dc6-2f8c-8543102d8572@pensando.io>
        <20200306102009.0817bb06@kicinski-fedora-PC1C0HJN>
        <5ac3562b-47b1-a684-c7f2-61da1a233859@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Mar 2020 12:32:51 -0800 Shannon Nelson wrote:
> >> However, this device id does exist on some of the DSC configurations,
> >> and I'd prefer to explicitly acknowledge its existence in the driver a=
nd
> >> perhaps keep better control over it, whether or not it gets used by our
> >> 3rd party tool, rather than leave it as some obscure port for someone =
to
> >> "discover". =20
> > I understand, but disagree. Your driver can certainly bind to that
> > management device but it has to be for the internal use of the kernel.
> > You shouldn't just expose that FW interface right out to user space as
> > a netdev. =20
>=20
> So for now the driver should simply capture and configure the PCI=20
> device, but stop at that point and not setup a netdev.=C2=A0 This would l=
eave=20
> the device available for devlink commands.
>=20
> If that sounds reasonable to you, I'll add it and respin the patchset.

I presume the driver currently creates a devlink instance per PCI
function? (Given we have no real infrastructure in place to combine
them.) It still feels a little strange to have a devlink instance that
doesn't represent any entity user would care about, but a communication
channel. It'd be better if other functions made use of the
communication channel behind the scene. That said AFAIU driver with just
a devlink instance won't allow passing arbitrary commands, so that would
indeed address my biggest concern.

What operations would that devlink instance expose?
