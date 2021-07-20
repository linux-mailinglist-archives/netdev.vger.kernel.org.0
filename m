Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5CD3CF351
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 06:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240855AbhGTDtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 23:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbhGTDtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 23:49:25 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAF1C061574;
        Mon, 19 Jul 2021 21:30:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t9so21390950pgn.4;
        Mon, 19 Jul 2021 21:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BzuDwtFqPo4qqrRvCl7MJ3PnC9VhI0oxy96YAAdNcKM=;
        b=ceLJfZuTfRY/Mn7cPwed8gBs+/+yyBD1PqVOW0Gc6mVjxUdHEpTGsCXwoe4YWELZpW
         3Sq2M9k8NRI7Of1AJEzlwhDr15YhH4Ssvmhxm8KUUFPGcBsR5qxVaVkC/dEsgfqcWPEQ
         BPjEATi0kcgW2M0IsTsVQ2zbUzGaIeTlnzkpkwk2g21Re/sYPQRLBxy5FYQyxcZJdf6x
         r/zlarBJ1mN7x1jJWJKNz96mWcxL6dI7yNfbZ7in75cxKtL4YYWZvglJ9s+bNExlbQI4
         jCQ1lZ5pNFKgG2dqyaml3fL1n5lFGjzbJnjLZ2/BzUG0hmr3oeZPGv5HgDvq3AxVdUsg
         XNlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BzuDwtFqPo4qqrRvCl7MJ3PnC9VhI0oxy96YAAdNcKM=;
        b=aGx8KLLgmxzSl+DWb9lEBJNsYEFurAmBc1Hoh+L37Fi5gHqgd2LeLb9/zqrujdsrtx
         HRaIi57XCB4ZMyd+eYe3GtJpzio2OlCzZlO83J55FxV9HiiaJl+ldNqZeFmKMqo8pjl8
         JbTHo1ZCVFOXhLdNy6jMM/WUiBBjv9yI6quuYPM3J6rXzHMycgFnB/6UxdYbHozSvOYj
         QyG8RpAJD720Q5/nqOTmk7EHUtW7LpdYjkKASFY6flb5NF2QGVFsze+SUYQuIdkQ5QNN
         3Udp4jNdSyg2B0duKhHpvdw2/KBd7NY25TgaqkeXVVPZTryBH/Kj4q8FE8nrub44GYxn
         473g==
X-Gm-Message-State: AOAM5328UYfd/I8fMCjsJuisJ438ZeSPcxAXdjIxMa00bo4xxRFM206Z
        RRSYEBpU3rXjsSFGaISezEWtanGb4A4QLafH+GY=
X-Google-Smtp-Source: ABdhPJwGAZ9pw6/Nfnhc5hLXNtEg5yNwKeNeSbOw+AZLvl+tfUHhCBayNrYsQxUnt637bXLneJYy0l0K/WoLrHGLNU0=
X-Received: by 2002:a62:ea1a:0:b029:329:a95a:fab with SMTP id
 t26-20020a62ea1a0000b0290329a95a0fabmr29822885pfh.31.1626755402840; Mon, 19
 Jul 2021 21:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210719051816.11762-1-yajun.deng@linux.dev>
In-Reply-To: <20210719051816.11762-1-yajun.deng@linux.dev>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 19 Jul 2021 21:29:51 -0700
Message-ID: <CAM_iQpV56fJjHotOuOsk=FavTqt9goDbfv4tv5J0nuoU-LKkWw@mail.gmail.com>
Subject: Re: [PATCH] netlink: Deal with ESRCH error in nlmsg_notify()
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 18, 2021 at 10:19 PM Yajun Deng <yajun.deng@linux.dev> wrote:
> The failure seems due to the commit
>     cfdf0d9ae75b ("rtnetlink: use nlmsg_notify() in rtnetlink_send()")
>
> Deal with ESRCH error in nlmsg_notify() even the report variable is zero.

Looks like the tc-testing failure I saw is also due to this...

Why not just revert the above commit which does not have
much value? It at most saves some instructions.

Thanks.
