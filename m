Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8294413C4
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhKAGf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhKAGf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:35:27 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6574C061714
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 23:32:54 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g8so61275576edb.2
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 23:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=jCRBWbynqrRgKzzCjid3DuFSZ3GnlUL2jAjDZ1YiWlM=;
        b=Xkl2r8eUJLStAVTQ0gnr8LN+Q4LOvb3D9ABwX9KL2OJpTP1AWlUaMaiict1RRdslq7
         JqGmBym65X50GZmO3gdPh3/mEh0tIRuhTr7MYzviyFFFsL5Ibs6da9V5SbWvgJRVDWm0
         oeTFBWFVyZu8L5/scesoaVFJ78bXwYXps/MKrPGDdoDKG5lbjOTrYaPf7BYDvvfCUKe6
         BGleuFJ7muL1d+VymXy8DcVxiPTaOjvXn0NyWGdXyegIiUHZ+QxI7dp8Mg84NdOJaRzq
         BK1RyYT3ou/6uJkWTeZM09ShOLPxjGho6jwH4/5LCHjheCsxgwGpbEtPjTa/ZSiIR+Zy
         Sojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=jCRBWbynqrRgKzzCjid3DuFSZ3GnlUL2jAjDZ1YiWlM=;
        b=IRaYdR5MdW7HDX4pKZnFchVLzuTj0Gy2q+dj3COY7lu8mHX8oMeIbFhTFk7h966jzZ
         tcpbW3nMwrwPSObcwFWTjC1fgE6KkYO83ITKy3TTNzuw13FF6q/AnOkTbg3ad/QBNHG7
         5BNuU12lt67QBdlC9copIyHKiRQslqz+89YLeaiQtii5t5NIMQFt0GoEVtTb0HOONnhX
         dky5oeyK0HBURZIc8h/nMPtX/zfVtEggzM2SXawn94UZHMjHnnIqxohtT0vhAuSN00cP
         lR7Y95/mKI3DyCev4v00kPAvvWi90aFU8rdWkOGmRDJnriicQs/cJCHZGcj0Z+zGkXhF
         80HA==
X-Gm-Message-State: AOAM5310mn5UsJjD54z8Ll5wDRCaz1RDJth/ZlLL/Dt1pjjz5SZhGOWB
        exZ+zTWtPFx4nZ288SK5/nEcW7hdG+ZUyGYbn3w=
X-Google-Smtp-Source: ABdhPJx0yaljmX15u74weqa2LUWQjgiZn6toGdfzYe4FCK6TjpBGw3OkfVseBPFMYaI12aYVEHwxtd2IcHhLhny8g/8=
X-Received: by 2002:a17:906:2505:: with SMTP id i5mr34328273ejb.450.1635748373325;
 Sun, 31 Oct 2021 23:32:53 -0700 (PDT)
MIME-Version: 1.0
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 1 Nov 2021 14:32:17 +0800
Message-ID: <CAMDZJNUNdGNh6TQchcGbfC6ur9C7KZ4Ci8Yj4_=gj7OAvZCytg@mail.gmail.com>
Subject: bpf redirect will loop the packets
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <xiyou.wangcong@gmail.com>, ast@kernel.org,
        andrii@kernel.org, songliubraving@fb.com, yhs@fb.com
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi
I found the issue,
if we use the bpf_redirect to the same netdevice in the ingress path.
the packet loop.
and now linux doesn't check that. In tx path,
softnet_data.xmit.recursion will limit the recursion.
I think we should check that in ingress. any thoughts?

tc.c:
...
return bpf_redirect(skb->ifindex /* same netdev */, 1);

$ tc filter add dev $NETDEV ingress bpf direct-action obj tc.o sec .text


-- 
Best regards, Tonghao
