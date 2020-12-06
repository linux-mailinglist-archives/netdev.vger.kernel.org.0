Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5402D0089
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 05:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgLFEgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 23:36:50 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:63924 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgLFEgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 23:36:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607229409; x=1638765409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ux9UQupwRxsmnTCznRymbcgrgIzmrmbRbcAbzuMG1b0=;
  b=CTTLWwUD7I7t56JF2mtBwVNHfoWgQKEE45OhnIlWDF3Q9M5HS5dq1pbZ
   JBgkKsGhBgiZgXYVe3wWc1NR08qhbIP05Em/88UEMkkfTi1n8hYe3b/7X
   kyCRL1Nfmj0EszJTMQjTb98jWZBthjIfUwmP8oj5tSOD7xfI7i+26wKt+
   A=;
X-IronPort-AV: E=Sophos;i="5.78,396,1599523200"; 
   d="scan'208";a="93749986"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 06 Dec 2020 04:36:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 5CC28C06B0;
        Sun,  6 Dec 2020 04:36:08 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 04:36:07 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.229) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 04:36:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <kuni1840@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 09/11] bpf: Support bpf_get_socket_cookie_sock() for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Sun, 6 Dec 2020 13:36:01 +0900
Message-ID: <20201206043601.26634-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201204195807.mnckuteadncd4spr@kafai-mbp.dhcp.thefacebook.com>
References: <20201204195807.mnckuteadncd4spr@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D32UWB004.ant.amazon.com (10.43.161.36) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sending this mail just for logging because I failed to send mails only 
to LKML, netdev, and bpf yesterday.


From:   Martin KaFai Lau <kafai@fb.com>
Date:   Fri, 4 Dec 2020 11:58:07 -0800
> On Tue, Dec 01, 2020 at 11:44:16PM +0900, Kuniyuki Iwashima wrote:
> > We will call sock_reuseport.prog for socket migration in the next commit,
> > so the eBPF program has to know which listener is closing in order to
> > select the new listener.
> > 
> > Currently, we can get a unique ID for each listener in the userspace by
> > calling bpf_map_lookup_elem() for BPF_MAP_TYPE_REUSEPORT_SOCKARRAY map.
> > 
> > This patch makes the sk pointer available in sk_reuseport_md so that we can
> > get the ID by BPF_FUNC_get_socket_cookie() in the eBPF program.
> > 
> > Link: https://lore.kernel.org/netdev/20201119001154.kapwihc2plp4f7zc@kafai-mbp.dhcp.thefacebook.com/
> > Suggested-by: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  include/uapi/linux/bpf.h       |  8 ++++++++
> >  net/core/filter.c              | 12 +++++++++++-
> >  tools/include/uapi/linux/bpf.h |  8 ++++++++
> >  3 files changed, 27 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index efe342bf3dbc..3e9b8bd42b4e 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1650,6 +1650,13 @@ union bpf_attr {
> >   * 		A 8-byte long non-decreasing number on success, or 0 if the
> >   * 		socket field is missing inside *skb*.
> >   *
> > + * u64 bpf_get_socket_cookie(struct bpf_sock *sk)
> > + * 	Description
> > + * 		Equivalent to bpf_get_socket_cookie() helper that accepts
> > + * 		*skb*, but gets socket from **struct bpf_sock** context.
> > + * 	Return
> > + * 		A 8-byte long non-decreasing number.
> > + *
> >   * u64 bpf_get_socket_cookie(struct bpf_sock_addr *ctx)
> >   * 	Description
> >   * 		Equivalent to bpf_get_socket_cookie() helper that accepts
> > @@ -4420,6 +4427,7 @@ struct sk_reuseport_md {
> >  	__u32 bind_inany;	/* Is sock bound to an INANY address? */
> >  	__u32 hash;		/* A hash of the packet 4 tuples */
> >  	__u8 migration;		/* Migration type */
> > +	__bpf_md_ptr(struct bpf_sock *, sk); /* current listening socket */
> >  };
> >  
> >  #define BPF_TAG_SIZE	8
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 0a0634787bb4..1059d31847ef 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -4628,7 +4628,7 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_proto = {
> >  	.func		= bpf_get_socket_cookie_sock,
> >  	.gpl_only	= false,
> >  	.ret_type	= RET_INTEGER,
> > -	.arg1_type	= ARG_PTR_TO_CTX,
> > +	.arg1_type	= ARG_PTR_TO_SOCKET,
> This will break existing bpf prog (BPF_PROG_TYPE_CGROUP_SOCK)
> using this proto.  A new proto is needed and there is
> an on-going patch doing this [0].
> 
> [0]: https://lore.kernel.org/bpf/20201203213330.1657666-1-revest@google.com/

Thank you for notifying me of this patch!
I will define another proto, but may drop the part if the above patch is
already merged then.
