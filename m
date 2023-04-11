Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678EE6DE3B5
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjDKSSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjDKSSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:18:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5885A4EDA;
        Tue, 11 Apr 2023 11:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB59D62695;
        Tue, 11 Apr 2023 18:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B75FC433EF;
        Tue, 11 Apr 2023 18:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681237089;
        bh=5WbQ6Px1ipYXbNSrJn/zqSw7euJ7xa/HCvA4TxvFMHA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G6vSZrwW1LCkXv27pgvnkjBPDwR5+hzHBtD0xgR4Xz4wOVp2ixc5Gqjfqu+aqls8r
         u1hnCxQmnFz9Kn7ojz6CX+hMUe8OtbnUC/zq6859gf/gRP+0KD1jBuLWeqhu7qUmFK
         DH0DwQtY9/GSEpagyl2J4HuEvFdOi50iat7H1+SJSGubVgBdy1YnrRcfYNPYgAPZZb
         fcY2nHJgQ31OuiS1UxmE362Hnf4QVVPMdAJto4oognOBvhH/Ukk9YlzNxR4Jhzsqwn
         Gx7k0A+z2QiUdw8/GczNtYRhhyRmpFxIOhlB9P32/2pxdYNZic0yv44SSjVAAVW9a0
         K5ShjJ81Ww5dQ==
Date:   Tue, 11 Apr 2023 11:18:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user
 input of FP adminStatus
Message-ID: <20230411111807.6b5a64cb@kernel.org>
In-Reply-To: <20230411170151.ii7onipewbd27uw6@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
        <20230403103440.2895683-7-vladimir.oltean@nxp.com>
        <20230405181234.35dbd2f9@kernel.org>
        <20230411170151.ii7onipewbd27uw6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Apr 2023 20:01:51 +0300 Vladimir Oltean wrote:
> > > +	int err, tc;
> > > +
> > > +	err = nla_parse_nested(tb, TCA_MQPRIO_TC_ENTRY_MAX, opt,
> > > +			       mqprio_tc_entry_policy, extack);
> > > +	if (err < 0)
> > > +		return err;
> > > +
> > > +	if (!tb[TCA_MQPRIO_TC_ENTRY_INDEX]) {
> > > +		NL_SET_ERR_MSG(extack, "TC entry index missing");  
> > 
> > Are you not using NL_REQ_ATTR_CHECK() because iproute can't actually
> > parse the result? :(  
> 
> I could use it though.. let's assume that iproute2 is "reference code"
> and gets the nlattr structure right. Thus, the NLMSGERR_ATTR_MISS_NEST
> would be of more interest for custom user programs.
> 
> Speaking of which, is there any reference example of how to use
> NLMSGERR_ATTR_MISS_NEST? My search came up empty handed:
> https://github.com/search?p=1&q=NLMSGERR_ATTR_MISS_NEST&type=Code

Only YNL to my knowledge, basic support in the in-tree Python:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/tools/net/ynl/lib/ynl.py#n198
And fuller support in the user space hacks which never made it out
of my GitHub:
https://github.com/kuba-moo/linux/blob/ynl-user-c-wip/tools/net/ynl/lib/ynl.c#L163

> I usually steal from hostap's error_handler(), but it looks like it
> hasn't gotten that advanced yet as to re-parse the netlink message to
> understand the reason why it got rejected.
