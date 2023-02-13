Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F208693F7C
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 09:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjBMIWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 03:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjBMIWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 03:22:17 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD2D1285D;
        Mon, 13 Feb 2023 00:22:11 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k13so12793938plg.0;
        Mon, 13 Feb 2023 00:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Cc8oF+7BeFkTvl0tiR5ilyaJsXX8cQAcNRTUnSXCuQ=;
        b=VAptGiqps+dmcLjKqESSax0nsydlcGffI+aeuewHs7zeVP8k792ryUoTO/lifmMFHG
         6+khFc3eFXA7ip8sGiWRHW7Dm5Hr/9kWqTGRqEd7yquopVGS3/kg/SgEY+aQrvZ52rtv
         tQsMZ191fqzbgsi++mUddK+fI0sKdyyO+RlyJd5qR8JO5bNwfPXrDB493zUOctLZvDYh
         2rq5GxVzq7SUWH9twM5e4V2xgCpDCC8REg1C3Abu5yzYy/NuW5ajMCczxfFZqvRzL2B5
         wiTDjTlvk12G1tI7/2/izzh8N65JAOdzOePjPG+QPRnFK7wKJ/8gBgdBvIdvzytxIwbN
         k+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Cc8oF+7BeFkTvl0tiR5ilyaJsXX8cQAcNRTUnSXCuQ=;
        b=Iv0Iz7fD1c6PXxMbGxBrcHb7FlW80ShoR0sN2GHyZfWQFQKYEj8ix7tHxRdymB53Ak
         ACSdKmc9V92GcB6qqaPwc1zC8wEJVgL88TNFiJfr5fHydlguKMuMndUH4XrTXEdK0zKZ
         28n5Bj2bxgTCDG93FB9r2Wk3TIvCti+dYaIvQZzSHLdioEMd45pJq7AVUru++cd2iT7/
         fVmwvlVQL26AxIYVNxOQkuIl8oJqSeqt2B137qbxy8+sZLmUhmJjaHf74bJ/uSv/4fIi
         O3DWOjcEtc/d/NmjR/LuOvqtI8e7lDjqS9gPbCRTnoPSdrbLvuWl0JwlvkS+n3YU900X
         NK3Q==
X-Gm-Message-State: AO0yUKWv+KVpR0BnbcAwEvHrZfqmxc5iuaSDFz+t1yWHYZxp8jY/V1qo
        EqYBO78yNaw9CSTtVSc3eLlVbXeWWAFt8ZBIeKB1G9P0LsuHvA==
X-Google-Smtp-Source: AK7set+4dh1XshE8gce5zGUW9rPYY15T59wx4nemxaVNdbh+uY9RR+5EIHm0X46Dws3T8NdcyNTKIxuPr5MFua5vTC8=
X-Received: by 2002:a17:902:c40c:b0:198:f92d:9a2c with SMTP id
 k12-20020a170902c40c00b00198f92d9a2cmr5586324plk.2.1676276530208; Mon, 13 Feb
 2023 00:22:10 -0800 (PST)
MIME-Version: 1.0
References: <20230210041030.865478-1-zyytlz.wz@163.com> <868017d2-c85f-20a1-292f-0b97ab8bf752@molgen.mpg.de>
In-Reply-To: <868017d2-c85f-20a1-292f-0b97ab8bf752@molgen.mpg.de>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Mon, 13 Feb 2023 16:21:58 +0800
Message-ID: <CAJedcCx9Ur4a7isrEEDRaCThq2T=3=Z9b1dmfjUNh5qABkdBqg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_core: Fix poential Use-after-Free bug in hci_remove_adv_monitor
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Zheng Wang <zyytlz.wz@163.com>, marcel@holtmann.org,
        alex000young@gmail.com, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Paul Menzel <pmenzel@molgen.mpg.de> =E4=BA=8E2023=E5=B9=B42=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=B8=80 16:19=E5=86=99=E9=81=93=EF=BC=9A
>
> Dear Zheng,
>
>
> Thank you for your patch.
>
> Am 10.02.23 um 05:10 schrieb Zheng Wang:
> > In hci_remove_adv_monitor, if it gets into HCI_ADV_MONITOR_EXT_MSFT cas=
e,
> > the function will free the monitor and print its handle after that.
> >
> > Fix it by switch the order.
>
> =E2=80=A6 by switch*ing* =E2=80=A6
>
> There is a small typo in the commit message summary/title: po*t*ential
>
Hi Paul,

Thanks for pointing that out ^^. Will correct it in the next version of pat=
ch.

Best regards,
Zheng Wang
