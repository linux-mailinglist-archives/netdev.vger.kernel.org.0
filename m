Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1BE79D49
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 02:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbfG3AXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 20:23:33 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45794 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbfG3AXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 20:23:33 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so29057375pgp.12;
        Mon, 29 Jul 2019 17:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SDS/oRbp3ndQD48erCJR8LYHts1U4WFu/TkobcIYFLU=;
        b=K7Px++GyUB3IKchznHVKlpORjcHhnjcdO6Lw067w6ofIzdRXflKRgfr3ZFCzzGfrLp
         xXxVa9do5SNUJCaGd5yUkgiUOXV45J8S6jDKMNVw8AXl0TMfRzsgP5+eEKITgCezoBKn
         DGrDJETdxGJEUcMwZL4HgYXgSX9/zspKvJ66ODuUYM5SCxwKhfPMQXupCrw9CKehZdWI
         uxlY9PrDQR9tc5cb63vDo23DQ+1Cf0KseuXbMjfHC5VomKrUXiJglEzfZ6sBGDNLc5Gg
         8f2lFSMjnks1nFi4Y2rmokYXB9qpyPPgEDKaI0VSN2BESinSKo8N0Jv3z1TfkGjz/k80
         PiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SDS/oRbp3ndQD48erCJR8LYHts1U4WFu/TkobcIYFLU=;
        b=uhix5wd26pemwhdrlBMQihdLBpwuIvt04TlaStN9seftHbP2S4vHR03RjqJaWzOnN9
         OXQRpXU9DMmxyEgcNk3HwC+mjP5LLxzzwH+uiwIziesQzbTmn8eLKOsWR9EzuLZmgeRf
         mfU2uQ81EXTu4cN4nD/yLsDMfbL/sGXEuCGMBWMx5Fz3v3YAoYxhSPdLkT6/62/L08pr
         aug4kZMp780VUr2qANx3SgL0vb5oTdK4sntmw0i5yFPb2NjXnTvZ3BwGQTdfCIpkDPhf
         lwn+e4Rqg/TWQloFyHPwBomRuPe+zyS/e7PqKY6Vn0TNRzWtToGNtBv7dAx/o2Yg9bGC
         z/pQ==
X-Gm-Message-State: APjAAAWJz03/0ybQM9Gyaub4BMV9XYni4lRTv4v8TOAr1Kg3cYifS3pP
        O1ULw4mABEIfCDZLtTKuVJhULKvO
X-Google-Smtp-Source: APXvYqwAc8rdlD+UPsbJp6Atian7nae1A5y24Hm5XKecZwzNVtco3YvJ9gjxt47hwdUsAQQOgRZSow==
X-Received: by 2002:a17:90a:36a7:: with SMTP id t36mr112276735pjb.34.1564446211820;
        Mon, 29 Jul 2019 17:23:31 -0700 (PDT)
Received: from [172.27.227.219] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id v126sm251489pgb.23.2019.07.29.17.23.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 17:23:30 -0700 (PDT)
Subject: Re: [PATCH net] net: ipv6: Fix a bug in ndisc_send_ns when netdev
 only has a global address
To:     Su Yanjun <suyj.fnst@cn.fujitsu.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1564368591-42301-1-git-send-email-suyj.fnst@cn.fujitsu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4889aab0-5d79-bbba-1286-91d89c55fc1e@gmail.com>
Date:   Mon, 29 Jul 2019 18:23:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1564368591-42301-1-git-send-email-suyj.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/19 8:49 PM, Su Yanjun wrote:
> When we send mpls packets and the interface only has a
> manual global ipv6 address, then the two hosts cant communicate.
> I find that in ndisc_send_ns it only tries to get a ll address.
> In my case, the executive path is as below.
> ip6_output
>  ->ip6_finish_output
>   ->lwtunnel_xmit
>    ->mpls_xmit
>     ->neigh_resolve_output
>      ->neigh_probe
>       ->ndisc_solicit
>        ->ndisc_send_ns

for the archives, this is not an MPLS problem but a general IPv6
forwarding problem when the egress interface does not have a link local
address.

