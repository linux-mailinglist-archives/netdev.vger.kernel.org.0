Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD505F5D87
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 02:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJFALd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 20:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJFALb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 20:11:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E612232072;
        Wed,  5 Oct 2022 17:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665015090; x=1696551090;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=QfbB1xck2NZlRA+BREh90ksDTDh4H6hsxrQLHLKAXwM=;
  b=UplKDUe51F5lIhaVN0c86cqnee1ohEc7CJ+QGa6ejBpKjDiyEmUzhUbR
   Cv9lkEpyEaO7L8SRpBgwWKDB6N+dtpas5t0LATxP8Zy1yLwvVMW1Ym9r3
   MAQWcJ9FQXZUlZJ5Mh/9d2CI2QSan0g4b5xEPX+U7RxCOllaKdY6SIwFa
   bfAs0OgH7MLrwGoeO7RpZ7cV17g8WXuPqe2vEIwofAA3xRnbwUKAUizte
   73rYxuyzQv1WEA0hsreNB0ao4x7A3mnaZVfIm74nGXxRELtNf+QiT774u
   PObXYZglkcNOQMNxznRj2GtBzD4EWhNFaKHknVR4KlwKyKXFNZZeBzP4W
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="303280938"
X-IronPort-AV: E=Sophos;i="5.95,162,1661842800"; 
   d="scan'208";a="303280938"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 17:11:30 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="766941964"
X-IronPort-AV: E=Sophos;i="5.95,162,1661842800"; 
   d="scan'208";a="766941964"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 17:11:30 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net] Revert "net/sched: taprio: make qdisc_leaf() see
 the per-netdev-queue pfifo child qdiscs"
