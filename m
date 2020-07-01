Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E4D2112F3
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 20:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgGASnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 14:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgGASnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 14:43:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A191920748;
        Wed,  1 Jul 2020 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593629018;
        bh=AheonDyc1SUNlyr/mAtc9oDOgXtIJLRjOmJ1noRfKjo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XCapj1yTaxQv1jvNS9aEtGh3UkQUzKdNvK2gslvoMwHX0dZCpxW3XvF9YB+FkTi0C
         VhvEpByz5YCT2sfKDOd2aysWtoiqW9Ds7cY761520zKAnTbKd6cv3EUegW18bmsWK6
         kJ8K+Yn5H7jBNHg5JEli3BFIA1Gm74KjkgJvn2tA=
Date:   Wed, 1 Jul 2020 11:43:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <mhabets@solarflare.com>, <linux-net-drivers@solarflare.com>
Subject: Re: [PATCH net-next] sfc: remove udp_tnl_has_port
Message-ID: <20200701114336.62b57cc4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <29d3564b-6bcc-9df7-f6a9-3d3867390e15@solarflare.com>
References: <20200630225038.1190589-1-kuba@kernel.org>
        <29d3564b-6bcc-9df7-f6a9-3d3867390e15@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 15:32:03 +0100 Edward Cree wrote:
> On 30/06/2020 23:50, Jakub Kicinski wrote:
> > Nothing seems to have ever been calling this.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org> =20
> That was intended to be used by encap offloads (TX csum and TSO), which
> =C2=A0we only recently realised we hadn't upstreamed the rest of; the
> =C2=A0udp_tnl_has_port method would be called from our ndo_features_check=
().
> I'll try to get to upstreaming that support after ef100 is in, hopefully
> =C2=A0within this cycle, but if you don't want this dead code lying aroun=
d in
> =C2=A0the meantime then have an
> Acked-by: Edward Cree <ecree@solarflare.com>
> =C2=A0and I can revert it when I add the code that calls it.
> (And don't worry, ef100 doesn't use ugly port-based offloads; it does
> =C2=A0proper CHECKSUM_PARTIAL and GSO_PARTIAL, so it won't have this stuf=
f.)

There's a number of drivers which try to match the UDP ports. That
seems fragile to me. Is it actually required for HW to operate
correctly?=20

Aren't the ports per ns in the kernel? There's no guarantee that some
other netns won't send a TSO skb and whatever other UDP encap.
