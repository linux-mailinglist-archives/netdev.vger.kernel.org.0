Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E880D15CE4F
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 23:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgBMWuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 17:50:55 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40845 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgBMWuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 17:50:54 -0500
Received: by mail-oi1-f193.google.com with SMTP id a142so7547467oii.7
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 14:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f9TNn4B9D+wG0vDxRux17HLxKH6DjAz2SY1uFe/gH+I=;
        b=D8f3/dKfafLcfMEcQTNX22uzH1xC1kXRZVV0uW7lmM4LYAy7X9MvbDJnQEEMuD1yji
         u8ZpJvb04OwMQfGNCixJACeX1BxDvKG2EHvDgrIL+k2cz51wpO8n5/gIWvRt8etRknyL
         ghkudNkb8ov+B9oxoX1LHd0BCjvdrJUWBBA7OHHXj9lV8FlplVMgce5iltTOq+v9vRjP
         sSgZC0UHe4D0ZN/n6hoyTk1tjDP8uBN1Q2D/ShUz4hUDZiS8iKk/t38nylWWHogP/a55
         2T0ASNGld+Y4WMDo3OQfnW2h7oMrTMySpRZmjAkYVmnMliVJuDNa1BsQfiP/f92hG8g7
         55pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f9TNn4B9D+wG0vDxRux17HLxKH6DjAz2SY1uFe/gH+I=;
        b=tVSlz91HfpYLOHkTn7FpCFfgelstMLOJ5+aQhUhxs2ymJchM1gZD8E04LNWvW23qiu
         NAkPcYxYNoF1EXw0jZ+U0Ts0RTxmzczezzT2zzZcEaewIuz+6WxaGTThn2uCkK7bBJA+
         8fWqcwCYkuoRzMJJ4rDz47RlayjRMHsK05RkG6ykHb85UKKDoHfefYhvV/nrK68fXtiC
         jFR2EmaZhm2K8x8ahuOnA2oksB2n0SlR021duA3zc+9vebiM5ILILfM+C/RmVrd50EZP
         nIb5pSAAkWoDkpB1LIE8atoxfcZ/7ZTvyeq+2s1joxckEE3BA56giAl96xNa9DjKJFUZ
         W1Vg==
X-Gm-Message-State: APjAAAVxOpRdhZxJnc98Jr1vmVLgOMSm2sGbWNTzIiw0zaTZnVcI6npc
        8PjXL9aw71afCe0AIBmgMs0KQKqaPiBA76fVHCH8YENj
X-Google-Smtp-Source: APXvYqzduGhXxQFHpYE4ncjzaOVG8azOS8qMMNEnfzomPqDROj/PKctS1VSUXzvgXR5P/73QjufiVBLsp+rTOD3IjOU=
X-Received: by 2002:aca:4e02:: with SMTP id c2mr4679597oib.142.1581634253922;
 Thu, 13 Feb 2020 14:50:53 -0800 (PST)
MIME-Version: 1.0
References: <1581625699-24457-1-git-send-email-jbaron@akamai.com>
In-Reply-To: <1581625699-24457-1-git-send-email-jbaron@akamai.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 13 Feb 2020 14:50:42 -0800
Message-ID: <CAM_iQpU_dbze9u2U+QjasAw6Rg3UPkax-rs=W1kwi3z4d5pwwg@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: correct flower port blocking
To:     Jason Baron <jbaron@akamai.com>
Cc:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        soukjin.bae@samsung.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 12:31 PM Jason Baron <jbaron@akamai.com> wrote:
>
> tc flower rules that are based on src or dst port blocking are sometimes
> ineffective due to uninitialized stack data. __skb_flow_dissect() extracts
> ports from the skb for tc flower to match against. However, the port
> dissection is not done when when the FLOW_DIS_IS_FRAGMENT bit is set in
> key_control->flags. All callers of __skb_flow_dissect(), zero-out the
> key_control field except for fl_classify() as used by the flower
> classifier. Thus, the FLOW_DIS_IS_FRAGMENT may be set on entry to
> __skb_flow_dissect(), since key_control is allocated on the stack
> and may not be initialized.
>
> Since key_basic and key_control are present for all flow keys, let's
> make sure they are initialized.
>
> Fixes: 62230715fd24 ("flow_dissector: do not dissect l4 ports for fragments")
> Co-developed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> ---
>  include/linux/skbuff.h | 8 ++++++++
>  net/sched/cls_flower.c | 1 +
>  2 files changed, 9 insertions(+)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index ca8806b..f953bfa 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1288,6 +1288,14 @@ bool __skb_flow_dissect(const struct net *net,
>                         void *data, __be16 proto, int nhoff, int hlen,
>                         unsigned int flags);
>
> +static inline void
> +skb_flow_dissect_init_key(struct flow_dissector_key_control *key_control,
> +                         struct flow_dissector_key_basic *key_basic)
> +{
> +       memset(key_control, 0, sizeof(*key_control));
> +       memset(key_basic, 0, sizeof(*key_basic));
> +}

I think this function has nothing to do with skb, therefore it fits
better in include/net/flow_dissector.h? And remove skb prefix from
its name too.

Other than this:

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
