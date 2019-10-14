Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958F3D68EA
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbfJNR5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:57:55 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46432 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbfJNR5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:57:54 -0400
Received: by mail-pl1-f196.google.com with SMTP id q24so8312363plr.13;
        Mon, 14 Oct 2019 10:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TcYwlh8m3rpWuvsgEGDkIAHPtWJgLexaUieVa+euzDE=;
        b=H09Y8AeHXNPww5ZTPyskS0U8BkXT6T/s7oAw66f1FBkQzznWYU7d7Z3Le+gLVUH8OG
         ihgN/JetUuPSBO4ZUqUBOaxPRjAbJxSDUSON6lLJ+r1tngmnE6RYx2iOYp4MnoZB0Hv3
         YcCUy9/AH+nujDIP0yurBRxNrYCe5qYTbHQb6sVC1J9CaLpAb6pR2e2Tq4xdssZ+Vljc
         h/V8Ghl7tADXhjuMxRMV6gv1mvfBv1rd2knhJGaIVjJ3w5hZ+G93rYGNYtG/HRq6L1L+
         x2AxvWIlYjFfP1d6MI5DlJroaJwmcw95HDFANcwj57hFbmJq2a4Se8WgNSjmGmXs6nzB
         FEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TcYwlh8m3rpWuvsgEGDkIAHPtWJgLexaUieVa+euzDE=;
        b=uhgIr/nlmj4L465eVvO7cCYZVt2jBBJkRTvXG95OI695dyMQ4phSmm91UNRBfvviK9
         ruLM5s0Ibyuzq5FUXR3gbHEHyK5cvwE0BnMTYfTyD84RF9HDifq8MokOQnyDxfH6jtg8
         2aYuAExieYcfKXaoEbho+PyQE3TgZp1191Am7niV20qMmtgp6OJoFEKI3stcKiX9lLAN
         BFuf/dhp94ma1uibnWb2SNbrVO5u9hW0VNP7kvgnfjq7XrK8fpSDX2RdBTa7bU8B+drX
         Qj36h7QwC4GT5MsDb0nyYHquz/255TMsZbmukpklZUafAp5BVifa8+88Bi0qM5Pv6ge9
         m7Fg==
X-Gm-Message-State: APjAAAW/Y0jHB8U6U0NyFQGX/v7qlmqTPPKHd5DmYz1RpXMQPXF2Qf4B
        WjeCVaPe2kxbeMzeFnnpODQ98v1tXG5wG3gNy7b9FA==
X-Google-Smtp-Source: APXvYqxWbGeBp4YRa3Fv9Y2Tk+Lbfd+KmSMX2LOdqziPoZIrmUhQ4caKBRlBJXevhj+iuMM7w/X1cyxsYVJ3g3zIL5A=
X-Received: by 2002:a17:902:321:: with SMTP id 30mr31388615pld.61.1571075873894;
 Mon, 14 Oct 2019 10:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
In-Reply-To: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 14 Oct 2019 10:57:42 -0700
Message-ID: <CAM_iQpVkTb6Qf9J-PuXJoQTZa5ojN_oun64SMv9Kji7tZkxSyA@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: act_mirred: drop skb's dst_entry in
 ingress redirection
To:     Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 12:16 AM Zhiyuan Hou
<zhiyuan2048@linux.alibaba.com> wrote:
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index 9ce073a05414..6108a64c0cd5 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -18,6 +18,7 @@
>  #include <linux/gfp.h>
>  #include <linux/if_arp.h>
>  #include <net/net_namespace.h>
> +#include <net/dst.h>
>  #include <net/netlink.h>
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
> @@ -298,8 +299,10 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>
>         if (!want_ingress)
>                 err = dev_queue_xmit(skb2);
> -       else
> +       else {
> +               skb_dst_drop(skb2);
>                 err = netif_receive_skb(skb2);
> +       }

Good catch!

I don't want to be picky, but it seems this is only needed
when redirecting from egress to ingress, right? That is,
ingress to ingress, or ingress to egress is okay? If not,
please fix all the cases while you are on it?

Thanks.
