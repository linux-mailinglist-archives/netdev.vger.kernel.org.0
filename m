Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942F068AFC1
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 13:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjBEMoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 07:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBEMoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 07:44:11 -0500
Received: from mx07lb.world4you.com (mx07lb.world4you.com [81.19.149.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB221C323
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 04:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6flcYYr22zHfjQXBK0tBhXvf2L0GaYT2TSJBQQOxup4=; b=E/QP9NWiqILnIZDItSZqMmbP+o
        w6mp66S8j8YmsccixVupQb6mL40Uw86yvPYMoOon8uuRgFWjPqMTMDM3OUoJdT58J+hU3WZkiZsod
        rrCCvExoWH+fIiyvjMDVoIEOgkGFHqvyVks5Ls5X67v9uNUnaL7iaZ9C0jVow5W111+E=;
Received: from [88.117.49.184] (helo=[10.0.0.160])
        by mx07lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pOeNN-00068I-1Z; Sun, 05 Feb 2023 13:44:09 +0100
Message-ID: <07d7b20a-da80-5e37-b72b-eb15ad3368d9@engleder-embedded.com>
Date:   Sun, 5 Feb 2023 13:44:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 net-next 07/13] net/sched: taprio: centralize mqprio
 qopt validation
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
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
 <20230204135307.1036988-8-vladimir.oltean@nxp.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230204135307.1036988-8-vladimir.oltean@nxp.com>
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

On 04.02.23 14:53, Vladimir Oltean wrote:
> There is a lot of code in taprio which is "borrowed" from mqprio.
> It makes sense to put a stop to the "borrowing" and start actually
> reusing code.
> 
> Because taprio and mqprio are built as part of different kernel modules,
> code reuse can only take place either by writing it as static inline
> (limiting), putting it in sch_generic.o (not generic enough), or
> creating a third auto-selectable kernel module which only holds library
> code. I opted for the third variant.
> 
> In a previous change, mqprio gained support for reverse TC:TXQ mappings,
> something which taprio still denies. Make taprio use the same validation
> logic so that it supports this configuration as well.
> 
> The taprio code didn't enforce TXQ overlaps in txtime-assist mode and
> that looks intentional, even if I've no idea why that might be. Preserve
> that, but add a comment.
> 
> There isn't any dedicated MAINTAINERS entry for mqprio, so nothing to
> update there.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
