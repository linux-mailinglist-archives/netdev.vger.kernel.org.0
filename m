Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AA2407EA0
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhILQfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhILQe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:34:59 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8306C061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 09:33:44 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c21so2727355edj.0
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 09:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Usf6mkSp6FhVqVzM9WrcC9ki4m2tVa7D6HM9LRGxIhg=;
        b=MVPD2hwdGvR04B9PGmKTE3SzJ+6oZpp8s+ODEbHwL+5uovxoxOPycyxAJn9wBWN9XI
         1pGlgAoqQs0B+B2+UGw1uHo75+ETcSOyOHbm9x9eP4RA0VSvOx2NgoBG2gJpWO+KrEsG
         Su7Q4JeyQak8NR5qohUFSMsGpm9s/EDF+Yht17Q1nQCNaTc9R9J3F3xPoKPpf+WJv9Zn
         wWQ+G6xWmkNGh8FSwmN7Ni8a23CVS30RD1h/px/AhpAVooSV4/MbiYx9N9Xd0edmW9+o
         aJQmz7oSTItF1NzBN34n26C0NYs4AHelrJ5YqnLxjCRdmMi2fnQh/0KuoRWqvjNKzMM3
         YWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Usf6mkSp6FhVqVzM9WrcC9ki4m2tVa7D6HM9LRGxIhg=;
        b=dUMfWHaigguLKyIPrOMcvIWmZ58DZ2pOgQGV0T7iZunRQO85u4R1j5wbMfsRKpYlK3
         togBfGFvt55GDOKhr1G34Y9q+NHa3acwK36fo2ss6LQ8Ts6tQ6k8h2LEBTD0YdrEXA1L
         PZD7yJVUI5tSFqvxyJccDYypkxoOm0VXpm5qCyCDeaI5vQQHxvt+qLiDtD9MjUI7tiR+
         u2C700x6qlDAwtvz3oyUdPCWrPg4cDm4z4KqKYC5dG7GIyJYkqk3EjtKgkI0D2TGgip3
         GPz1GJv80tk6ufTI8wqGbTjB2gRjv0Nv0xM5IeEmrpTN1atLaCGJGfvZvM43Quo5m4jY
         13Tg==
X-Gm-Message-State: AOAM531hTvqi2Cn5FSavOgl3qscsTfjMS1MuvlgG8X0QEZXua+BT5H0y
        4f3VLz+zl0cdAwtaGAbOAgA=
X-Google-Smtp-Source: ABdhPJzO7QqL7SK0Zu6akREBkPwsf3BjlFSzl+z0ZQbCcrUegjkC7160xQwxgIGHwSaRmQNnKce8mA==
X-Received: by 2002:aa7:d7d5:: with SMTP id e21mr8824071eds.27.1631464423017;
        Sun, 12 Sep 2021 09:33:43 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id f24sm2536706edc.40.2021.09.12.09.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 09:33:42 -0700 (PDT)
Date:   Sun, 12 Sep 2021 19:33:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH net] net: dsa: flush switchdev workqueue before
 tearing down CPU/DSA ports
Message-ID: <20210912163341.zlhsgq3uvkro3bem@skbuf>
References: <20210912160015.1198083-1-vladimir.oltean@nxp.com>
 <5223b1d0-b55b-390c-b3d3-f6e6fa24d6d8@gmail.com>
 <20210912161913.sqfcmff77ldc3m5e@skbuf>
 <6af5c67f-db27-061c-3a33-fbc4cede98d1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6af5c67f-db27-061c-3a33-fbc4cede98d1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 09:24:53AM -0700, Florian Fainelli wrote:
>
>
> On 9/12/2021 9:19 AM, Vladimir Oltean wrote:
> > On Sun, Sep 12, 2021 at 09:13:36AM -0700, Florian Fainelli wrote:
> > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > >
> > > Did you post this as a RFC for a particular reason, or just to give
> > > reviewers some time?
> >
> > Both.
> >
> > In principle there's nothing wrong with what this patch does, only
> > perhaps maybe something with what it doesn't do.
> >
> > We keep saying that a network interface should be ready to pass traffic
> > as soon as it's registered, but that "walk dst->ports linearly when
> > calling dsa_port_setup" might not really live up to that promise.
>
> That promise most definitively existed back when Lennert wrote this code and
> we had an array of ports and the switch drivers brought up their port in
> their ->setup() method, nowadays, not so sure anymore because of the
> .port_enable() as much as the list.
>
> This is making me wonder whether the occasional messages I am seeing on
> system suspend from __dev_queue_xmit: Virtual device %s asks to queue
> packet! might have something to do with that and/or the inappropriate
> ordering between suspending the switch and the DSA master.

Sorry, I have never tested the suspend/resume code path, mostly because
I don't know what would the easiest way be to wake up my systems from
suspend. If you could give me some pointers there I would be glad to
look into it.
