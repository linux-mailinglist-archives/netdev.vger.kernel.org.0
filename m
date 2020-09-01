Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B38F259627
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731947AbgIAP6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 11:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731764AbgIAPn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 11:43:59 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25FBC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 08:43:58 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id cy2so725220qvb.0
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 08:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oSyU4rbRCx7oJC6Q+h2Vq9u8C2zTFP5KkB72aQOvBJ8=;
        b=MuQINPXdDrFew7Qa+o4Y65wC8+8poRZ475eqCEsF/tyACMmEKt7Q5v4ZlrFecQMipm
         vVDiPRVj7HRGUHkQLsqTUb4IB8G8UP8gkMK2qm8/b7i0tAGTme3VryVogvWj5mRTigYZ
         wYgXh7ZcJTvneS+FXmHjn+1/UErf/NgIMlLBtHzW8OLg3TKv4gRu+6/CWuRHzc33vMWV
         tWkb2f/EW/3IxM7aNuN+j56JHX3vIiMZbu/bE9hqUkImhHivX/pQBvrJ734Lkc304JLO
         6KVhTFRHoU1cCiCKMJcV0aDWsyTHecGyYE1aqjQAVhFJNeQYDjAc9Fveve6DHr1MO30L
         LrXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oSyU4rbRCx7oJC6Q+h2Vq9u8C2zTFP5KkB72aQOvBJ8=;
        b=pqLI3AqKKNUAGukeaW14ZeOI3gemrUQy1vsv88XYY54/YxjN5f7KCfPrdC8LdxIhv5
         olpGOmMTN2ZT1YDe4J2L4SbF1koMg+9G4rYeobgcitMeODSvdGErVP7Zf3H8k8/UcqRK
         Fj+5US5taeeE4VtnSYSY/77YpUVLe3k5nNbPyGzI2OEMrEB7J6fVJ2dm0DYAsSx/82na
         F1E6WI2kuIGjC7C6IUDhQ6niztUbPxf8oXUxBKErKo+Aq1w4a78kbtCPuAzNoASdZNZP
         KU14zZwHtuVK7RSJ8Myhs4sx6AWFklnfCNH44k/kww/OlLnKcCyFmZ0sK++p+XIq5W70
         MzSQ==
X-Gm-Message-State: AOAM531DP3Q5Idn6cdt0dmyRliNd2bqFyuS3+UH/jFRpS8zBahXbedNC
        GseJVOTAcPCaune7go6l2Zb6yX7RGav52pmB/6izjA==
X-Google-Smtp-Source: ABdhPJwgiFnNCRyjJL2gdJhEDxZjGFoJ0pKaCYS2kn20L8UThitNkhwxTJMrUqll5FICEWInU7erhnYSdFpLJ8/7sNU=
X-Received: by 2002:a0c:de0e:: with SMTP id t14mr2468615qvk.57.1598975037745;
 Tue, 01 Sep 2020 08:43:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200901065758.1141786-1-brianvv@google.com> <CANn89iL+C5QWxbqKbxcdAa=BtDkEg-tm5dNnvrvXJrMRXQb=mg@mail.gmail.com>
In-Reply-To: <CANn89iL+C5QWxbqKbxcdAa=BtDkEg-tm5dNnvrvXJrMRXQb=mg@mail.gmail.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Tue, 1 Sep 2020 08:43:45 -0700
Message-ID: <CAMzD94TF+q5600oVTMbYNSng=ZCwNdz2RCybSgeW4O5g3nCzeg@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: fix __rt6_purge_dflt_routers when forwarding
 is not set on all ifaces
To:     Eric Dumazet <edumazet@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 1:20 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Sep 1, 2020 at 8:58 AM Brian Vazquez <brianvv@google.com> wrote:
> >
> > The problem is exposed when the system has multiple ifaces and
> > forwarding is enabled on a subset of them, __rt6_purge_dflt_routers will
> > clean the default route on all the ifaces which is not desired.
>
> What is the exact problem you want to fix ?
Imagine you have a host with 2 interfaces. 1 is using SLAAC, the other
one it isn't.
On your main routing table you have the default SLAAC route for iface A

Then you're setting a second interface B and you enable forwarding
only on this iface:
echo 1 > /proc/sys/net/ipv6/conf/B/forwarding. Changing the sysctl
which call the rt6_purge_dflt_routers
which would delete your default route on iface A, so effectively you
will lose connection via iface A, until the default
entry is added again which would happen because that iface has
accept_ra = 1 and forwarding = 0, but it would take some time.
It feels weird that modifying interface B deletes default route A
which would be added back anyway, but you lose connection on A for
some minutes.

>
> >
> > This patches fixes that by cleaning only the routes where the iface has
> > forwarding enabled.
>
> This seems like a new feature, and this might break some setups.

Fair enough, the main issue here is that the behaviour of a host in a
mixed environment is not well defined.

>
> linux always had removed any IPv6 address and default route it learnt via SLAAC.
> (this might be to conform to one RFC or known security rule).
> It would be nice to add a nice comment giving references.
>
> >
> > Fixes: 830218c1add1 ("net: ipv6: Fix processing of RAs in presence of VRF")
>
> Please provide a test, or a better commit message ?
>
> If your patch targets the net tree, then it should only fix a bug.
>
> Thanks.
