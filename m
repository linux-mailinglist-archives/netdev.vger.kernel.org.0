Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D31EE8EFF
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfJ2SIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:08:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38644 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726310AbfJ2SIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:08:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572372514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+AFrkPshIHm3cxzJTEBVMXAP6hJQIAiuU+zH/SUBwUo=;
        b=fbcIoTRGL9efDL4P4PibWEWe2FSsTAy60fgCgYvztjnVJXFSmLyXPgB82ruW5T7LQuu7zB
        EvQqKxJNfwlR0EAVo2WkIwkJ4Pkrpb9pFReKJi8i2AerVa/jeceioSBOhAFXR6738oEKeD
        iXO9wZ4EE7v1IcLJtz2Tc+sy9DmcipI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-SGVItaXjOai_BH_g-5ZtXw-1; Tue, 29 Oct 2019 14:08:33 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF4B981A334;
        Tue, 29 Oct 2019 18:08:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-125-132.rdu2.redhat.com [10.10.125.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B643C600CC;
        Tue, 29 Oct 2019 18:08:31 +0000 (UTC)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E0E91C0D97; Tue, 29 Oct 2019 15:08:29 -0300 (-03)
Date:   Tue, 29 Oct 2019 15:08:29 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, paulb@mellanox.com
Subject: Re: [PATCH iproute2 net] tc: remove duplicated NEXT_ARG_FWD() in
 parse_ct()
Message-ID: <20191029180829.GH4321@localhost.localdomain>
References: <20191029175346.14564-1-vladbu@mellanox.com>
MIME-Version: 1.0
In-Reply-To: <20191029175346.14564-1-vladbu@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: SGVItaXjOai_BH_g-5ZtXw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 07:53:46PM +0200, Vlad Buslov wrote:
> Function parse_ct() manually calls NEXT_ARG_FWD() after
> parse_action_control_dflt(). This is redundant because
> parse_action_control_dflt() modifies argc and argv itself. Moreover, such
> implementation parses out any following actions option. For example, addi=
ng
> action ct with cookie errors:
>=20
> $ sudo tc actions add action ct cookie 111111111111
> Bad action type 111111111111
> Usage: ... gact <ACTION> [RAND] [INDEX]
> Where:  ACTION :=3D reclassify | drop | continue | pass | pipe |
>                   goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>
>         RAND :=3D random <RANDTYPE> <ACTION> <VAL>
>         RANDTYPE :=3D netrand | determ
>         VAL : =3D value not exceeding 10000
>         JUMP_COUNT :=3D Absolute jump from start of action list
>         INDEX :=3D index value used
>=20
> With fix:
>=20
> $ sudo tc actions add action ct cookie 111111111111
> $ sudo tc actions list action ct
> total acts 1
>=20
>         action order 0: ct zone 0 pipe
>          index 1 ref 1 bind 0
>         cookie 111111111111
>=20
> Fixes: c8a494314c40 ("tc: Introduce tc ct action")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks Vlad.

> ---
>  tc/m_ct.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/tc/m_ct.c b/tc/m_ct.c
> index 8589cb9a3c51..d79eb5e361ac 100644
> --- a/tc/m_ct.c
> +++ b/tc/m_ct.c
> @@ -316,7 +316,6 @@ parse_ct(struct action_util *a, int *argc_p, char ***=
argv_p, int tca_id,
> =20
>  =09parse_action_control_dflt(&argc, &argv, &sel.action, false,
>  =09=09=09=09  TC_ACT_PIPE);
> -=09NEXT_ARG_FWD();
> =20
>  =09addattr16(n, MAX_MSG, TCA_CT_ACTION, ct_action);
>  =09addattr_l(n, MAX_MSG, TCA_CT_PARMS, &sel, sizeof(sel));
> --=20
> 2.21.0
>=20

