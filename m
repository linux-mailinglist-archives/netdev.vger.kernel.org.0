Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42C817A4CE
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgCEMAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:00:48 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54019 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgCEMAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:00:48 -0500
Received: by mail-wm1-f68.google.com with SMTP id g134so5969058wme.3
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 04:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=uObr8HTRJvvkPtZFYtcKx4WzpLxPFBuwzYX1IrBj3yc=;
        b=IaN3n+vcHlCFmj2FjcyBTvl5NWCPWY1Gq3x4HzQpuLkfxQZrzljTgj+k100BRs8Biy
         dF2wPK82zVVMQyv1oCHPn6LNrZf5C/2TPmww8bsfvMyR5BXOcwMqIQ4qnYlj5vqUVXCv
         H6N70701bHwnqBbmxSTsVxdBFveFAM3iPEP6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=uObr8HTRJvvkPtZFYtcKx4WzpLxPFBuwzYX1IrBj3yc=;
        b=mQzizICEVwN5vn+91VMkgmPpNdK+4EWuAqmVwEsKOOL5nCG+Gz47jx5qvo1dlB4wgh
         PZIWZWN2Pmpx5V7Y16rP0nLhO56P0RALRQVWPDTJdfTDd0jU6DQXgTCc5bFOOXunl4yL
         u1T0AjICNPwG9BLr3k3nXbmLD7+/V7QTlEbRPbFhxH3wiscRI8aXCqmCie61byCZ010M
         EfpDy+zaFg3WPPdy8GrWzHOp4K4UhPbNo8bsxg1HLybie+M12KpuW6+qnQU7H5nv0F6R
         aRN5AcpBiCgDrMmSQeO+rH+aJDEuw6RQnheA+abwuiictB1EdlJgmIrIRBTqDggmS3lH
         8IgA==
X-Gm-Message-State: ANhLgQ0G8Y5iCL/J/FtrYH/bTaq4/LX0JUc2XdN1K6YNqMZ4KJuGrjXZ
        FSkXVQ6WipzV3f91/4HslRsNGA==
X-Google-Smtp-Source: ADFU+vvhiNLXK/gmpiu0l+tLWMsxbL563AqkpPF0XFukxV+4vnxzUWtwy7ToAThcKQCy2Yn3Hx94cA==
X-Received: by 2002:a1c:df45:: with SMTP id w66mr9145048wmg.171.1583409645664;
        Thu, 05 Mar 2020 04:00:45 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id w16sm10403375wrp.8.2020.03.05.04.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 04:00:44 -0800 (PST)
References: <20200304101318.5225-1-lmb@cloudflare.com> <20200304101318.5225-2-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 01/12] bpf: sockmap: only check ULP for TCP sockets
In-reply-to: <20200304101318.5225-2-lmb@cloudflare.com>
Date:   Thu, 05 Mar 2020 13:00:44 +0100
Message-ID: <87h7z3ypsj.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:13 AM CET, Lorenz Bauer wrote:
> The sock map code checks that a socket does not have an active upper
> layer protocol before inserting it into the map. This requires casting
> via inet_csk, which isn't valid for UDP sockets.
>
> Guard checks for ULP by checking inet_sk(sk)->is_icsk first.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

[...]
