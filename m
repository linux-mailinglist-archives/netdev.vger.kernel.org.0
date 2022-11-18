Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7FF62F95A
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiKRPfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242329AbiKRPfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:35:04 -0500
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1A15A6C1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 07:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=bSbtRZDIbn7lpwTb3ByCDbonLiBkZuojB4K05t2aq+8=; b=NmX/pcV4HIEtqg5X46qyiebYsA
        qLHyV6mDFWgNf3HB9J9pxPfq3SWUby1dKPuwkzyX7fhTi4kI++RTba/jpr0pTMHJybdmyn65AZW3f
        8KZgdv/xLRKatAX8Xhg+keIoA4U4HiXUXv4rqhWj2lystoJFV0ZkxJ2UyvGlc5HiUxSHz72TpYlso
        n20Fcb/jGZmAC1b3ySUi3eWXoSlyA/m+vSkpBMLozNihdjfZcT0W0t0ABs8tQwiwOVQp+v+eUICfq
        kPetRM2p+9hKZGxmlU8cDhIyXgaU94t0M8CWEvCzrn1McNQ6AWxkBKKfiERAbsYEGTbAU6xacbBkD
        wEWh/BoA2qSY6GondTfa7vKrFnni2uh9U7G/YppqeMGIO+zu+4N4MJn7Tca5kmkv2h5lg8sVQxCC3
        jfN3OJrfIbe1yirE+92Gl7tfJeRFpf+CwODIFLwzHzF2pGXVYkQGhdxOgtPbR6pz9VeOnkrXPnbQb
        sN7Yy6NQVvxo8wHPWUdwfsUZdyYdmm66dEiBVaQo0GclS2xQ5t+V8hmmHI2unVs/GKbPeVNWdJVlM
        1PKXLSH+bYshsHqLB4gQLcfD5Ylyihi4GYGMBdwCSfSa1m2JEjxEy7Xg02eRVdiSlNQqL64dXatb5
        J3mvlyvCTMmSxZvsulbnEoviz5XArdHDUuxdGCBMw=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>, asmadeus@codewreck.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3 v2] 9p: Fix write overflow in p9_read_work
Date:   Fri, 18 Nov 2022 16:34:35 +0100
Message-ID: <3743363.vbEDF3eA3V@silver>
In-Reply-To: <Y3ePOhpctTf7Buf8@codewreck.org>
References: <20221117091159.31533-1-guozihua@huawei.com>
 <a6aec93a-1166-1d8a-48de-767bc1eb2214@huawei.com>
 <Y3ePOhpctTf7Buf8@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, November 18, 2022 2:57:14 PM CET asmadeus@codewreck.org wrote:
> Guozihua (Scott) wrote on Fri, Nov 18, 2022 at 06:18:16PM +0800:
> > I retried the repro on your branch, the issue does not reproduce. What
> > a good pair of eyes :)=EF=BC=81
>=20
> Thanks!
> By the way the original check also compared size to msize directly,
> without an offset for headers, so with hindsight it looks clear enough
> that the size is the full size including the header.
>=20
> I'm not sure why I convinced myself it didn't...
>=20
> Anyway, this made me check other places where we might fail at this and
> I've a couple more patches; please review if you have time.
> I'll send them all to Linus next week...
>=20

Aah, the offset is already incremented before that block is entered:

303	err =3D p9_fd_read(m->client, m->rc.sdata + m->rc.offset,
304			 m->rc.capacity - m->rc.offset);
=2E..
312	m->rc.offset +=3D err;
313
314	/* header read in */
315	if ((!m->rreq) && (m->rc.offset =3D=3D m->rc.capacity)) {

And the data is then copied to m->rreq->rc.sdata without any offset. So yes,
there should be no `offset` in the check.

Best regards,
Christian Schoenebeck


