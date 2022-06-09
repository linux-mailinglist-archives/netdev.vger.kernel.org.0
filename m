Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC48B545107
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344562AbiFIPip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344554AbiFIPil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:38:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CEA263E87
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:38:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B7E2B82E2C
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 15:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868C3C34114;
        Thu,  9 Jun 2022 15:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654789116;
        bh=V5ygrUDEtywNFMQYuOTeP69wvMjrVcFexO6fEFgyNR0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BvnJIMl0eZVYbtl/DEbbu+WaFbQL0DkkjK2/zu6emAWZ0zZ5e5LaN78HivprXpycX
         HkTJQgDeI/BvEFVfOzC0/h6dAKk1BA2O1O6Mv3/xfedK8N7sggYoTk2aa9PNjvpjJf
         /tPZ0t0IiJg/umTlWO0JRA3ORQiKaDjCoHv7hvv39aHVv74JYAEZ7GAUugKu2Xoe6t
         WgSmiJq4iAruONJexxUVE9kO/dI3BDrTebecbnqgryhnzT53bFF/Ofa3myuMQRiHN/
         3N8V1utjjiwGzcyLyI4cX+ugTYkmfV/+Vfo4dY7lLleZKw8lhn0TCh7vCBf4QZFLtW
         elsarocp0ViCQ==
Message-ID: <d8cd8c4f-6056-e696-d27b-2311e59f95e2@kernel.org>
Date:   Thu, 9 Jun 2022 09:38:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v2 net-next] net: neigh: add netlink filtering based on
 LLADDR for dump
Content-Language: en-US
To:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20220509205646.20814-1-florent.fourcot@wifirst.fr>
 <b84e51fa-f410-956e-7304-7a49d297f254@kernel.org>
 <8653ac99-4c5a-b596-7109-7622c125088a@wifirst.fr>
 <af7b9565-ca70-0c36-4695-a0705825468d@wifirst.fr>
 <d8a28a59-79ca-e1fc-7768-a91f8033ce0e@kernel.org>
 <d0f91700-0a0c-b464-4a25-2f0cc24987e6@wifirst.fr>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <d0f91700-0a0c-b464-4a25-2f0cc24987e6@wifirst.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/22 1:58 AM, Florent Fourcot wrote:
> Hello David,
> 
>>
>> Kernel side filtering has always been kept to simple, coarse grained
>> checks - like a device index or upper device index. It's a fine line
>> managing kernel cycles holding the rtnl vs cycles shipping the data to
>> userspace. e.g., a memcmp has a higher cost than a dev->index
>> comparison. I see the point about GET only - potential for many matches
>> and a lookup of the ll address is basically a filtered dump. Mixed
>> thoughts on whether this should be merged.
> 
> Thanks for your feedback. As you know, this option will not slow down
> standard dump.
> 
> I understand your concern, but the choice is between:
>  * putting all entries on socket to send data to userspace. It means
> several memcpy (at least one for L3 address, one for L2 address) for
> each entries
>  * Use proposed filter, with a single memcmp. memcpy is not called for
> filtered out entries.
> 
> My solution looks faster, but I can send a v3 with some numbers if you
> think that it's important to get this patch merged.
> 

sure post a v3.
