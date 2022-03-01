Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8A84C983F
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 23:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbiCAWVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 17:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiCAWVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 17:21:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF0F7087E;
        Tue,  1 Mar 2022 14:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3452B612B9;
        Tue,  1 Mar 2022 22:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BD3C340EE;
        Tue,  1 Mar 2022 22:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646173220;
        bh=QWtzGgPDT3UAoP9LthHH+ovHAX/WgDZXos0E+c/beN8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ook6XhJCwYQxt5EHRzFY6KzAA4H9e8Fh1ZquS/3LD0lnphsosnlU9toXv7F5Wpt0l
         FSYWCUfL5+7SkDYpfauaTNu83/Lhmf8w7drvbjyj0JHulGGrXcgJj0DZyAr5nBB3cE
         x0RvU8GXpslDiXBpUyROcRvzOk3SD9wkTAX6vSfOjt2pTXg1c0IJIQu863xr6pST4A
         0af6RjSjVNcq6YavfFY7extgY61HDqZr1ZAtaXiLDm5s8dDtcAigJvNDUPt3Qg08Qg
         DYYN+O/xQf6XJoZcNUwurW1mPmhZMqdqtyVF1GjBpoxsa7+DNFuwqW1ZRwF5StxidP
         XJDBkLLfTd2RQ==
Date:   Tue, 1 Mar 2022 14:20:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] net/smc: add sysctl for autocorking
Message-ID: <20220301142019.7ecae6c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301094402.14992-4-dust.li@linux.alibaba.com>
References: <20220301094402.14992-1-dust.li@linux.alibaba.com>
        <20220301094402.14992-4-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Mar 2022 17:43:58 +0800 Dust Li wrote:
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -147,7 +147,7 @@ static bool smc_should_autocork(struct smc_sock *smc)
>  	struct smc_connection *conn =3D &smc->conn;
>  	int corking_size;
> =20
> -	corking_size =3D min(SMC_AUTOCORKING_DEFAULT_SIZE,
> +	corking_size =3D min(sock_net(&smc->sk)->smc.sysctl_autocorking_size,
>  			   conn->sndbuf_desc->len >> 1);

I think this broke the build:

In file included from ../include/linux/kernel.h:26,
                 from ../include/linux/random.h:11,
                 from ../include/linux/net.h:18,
                 from ../net/smc/smc_tx.c:16:
../net/smc/smc_tx.c: In function =E2=80=98smc_should_autocork=E2=80=99:
../include/linux/minmax.h:20:35: error: comparison of distinct pointer type=
s lacks a cast [-Werror]
   20 |         (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
      |                                   ^~
../include/linux/minmax.h:26:18: note: in expansion of macro =E2=80=98__typ=
echeck=E2=80=99
   26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
      |                  ^~~~~~~~~~~
../include/linux/minmax.h:36:31: note: in expansion of macro =E2=80=98__saf=
e_cmp=E2=80=99
   36 |         __builtin_choose_expr(__safe_cmp(x, y), \
      |                               ^~~~~~~~~~
../include/linux/minmax.h:45:25: note: in expansion of macro =E2=80=98__car=
eful_cmp=E2=80=99
   45 | #define min(x, y)       __careful_cmp(x, y, <)
      |                         ^~~~~~~~~~~~~
../net/smc/smc_tx.c:150:24: note: in expansion of macro =E2=80=98min=E2=80=
=99
  150 |         corking_size =3D min(sock_net(&smc->sk)->smc.sysctl_autocor=
king_size,
      |                        ^~~
