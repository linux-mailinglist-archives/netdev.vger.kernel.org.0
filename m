Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 467C016B8A
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfEGTjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:39:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfEGTjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:39:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E829614B8B70B;
        Tue,  7 May 2019 12:39:52 -0700 (PDT)
Date:   Tue, 07 May 2019 12:39:52 -0700 (PDT)
Message-Id: <20190507.123952.2046042425594195721.davem@davemloft.net>
To:     ldir@darbyshire-bryant.me.uk
Cc:     jhs@mojatatu.com, jiri@resnulli.us, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, xiyou.wangcong@gmail.com
Subject: Re: [net-next v3] net: sched: Introduce act_ctinfo action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190505131736.50496-1-ldir@darbyshire-bryant.me.uk>
References: <20190505101523.48425-1-ldir@darbyshire-bryant.me.uk>
        <20190505131736.50496-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:39:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Date: Sun, 5 May 2019 13:20:13 +0000

> ctinfo is a new tc filter action module.  It is designed to restore
> information contained in conntrack marks to other places.  At present it
> can restore DSCP values to IPv4/6 diffserv fields and also copy
> conntrack marks to skb marks.  As such the 2nd function effectively
> replaces the existing act_connmark module

This needs more time for review and therefore I'm deferring this to the
next merge window.

Also:

> +static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
> +			  struct tcf_result *res)
> +{
> +	const struct nf_conntrack_tuple_hash *thash = NULL;
> +	struct nf_conntrack_tuple tuple;
> +	enum ip_conntrack_info ctinfo;
> +	struct tcf_ctinfo *ca = to_ctinfo(a);
> +	struct tcf_ctinfo_params *cp;
> +	struct nf_conntrack_zone zone;
> +	struct nf_conn *ct;
> +	int proto, wlen;
> +	int action;

Reverse christmas tree for these local variables please.

> +static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
> +			   struct nlattr *est, struct tc_action **a,
> +			   int ovr, int bind, bool rtnl_held,
> +			   struct tcf_proto *tp,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
> +	struct tcf_ctinfo_params *cp_new;
> +	struct nlattr *tb[TCA_CTINFO_MAX + 1];
> +	struct tcf_chain *goto_ch = NULL;
> +	struct tcf_ctinfo *ci;
> +	struct tc_ctinfo *actparm;
> +	struct tc_ctinfo_dscp *dscpparm;
> +	int ret = 0, err, i;

Likewise.

> +static inline int tcf_ctinfo_dump(struct sk_buff *skb, struct tc_action *a,
> +				  int bind, int ref)
> +{
> +	unsigned char *b = skb_tail_pointer(skb);
> +	struct tcf_ctinfo *ci = to_ctinfo(a);
> +	struct tcf_ctinfo_params *cp;
> +	struct tc_ctinfo opt = {
> +		.index   = ci->tcf_index,
> +		.refcnt  = refcount_read(&ci->tcf_refcnt) - ref,
> +		.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind,
> +	};
> +	struct tcf_t t;
> +	struct tc_ctinfo_dscp dscpparm;
> +	struct tc_ctinfo_stats_dscp dscpstats;

Likewise.

Also, never use the inline keyword in foo.c files, always let the compiler
decide.
