Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778DF4DA907
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 04:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbiCPDuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 23:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353487AbiCPDuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 23:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA97D26576;
        Tue, 15 Mar 2022 20:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6180DB81883;
        Wed, 16 Mar 2022 03:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20867C340EC;
        Wed, 16 Mar 2022 03:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647402546;
        bh=8Cz/B7fg9fX5P0J2gHVThCXGpy/dkB3BtfxpXeVzrOU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PnmdovmZqxb/vqdEiFUoPidYDz/m4hVUp3VYwHaCoobFRXd6AmdyKDNa8YIu3BOY6
         roZ7qsE1eaFt4oQrA9FbBHPA9oTJKCckb2M+tqbzJ16U/RAhHW4s405ErVt2Lt9uc7
         T4L8JvOm2lDEdfv4STZmbhz4q+S6RTzP8zGtm2tiT0oYlqaS54QQ4mSVRO5MNNNnhj
         wkyfWhTFgKKVNqKwpXH4zZ4JAZuZFLMuSZr2kirPnzZEs5EhoCurHsBwCnrI0iV4c/
         QxVn/ROUl7z8pgc3hTZbvy3JR1hwDx8zMW2cfoZN3tEU1jaTT9dZdudn1s53Sf+HnZ
         dUnPaZCl3c4EA==
Message-ID: <daa287f3-fbed-515d-8f37-f2a36234cc8a@kernel.org>
Date:   Tue, 15 Mar 2022 21:49:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to
 gre_rcv()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, menglong8.dong@gmail.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Biao Jiang <benbjiang@tencent.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
 <20220314133312.336653-2-imagedong@tencent.com>
 <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/22 9:08 PM, Jakub Kicinski wrote:
> On Mon, 14 Mar 2022 21:33:10 +0800 menglong8.dong@gmail.com wrote:
>> +	reason = SKB_DROP_REASON_NOT_SPECIFIED;
>>  	if (!pskb_may_pull(skb, 12))
>>  		goto drop;
> 
> REASON_HDR_TRUNC ?
> 
>>  	ver = skb->data[1]&0x7f;
>> -	if (ver >= GREPROTO_MAX)
>> +	if (ver >= GREPROTO_MAX) {
>> +		reason = SKB_DROP_REASON_GRE_VERSION;
> 
> TBH I'm still not sure what level of granularity we should be shooting
> for with the reasons. I'd throw all unexpected header values into one 
> bucket, not go for a reason per field, per protocol. But as I'm said
> I'm not sure myself, so we can keep what you have..

I have stated before I do not believe every single drop point in the
kernel needs a unique reason code. This is overkill. The reason augments
information we already have -- the IP from kfree_skb tracepoint.

> 
>>  		goto drop;
>> +	}
>>  
>>  	rcu_read_lock();
>>  	proto = rcu_dereference(gre_proto[ver]);
>> -	if (!proto || !proto->handler)
>> +	if (!proto || !proto->handler) {
>> +		reason = SKB_DROP_REASON_GRE_NOHANDLER;
> 
> I think the ->handler check is defensive programming, there's no
> protocol upstream which would leave handler NULL.
> 
> This is akin to SKB_DROP_REASON_PTYPE_ABSENT, we can reuse that or add
> a new reason, but I'd think the phrasing should be kept similar.
> 
>>  		goto drop_unlock;
>> +	}
>>  	ret = proto->handler(skb);

