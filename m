Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EF0FD3BE
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 05:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKOEmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 23:42:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbfKOEmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 23:42:35 -0500
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 842122072E;
        Fri, 15 Nov 2019 04:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573792954;
        bh=g3rlB32/6gd8dD5fY3MmF2bhvO5L4Q8Y+YT4GjFr3wQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KGrd5zOZNBxWzcSvrPXyvSbFC3vxoGQoxybEK02Kveb4aW4JhvHNhVZ8hWxpFpRsY
         nMc+/3ukHPjrlhfLtZM4uxDLglMA/kI06ihg4EoH25/6ElqmesHF4JwyKppZ1mic7B
         H4tNC+rKqauChwU3xSHJPphJwawp0FskLwe2C62Q=
Received: by mail-qv1-f46.google.com with SMTP id i3so3335053qvv.7;
        Thu, 14 Nov 2019 20:42:34 -0800 (PST)
X-Gm-Message-State: APjAAAVVZ8sgkdg/IHsDuT1D/oFnje4MZeGr8St0SBSyZZjKLXPrhFs8
        A/Yd9CfowdKapZzj/FwRfPkKjJO6WT+b5crpWBs=
X-Google-Smtp-Source: APXvYqzhjv5G4OmRuommd+stX/u8tXaIf+kgtocwlFijjGY3iPO27FpXOJ5UgCEDdEl/zBvDultfDqkQncbaw+8Q4dM=
X-Received: by 2002:ad4:462d:: with SMTP id x13mr11789533qvv.105.1573792953648;
 Thu, 14 Nov 2019 20:42:33 -0800 (PST)
MIME-Version: 1.0
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk> <20191108130123.6839-46-linux@rasmusvillemoes.dk>
In-Reply-To: <20191108130123.6839-46-linux@rasmusvillemoes.dk>
From:   Timur Tabi <timur@kernel.org>
Date:   Thu, 14 Nov 2019 22:41:55 -0600
X-Gmail-Original-Message-ID: <CAOZdJXUibQ6RM8O4CfkYBdGsg+LMcE2ZoZEQ4txn2yvquUWwCA@mail.gmail.com>
Message-ID: <CAOZdJXUibQ6RM8O4CfkYBdGsg+LMcE2ZoZEQ4txn2yvquUWwCA@mail.gmail.com>
Subject: Re: [PATCH v4 45/47] net/wan/fsl_ucc_hdlc: reject muram offsets above 64K
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 7:04 AM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:

> diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
> index 8d13586bb774..f029eaa7cfc0 100644
> --- a/drivers/net/wan/fsl_ucc_hdlc.c
> +++ b/drivers/net/wan/fsl_ucc_hdlc.c
> @@ -245,6 +245,11 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
>                 ret = -ENOMEM;
>                 goto free_riptr;
>         }
> +       if (riptr != (u16)riptr || tiptr != (u16)tiptr) {

"riptr/tiptr > U16_MAX" is clearer.
