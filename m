Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C41668AF9F
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 12:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjBELzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 06:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjBELzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 06:55:20 -0500
Received: from mx16lb.world4you.com (mx16lb.world4you.com [81.19.149.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC2C619A
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 03:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vSW1i2bcCI/mt9l9NCLob+7ErHXyEWvFt3HfVim+uCc=; b=oYTx29vBKiT+jBPdQwT5NZbeOT
        NHTpZGggtSgZehw74P1xyvaIv7CbcYK4tCfOOEvV+RoSY924lVpc1TN7YMxmkDTWmM+gffWYYLK90
        rALaT6NIeayL3R84esKxBBmUNPRVgi7uQAyV+9GTUGPF0XPFLIBsEMLd+c7+5owa+wE8=;
Received: from [88.117.49.184] (helo=[10.0.0.160])
        by mx16lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pOdc2-0000g8-0y; Sun, 05 Feb 2023 12:55:14 +0100
Message-ID: <68933529-2e83-7755-0184-9cd882a61a70@engleder-embedded.com>
Date:   Sun, 5 Feb 2023 12:55:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 net-next 08/17] net/sched: mqprio: allow reverse TC:TXQ
 mappings
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-9-vladimir.oltean@nxp.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230202003621.2679603-9-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.02.23 01:36, Vladimir Oltean wrote:
> By imposing that the last TXQ of TC i is smaller than the first TXQ of
> any TC j (j := i+1 .. n), mqprio imposes a strict ordering condition for
> the TXQ indices (they must increase as TCs increase).
> 
> Claudiu points out that the complexity of the TXQ count validation is
> too high for this logic, i.e. instead of iterating over j, it is
> sufficient that the TXQ indices of TC i and i + 1 are ordered, and that
> will eventually ensure global ordering.
> 
> This is true, however it doesn't appear to me that is what the code
> really intended to do. Instead, based on the comments, it just wanted to
> check for overlaps (and this isn't how one does that).
> 
> So the following mqprio configuration, which I had recommended to
> Vinicius more than once for igb/igc (to account for the fact that on
> this hardware, lower numbered TXQs have higher dequeue priority than
> higher ones):
> 
> num_tc 4 map 0 1 2 3 queues 1@3 1@2 1@1 1@0
> 
> is in fact denied today by mqprio.
> 
> The full story is that in fact, it's only denied with "hw 0"; if
> hardware offloading is requested, mqprio defers TXQ range overlap
> validation to the device driver (a strange decision in itself).
> 
> This is most certainly a bug, but it's not one that has any merit for
> being fixed on "stable" as far as I can tell. This is because mqprio
> always rejected a configuration which was in fact valid, and this has
> shaped the way in which mqprio configuration scripts got built for
> various hardware (see igb/igc in the link below). Therefore, one could
> consider it to be merely an improvement for mqprio to allow reverse
> TC:TXQ mappings.
> 
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230130173145.475943-9-vladimir.oltean@nxp.com/#25188310
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230128010719.2182346-6-vladimir.oltean@nxp.com/#25186442
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
