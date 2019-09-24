Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28383BCCE7
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 18:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632822AbfIXQmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 12:42:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38062 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409860AbfIXQms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 12:42:48 -0400
Received: by mail-pf1-f195.google.com with SMTP id h195so1702672pfe.5
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 09:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nG0vpzTkSIsChxXemc8J3wLGjX+JFTCoH17ggHd4VIk=;
        b=gp6qIAnSeoKHw8V8mYKKXIjA8IlszlH/k3BV5Fwdi8LjzOMQOAIU/B5LPujhaBNhIj
         zaTs61vpULnP1C8KYtD86IbUd0WiveioD+4KOmWfvd9eNPbjpPuxVhqM8ZtZpwSulIEv
         u+U2QAXw9UHGanOCXTwdYMpAE/yzZilahZD7jR07JqfvX//1zhlK3ZHT+hrZKwLsmDNV
         V/kxMKB7v1hFMX+Lt4cM5M/VNSuVuq7WQcz3DMqM7mStTPIb8ugQV4aXYeNo7LXYT/s1
         GOjPgeaFY8brb4BWVsuh7bk3PUbqItWaYqvSdgTnQSxOZKULlQGYnfXs/NMAWpuu3OYL
         72Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nG0vpzTkSIsChxXemc8J3wLGjX+JFTCoH17ggHd4VIk=;
        b=pVpcLnP5P2LowqETvWfjZa2DBxf/0pPFeZLIR+B+TnYoRVn3g5frmohyI5DYF1m6A4
         MbpsuHY+VCgCvkgBOEI4ozqRYj7vNU9vhpqeET/r72xFdmPRnx4WVph9kKiWMfQOlOik
         qh1IPjJH3D0pp2rE3R5vgqt7x5tpcUpe95eT9jD6DgeRiIZwtSIOtiyXdgTwW5Kfg1Zk
         7tVgSiUEoVNz5alsOXhZewKgzeCrS1kmb4GjQ6IDE2ttlL4/kAD3cwJfyeGyRruJL/LI
         NgtDcYAMP2bu1HfCkQuFTb+PXmu4pPsfmdZlh+IvHajpyrHzt6W+LgXRTXgRfWfee+p+
         QXgw==
X-Gm-Message-State: APjAAAV00CkGKvP94oiqVwbYMGfjpZpTzq8QOnP9JTuDw4oG1pJ+Q8di
        TPdVSAsVLHs2LqX8NkU/3ZgABhGlKiEQjWzT19U=
X-Google-Smtp-Source: APXvYqy1atFcJhISDWVG5JqwxWhZ6yv9AHEBlj0ml/Zq1yUX9k5+3lpcBIqkiqVO9M6OO1gcmNBHkD4QT9P9ydvILfk=
X-Received: by 2002:a65:404b:: with SMTP id h11mr4017437pgp.237.1569343367506;
 Tue, 24 Sep 2019 09:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190924155118.2488-1-vladbu@mellanox.com>
In-Reply-To: <20190924155118.2488-1-vladbu@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 24 Sep 2019 09:42:36 -0700
Message-ID: <CAM_iQpXO9DG97beUocBuatzZr6+Kha0mQFpA+yFP6yz1R=WWCg@mail.gmail.com>
Subject: Re: [PATCH net v3 0/3] Fix Qdisc destroy issues caused by adding
 fine-grained locking to filter API
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 8:51 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>
> TC filter API unlocking introduced several new fine-grained locks. The
> change caused sleeping-while-atomic BUGs in several Qdiscs that call cls
> APIs which need to obtain new mutex while holding sch tree spinlock. This
> series fixes affected Qdiscs by ensuring that cls API that became sleeping
> is only called outside of sch tree lock critical section.
>
> Vlad Buslov (3):
>   net: sched: sch_htb: don't call qdisc_put() while holding tree lock
>   net: sched: multiq: don't call qdisc_put() while holding tree lock
>   net: sched: sch_sfb: don't call qdisc_put() while holding tree lock
>

For the whole series:

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
