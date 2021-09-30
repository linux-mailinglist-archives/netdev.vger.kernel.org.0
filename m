Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C969D41E49D
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349356AbhI3XQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:16:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:32665 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhI3XQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:16:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="310853764"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="310853764"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 16:14:36 -0700
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="477156623"
Received: from amitprak-mobl1.amr.corp.intel.com ([10.209.88.116])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 16:14:36 -0700
Date:   Thu, 30 Sep 2021 16:14:36 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Tim Gardner <tim.gardner@canonical.com>
cc:     mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH][next] mptcp: Avoid NULL dereference in
 mptcp_getsockopt_subflow_addrs()
In-Reply-To: <149982aa-720-35be-4866-39259b92884d@linux.intel.com>
Message-ID: <96389960-fd3-616d-c829-203d2414ffe@linux.intel.com>
References: <20210920154232.15494-1-tim.gardner@canonical.com> <149982aa-720-35be-4866-39259b92884d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021, Mat Martineau wrote:

> On Mon, 20 Sep 2021, Tim Gardner wrote:
>
>> Coverity complains of a possible NULL dereference in
>> mptcp_getsockopt_subflow_addrs():
>> 
>> 861        } else if (sk->sk_family == AF_INET6) {
>>    	3. returned_null: inet6_sk returns NULL. [show details]
>>    	4. var_assigned: Assigning: np = NULL return value from inet6_sk.
>> 862                const struct ipv6_pinfo *np = inet6_sk(sk);
>> 
>> Fix this by checking for NULL.
>> 
>> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
>> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: netdev@vger.kernel.org
>> Cc: mptcp@lists.linux.dev
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>> 
>> [ I'm not at all sure this is the right thing to do since the final result is to
>> return garbage to user space in mptcp_getsockopt_subflow_addrs(). Is this one
>> of those cases where inet6_sk() can't fail ?]
>
> Hi Tim -
>
> Thanks for noticing this and proposing a fix.
>
> As you commented, this isn't the right change to merge since 
> mptcp_getsockopt_subflow_addrs() would copy garbage.
>
> This block of code already checks that CONFIG_IPV6 is enabled, so the 
> question is whether sk_fullsock() would return false because the subflow is 
> in TCP_TIME_WAIT or TCP_NEW_SYN_RECV. The caller is iterating over sockets in 
> the MPTCP socket's conn_list, which does not contain request_socks (so there 
> are no sockets in the TCP_NEW_SYN_RECV state).
>
> TCP subflow sockets are normally removed from the conn_list before they are 
> closed by their parent MPTCP socket, but I need to double-check for corner 
> cases. I created a github issue to track this: 
> https://github.com/multipath-tcp/mptcp_net-next/issues/231
>

Tim,

Could you submit a v2 of this patch? Paolo took a look and the condition 
should not happen, but adding the NULL check would be a good idea and 
returning early as your patch does is ok. The data copied after the early 
return will be zeroed and look like the address family is AF_UNSPEC.

Could you add a

Fixes: https://github.com/multipath-tcp/mptcp_net-next/issues/231

tag and make the one change below?

>
>> ---
>> net/mptcp/sockopt.c | 3 +++
>> 1 file changed, 3 insertions(+)
>> 
>> diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
>> index 8137cc3a4296..c89f2bedce79 100644
>> --- a/net/mptcp/sockopt.c
>> +++ b/net/mptcp/sockopt.c
>> @@ -861,6 +861,9 @@ static void mptcp_get_sub_addrs(const struct sock *sk, 
>> struct mptcp_subflow_addr
>> 	} else if (sk->sk_family == AF_INET6) {
>> 		const struct ipv6_pinfo *np = inet6_sk(sk);
>> 
>> +		if (!np)

This could be

if (WARN_ON_ONCE(!np))

(as suggested by Paolo) to make it clear the condition is unexpected.

>> +			return;
>> +
>> 		a->sin6_local.sin6_family = AF_INET6;
>> 		a->sin6_local.sin6_port = inet->inet_sport;
>> 
>> -- 
>> 2.33.0

Thanks,

--
Mat Martineau
Intel
