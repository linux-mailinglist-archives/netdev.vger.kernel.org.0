Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E7E270704
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgIRU02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgIRU02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:26:28 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA4FC0613CF
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:26:27 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h4so8383576ioe.5
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zPIiXtAmm1znwy//ZzDO5/qxaCxybnzlRD5TAdxKKpc=;
        b=A0kw3FLApPzgEKeOvVJgccZvJ8BPv9sXncgcQVLjYXSnBVesfgswX0vOwVQ5OraAcf
         qwfnN9KpCoX+VPbIJjmDUvZZmsJ7VjbNVfB7VGzU04rZbWEA73ygEhnFoB7UXV5Lv6BE
         6pYaKpnEWvTeOnL9Oa1K+3V3Eh8eIUzpOJ1FovkBrv1yVFRUnxkkfcD89nUvYE8Z3C1a
         5ctxS+iZc5vFsJVDvJ+1LuErAMxXJQSEMxXk5W4y72+RkmpylpRCu/gl8iOQOy0vEVeq
         7hB6Q17XdAk97Plg6IgwLWJ484lBu+m/X34R59KdDR/yKVc3SSpyWnk3y/Bz3q+BzGlL
         OiZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zPIiXtAmm1znwy//ZzDO5/qxaCxybnzlRD5TAdxKKpc=;
        b=mdIWH9Ittvet+KW8nr+VEvgu5W7Ajez9+mNoTVX09Gj0oYfcb3PtjRInvWx+YlhV/4
         Gls1TKuKych5jyQV3otM+nBM65X7DhClR/3C5cH+dmZT7f4SI35TXDE2R/AGbmoQfPk5
         pW1Iy8P7txuAT596ObOEu9BdpC6o3XRDIoHQ1ByErBA6aCdfVm6O7o2nL5tDRHCf8xXf
         5jOYklxTAnkkgFBY38qvsd/QVn6p0fpF3ptWn01I/5TGv85OTlKh5EO0Tz+OwtzmZ9tH
         7tjVYFKOVnSLCzgFxApTCxoYezoGQbqdgZzERarcwljKvWF3ZU9aUFs+1i8Lf4iRYqiU
         vujA==
X-Gm-Message-State: AOAM532JIajwz/462yIMi1/jKGhFgKeWtH58sgoNXAgPNs8qG/mhE8Za
        PyAJoNDzD5GV6oL1ahmp83oR6Lng3wltFb65IVxI4w==
X-Google-Smtp-Source: ABdhPJxTlh+pfInXhz9Y0Tl4FYMMs30+z+zgXiQAyegJ3rr5nXdw+897yR0nmJsBjl6Wl6w09p8jbAy32YkHaa1MMkM=
X-Received: by 2002:a05:6602:584:: with SMTP id v4mr29258818iox.195.1600460786710;
 Fri, 18 Sep 2020 13:26:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200918201902.0931495C0649@us180.sjc.aristanetworks.com>
In-Reply-To: <20200918201902.0931495C0649@us180.sjc.aristanetworks.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 18 Sep 2020 22:26:15 +0200
Message-ID: <CANn89iKOAfFzj0oJiN99_2hUqnB=vu-rYjd_sAxQYucS28wKMQ@mail.gmail.com>
Subject: Re: [PATCH v4] net: use exponential backoff in netdev_wait_allrefs
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 10:19 PM Francesco Ruggeri <fruggeri@arista.com> wrote:
>
> The combination of aca_free_rcu, introduced in commit 2384d02520ff
> ("net/ipv6: Add anycast addresses to a global hashtable"), and
> fib6_info_destroy_rcu, introduced in commit 9b0a8da8c4c6 ("net/ipv6:
> respect rcu grace period before freeing fib6_info"), can result in
> an extra rcu grace period being needed when deleting an interface,
> with the result that netdev_wait_allrefs ends up hitting the msleep(250),
> which is considerably longer than the required grace period.
> This can result in long delays when deleting a large number of interfaces,
> and it can be observed with this script:
>
>
>
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
