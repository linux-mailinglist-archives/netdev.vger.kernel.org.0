Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8123D5B90F1
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiINXRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiINXRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:17:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BDF816BC;
        Wed, 14 Sep 2022 16:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663197437; x=1694733437;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=Qiox5wufUKovIQD2LwljILtoHEckzqBMuDeL94CnBYs=;
  b=eutH8J40ctUU+bVBFrZrRUo/z14Bz6uFNLUsH1P6mSBLOe//l5P9yxRh
   E9FRAIqjl7M7QqwbuEuNL69J/GT/nSYAgJuKwk1C3l3YG8zrY02FSSRKN
   ziMB/kQQ74YXsRRhNNsxe3hwTcWFvdQvzoiIVPIZHartCorDUjjWhkdVQ
   /MvAxpbm4RasqZz3HoBKjCxIwsag27irjvwrgqd9q3ZP4wg49EhNKzyCM
   F32R0fe8s0Qtoi51WANvictIY0pFTcxN/oSgdfIbUJUFsAwm0GfnzT/EN
   XbvSEvM0BbbsrNyJEHi3VkhF6CnnHGwRNWdMWhfl/nP2Kyw9AwQvMNVGC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="299922687"
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="299922687"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 16:17:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="594581982"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 16:17:16 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 04/13] net/sched: taprio: allow user input of
 per-tc max SDU
In-Reply-To: <20220914230335.lioxtjxbjiyd7ds4@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-5-vladimir.oltean@nxp.com>
 <87k065iqe1.fsf@intel.com> <20220914221042.oenxhxacgt2xsb2k@skbuf>
 <871qsdimtk.fsf@intel.com> <20220914230335.lioxtjxbjiyd7ds4@skbuf>
Date:   Wed, 14 Sep 2022 16:17:16 -0700
Message-ID: <87illph7gj.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Wed, Sep 14, 2022 at 04:00:07PM -0700, Vinicius Costa Gomes wrote:
>> Hm, I just noticed something.
>> 
>> During parse the user only sets the max-sdu for the traffic classes she
>> is interested on. During dump you are showing all of them, the unset
>> ones will be shown as zero, that seems a bit confusing, which could mean
>> that you would have to add some checks anyway.
>> 
>> For the offload side, you could just document that U32_MAX means unset.
>
> Yes, choosing '0' rather than other value, to mean 'default to port MTU'
> was intentional. It is also in line with what other places, like the
> YANG models, expect to see:
> https://github.com/YangModels/yang/blob/main/standard/ieee/draft/802.1/Qcw/ieee802-dot1q-sched.yang#L128

Oh, I see. My bad. So, only that comment about thinking about making the
comparison simpler is still valid.


Cheers,
-- 
Vinicius
