Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D27FD080
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKNVnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:43:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20639 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726628AbfKNVnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 16:43:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573767803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDfmOH9PNi4Wxo2sjghLF/7WTkfo/Nxl8i+LNOZea8g=;
        b=MhWW02UaLZjm1K4aZ+Gxy9J9KuCqrJbA01ncoJbFjH3HLCL2rQvaSbwREHLr5XCT+uQmUU
        Gp8kPfJ46Hc1aSWW4kao6V83zasmGC8pKT7LJdm5wLY8kBkZPtLweruCIHcAWHU3DcMbNw
        Y5PMvG1RF6+VpD5Sd2TQlDaQSxDmew8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-JbhJwrGeNyqjlyLwt10Vug-1; Thu, 14 Nov 2019 16:43:22 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C8641802CE2;
        Thu, 14 Nov 2019 21:43:20 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 956F2A7D2;
        Thu, 14 Nov 2019 21:43:10 +0000 (UTC)
Date:   Thu, 14 Nov 2019 22:43:09 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, matteo.croce@redhat.com,
        brouer@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for non-coherent devices
Message-ID: <20191114224309.649dfacb@carbon>
In-Reply-To: <ECC7645D-082A-4590-9339-C45949E10C4D@gmail.com>
References: <cover.1573383212.git.lorenzo@kernel.org>
        <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
        <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
        <20191114185326.GA43048@PC192.168.49.172>
        <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
        <20191114204227.GA43707@PC192.168.49.172>
        <ECC7645D-082A-4590-9339-C45949E10C4D@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: JbhJwrGeNyqjlyLwt10Vug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 13:04:26 -0800
"Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:

> On 14 Nov 2019, at 12:42, Ilias Apalodimas wrote:
>=20
> > Hi Jonathan,
> >
> > On Thu, Nov 14, 2019 at 12:27:40PM -0800, Jonathan Lemon wrote: =20
> >>
> >>
> >> On 14 Nov 2019, at 10:53, Ilias Apalodimas wrote:
> >> =20
> >>> [...] =20
> >>>>> index 2cbcdbdec254..defbfd90ab46 100644
> >>>>> --- a/include/net/page_pool.h
> >>>>> +++ b/include/net/page_pool.h
> >>>>> @@ -65,6 +65,9 @@ struct page_pool_params {
> >>>>>  =09int=09=09nid;  /* Numa node id to allocate from pages from */
> >>>>>  =09struct device=09*dev; /* device, for DMA pre-mapping purposes *=
/
> >>>>>  =09enum dma_data_direction dma_dir; /* DMA mapping direction */
> >>>>> +=09unsigned int=09max_len; /* max DMA sync memory size */
> >>>>> +=09unsigned int=09offset;  /* DMA addr offset */
> >>>>> +=09u8 sync;
> >>>>>  }; =20
> >>>>
> >>>> How about using PP_FLAG_DMA_SYNC instead of another flag word?
> >>>> (then it can also be gated on having DMA_MAP enabled) =20
> >>>
> >>> You mean instead of the u8?
> >>> As you pointed out on your V2 comment of the mail, some cards don't=
=20
> >>> sync back to device.
> >>>
> >>> As the API tries to be generic a u8 was choosen instead of a flag
> >>> to cover these use cases. So in time we'll change the semantics of
> >>> this to 'always sync', 'dont sync if it's an skb-only queue' etc.
> >>>
> >>> The first case Lorenzo covered is sync the required len only instead=
=20
> >>> of the full buffer =20
> >>
> >> Yes, I meant instead of:
> >> +=09=09.sync =3D 1,
> >>
> >> Something like:
> >>         .flags =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC
> >>

I actually agree and think we could use a flag. I suggest
PP_FLAG_DMA_SYNC_DEV to indicate that this DMA-sync-for-device.

Ilias notice that the change I requested to Lorenzo, that dma_sync_size
default value is 0xFFFFFFFF (-1).  That makes dma_sync_size=3D=3D0 a valid
value, which you can use in the cases, where you know that nobody have
written into the data-area.  This allow us to selectively choose it for
these cases.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

