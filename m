Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC382E13A9
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgLWCdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730211AbgLWCam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:30:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 128BA206EC;
        Wed, 23 Dec 2020 02:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690602;
        bh=xj+iTXA2OLJtRA4SqQtsCKFWxLpQpoedBDnznjwDLww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Iam8VpcIzfHIwKPOGXAC6N3o6/eYvO9CsaLwGfCXo//PSbmer31Ti6YW+ROMV6bGg
         iikxjHB3v1iEke0u68s1Nc+v491PfhqegnqIGZGb34ZgmN/kkzWM7PqhxZvcJP6rg6
         z/3496iUeIHYdRzejC1BT1Qi0Mfnad9+e5j9ma6SIj8ikRowQ8yKxC4jgPh+FBu3vF
         n/qoNXdQc2shDE+V8fy7QWo5bukB9s4U87P7symn/NKpWo5f9+86wcm7fbkNsbqjF4
         gOWtetOzB4nblnzTMxbTFoCBPlvoa27chhstFsUi4EUIM265RusOr2jOaVUmMYB/S/
         vbHB5MCfGi0Uw==
Date:   Tue, 22 Dec 2020 18:30:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jeff Dike <jdike@akamai.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] virtio_net: Fix recursive call to cpus_read_lock()
Message-ID: <20201222183001.4e88f959@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e8379ba8-6578-baa0-8a67-1deada809271@redhat.com>
References: <20201222033648.14752-1-jdike@akamai.com>
        <e8379ba8-6578-baa0-8a67-1deada809271@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 11:49:04 +0800 Jason Wang wrote:
> On 2020/12/22 =E4=B8=8A=E5=8D=8811:36, Jeff Dike wrote:
> > virtnet_set_channels can recursively call cpus_read_lock if CONFIG_XPS
> > and CONFIG_HOTPLUG are enabled.
> >
> > The path is:
> >      virtnet_set_channels - calls get_online_cpus(), which is a trivial
> > wrapper around cpus_read_lock()
> >      netif_set_real_num_tx_queues
> >      netif_reset_xps_queues_gt
> >      netif_reset_xps_queues - calls cpus_read_lock()
> >
> > This call chain and potential deadlock happens when the number of TX
> > queues is reduced.
> >
> > This commit the removes netif_set_real_num_[tr]x_queues calls from
> > inside the get/put_online_cpus section, as they don't require that it
> > be held.
> >
> > Signed-off-by: Jeff Dike <jdike@akamai.com>
>=20
> Adding netdev.
>=20
> The patch can go with -net and is needed for -stable.
>=20
> Acked-by: Jason Wang <jasowang@redhat.com>

Thanks, we'll need a repost with netdev CCed to apply it to net,=20
I don't have this one in my inbox or in patchwork.

Jeff please make sure to keep the acks when reposting.

