Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356C36B7E4A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjCMQ5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjCMQ5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:57:04 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BF65504B;
        Mon, 13 Mar 2023 09:56:43 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id ay18so8057900pfb.2;
        Mon, 13 Mar 2023 09:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678726602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HaV/+YukF9fT9fud42iokP2NQAvW1bVr66fpL0PEARs=;
        b=kB6oE5AAjFAcjGKrhJ/lB5gxApvHCDri2aS+7ma0lgfqI+f8Hrw5eh8cb0kQnNhokr
         MD75RticHcRvy47ovyCkOgAXgiB0CZE2Siibx7xZ0QZNXiP5lC6+/BHWDe87HpgolJGR
         S37RoM2khOliB/iG0f6zVhsBodhw3hvbXe2ryit+ABbTRMFevQHy9ijO2nSC51jaus4T
         L8Chce50S5SCzqi4SWulsQ2xr/bofwKDPtOoNzzH/+WwFKzeEr4MmP2MhkitcubeBc7M
         SqFZS+cLX9r5OcP+ICLEKrxTcCbRdzqkscedb2nw0Xf59UE9MDa1YD9GM5X96vUXPQly
         ERUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678726602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HaV/+YukF9fT9fud42iokP2NQAvW1bVr66fpL0PEARs=;
        b=TY+IJAnic1uv1eG8DnXPeB1+njSY4FI1LUnFh7D3Cz0SrTrEE0H7jkoPogxfx+OhQv
         cRVqK/XkbLJBy6CGAe7945GEFFOR88eiBWGaMXqRItqEmoPOnjtdNGCEvcZ4nnVpYht1
         58DSPMCt5I+IU+WZvxzPgDWE/5uojDUGsab9tbiiuOBUY3roRyvZy7CbdQcYjAmRq32l
         nVOU+cWRY65p/Ep6d25UT2tNjGljjlvim1dC+KSqxbXqlLd6UoTir9SSILA0rCHd5o1d
         bf6gEo7HUFKAsv7BFBYjBfGzoRSOB1eMXbDRQBcUms5SMUd5VHguZuh8KReHyMyfx6SQ
         hufw==
X-Gm-Message-State: AO0yUKUgPOr0l5Tl7Pf0oj0uSll11MMNE7DlWUg2ry4V/G9qk6Ni5k0H
        uHdUaiNkh4HG13cMNBolhiVqA5MHBK5XpkBNplc=
X-Google-Smtp-Source: AK7set8VRFOtLY8qVIfm5icjabtDYuZtkmF+Cytw1G/oVWBUTt79Sg9pV/dNK6OGyM3m8fVj1NCKwnb8QtYutfzppjY=
X-Received: by 2002:a63:f0a:0:b0:502:f5c8:a00c with SMTP id
 e10-20020a630f0a000000b00502f5c8a00cmr11257951pgl.9.1678726602586; Mon, 13
 Mar 2023 09:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230312160837.2040857-1-zyytlz.wz@163.com> <a16b8715-2962-4094-4d50-59d673f455e2@linaro.org>
In-Reply-To: <a16b8715-2962-4094-4d50-59d673f455e2@linaro.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Tue, 14 Mar 2023 00:56:31 +0800
Message-ID: <CAJedcCz1vazA0NPrA69C0DqqTM742YwNXMshwY_9Uiy08XEtOg@mail.gmail.com>
Subject: Re: [PATCH] nfc: st-nci: Fix use after free bug in ndlc_remove due to
 race condition
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> =E4=BA=8E2023=E5=B9=B4=
3=E6=9C=8813=E6=97=A5=E5=91=A8=E4=B8=80 14:52=E5=86=99=E9=81=93=EF=BC=9A
>
> On 12/03/2023 17:08, Zheng Wang wrote:
> > This bug influences both st_nci_i2c_remove and st_nci_spi_remove.
> > Take st_nci_i2c_remove as an example.
> >
> > In st_nci_i2c_probe, it called ndlc_probe and bound &ndlc->sm_work
> > with llt_ndlc_sm_work.
> >
> > When it calls ndlc_recv or timeout handler, it will finally call
> > schedule_work to start the work.
> >
> > When we call st_nci_i2c_remove to remove the driver, there
> > may be a sequence as follows:
> >
> > Fix it by finishing the work before cleanup in ndlc_remove
>
>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>

Thanks for the detailed review.

Best regards,
Zheng

> Best regards,
> Krzysztof
>
