Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C21F2F8B33
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbhAPEbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:31:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbhAPEbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 23:31:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5DC523A5E;
        Sat, 16 Jan 2021 04:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610771424;
        bh=qMDRWToLQ/4TptwuZSmDQQfMwSt3KS2cw2D//FPEt/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U+aAm1w9JU3pIsHh2sb7hGSuu9wVQm6okaSscvSxYfKm0mWeHJhWFJRY7HZwM+vVq
         QplIQ0PKtWiPdU8PsItkoNpy16j2+1tgz9hJXdRrjIgU43XvyjaberM+5TDVhK/ONu
         Hea+t3YU0cKLvliJegB2vjqSOr5ycVFk8A6HJOv6Q5owov2QLSyb+MUlSYCxmOdyNp
         9LLJdqyMxMPxBb7gAXFXgizA/uWqe3OkC+y+mds80mjerWMk2roYiy4hj9nUCKofgm
         2Xl7mn3c4Puve9F70YczTBXl+7+UVLLC5WZgjZo8deUGCpZEu6GxIBL7dKTsaGtz8N
         4E2dUMRr4FOWQ==
Date:   Fri, 15 Jan 2021 20:30:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2] hv_netvsc: Add (more) validation for untrusted
 Hyper-V values
Message-ID: <20210115203022.7005e66a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114202628.119541-1-parri.andrea@gmail.com>
References: <20210114202628.119541-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 21:26:28 +0100 Andrea Parri (Microsoft) wrote:
> For additional robustness in the face of Hyper-V errors or malicious
> behavior, validate all values that originate from packets that Hyper-V
> has sent to the guest.  Ensure that invalid values cannot cause indexing
> off the end of an array, or subvert an existing validation via integer
> overflow.  Ensure that outgoing packets do not have any leftover guest
> memory that has not been zeroed out.
> 
> Reported-by: Juan Vazquez <juvazq@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> ---
> Applies to 5.11-rc3 (and hyperv-next).

So this is for hyperv-next or should we take it via netdev trees?

> Changes since v1 (Juan Vazquez):
>   - Improve validation in rndis_set_link_state() and rndis_get_ppi()
>   - Remove memory/skb leak in netvsc_alloc_recv_skb()
