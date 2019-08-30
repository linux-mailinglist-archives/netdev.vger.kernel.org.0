Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5171DA3E31
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfH3TL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:11:56 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36805 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfH3TL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:11:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id w2so5211923pfi.3;
        Fri, 30 Aug 2019 12:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9u/tqtaLG6240uNY82DEre67il7/kZpdn3CWfckWgQw=;
        b=Lv1jH68NiLXGJon81oAlUXAZp4E6Zu68/xRoV42QXYDhfTKWs9cjz7i26ku8U+d6nK
         J/FX5Vn8EYRJKvo2RjGEmR7KZgGJ+PRA3fPTH2OU9wwNja1K7So24Ag6VJlK8g8Xeq8h
         6nIwFNKTt4XQdSY79F3mUQ07Vf3bjlMAfSVZMGUNsvXLebHTsUwhOksFwUX999Bt/5UN
         B7RpGo023Maq4tk27R8JgJ5tQ5RYMUxA3bTTLmxcB1tumShQA2iIlTlYj5duxE551xkg
         r6jCKs9xgXhYKqrxnv6YM31+bvAzHqsh4H8RwWKFDajICAcpprOujfP6HcFQbEKS/A/Q
         9mSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9u/tqtaLG6240uNY82DEre67il7/kZpdn3CWfckWgQw=;
        b=Mp6QPMs5eWFrkUZZLzK42iG8jMMNmNWvoccx1p6qPH+b6hSAUe0rovK45vBvacL5aw
         76WW99hfDQ24dPX+3MAOgEuW8IeKDONKufQecZJjLjxz2pWk/7b11H1R6xOke6Bmgjj8
         0lFUH7e2XRCiJDyeg9mVds72Nwv2Y0od7744ch/J7iWz5K1ftMT9TQvg/ZAvnazaKAHj
         J94u7bo+JPvSDsmoy4cuCMbIK4rBxZrA8CkOTV9ES+q3xVOySFKSsCgATVhGyEh3buJ1
         ZwnpP+Kuxy1b0U1WJPL4b+x28Crqh44JFCzQDruj86HmKgevB9A4XSm8kgp1kiNh/bpD
         1h3Q==
X-Gm-Message-State: APjAAAVlx8QxTrRwhEmiKczRv6+IeDHP4wIwYbOB8/vELuLiW3wKWjN7
        X0V/6H7Vy2gJ4tOMXYtDUoAE5Kqc4X5p4PXfNAYuTaA9
X-Google-Smtp-Source: APXvYqw3vPFMWXij1ISsxMzc7xrJttNn3C1RZ7AUC5tULYlW0RWKOwqX/+sKwgzgSsFClCmV9VFUQ8t7SUKeLpL2PH4=
X-Received: by 2002:a17:90a:ae15:: with SMTP id t21mr137416pjq.50.1567192315614;
 Fri, 30 Aug 2019 12:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <1567191974-11578-1-git-send-email-zdai@linux.vnet.ibm.com>
In-Reply-To: <1567191974-11578-1-git-send-email-zdai@linux.vnet.ibm.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 30 Aug 2019 12:11:44 -0700
Message-ID: <CAM_iQpVMYQUdQN5L+ntXZTffZkW4q659bvXoZ8+Ar+zeud7Y4Q@mail.gmail.com>
Subject: Re: [v2] net_sched: act_police: add 2 new attributes to support
 police 64bit rate and peakrate
To:     David Dai <zdai@linux.vnet.ibm.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, zdai@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 12:06 PM David Dai <zdai@linux.vnet.ibm.com> wrote:
> -       if (p->peak_present)
> +               if ((police->params->rate.rate_bytes_ps >= (1ULL << 32)) &&
> +                   nla_put_u64_64bit(skb, TCA_POLICE_RATE64,
> +                                     police->params->rate.rate_bytes_ps,
> +                                     __TCA_POLICE_MAX))

I think the last parameter should be TCA_POLICE_PAD.
