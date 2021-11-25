Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED6145D511
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351305AbhKYHIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:08:35 -0500
Received: from vulcan.natalenko.name ([104.207.131.136]:42414 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243105AbhKYHGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:06:34 -0500
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 256F0CBCA7C;
        Thu, 25 Nov 2021 08:03:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1637823800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IXUCekOknOdqWi3NoejcSY8b4+cDF5XXrBMYpnYJrZ0=;
        b=NGr7TZuhUl05DV/Y5Pri92WOScPJOQSCppojgak7bjONvFsFB+N09CIXZksgoPa9ruC80d
        UxF14o/10PawYTEdY6kUBFtzwqKhjLaC0sl5hEzuy+3gvQDqWd1x+2eDQUCln/SmoIIIgY
        2hDAP6pizNarDFr8T0i2gSCM244d7mw=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, Danielle Ratson <danieller@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net v2] igb: fix netpoll exit with traffic
Date:   Thu, 25 Nov 2021 08:03:18 +0100
Message-ID: <4695060.31r3eYUQgx@natalenko.name>
In-Reply-To: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
References: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On =FAter=FD 23. listopadu 2021 21:40:00 CET Jesse Brandeburg wrote:
> Oleksandr brought a bug report where netpoll causes trace
> messages in the log on igb.
>=20
> Danielle brought this back up as still occuring, so we'll try
> again.
>=20
> [22038.710800] ------------[ cut here ]------------
> [22038.710801] igb_poll+0x0/0x1440 [igb] exceeded budget in poll
> [22038.710802] WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155
> netpoll_poll_dev+0x18a/0x1a0
>=20
> As Alex suggested, change the driver to return work_done at the
> exit of napi_poll, which should be safe to do in this driver
> because it is not polling multiple queues in this single napi
> context (multiple queues attached to one MSI-X vector). Several
> other drivers contain the same simple sequence, so I hope
> this will not create new problems.
>=20
> Fixes: 16eb8815c235 ("igb: Refactor clean_rx_irq to reduce overhead and
> improve performance") Reported-by: Oleksandr Natalenko
> <oleksandr@natalenko.name>
> Reported-by: Danielle Ratson <danieller@nvidia.com>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> COMPILE TESTED ONLY! I have no way to reproduce this even on a machine I
> have with igb. It works fine to load the igb driver and netconsole with
> no errors.
> ---
> v2: simplified patch with an attempt to make it work
> v1: original patch that apparently didn't work
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> b/drivers/net/ethernet/intel/igb/igb_main.c index
> e647cc89c239..5e24b7ce5a92 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -8104,7 +8104,7 @@ static int igb_poll(struct napi_struct *napi, int
> budget) if (likely(napi_complete_done(napi, work_done)))
>  		igb_ring_irq_enable(q_vector);
>=20
> -	return min(work_done, budget - 1);
> +	return work_done;
>  }
>=20
>  /**

This seems to address the issue for me. I do not see a warning after a coup=
le=20
of suspend/resume cycles any more, while previously it occurred after the f=
irst=20
cycle.

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>

Thanks!

=2D-=20
Oleksandr Natalenko (post-factum)


