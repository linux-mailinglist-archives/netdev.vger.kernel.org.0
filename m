Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761665F02A9
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiI3CST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI3CSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:18:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9391F11C3;
        Thu, 29 Sep 2022 19:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C3516221B;
        Fri, 30 Sep 2022 02:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD49C433C1;
        Fri, 30 Sep 2022 02:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664504296;
        bh=1w5YrR1fb+EjiLPc63z7JGanZy2bUC82YznToesWRbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kUpDrwthAV3nnMgpTki7GLzVNhxX6EFqJZPl72eZJ5S1vnjrkHQTOINXcGDYUBkwz
         44CIdWeSi8VLMia29APU2oXVUMfOSIG4VtaSKDKFa64LCJ1lTh9LYSNZqxbClLgvfD
         mtrvY5eE4kjjUk4c4xXQEbRGDm6+Bjc55BecOP8Od5nlndFrgu4d2NOoesLIiRR+fi
         qnFc5sud6IJe7GiKNzLesmcXNPVFYRHr17pN1SY/lF3c5H+Kg0a7vxWMqoD5oSu0+E
         6lh7Ftzay3CVpAxctjenwooHC1DN/q6zIpyJl1TrdKPfGV42HIm69CcMHWvwXaqxBc
         rqF7iNMI7NtWQ==
Date:   Thu, 29 Sep 2022 19:18:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     jianghaoran <jianghaoran@kylinos.cn>
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] taprio: Set the value of picos_per_byte before fill
 sched_entry
Message-ID: <20220929191815.51362581@kernel.org>
In-Reply-To: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
References: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 14:58:30 +0800 jianghaoran wrote:
> If the value of picos_per_byte is set after fill sched_entry,
> as a result, the min_duration calculated by length_to_duration is 0,
> and the validity of the input interval cannot be judged,
> too small intervals couldn't allow any packet to be transmitted.

Meaning an invalid configuration is accepted but no packets
can ever be transmitted?  Could you make the user-visible 
issue clearer?

> It will appear like commit b5b73b26b3ca ("taprio:
> Fix allowing too small intervals") described problem.
> Here is a further modification of this problem.
> 
> example:

Here as well it seems worthwhile to mention what this is an example of.
e.g. "example configuration which will not be able to transmit packets"

> tc qdisc replace dev enp5s0f0 parent root handle 100 taprio \
>               num_tc 3 \
>               map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>               queues 1@0 1@1 2@2 \
>               base-time  1528743495910289987 \
>               sched-entry S 01 9 \
> 	      sched-entry S 02 9 \
> 	      sched-entry S 04 9 \
>               clockid CLOCK_TAI

Please add a Fixes tag pointing to the first commit where the issue was
present, and CC Vladimir Oltean <vladimir.oltean@nxp.com> on the next
version.
