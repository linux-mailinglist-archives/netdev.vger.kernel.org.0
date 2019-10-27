Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E402EE6330
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 15:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfJ0Onh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 10:43:37 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55447 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfJ0One (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 10:43:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id g24so6812078wmh.5;
        Sun, 27 Oct 2019 07:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K1drSj56NAMifp0a52nujMXEWxvKYc9KCSSsaeobpyU=;
        b=TyzHBKD+Hyl4HO0A4bnaZYaumW+Bj/xP+SRf/Gyzp9LM2IPa0nApKEzMny34zY2nni
         /jZhVQQMkOA6w1fkLsXyCvZ4wSYOTFxaO3AjVsJGJvJkcsO/lzGVgGeQngK/RNc7Egri
         vcK+0EhYd7ZlM1z6inTn6NOxMFHs+Pb3pOBZ6vhw7YSe4PqKmG/frwtLNLcEq6k2+aE9
         jxtFwZ4mg+SL5Ee4EKdIpMQC0OuOLgcrxmGnPBP4d4E92oNWKVi+Puh4M0wCaNJr6lHn
         0Rh0AMSpRQsCmYGBDT4pEtOzApgtfEeCQGkf3x3kQqyZwQ73BtMFIzymjJc/+v70cVZO
         NIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K1drSj56NAMifp0a52nujMXEWxvKYc9KCSSsaeobpyU=;
        b=Y0q8T62VnWU6VKDda6nMPZIIMZZprfgE2JdbFTKovIWUZtEigA7EpJqBesrcS7I3rW
         hUF+rFzdWlRV4RGfHio5XjKyRnNIRNK5HlXqGqq6LmnrHqMj+BSvYaLgsSPhAwSsWxS6
         LT9B0A7lNg2yzrMnkaz8MRnNw8KnMuu3oC/9USg+85pa5nZrYpXFzl82vGYPPvAhiKuq
         mfW3Ou/hb2vphMxV9txqVUgs0F4UbgpBWundDrzRUELXL0p/Tz21MNFOlFt1RiVZoxQk
         eHO0XqjygBOV80lGveY05afKC7XCZ4P8Ejdf6DNVJ5e4BESiJ+cpZY+hOzBd3EcnVdWU
         r8kA==
X-Gm-Message-State: APjAAAXwp4YhG/9Ax3NTvDFWbXVyLZ0fPIwhToU5rINVblJ0Y/Okap2M
        qn25m32MRTQTqIjND8vs73E=
X-Google-Smtp-Source: APXvYqxLw4bBUvZYDSjjOukhCIcplahm2+ltAyfvlmEEdDvw7ye8qdWpBrNXeBrD9mv/HgOQmciqAg==
X-Received: by 2002:a1c:5f82:: with SMTP id t124mr12409011wmb.114.1572187411930;
        Sun, 27 Oct 2019 07:43:31 -0700 (PDT)
Received: from localhost (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id h124sm1133697wmf.30.2019.10.27.07.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 07:43:31 -0700 (PDT)
Date:   Sun, 27 Oct 2019 09:08:23 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 07/14] vsock: handle buffer_size sockopts in the
 core
Message-ID: <20191027080823.GB4472@stefanha-x1.localdomain>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-8-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <20191023095554.11340-8-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2019 at 11:55:47AM +0200, Stefano Garzarella wrote:
> virtio_transport and vmci_transport handle the buffer_size
> sockopts in a very similar way.
>=20
> In order to support multiple transports, this patch moves this
> handling in the core to allow the user to change the options
> also if the socket is not yet assigned to any transport.
>=20
> This patch also adds the '.notify_buffer_size' callback in the
> 'struct virtio_transport' in order to inform the transport,
> when the buffer_size is changed by the user. It is also useful
> to limit the 'buffer_size' requested (e.g. virtio transports).
>=20
> Acked-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> RFC -> v1:
> - changed .notify_buffer_size return to void (Stefan)
> - documented that .notify_buffer_size is called with sk_lock held (Stefan)
> ---
>  drivers/vhost/vsock.c                   |  7 +-
>  include/linux/virtio_vsock.h            | 15 +----
>  include/net/af_vsock.h                  | 15 ++---
>  net/vmw_vsock/af_vsock.c                | 43 ++++++++++---
>  net/vmw_vsock/hyperv_transport.c        | 36 -----------
>  net/vmw_vsock/virtio_transport.c        |  8 +--
>  net/vmw_vsock/virtio_transport_common.c | 79 ++++-------------------
>  net/vmw_vsock/vmci_transport.c          | 86 +++----------------------
>  net/vmw_vsock/vmci_transport.h          |  3 -
>  9 files changed, 65 insertions(+), 227 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl21UHcACgkQnKSrs4Gr
c8jf5wf6ArMyUiMMsXentQxUSlbUpCtIRf1HllqzAAYdsb4/GngX/TcZHaVU4JYg
vnMxPnYs9IatdJgEmJ2oV7Xemt2KdT67eqeqpeUuvOXzwCFTqx7gmCq0GYXPobTW
5Km+oVwrDxfzrUNVK5ZmeFhOSQuB09zbY1JhuwXTiX+nXOVOBP91Mt3i5wijc6a1
M6W2KtgysSkW1K4tf+8/c12QdNlB5bwL6HX2Tgop6bE+yTFpxmykopRkXonrLSQ7
2Ba02wkFAOakw0f9AlF0xBCJfY8OvHUNPYRvnh5g9OJc9DjvZPl2p2PLTpMv7DLm
XF8KeD/VWkSjA8RIYlUYmzUdVvshGA==
=oEzi
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