> 
> In RFC4861, 7.2.2 says
> "If the source address of the packet prompting the solicitation is the
> same as one of the addresses assigned to the outgoing interface, that
> address SHOULD be placed in the IP Source Address of the outgoing
> solicitation.  Otherwise, any one of the addresses assigned to the
> interface should be used."
> 
> In this patch we try get a global address if we get ll address failed.
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> ---
>  include/net/addrconf.h |  4 ++++
>  net/ipv6/addrconf.c    | 34 ++++++++++++++++++++++++++++++++++
>  net/ipv6/ndisc.c       |  8 ++++++--
>  3 files changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> index becdad5..006db8e 100644
> --- a/include/net/addrconf.h
> +++ b/include/net/addrconf.h
> @@ -107,6 +107,10 @@ int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
>  		      u32 banned_flags);
>  int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
>  		    u32 banned_flags);
> +int __ipv6_get_addr(struct inet6_dev *idev, struct in6_addr *addr,
> +		      u32 banned_flags);

no reason to export __ipv6_get_addr. I suspect you copied
__ipv6_get_lladdr but it has an external (to addrconf.c) user. In this
case only ipv6_get_addr needs to be exported.


> +int ipv6_get_addr(struct net_device *dev, struct in6_addr *addr,
> +		    u32 banned_flags);
>  bool inet_rcv_saddr_equal(const struct sock *sk, const struct sock *sk2,
>  			  bool match_wildcard);
>  bool inet_rcv_saddr_any(const struct sock *sk);
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 521e320..4c0a43f 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -1870,6 +1870,40 @@ int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
>  	return err;
>  }
>  
> +int __ipv6_get_addr(struct inet6_dev *idev, struct in6_addr *addr,
> +		    u32 banned_flags)
> +{
> +	struct inet6_ifaddr *ifp;
> +	int err = -EADDRNOTAVAIL;
> +
> +	list_for_each_entry_reverse(ifp, &idev->addr_list, if_list) {

Addresses are ordered by scope. __ipv6_get_lladdr uses
list_for_each_entry_reverse because the LLA's are after the globals.
Since this is falling back to 'give an address' from this interface, I
think you can just use list_for_each_entry.


> +		if (ifp->scope == 0 &&
> +		    !(ifp->flags & banned_flags)) {
> +			*addr = ifp->addr;
> +			err = 0;
> +			break;
> +		}
> +	}
> +	return err;
> +}
> +
> +int ipv6_get_addr(struct net_device *dev, struct in6_addr *addr,
> +		  u32 banned_flags)
> +{
> +	struct inet6_dev *idev;
> +	int err = -EADDRNOTAVAIL;
> +
> +	rcu_read_lock();
> +	idev = __in6_dev_get(dev);
> +	if (idev) {
> +		read_lock_bh(&idev->lock);
> +		err = __ipv6_get_addr(idev, addr, banned_flags);
> +		read_unlock_bh(&idev->lock);
> +	}
> +	rcu_read_unlock();
> +	return err;
> +}
> +
>  static int ipv6_count_addresses(const struct inet6_dev *idev)
>  {
>  	const struct inet6_ifaddr *ifp;
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index 083cc1c..18ac2fb 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -606,8 +606,12 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
>  
>  	if (!saddr) {

And since you are going to do a v2, another nit - define a local banned
flags and use it for both lookups just to make it clear.

		u32 banned_flags = IFA_F_TENTATIVE | IFA_F_OPTIMISTIC;

>  		if (ipv6_get_lladdr(dev, &addr_buf,
> -				   (IFA_F_TENTATIVE|IFA_F_OPTIMISTIC)))
> -			return;
> +				   (IFA_F_TENTATIVE | IFA_F_OPTIMISTIC))) {
> +			/* try global address */
> +			if (ipv6_get_addr(dev, &addr_buf,
> +					  (IFA_F_TENTATIVE | IFA_F_OPTIMISTIC)))
> +				return;
> +		}
>  		saddr = &addr_buf;
>  	}
>  
> 

