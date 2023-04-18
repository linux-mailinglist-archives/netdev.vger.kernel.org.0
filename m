Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEEB6E6DA1
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 22:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjDRUqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 16:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjDRUqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 16:46:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD77B2;
        Tue, 18 Apr 2023 13:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C716638D9;
        Tue, 18 Apr 2023 20:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150E0C433EF;
        Tue, 18 Apr 2023 20:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681850794;
        bh=PTE4R9f1OKfuM9nJaj9mQ4McfsyLeyxfNyTbqxHTrXw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FLEmW1mUWBBzrbWSt0tUPLtwH2XFzHDBAdA4gbHvutgJ1W239y6FMStmuRwn5j5NN
         Lgs0v59QlHTIP0p7iGmRljpg0Uh5UvWHc1ofmLHf6w85mhhcA6BVxP7IjBAKgld3RW
         B79ZFivt2iuYrbdPipSxUoMr2BktOps/wmfyRXYBquE732c2141SScZvYlC25Loqde
         CaLAbPQiJ7HunwTRsu7Ucmw/Kf8ht3YjiivEJO47jpXJCwO3pNT7M5Ot7UBkaYEJZK
         BTB7f19cjZcd2yasMUaroiXXYARMk9MCo8mhCWcf978Z0CyhJyLgDkCsSAKKBqppfu
         94y+LZtAGT36A==
Message-ID: <f920c935-3876-c8bc-cb6e-c8740d64a6e4@kernel.org>
Date:   Tue, 18 Apr 2023 14:46:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2] net/ipv6: silence 'passing zero to ERR_PTR()'
 warning
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Dan Carpenter <error27@gmail.com>
Cc:     Haoyi Liu <iccccc@hust.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        hust-os-kernel-patches@googlegroups.com, yalongz@hust.edu.cn,
        Dongliang Mu <dzm91@hust.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230413101005.7504-1-iccccc@hust.edu.cn>
 <a3e202ed-a50f-2a0f-082b-ec0313be096e@kernel.org>
 <11c76aa6-4c19-4f1d-86dd-e94e683dbd64@kili.mountain>
 <20230417191734.78c18a5f@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230417191734.78c18a5f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/23 8:17 PM, Jakub Kicinski wrote:
> On Fri, 14 Apr 2023 09:32:51 +0300 Dan Carpenter wrote:
>> Also it can return NULL.
>>
>> net/xfrm/xfrm_policy.c
>>   3229                  dst = dst_orig;
>>   3230          }
>>   3231  ok:
>>   3232          xfrm_pols_put(pols, drop_pols);
>>   3233          if (dst && dst->xfrm &&
>>                     ^^^
>> "dst" is NULL.
> 
> Don't take my word for it, but AFAICT it's impossible to get there with
> dst == NULL. I think we can remove this check instead if that's what
> makes smatch infer that dst may be NULL.
> 

That was my conclusion as well staring at it multiple times, but given
the horrible maze of goto's I cannot definitively say that.

