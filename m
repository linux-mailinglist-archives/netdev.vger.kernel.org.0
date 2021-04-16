Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2223626A0
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241163AbhDPRVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbhDPRVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 13:21:49 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EC8C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 10:21:24 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id j7so10225314pgi.3
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 10:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UIPBO/xQbzXPnO2JRZkqE+hgnG7Axje4TkUXNbu82bU=;
        b=PpF4dDfdq+UXcU8LHYVBU/70yvwZtU5K5OG48tJHGRuxkwcVX0SyY9UkFxHyCSx9OI
         xrgmoWhIDE0xcTDifORJDiBgDSrhgWDoZSTazfgcRU3XAnN1ztxLdjIsfBOI/tXm46WB
         XqeLMdl/X7V0Cs3V0APp7uc/HbXn2i3TBdkxZse4ZJN9ylqZ9i3iBrgLLhWtSf7d8mO3
         XpTj+BY6OCckuo8bBceEXNhD1yelrME8QNfccxeoOHSXrjtlL+pI/DB4aA9qY8CE1006
         SP+FWsYR/VTEbd63QJjKlLpSOmheVXhuWL3HtVRhUCxlK8ujBq+uP24B/gzAKMfgAF0+
         yFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UIPBO/xQbzXPnO2JRZkqE+hgnG7Axje4TkUXNbu82bU=;
        b=aZlPopgEPikjtk/Umq8orXWZgwJqWIRkJwZXIHx89fI+P0Ahq/ZEH8cTLQVpkdD1CM
         u7+kGchqWC0/8cr4POR35+8w2yT+i20VUhU8UH1Nxi58OpQ9/jmJ1FAXI9TuMmUrJtln
         P1xnS+5haxWi7uvrPOU9RDN4hga2B8xIgD2RX0YmfpaEN9w7UKz87Zm/ebSmXAFL3pjL
         oqmox4q06sNHaSjE/eEDCjExSwqh4NS5sY65jSgDIsos93XW/o85j2CFAswQW6U+7L4H
         KlsDAGkcDHuUymdnWKg2t4Vb4nNwTJ7AjcEs8SfSr9tcxOI47nXiII8/GXerzZ0A8gF0
         efkg==
X-Gm-Message-State: AOAM531/29VAgBcNSF3BHxeJg6ynTRSthoCLDRYOlTZbK9SvYqM6qk1a
        eMnloCIUIJQC2Y6G8PiGmhw1WfXt1ZJHCTcTbNo=
X-Google-Smtp-Source: ABdhPJwXKqLNtofA1cs/QlNEC4MzicsZRIvfyUrNDikF6OjHttjtOwJdYr748Cv95Esnb59d3EXXjR5becmfAXXoy2M=
X-Received: by 2002:aa7:90d3:0:b029:241:21a1:6ffb with SMTP id
 k19-20020aa790d30000b029024121a16ffbmr8632928pfk.43.1618593683597; Fri, 16
 Apr 2021 10:21:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210415141724.17471-1-sishuai@purdue.edu>
In-Reply-To: <20210415141724.17471-1-sishuai@purdue.edu>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 16 Apr 2021 10:21:12 -0700
Message-ID: <CAM_iQpUqMOTAwfrXoY5a4tCTdCk05OEFc4sZDjKr-wzoew5kaA@mail.gmail.com>
Subject: Re: [PATCH v2] net: fix a concurrency bug in l2tp_tunnel_register()
To:     Sishuai Gong <sishuai@purdue.edu>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, tparkin@katalix.com,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 7:18 AM Sishuai Gong <sishuai@purdue.edu> wrote:
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 203890e378cb..879f1264ec3c 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1478,6 +1478,9 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>         tunnel->l2tp_net = net;
>         pn = l2tp_pernet(net);
>
> +       sk = sock->sk;
> +       tunnel->sock = sk;
> +
>         spin_lock_bh(&pn->l2tp_tunnel_list_lock);
>         list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
>                 if (tunnel_walk->tunnel_id == tunnel->tunnel_id) {
> @@ -1490,9 +1493,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>         list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
>         spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
>
> -       sk = sock->sk;
>         sock_hold(sk);
> -       tunnel->sock = sk;

I think you have to hold this refcnt before making tunnel->sock visible
to others.

Why not just move this together and simply release the refcnt on error
path?

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 203890e378cb..8eb805ee18d4 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1478,11 +1478,15 @@ int l2tp_tunnel_register(struct l2tp_tunnel
*tunnel, struct net *net,
        tunnel->l2tp_net = net;
        pn = l2tp_pernet(net);

+       sk = sock->sk;
+       sock_hold(sk);
+       tunnel->sock = sk;
+
        spin_lock_bh(&pn->l2tp_tunnel_list_lock);
        list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
                if (tunnel_walk->tunnel_id == tunnel->tunnel_id) {
                        spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-
+                       sock_put(sk);
                        ret = -EEXIST;
                        goto err_sock;
                }
@@ -1490,10 +1494,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel
*tunnel, struct net *net,
        list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
        spin_unlock_bh(&pn->l2tp_tunnel_list_lock);

-       sk = sock->sk;
-       sock_hold(sk);
-       tunnel->sock = sk;
-
        if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
                struct udp_tunnel_sock_cfg udp_cfg = {
                        .sk_user_data = tunnel,
