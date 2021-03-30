Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E9C34DF83
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 05:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhC3DmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 23:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhC3Dlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 23:41:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D1EC061762;
        Mon, 29 Mar 2021 20:41:48 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so6984925pjb.0;
        Mon, 29 Mar 2021 20:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H20z6a01zOabARj7KiXuuTGakHQ2bTsJGwnuUxgVOds=;
        b=izfuPkuLj7M5nKqR3ojCclqJI8bk2PZG2t0mHF6Ov0y+4gfr24SqeZMjftG+PhUpKr
         7D4ltGvR//clSXRIuVNP2kFu7YlhXfvgO23XwNXlHOkzlh998MZHSeU9DJu99+/BQGGz
         BUf0LIxuit++v/yr4ch+VLR3jyvmeaCF4OH/63qABaquPLQyxiTR2duXINObW9fUjTSl
         aNkvj2vYKFiXE+QrQCrhTsFiX6x937/pm+5A8/T1Ns6RDK4cFBpw6xR4HJVo1pi7NSic
         K8mem/nGVfVN3vODpJncgxXLDpKrStuDBoSYnCrl5DrxbPWggqEjyqB/YjMm5BG0vpMI
         3sGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H20z6a01zOabARj7KiXuuTGakHQ2bTsJGwnuUxgVOds=;
        b=NJSYopr8AGhVkl9BH97yPcbxpva1haQVRSA3BYFDLra44Q0Ajb4q5lOSf4XwM8wqug
         I5+5m2QEWlIBbAT+bU64iAtEwJdyNNhYMvwQoATiYpZjI+KPK4IAnKqcO03CqWVG56pH
         s7htfmVaY2Pz+03atnAcLZmIGRi3TXr9qWUxdTH1fWoXQx/QB1Q37/15bnOMEL+3t1Rz
         FpqUJZWLrlYI22quJ+ZFPE+7HtIrl8+BuxOcQp/3AOiUl6TgeSEvZFk6qK5biEZKZ0Qa
         sLhFRLxolOdnwK3ucYcWIoXxiGejCe4rclAnsPI90N2Xmw80UTQtNDZm0g0oeeKuFyz4
         rf7g==
X-Gm-Message-State: AOAM531lYsSfJC4FhUpdgqo7YCfbmRL9NK57pQjWTQYFqnIuGxeQlEYc
        CpJlNI+Gg3ZxEMqwCuVAwwk=
X-Google-Smtp-Source: ABdhPJzpOZewSVE8JN8OFoK2cyL25/7ric2zwhIPaplUwu3jxy1vp2OKyzRVvuPGKeiaEmfQ+s1sLQ==
X-Received: by 2002:a17:90a:9b18:: with SMTP id f24mr2195723pjp.96.1617075707803;
        Mon, 29 Mar 2021 20:41:47 -0700 (PDT)
Received: from kakao-entui-MacBookPro.local ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id s12sm17812830pgj.70.2021.03.29.20.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 20:41:47 -0700 (PDT)
Subject: Re: [PATCH net-next v3 5/7] mld: convert ifmcaddr6 to RCU
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-s390@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        xiyou.wangcong@gmail.com
References: <20210325161657.10517-1-ap420073@gmail.com>
 <20210325161657.10517-6-ap420073@gmail.com>
 <6262890a-7789-e3dd-aa04-58e5e06499dc@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <f054971d-8be0-92ba-009b-9681e08f841c@gmail.com>
Date:   Tue, 30 Mar 2021 12:41:40 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <6262890a-7789-e3dd-aa04-58e5e06499dc@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ko
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021. 3. 30. 오전 4:56, Eric Dumazet wrote:
 >
 >

Hi Eric,
Thank you for the review!

 > On 3/25/21 5:16 PM, Taehee Yoo wrote:
 >> The ifmcaddr6 has been protected by inet6_dev->lock(rwlock) so that
 >> the critical section is atomic context. In order to switch this context,
 >> changing locking is needed. The ifmcaddr6 actually already protected by
 >> RTNL So if it's converted to use RCU, its control path context can be
 >> switched to sleepable.
 >>
 >
 > I do not really understand the changelog.
 >
 > You wanted to convert from RCU to RTNL, right ?

The purpose of this is to use both RCU and RTNL.
In the control path, ifmcaddr6 is protected by RTNL
(setsockopt_needs_rtnl() in the do_ipv6_setsockopt())
And in the data path, ifmcaddr6 will be protected by RCU.

But ifmcaddr6 is already protected by RTNL in the control path.
So, this patch is to convert ifmcaddr6 to RCU only for datapath.
Therefore, by this patch, ifmcaddr6 will be protected by both RTNL and RCU.

I'm so sorry for this strange changelog.

 >
 > Also :
 >
 >> @@ -571,13 +573,9 @@ int ip6_mc_msfget(struct sock *sk, struct 
group_filter *gsf,
 >>   	if (!ipv6_addr_is_multicast(group))
 >>   		return -EINVAL;
 >>
 >> -	rcu_read_lock();
 >> -	idev = ip6_mc_find_dev_rcu(net, group, gsf->gf_interface);
 >> -
 >> -	if (!idev) {
 >> -		rcu_read_unlock();
 >> +	idev = ip6_mc_find_dev_rtnl(net, group, gsf->gf_interface);
 >> +	if (!idev)
 >>   		return -ENODEV;
 >> -	}
 >>
 >
 > I do not see RTNL being acquired before entering ip6_mc_msfget()
 >

Thank you so much for catching this.
I will send a patch to fix this problem!

Thanks a lot!
Taehee Yoo
