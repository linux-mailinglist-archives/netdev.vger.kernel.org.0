Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A698B2F6EBA
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbhANW5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:57:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730834AbhANW5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 17:57:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4526823A5C;
        Thu, 14 Jan 2021 22:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610665017;
        bh=7OKS990SMNCg5lRpfEXdqNvYupwlzOnAG4C9+dWzBWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uaVtFX5geTxWzuOrFCjUv1YfzHDEcdnqCQyvbjqfonIfcfBCsS/YK5r0LRGb0BSbs
         QXAzB0xwNxiuUxw3StonsBNESDvEbvEsd1r3ZzC3nA3JZaFgSZTmTJ1QEDdkFBt43X
         O8SNxiXqos/TDoLJtb/fdc2d/eY9F+dRN8xhgPtpSMpFqLXV3cR9wQRXqDztaMAr0a
         tKTyWc3O1VvXmBOODaUPYjeqJmFf9LzEapgmgj/XU8vR0H7UF8Epgxjt9dGeCFkDse
         5zmk6kqQ8mmOHkIT5iPkTBpXGN2wZgNjbOyqRxPxO8KpQYHbmfuxhFf0Mcxe9yURCt
         e1/ugt4lFKh1w==
Date:   Thu, 14 Jan 2021 14:56:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net v3] cls_flower: call nla_ok() before nla_next()
Message-ID: <20210114145656.65044a4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpUa3a4gRLSwWpC-t98iv8bCu60cwHkx9AB=81g_9d_PWQ@mail.gmail.com>
References: <20210114210749.61642-1-xiyou.wangcong@gmail.com>
        <20210114133625.0d1ea5e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpVAer0tBocMXGa0G_8jqJVz5oJ--woPo+TrtzVemyz+rQ@mail.gmail.com>
        <20210114143000.4bfca23a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpUa3a4gRLSwWpC-t98iv8bCu60cwHkx9AB=81g_9d_PWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 14:50:04 -0800 Cong Wang wrote:
> > static int fl_set_vxlan_opt(const struct nlattr *nla, struct fl_flow_ke=
y *key,
> >                             int depth, int option_len,
> >                             struct netlink_ext_ack *extack)
> > {
> >         struct nlattr *tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1];
> >         struct vxlan_metadata *md;
> >         int err;
> >
> >         md =3D (struct vxlan_metadata *)&key->enc_opts.data[key->enc_op=
ts.len];
> >         memset(md, 0xff, sizeof(*md));
> >
> >         if (!depth)
> >                 return sizeof(*md);
> >                 ^^^^^^^^^^^^^^^^^^^
> >
> > The mask is filled with all 1s if attribute is not provided. =20
>=20
> Hmm, then what is the length comparison check for?
>=20
> fl_set_vxlan_opt() either turns negative or sizeof(*md), and negitve
> is already checked when it returns, so when we hit the length comparison
> it is always equal. So it must be redundant.
>=20
> (Note, I am only talking about the vxlan case you pick here, because the
> geneve case is different, as it returns different sizes.)

Good question =F0=9F=A4=B7=F0=9F=8F=BB=E2=80=8D=E2=99=82=EF=B8=8F=F0=9F=A4=
=B7=F0=9F=8F=BB=E2=80=8D=E2=99=82=EF=B8=8F  I'd guess GENEVE came first and=
 and then
people copy / pasted the code structure other tunnel types?
