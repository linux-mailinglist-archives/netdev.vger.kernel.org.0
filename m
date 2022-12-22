Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B227F653A50
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 02:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiLVB2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 20:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLVB2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 20:28:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D02B492
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 17:28:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A113361990
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923A2C433D2;
        Thu, 22 Dec 2022 01:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671672499;
        bh=WJU4Lu8igw9eo00glNEenw2N6u/xfaP2ooZZmNI85ro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MKo1Xxe2ZVIc4kF1GrOOt929JN/2ddfXXtJNw3m++Ae7u/vNgL24WgrVHJSjgeeq8
         I6P0O4vnjZtvaSRHee+gDJ5Wu8A/lnKTNORhuKw5LSpmRVQdem19wgEh0iDlT7MCXM
         pfDMwVtwsw3n/Cpb7xGRnfCWDWZS2GkRLDVbJp0jag6ePKoOzF6JtoBFIIziXWorOE
         8GKDFqHhz9sp4M5yx6hyFpGBI+TL/+JAWPqjDd/HL0t+oGmHvwHiOQnHWEoe32XG8h
         H7BpvC+dW0sVppK6CljJALqA2uN10u6C3+EFzgZErEhuY8lHuaggxDAqbzFBMke6N2
         kKp3K22BNdd2g==
Date:   Wed, 21 Dec 2022 17:28:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCHv2 net-next] sched: multicast sched extack messages
Message-ID: <20221221172817.0da16ffa@kernel.org>
In-Reply-To: <20221221093940.2086025-1-liuhangbin@gmail.com>
References: <20221221093940.2086025-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Dec 2022 17:39:40 +0800 Hangbin Liu wrote:
> +	nlh = nlmsg_put(skb, portid, n->nlmsg_seq, NLMSG_ERROR, sizeof(*errmsg),
> +			NLM_F_ACK_TLVS | NLM_F_CAPPED);
> +	if (!nlh)
> +		return -1;
> +
> +	errmsg = (struct nlmsgerr *)nlmsg_data(nlh);
> +	errmsg->error = 0;
> +	errmsg->msg = *n;
> +
> +	if (nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg))
> +		return -1;
> +
> +	nlmsg_end(skb, nlh);

I vote "no", notifications should not generate NLMSG_ERRORs.
(BTW setting pid and seq on notifications is odd, no?)
