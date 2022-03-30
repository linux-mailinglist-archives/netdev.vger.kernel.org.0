Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304B34EBBBC
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 09:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243870AbiC3HdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 03:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243859AbiC3HdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 03:33:09 -0400
Received: from smtp.tom.com (smtprz01.163.net [106.3.154.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BFF51EF5FD
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 00:31:23 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 83AAE440106
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 15:31:22 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648625482; bh=NMMsM4W1Upu0QGhDq7i8xxMqcVrHRP8FulbAb4qUKvI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hbVMlh7XfTsiDdj94uG8cIhXl/9cUyFgR+HtJyvNuLJuQNb0fMrZWgsU0eBS6c9aW
         IeoJFAwtvc1BquvpxwxpwnOX9Uc5czwdjZQUBCi0MsD8ZGeXVQjVFTpzEI3DSJmHKE
         yFiTNquf3QT+9lgAFekEp/TaV/RaRPiDv8G7cE+Y=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID 945234129
          for <netdev@vger.kernel.org>;
          Wed, 30 Mar 2022 15:31:22 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648625482; bh=NMMsM4W1Upu0QGhDq7i8xxMqcVrHRP8FulbAb4qUKvI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hbVMlh7XfTsiDdj94uG8cIhXl/9cUyFgR+HtJyvNuLJuQNb0fMrZWgsU0eBS6c9aW
         IeoJFAwtvc1BquvpxwxpwnOX9Uc5czwdjZQUBCi0MsD8ZGeXVQjVFTpzEI3DSJmHKE
         yFiTNquf3QT+9lgAFekEp/TaV/RaRPiDv8G7cE+Y=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 1C5AB154209E;
        Wed, 30 Mar 2022 15:31:19 +0800 (CST)
Date:   Wed, 30 Mar 2022 15:31:17 +0800
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Message-ID: <20220330153117.00002565@tom.com>
In-Reply-To: <20220328213353.4aca75bd@kernel.org>
References: <20220311103414.8255-1-sunmingbao@tom.com>
        <20220311103414.8255-2-sunmingbao@tom.com>
        <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
        <20220325201123.00002f28@tom.com>
        <b7b5106a-9c0d-db49-00ab-234756955de8@grimberg.me>
        <20220329104806.00000126@tom.com>
        <20220328213353.4aca75bd@kernel.org>
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

On Mon, 28 Mar 2022 21:33:53 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 29 Mar 2022 10:48:06 +0800 Mingbao Sun wrote:
> > A server in a data-center with the following 2 NICs:
> >=20
> >     - NIC_fron-end, for interacting with clients through WAN
> >       (high latency, ms-level)
> >=20
> >     - NIC_back-end, for interacting with NVMe/TCP target through LAN
> >       (low latency, ECN-enabled, ideal for dctcp)
> >=20
> > This server interacts with clients (handling requests) via the fron-end
> > network and accesses the NVMe/TCP storage via the back-end network.
> > This is a normal use case, right? =20
>=20
> Well, if you have clearly separated networks you can set the congestion
> control algorithm per route, right? man ip-route, search congctl.

Cool, many thanks for the education.

I verified this approach, and it did work well.
And I furtherly found the commit
=E2=80=98net: tcp: add per route congestion control=E2=80=99 which just
addresses the requirement of this scenario (separated network).

So with this approach, the requirements of our use case are
roughly satisfied.

Thanks again ^_^