In-Reply-To: <20221004220100.1650558-1-vladimir.oltean@nxp.com>
References: <20221004220100.1650558-1-vladimir.oltean@nxp.com>
Date:   Wed, 05 Oct 2022 17:11:30 -0700
Message-ID: <87zge9olot.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> taprio_attach() has this logic at the end, which should have been
> removed with the blamed patch (which is now being reverted):
>
> 	/* access to the child qdiscs is not needed in offload mode */
> 	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> 		kfree(q->qdiscs);
> 		q->qdiscs = NULL;
> 	}
>
> because otherwise, we make use of q->qdiscs[] even after this array was
> deallocated, namely in taprio_leaf(). Therefore, whenever one would try
> to attach a valid child qdisc to a fully offloaded taprio root, one
> would immediately dereference a NULL pointer.
>
> $ tc qdisc replace dev eno0 handle 8001: parent root taprio \
> 	num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
> 	max-sdu 0 0 0 0 0 200 0 0 \
> 	base-time 200 \
> 	sched-entry S 80 20000 \
> 	sched-entry S a0 20000 \
> 	sched-entry S 5f 60000 \
> 	flags 2
> $ max_frame_size=1500
> $ data_rate_kbps=20000
> $ port_transmit_rate_kbps=1000000
> $ idleslope=$data_rate_kbps
> $ sendslope=$(($idleslope - $port_transmit_rate_kbps))
> $ locredit=$(($max_frame_size * $sendslope / $port_transmit_rate_kbps))
> $ hicredit=$(($max_frame_size * $idleslope / $port_transmit_rate_kbps))
> $ tc qdisc replace dev eno0 parent 8001:7 cbs \
> 	idleslope $idleslope \
> 	sendslope $sendslope \
> 	hicredit $hicredit \
> 	locredit $locredit \
> 	offload 0
>
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000030
> pc : taprio_leaf+0x28/0x40
> lr : qdisc_leaf+0x3c/0x60
> Call trace:
>  taprio_leaf+0x28/0x40
>  tc_modify_qdisc+0xf0/0x72c
>  rtnetlink_rcv_msg+0x12c/0x390
>  netlink_rcv_skb+0x5c/0x130
>  rtnetlink_rcv+0x1c/0x2c
>
> The solution is not as obvious as the problem. The code which deallocates
> q->qdiscs[] is in fact copied and pasted from mqprio, which also
> deallocates the array in mqprio_attach() and never uses it afterwards.
>
> Therefore, the identical cleanup logic of priv->qdiscs[] that
> mqprio_destroy() has is deceptive because it will never take place at
> qdisc_destroy() time, but just at raw ops->destroy() time (otherwise
> said, priv->qdiscs[] do not last for the entire lifetime of the mqprio
> root), but rather, this is just the twisted way in which the Qdisc API
> understands error path cleanup should be done (Qdisc_ops :: destroy() is
> called even when Qdisc_ops :: init() never succeeded).
>
> Side note, in fact this is also what the comment in mqprio_init() says:
>
> 	/* pre-allocate qdisc, attachment can't fail */
>
> Or reworded, mqprio's priv->qdiscs[] scheme is only meant to serve as
> data passing between Qdisc_ops :: init() and Qdisc_ops :: attach().
>
> [ this comment was also copied and pasted into the initial taprio
>   commit, even though taprio_attach() came way later ]
>
> The problem is that taprio also makes extensive use of the q->qdiscs[]
> array in the software fast path (taprio_enqueue() and taprio_dequeue()),
> but it does not keep a reference of its own on q->qdiscs[i] (you'd think
> that since it creates these Qdiscs, it holds the reference, but nope,
> this is not completely true).
>
> To understand the difference between taprio_destroy() and mqprio_destroy()
> one must look before commit 13511704f8d7 ("net: taprio offload: enforce
> qdisc to netdev queue mapping"), because that just muddied the waters.
>
> In the "original" taprio design, taprio always attached itself (the root
> Qdisc) to all netdev TX queues, so that dev_qdisc_enqueue() would go
> through taprio_enqueue().
>
> It also called qdisc_refcount_inc() on itself for as many times as there
> were netdev TX queues, in order to counter-balance what tc_get_qdisc()
> does when destroying a Qdisc (simplified for brevity below):
>
> 	if (n->nlmsg_type == RTM_DELQDISC)
> 		err = qdisc_graft(dev, parent=NULL, new=NULL, q, extack);
>
> qdisc_graft(where "new" is NULL so this deletes the Qdisc):
>
> 	for (i = 0; i < num_q; i++) {
> 		struct netdev_queue *dev_queue;
>
> 		dev_queue = netdev_get_tx_queue(dev, i);
>
> 		old = dev_graft_qdisc(dev_queue, new);
> 		if (new && i > 0)
> 			qdisc_refcount_inc(new);
>
> 		qdisc_put(old);
> 		~~~~~~~~~~~~~~
> 		this decrements taprio's refcount once for each TX queue
> 	}
>
> 	notify_and_destroy(net, skb, n, classid,
> 			   rtnl_dereference(dev->qdisc), new);
> 			   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 			   and this finally decrements it to zero,
> 			   making qdisc_put() call qdisc_destroy()
>
> The q->qdiscs[] created using qdisc_create_dflt() (or their
> replacements, if taprio_graft() was ever to get called) were then
> privately freed by taprio_destroy().
>
> This is still what is happening after commit 13511704f8d7 ("net: taprio
> offload: enforce qdisc to netdev queue mapping"), but only for software
> mode.
>
> In full offload mode, the per-txq "qdisc_put(old)" calls from
> qdisc_graft() now deallocate the child Qdiscs rather than decrement
> taprio's refcount. So when notify_and_destroy(taprio) finally calls
> taprio_destroy(), the difference is that the child Qdiscs were already
> deallocated.
>
> And this is exactly why the taprio_attach() comment "access to the child
> qdiscs is not needed in offload mode" is deceptive too. Not only the
> q->qdiscs[] array is not needed, but it is also necessary to get rid of
> it as soon as possible, because otherwise, we will also call qdisc_put()
> on the child Qdiscs in qdisc_destroy() -> taprio_destroy(), and this
> will cause a nasty use-after-free/refcount-saturate/whatever.
>
> In short, the problem is that since the blamed commit, taprio_leaf()
> needs q->qdiscs[] to not be freed by taprio_attach(), while qdisc_destroy()
> -> taprio_destroy() does need q->qdiscs[] to be freed by taprio_attach()
> for full offload. Fixing one problem triggers the other.
>
> All of this can be solved by making taprio keep its q->qdiscs[i] with a
> refcount elevated at 2 (in offloaded mode where they are attached to the
> netdev TX queues), both in taprio_attach() and in taprio_graft(). The
> generic qdisc_graft() would just decrement the child qdiscs' refcounts
> to 1, and taprio_destroy() would give them the final coup de grace.
>
> However the rabbit hole of changes is getting quite deep, and the
> complexity increases. The blamed commit was supposed to be a bug fix in
> the first place, and the bug it addressed is not so significant so as to
> justify further rework in stable trees. So I'd rather just revert it.
> I don't know enough about multi-queue Qdisc design to make a proper
> judgement right now regarding what is/isn't idiomatic use of Qdisc
> concepts in taprio. I will try to study the problem more and come with a
> different solution in net-next.
>
> Fixes: 1461d212ab27 ("net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs")
> Reported-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Reported-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
-- 
Vinicius
