Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683092A1131
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgJ3Ww6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgJ3Ww5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 18:52:57 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2087820825;
        Fri, 30 Oct 2020 22:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604098376;
        bh=9P4KNw5xcpR7x5NeyeVpmMxXUCRky89EVfiUKIGWGD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N5VckLQqI69V90I5Rl7wMCdNBjp4oTlX5wKfESzVIrRTm18/0b9CpaLH9+3zvmQ6+
         6phepvSV9oJfydsU9H0WbrlPCTDQ974j/u2ylAYXRivKgymVAJCX9DiYIJjwSPg+zO
         QlxIcZn1rfSJQ7ZoTV9kcf+VLGcWa+SMTI3Der4Y=
Date:   Fri, 30 Oct 2020 15:52:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Motiejus =?UTF-8?B?SmFrxaF0eXM=?= <desired.mta@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-doc@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Documentation: tproxy: more gentle intro
Message-ID: <20201030155255.6599e46a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027120620.476066-1-desired.mta@gmail.com>
References: <20201027120620.476066-1-desired.mta@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 14:06:20 +0200 Motiejus Jak=C5=A1tys wrote:
> Clarify tproxy odcumentation, so it's easier to read/understand without
> a-priori in-kernel transparent proxying knowledge:
>=20
> - re-shuffle the sections, as the "router" section is easier to
>   understand when getting started.
> - add a link to HAProxy page. This is where I learned most about what
>   tproxy is, so I believe it is reasonable to include.
> - removed a reference to linux 2.2.
>=20
> Plus Sphinx formatting/cosmetic changes.
>=20
> Signed-off-by: Motiejus Jak=C5=A1tys <desired.mta@gmail.com>
> ---
>  Documentation/networking/tproxy.rst | 155 +++++++++++++++-------------
>  1 file changed, 83 insertions(+), 72 deletions(-)
>=20
> diff --git a/Documentation/networking/tproxy.rst b/Documentation/networki=
ng/tproxy.rst
> index 00dc3a1a66b4..0f43159046fb 100644
> --- a/Documentation/networking/tproxy.rst
> +++ b/Documentation/networking/tproxy.rst
> @@ -1,42 +1,77 @@
>  .. SPDX-License-Identifier: GPL-2.0
> =20
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> -Transparent proxy support
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +Transparent proxy (TPROXY)
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> =20
> -This feature adds Linux 2.2-like transparent proxy support to current ke=
rnels.
> -To use it, enable the socket match and the TPROXY target in your kernel =
config.
> -You will need policy routing too, so be sure to enable that as well.
> +TPROXY enables forwarding and intercepting packets that were destined
> +for other destination IPs, without using NAT chain or REDIRECT targets.

"destined for other destination" does not sound good.

Better say endpoint than IPs, IP is the name of a protocol.

> -From Linux 4.18 transparent proxy support is also available in nf_tables.
> +Redirecting traffic
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> -1. Making non-local sockets work
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +TPROXY is often used to "intercept" traffic on a router. This is usually=
 done
> +with the iptables ``REDIRECT`` target, however, there are serious limita=
tions:
> +it modifies the packets to change the destination address -- which might=
 not be
> +acceptable in certain situations, e.g.:
> +- UDP: you won't be able to find out the original destination address.
> +- TCP: getting the original destination address is racy.

I don't think this rewrite of the examples helps. Also it doesn't
render right. Please leave the original wording.

> -The idea is that you identify packets with destination address matching =
a local
> -socket on your box, set the packet mark to a certain value::
> +The ``TPROXY`` target provides similar functionality without relying on =
NAT.
> +Simply add rules like this to the iptables ruleset above:

There are no rules "above" after the reordering.

> -    # iptables -t mangle -N DIVERT
> -    # iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
> -    # iptables -t mangle -A DIVERT -j MARK --set-mark 1
> -    # iptables -t mangle -A DIVERT -j ACCEPT
> +.. code-block:: sh

> +To use tproxy you'll need to have the following modules compiled for ipt=
ables:
> =20
> -As an example implementation, tcprdr is available here:
> -https://git.breakpoint.cc/cgit/fw/tcprdr.git/
> -This tool is written by Florian Westphal and it was used for testing dur=
ing the
> -nf_tables implementation.
> + - ``NETFILTER_XT_MATCH_SOCKET``
> + - ``NETFILTER_XT_TARGET_TPROXY``
> =20
> -3. Iptables and nf_tables extensions
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +For nf_tables:
> =20
> -To use tproxy you'll need to have the following modules compiled for ipt=
ables:
> + - ``NFT_TPROXY``
> + - ``NFT_SOCKET``

What happened to the mention of policy routing in the kernel support?

> - - NETFILTER_XT_MATCH_SOCKET
> - - NETFILTER_XT_TARGET_TPROXY
> +Application support
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

> +HAproxy
> +-------
> =20
> -Squid 3.HEAD has support built-in. To use it, pass
> -'--enable-linux-netfilter' to configure and set the 'tproxy' option on
> -the HTTP listener you redirect traffic to with the TPROXY iptables
> -target.
> +Documented in `Haproxy blog`_.

Can we add some words here, beyond just a link?

> -For more information please consult the following page on the Squid
> -wiki: http://wiki.squid-cache.org/Features/Tproxy4
> +.. _`Squid wiki`: http://wiki.squid-cache.org/Features/Tproxy4
> +.. _`HAproxy blog`: https://www.haproxy.com/blog/howto-transparent-proxy=
ing-and-binding-with-haproxy-and-aloha-load-balancer/

Overall I can see how the document can be hard to grasp, but I'm not
sure the reordering is an improvement. In the doc as is the first
section describes simple local receive of traffic not destined for
local host. Second describes TPROXY redirect.=20

Perhaps their headings or content could be clarified but reorder
doesn't make much sense IMHO.
