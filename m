Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A983E0F1E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfJWAVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:21:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727154AbfJWAVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571790088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j+zxnhxN9LHtyQ2JV3+0tt8hjLY8c1wwq0SRRNtEhEU=;
        b=LdemPX5fVOGc4NsnY3Sd1b4eWpKBTs4vAABVKdD3fgGPYpof/N91pKugLViGsVimA5mbXS
        Z+uTI9DqPaxyQIaF4v6fF1KcfkYcHk0Tv0ppBkyPhBs6YRbpkxAWCAitNNVBm6ukJ0XCbO
        EFnmwT3avVPK9rJTMTQ/Mrd35OuT+dA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-PUaLo326M_eq8feqTYVIUw-1; Tue, 22 Oct 2019 20:21:25 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27B6480183E;
        Wed, 23 Oct 2019 00:21:23 +0000 (UTC)
Received: from elisabeth (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B9F25DC18;
        Wed, 23 Oct 2019 00:21:17 +0000 (UTC)
Date:   Wed, 23 Oct 2019 02:20:53 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Hillf Danton <hdanton@sina.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ying Xue <ying.xue@windriver.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: Re: [PATCH net] net: openvswitch: free vport unless
 register_netdevice() succeeds
Message-ID: <20191023022053.0669e33f@elisabeth>
In-Reply-To: <20191022145316.63bf3b5a@cakuba.netronome.com>
References: <3caa233b136b5104c817a52a5fdc02691e530528.1571651489.git.sbrivio@redhat.com>
        <20191022145316.63bf3b5a@cakuba.netronome.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: PUaLo326M_eq8feqTYVIUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, 22 Oct 2019 14:53:16 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Mon, 21 Oct 2019 12:01:57 +0200, Stefano Brivio wrote:
> > From: Hillf Danton <hdanton@sina.com>
> >=20
> > syzbot found the following crash on: =20
> =20
> > The function in net core, register_netdevice(), may fail with vport's
> > destruction callback either invoked or not. After commit 309b66970ee2, =
=20
>=20
> I've added the correct commit quote here, please heed checkpatch'es
> warnings.

I disregarded this warning as it looks redundant to me, given that the
full commit quote is already given in the Fixes: tag below.

In this specific case, I guess it doesn't really make a difference, but
sometimes one needs to mention the same commit multiple times in the
actual message, and while checkpatch would complain about every single
instance, I think that providing the full quote for each of them isn't
very useful and hinders readability.

> > Reported-by: syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com
> > Fixes: 309b66970ee2 ("net: openvswitch: do not free vport if register_n=
etdevice() is failed.")
> > Cc: Taehee Yoo <ap420073@gmail.com>
> > Cc: Greg Rose <gvrose8192@gmail.com>
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Cc: Ying Xue <ying.xue@windriver.com>
> > Cc: Andrey Konovalov <andreyknvl@google.com>
> > Signed-off-by: Hillf Danton <hdanton@sina.com>
> > Acked-by: Pravin B Shelar <pshelar@ovn.org>
> > [sbrivio: this was sent to dev@openvswitch.org and never made its way
> >  to netdev -- resending original patch]
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> > This patch was sent to dev@openvswitch.org and appeared on netdev
> > only as Pravin replied to it, giving his Acked-by. I contacted the
> > original author one month ago requesting to resend this to netdev,
> > but didn't get an answer, so I'm now resending the original patch. =20
>=20
> Applied and queued for 4.14+, thanks!

Thank you!

--=20
Stefano

