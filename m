Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF15475F78
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbhLORiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbhLORiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 12:38:22 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A390C061574;
        Wed, 15 Dec 2021 09:38:22 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso25778454otj.11;
        Wed, 15 Dec 2021 09:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=GlpTpA1kE1vp2514h/RHYkGvpfuBtGSMqUeMESB7pDU=;
        b=o/+sGHJUOAhcSpuqvqpTvVyD1+hwttdoVp5sPh08INcBGjX84eLTuLMbnuZYLv4EAw
         L5D0FK+KK+5fCsUQF1FOU2qbStOHzI8isSsWj+ZI5C/N9eRA0ViFMoiaDRdEa+rM7UW7
         Jbza9WJjl9CjUgG1YDWHimDz3MWXEHGUdtizSKeSPDc5+Tj0UZxBjV0cT7wnqkTwGkmU
         FSC4nllYQEHiFtfuLhyiljSt9xl1+BH3VeH/DGIVMM+9eI1wv+QoYQ/ctBSL192yih4r
         WL3DhVZoaG+1OH7ha8CzNUFhw6lMrgq6La+03p5AZuXYFBUJBi2eSo5s59fowclZhoye
         uiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=GlpTpA1kE1vp2514h/RHYkGvpfuBtGSMqUeMESB7pDU=;
        b=QMB8NX7TU4k+ip0RVOlXA2t5d5j0d2S+ftHmee881xoBbJjoOfb4tUKeXDAt5lheAR
         oQmJP5oIHLk89Y5QjlMS+7GBg0JXtlxIYJSLUR+fUfasZefnZHujxrWv4vE6uD3J6kV8
         RpqbG/soPz4I39JG5K14ccnqP984FyI+7mRS+RdWXMm1vIh5ACLLiRRrpCVA64MC87aJ
         0S/IHgyPToa0n1sk6wgkKqd3GGeqlxdpoO8F5vPB4HWv8y06BE8cQv9Dg9K1+Tw1CIw8
         hcr4Mm+ZtsGeTHIL/wh8r4TIYekgRggZKq6s99oTCQ1bD8oIn7U6uEnXRP4Ft4m69S6i
         F1QA==
X-Gm-Message-State: AOAM530IOmC7e3AYdc8eNsbH8VjwulW30V6mWDVc9FKzILh5guBhO3p3
        wNG3BZPk6w0SokBr1n6zycaXzGQCxEIbflTEbR1XiJxUYp36/g==
X-Google-Smtp-Source: ABdhPJzzPxQczzBiZi4y1VJeiZx0MMzNiNAWLbILissM3iRIJL1FgcfM+d6Vh/wYRan4uPIoY59vO3OMEY9XHeGocP4=
X-Received: by 2002:a9d:5ccc:: with SMTP id r12mr9416057oti.67.1639589901545;
 Wed, 15 Dec 2021 09:38:21 -0800 (PST)
MIME-Version: 1.0
From:   Naveen Mamindlapalli <naveen130617.lkml@gmail.com>
Date:   Wed, 15 Dec 2021 23:08:10 +0530
Message-ID: <CABJS2x78hO71EAUpe+4xNUb8b5BTypOSOfd4Ati+r6PTq3sopA@mail.gmail.com>
Subject: Question about QoS hardware offload
To:     lartc@vger.kernel.org, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, maximmi@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Our NIC hardware provides a hierarchical QoS tree for each physical
link with strict
priority and DRR scheduling & also supports traffic shaping at each
level. I'm curious what the closest qdisc that supports the above
functionalities for offloading to hardware. I looked into htb/drr/prio
qdiscs, but each qdisc supports a subset of the functionality enabled
by our hardware.

As per my understanding, The HTB hardware offload is used for shaping
rather than scheduling (strict priority/DRR).

The PRIO qdisc seems to support strict priority but not DRR. Similarly
DRR doesn't support strict priority.

Please advise on how to effectively offload all the features.

Is the ETS - Enhanced Transmission Selection scheduler a better fit if
we simply need to offload scheduling with strict priority and DRR?

Thanks,
Naveen
