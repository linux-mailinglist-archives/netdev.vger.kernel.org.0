Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF59931C22E
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhBOTHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhBOTHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 14:07:16 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC010C061756
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 11:06:25 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id c8so6945406ljd.12
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 11:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=nlK3q0YWLBAVnlXKZxWS33kMLrpccihTVh26VJjnw+I=;
        b=j7s/++HQuwQ0dPkGJVEFaOkmyPWx89p7HYNinQy2Kw+C+ye83h8lIk+xBpcML2iPLN
         cdGQSEuotJSUOQ7DRw1BnXUk9c16a40Bj+En3z3QWuCbSU15II+YMyOE2o3yOZgTpyQx
         IPi5Xc/bjTWf3kr7U0jF5Y82wyhDULg/CRvLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=nlK3q0YWLBAVnlXKZxWS33kMLrpccihTVh26VJjnw+I=;
        b=DLL3+XXjkXxXwj1OHF82aZvzlRcGJt2ETrWUeNS35xlYuMuUMbEMXxPNopF6KkVDvY
         hbDEivBSn37CxVrZbyTrsQT9KF/B+ex5PM4WcLTLrlKMgvA1oVhZYSCGoNGAtyVRyZyw
         aQXpctq1vUT2O7usJwZflJe/eqElfZvkDjaa/H8uN0/HwcMJjdga3gOuM8+9g1XOtaO3
         ENGGYIuJSu5rO7f33a5pA5P9UvQ221k9OKnZUyDxGB+gc5RQjiDQNV2rjOov+RTSUh7l
         oYkzHkEo+KzPGgQR7wxfGSCQyitTVwS6QW/juTJDum6XjjU0NRuURtgvoE3lAvgcN0AQ
         2T3g==
X-Gm-Message-State: AOAM531pYd58W6soTVyQwz7wiAXCzJXf0VK8O5Rbkn2JpXMn61hXqDHx
        i/Zp4hQFA8mHF0xerrOYVC1FjQ==
X-Google-Smtp-Source: ABdhPJyab84qkpdHElTAbOYC612cZAhEcRlUrwt3krnBenvG4JjD2TkjUL3Eb8ZyTI94tkx/v8DK/w==
X-Received: by 2002:a2e:9a0a:: with SMTP id o10mr10444014lji.466.1613415984019;
        Mon, 15 Feb 2021 11:06:24 -0800 (PST)
Received: from cloudflare.com (83.24.183.171.ipv4.supernova.orange.pl. [83.24.183.171])
        by smtp.gmail.com with ESMTPSA id o27sm2720795lfi.183.2021.02.15.11.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 11:06:23 -0800 (PST)
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-4-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next v3 3/5] bpf: compute data_end dynamically with
 JIT code
In-reply-to: <20210213214421.226357-4-xiyou.wangcong@gmail.com>
Date:   Mon, 15 Feb 2021 20:06:22 +0100
Message-ID: <87k0r940cx.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 10:44 PM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Currently, we compute ->data_end with a compile-time constant
> offset of skb. But as Jakub pointed out, we can actually compute
> it in eBPF JIT code at run-time, so that we can competely get
> rid of ->data_end. This is similar to skb_shinfo(skb) computation
> in bpf_convert_shinfo_access().
>
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
