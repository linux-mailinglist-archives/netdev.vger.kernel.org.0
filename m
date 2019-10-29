Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D2FE90CA
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 21:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfJ2U30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 16:29:26 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34643 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfJ2U30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 16:29:26 -0400
X-Originating-IP: 209.85.217.45
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
        (Authenticated sender: pshelar@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id EEE4F60006
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:29:22 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id v10so131808vsc.7
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 13:29:22 -0700 (PDT)
X-Gm-Message-State: APjAAAU/n8kNcmtfvBQj7u3iXFbF3zAmR2X2GdB2mL4okvvHsuBDvFD6
        c0/Imf8SE2dPHjls/oNf2Agxa/Dv4lBBm4iduYE=
X-Google-Smtp-Source: APXvYqxTffZUHncpA/oQZGaGhSrLQ03pHdSAhYmWGRrhFj5hUHCWhaTVyO4aEuI3CMRqVUIc+1yknFUVT7v32g7pbt8=
X-Received: by 2002:a67:eb89:: with SMTP id e9mr3110953vso.103.1572380961573;
 Tue, 29 Oct 2019 13:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <1572242037-7041-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_A2S-27P3xWFOKTCZ5rrjeubzAcbr+sChYQOES0ucC_iw@mail.gmail.com> <20191029105037.GA9566@martin-VirtualBox>
In-Reply-To: <20191029105037.GA9566@martin-VirtualBox>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 29 Oct 2019 13:29:10 -0700
X-Gmail-Original-Message-ID: <CAOrHB_A_+s7Nsvy00sqJx8FRzRWHGQEnZjfJk8qbusczvSWCBA@mail.gmail.com>
Message-ID: <CAOrHB_A_+s7Nsvy00sqJx8FRzRWHGQEnZjfJk8qbusczvSWCBA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] Change in Openvswitch to support MPLS label
 depth of 3 in ingress direction
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 3:50 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Tue, Oct 29, 2019 at 12:37:45AM -0700, Pravin Shelar wrote:
> > On Sun, Oct 27, 2019 at 10:54 PM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin Varghese <martin.varghese@nokia.com>
> > >
> > > The openvswitch was supporting a MPLS label depth of 1 in the ingress
> > > direction though the userspace OVS supports a max depth of 3 labels.
> > > This change enables openvswitch module to support a max depth of
> > > 3 labels in the ingress.
> > >
> > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > > ---
> > > Changes in v2:
> > >     - Moved MPLS count validation from datapath to configuration.
> > >     - Fixed set mpls function.
> > >
> > > Changes in v3:
> > >     - Updated the comments section of POP_MPLS action configuration.
> > >     - Moved mpls_label_count variable initialization to ovs_nla_copy_actions.
> > >       The current value of the mpls_label_count variable in the function
> > >       __ovs_nla_copy_actions  will be passed to the functions processing
> > >       nested actions (Eg- validate_and_copy_clone) for validations of the
> > >       nested actions on the cloned packet.
> > >
> > >  net/openvswitch/actions.c      |  2 +-
> > >  net/openvswitch/flow.c         | 20 +++++++---
> > >  net/openvswitch/flow.h         |  9 +++--
> > >  net/openvswitch/flow_netlink.c | 87 +++++++++++++++++++++++++++++++-----------
> > >  4 files changed, 85 insertions(+), 33 deletions(-)
> > >
> > ...
> > > diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> > > index d7559c6..65c2e34 100644
> > > --- a/net/openvswitch/flow_netlink.c
> > > +++ b/net/openvswitch/flow_netlink.c
> > > @@ -424,7 +424,7 @@ size_t ovs_key_attr_size(void)
> > >         [OVS_KEY_ATTR_DP_HASH]   = { .len = sizeof(u32) },
> > >         [OVS_KEY_ATTR_TUNNEL]    = { .len = OVS_ATTR_NESTED,
> > >                                      .next = ovs_tunnel_key_lens, },
> > > -       [OVS_KEY_ATTR_MPLS]      = { .len = sizeof(struct ovs_key_mpls) },
> > > +       [OVS_KEY_ATTR_MPLS]      = { .len = OVS_ATTR_VARIABLE },
> > >         [OVS_KEY_ATTR_CT_STATE]  = { .len = sizeof(u32) },
> > >         [OVS_KEY_ATTR_CT_ZONE]   = { .len = sizeof(u16) },
> > >         [OVS_KEY_ATTR_CT_MARK]   = { .len = sizeof(u32) },
> > ovs_key_attr_size() also needs update for MPLS labels.
> >
> Do we need to ?
> In the existing ovs_key_attr_size function i dont see MPLS header size taken into
> account.I assume it is not needed as MPLS being a L3 protocol,either MPLS or IP/IPv6
> can be present.In the key size calculation we are including the 40 bytes of ipv6
> which can accomodate 12 bytes of MPLS header.
>
Yes, IPv6 attribute should cover MPLS.
