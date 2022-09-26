Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622815EAFAD
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiIZSXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiIZSX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:23:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9CB10E4;
        Mon, 26 Sep 2022 11:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664216473; x=1695752473;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=UsK+7D3FoPGcFjhaXGMgThTNGxv81x/VXSh4MA3UMJ0=;
  b=VzhYZqv2eMNK1Z1Nd4OpV4sLBVdC0PMI6fllQpNgX7btJwi+Dru19RzY
   Yh4iGVA9Asb9XbYNZJnMHL07qgY1cx9IacRf7pzwu8GlMn9CirJ3VXbU9
   VgIvCr7dHewvMFL589f7AuN3vrH8MXwVI4btgi7iZxM3Z2ygpdlziOt2W
   0iJE6LuPzoyE8iFs86aJlS5SbcnbBdFPyW8teWD+wBDq+PboZ9yy8ff6I
   wZ2GFzrcQeZ/GB2UXPRFNzk9OjXydmmU1qeer4Eho100wTikngA7dXTwd
   JgkAdRp/gYfOLlVbhuIlrPaIgTZFnHPftq4NtNMHtodWQTbcsRPo8EqRk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="281478099"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="281478099"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 11:21:12 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="746717533"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="746717533"
Received: from unknown (HELO vcostago-mobl3) ([10.209.47.116])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 11:21:12 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: taprio: simplify list iteration in
 taprio_dev_notifier()
In-Reply-To: <20220923145921.3038904-1-vladimir.oltean@nxp.com>
References: <20220923145921.3038904-1-vladimir.oltean@nxp.com>
Date:   Mon, 26 Sep 2022 11:21:11 -0700
Message-ID: <87illa80a0.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> taprio_dev_notifier() subscribes to netdev state changes in order to
> determine whether interfaces which have a taprio root qdisc have changed
> their link speed, so the internal calculations can be adapted properly.
>
> The 'qdev' temporary variable serves no purpose, because we just use it
> only once, and can just as well use qdisc_dev(q->root) directly (or the
> "dev" that comes from the netdev notifier; this is because qdev is only
> interesting if it was the subject of the state change, _and_ its root
> qdisc belongs in the taprio list).
>
> The 'found' variable also doesn't really serve too much of a purpose
> either; we can just call taprio_set_picos_per_byte() within the loop,
> and exit immediately afterwards.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Thanks,

Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
-- 
Vinicius
