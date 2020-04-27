Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283771BB1C6
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgD0XAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:00:22 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:50573 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgD0XAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 19:00:22 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e0a57c52
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 22:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=mOBxeDeOwDBQ
        C9nE4LU5bxeymmY=; b=fxE4R3Gcn1YajwPgqTKt42evF39PjWfmXrhh2mH3uPC2
        epnWzOl421aQ8x0rnLczWv1xPOLghYaxhH0jDP3b8QgTYjqkKdRy2/4c2YO/GBAW
        227qheetb6ULWi64C3+J7g7MaQ/q/1TA7KPI/ubHM849XoOGIZUTh/Ryacxmi+LV
        5iRDwmDSFPni20vedQ+u+xUP7yBRGew7T5YBrZccZip7/2nGc31HuRBwyn686soF
        eBLiLr++YWFkK+HXponfy3d7fOu6Va1HszWspmq+/3fAdJVjsUxG6jGsch61Eaoo
        3hI7b3I0VtitddbC9vnQCjgkaoaRBlYKTDMNdoe2YA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 11a2f986 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 22:48:41 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id c16so18428421ilr.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:00:14 -0700 (PDT)
X-Gm-Message-State: AGi0Pua8HxZUhLxRbF/8kOtrsMEhrjWMpZqfPmfkljm/72Bq5nNv0MTr
        VbNcNSSPSStQZWlHi0u86UxMpkq742rnDShyPIo=
X-Google-Smtp-Source: APiQypJsq3Aqnhj+QNoxKRx2HdOGNFi/yG82AqfKnNOMiNC3smAVZCyKkY8I0zWL9TVuxU3CxSVvCeF7FwEWjREI/8c=
X-Received: by 2002:a92:d98c:: with SMTP id r12mr24105003iln.224.1588028413815;
 Mon, 27 Apr 2020 16:00:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
 <20200427204208.2501-1-Jason@zx2c4.com> <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <877dy0y6le.fsf@toke.dk> <20200427143145.19008d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200427143145.19008d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Apr 2020 17:00:02 -0600
X-Gmail-Original-Message-ID: <CAHmME9r7G6f5y-_SPs64guH9PrG8CKBhLDZZK6jpiOhgHBps8g@mail.gmail.com>
Message-ID: <CAHmME9r7G6f5y-_SPs64guH9PrG8CKBhLDZZK6jpiOhgHBps8g@mail.gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 3:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 27 Apr 2020 23:14:05 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
> > Jakub Kicinski <kuba@kernel.org> writes:
> > > On Mon, 27 Apr 2020 13:52:54 -0700 Jakub Kicinski wrote:
> > >> On Mon, 27 Apr 2020 14:42:08 -0600 Jason A. Donenfeld wrote:
> > >> > A user reported that packets from wireguard were possibly ignored =
by XDP
> > >> > [1]. Apparently, the generic skb xdp handler path seems to assume =
that
> > >> > packets will always have an ethernet header, which really isn't al=
ways
> > >> > the case for layer 3 packets, which are produced by multiple drive=
rs.
> > >> > This patch fixes the oversight. If the mac_len is 0, then we assum=
e
> > >> > that it's a layer 3 packet, and in that case prepend a pseudo ethh=
dr to
> > >> > the packet whose h_proto is copied from skb->protocol, which will =
have
> > >> > the appropriate v4 or v6 ethertype. This allows us to keep XDP pro=
grams'
> > >> > assumption correct about packets always having that ethernet heade=
r, so
> > >> > that existing code doesn't break, while still allowing layer 3 dev=
ices
> > >> > to use the generic XDP handler.
> > >>
> > >> Is this going to work correctly with XDP_TX? presumably wireguard
> > >> doesn't want the ethernet L2 on egress, either? And what about
> > >> redirects?
> > >>
> > >> I'm not sure we can paper over the L2 differences between interfaces=
.
> > >> Isn't user supposed to know what interface the program is attached t=
o?
> > >> I believe that's the case for cls_bpf ingress, right?
> > >
> > > In general we should also ask ourselves if supporting XDPgeneric on
> > > software interfaces isn't just pointless code bloat, and it wouldn't
> > > be better to let XDP remain clearly tied to the in-driver native use
> > > case.
> >
> > I was mostly ignoring generic XDP for a long time for this reason. But
> > it seems to me that people find generic XDP quite useful, so I'm no
> > longer so sure this is the right thing to do...
>
> I wonder, maybe our documentation is not clear. IOW we were saying that
> XDP is a faster cls_bpf, which leaves out the part that XDP only makes
> sense for HW/virt devices.
>
> Kinda same story as XDP egress, folks may be asking for it but that
> doesn't mean it makes sense.
>
> Perhaps the original reporter realized this and that's why they
> disappeared?
>
> My understanding is that XDP generic is aimed at testing and stop gap
> for drivers which don't implement native. Defining behavior based on
> XDP generic's needs seems a little backwards, and risky.
>
> That said, I don't feel particularly strongly about this.

Okay, well, I'll continue developing the v3 approach a little further
-- making sure I have tx path handled too and whatnot. Then at least
something viable will be available, and you can take or leave it
depending on what you all decide.
