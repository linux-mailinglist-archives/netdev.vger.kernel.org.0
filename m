Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F056D930
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 04:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfGSCu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 22:50:26 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35259 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfGSCuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 22:50:25 -0400
Received: by mail-ot1-f66.google.com with SMTP id j19so31277048otq.2
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 19:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=duLoaeFOB9tCbTP7v2bh3D2YEzrjtTXWKWwHL2VBQ0g=;
        b=lecP9clxwCN8H6R1BSlRH+cUYK2uPmm1VHuaeOe8gOPAj7wJDgTnIBOaVUIjH/kPO1
         hDS9bdrFwUgjgYWjsN6j4PDb6sZ8G2bOrc4taP5wrr2bTPsyQa0X84/k31NcPm4jNXDb
         vWusz8N/54dXojqhXMADybCpuAlqsKQ6d/t2If+TUWk9KYmY2MQVy8DPMw3Ngsg6M8nN
         puUgoSkegjSS/i/hs0RKWoKbYEJUrztdB9V+IK21NpkWPtIgBKdOmQmsbT6J9O//usY2
         jEB3Cie3Gw0EFpVCVb6i/MqOT/+GXe2FSLqj7xh6Ly26b2JoXvVsbp/T54Bt/piMBjfk
         vKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=duLoaeFOB9tCbTP7v2bh3D2YEzrjtTXWKWwHL2VBQ0g=;
        b=UbaD20fjSm+01bWnz/wVeE7Q1qEcTe1EA9RWobluMSg4glK5b2MwzKerCtsSRMDF87
         Ix1r5Nn46VTr1XwjsOuSsHyWV/0GNuGBS4pIEZXS8V9HA6i2FJkNHuBz9neaVLPFqNaY
         EdhbIBqnxPn1d26eTMUpBri/9N7qdXa4r1SUT8Utofp3YGWW33LQcyKyrNNHsARIL2GL
         M0nCwcZzNG7WGinGjXZUsZTjRPFWB6KpVCUDA/qpx+Cnl4r0niJ3yh9O2/dtUeDrZRB4
         uqMGtxh/v2/IUxx6Jnt0GluP1t8e+VOJGnvSHCah5CJPwposZlvIPio8eh8ID6yiByRG
         HILA==
X-Gm-Message-State: APjAAAWibXNb75MCJT6/fCTpUQl6mIeQHP87LzP33KyHNeNF1kEv1N7T
        RdS2TmUaktJqXHKrPLNxcOJ0cHQlGGQTZXlowhkXWg==
X-Google-Smtp-Source: APXvYqwWxrUbRRtuwZW+hoBxbUjk9/NRSSlcquabURks8/KhXKPCGHCFFwh6cUboAJolyH8i20MchUB0Jfx/Q8nwYZ8=
X-Received: by 2002:a9d:27e2:: with SMTP id c89mr37505861otb.302.1563504624412;
 Thu, 18 Jul 2019 19:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190719022814.233056-1-edumazet@google.com>
In-Reply-To: <20190719022814.233056-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 18 Jul 2019 22:50:07 -0400
Message-ID: <CADVnQymE-QbN_T1Pcx=m5HuXvMvvL5Rb=5Ox-Tgqar54__4m_g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix tcp_set_congestion_control() use from bpf hook
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lawrence Brakmo <brakmo@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 10:28 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Neal reported incorrect use of ns_capable() from bpf hook.
>
> bpf_setsockopt(...TCP_CONGESTION...)
>   -> tcp_set_congestion_control()
>    -> ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)
>     -> ns_capable_common()
>      -> current_cred()
>       -> rcu_dereference_protected(current->cred, 1)
>
> Accessing 'current' in bpf context makes no sense, since packets
> are processed from softirq context.
>
> As Neal stated : The capability check in tcp_set_congestion_control()
> was written assuming a system call context, and then was reused from
> a BPF call site.
>
> The fix is to add a new parameter to tcp_set_congestion_control(),
> so that the ns_capable() call is only performed under the right
> context.
>
> Fixes: 91b5b21c7c16 ("bpf: Add support for changing congestion control")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Lawrence Brakmo <brakmo@fb.com>
> Reported-by: Neal Cardwell <ncardwell@google.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks, Eric!

neal
