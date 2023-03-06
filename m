Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7406AC862
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCFQmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjCFQlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:41:45 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C50F410B7;
        Mon,  6 Mar 2023 08:41:03 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id v11so11029657plz.8;
        Mon, 06 Mar 2023 08:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678120734;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AKshk2TgFt5gDSPmPYc9r3UR+qbqqGSRRPYk81A3xdc=;
        b=DbLuxUxQqGzccl6Odt7acKe19prnsM6WdaP6bauyrhsMyQyI42TcOjeoZtiZyZDzt7
         CJKgEOh6gahky9B9KYTWapNDSXhf329cvHHwlKqjsJX1p5SWKyHOCrEc40/Ij89GPtJg
         jh4Lbjhltf6LT5dKLkwf+/yBBAA04vbDuo1DKaVg8Ivf6kf7ATX3EGTtYy1bf0ZzlslJ
         PalgQ6vhD1K8arbBsFRF9zKt2jRpSMa+qk6WrWaScVaibQoPUTZEjETp0HxB9dlJvea5
         jD3nNWQCAZizc008uHyyoUn5mhT4bAYjeR/phegtdVNk0MdCg5b3Gw+80ArFZ9DodL2h
         2xvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678120734;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AKshk2TgFt5gDSPmPYc9r3UR+qbqqGSRRPYk81A3xdc=;
        b=ev/J6d+qIf9SXDnb+NPbRSvD/EoKpIwCZhU0KUiI6NETX2Dj3SsVaXVZ/C3DwXo3JB
         X6mA+2k0aGG8gD7WIReTutpPlXn7xtTO/MDbIRWXlwOj8yM9qtZB0+UE2gINCQf00Rz9
         djQfo1WTy1BqbazgZ/KikFrI36Szke3EEP1flx300CaamvsLeZ7/PNSrj4DhMkQPbTlA
         BapHh4K1KW7G5baXvQfJEuk++nlmpXMGoz0HiPwyET4mNjhxBC9MNwDPJdmJ7tgdIgqY
         ttkDS5ChcYsUc98SIaRjAIR3aB35POx7TQ0z1YNu7XtdsuzQZJaT8rmPxN7XYAgQUvky
         Idrg==
X-Gm-Message-State: AO0yUKUjlXDl1yc95/guLl039leux3gkIwmuZhnXuCXXH63REzmk6aMi
        1MQvFG+xHD5oOpa/N3633ef1lAjqgM4=
X-Google-Smtp-Source: AK7set8u5t1kTcKA2gaCJvvlkswCUv1hJg2P+yPJEb8eDD8uhzOirB0wrwddDwwAL4fZcYeHFpXwyw==
X-Received: by 2002:a05:6a20:7aaf:b0:cc:f39:5094 with SMTP id u47-20020a056a207aaf00b000cc0f395094mr10040199pzh.30.1678120734456;
        Mon, 06 Mar 2023 08:38:54 -0800 (PST)
Received: from [192.168.0.128] ([98.97.39.127])
        by smtp.googlemail.com with ESMTPSA id b4-20020aa78704000000b005a8c60ce93bsm6737372pfo.149.2023.03.06.08.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:38:54 -0800 (PST)
Message-ID: <a4a6c3381239d1297f218c5b6d01828bac016660.camel@gmail.com>
Subject: Re: [PATCH net] net/smc: fix NULL sndbuf_desc in
 smc_cdc_tx_handler()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date:   Mon, 06 Mar 2023 08:38:52 -0800
In-Reply-To: <1678073786-110013-1-git-send-email-alibuda@linux.alibaba.com>
References: <1678073786-110013-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-03-06 at 11:36 +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
>=20
> When performing a stress test on SMC-R by rmmod mlx5_ib driver
> during the wrk/nginx test, we found that there is a probability
> of triggering a panic while terminating all link groups.
>=20
> This issue dues to the race between smc_smcr_terminate_all()
> and smc_buf_create().
>=20
> 			smc_smcr_terminate_all
>=20
> smc_buf_create
> /* init */
> conn->sndbuf_desc =3D NULL;
> ...
>=20
> 			__smc_lgr_terminate
> 				smc_conn_kill
> 					smc_close_abort
> 						smc_cdc_get_slot_and_msg_send
>=20
> 			__softirqentry_text_start
> 				smc_wr_tx_process_cqe
> 					smc_cdc_tx_handler
> 						READ(conn->sndbuf_desc->len);
> 						/* panic dues to NULL sndbuf_desc */
>=20
> conn->sndbuf_desc =3D xxx;
>=20
> This patch tries to fix the issue by always to check the sndbuf_desc
> before send any cdc msg, to make sure that no null pointer is
> seen during cqe processing.
>=20
> Fixes: 0b29ec643613 ("net/smc: immediate termination for SMCR link groups=
")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>

Looking at the code for __smc_buf_create it seems like you might have
more issues hiding in the code. From what I can tell smc_buf_get_slot
can only return a pointer or NULL but it is getting checked for being
being a PTR_ERR or IS_ERR in several spots that are likely all dead
code.

> ---
>  net/smc/smc_cdc.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 53f63bf..2f0e2ee 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -114,6 +114,9 @@ int smc_cdc_msg_send(struct smc_connection *conn,
>  	union smc_host_cursor cfed;
>  	int rc;
> =20
> +	if (unlikely(!READ_ONCE(conn->sndbuf_desc)))
> +		return -EINVAL;
> +

This return value doesn't seem right to me. Rather than en EINVAL
should this be something like a ENOBUFS just to make it easier to debug
when this issue is encountered?

>  	smc_cdc_add_pending_send(conn, pend);
> =20
>  	conn->tx_cdc_seq++;


