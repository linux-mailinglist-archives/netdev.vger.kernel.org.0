Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73718FD734
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfKOHoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:44:17 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42964 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfKOHoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 02:44:16 -0500
Received: by mail-lj1-f194.google.com with SMTP id n5so9605414ljc.9
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 23:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MerzeYQd7mMrWj7xug82ip0Zzuk57QC86rO5mCSsEzs=;
        b=cimPOY7g4EAlwVyfr4cwpdgRJdBwRgLjtx/sUwL01IBFA4qPtm6hLBgyIKILrFzJM9
         xiOtbLJf0y4FyFS5wuHNxaB4q8sFK2F7P67/5/RQWCsQ9oGFBnDTdc4D+B26iZzap9Qa
         gTUwq1Rz9t3IIvqDWNeazaS9zPcEWsGD6g1ZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MerzeYQd7mMrWj7xug82ip0Zzuk57QC86rO5mCSsEzs=;
        b=LV3LpXQeuzT5d271eNPkfW/mNc+SPMtbjQ+Hhi5ulLH/eqjm/nME/tzJlZqoJA7GoM
         BE40+VeJUzHrb0xWzJtBGLuR2igvCDYzJ4WnfL6Fe6f8jjaoH3hvBxSP9ezvf2ZoY9vc
         DIHvMZMR1+tphPu3I9HjL/WyCaFxm26Ea3gjvoVl6NGKLGJWe/jsZtgtzFn/AbLm8Vyd
         Jmgjyt3YBAJD11ks+SGlhLJx3q4CAi19Pg/eXeRXSnr9udr8W1gKVrURW77C9LHJVla8
         rPAVOio2dS9Mo4uv6+ysuoPJGXCri2Kn6q99y5+d9195EWG+nTNgZ5+VNFzCQUAfCySu
         9KGg==
X-Gm-Message-State: APjAAAU1BlaTTkPWK9ZnQV9Y3eM3eDVZbZUd8DhGgeOvhg16ajAym+pR
        W6b36OJsZfUjSES+Yca+NX/kYK9pgd4k4TP5
X-Google-Smtp-Source: APXvYqw8OAiLBu508szXHtSnz3QQioa3U2uijYFbTHFzEtm/A+7bHMI6CgvxmnwrGknlwyb2z4HUYw==
X-Received: by 2002:a2e:9784:: with SMTP id y4mr10091304lji.77.1573803854082;
        Thu, 14 Nov 2019 23:44:14 -0800 (PST)
Received: from [172.16.11.28] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id p19sm3689755lji.65.2019.11.14.23.44.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 23:44:13 -0800 (PST)
Subject: Re: [PATCH v4 45/47] net/wan/fsl_ucc_hdlc: reject muram offsets above
 64K
To:     Timur Tabi <timur@kernel.org>
Cc:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>, netdev <netdev@vger.kernel.org>
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
 <20191108130123.6839-46-linux@rasmusvillemoes.dk>
 <CAOZdJXUibQ6RM8O4CfkYBdGsg+LMcE2ZoZEQ4txn2yvquUWwCA@mail.gmail.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <79101f00-e3ff-9dd0-7a05-760f8be1ff69@rasmusvillemoes.dk>
Date:   Fri, 15 Nov 2019 08:44:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAOZdJXUibQ6RM8O4CfkYBdGsg+LMcE2ZoZEQ4txn2yvquUWwCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/11/2019 05.41, Timur Tabi wrote:
> On Fri, Nov 8, 2019 at 7:04 AM Rasmus Villemoes
> <linux@rasmusvillemoes.dk> wrote:
> 
>> diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
>> index 8d13586bb774..f029eaa7cfc0 100644
>> --- a/drivers/net/wan/fsl_ucc_hdlc.c
>> +++ b/drivers/net/wan/fsl_ucc_hdlc.c
>> @@ -245,6 +245,11 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
>>                 ret = -ENOMEM;
>>                 goto free_riptr;
>>         }
>> +       if (riptr != (u16)riptr || tiptr != (u16)tiptr) {
> 
> "riptr/tiptr > U16_MAX" is clearer.
> 

I can change it, sure, but it's a matter of taste. To me the above asks
"does the value change when it is truncated to a u16" which makes
perfect sense when the value is next used with iowrite16be(). Using a
comparison to U16_MAX takes more brain cycles for me, because I have to
think whether it should be > or >=, and are there some
signedness/integer promotion business interfering with that test.

Rasmus
