Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0394219FA39
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 18:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgDFQiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 12:38:23 -0400
Received: from fgont.go6lab.si ([91.239.96.14]:36876 "EHLO fgont.go6lab.si"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbgDFQiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 12:38:23 -0400
Received: from [192.168.0.10] (unknown [181.45.84.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by fgont.go6lab.si (Postfix) with ESMTPSA id AAD09805BE;
        Mon,  6 Apr 2020 18:38:17 +0200 (CEST)
Subject: Re: [PATCH] [net-next] IPv6 RFC4941bis (Privacy/temporary addresses)
From:   Fernando Gont <fgont@si6networks.com>
To:     netdev <netdev@vger.kernel.org>
References: <e8eb613d-3967-3bf3-209c-630017c7f304@si6networks.com>
Message-ID: <0982c841-0dd9-c4e5-d2a9-ba1b0bd3a996@si6networks.com>
Date:   Mon, 6 Apr 2020 13:26:34 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <e8eb613d-3967-3bf3-209c-630017c7f304@si6networks.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Folks,

Any thoughts?

Thanks!
Fernando




On 2/4/20 14:06, Fernando Gont wrote:
> Folks,
> 
> This patch the upcoming revision of RFC4941: 
> https://tools.ietf.org/html/draft-ietf-6man-rfc4941bis-08 .
> 
> Namely,
> 
> * Reduces the default Valid Lifetime to 2 days
> This reduces stress on network elements, among other things
> 
> * Employs different IIDs for different prefixes
> To avoid network activity correlation among addresses configured for 
> different prefixes
> 
> * Uses a simpler algorithm for IID generation
> No need to store "history" anywhere
> 
> P.S.: The patch is also available here: 
> https://www.gont.com.ar/code/fgont-patch-linux-net-next-rfc4941bis.txt
> 
> ---- cut here ----
> diff --git Documentation/networking/ip-sysctl.txt 
> Documentation/networking/ip-sysctl.txt
> index ee961d322d93..db1ee7340090 100644
> --- Documentation/networking/ip-sysctl.txt
> +++ Documentation/networking/ip-sysctl.txt
> @@ -1807,7 +1807,7 @@ use_tempaddr - INTEGER
> 
>   temp_valid_lft - INTEGER
>       valid lifetime (in seconds) for temporary addresses.
> -    Default: 604800 (7 days)
> +    Default: 172800 (2 days)
> 
>   temp_prefered_lft - INTEGER
>       Preferred lifetime (in seconds) for temporary addresses.
> diff --git include/net/addrconf.h include/net/addrconf.h
> index e0eabe58aa8b..1bd21ee035bf 100644
> --- include/net/addrconf.h
> +++ include/net/addrconf.h
> @@ -8,7 +8,7 @@
> 
>   #define MIN_VALID_LIFETIME        (2*3600)    /* 2 hours */
> 
> -#define TEMP_VALID_LIFETIME        (7*86400)
> +#define TEMP_VALID_LIFETIME        (2*86400)
>   #define TEMP_PREFERRED_LIFETIME        (86400)
>   #define REGEN_MAX_RETRY            (3)
>   #define MAX_DESYNC_FACTOR        (600)
> diff --git include/net/if_inet6.h include/net/if_inet6.h
> index a01981d7108f..212eb278bda6 100644
> --- include/net/if_inet6.h
> +++ include/net/if_inet6.h
> @@ -190,7 +190,6 @@ struct inet6_dev {
>       int            dead;
> 
>       u32            desync_factor;
> -    u8            rndid[8];
>       struct list_head    tempaddr_list;
> 
>       struct in6_addr        token;
> diff --git net/ipv6/addrconf.c net/ipv6/addrconf.c
> index a11fd4d67832..da34dbbd0195 100644
> --- net/ipv6/addrconf.c
> +++ net/ipv6/addrconf.c
> @@ -135,8 +135,7 @@ static inline void addrconf_sysctl_unregister(struct 
> inet6_dev *idev)
>   }
>   #endif
> 
> -static void ipv6_regen_rndid(struct inet6_dev *idev);
> -static void ipv6_try_regen_rndid(struct inet6_dev *idev, struct 
> in6_addr *tmpaddr);
> +static void ipv6_gen_rnd_iid(struct in6_addr *addr);
> 
>   static int ipv6_generate_eui64(u8 *eui, struct net_device *dev);
>   static int ipv6_count_addresses(const struct inet6_dev *idev);
> @@ -432,8 +431,7 @@ static struct inet6_dev *ipv6_add_dev(struct 
> net_device *dev)
>           dev->type == ARPHRD_SIT ||
>           dev->type == ARPHRD_NONE) {
>           ndev->cnf.use_tempaddr = -1;
> -    } else
> -        ipv6_regen_rndid(ndev);
> +    }
> 
>       ndev->token = in6addr_any;
> 
> @@ -1306,12 +1304,11 @@ static void ipv6_del_addr(struct inet6_ifaddr *ifp)
>       in6_ifa_put(ifp);
>   }
> 
> -static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp,
> -                struct inet6_ifaddr *ift,
> -                bool block)
> +static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
>   {
>       struct inet6_dev *idev = ifp->idev;
> -    struct in6_addr addr, *tmpaddr;
> +    struct in6_addr addr;
> +    struct inet6_ifaddr *ift;
>       unsigned long tmp_tstamp, age;
>       unsigned long regen_advance;
>       struct ifa6_config cfg;
> @@ -1321,14 +1318,7 @@ static int ipv6_create_tempaddr(struct 
> inet6_ifaddr *ifp,
>       s32 cnf_temp_preferred_lft;
> 
>       write_lock_bh(&idev->lock);
> -    if (ift) {
> -        spin_lock_bh(&ift->lock);
> -        memcpy(&addr.s6_addr[8], &ift->addr.s6_addr[8], 8);
> -        spin_unlock_bh(&ift->lock);
> -        tmpaddr = &addr;
> -    } else {
> -        tmpaddr = NULL;
> -    }
> +
>   retry:
>       in6_dev_hold(idev);
>       if (idev->cnf.use_tempaddr <= 0) {
> @@ -1351,8 +1341,8 @@ static int ipv6_create_tempaddr(struct 
> inet6_ifaddr *ifp,
>       }
>       in6_ifa_hold(ifp);
>       memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
> -    ipv6_try_regen_rndid(idev, tmpaddr);
> -    memcpy(&addr.s6_addr[8], idev->rndid, 8);
> +    ipv6_gen_rnd_iid(&addr);
> +
>       age = (now - ifp->tstamp) / HZ;
> 
>       regen_advance = idev->cnf.regen_max_retry *
> @@ -1417,7 +1407,6 @@ static int ipv6_create_tempaddr(struct 
> inet6_ifaddr *ifp,
>           in6_ifa_put(ifp);
>           in6_dev_put(idev);
>           pr_info("%s: retry temporary address regeneration\n", __func__);
> -        tmpaddr = &addr;
>           write_lock_bh(&idev->lock);
>           goto retry;
>       }
> @@ -2032,7 +2021,7 @@ static void addrconf_dad_stop(struct inet6_ifaddr 
> *ifp, int dad_failed)
>           if (ifpub) {
>               in6_ifa_hold(ifpub);
>               spin_unlock_bh(&ifp->lock);
> -            ipv6_create_tempaddr(ifpub, ifp, true);
> +            ipv6_create_tempaddr(ifpub, true);
>               in6_ifa_put(ifpub);
>           } else {
>               spin_unlock_bh(&ifp->lock);
> @@ -2329,42 +2318,39 @@ static int ipv6_inherit_eui64(u8 *eui, struct 
> inet6_dev *idev)
>       return err;
>   }
> 
> -/* (re)generation of randomized interface identifier (RFC 3041 3.2, 
> 3.5) */
> -static void ipv6_regen_rndid(struct inet6_dev *idev)
> +/* Generation of a randomized Interface Identifier 
> draft-ietf-6man-rfc4941bis, Section 3.3.1 */
> +static void ipv6_gen_rnd_iid(struct in6_addr *addr)
>   {
>   regen:
> -    get_random_bytes(idev->rndid, sizeof(idev->rndid));
> -    idev->rndid[0] &= ~0x02;
> +    get_random_bytes(&addr->s6_addr[8], 8);
> 
>       /*
> -     * <draft-ietf-ipngwg-temp-addresses-v2-00.txt>:
> -     * check if generated address is not inappropriate
> +     *  <draft-ietf-6man-rfc4941bis-08.txt>, Section 3.3.1:
> +     *  check if generated address is not inappropriate:
> +     *
> +     *  - Reserved IPv6 Interface Identifers
> +     * 
> (http://www.iana.org/assignments/ipv6-interface-ids/ipv6-interface-ids.xhtml) 
> 
>        *
> -     *  - Reserved subnet anycast (RFC 2526)
> -     *    11111101 11....11 1xxxxxxx
> -     *  - ISATAP (RFC4214) 6.1
> -     *    00-00-5E-FE-xx-xx-xx-xx
> -     *  - value 0
>        *  - XXX: already assigned to an address on the device
>        */
> -    if (idev->rndid[0] == 0xfd &&
> - 
> (idev->rndid[1]&idev->rndid[2]&idev->rndid[3]&idev->rndid[4]&idev->rndid[5]&idev->rndid[6]) 
> == 0xff &&
> -        (idev->rndid[7]&0x80))
> +
> +    /* Subnet-router anycast: 0000:0000:0000:0000 */
> +    if (!(addr->s6_addr32[2] | addr->s6_addr32[3]))
>           goto regen;
> -    if ((idev->rndid[0]|idev->rndid[1]) == 0) {
> -        if (idev->rndid[2] == 0x5e && idev->rndid[3] == 0xfe)
> -            goto regen;
> -        if 
> ((idev->rndid[2]|idev->rndid[3]|idev->rndid[4]|idev->rndid[5]|idev->rndid[6]|idev->rndid[7]) 
> == 0x00)
> -            goto regen;
> -    }
> -}
> 
> -static void  ipv6_try_regen_rndid(struct inet6_dev *idev, struct 
> in6_addr *tmpaddr)
> -{
> -    if (tmpaddr && memcmp(idev->rndid, &tmpaddr->s6_addr[8], 8) == 0)
> -        ipv6_regen_rndid(idev);
> +    /* IANA Ethernet block: 0200:5EFF:FE00:0000-0200:5EFF:FE00:5212
> +       Proxy Mobile IPv6:   0200:5EFF:FE00:5213
> +       IANA Ethernet block: 0200:5EFF:FE00:5214-0200:5EFF:FEFF:FFFF
> +    */
> +    if (ntohl(addr->s6_addr32[2]) == 0x02005eff && 
> (ntohl(addr->s6_addr32[3]) & 0Xff000000) == 0xfe000000)
> +        goto regen;
> +
> +    /* Reserved subnet anycast addresses */
> +    if (ntohl(addr->s6_addr32[2]) == 0xfdffffff && 
> ntohl(addr->s6_addr32[3]) >= 0Xffffff80)
> +        goto regen;
>   }
> 
> +
>   /*
>    *    Add prefix route.
>    */
> @@ -2544,7 +2530,7 @@ static void manage_tempaddrs(struct inet6_dev *idev,
>            * no temporary address currently exists.
>            */
>           read_unlock_bh(&idev->lock);
> -        ipv6_create_tempaddr(ifp, NULL, false);
> +        ipv6_create_tempaddr(ifp, false);
>       } else {
>           read_unlock_bh(&idev->lock);
>       }
> @@ -4539,7 +4525,7 @@ static void addrconf_verify_rtnl(void)
>                           ifpub->regen_count = 0;
>                           spin_unlock(&ifpub->lock);
>                           rcu_read_unlock_bh();
> -                        ipv6_create_tempaddr(ifpub, ifp, true);
> +                        ipv6_create_tempaddr(ifpub, true);
>                           in6_ifa_put(ifpub);
>                           in6_ifa_put(ifp);
>                           rcu_read_lock_bh();
> ---- cut here ----
> 
> Thanks,


-- 
Fernando Gont
SI6 Networks
e-mail: fgont@si6networks.com
PGP Fingerprint: 6666 31C6 D484 63B2 8FB1 E3C4 AE25 0D55 1D4E 7492




