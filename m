Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242F6240C2
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 21:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfETTAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 15:00:03 -0400
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:41748 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbfETTAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 15:00:03 -0400
Received: from pps.filterd (m0049297.ppops.net [127.0.0.1])
        by m0049297.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x4KIuAuf036735;
        Mon, 20 May 2019 15:00:01 -0400
Received: from alpi155.enaf.aldc.att.com (sbcsmtp7.sbc.com [144.160.229.24])
        by m0049297.ppops.net-00191d01. with ESMTP id 2sm1801byc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 May 2019 15:00:01 -0400
Received: from enaf.aldc.att.com (localhost [127.0.0.1])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id x4KJ00r8027643;
        Mon, 20 May 2019 15:00:00 -0400
Received: from zlp27129.vci.att.com (zlp27129.vci.att.com [135.66.87.42])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id x4KIxsoe027547
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 20 May 2019 14:59:54 -0400
Received: from zlp27129.vci.att.com (zlp27129.vci.att.com [127.0.0.1])
        by zlp27129.vci.att.com (Service) with ESMTP id F0A5340392B7;
        Mon, 20 May 2019 18:59:53 +0000 (GMT)
Received: from mlpi432.sfdc.sbc.com (unknown [144.151.223.11])
        by zlp27129.vci.att.com (Service) with ESMTP id CBF1B40392A9;
        Mon, 20 May 2019 18:59:53 +0000 (GMT)
Received: from sfdc.sbc.com (localhost [127.0.0.1])
        by mlpi432.sfdc.sbc.com (8.14.5/8.14.5) with ESMTP id x4KIxrfE029899;
        Mon, 20 May 2019 14:59:53 -0400
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by mlpi432.sfdc.sbc.com (8.14.5/8.14.5) with ESMTP id x4KIxlo6029717;
        Mon, 20 May 2019 14:59:47 -0400
Received: from [10.156.47.136] (unknown [10.156.47.136])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id 668FC360065;
        Mon, 20 May 2019 11:59:46 -0700 (PDT)
Reply-To: mmanning@vyatta.att-mail.com
Subject: Re: [PATCH net] net/ipv6: Reinstate ping/traceroute use with source
 address in VRF
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
References: <20190520084041.10393-1-mmanning@vyatta.att-mail.com>
 <1d14e6d9-5cac-064d-aa4e-bad667516c75@gmail.com>
From:   Mike Manning <mmanning@vyatta.att-mail.com>
Message-ID: <712e7529-a171-043c-f809-d55c3219a863@vyatta.att-mail.com>
Date:   Mon, 20 May 2019 19:59:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1d14e6d9-5cac-064d-aa4e-bad667516c75@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-20_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905200118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2019 17:58, David Ahern wrote:
> On 5/20/19 2:40 AM, Mike Manning wrote:
>> Since the commit 1893ff20275b ("net/ipv6: Add l3mdev check to
>> ipv6_chk_addr_and_flags"), traceroute using TCP SYN or ICMP ECHO option
>> and ping fail when specifying a source address typically on a loopback
>> /dummy interface in the same VRF, e.g.:
>>
>>     # ip vrf exec vrfgreen ping 3000::1 -I 2222::2
>>     ping: bind icmp socket: Cannot assign requested address
>>     # ip vrf exec vrfgreen traceroute 3000::1 -s 2222::2 -T
>>     bind: Cannot assign requested address
>>
>> IPv6 traceroute using default UDP and IPv4 ping & traceroute continue
>> to work inside a VRF using a source address.
>>
>> The reason is that the source address is provided via bind without a
>> device given by these applications in this case. The call to
>> ipv6_check_addr() in rawv6_bind() returns false as the default VRF is
>> assumed if no dev was given, but the src addr is in a non-default VRF.
>>
>> The solution is to check that the address exists in the L3 domain that
>> the dev is part of only if the dev has been specified.
>>
>> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
>> ---
>>  net/ipv6/addrconf.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> index f96d1de79509..3963306ec27f 100644
>> --- a/net/ipv6/addrconf.c
>> +++ b/net/ipv6/addrconf.c
>> @@ -1908,6 +1908,7 @@ int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
>>  			    int strict, u32 banned_flags)
>>  {
>>  	unsigned int hash = inet6_addr_hash(net, addr);
>> +	const struct net_device *orig_dev = dev;
>>  	const struct net_device *l3mdev;
>>  	struct inet6_ifaddr *ifp;
>>  	u32 ifp_flags;
>> @@ -1922,7 +1923,7 @@ int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
>>  		if (!net_eq(dev_net(ifp->idev->dev), net))
>>  			continue;
>>  
>> -		if (l3mdev_master_dev_rcu(ifp->idev->dev) != l3mdev)
>> +		if (orig_dev && l3mdev_master_dev_rcu(ifp->idev->dev) != l3mdev)
>>  			continue;
>>  
>>  		/* Decouple optimistic from tentative for evaluation here.
>>
> Wrong fix. When looking up the address you have to give the L3 domain of
> interest.
>
> This change:
>
> diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
> index 84dbe21b71e5..96a3559f2a09 100644
> --- a/net/ipv6/raw.c
> +++ b/net/ipv6/raw.c
> @@ -287,7 +287,9 @@ static int rawv6_bind(struct sock *sk, struct
> sockaddr *uaddr, int addr_len)
>                         /* Binding to link-local address requires an
> interface */
>                         if (!sk->sk_bound_dev_if)
>                                 goto out_unlock;
> +               }
>
> +               if (sk->sk_bound_dev_if) {
>                         err = -ENODEV;
>                         dev = dev_get_by_index_rcu(sock_net(sk),
>                                                    sk->sk_bound_dev_if);
>
> make raw binds similar to tcp. See:
>
> c5ee066333ebc ("ipv6: Consider sk_bound_dev_if when binding a socket to
> an address")
> ec90ad334986f ("ipv6: Consider sk_bound_dev_if when binding a socket to
> a v4 mapped address")

Thanks, I withdraw this submission and have submitted a new one as you
recommend.

