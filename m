Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFF743AC1D
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 08:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhJZGQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 02:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhJZGQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 02:16:24 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9573C061745;
        Mon, 25 Oct 2021 23:14:00 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id h20so14007055qko.13;
        Mon, 25 Oct 2021 23:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rZXleyp133hD3PRG1ySuktNjNOVf4N0QRMg8i2MUjj8=;
        b=LNvIh7FX6R9EV3OLzv6fzhVQTLBn51dDro8PX6kJuVzAv5XqtoS3DnJHzuhivfl9Ml
         0hrHjrLDZi5QNSJqzJq9IEJSgMeM4q3gx7dSPK9hWFPCigj/txfOD1r0BtypV18OzC1G
         QCWYkNwNpaWTbrXb5PgHBixv0JWEDhVzmKu9uKLthjaGur0bwb132RnieRBsd6u+ZTbu
         q+Y7RIqQ/Ya0mnoWx2edbSwoqiZRpYQkOFi23+QQ6fNxXWUSeC+BarlhthsaG0fFFALs
         xjsvGAtare0YK2btnY7dnPSLdc/fD+ObrvfsPbcQNJ6k9sQzaS0t3PQGBTt+goTQYpXE
         sDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rZXleyp133hD3PRG1ySuktNjNOVf4N0QRMg8i2MUjj8=;
        b=O9iAL7bAPEw3cTDOqXbz1cwSiT92HduCMboRGDkuE6orXkF0UMPbFEfYTsdyh3QZX4
         fBm8CMGGAq9fRXDNkLZUL7eGyn+hoRnH3s2Dt+2ZonbHT2aCT+iYVdgayxQS0XTVcYXE
         h1Mz3OzgdpD/T/X4Y7PYgJpWb5jC1Q5YKziLxzCZbRSZxGiHEYGGCYhg+L5y+G4OUQ17
         mbbY0q7oldajy5n9yqxqAxrtdUAEADfOs2zHUA8xFAAGnpt3ok4kSnBPbaFwPQe1voWk
         Q0GWx8WBhsOvAxfKgRPVHXITfCb4rbgCIDd1EflomJISn0NS2LhccglVpNJFU6aCEDBq
         4Z7Q==
X-Gm-Message-State: AOAM532SXOj/isbS0L1mkF9GwBcgoKio/Rwlzxiwc0mca6StIx62lpD/
        vgW3cbA8SrWcpq/OQwh08/7ST0IbW2vjIMcco8Y=
X-Google-Smtp-Source: ABdhPJyJyhDRhA/s2PfHrkLVXtWBzw7Z8bx6p6vXCG7jdg8/04eVgc3/u0W5VDd0A6K8q2EJgn+6gCM8RrWRhPoDF1A=
X-Received: by 2002:a37:a93:: with SMTP id 141mr17376294qkk.443.1635228839907;
 Mon, 25 Oct 2021 23:13:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211025115910.2595-1-xingwu.yang@gmail.com> <707b5fb3-6b61-c53-e983-bc1373aa2bf@ssi.bg>
 <CA+7U5JsSuwqP7eHj1tMHfsb+EemwrhZEJ2b944LFWTroxAnQRQ@mail.gmail.com> <1190ef60-3ad9-119e-5336-1c62522aec81@ssi.bg>
In-Reply-To: <1190ef60-3ad9-119e-5336-1c62522aec81@ssi.bg>
From:   yangxingwu <xingwu.yang@gmail.com>
Date:   Tue, 26 Oct 2021 14:13:48 +0800
Message-ID: <CA+7U5JvvsNejgOifAwDdjddkLHUL30JPXSaDBTwysSL7dhphuA@mail.gmail.com>
Subject: Re: [PATCH] ipvs: Fix reuse connection if RS weight is 0
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, fw@strlen.de,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, corbet@lwn.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thanks Julian

yes, I know that the one-second delay issue has been fixed by commit
f0a5e4d7a594e0fe237d3dfafb069bb82f80f42f if we set conn_reuse_mode to
1

BUT  it's still NOT what we expected with sysctl settings
(conn_reuse_mode == 0 && expire_nodest_conn == 1).

We run kubernetes in extremely diverse environments and this issue
happens a lot.

On Tue, Oct 26, 2021 at 1:44 PM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Tue, 26 Oct 2021, yangxingwu wrote:
>
> > thanks julian
> >
> > What happens in this situation is that if we set the wait of the
> > realserver to 0 and do NOT remove the weight zero realserver with
> > sysctl settings (conn_reuse_mode == 0 && expire_nodest_conn == 1), and
> > the client reuses its source ports, the kernel will constantly
> > reuse connections and send the traffic to the weight 0 realserver.
>
>         Yes, this is expected when conn_reuse_mode=0.
>
> > you may check the details from
> > https://github.com/kubernetes/kubernetes/issues/81775
>
>         What happens if you try conn_reuse_mode=1? The
> one-second delay in previous kernels should be corrected with
>
> commit f0a5e4d7a594e0fe237d3dfafb069bb82f80f42f
> Date:   Wed Jul 1 18:17:19 2020 +0300
>
>     ipvs: allow connection reuse for unconfirmed conntrack
>
> > On Tue, Oct 26, 2021 at 2:12 AM Julian Anastasov <ja@ssi.bg> wrote:
> > >
> > > On Mon, 25 Oct 2021, yangxingwu wrote:
> > >
> > > > Since commit dc7b3eb900aa ("ipvs: Fix reuse connection if real server is
> > > > dead"), new connections to dead servers are redistributed immediately to
> > > > new servers.
> > > >
> > > > Then commit d752c3645717 ("ipvs: allow rescheduling of new connections when
> > > > port reuse is detected") disable expire_nodest_conn if conn_reuse_mode is
> > > > 0. And new connection may be distributed to a real server with weight 0.
> > >
> > >         Your change does not look correct to me. At the time
> > > expire_nodest_conn was created, it was not checked when
> > > weight is 0. At different places different terms are used
> > > but in short, we have two independent states for real server:
> > >
> > > - inhibited: weight=0 and no new connections should be served,
> > >         packets for existing connections can be routed to server
> > >         if it is still available and packets are not dropped
> > >         by expire_nodest_conn.
> > >         The new feature is that port reuse detection can
> > >         redirect the new TCP connection into a new IPVS conn and
> > >         to expire the existing cp/ct.
> > >
> > > - unavailable (!IP_VS_DEST_F_AVAILABLE): server is removed,
> > >         can be temporary, drop traffic for existing connections
> > >         but on expire_nodest_conn we can select different server
> > >
> > >         The new conn_reuse_mode flag allows port reuse to
> > > be detected. Only then expire_nodest_conn has the
> > > opportunity with commit dc7b3eb900aa to check weight=0
> > > and to consider the old traffic as finished. If a new
> > > server is selected, any retrans from previous connection
> > > would be considered as part from the new connection. It
> > > is a rapid way to switch server without checking with
> > > is_new_conn_expected() because we can not have many
> > > conns/conntracks to different servers.
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
