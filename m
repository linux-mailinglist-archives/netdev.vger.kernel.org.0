Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6BF77815
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbfG0KMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:12:52 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35610 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbfG0KMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:12:51 -0400
Received: by mail-ed1-f65.google.com with SMTP id w20so55263309edd.2
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 03:12:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JBkZcip8PdD34NFoetd7Swbs2DuMQAqr62FuUN1slVU=;
        b=NENuTmX6zzs7nz6Sb1fbEJAdifO3NKCx9gsCluq/0kdyLiUSuvjNov5gdpUmvFP3sL
         GVhTKM0z7xg8feTxGR5zJrp2mCjXUqlb3T1/dBKaArjjx06+OSeVA6eQcS5/BLw+cwFZ
         Ua5oai3dKVn6Mr2UJ0HebeF14YAemhNVaWV2NI+NRNEyL390vKmFf6OR5X/J5MM+Pggt
         eBqiphCZFhq9Q3DlomcxrerW26JH3N1J367YOamryMAdpPt/rbNYMx98ZsKOMET7gvwH
         hgHGh2n0NoGMnFrzhLmLBz9vJJDRc94z6iv0UDqI+YBn/ldi0QkQ+08S1le84nYLPzau
         d7qA==
X-Gm-Message-State: APjAAAXeADr5qWsaYqyBIoEcTvkdwEM3Itvq5JDOsqfhjyOZsvmvi9n0
        LmsIAVysAjjDdxfiU1WnyIrWvg==
X-Google-Smtp-Source: APXvYqyfh20gE1xoyfIorUBeyJupr05Qs0jKAFZUiLE3sVl/vRnuGKK7zJnQqsB3ek3R3m3ePryP6A==
X-Received: by 2002:a50:d8cf:: with SMTP id y15mr86176822edj.213.1564222370262;
        Sat, 27 Jul 2019 03:12:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id j16sm10725505ejq.66.2019.07.27.03.12.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 03:12:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E8CB91800C5; Sat, 27 Jul 2019 12:12:48 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2 1/2] devlink: introduce cmdline option to switch to a different namespace
In-Reply-To: <20190727100544.28649-1-jiri@resnulli.us>
References: <20190727094459.26345-1-jiri@resnulli.us> <20190727100544.28649-1-jiri@resnulli.us>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 27 Jul 2019 12:12:48 +0200
Message-ID: <87ef2bwztr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Pirko <jiri@resnulli.us> writes:

> From: Jiri Pirko <jiri@mellanox.com>
>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  devlink/devlink.c  | 12 ++++++++++--
>  man/man8/devlink.8 |  4 ++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index d8197ea3a478..9242cc05ad0c 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -32,6 +32,7 @@
>  #include "mnlg.h"
>  #include "json_writer.h"
>  #include "utils.h"
> +#include "namespace.h"
>  
>  #define ESWITCH_MODE_LEGACY "legacy"
>  #define ESWITCH_MODE_SWITCHDEV "switchdev"
> @@ -6332,7 +6333,7 @@ static int cmd_health(struct dl *dl)
>  static void help(void)
>  {
>  	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
> -	       "       devlink [ -f[orce] ] -b[atch] filename\n"
> +	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns]
>  netnsname\n"

'ip' uses lower-case n for this; why not be consistent?

-Toke
