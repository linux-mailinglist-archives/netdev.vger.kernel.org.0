Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09B32F2E71
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731516AbhALLx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbhALLx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 06:53:28 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A353C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 03:52:48 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 190so1666740wmz.0
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 03:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HrmXQ1okfje8zqIQ10PW4lfsYsRk31PRkCy/11hGlqQ=;
        b=tLYSV9ka2KI+pcVTRquc0d94IMleQ0PXSQ4BU+exv+ejC7M4ILmCFnoLfC8pqj4y4/
         wXVNwMn0RdBTgd7tiSsKII7qvhQuH6LHSUxK8q1rPv+gegmOizP+s/UVGKHg2bEm8mru
         HD9tLV+SU/Vjc/d3+04Xja1UF3LdFEHm1PnTtQ/wtdejXrbmQRlwCQaXZL0ufTxHOIM9
         7C6YURD+8IH23LIUdB4WCEuIJ4CSlZPxulLl2mW+UP1P2ifInDqdO4BLd5pw4EPIUAQx
         HXLNxLWM66nfjRzZDP9z4+A2oxZLoTEY/3LITdWcRQ+PaaoGMwvI0EPuqClpfCMFPPx8
         psmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HrmXQ1okfje8zqIQ10PW4lfsYsRk31PRkCy/11hGlqQ=;
        b=At6YxI2CCZtjb456cDo7piRV8RyrDdxC0T+RrSnHXaXMxbR0DhtWwGqaB7Pk9rbjUq
         c8nNsBcUy6VdplwzmcxzaLWPn9D8ictx4zxBPkPz737lYNSvgcf4STY0VZOET/oyo6Ol
         gWlh1t99KUtUJwJMAmDhpI2HwJA9B04LY2WsqQhUxC2RuN/F3NecCGH8WFL2+oFAYNp5
         grlucdKyWm2IVbLnDhRQFI9vqZaAOmsk3PVdBcvQNdcDfJKwSl2/wB+pUcSA/CcwXnkZ
         gjSMuXcCiNxPZbcDYE53VJa9XJWQiEonnP4/uuCWaZqeGFQJU2Ifbmw+ablym0dpDg8Z
         nYow==
X-Gm-Message-State: AOAM5315jm+WYzT0HKnKql9AmI8CMONK8Ji7QbfcU2kKTFio/uA1Zi3w
        VlL0NRtZXad+gpPJYSMsCr4X+pM1APr/Kqh53FuWcMiq0tSVdw==
X-Google-Smtp-Source: ABdhPJwKh8dImN/sNZg1tYK+4VB8N98UwS3LWi5tjLxis4SqtcDOq2qWrb0idEfv02BsXPdP8VwGMOJ1mbRu+U2jr5s=
X-Received: by 2002:a1c:2483:: with SMTP id k125mr3234380wmk.67.1610452367161;
 Tue, 12 Jan 2021 03:52:47 -0800 (PST)
MIME-Version: 1.0
References: <20210112025548.19107-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210112025548.19107-1-xiyou.wangcong@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 12 Jan 2021 19:52:35 +0800
Message-ID: <CADvbK_dvG9LNTTxh9R4QYO_0UHjKTvxaccb2AingaAzyXpzp4g@mail.gmail.com>
Subject: Re: [Patch net] cls_flower: call nla_ok() before nla_next()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 10:56 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> fl_set_enc_opt() simply checks if there are still bytes left to parse,
> but this is not sufficent as syzbot seems to be able to generate
> malformatted netlink messages. nla_ok() is more strict so should be
> used to validate the next nlattr here.
>
> And nla_validate_nested_deprecated() has less strict check too, it is
> probably too late to switch to the strict version, but we can just
> call nla_ok() too after it.
>
> Reported-and-tested-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
> Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
> Cc: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Xin Long <lucien.xin@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/sched/cls_flower.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 1319986693fc..e265c443536e 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -1272,6 +1272,8 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
>
>                 nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
>                 msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> +               if (!nla_ok(nla_opt_msk, msk_depth))
> +                       return -EINVAL;
>         }
I think it's better to also add  NL_SET_ERR_MSG(extack, xxxx);
for this error return, like all the other places in this function.

>
>         nla_for_each_attr(nla_opt_key, nla_enc_key,
> @@ -1308,7 +1310,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
>                                 return -EINVAL;
>                         }
>
> -                       if (msk_depth)
> +                       if (nla_ok(nla_opt_msk, msk_depth))
>                                 nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
>                         break;
>                 case TCA_FLOWER_KEY_ENC_OPTS_VXLAN:
> @@ -1341,7 +1343,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
>                                 return -EINVAL;
>                         }
>
> -                       if (msk_depth)
> +                       if (nla_ok(nla_opt_msk, msk_depth))
>                                 nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
>                         break;
>                 case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
> @@ -1374,7 +1376,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
>                                 return -EINVAL;
>                         }
>
> -                       if (msk_depth)
> +                       if (nla_ok(nla_opt_msk, msk_depth))
>                                 nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
>                         break;
>                 default:
> --
> 2.25.1
>
