Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FCB4E2C88
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350410AbiCUPnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350434AbiCUPnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:43:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1A4174BA9
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 08:42:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 931BB6113C
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 15:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EE1C340E8;
        Mon, 21 Mar 2022 15:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647877340;
        bh=UekTriGSA9KpExEJIBxz5JqCsr5rxBpmHS8mfUamf7Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kXwCZFQukmCZa54+2mFFKU/72Pi9HhjmR/8xAX34cMep0zKubdb3poYEH2xrxQ9xj
         lTBEA1CgzsgFADzWWqgPrORoRgPffG+ULVyqiDyErlzbEjXxQRMyejt4rahcGUyADF
         eaZHgshCOOQulue1VGQ0eTiRCBcgJrQo3v4eLKaCpLFyhG5GrgSZj85As9cLtMF1WU
         nOpAuEDBZF7oC0on9c7+DUNwgHWqL2tr4vmKjb1YbGwqe3/p1zJ9Ius3/TpTXC5RB6
         bTJi2SuCOCwj+x0lkcogzowDpMPeOun69GQm6JVvcmJDt44SwokkpPIVS3FUOxCTlZ
         F2hl2QkxCiDJg==
Message-ID: <5bda97a3-6efc-4ce2-859a-be44f3c2345e@kernel.org>
Date:   Mon, 21 Mar 2022 09:42:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2] ipv6: acquire write lock for addr_list in
 dev_forward_change
Content-Language: en-US
To:     Niels Dossche <dossche.niels@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220317155637.29733-1-dossche.niels@gmail.com>
 <7bd311d0846269f331a1d401c493f5511491d0df.camel@redhat.com>
 <a24b13ea10ca898bb003300084039b459d553f6d.camel@redhat.com>
 <13558e3e0ed23097f04bb90b43c261062dca9107.camel@redhat.com>
 <f8b7e306-916d-a3e7-5755-b71d6b118489@gmail.com>
 <0cf800e8bb28116fce7466cacbabde395abfac4f.camel@redhat.com>
 <8b90b4a6-a906-0f46-bb87-0ec51c9c89fe@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <8b90b4a6-a906-0f46-bb87-0ec51c9c89fe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/22 7:17 AM, Niels Dossche wrote:
> I have an additional question about the locks on the addr_list actually.
> In addrconf_ifdown, there's a loop on addr_list within a write lock in idev->lock
>> list_for_each_entry_safe(ifa, tmp, &idev->addr_list, if_list)
> The loop body unlocks the idev->lock and reacquires it later. I assume because of the lock dependency on ifa->lock and the calls that acquire the mc_lock? Shouldn't that list iteration also be protected during the whole iteration?
> 


That loop needs to be improved as well. Locking in ipv6 code is a bit
hairy.
