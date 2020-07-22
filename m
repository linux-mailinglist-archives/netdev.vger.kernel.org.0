Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E344229D19
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgGVQaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGVQaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:30:10 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AFEC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:30:10 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id j1so1306919ybh.10
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3foWdmo32Oui0HJ/cbO3mxJnWbsyvKWkU8jwS9A2SbY=;
        b=Bojz7lnupA2619QhcfoC10rdTqWBmRzUdUjWYK4TTwIfg4GBGhZee+azAhQNOY3v6E
         k+4jjTNGGJ8pMEgul0y8zrW3stwq/U+QK8g6kfyHbU0wRd8rNyz/YkH06yLx0crie8oG
         LjzXfIy+TpCC+h6lcoMIQjRKg5Rw+3IlLw8D6d0ksxiOlsKzz2FsgIKR7DqA3VOA0+7N
         NAPDPXeSkiYeXKSrWwdNrPRa6BoYT4xIibtqPyIvdU4EwbwHRq1JApvI8RwChF8X8MM8
         za2YvWbpL/phjd3U1O9va8QGD6dOKogA5SjaMajCH7hrGDdlgJ0aUm6LWuKjQXusepyy
         8lLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3foWdmo32Oui0HJ/cbO3mxJnWbsyvKWkU8jwS9A2SbY=;
        b=japEmGi7C7Sw/wgOcy+9+ODHw7iABIZEl1dBS1fGYyosncEIQUrQUzQM4i1vZZOxVu
         tZkuEjVgUo/0vy3Gcji+spP4sajAUFU8O0jlLlWoGyVz7YQEHe/JT4dNf/Q7U5hYaMTa
         lpvN3AAC4kxkCjRwyPbVVhI6P/aUkzizrMz7anFfKfAcimIU5IPL8ZYv4EjgFu11FbKp
         aRQzZFDzYvHO3q8GGDdJBFAxRHmnOVNbAoe4X5K8aHcTI3gBZI1F6fk9KZLcnfYvZ+73
         B6d9Oxak5Fr5GXZXI5jKaP/Bn3/BoT1/mE7VeSGQf3cInIgT/gV9xfiW+ZBZolhdcA29
         n5IA==
X-Gm-Message-State: AOAM53068FbhxOPUnbCst4SRaX24onlLOJcBUEIPqjAVU0n93NYq9wXq
        3pXoQo0NDul7t8X7SMDwOORA5pb4qrvAyyVSePj6VQ==
X-Google-Smtp-Source: ABdhPJwfwDY4JbBlaYal7c5zI4dtkjYWA4kPM3QeMQfuzyaUtplrWCE/Xr922Va//fZLqNtgncaWKCGNoHtz4out8Mg=
X-Received: by 2002:a5b:74a:: with SMTP id s10mr239539ybq.101.1595435409540;
 Wed, 22 Jul 2020 09:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <1595409499-25008-1-git-send-email-geffrey.guo@huawei.com>
In-Reply-To: <1595409499-25008-1-git-send-email-geffrey.guo@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Jul 2020 09:29:57 -0700
Message-ID: <CANn89iKKSOFSvtoFamuG1S1e5qb_WNpEdFgtQ-UtgkfWa0-WxA@mail.gmail.com>
Subject: Re: [PATCH,v2] ipvlan: add the check of ip header checksum
To:     guodeqing <geffrey.guo@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 2:23 AM guodeqing <geffrey.guo@huawei.com> wrote:
>
> The ip header checksum can be error in the following steps.
> $ ip netns add ns1
> $ ip link add gw link eth0 type ipvlan
> $ ip addr add 168.16.0.1/24 dev gw
> $ ip link set dev gw up
> $ ip link add ip1 link eth0 type ipvlan
> $ ip link set ip1 netns ns1
> $ ip netns exec ns1 ip link set ip1 up
> $ ip netns exec ns1 ip addr add 168.16.0.2/24 dev ip1
> $ ip netns exec ns1 tc qdisc add dev ip1 root netem corrupt 50%
> $ ip netns exec ns1 ping 168.16.0.1
>
> This is because the netem will modify the packet randomly. the
> corrupted packets should be dropped derectly, otherwise it may
> cause a problem.


And why would ipvlan be so special ?

What about all other drivers ?

My advice : Do not use netem corrupt if you do not want to send
corrupted packets .

>
>
> Here I add the check of ip header checksum and drop the illegal
> packets in l3/l3s mode.
>

This patch makes no sense really.

>
> Signed-off-by: guodeqing <geffrey.guo@huawei.com>
> ---
