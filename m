Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3C857AAFF
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 02:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiGTAcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 20:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiGTAcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 20:32:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10AB45F53
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 17:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28880616CB
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F3CC341C6;
        Wed, 20 Jul 2022 00:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658277122;
        bh=B1Wx6UTgWlcjDtqBK00/uID4IV/Nrs7SUFVuffIIsy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tUma2/mlesh8j3cY9yE+xehcSbVAnrePJB/ObdRF1XrZWv6OB5z3sUC4fCMdqM2sd
         lo5d94H3lNcXp1ihNKFLI/Kr0061PoDUkpHs3opHtTcn68F8JltXfKa00tnaC7I/qq
         OXPLZGB9J6ndYQUmNpn2DDEWGF2Czgd9W253p5bjwpRI4cxXM/X0v0GnodlxkrxDrK
         Q4jWxeq2vVmtAclGqcUDa7A2fw4/VpGRL3HbXteMfiIE1qLxt1mETlXRYUG6tUQI76
         k+bH7T3PDsOed4FGEjCS9X7etypyB17reo5PxIYY1eqLgcmD4p5Yln0IaGvuXsjNys
         ErQWHcylAmoMw==
Date:   Tue, 19 Jul 2022 17:32:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v1 net-next] selftests: net: af_unix: Fix a build error
 of unix_connect.c.
Message-ID: <20220719173201.01807d65@kernel.org>
In-Reply-To: <20220718162350.19186-1-kuniyu@amazon.com>
References: <20220718162350.19186-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 09:23:50 -0700 Kuniyuki Iwashima wrote:
> This patch fixes a build error reported in the link. [0]
>=20
>   unix_connect.c: In function =E2=80=98unix_connect_test=E2=80=99:
>   unix_connect.c:115:55: error: expected identifier before =E2=80=98(=E2=
=80=99 token
>    #define offsetof(type, member) ((size_t)&((type *)0)->(member))
>                                                        ^
>   unix_connect.c:128:12: note: in expansion of macro =E2=80=98offsetof=E2=
=80=99
>     addrlen =3D offsetof(struct sockaddr_un, sun_path) + variant->len;
>               ^~~~~~~~

Can we delete this define and use stddef.h instead?  man offsetof
This is not kernel code the C standard lib is at our disposal.

> The checkpatch.pl will complain about this change, but the root cause of
> the build failure is that I fixed this in the v2 -> v3 change. [1]
>=20
>   CHECK: Macro argument 'member' may be better as '(member)' to avoid pre=
cedence issues
>   #33: FILE: tools/testing/selftests/net/af_unix/unix_connect.c:115:
>   +#define offsetof(type, member) ((size_t)&((type *)0)->member)
>=20
> [0]: https://lore.kernel.org/linux-mm/202207182205.FrkMeDZT-lkp@intel.com/
> [1]: https://lore.kernel.org/netdev/20220702154818.66761-1-kuniyu@amazon.=
com/
>=20
> Fixes: e95ab1d85289 ("selftests: net: af_unix: Test connect() with differ=
ent netns.")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  tools/testing/selftests/net/af_unix/unix_connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/net/af_unix/unix_connect.c b/tools/t=
esting/selftests/net/af_unix/unix_connect.c
> index 157e44ef7f37..5b231d8c4683 100644
> --- a/tools/testing/selftests/net/af_unix/unix_connect.c
> +++ b/tools/testing/selftests/net/af_unix/unix_connect.c
> @@ -112,7 +112,7 @@ FIXTURE_TEARDOWN(unix_connect)
>  		remove("test");
>  }
> =20
> -#define offsetof(type, member) ((size_t)&((type *)0)->(member))
> +#define offsetof(type, member) ((size_t)&((type *)0)->member)
> =20
>  TEST_F(unix_connect, test)
>  {

