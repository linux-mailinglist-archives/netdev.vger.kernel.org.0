Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F8B63392A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiKVJ4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiKVJ4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:56:46 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A71D19006
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:56:45 -0800 (PST)
Date:   Tue, 22 Nov 2022 10:56:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669111003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TuiciRZgZmN+FCicWYJgj0BqEPgCkw2j5LIF5xdT8g4=;
        b=NTRWzBRxq0ey3fW3ApDIolWTyDgh7xDIMT5ctXGM2KG+3Sr3XLLA/vxa8+D2JcP3iw01Pc
        MsIKoGLfYGqMmm6UEtzfFBAArswXJVpKpLi2ciorEhd4RL27DVL8ukuQTHa6WJZSN3O2rF
        1SMrn0vmoxzh4ciN9K5Kv4qLdRzP7BIDRfLyo1zsrnRwRc6emwL/n38H0tzWDF+PK8AcTN
        hdFIfbcnRKO0LkZAj/ZZUa4p5/p1aqlXLEUVYzyDZokS0O/PkEvdb9nF9IvK7d/gytDVOC
        xvD0Vlgr55GybASGK2SrBMyiu0FOUJroE5SWMtluvpo+ckWz65SqJGzco98CGw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669111003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TuiciRZgZmN+FCicWYJgj0BqEPgCkw2j5LIF5xdT8g4=;
        b=e1vvjZuh+iU2xv6doYgKyVwKjlZH358bsKk5sGKrYmVTtgwCG5Ya0c6k98i2kq+zGvEJQl
        7K+DJzO7sVCpjYAg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 net 7/7] hsr: Use a single struct for self_node.
Message-ID: <Y3yc2CrT3Wz6L57a@linutronix.de>
References: <20221121174605.2456845-1-bigeasy@linutronix.de>
 <20221121174605.2456845-8-bigeasy@linutronix.de>
 <87sfib9wge.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87sfib9wge.fsf@kurt>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-22 10:20:49 [+0100], Kurt Kanzenbach wrote:
> On Mon Nov 21 2022, Sebastian Andrzej Siewior wrote:
> > self_node_db is a list_head with one entry of struct hsr_node. The
> > purpose is to hold the two MAC addresses of the node itself.
> > It is convenient to recycle the structure. However having a list_head
> > and fetching always the first entry is not really optimal.
> >
> > Created a new data strucure contaning the two MAC addresses named
> > hsr_self_node. Access that structured like an RCU protected pointer so
>                              ^ structure
> 
> > it can be replaced on the fly withou blocking the reader.
>                                ^ without

argh.

> >
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Lacks a Fixes tag. Looks rather like an optimization than a bugfix? So,
> maybe this one should go to net-next instead.

The initial motivation for
	hsr: Avoid double remove of a node

was to use hlist_del_init_rcu() for the remove and then use
hlist_unhashed() for the check. This got me to this because I was not
sure why we have this list for a single node which isn't needed and
looks like waste of memory and confusion (a list for a single entry?).
In the end I decided midway to stay with the list_head and just add a
`removed' field to deal with this.

Can we ignore this patch and then I repost just that one for next?

> [snip]
> 
> > +struct hsr_self_node {
> > +	unsigned char	macaddress_A[6];
>                                     ^ ETH_ALEN
> 
> > +	unsigned char	macaddress_B[6];
>                                     ^ ETH_ALEN
> > +	struct rcu_head	rcu_head;
> > +};
> > +

Sure.

> Thanks,
> Kurt
Sebastian

