Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C17FD77823
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfG0KZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:25:13 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40231 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfG0KZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:25:13 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so55281506eds.7
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 03:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gRkoR81Uu5EiiHCvSASeMQn+rAcZzE3EOi2+08buUhM=;
        b=WLREo7XdRmHojfIKbw5P6B9qW4RqEuW5FDJR1VqMxUvlIKoNrcEJgPO1YGv18HV3sW
         iPDDhoR/49xnn9ojpio8Pmk4nEeBVeo8ERzUPStFSIFjAHWi2ZNUc8Lak4krq16vcIn1
         W4MU1u7tGOzwJ3NJQSMNokiH3i1SZCTWK+zC21AUjLhUYJfPW5+Nj0jatmg7FUiJMdkO
         bXSdoNy9S0H4vAAmFauLDU9E2pKrYBHB5Uw+7MyHvt5G06pJY6ib/ES9j2qjQmKTbciX
         mq3Tk4YolFFtmvL1T8muzz8tylT/B6RHP4pmzq33zfaAwy4hflo9fxyPzBPTPq/pOBZs
         VYzA==
X-Gm-Message-State: APjAAAVWwD+ATv6isGDBZY1P8hDSV0NXZ/IKzGDYQm1bcUf/1dUP7RNj
        wTaZWKdV2fG7WOfCJuTAq7p1oR9YWDE=
X-Google-Smtp-Source: APXvYqxfgvdCQsk/WGaZtym0pWET2OA5SCXzb4sRRw5OXfrQhg3Q75+uUM1PJ5cUscOsDOw27qXnQQ==
X-Received: by 2002:a50:b617:: with SMTP id b23mr86501083ede.135.1564223111914;
        Sat, 27 Jul 2019 03:25:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b53sm14785413edd.45.2019.07.27.03.25.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 03:25:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 64BFB1800C5; Sat, 27 Jul 2019 12:25:10 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2 1/2] devlink: introduce cmdline option to switch to a different namespace
In-Reply-To: <20190727102116.GC2843@nanopsycho>
References: <20190727094459.26345-1-jiri@resnulli.us> <20190727100544.28649-1-jiri@resnulli.us> <87ef2bwztr.fsf@toke.dk> <20190727102116.GC2843@nanopsycho>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 27 Jul 2019 12:25:10 +0200
Message-ID: <87a7czwz95.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Pirko <jiri@resnulli.us> writes:

> Sat, Jul 27, 2019 at 12:12:48PM CEST, toke@redhat.com wrote:
>>Jiri Pirko <jiri@resnulli.us> writes:
>>
>>> From: Jiri Pirko <jiri@mellanox.com>
>>>
>>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>>> ---
>>>  devlink/devlink.c  | 12 ++++++++++--
>>>  man/man8/devlink.8 |  4 ++++
>>>  2 files changed, 14 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/devlink/devlink.c b/devlink/devlink.c
>>> index d8197ea3a478..9242cc05ad0c 100644
>>> --- a/devlink/devlink.c
>>> +++ b/devlink/devlink.c
>>> @@ -32,6 +32,7 @@
>>>  #include "mnlg.h"
>>>  #include "json_writer.h"
>>>  #include "utils.h"
>>> +#include "namespace.h"
>>>  
>>>  #define ESWITCH_MODE_LEGACY "legacy"
>>>  #define ESWITCH_MODE_SWITCHDEV "switchdev"
>>> @@ -6332,7 +6333,7 @@ static int cmd_health(struct dl *dl)
>>>  static void help(void)
>>>  {
>>>  	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
>>> -	       "       devlink [ -f[orce] ] -b[atch] filename\n"
>>> +	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns]
>>>  netnsname\n"
>>
>>'ip' uses lower-case n for this; why not be consistent?
>
> Because "n" is taken :/

Ah, right, that was right there on the line below in the patch context.
Oops, by bad (and too bad!)

-Toke
