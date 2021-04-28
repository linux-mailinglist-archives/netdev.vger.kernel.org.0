Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CCB36DFD8
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 21:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239991AbhD1TqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 15:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232284AbhD1TqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 15:46:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 519BE61440;
        Wed, 28 Apr 2021 19:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619639135;
        bh=RiJLU5XTW9NWCVRLAFf7z+Q9Cbr4iLM1e5RwN+yOzQA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=krg+ojU83ZtqWY/9K6dYyFDw6x8pAud3iqZyNUpbhL78HTPee/LI0k9zxvy++1Fl+
         Sw5NeLTQQBxsUboFAku2NMompxspEkESegaDwBEeQ456lrNR4n6Iyyg04UWel4tnNo
         0rFQzAnvzZXAX1Bp79xlhK4vfaalDFgv0fQwty4U6WrWpvpQZW5k5LrIWdqy38qKh9
         zeoEcp/EIqnHCkJi/hw9qLAgrW/o+l+FJkx06LxP/rwlgFeY9qjhW14gxehbLWEhRv
         35PGB5CN+WMOV6DPp61R8KOVv6fT6/AKOK+rBciLgfVTJ3P/4OKq5f8HTPpZ00IFQW
         Bpd/szVAJxQgQ==
Date:   Wed, 28 Apr 2021 12:45:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Gong, Sishuai" <sishuai@purdue.edu>
Cc:     David Miller <davem@davemloft.net>,
        "tparkin@katalix.com" <tparkin@katalix.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: fix a concurrency bug in l2tp_tunnel_register()
Message-ID: <20210428124534.6f1d7dc4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1F82E994-8F0B-499F-BA1A-8F1B2EEF1BF2@purdue.edu>
References: <1F82E994-8F0B-499F-BA1A-8F1B2EEF1BF2@purdue.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Apr 2021 15:04:24 +0000 Gong, Sishuai wrote:
> l2tp_tunnel_register() registers a tunnel without fully
> initializing its attribute. This can allow another kernel thread
> running l2tp_xmit_core() to access the uninitialized data and
> then cause a kernel NULL pointer dereference error, as shown below.
>=20
> Thread 1    Thread 2
> //l2tp_tunnel_register()
> list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
>            //pppol2tp_connect()
>            tunnel =3D l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
>            // Fetch the new tunnel
>            ...
>            //l2tp_xmit_core()
>            struct sock *sk =3D tunnel->sock;
>            ...
>            bh_lock_sock(sk);
>            //Null pointer error happens
> tunnel->sock =3D sk;
>=20
> Fix this bug by initializing tunnel->sock before adding the
> tunnel into l2tp_tunnel_list.
>=20
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Sishuai Gong <sishuai@purdue.edu>
> Reported-by: Sishuai Gong <sishuai@purdue.edu>

Thanks for the patch! Unfortunately the patch in the email is
corrupted, looks like something removed spaces at the start of=20
the lines which are expected in patches, e.g.:

=C2=BB       pn=C2=B7=3D=C2=B7l2tp_pernet(net);$
$
+=C2=BB      sk=C2=B7=3D=C2=B7sock->sk;$

Should have been:

 =C2=BB      pn=C2=B7=3D=C2=B7l2tp_pernet(net);$
 $
+=C2=BB      sk=C2=B7=3D=C2=B7sock->sk;$

Could you try to resend once more with git-send-email or via=20
a different mail server?
