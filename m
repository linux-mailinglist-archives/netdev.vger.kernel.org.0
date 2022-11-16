Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8925962CAE1
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbiKPUb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbiKPUbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:31:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F86F5CD07;
        Wed, 16 Nov 2022 12:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 35F55CE1C7B;
        Wed, 16 Nov 2022 20:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130D9C433C1;
        Wed, 16 Nov 2022 20:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668630676;
        bh=CLvKGVimpMT7ZDsiSRppXbfGfDGwppgEoHMbZNRXQ08=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ELDxcxIuTVoBjWLQyyUkMT843Jyoiffgh06Xgm52ZL0K3+nRhn2P0JW6PtMP2i+8a
         ThAAGUG8r9mty4Gr6EcKdzGI/Q62BEqZ8HFePV9z+PPi7Fwx5zr8Vi+VxtgP4HTXK9
         Whdnzmk4zESehsRZpII9MZ6yUke2a17b/lmqESQZdagVUdsiMolFOOxLKXIDsBYYPb
         fJoSR3AFvx6ofui8xYtpbJ8CGzSzkPIhVtmiUMXDgNG5yIHGw1fDEfkYUA0yil3Ekm
         S0NR38C/9X3VWJASEXJsl4WNB2RIyYEFIm3PW9jvJGRF+npwsuVjSUFGAu7ViX279a
         wA78RdZJzJoaw==
Date:   Wed, 16 Nov 2022 12:31:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: Fix tcp_syn_flood_action() if
 CONFIG_IPV6=n
Message-ID: <20221116123115.6b49e1b8@kernel.org>
In-Reply-To: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
References: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 11:12:16 +0100 Geert Uytterhoeven wrote:
> If CONFIG_IPV6=3Dn:
>=20
>     net/ipv4/tcp_input.c: In function =E2=80=98tcp_syn_flood_action=E2=80=
=99:
>     include/net/sock.h:387:37: error: =E2=80=98const struct sock_common=
=E2=80=99 has no member named =E2=80=98skc_v6_rcv_saddr=E2=80=99; did you m=
ean =E2=80=98skc_rcv_saddr=E2=80=99?
>       387 | #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
> 	  |                                     ^~~~~~~~~~~~~~~~
>     include/linux/printk.h:429:19: note: in definition of macro =E2=80=98=
printk_index_wrap=E2=80=99
>       429 |   _p_func(_fmt, ##__VA_ARGS__);    \
> 	  |                   ^~~~~~~~~~~
>     include/linux/printk.h:530:2: note: in expansion of macro =E2=80=98pr=
intk=E2=80=99
>       530 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> 	  |  ^~~~~~
>     include/linux/net.h:272:3: note: in expansion of macro =E2=80=98pr_in=
fo=E2=80=99
>       272 |   function(__VA_ARGS__);    \
> 	  |   ^~~~~~~~
>     include/linux/net.h:288:2: note: in expansion of macro =E2=80=98net_r=
atelimited_function=E2=80=99
>       288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
> 	  |  ^~~~~~~~~~~~~~~~~~~~~~~~
>     include/linux/net.h:288:43: note: in expansion of macro =E2=80=98sk_v=
6_rcv_saddr=E2=80=99
>       288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
> 	  |                                           ^~~~~~~~~~~
>     net/ipv4/tcp_input.c:6847:4: note: in expansion of macro =E2=80=98net=
_info_ratelimited=E2=80=99
>      6847 |    net_info_ratelimited("%s: Possible SYN flooding on port [%=
pI6c]:%u. %s.\n",
> 	  |    ^~~~~~~~~~~~~~~~~~~~
>=20
> Fix this by using "#if" instead of "if", like is done for all other
> checks for CONFIG_IPV6.
>=20
> Fixes: d9282e48c6088105 ("tcp: Add listening address to SYN flood message=
")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Sorry for the late reaction, this now conflicts with bf36267e3ad3df8

I was gonna hand edit but perhaps we can do better with the ifdef
formation.

Instead of=20

#ifdef v6
	if (v6) {
		expensive_call6();
	} else    //  d k
#endif            //  o i
	{         //  o e
		expensive_call4();
	}

Can we go with:

#ifdef v6
	if (v6)
		expensive_call6();
	else=20
#endif
		expensive_call4();

or

	if (v4) {
		expensive_call4();
#ifdef v6
	} else {
		expensive_call6();
#endif
	}

or

	if (v6) {
#ifdef v6
		expensive_call6();
#endif
	} else {
		expensive_call6();
	}


I know you're just going with the most obviously correct / smallest diff
way, but the broken up else bracket gives me flashbacks of looking at
vendor code :S
