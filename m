Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A8232B398
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449800AbhCCEDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839551AbhCBQh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 11:37:27 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BB1C0611C2
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 08:23:52 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id v5so32155942lft.13
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 08:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LcVHR6+gABrqPot+5DAzhb8/k5TtG4mpDhY9zzDMCc0=;
        b=Kq2QnaeT1nRM6DYPza7WQUqKQY42w28TJBUGBLao7XP2ciXqqvS8asIep60PPDPO5u
         13NFkQQBHubCv2lA0oEpBvpb7OG5O6cmQDK6xugIvxhVxuBCFZrHE2RCcfEuQQQXFOhT
         ahrsieoo1mV/PTysZOVhwIvpIDBDyzJf48qMo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LcVHR6+gABrqPot+5DAzhb8/k5TtG4mpDhY9zzDMCc0=;
        b=na+4Q0D1rXQl26hC0M55K275yCBXgd/FMSTcGQ54r92BbO7npwOSitpD4WAYSSDV5X
         BXhPotk7qIyN9VLg6M9Yr8h+BSTTFNJHxnP7CTNCIu+GAnFqeN+C4BPgf9bFoq8zEZAt
         ZXE7yDmIsZbZfoBpX4GXcs5ZpguXymiaaqjTBh02/bsqMRcx6/9sD7DirwHPQGBvfOxT
         jqnVfXCNhhcpcI0pv6BML0f+yVokG18XzlkYnivojL77jKzO3tUCtOlOE2tcp+1xU93L
         EqI1Ui+t6nxu/BzYjeT2/CYKi/S9hnOKjrXHyQUJspwFxZfxKZZEqUoPHdS8skSTkwl9
         4B0Q==
X-Gm-Message-State: AOAM532RjQkafhM4gWKBeXvJ6z+B1Dtpxk7mtZmK7IIKZ8tRpQ0mvkpE
        xBXRpTO4ziy9ivdwP21iBm8yeuETrUYxt6kK7S++/w==
X-Google-Smtp-Source: ABdhPJw40UN64yFL1RnxO7mP7QwoGSxtkWRg9aDMbR4xEvelVYPQesFunWYeerPMi7Q9bZ2PgQ14Va2+VYO2KeM4Vpg=
X-Received: by 2002:a05:6512:33d1:: with SMTP id d17mr12794743lfg.13.1614702230670;
 Tue, 02 Mar 2021 08:23:50 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com> <20210302023743.24123-6-xiyou.wangcong@gmail.com>
In-Reply-To: <20210302023743.24123-6-xiyou.wangcong@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 2 Mar 2021 16:23:39 +0000
Message-ID: <CACAyw98C99sjOompq59Aa-uuaeyJc0pXAEBiBCVJ+1Ds4_h=jA@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 5/9] udp: add ->read_sock() and
 ->sendmsg_locked() to ipv6
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 at 02:38, Cong Wang <xiyou.wangcong@gmail.com> wrote:

...

> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index bd1f396cc9c7..48b6850dae85 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -1119,6 +1119,7 @@ int inet6_hash_connect(struct inet_timewait_death_row *death_row,
>  int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
>  int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>                   int flags);
> +int udpv6_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t len);
>
>  /*
>   * reassembly.c
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 54f24b1d4f65..717c543aaec3 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1831,6 +1831,7 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
>
>         return copied;
>  }
> +EXPORT_SYMBOL(udp_read_sock);

Should this be in the previous commit?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
