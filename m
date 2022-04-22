Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96BD50AE61
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 05:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443710AbiDVDNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 23:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443666AbiDVDNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 23:13:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BF64C789;
        Thu, 21 Apr 2022 20:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4EB061C32;
        Fri, 22 Apr 2022 03:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC948C385BB;
        Fri, 22 Apr 2022 03:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650597024;
        bh=67F6OE4ldagYpkh/rSuYDnD7ifOiAmX/4fAdaoeN0Hg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eVI/VUt5SaBRpUUUuuFcGzBh+RnSSSNF2u1m+8OPBfneTg3f8UXCESyfDo9bEaIkC
         dd/U+SnHv++LZLKtDekvZLT+NFKYTTk8Vw43KzcARBomMvZKXp7PKYDGlM2pGnL+hk
         YWzrdFLgvAKzcNF0b44BU70m/W7SaT5otvdP6ztMwIR9op+74BfoMQQTB9Nw/EwyVC
         oXTHkNe3cRD8sO41nyt/1hi1YoDEUCdHSNyceFCnDpNwJlfB9bjoI/xWnenPg66dNC
         9qDWf7X03s9EOdTr+NbqZur8kmAf4+PhFXZZdoFXpCQguiVj9IlRMnqdfKsEwl/gtC
         tKaeNbN1YbkmA==
Message-ID: <2ee8fb0d-aeb4-5010-bc8c-16cbd6e88eff@kernel.org>
Date:   Thu, 21 Apr 2022 21:10:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 0/3] ipv4: First steps toward removing RTO_ONLINK
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dccp@vger.kernel.org
References: <cover.1650470610.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <cover.1650470610.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/22 5:21 PM, Guillaume Nault wrote:
> RTO_ONLINK is a flag that allows to reduce the scope of route lookups.
> It's stored in a normally unused bit of the ->flowi4_tos field, in
> struct flowi4. However it has several problems:
> 
>  * This bit is also used by ECN. Although ECN bits are supposed to be
>    cleared before doing a route lookup, it happened that some code
>    paths didn't properly sanitise their ->flowi4_tos. So this mechanism
>    is fragile and we had bugs in the past where ECN bits slipped in and
>    could end up being erroneously interpreted as RTO_ONLINK.
> 
>  * A dscp_t type was recently introduced to ensure ECN bits are cleared
>    during route lookups. ->flowi4_tos is the most important structure
>    field to convert, but RTO_ONLINK prevents such conversion, as dscp_t
>    mandates that ECN bits (where RTO_ONLINK is stored) be zero.
> 
> Therefore we need to stop using RTO_ONLINK altogether. Fortunately
> RTO_ONLINK isn't a necessity. Instead of passing a flag in ->flowi4_tos
> to tell the route lookup function to restrict the scope, we can simply
> initialise the scope correctly.
> 

I believe the set looks ok. I think the fib test coverage in selftests
could use more tests to cover tos.

