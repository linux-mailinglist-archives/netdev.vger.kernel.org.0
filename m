Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0351348D1
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 18:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbgAHRHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 12:07:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:12239 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbgAHRHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 12:07:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 09:06:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,410,1571727600"; 
   d="scan'208";a="254286271"
Received: from fepiepan-mobl.amr.corp.intel.com ([10.251.7.163])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jan 2020 09:06:48 -0800
Date:   Wed, 8 Jan 2020 09:06:48 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@fepiepan-mobl.amr.corp.intel.com
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next v6 05/11] tcp, ulp: Add clone operation to
 tcp_ulp_ops
In-Reply-To: <7df4cdc2-37fe-e724-a2e8-829b6920e9c6@gmail.com>
Message-ID: <alpine.OSX.2.21.2001080843490.27415@fepiepan-mobl.amr.corp.intel.com>
References: <20200108011921.28942-1-mathew.j.martineau@linux.intel.com> <20200108011921.28942-6-mathew.j.martineau@linux.intel.com> <7df4cdc2-37fe-e724-a2e8-829b6920e9c6@gmail.com>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 8 Jan 2020, Eric Dumazet wrote:

>
>
> On 1/7/20 5:19 PM, Mat Martineau wrote:
>> If ULP is used on a listening socket, icsk_ulp_ops and icsk_ulp_data are
>> copied when the listener is cloned. Sometimes the clone is immediately
>> deleted, which will invoke the release op on the clone and likely
>> corrupt the listening socket's icsk_ulp_data.
>>
>> The clone operation is invoked immediately after the clone is copied and
>> gives the ULP type an opportunity to set up the clone socket and its
>> icsk_ulp_data.
>>
>> The MPTCP ULP clone will silently fallback to plain TCP on allocation
>> failure, so 'clone()' does not need to return an error code.
>>
>> v5 -> v6:
>>  - clarified MPTCP clone usage in commit message
>>
>> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>> ---
>>  include/net/tcp.h               |  5 +++++
>>  net/ipv4/inet_connection_sock.c |  2 ++
>>  net/ipv4/tcp_ulp.c              | 12 ++++++++++++
>>  3 files changed, 19 insertions(+)
>>
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index 85f1d7ff6e8b..82879718d35a 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -2154,6 +2154,9 @@ struct tcp_ulp_ops {
>>  	/* diagnostic */
>>  	int (*get_info)(const struct sock *sk, struct sk_buff *skb);
>>  	size_t (*get_info_size)(const struct sock *sk);
>> +	/* clone ulp */
>> +	void (*clone)(const struct request_sock *req, struct sock *newsk,
>> +		      const gfp_t priority);
>>
>>  	char		name[TCP_ULP_NAME_MAX];
>>  	struct module	*owner;
>> @@ -2164,6 +2167,8 @@ int tcp_set_ulp(struct sock *sk, const char *name);
>>  void tcp_get_available_ulp(char *buf, size_t len);
>>  void tcp_cleanup_ulp(struct sock *sk);
>>  void tcp_update_ulp(struct sock *sk, struct proto *p);
>> +void tcp_clone_ulp(const struct request_sock *req,
>> +		   struct sock *newsk, const gfp_t priority);
>
>
> Maybe not needed, see below.
>
>>
>>  #define MODULE_ALIAS_TCP_ULP(name)				\
>>  	__MODULE_INFO(alias, alias_userspace, name);		\
>> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
>> index 18c0d5bffe12..bf53a722923a 100644
>> --- a/net/ipv4/inet_connection_sock.c
>> +++ b/net/ipv4/inet_connection_sock.c
>> @@ -810,6 +810,8 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
>>  		/* Deinitialize accept_queue to trap illegal accesses. */
>>  		memset(&newicsk->icsk_accept_queue, 0, sizeof(newicsk->icsk_accept_queue));
>>
>> +		tcp_clone_ulp(req, newsk, priority);
>
> Since inet_csk_clone_lock() is also used by dccp, I would suggest renaming
> this helper to inet_clone_ulp() ?

Sure, icsk_ulp_ops does reside in inet_connection_sock so that naming 
works too.

>
>> +
>>  		security_inet_csk_clone(newsk, req);
>>  	}
>>  	return newsk;
>> diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
>> index 12ab5db2b71c..e7a2589d69ee 100644
>> --- a/net/ipv4/tcp_ulp.c
>> +++ b/net/ipv4/tcp_ulp.c
>> @@ -130,6 +130,18 @@ void tcp_cleanup_ulp(struct sock *sk)
>>  	icsk->icsk_ulp_ops = NULL;
>>  }
>>
>> +void tcp_clone_ulp(const struct request_sock *req, struct sock *newsk,
>> +		   const gfp_t priority)
>> +{
>> +	struct inet_connection_sock *icsk = inet_csk(newsk);
>> +
>> +	if (!icsk->icsk_ulp_ops)
>> +		return;
>> +
>> +	if (icsk->icsk_ulp_ops->clone)
>> +		icsk->icsk_ulp_ops->clone(req, newsk, priority);
>> +}
>> +
>
> Unless I am mistaken, this is only used from  inet_csk_clone_lock()

Yes, only used there.

>
> So I would move this function in net/ipv4/inet_connection_sock.c, make it static
> so that compiler can inline it cleanly.

I'll do that. Thanks for the feedback.

--
Mat Martineau
Intel
