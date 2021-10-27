Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E303943CDE4
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242768AbhJ0Pti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233252AbhJ0Pth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:49:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6D9260F5A;
        Wed, 27 Oct 2021 15:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635349632;
        bh=zrs+3Ie1XvL5tmAO4YGEuxfoVuRJ/WswP29+77Hq8OE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Eh67WkL9bppVXtPeQ++SOTNomdHwFyH5KcnsV967X63nzu/UbPID1ccRCBKdS1SmB
         AHbkhhPDLRrH9AtUaNMXz3zLDG/bT3ubAxtexKUhLvltfVpSJjazIceGLLQUHDezRm
         ck+JokbgHhs74DDoexCDMsW0USmJNFxI3HIyYx4aXL0+ZwdqszVx9WgKf1rNtWHuaa
         VFPjxi6Gd2x92If6UNELMWb4Cn9pKK12Ea1l0iHslzUHzL6brD1Rz3IZARcrxIR6P9
         tv+mEg7mkoF704nl0lCteHeaM9M9FmQhNDiO8GuQ9ueZAAHTaqezRCLr7HPNWtRyQK
         3KLUGamZAbk/g==
Date:   Wed, 27 Oct 2021 08:47:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer
 space when data was already sent"
Message-ID: <20211027084710.1f4a4ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <06ae0731-0b9b-a70d-6479-de6fe691e25d@linux.ibm.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
        <20211027085208.16048-2-tonylu@linux.alibaba.com>
        <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
        <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <06ae0731-0b9b-a70d-6479-de6fe691e25d@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 17:38:27 +0200 Karsten Graul wrote:
> What we found out was that applications called sendmsg() with large data
> buffers using blocking sockets. This led to the described situation, were=
 the
> solution was to early return to user space even if not all data were sent=
 yet.
> Userspace applications should not have a problem with the fact that sendm=
sg()
> returns a smaller byte count than requested.
>=20
> Reverting this patch would bring back the stalled connection problem.

I'm not sure. The man page for send says:

       When the message does not fit into  the  send  buffer  of  the  sock=
et,
       send()  normally blocks, unless the socket has been placed in nonblo=
ck=E2=80=90
       ing I/O mode.  In nonblocking mode it would fail with the error  EAG=
AIN
       or  EWOULDBLOCK in this case.

dunno if that's required by POSIX or just a best practice.
