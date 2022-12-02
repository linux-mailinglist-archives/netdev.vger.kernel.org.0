Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092476406F6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbiLBMjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbiLBMjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:39:12 -0500
X-Greylist: delayed 928 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Dec 2022 04:39:11 PST
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F9D1006D;
        Fri,  2 Dec 2022 04:39:11 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1p154m-00011a-5T; Fri, 02 Dec 2022 13:23:32 +0100
Date:   Fri, 2 Dec 2022 13:23:32 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>, mptcp@lists.linux.dev,
        network dev <netdev@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: Broken SELinux/LSM labeling with MPTCP and accept(2)
Message-ID: <20221202122332.GC7057@breakpoint.cc>
References: <CAFqZXNs2LF-OoQBUiiSEyranJUXkPLcCfBkMkwFeM6qEwMKCTw@mail.gmail.com>
 <108a1c80eed41516f85ebb264d0f46f95e86f754.camel@redhat.com>
 <CAHC9VhSSKN5kh9Kqgj=aCeA92bX1mJm1v4_PnRgua86OHUwE3w@mail.gmail.com>
 <48dd1e9b21597c46e4767290e5892c01850a45ff.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48dd1e9b21597c46e4767290e5892c01850a45ff.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> wrote:
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index 99f5e51d5ca4..b8095b8df71d 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -3085,7 +3085,10 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
>  	/* will be fully established after successful MPC subflow creation */
>  	inet_sk_state_store(nsk, TCP_SYN_RECV);
>  
> -	security_inet_csk_clone(nsk, req);
> +	/* let's the new socket inherit the security label from the msk
> +	 * listener, as the TCP reqest socket carries a kernel context
> +	 */
> +	security_sock_graft(nsk, sk->sk_socket);
>  	bh_unlock_sock(nsk);

FWIW this makes Ondrejs test case work:

before:
mptcp successfully enabled on unit /usr/lib/systemd/system/nginx.service
% Total    % Received % Xferd  Average Speed   Time    Time     Time % Current
Dload  Upload   Total   Spent    Left Speed
0     0    0     0    0     0 0      0 --:--:-- --:--:-- --:--:-- 0
curl: (52) Empty reply from server

With above change:
mptcp successfully enabled on unit /usr/lib/systemd/system/nginx.service
% Total    % Received % Xferd  Average Speed   Time    Time     Time % Current
Dload  Upload   Total   Spent    Left Speed 100     5  100     5    0     0 1770      0 --:--:-- --:--:-- --:--:--  5000
