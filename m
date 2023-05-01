Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3776C6F326E
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjEAPEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbjEAPEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:04:45 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DECED;
        Mon,  1 May 2023 08:04:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b5465fb99so1992518b3a.1;
        Mon, 01 May 2023 08:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682953484; x=1685545484;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s+tJrCi2K9LEPZ9FygMAj/kUS3CL5myrUGXnzx57Uyw=;
        b=XhZ5FFPq6aL+YkLoQlTpzAcJifqf3n8sQrhL3vkrBYt8iStkWsuOvbCEaYoz+ogw4a
         zsJP0HPH4s3v+FxVm6JYUmofZLH9WaAYM1wXNg2qVGw7Oiz8Pj7ST4COj9jvML9xbk97
         0p0X/pkFFDF4ORSSKGYM5op+DNZFahLc0o+kMClgGjtE43K6ErpJFgmmc6daxYLfb2I5
         hyAGvMwN/kcj62kq+UHwhyQubqB4sf8xlShxHIt8ttf1yHZ2Nf00b9eFQaK1QSHmGO4w
         cYWKKqmOB55T5PFv7tOwvKKbzlOis7F+EqU1UBSGylJbjGDkOYr3Zv+MAPHOIG5hkVIA
         CJWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682953484; x=1685545484;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s+tJrCi2K9LEPZ9FygMAj/kUS3CL5myrUGXnzx57Uyw=;
        b=F2/vvTJY1Zt+ve7xd3SX05t6yX31GT7T4aKoHZpidNBvr9foZPX48mtEdvyXO+uw/n
         XV6ij+HoTES/+zOgLetXAOP/4IkUcE+eF9m8zCTLqbTveePFGNYRRH++pG9r7mQ8PPcJ
         gebc1HffahFuv3f5HVUeCNnGKKHx0b4uYZ3YbdM9vdA/tSxK0m0Z5bRR4RrGPIgcSlTU
         k6nSNYStWUyo2PaYt5P3m4wnt2wHXG7jphYwmF7sjgVZeLZkdGokokubiNKsFnInV810
         DWFY1HqMwfbDEGr7kV2MAb2Prfolz9KFiyaZWtbaYHiQybISqBQ4FmCJqCr1CvSjEOUH
         cTfw==
X-Gm-Message-State: AC+VfDz9iCm2AeYQAQ/jdZ53c/BXDuZ7eqcHvURDxXp9Gjqehbg1/2+D
        0R0c0z+QeWJlFHwqEIUYA0c=
X-Google-Smtp-Source: ACHHUZ4gjX+WBO4lPTvkhe29UxJdcNKRBzojgDoQ1532C46Bn2H/2fSFDxhO5yux4X8rry1kONXF6A==
X-Received: by 2002:a05:6a20:144e:b0:f3:532a:7150 with SMTP id a14-20020a056a20144e00b000f3532a7150mr18498948pzi.0.1682953484047;
        Mon, 01 May 2023 08:04:44 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.117.210])
        by smtp.googlemail.com with ESMTPSA id t20-20020a17090aba9400b0023b4d4ca3a9sm5980993pjr.50.2023.05.01.08.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 08:04:43 -0700 (PDT)
Message-ID: <c5cb682ad747ee5755ff96736c3358ebdb2c0f1c.camel@gmail.com>
Subject: Re: [PATCH v4 1/3] net: mvpp2: tai: add refcount for ptp worker
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Shmuel Hazan <shmuel.h@siklu.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
Date:   Mon, 01 May 2023 08:04:41 -0700
In-Reply-To: <20230430170656.137549-2-shmuel.h@siklu.com>
References: <20230430170656.137549-1-shmuel.h@siklu.com>
         <20230430170656.137549-2-shmuel.h@siklu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-04-30 at 20:06 +0300, Shmuel Hazan wrote:
> In some configurations, a single TAI can be responsible for multiple
> mvpp2 interfaces. However, the mvpp2 driver will call mvpp22_tai_stop
> and mvpp22_tai_start per interface RX timestamp disable/enable.
>=20
> As a result, disabling timestamping for one interface would stop the
> worker and corrupt the other interface's RX timestamps.
>=20
> This commit solves the issue by introducing a simpler ref count for each
> TAI instance.
>=20
> Due to the ref count, we need now to lock tai->refcount_lock before
> doing anything. As a result, we can't call mvpp22_tai_do_aux_work as it
> will cause a deadlock. Therefore, we will just schedule the worker to
> start immediately.
>=20
> Fixes: ce3497e2072e ("net: mvpp2: ptp: add support for receive timestampi=
ng")
> Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>
> ---
> v1 -> v2: lock tai->lock before touching poll_worker_refcount.
> v2 -> v3: no change
> v3 -> v4: added additional lock for poll_worker_refcount due to
> 	  a possible deadlock.
> ---
>  .../net/ethernet/marvell/mvpp2/mvpp2_tai.c    | 28 +++++++++++++++++--
>  1 file changed, 25 insertions(+), 3 deletions(-)
>=20

So this patch looks fine to me. However you submitted this and the
other 2 for net. The other 2 patches in this series seem to be a
feature add rather than a fix. As such you may want to split up this
set and submit the other two patches for net-next instead of net.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

