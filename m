Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EADC21E12D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgGMUJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgGMUJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 16:09:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A79F420674;
        Mon, 13 Jul 2020 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594670971;
        bh=E5YuXc6lCU69v6BjaGW0PR13hJFqpjWt4C8mhywt3cw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lhchefvFMjtkwhw9ZKQHTGBJZpEWbaA6s2QgYVlO3zCbNRCbxybIIjwitwbHZw1Zr
         Qy4Y/vilDCIl7EYxGZaYdGkiMNqEiDqykaZwkAMM6GZnl1WoOmC0Ky4Gko8XlXBF/z
         2Oy8mGGpVknk7tyLjt/rY5AjoTAgsHI1LMyq+NBI=
Date:   Mon, 13 Jul 2020 13:09:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        mkubecek@suse.cz, davem@davemloft.net
Subject: Re: [PATCH net-next 0/3] net: Preserve netdev_ops equality tests
Message-ID: <20200713130929.0fc74fa1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200712221625.287763-1-f.fainelli@gmail.com>
References: <20200712221625.287763-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jul 2020 15:16:22 -0700 Florian Fainelli wrote:
> Hi David, Jakub,
>=20
> This patch series addresses a long standing with no known impact today
> with the overloading of netdev_ops done by the DSA layer.

Do you plan to make use of this comparison? Or trying to protect the
MAC driver from misbehaving because it's unaware the DSA may replace
its ops? For non-DSA experts I think it may be worth stating :)

> First we introduce a ndo_equal netdev_ops function pointer, then we have
> DSA utilize it, and finally all in tree users are converted to using
> either netdev_ops_equal() or __netdev_ops_equal() (for const struct
> net_device reference).

The experience with TCP ULPs made me dislike hijacking ops :(=20
Maybe it's just my limited capability to comprehend complex systems
but the moment there is more than one entity that tries to insert
itself as a proxy, ordering etc. gets quite hairy.. Perhaps we=20
have some well understood rules for ndo replacement but if that's not
the case I prefer the interception to be done explicitly in the caller.
(e.g. add separate dsa_ops to struct net_device and call that prior to/
/instead of calling the ndo).

At the very least I'd think it's better to create an explicit hierarchy
of the ops by linking them (add "const struct net_device_ops *base_ops"
to ndos) rather than one-off callback for comparisons.

That's just my 2=C2=A2..
