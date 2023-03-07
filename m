Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C06AE670
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjCGQ1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjCGQ1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:27:12 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E29B46C;
        Tue,  7 Mar 2023 08:27:09 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n6so14698224plf.5;
        Tue, 07 Mar 2023 08:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678206429;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oQS9LHHzsczl10tpcOn2yO7JTno+XApneMVOiHVt3Ps=;
        b=ihQ8v/7LYz0noWajHkDjmfLGw2JEcidJ4j1EGUZm8Z4Tfznh+BD3TCEN494bycrp+o
         SPEyC5Nu36w0RpNU/FvwJMIhHXw8y7+NPELNijg0e2mfscNVlqJLSM3pM832jgDYZkoB
         t829tYqVTkPc/qrmdapAJc6zg8dFevdC8bbP9Ryba7Zib3H5GpYIbaEmqF+Scky5fb8r
         VxlK8GILzjmCqzu8wZTMT4qVEHLd383FbTxINh31YE00k4Z8Lm90AlDzfTRh9MHfTH6i
         iiNQ6Ba9tJ1wASgaJAq4n9m/L7blbKIKjmzuhblTQAdtih08bv1dH92Fn4e+WT8hFij1
         kPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678206429;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oQS9LHHzsczl10tpcOn2yO7JTno+XApneMVOiHVt3Ps=;
        b=pjJYzAsftJQswzDOuNoClm6EvFUZHZbgDIGC+uJN3SiNOGOdMFPGCvLDj5JZnhA5ty
         9o8tih9NE2j03g7Gmfx0fgT4LM++aitMKx35O5hKnb0yHyulJrBCD6K8WUmebN8x0KYv
         MYHHYAwaMmxk7eCvqbaZVgfCkXZ8ceCqwJgr5GcKsbebpuNsXenbHEmOKiXLy58ywqec
         l0uaNDpD/T0jmCX6ZmmqXMUlRZ0IR5VZxJIUYPvao5RH7JIRlMLLlbgY3deTqzaM73v5
         yT824LHnKl+jbCaniFYKD+QIByw9pyl3S/jWqiozQ0iH4rT8DrVGs4Lek8J20KepOAdH
         tSGQ==
X-Gm-Message-State: AO0yUKVWeQrC1N5JjInaa+F6q7xeRMVbOwdNoFtytYkFmj/anHz6gyD8
        N11kOxuth/y+GTYkHoYXTyM=
X-Google-Smtp-Source: AK7set/w039We3W0unfCgrfSAFnX3LU2WLHnn82tj+dU0OAlsIqcefJRmkHf3vrosKIVlFylN95XVQ==
X-Received: by 2002:a17:90a:191c:b0:237:50b6:7835 with SMTP id 28-20020a17090a191c00b0023750b67835mr15859394pjg.20.1678206429115;
        Tue, 07 Mar 2023 08:27:09 -0800 (PST)
Received: from [192.168.0.128] ([98.97.39.127])
        by smtp.googlemail.com with ESMTPSA id d88-20020a17090a6f6100b002341ae23ad7sm1451526pjk.1.2023.03.07.08.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 08:27:08 -0800 (PST)
Message-ID: <630dfe212df268d5d159f538c70dec1c9dde4397.camel@gmail.com>
Subject: Re: [PATCH net] net/smc: fix NULL sndbuf_desc in
 smc_cdc_tx_handler()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date:   Tue, 07 Mar 2023 08:27:07 -0800
In-Reply-To: <76103587-435d-159d-98b7-0c4cbedaf62e@linux.ibm.com>
References: <1678073786-110013-1-git-send-email-alibuda@linux.alibaba.com>
         <a4a6c3381239d1297f218c5b6d01828bac016660.camel@gmail.com>
         <76103587-435d-159d-98b7-0c4cbedaf62e@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-03-06 at 22:06 +0100, Wenjia Zhang wrote:
>=20
> On 06.03.23 17:38, Alexander H Duyck wrote:
> > On Mon, 2023-03-06 at 11:36 +0800, D. Wythe wrote:
> > > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > >=20
> > > When performing a stress test on SMC-R by rmmod mlx5_ib driver
> > > during the wrk/nginx test, we found that there is a probability
> > > of triggering a panic while terminating all link groups.
> > >=20
> > > This issue dues to the race between smc_smcr_terminate_all()
> > > and smc_buf_create().
> > >=20
> > > 			smc_smcr_terminate_all
> > >=20
> > > smc_buf_create
> > > /* init */
> > > conn->sndbuf_desc =3D NULL;
> > > ...
> > >=20
> > > 			__smc_lgr_terminate
> > > 				smc_conn_kill
> > > 					smc_close_abort
> > > 						smc_cdc_get_slot_and_msg_send
> > >=20
> > > 			__softirqentry_text_start
> > > 				smc_wr_tx_process_cqe
> > > 					smc_cdc_tx_handler
> > > 						READ(conn->sndbuf_desc->len);
> > > 						/* panic dues to NULL sndbuf_desc */
> > >=20
> > > conn->sndbuf_desc =3D xxx;
> > >=20
> > > This patch tries to fix the issue by always to check the sndbuf_desc
> > > before send any cdc msg, to make sure that no null pointer is
> > > seen during cqe processing.
> > >=20
> > > Fixes: 0b29ec643613 ("net/smc: immediate termination for SMCR link gr=
oups")
> > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> >=20
> > Looking at the code for __smc_buf_create it seems like you might have
> > more issues hiding in the code. From what I can tell smc_buf_get_slot
> > can only return a pointer or NULL but it is getting checked for being
> > being a PTR_ERR or IS_ERR in several spots that are likely all dead
> > code.
> >=20
> This smc_buf_get_slot() is used to get a reusable slot, which is=20
> originally assigned by smcr_new_buf_create() or smcd_new_buf_create()=20
> depending on the device being used. In=20
> smcr_new_buf_create()/smcd_new_buf_create(), the pointer values of the=
=20
> return codes are converted from integer values.

Ah, okay that is what I was missing.
