Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5474C186934
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 11:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbgCPKfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 06:35:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40563 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730582AbgCPKfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 06:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584354932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rxa5ZQUiWPk0xLoE7r0pviacnRX8yq/R/jdIfcniPtQ=;
        b=heFrLMeYY/ea1AGeKz4kSR3SGfTm3rMi4kYahE1j6YYnydpfKr6bNTsK4mx27auo+5KvIX
        yTF0sQeqOiZukqoghMj4XHqC2nuXdt+YaeS+//5gb8uovYCeOe1TQqs8Jfsqg5B3WdOcK1
        ERm8TNj5DtL2quY2nX/bjY8hOA8ms+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-2iu4k6TKPfCBluwbLdf-gA-1; Mon, 16 Mar 2020 06:35:26 -0400
X-MC-Unique: 2iu4k6TKPfCBluwbLdf-gA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C39F3107ACC4;
        Mon, 16 Mar 2020 10:35:24 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 825F35D9E2;
        Mon, 16 Mar 2020 10:35:18 +0000 (UTC)
Date:   Mon, 16 Mar 2020 11:35:15 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, <mhabets@solarflare.com>,
        <cmclachlan@solarflare.com>, <ilias.apalodimas@linaro.org>,
        <lorenzo@kernel.org>, <sameehj@amazon.com>, brouer@redhat.com
Subject: Re: [PATCH net-next] sfc: fix XDP-redirect in this driver
Message-ID: <20200316113515.16f7e243@carbon>
In-Reply-To: <98fd3c0c-225b-d64c-a64f-ca497205d4ce@solarflare.com>
References: <158410589474.499645.16292046086222118891.stgit@firesoul>
        <20200316.014927.1864775444299469362.davem@davemloft.net>
        <98fd3c0c-225b-d64c-a64f-ca497205d4ce@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 10:10:01 +0000
Edward Cree <ecree@solarflare.com> wrote:

> On 16/03/2020 08:49, David Miller wrote:
> > Solarflare folks, please review. =20
>
> This looks like a correct implementation of what it purports to do, so
> Acked-by: Edward Cree <ecree@solarflare.com>

Thanks for the review!

> It did take me some digging to understand _why_ it was needed though;
> =C2=A0Jesper, is there any documentation of the tailroom requirement?=C2=
=A0 It
> =C2=A0doesn't seem to be mentioned anywhere I could find.

I admit that is is poorly documented.  It is a requirement as both
cpumap and veth have a dependency when they process the redirected
packet.  We/I also need to update the doc on one page per packet
requirement, as it is (in-practice) no longer true.

I'm noticing these bugs, because I'm working on a patchset that add
tailroom extend, and also reserves this 'skb_shared_info' tailroom area.
The real goal is to later add XDP multi-buffer support, using this
'skb_shared_info' tailroom area, as desc here[2]

[2] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-m=
ulti-buffer01-design.org

> (Is there even any up-to-date doc of the XDP driver interface?=C2=A0 The
> =C2=A0one at [1] looks a bit stale...)
> -Ed
>=20
> [1]: https://prototype-kernel.readthedocs.io/en/latest/networking/XDP/des=
ign/requirements.html

This is my old and out-dated documentation. I didn't know people were
still referring to this.  I does score quite high on Google, so I
guess, that I really need to update this documentation.  (It was my
plan that this would be merged into kernel tree, but I can see it have
been bit-rotting for too long).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

