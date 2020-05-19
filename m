Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF83C1D8C42
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgESA0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbgESA0n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 20:26:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F8A520715;
        Tue, 19 May 2020 00:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589848003;
        bh=QSS3tzAfLZzfKmjIACrDUNEVS1tqi1P+rzQvATB+XQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AT6oe2MtBUTi9biUR57YRco34euhns+9oV239hjalq3pyEC5tWsteL3kYi3Zadmpy
         k7BJJeknDMbFac0TMBuJtP/+tRYV+rsOEQlrvnyHlA8auDTdVtSVv3phRfTBfNsonl
         r2FlLZ1nhML3WwvDPBhAMSX/Ic5AMxAFmsakjWI4=
Date:   Mon, 18 May 2020 17:26:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/tls: fix encryption error checking
Message-ID: <20200518172640.1b07cf46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8c526c6b-172e-1301-dbd0-6ce5901f5890@novek.ru>
References: <20200517014451.954F05026DE@novek.ru>
        <20200518153005.577dfe99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANN+EMpn2ZkquAdK5WFC-bmioSoAbAtNvovXtgTyTHW+-eDPhw@mail.gmail.com>
        <e26b157f-edc4-4a04-11ac-21485ed52f8a@novek.ru>
        <20200518162343.7685f779@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8c526c6b-172e-1301-dbd0-6ce5901f5890@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 02:55:16 +0300 Vadim Fedorenko wrote:
> On 19.05.2020 02:23, Jakub Kicinski wrote:
> > On Tue, 19 May 2020 02:05:29 +0300 Vadim Fedorenko wrote: =20
> >> On 19.05.2020 01:30, Jakub Kicinski wrote: =20
> >>>> tls_push_record can return -EAGAIN because of tcp layer. In that
> >>>> case open_rec is already in the tx_record list and should not be
> >>>> freed.
> >>>> Also the record size can be more than the size requested to write
> >>>> in tls_sw_do_sendpage(). That leads to overflow of copied variable
> >>>> and wrong return code.
> >>>>
> >>>> Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
> >>>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru> =20
> >>> Doesn't this return -EAGAIN back to user space? Meaning even tho we
> >>> queued the user space will try to send it again? =20
> >> Before patch it was sending negative value back to user space.
> >> After patch it sends the amount of data encrypted in last call. It is =
checked
> >> by:
> >>   =C2=A0return (copied > 0) ? copied : ret;
> >> and returns -EAGAIN only if data is not sent to open record. =20
> > I see, you're fixing two different bugs in one patch. Could you please
> > split the fixes into two? (BTW no need for parenthesis around the
> > condition in the ternary operator.) I think you need more fixes tags,
> > too. Commit d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
> > already added one instance of the problem, right? =20
> Sure, will split it into two. Also the problem with overflow is possible =
in
> tls_sw_sendmsg(). But I'm not sure about correctness of freeing whole
> open record in bpf_exec_tx_verdict.

Yeah, as a matter of fact checking if copied is negative is just
papering over the issue. Cleaning up the record so it can be
re-submitted again would be better.

> > What do you think about Pooja's patch to consume the EAGAIN earlier?
> > There doesn't seem to be anything reasonable we can do with the error
> > anyway, not sure there is a point checking for it.. =20
> Yes, it's a good idea to consume this error earlier. I think it's better =
to fix
> tls_push_record() instead of dealing with it every possible caller.
>=20
> So I suggest to accept Pooja's patch and will resend only ssize_t checkin=
g fix.

Cool, thanks!
