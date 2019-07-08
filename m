Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25DD62145
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfGHPN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:13:59 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45653 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfGHPN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:13:59 -0400
Received: by mail-ed1-f68.google.com with SMTP id e2so8142182edi.12
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 08:13:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VoEGvRZIbR2MT8Tlaag7Yj92AA+lSowumqLl0+Yfn5M=;
        b=CoEPCH+zQjFdrgcByJryhM28ai0t6vp5d/MMsQJCkCN7SRZn5p4MWIbbj0FrTDmkNe
         IXZ3o53t+w0rBy3feXhIF4UVfS9e0dCOZLRpUuj9ZBZ2Z11Jm5xY6mLY8R4BrkvA7tcd
         I/iBofibdMEbOV64l+k9zBs+589JRQfWQn2HVpfZS31ozc9MAxKsosgD0Si/2aiWjmEO
         5yNC9DCAQUSfCxGyHZLEPEbzCFnUx7YIO+3M+5Q/6+ObryG0qncZBqsm6U9FNgOb/9AY
         AhtHPLSROFsmGap513/YgZNZaArop0ndwosISiLYcsztnvsKBQ+ER6nboCVmFxov+B0Q
         ILcA==
X-Gm-Message-State: APjAAAWjc1dVCxeAayc07SQvTHfS+NPug1EgBRxuwZpAKrBZpUX8fcm6
        mkzHwjOkDQntLtB7f5IeIXnXKRxVo1vjXvVQK9Dmy57EKIc=
X-Google-Smtp-Source: APXvYqwhVgEmtWDr+IpH8/xVS+iawRTvMl/fWqGUcyTam4w+8KN9+yoA0ftyJ+QH1vTh2W0W78X0DQoSKxHoblgCPCM=
X-Received: by 2002:a17:906:2101:: with SMTP id 1mr16795278ejt.182.1562598837949;
 Mon, 08 Jul 2019 08:13:57 -0700 (PDT)
MIME-Version: 1.0
References: <f1535e547aa6da8216ca2a0da7c06b645a132929.1562578533.git.aclaudi@redhat.com>
In-Reply-To: <f1535e547aa6da8216ca2a0da7c06b645a132929.1562578533.git.aclaudi@redhat.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Mon, 8 Jul 2019 17:14:49 +0200
Message-ID: <CAPpH65xb5cnqpTP5mNsT28wf6103hkM+Ega7D1EbyFffce=ixw@mail.gmail.com>
Subject: Re: [PATCH iproute2] ip-route: fix json formatting for metrics
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 11:38 AM Andrea Claudi <aclaudi@redhat.com> wrote:
>
> Setting metrics for routes currently lead to non-parsable
> json output. For example:
>
> $ ip link add type dummy
> $ ip route add 192.168.2.0 dev dummy0 metric 100 mtu 1000 rto_min 3
> $ ip -j route | jq
> parse error: ':' not as part of an object at line 1, column 319
>
> Fixing this opening a json object in the metrics array and using
> print_string() instead of fprintf().
>
> This is the output for the above commands applying this patch:
>
> $ ip -j route | jq
> [
>   {
>     "dst": "192.168.2.0",
>     "dev": "dummy0",
>     "scope": "link",
>     "metric": 100,
>     "flags": [],
>     "metrics": [
>       {
>         "mtu": 1000,
>         "rto_min": 3
>       }
>     ]
>   }
> ]
>
> Fixes: 663c3cb23103f ("iproute: implement JSON and color output")
> Fixes: 968272e791710 ("iproute: refactor metrics print")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  ip/iproute.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/ip/iproute.c b/ip/iproute.c
> index 1669e0138259e..2f9b612b0b506 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -578,6 +578,7 @@ static void print_rta_metrics(FILE *fp, const struct rtattr *rta)
>         int i;
>
>         open_json_array(PRINT_JSON, "metrics");
> +       open_json_object(NULL);
>
>         parse_rtattr(mxrta, RTAX_MAX, RTA_DATA(rta), RTA_PAYLOAD(rta));
>
> @@ -611,7 +612,7 @@ static void print_rta_metrics(FILE *fp, const struct rtattr *rta)
>                         print_rtax_features(fp, val);
>                         break;
>                 default:
> -                       fprintf(fp, "%u ", val);
> +                       print_uint(PRINT_ANY, mx_names[i], "%u ", val);
>                         break;
>
>                 case RTAX_RTT:
> @@ -639,6 +640,7 @@ static void print_rta_metrics(FILE *fp, const struct rtattr *rta)
>                 }
>         }
>
> +       close_json_object();
>         close_json_array(PRINT_JSON, NULL);
>  }
>
> --
> 2.20.1
>

Sorry, I forgot to add:
Reported-by: Frank Hofmann <fhofmann@cloudflare.com>

Regards,
Andrea
