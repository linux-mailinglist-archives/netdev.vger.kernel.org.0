Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6389A163673
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 23:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgBRWua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 17:50:30 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43067 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgBRWu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 17:50:28 -0500
Received: by mail-ed1-f68.google.com with SMTP id dc19so26699785edb.10
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 14:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=41cGzlU4cjOdIvYsB+FQ4XEqSVKoQUwQYSLczOx+4g8=;
        b=D6s6qOgHjccdc5oGSjGRqwxlUW6kIZZPog/sURVbWHbS3Cb2XZFtNtalcUDhRwfi6c
         KMZWzKfrC9mjM8IfBy+t8tO2xdGQO+8QNww/Q4b2NHygytY/qtPrMxTkYbL31pcagluO
         5zNenTvZ3/qZYgulcelTOG5nWniaGs4zafcOmLeLMRy2p4ka8WukVSjL2QbDzZoR7r2o
         G4BZaqyM+UQLcIWT4GWLsdbZuUM0A0rLKMIi8L4q3+EFdxfNpMA7fI42E44VacWDurBQ
         ym1Xbj1x8Si0Qj39ehvo8PwoG3gAd3+PghuaUB5/p8U6zX+Gq6Uq67SUYkmfbAPYZszj
         0S8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=41cGzlU4cjOdIvYsB+FQ4XEqSVKoQUwQYSLczOx+4g8=;
        b=fM/mqeRwgSnPZWIui+HRwb67N9mIn9rHrORCEZbyzM5Fa5dWPHnrCIsDWV6kFc5kFT
         jRNTxmuGN6sCGKZFmX3g0kRQ2zF+8JkhpZcv6cKd87QstHu6TxI70zG9sbhRvOinKzYg
         fbcU4gR5oHNLWNOw0/GYoHlBGwM/f9qnfEBuTz87gFp721HG9UlOxYA3L+g2tx7ck4lh
         PrLdSFR2Jqp24y6vtXK7csEJ7fdOWQiVFv1Yz3A8/CMYBH+TMSpyv1PCihH2MS2n+zXm
         LXeTQgmCLojIiyaRqXkr5lsVv2j8PxKvU9oxm1/rb0yU3FZZU36tMGqd9nl8o2rdflT3
         m+Fg==
X-Gm-Message-State: APjAAAVwNrE12qq5HdTwosbWB3MWBmvvGiUdRIEaEY6fu32UBsHqYDoT
        nD2rvt/sekoRWk5NWIysCAIgS56h1yQ+AsdCU15c
X-Google-Smtp-Source: APXvYqyhhYGjJi44BuMzGcIPQERfVr3yRw9OSPDNrlzTgybuGmGK43HZ9IiGu1tLojzYp++JzNqAIROsoipZq7DV9xU=
X-Received: by 2002:a17:906:198b:: with SMTP id g11mr21930378ejd.271.1582066224967;
 Tue, 18 Feb 2020 14:50:24 -0800 (PST)
MIME-Version: 1.0
References: <20200218184132.20363-1-madhuparnabhowmik10@gmail.com>
In-Reply-To: <20200218184132.20363-1-madhuparnabhowmik10@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 18 Feb 2020 17:50:14 -0500
Message-ID: <CAHC9VhShJnD-YnGNN7eYK3k5B3uJd7KVmG4oATboqWGXvFuv5w@mail.gmail.com>
Subject: Re: [PATCH] netlabel_domainhash.c: Use built-in RCU list checking
To:     madhuparnabhowmik10@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 1:42 PM <madhuparnabhowmik10@gmail.com> wrote:
>
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>
> list_for_each_entry_rcu() has built-in RCU and lock checking.
>
> Pass cond argument to list_for_each_entry_rcu() to silence
> false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
> by default.
>
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> ---
>  net/netlabel/netlabel_domainhash.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Same as with the other patch.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
> index f5d34da0646e..a1f2320ecc16 100644
> --- a/net/netlabel/netlabel_domainhash.c
> +++ b/net/netlabel/netlabel_domainhash.c
> @@ -143,7 +143,8 @@ static struct netlbl_dom_map *netlbl_domhsh_search(const char *domain,
>         if (domain != NULL) {
>                 bkt = netlbl_domhsh_hash(domain);
>                 bkt_list = &netlbl_domhsh_rcu_deref(netlbl_domhsh)->tbl[bkt];
> -               list_for_each_entry_rcu(iter, bkt_list, list)
> +               list_for_each_entry_rcu(iter, bkt_list, list,
> +                                       lockdep_is_held(&netlbl_domhsh_lock))
>                         if (iter->valid &&
>                             netlbl_family_match(iter->family, family) &&
>                             strcmp(iter->domain, domain) == 0)
> --
> 2.17.1

-- 
paul moore
www.paul-moore.com
