Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EA04A4F77
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376604AbiAaTbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244446AbiAaTbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:31:39 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A26FC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:31:39 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id v186so43894069ybg.1
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3yqVB3LreG3wrKcdDt60fm0rPqnL3y1QlZlBA3DAFbQ=;
        b=WtqXoPLWZIGR0p3Pf/GLbBLnoxWku154UWIB08lLYAg4UNSXg/b9tuC32K8wxD+IEm
         Amkkn3EHCY/JRzpbtC5+7BmhKrWA0yg6hhJSKkPGV0L7Zb3CyYcDvD4ySX3Qd5rL3n/V
         7BVWt/wdCDkBdKTQfSHBEA0p8X2CDeNIjvz6JQvtNV1/oU4jajb4pv9LQbszGnBbNJYx
         Ij82aKcC6p+s+qOjpPjjZkmzU+ZJElHx0Rv1BrHdjG1W4BfEe7F6KXGtr3+ac9PSu+k4
         /Q0eEjPwhmozEn2hPzt1A8GcSV5S4PfvG7eG4EX7DgxJEqZ43RX0kh+/bVIDQP/6sQ5w
         dmiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3yqVB3LreG3wrKcdDt60fm0rPqnL3y1QlZlBA3DAFbQ=;
        b=X9FWXp5m/r9i5OATYruNuwcEJPJw7/uV3+Cko9iYoYvI2GUOawgYqXInyGAZECZVHp
         ZJpEtSn3EWE458/XHl7bOCj3usGFAz3J3yuuIrWN4IgWXv7TX9GYT7VvJxki/+zrwpbY
         tRLgIaZ3SmhTtFgxo7wAY24UMEhWz0eLSkBV/NH67g0HLMonbr8x4pXIGpKCLQENQRwQ
         TnjS+cWzcx8491qk5U5v5N+bdredBz9tS/MRttOVlpSdVmPTBa0JiPxHBRFOgB38+UWl
         cSNIN2emDNs3c2EvWWKPASqmUfx9b3xtzlxQTGoK+zF9/C2E1AGj04WeKhUH3F4P//pU
         MMJQ==
X-Gm-Message-State: AOAM530ql+J3Nfw6IWsD1G7DHeQkscTdfH4UsRQJG/VT1XXyc3CJWcNj
        MPA/H/nX2ABxV2r2sAviAVRRWisrIp2oI0tKLZxtM8KK4r1kcA==
X-Google-Smtp-Source: ABdhPJy1/bq7EM7Viq+K0Jxi22Kei8qwFrvbbktg7y7DIdpQvkN0kaT2YRQBs6Qh0XgALcwBDEq7clmiBqd8kaSDsXU=
X-Received: by 2002:a25:d80f:: with SMTP id p15mr32611853ybg.753.1643657497886;
 Mon, 31 Jan 2022 11:31:37 -0800 (PST)
MIME-Version: 1.0
References: <20220131172018.3704490-1-eric.dumazet@gmail.com>
 <ygnh1r0npwiy.fsf@nvidia.com> <CANn89iKpv-6uHXCvSHzPrrPc8eD2wEDvO39yQ4OEQ1t0+NK1Lw@mail.gmail.com>
 <ygnhwnifogb9.fsf@nvidia.com>
In-Reply-To: <ygnhwnifogb9.fsf@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 31 Jan 2022 11:31:26 -0800
Message-ID: <CANn89iL7_FtnUmTxY=tN5dQuB82QL=LANXKxo+vwO90yu1fcJg@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix use-after-free in tc_new_tfilter()
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 11:28 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> Yeah, but I also didn't get how the "chain" variable can get reused in
> that other function (tcf_new_tfilter()). It seems to always be
> unconditionally assigned with return value of tcf_chain_get().
>

This is why I removed the chain=NULL initialization which is not needed.

The potential issue about replay was really about @q variable.
