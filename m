Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44BB811EE66
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfLMXWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:22:41 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44742 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfLMXWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:22:40 -0500
Received: by mail-pl1-f194.google.com with SMTP id az3so1852456plb.11
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KQSkJ25NloJBBL3uTiVtDV/N4wEuZVqk2swmfoy2zMc=;
        b=PpO431ZN2DhU0Q8XU1oBwysraCUbMrh68B28cwZl7glcq6hPmGnD3M5UEAbhdvT6G2
         gsBY2uHt4YSu13z5qll2SPnN8nprBW5LJOj9SWGI/yu+u7nn+XCZW1B+GBmY8rdSbKlg
         N19364OEBsg9tlPNPAXTTJUIo5p/6NN7h3EK0i39Bwko1t3aJI2M7DDT77Tp2HrVq8Pj
         z9/k93fzBnK64s1Da9Jyos+MRluozOkkjRzYM61QjXxcYYdMH8X5vzTqkg4ferszLSRv
         1suj5fD9C4MTcwe3aiElETVtie+ZSprIszUoNEpTxx1EYPHcIpDhP9HNgrh0smTpCnFF
         CHhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KQSkJ25NloJBBL3uTiVtDV/N4wEuZVqk2swmfoy2zMc=;
        b=czNXBYiIqbpoi/xti740d3aKri6TOMhzHQkG25eoWg/X8s5OUa7c51qqtbBFxch2Th
         G+CpIfb0bf0/x1lS66gdYk8WhhLhlm6ZKdWsQGvzYVKOv2H3jdfIueCJcnmW1fHcggXX
         fAApPx3+1h1+oF+G50oF5f+3PGh82vqGFBl9hC++XWKMnZNjCJkyOwJcbNVjYUzMW3IM
         dLUUlosuZbPzn5ZSpmCWBWaxOiAB6Sw6UgVkp732ziWNHd6I3Zu3ARBGoMpRBfmUoEmW
         hF6mgR8hiaUc7Ah2GHhLgMiihi/zry3tYVZGl1DeAO7G4AwmmFC+v1FoHFol8Lv/iw/I
         GJAw==
X-Gm-Message-State: APjAAAW6u+38ZICeaqdPXslveM2Av9aRpL5ovTdqLNHc3pLzUDaTE5Ae
        bndwAA5PuiM3/QPlGj1tkjM=
X-Google-Smtp-Source: APXvYqxcQPj7MpCSHDuTauLBN5PXHBTu7uVGun75jBNAkS2rfrc0tHJhCDx8tfGq2yEmpGt6VBctHA==
X-Received: by 2002:a17:902:ac88:: with SMTP id h8mr2117263plr.131.1576279359944;
        Fri, 13 Dec 2019 15:22:39 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id q11sm12848697pff.111.2019.12.13.15.22.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 15:22:39 -0800 (PST)
Subject: Re: [PATCH net-next 09/11] tcp: Check for filled TCP option space
 before SACK
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191213230022.28144-1-mathew.j.martineau@linux.intel.com>
 <20191213230022.28144-10-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <47545b88-94db-e9cd-2f9f-2c6d665246e2@gmail.com>
Date:   Fri, 13 Dec 2019 15:22:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213230022.28144-10-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/19 3:00 PM, Mat Martineau wrote:
> The SACK code would potentially add four bytes to the expected
> TCP option size even if all option space was already used.
> 
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  net/ipv4/tcp_output.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 9e04d45bc0e4..710ab45badfa 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -748,6 +748,9 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
>  		size += TCPOLEN_TSTAMP_ALIGNED;
>  	}
>  
> +	if (size + TCPOLEN_SACK_BASE_ALIGNED >= MAX_TCP_OPTION_SPACE)
> +		return size;
> +
>  	eff_sacks = tp->rx_opt.num_sacks + tp->rx_opt.dsack;
>  	if (unlikely(eff_sacks)) {
>  		const unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
> 


Hmmm... I thought I already fixed this issue ?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9424e2e7ad93ffffa88f882c9bc5023570904b55

Please do not mix fixes (targeting net tree) in a patch series targeting net-next

