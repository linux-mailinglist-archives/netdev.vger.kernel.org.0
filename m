Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6814ED2BB
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 06:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiCaEMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 00:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiCaEM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 00:12:27 -0400
Received: from smtprz01.163.net (smtprz01.163.net [106.3.154.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB1AA15471B
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 20:52:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 77B8F440104
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 11:26:19 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648697179; bh=21CqgYe68EqtmuAUXMw5t7Y6CsanGtFEcTU3Jo5xixQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vmGe8eDSSC4A7UgWYEejv4W5WicbEobzSCZVE2A9OlBkJm9MExfDiF+j2F6vaVieX
         dxvWpoPs4nQpQN7rDt/VfShB5YBiCbnK3lzhsQBBb4zGAIzMZL19KwE32aPgzBoUvY
         rJcy6N+oR5UPyaf/xa5qI2auGIOZ4pjbMfBnFr3o=
Received: from localhost (HELO smtprz01.163.net) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID 1503310895
          for <netdev@vger.kernel.org>;
          Thu, 31 Mar 2022 11:26:19 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648697179; bh=21CqgYe68EqtmuAUXMw5t7Y6CsanGtFEcTU3Jo5xixQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vmGe8eDSSC4A7UgWYEejv4W5WicbEobzSCZVE2A9OlBkJm9MExfDiF+j2F6vaVieX
         dxvWpoPs4nQpQN7rDt/VfShB5YBiCbnK3lzhsQBBb4zGAIzMZL19KwE32aPgzBoUvY
         rJcy6N+oR5UPyaf/xa5qI2auGIOZ4pjbMfBnFr3o=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 0C94D15411C6;
        Thu, 31 Mar 2022 11:26:14 +0800 (CST)
Date:   Thu, 31 Mar 2022 11:26:13 +0800
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Message-ID: <20220331112613.0000063e@tom.com>
In-Reply-To: <15f24dcd-9a62-8bab-271c-baa9cc693d8d@grimberg.me>
References: <20220311103414.8255-1-sunmingbao@tom.com>
 <20220311103414.8255-2-sunmingbao@tom.com>
 <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
 <20220325201123.00002f28@tom.com>
 <b7b5106a-9c0d-db49-00ab-234756955de8@grimberg.me>
 <20220329104806.00000126@tom.com>
 <15f24dcd-9a62-8bab-271c-baa9cc693d8d@grimberg.me>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 10:46:08 +0300
Sagi Grimberg <sagi@grimberg.me> wrote:

> >> As I said, TCP can be tuned in various ways, congestion being just one
> >> of them. I'm sure you can find a workload where rmem/wmem will make
> >> a difference. =20
> >=20
> > agree.
> > but the difference for the knob of rmem/wmem is:
> > we could enlarge rmem/wmem for NVMe/TCP via sysctl,
> > and it would not bring downside to any other sockets whose
> > rmem/wmem are not explicitly specified. =20
>=20
> It can most certainly affect them, positively or negatively, depends
> on the use-case.

Agree.
Your saying is rigorous.

> >> In addition, based on my knowledge, application specific TCP level
> >> tuning (like congestion) is not really a common thing to do. So why in
> >> nvme-tcp?
> >>
> >> So to me at least, it is not clear why we should add it to the driver.=
 =20
> >=20
> > As mentioned in the commit message, though we can specify the
> > congestion-control of NVMe_over_TCP via sysctl or writing
> > '/proc/sys/net/ipv4/tcp_congestion_control', but this also
> > changes the congestion-control of all the future TCP sockets on
> > the same host that have not been explicitly assigned the
> > congestion-control, thus bringing potential impaction on their
> > performance.
> >=20
> > For example:
> >=20
> > A server in a data-center with the following 2 NICs:
> >=20
> >      - NIC_fron-end, for interacting with clients through WAN
> >        (high latency, ms-level)
> >=20
> >      - NIC_back-end, for interacting with NVMe/TCP target through LAN
> >        (low latency, ECN-enabled, ideal for dctcp)
> >=20
> > This server interacts with clients (handling requests) via the fron-end
> > network and accesses the NVMe/TCP storage via the back-end network.
> > This is a normal use case, right?
> >=20
> > For the client devices, we can=E2=80=99t determine their congestion-con=
trol.
> > But normally it=E2=80=99s cubic by default (per the CONFIG_DEFAULT_TCP_=
CONG).
> > So if we change the default congestion control on the server to dctcp
> > on behalf of the NVMe/TCP traffic of the LAN side, it could at the
> > same time change the congestion-control of the front-end sockets
> > to dctcp while the congestion-control of the client-side is cubic.
> > So this is an unexpected scenario.
> >=20
> > In addition, distributed storage products like the following also have
> > the above problem:
> >=20
> >      - The product consists of a cluster of servers.
> >=20
> >      - Each server serves clients via its front-end NIC
> >       (WAN, high latency).
> >=20
> >      - All servers interact with each other via NVMe/TCP via back-end N=
IC
> >       (LAN, low latency, ECN-enabled, ideal for dctcp). =20
>=20
> Separate networks are still not application (nvme-tcp) specific and as
> mentioned, we have a way to control that. IMO, this still does not
> qualify as solid justification to add this to nvme-tcp.
>=20
> What do others think?

Well, per the fact that the approach (=E2=80=98ip route =E2=80=A6=E2=80=99)=
 proposed
by Jakub could largely fit the per link requirement on
congestion-control, so the usefulness of this patchset is really
not so significant.

So here I terminate all the threads of this patchset.

At last, many thanks to all of you for reviewing this patchset.
