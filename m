Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A583D30309
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfE3T5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:57:07 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38059 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfE3T5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:57:07 -0400
Received: by mail-ed1-f66.google.com with SMTP id g13so10811475edu.5
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 12:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sqQgNcqFZySjAPmekC69cdPorwQrCLLU9gQX96lOKoU=;
        b=IYPDEL2JsQcDXAz0Rq6zN/Wi78w91Br9z3IDDDsqARAZpFCjr0XmGWqoGOXMPh8isl
         tPkPhhEi7DzY9//jhJDIC41cnUhHxrRQBsGE1yuHmrmIcn+EfAbJFN6fzRW+PC6Pnstx
         2gkD39EqmmQ5bPk6hkxlreWYmTa6hLekV/l9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sqQgNcqFZySjAPmekC69cdPorwQrCLLU9gQX96lOKoU=;
        b=qCZb5FuLx287KaJ65xi2Lo2lnTazUwUqX/6jNK9Sf+Gmpd+YO6LMITSNNZv9O4otIm
         pt1Np6iJP+OxDBDayWMf8VoW+jg1ig/b39+9SHVnLa/RGgNitorZbbNUjKlk5Yj3p68t
         P2+jemZP44Ee6HH8vc14fkC+xx+LDhxUmMEK6uMgbuUYalGI8DM129A34hjP23ycMfQX
         MEvhWifAdTw5CkXgYIOHO2uLbqXKLapZbxdYRdk7AcTPYRP/wSh3StjyoxCaqbfeNuoN
         04+Di3Moj3MIPbDzS5M8O/R5ni6JhU9skaYiqk2MV7Z4eyM50sbj8qA0iOtBpEGbM8Sz
         oZwA==
X-Gm-Message-State: APjAAAVVPvFYpEud+54k0t8Q6t7Tblyp/uAK555pJDT3UWR/rYwOw8Gx
        zN/1he4a7kCGAf9Dbv8EBRhkhR1rvSwMkZlM0rUcmw==
X-Google-Smtp-Source: APXvYqx28p77P6Z8suZSg9YQHxITszU/yX0X1zmA/l7toYK9P9XE66adUZQ++uY/sz84X6mCxNmHwmlRzlgXUtJ91Qw=
X-Received: by 2002:a50:94a1:: with SMTP id s30mr6771682eda.4.1559246225601;
 Thu, 30 May 2019 12:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190530031746.2040-1-dsahern@kernel.org> <20190530031746.2040-6-dsahern@kernel.org>
In-Reply-To: <20190530031746.2040-6-dsahern@kernel.org>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Thu, 30 May 2019 12:56:54 -0700
Message-ID: <CAJieiUjM5-4up5RU5KV=yJALH67+MReqBZ2DymoeDz0YzNN=dA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 5/9] libnetlink: Add helper to create
 nexthop dump request
To:     David Ahern <dsahern@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 9:04 PM David Ahern <dsahern@kernel.org> wrote:
>
> From: David Ahern <dsahern@gmail.com>
>
> Add rtnl_nexthopdump_req to initiate a dump request of nexthop objects.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  include/libnetlink.h |  4 ++++
>  lib/libnetlink.c     | 27 +++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
>
> diff --git a/include/libnetlink.h b/include/libnetlink.h
> index 599b2c592f68..1ddba8dcd220 100644
> --- a/include/libnetlink.h
> +++ b/include/libnetlink.h
> @@ -93,6 +93,10 @@ int rtnl_dump_request(struct rtnl_handle *rth, int type, void *req,
>  int rtnl_dump_request_n(struct rtnl_handle *rth, struct nlmsghdr *n)
>         __attribute__((warn_unused_result));
>
> +int rtnl_nexthopdump_req(struct rtnl_handle *rth, int family,
> +                        req_filter_fn_t filter_fn)
> +       __attribute__((warn_unused_result));
> +
>  struct rtnl_ctrl_data {
>         int     nsid;
>  };
> diff --git a/lib/libnetlink.c b/lib/libnetlink.c
> index eb85bbdf01ee..c1cdda3b8d4e 100644
> --- a/lib/libnetlink.c
> +++ b/lib/libnetlink.c
> @@ -25,6 +25,7 @@
>  #include <linux/fib_rules.h>
>  #include <linux/if_addrlabel.h>
>  #include <linux/if_bridge.h>
> +#include <linux/nexthop.h>
>
>  #include "libnetlink.h"
>
> @@ -252,6 +253,32 @@ int rtnl_open(struct rtnl_handle *rth, unsigned int subscriptions)
>         return rtnl_open_byproto(rth, subscriptions, NETLINK_ROUTE);
>  }
>
> +int rtnl_nexthopdump_req(struct rtnl_handle *rth, int family,
> +                        req_filter_fn_t filter_fn)
> +{
> +       struct {
> +               struct nlmsghdr nlh;
> +               struct nhmsg nhm;
> +               char buf[128];
> +       } req = {
> +               .nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifaddrmsg)),

sizeof(struct nhmsg) ?


> +               .nlh.nlmsg_type = RTM_GETNEXTHOP,
> +               .nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
> +               .nlh.nlmsg_seq = rth->dump = ++rth->seq,
> +               .nhm.nh_family = family,
> +       };
> +
> +       if (filter_fn) {
> +               int err;
> +
> +               err = filter_fn(&req.nlh, sizeof(req));
> +               if (err)
> +                       return err;
> +       }
> +
> +       return send(rth->fd, &req, sizeof(req), 0);
> +}
> +
>  int rtnl_addrdump_req(struct rtnl_handle *rth, int family,
>                       req_filter_fn_t filter_fn)
>  {
> --
> 2.11.0
>
