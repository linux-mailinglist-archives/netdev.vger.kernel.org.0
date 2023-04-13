Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED7D6E0CCE
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjDMLiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjDMLiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:38:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9E12136
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681385893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tFynjbvQBmoKGMXvOtx49zJOr/TclRQ15smVVahNzyg=;
        b=KO6gdDm7VQrz+N7we5JsLw/ZETbaI/Cz6ggWnOpFocMb6u4jodWzvIuuJRM0vfQ8Ii5bvT
        IpQQbhOfGudWfuWHkskbJoGMsP22htnt6cr3mdgwc3AHY5cbrEF5ujEkY+oD8hIjJgRWQ6
        jis3I+zNzqG/U6AwmgCn2Kg1gfOyMX4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-ueK6UuehMqK4QZcyVyG_oQ-1; Thu, 13 Apr 2023 07:38:12 -0400
X-MC-Unique: ueK6UuehMqK4QZcyVyG_oQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3e947d81d7dso2119581cf.1
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681385892; x=1683977892;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tFynjbvQBmoKGMXvOtx49zJOr/TclRQ15smVVahNzyg=;
        b=NkygMFdTqk9xYZ1NrHt4/sU8twZGWOcWe8C1zatsCZklSHCSr/3rXLfpHN8YKUbUk/
         vrIJM/J/2/gu7+6Z69g4Qcb9A6IoXMf+sJd5IJ1M9v0ZqMLw3bosiR5IkG1vIdjOOHWB
         gVJxEnNwsvdpIkaiwLCXkag0h/7vku8t14wglyMOcmP6vAisU8Mw9Xw1n417Gs1WRPP6
         BSoP4KikxHaNgHqy1k6Vf5GnbkxrdAahkkgY2276pNHJdqM820HOb03J/uE9TjqKmH22
         wWjFuLSmxfRE7C+G0kePxDy93GtsLaB2WzvetNb+FDSapwju+G56yGx7KuRVmQTWH/0D
         PQFQ==
X-Gm-Message-State: AAQBX9e8/3fbOjNSyyY2yYUNswOximzrC/y8eEp4dDzAUDD5KiT3dNyP
        b60/PmAc8cwfgREPGPtMZ4GQPHm8WofRCYAVlnJuupYPH68zVDuS9cLJaYptAxy0GE59CiJWU2E
        Ffro+yCJMP79a6z8z
X-Received: by 2002:ac8:58d0:0:b0:3e6:707e:d3c2 with SMTP id u16-20020ac858d0000000b003e6707ed3c2mr2618406qta.0.1681385892091;
        Thu, 13 Apr 2023 04:38:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350a4ck3kHlLWdeQKe1CDThZ2MUc4egBZ5LsrQb90FvkTkDplW5rVedR3160hmOcv/WAm5KcP6Q==
X-Received: by 2002:ac8:58d0:0:b0:3e6:707e:d3c2 with SMTP id u16-20020ac858d0000000b003e6707ed3c2mr2618385qta.0.1681385891769;
        Thu, 13 Apr 2023 04:38:11 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-183.dyn.eolo.it. [146.241.232.183])
        by smtp.gmail.com with ESMTPSA id y4-20020ac85244000000b003e6a1bf26a4sm419599qtn.64.2023.04.13.04.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 04:38:11 -0700 (PDT)
Message-ID: <78cea5774de414fa3bcbd6ef02e436ae6b5706c1.camel@redhat.com>
Subject: Re: [PATCH net-next v2 2/3] bnxt: use READ_ONCE/WRITE_ONCE for ring
 indexes
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Jakub Kicinski' <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Date:   Thu, 13 Apr 2023 13:38:08 +0200
In-Reply-To: <f6c134852244441a88eef8c1774bb67f@AcuMS.aculab.com>
References: <20230412015038.674023-1-kuba@kernel.org>
         <20230412015038.674023-3-kuba@kernel.org>
         <f6c134852244441a88eef8c1774bb67f@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-04-12 at 08:15 +0000, David Laight wrote:
> From: Jakub Kicinski
> > Sent: 12 April 2023 02:51
> >=20
> > Eric points out that we should make sure that ring index updates
> > are wrapped in the appropriate READ_ONCE/WRITE_ONCE macros.
> >=20
> ...
> > -static inline u32 bnxt_tx_avail(struct bnxt *bp, struct bnxt_tx_ring_i=
nfo *txr)
> > +static inline u32 bnxt_tx_avail(struct bnxt *bp,
> > +				const struct bnxt_tx_ring_info *txr)
> >  {
> > -	/* Tell compiler to fetch tx indices from memory. */
> > -	barrier();
> > +	u32 used =3D READ_ONCE(txr->tx_prod) - READ_ONCE(txr->tx_cons);
> >=20
> > -	return bp->tx_ring_size -
> > -		((txr->tx_prod - txr->tx_cons) & bp->tx_ring_mask);
> > +	return bp->tx_ring_size - (used & bp->tx_ring_mask);
> >  }
>=20
> Doesn't that function only make sense if only one of
> the ring index can be changing?
> In this case I think this is being used in the transmit path
> so that 'tx_prod' is constant and is either already read
> or need not be read again.
>=20
> Having written a lot of 'ring access' functions over the years
> if the ring size is a power of 2 I'd mask the 'tx_prod' value
> when it is being used rather than on the increment.
> (So the value just wraps modulo 2**32.)
> This tends to make the code safer - especially since the
> 'ring full' and 'ring empty' conditions are different.
>=20
> Also that code is masking with bp->tx_ring_mask, but the
> increments (in hunks I've chopped) use NEXT_TX(prod).
> If that is masking with bp->tx_ring_mask then 'bp' should
> be a parameter.

AFAICS bnxt_tx_avail() is also used in TX interrupt, outside tx path/tx
lock.

I think all the above consideration are more suited for a driver
refactor, while the current patch specifically address potential data
race issues.

Cheers,

Paolo

