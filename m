Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66533164EF6
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgBSTf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:35:27 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45818 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgBSTf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:35:27 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so553813pfg.12;
        Wed, 19 Feb 2020 11:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TJB87GoDSDS5eCfiA9gR2g0zVyeNrrkXgkcpdklcL2M=;
        b=oc7Q51d4YtnLDYX2A8TMQ4xesXFWl/2DkhyK9OtaG4kMy1ZgusJRqiFamcQiJGi0rg
         MuVDKajG3ccLjKItJx2pa9geyOXV47tNaRRrbhEwosVyy7i8VgOXgH+TwDkkyAhCdJyj
         UCg97xx1zK8zKMI0zx0FCsuKGtD9sXjcYqbnx5oh9yl18U2K69FDVINvmwRTU6/WIuXS
         2d6vCTA5oHxt5TNszR1QauvOoa3TEmMDGqnYs9JybovKNIYzVJ7G9FOPJ7tmznoHZrrh
         9j5t4Vr6fScLrX2RqlPAdPpHtUX5xVHEGaWAXHQ8ZB2POu30f+PO45Ca8HVeruDma89U
         6iyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TJB87GoDSDS5eCfiA9gR2g0zVyeNrrkXgkcpdklcL2M=;
        b=Jo/miBR0z0qY33c0lLM8A9M+8Bk6T7VyRKxZpS3w/aizv+oaxMBYXLAGK522JVTQss
         KKtORdefTFsqytdZgfJY2MeEPCIws08PlmWlcN3SriyOGn1bU79Yy9PJTfN36DYYhLlV
         xb2JFdtQKKN2Ei6Q3YGdsDuByMDN87zEO6B+Mqa5hvgXrsP9leqOjzQBmCwVP2yIms6d
         7VEFXrVkEKypHrAvjxAK3N8hldbee6oKkg1+68if2wbQfudVEgEWrzTbqgD8eEIBDdBz
         HloRYpoWW2dMogxH/CH+ssgLZal0lXdgTgL8NqQjlbIYUQVvPQyA2z83CZt/7QorZ/i7
         qwRg==
X-Gm-Message-State: APjAAAW3b5af17MTgjM6cHtq48Z/2EPuPyRAY6fdhZDJ6H0SPGClopiE
        2sWS00MDAaxrwvI2k3HqEUNBXAGc
X-Google-Smtp-Source: APXvYqyyBPvcc8/naWU80PgrHTXcoA9XhyHQ5ElORvavw1J+a39LkzWU+BOh5AzpGgS/xmgSXmXm+w==
X-Received: by 2002:aa7:9f88:: with SMTP id z8mr28015192pfr.220.1582140925152;
        Wed, 19 Feb 2020 11:35:25 -0800 (PST)
Received: from [172.20.2.64] (rrcs-24-43-226-3.west.biz.rr.com. [24.43.226.3])
        by smtp.gmail.com with ESMTPSA id l26sm492514pgn.46.2020.02.19.11.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 11:35:24 -0800 (PST)
Subject: Re: [PATCH] tcp: Pass lockdep expression to RCU lists
To:     Amol Grover <frextrite@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org
References: <20200219100545.27397-1-frextrite@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b628d0ad-e066-46f5-5746-74dfba1816a8@gmail.com>
Date:   Wed, 19 Feb 2020 11:35:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219100545.27397-1-frextrite@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/19/20 2:05 AM, Amol Grover wrote:
> tcp_cong_list is traversed using list_for_each_entry_rcu
> outside an RCU read-side critical section but under the protection
> of tcp_cong_list_lock.
>

This is not true.

There are cases where RCU read lock is held,
and others where the tcp_cong_list_lock is held.

I believe you need to be more precise in the changelog.

If there was a bug, net tree would be the target for this patch,
with a required Fixes: tag.

Otherwise, if net-next tree is the intended target, you have to signal
it, as instructed in Documentation/networking/netdev-FAQ.rst

Thanks.

 
> Hence, add corresponding lockdep expression to silence false-positive
> warnings, and harden RCU lists.
> 
> Signed-off-by: Amol Grover <frextrite@gmail.com>
> ---
>  net/ipv4/tcp_cong.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
> index 3737ec096650..8d4446ed309e 100644
> --- a/net/ipv4/tcp_cong.c
> +++ b/net/ipv4/tcp_cong.c
> @@ -25,7 +25,8 @@ static struct tcp_congestion_ops *tcp_ca_find(const char *name)
>  {
>  	struct tcp_congestion_ops *e;
>  
> -	list_for_each_entry_rcu(e, &tcp_cong_list, list) {
> +	list_for_each_entry_rcu(e, &tcp_cong_list, list,
> +				lockdep_is_held(&tcp_cong_list_lock)) {
>  		if (strcmp(e->name, name) == 0)
>  			return e;
>  	}
> @@ -55,7 +56,8 @@ struct tcp_congestion_ops *tcp_ca_find_key(u32 key)
>  {
>  	struct tcp_congestion_ops *e;
>  
> -	list_for_each_entry_rcu(e, &tcp_cong_list, list) {
> +	list_for_each_entry_rcu(e, &tcp_cong_list, list,
> +				lockdep_is_held(&tcp_cong_list_lock)) {
>  		if (e->key == key)
>  			return e;
>  	}
> @@ -317,7 +319,8 @@ int tcp_set_allowed_congestion_control(char *val)
>  	}
>  
>  	/* pass 2 clear old values */
> -	list_for_each_entry_rcu(ca, &tcp_cong_list, list)
> +	list_for_each_entry_rcu(ca, &tcp_cong_list, list,
> +				lockdep_is_held(&tcp_cong_list_lock))
>  		ca->flags &= ~TCP_CONG_NON_RESTRICTED;
>  
>  	/* pass 3 mark as allowed */
> 
