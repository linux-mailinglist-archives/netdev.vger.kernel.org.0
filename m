Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E8A654522
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbiLVQ0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235230AbiLVQ0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:26:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D9133CD0
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 08:26:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A74CB81EB6
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 16:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6F9C433D2;
        Thu, 22 Dec 2022 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671726375;
        bh=LQdFkzzuPpBYhytote6d00p8uRnxT3WgUkjbnBtW/RQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sZVOB/3qEyxn3FcfNpAyAZlLmKxN6CBhBz8hydvQfTg670fVB/bMhOVUDDxYD3Bo6
         1WOeldfi7+0bpF8ab2CrjZA7+U2eBCKg/oGfV0uk3Wpg9w7BxqE3iHlscxTmaL4Qtw
         /bb2OZdypAVtGiIVqEcWSW5Gj4YnBEX9xubYtNcft/5mrHPLNu/Z+9QHjYYGAGp8Xe
         KVAucuFQN1Aqq/8To7Buqz946VN8mmFHI/sM5/UKhFQTi/LjMf8q/cLZ4gdIg3k+79
         N9GYzN92dW3RdxccQe3O7My2Nwh5pNnwCNrtQqBz++CilIisgHzZ7cBRyLePqADcac
         Zh58JutG7Xc2g==
Message-ID: <de4920b8-366b-0336-ddc2-46cb40e00dbb@kernel.org>
Date:   Thu, 22 Dec 2022 09:26:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCHv2 net-next] sched: multicast sched extack messages
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
References: <20221221093940.2086025-1-liuhangbin@gmail.com>
 <20221221172817.0da16ffa@kernel.org> <Y6QLz7pCnle0048z@Laptop-X1>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <Y6QLz7pCnle0048z@Laptop-X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/22/22 12:48 AM, Hangbin Liu wrote:
> On Wed, Dec 21, 2022 at 05:28:17PM -0800, Jakub Kicinski wrote:
>> On Wed, 21 Dec 2022 17:39:40 +0800 Hangbin Liu wrote:
>>> +	nlh = nlmsg_put(skb, portid, n->nlmsg_seq, NLMSG_ERROR, sizeof(*errmsg),
>>> +			NLM_F_ACK_TLVS | NLM_F_CAPPED);
>>> +	if (!nlh)
>>> +		return -1;
>>> +
>>> +	errmsg = (struct nlmsgerr *)nlmsg_data(nlh);
>>> +	errmsg->error = 0;
>>> +	errmsg->msg = *n;
>>> +
>>> +	if (nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg))
>>> +		return -1;
>>> +
>>> +	nlmsg_end(skb, nlh);
>>
>> I vote "no", notifications should not generate NLMSG_ERRORs.
>> (BTW setting pid and seq on notifications is odd, no?)
> 
> I'm not sure if this error message should be counted to notifications generation.
> The error message is generated as there is extack message, which is from
> qdisc/filter adding/deleting.
> 
> Can't we multicast error message?
> 
> If we can't multicast the extack message via NLMSG_ERROR or NLMSG_DONE. I
> think there is no other way to do it via netlink.
> 

it is confusing as an API to send back information or debugging strings
marked as an "error message."

