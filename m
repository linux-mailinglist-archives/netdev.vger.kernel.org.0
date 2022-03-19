Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14914DE4F3
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 02:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241697AbiCSBM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 21:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241693AbiCSBMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 21:12:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A25428AC40
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 18:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647652295; x=1679188295;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=MkYrly5dkcCF89KeQ7YonSyUBx6dtsTmznDlfZySfHk=;
  b=BE8JuX3KrqXe2ResECSSwyvabj4hPSdiwgCjxekQeyWR5+RgM7+g4jSn
   xQxnsBM5bixqW+v/z0464Icul0rwpjIw7/n1zdogAVB5WuPpgbmTMYqNu
   1mVgdXtf2NAW2v49PPP7uCMhWdcZWxH0FCWbSNW9BNpY83KaGIlRpZB4d
   49zmIY++aFBiefEcpzcuYlOlNtOqkvQXk7QS+1XF77kcorxQ6BsRTtRI9
   gJs/TNnLSH/Fq4vtKNR88dIqnAMxnSFco2IgAZpNC8TfFF1uBPHQyLuv4
   62Cii3GuNUb4x7Cb9u8yllksrf+DeUYai+7BEj3Fjzj8WCAfQTfk2yKZ0
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="320467848"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="320467848"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 18:11:34 -0700
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="635963361"
Received: from jbchavez-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.40.231])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 18:11:34 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Benedikt Spranger <b.spranger@linutronix.de>,
        netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 1/1] net/sched: taprio: Check if socket flags are valid
In-Reply-To: <20220318142532.313226-2-b.spranger@linutronix.de>
References: <20220318142532.313226-1-b.spranger@linutronix.de>
 <20220318142532.313226-2-b.spranger@linutronix.de>
Date:   Fri, 18 Mar 2022 18:11:33 -0700
Message-ID: <87k0cqvj96.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benedikt Spranger <b.spranger@linutronix.de> writes:

> A user may set the SO_TXTIME socket option to ensure a packet is send
> at a given time. The taprio scheduler has to confirm, that it is allowed
> to send a packet at that given time, by a check against the packet time
> schedule. The scheduler drop the packet, if the gates are closed at the
> given send time.
>
> The check, if SO_TXTIME is set, may fail since sk_flags are part of an
> union and the union is used otherwise. This happen, if a socket is not
> a full socket, like a request socket for example.
>
> Add a check to verify, if the union is used for sk_flags.
>
> Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

>  net/sched/sch_taprio.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 1ce6416b4810..86911a61e739 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -419,7 +419,8 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
>  {
>  	struct taprio_sched *q = qdisc_priv(sch);
>  
> -	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME)) {
> +	/* sk_flags are only save to use on full sockets. */


A very minor nitpick: it should have been "safe to use".

Apart from that,

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

> +	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
>  		if (!is_valid_interval(skb, sch))
>  			return qdisc_drop(skb, sch, to_free);
>  	} else if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
> -- 
> 2.20.1
>


Cheers,
-- 
Vinicius
