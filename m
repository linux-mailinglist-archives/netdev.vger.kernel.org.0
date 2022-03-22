Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D314E4695
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 20:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiCVTXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 15:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiCVTW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 15:22:58 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F4A6832B
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 12:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647976880;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=mWf7GiHCavijr7iXH8wyvD2RDVmUGUOVj3Kc3JgFMKE=;
    b=D8t743ofDkEPG4xhZAGnksjtBmQ5Hnx5I55GCEALyWfv8S5lrN5cW/H+cdlnkREdMs
    Eu9eEvDb81lF5wePvGsFnp4PqZ7vt9Hweg3hLvd7rmPqTpzYO+IOEgr5DDQWvcy4H7rC
    5IYuHeKU5LKXoaditRgZijD8yR8EO+cURLNqFeCnOXm6Jno5Hx+1itrZazWekEkUdM2j
    B0KZjmutthv7Cx76YsGbQdbVhy3YFw0bq8z63rqKwFIh3SEF26yIQtFz0ZXV4cI8+Lsz
    3gFgrH7YQzHauOUDvOcQ/LeX+e1touJZQGWZENHfYVTNMOzEXujtdIJpomy9W0D52MYY
    biqA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.41.1 AUTH)
    with ESMTPSA id cc2803y2MJLKGl6
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 22 Mar 2022 20:21:20 +0100 (CET)
Message-ID: <15e84731-2ecc-e19d-83bc-fb327b85b33f@hartkopp.net>
Date:   Tue, 22 Mar 2022 20:21:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v3] net: remove noblock parameter from
 skb_recv_datagram()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20220322080317.54887-1-socketcan@hartkopp.net>
 <20220322114157.5013ef0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220322114157.5013ef0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.03.22 19:41, Jakub Kicinski wrote:
> On Tue, 22 Mar 2022 09:03:17 +0100 Oliver Hartkopp wrote:
>> skb_recv_datagram() has two parameters 'flags' and 'noblock' that are
>> merged inside skb_recv_datagram() by 'flags | (noblock ? MSG_DONTWAIT : 0)'
>>
>> As 'flags' may contain MSG_DONTWAIT as value most callers split the 'flags'
>> into 'flags' and 'noblock' with finally obsolete bit operations like this:
>>
>> skb_recv_datagram(sk, flags & ~MSG_DONTWAIT, flags & MSG_DONTWAIT, &rc);
>>
>> And this is not even done consistently with the 'flags' parameter.
>>
>> This patch removes the obsolete and costly splitting into two parameters
>> and only performs bit operations when really needed on the caller side.
>>
>> One missing conversion thankfully reported by kernel test robot. I missed
>> to enable kunit tests to build the mctp code.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Would it be a major inconvenience if I asked you to come back with this
> patch after the merge window? We were hoping to keep net-next closed
> for the time being. No new features should go in in the meantime so it's
> unlikely the patch itself would break.

Definitely no problem. Just had the idea for an improvement, when 
looking at my own code.

No urgent thing - so I will resend after the merge window.

Many thanks!

Oliver


