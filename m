Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB3459F8CA
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 13:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbiHXLqm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Aug 2022 07:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbiHXLql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 07:46:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7465C857E3
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 04:46:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oQoq4-0004D5-1P; Wed, 24 Aug 2022 13:46:28 +0200
Date:   Wed, 24 Aug 2022 13:46:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ismael Luceno <iluceno@suse.de>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220824114628.GA14776@breakpoint.cc>
References: <20220615171113.7d93af3e@pirotess>
 <20220615090044.54229e73@kernel.org>
 <20220616171016.56d4ec9c@pirotess>
 <20220616171612.66638e54@kernel.org>
 <20220617150110.6366d5bf@pirotess>
 <9598e112-55b5-a8c0-8a52-0c0f3918e0cd@gmail.com>
 <20220617082225.333c5223@kernel.org>
 <b0246015-7fe6-7f30-c5ae-5531c126366f@gmail.com>
 <20220824125901.21a28927@pirotess>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20220824125901.21a28927@pirotess>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ismael Luceno <iluceno@suse.de> wrote:
> It seems to me now that most of the calls to nl_dump_check_consistent
> are redundant.
> 
> Either the rtnl lock is explicitly taken:
> - ethnl_tunnel_info_dumpit

That guarantess *this* invocation of ethnl_tunnel_info_dumpit doesn't
change in between, but it doesn't guarantee consistency of the dump.

rtn_lock();
cb->seq = 1
 dumping...
 skb full
unlock();

nl_dump_check_consistent();
return-to-userspace
 /* write happens, base seq increments */

next recv():
rtn_lock();
seq is now > 1
 resume dumping from pos h
unlock();
nl_dump_check_consistent(); -> prev_seq is 1 but seq > 1 -> set INTR

It doesn't really matter if dumpit() grabs RTNL or another lock or no
lock at all (rcu) unless there is a guarantee that everything will fit
in one recv() call. I am not aware of such a guarantee anywhere.

If you meant that there is another nl_dump_check_consistent() that
already covers this then I missed it.

> I assume the ones that rely on rcu_read_lock are safe too.
> 
> Also, the following ones set cb->seq just before calling it:
> - rtm_dump_nh_ctx
> - rtm_dump_res_bucket_ctx

I'm not sure what you mean, do you mean

3443 out_err:
3444         cb->seq = net->nexthop.seq;
3445         nl_dump_check_consistent(cb, nlmsg_hdr(skb));
3446         return err;
3447 }

I don't see why this is buggy.  rtm_dump_nexthop_bucket() is called
with RTNL held.  Things were different in case of RCU, because we'd miss
flagging INTR in case change happened while doing the first/initial dump
invocation.

i.e.:
- dump starts
   // parallel modification, seq increments
- set seq to *incremented* number
- prev_seq is 0,

End of next round sees seq == incremented && prev_seq == seq, no INTR
set.

For the RCU case, seq needs to be set before dump starts.
For RTNL, no parallel modifications can happen, so the above is fine.

Modification can only happen after unlock, so next dump will see
prev_seq != seq and sets the INTR flag.
