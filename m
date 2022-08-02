Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F568588008
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbiHBQNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237816AbiHBQNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:13:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4E64D178
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 09:11:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD0A1B81F47
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 16:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C66C433C1;
        Tue,  2 Aug 2022 16:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659456672;
        bh=Mqitr52KPe71Z+enBRADfI74mqX1cvYbr+NmIBsDzCc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q8CYpe9SmjFmmJWHWXyDa7wjhBZuIIvGsFzvx/Hpwx2Rk8G0CllwWfa42owjfTiuN
         l8PlbfLGjCcM8IBIuwLjMOy31hpPHzLfXjdl+Ei8T6QKWYiamdSm8WCSkzB+sfRpYj
         YyZbMkY74Qc940xRZGg4aCFzscXYqeBmQ3FlgGYiJzg3SVmQAyiQka3/p/podVarJl
         nuGseaRbujnQZwr9/00eqeAFhFWIGE7BASvCNQsuE1mL9/o1zqTfREOwxDpfaUncfT
         FDNej4mSE8B6dtifvmq/3xxvAbcMbjpSGqFfjsD5So0u9qTvvD70d+ivCfXQtLLXXp
         RJRORj+MLc4dg==
Date:   Tue, 2 Aug 2022 09:11:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with
 the jiffies of the last ARP/NS
Message-ID: <20220802091110.036d40dd@kernel.org>
In-Reply-To: <d04773ee3e6b6dee88a1362bbc537bf51b020238.camel@redhat.com>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
        <20220731124108.2810233-2-vladimir.oltean@nxp.com>
        <1547.1659293635@famine>
        <20220731191327.cey4ziiez5tvcxpy@skbuf>
        <5679.1659402295@famine>
        <20220802014553.rtyzpkdvwnqje44l@skbuf>
        <d04773ee3e6b6dee88a1362bbc537bf51b020238.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 02 Aug 2022 11:05:19 +0200 Paolo Abeni wrote:
> In any case, this looks like a significative rework, do you mind
> consider it for the net-next, when it re-open?

It does seem like it could be a lot for stable.

Perhaps we could take:

https://lore.kernel.org/all/20220727152000.3616086-1-vladimir.oltean@nxp.com/

as is, without the extra work Stephen asked for (since it's gonna be
reverted in net-next, anyway)? How do you feel about that option?
