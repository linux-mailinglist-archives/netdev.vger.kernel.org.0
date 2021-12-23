Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F139F47E183
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 11:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347740AbhLWKfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 05:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347734AbhLWKfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 05:35:11 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1807AC061401;
        Thu, 23 Dec 2021 02:35:11 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 43E4F59A720B6; Thu, 23 Dec 2021 11:35:08 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 3A81960C4AC90;
        Thu, 23 Dec 2021 11:35:08 +0100 (CET)
Date:   Thu, 23 Dec 2021 11:35:08 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: Re: [PATCH netfilter] netfilter: xt_owner: use sk->sk_uid for owner
 lookup
In-Reply-To: <20211223070642.499278-1-zenczykowski@gmail.com>
Message-ID: <1nrqq669-2r5o-qq5o-207r-p6pnr614s769@vanv.qr>
References: <20211223070642.499278-1-zenczykowski@gmail.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thursday 2021-12-23 08:06, Maciej Żenczykowski wrote:

>diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
>index e85ce69924ae..3eebd9c7ea4b 100644
>--- a/net/netfilter/xt_owner.c
>+++ b/net/netfilter/xt_owner.c
>@@ -84,8 +84,8 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
> 	if (info->match & XT_OWNER_UID) {
> 		kuid_t uid_min = make_kuid(net->user_ns, info->uid_min);
> 		kuid_t uid_max = make_kuid(net->user_ns, info->uid_max);
>-		if ((uid_gte(filp->f_cred->fsuid, uid_min) &&
>-		     uid_lte(filp->f_cred->fsuid, uid_max)) ^
>+		if ((uid_gte(sk->sk_uid, uid_min) &&
>+		     uid_lte(sk->sk_uid, uid_max)) ^

I have a "déjà rencontré" moment about these lines...

filp->f_cred->fsuid should be the EUID which performed the access (after
peeling away the setfsuid(2) logic...), and sk_uid has a value that the
original author of ipt_owner did not find useful. I think that was the
motivation. listen(80) then drop privileges by set(e)uid. sk_uid would be 0,
and thus not useful.
