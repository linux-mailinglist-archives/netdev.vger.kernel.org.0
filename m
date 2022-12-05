Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52E2642547
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiLEJBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiLEJAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:00:25 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4B26551;
        Mon,  5 Dec 2022 00:58:42 -0800 (PST)
Received: from [192.168.2.51] (p5dd0dfce.dip0.t-ipconnect.de [93.208.223.206])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C2E92C02F8;
        Mon,  5 Dec 2022 09:58:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1670230720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LOJOfm4gp0B6IgwZ7e2DWz6uGr5bR1VtG8wjN4Lfar8=;
        b=jHaQndNySlooz6ETFJI+730TQJFgMffCi1bR4NRcg/SJ1HbZPNbCRmwOJmNk+Uldpn/hZE
        xI1EoxEDDtl1GvDxPDMzobthE8Tn0jSrp+a/I1YJ1ItgT5VFPV0ZVxu1Htwm77CuxHk4G1
        J13sD+rHoTFtUE91nwpc+odfJdQOpiz2UuK41zepER2AFLhj2JHnwx88kZiSu16/mR63Kt
        xa2xYtNZbswgNmPWQoTV2Mexmt9I2PHPQipguZQ29bvMuqoUnJFC9UBQEKamno1H7NE0Nl
        MBzURgIN2YrjlcDpxPsJryPJwdi04/dogCZ1zutF9L+F6WQVCWTkPAKnda68Cw==
Message-ID: <d51c02cf-c20f-b983-d760-bf97ce76e33a@datenfreihafen.org>
Date:   Mon, 5 Dec 2022 09:58:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH wpan] mac802154: fix missing INIT_LIST_HEAD in
 ieee802154_if_add()
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>,
        Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20221130091705.1831140-1-weiyongjun@huaweicloud.com>
 <CAK-6q+gN9d2_=bN9tvCqCxSbymMfyJjF0j=gj4kUbi-bfSnF4g@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAK-6q+gN9d2_=bN9tvCqCxSbymMfyJjF0j=gj4kUbi-bfSnF4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 04.12.22 23:49, Alexander Aring wrote:
> Hi,
> 
> On Wed, Nov 30, 2022 at 4:19 AM Wei Yongjun <weiyongjun@huaweicloud.com> wrote:
>>
>> From: Wei Yongjun <weiyongjun1@huawei.com>
>>
>> Kernel fault injection test reports null-ptr-deref as follows:
>>
>> BUG: kernel NULL pointer dereference, address: 0000000000000008
>> RIP: 0010:cfg802154_netdev_notifier_call+0x120/0x310 include/linux/list.h:114
>> Call Trace:
>>   <TASK>
>>   raw_notifier_call_chain+0x6d/0xa0 kernel/notifier.c:87
>>   call_netdevice_notifiers_info+0x6e/0xc0 net/core/dev.c:1944
>>   unregister_netdevice_many_notify+0x60d/0xcb0 net/core/dev.c:1982
>>   unregister_netdevice_queue+0x154/0x1a0 net/core/dev.c:10879
>>   register_netdevice+0x9a8/0xb90 net/core/dev.c:10083
>>   ieee802154_if_add+0x6ed/0x7e0 net/mac802154/iface.c:659
>>   ieee802154_register_hw+0x29c/0x330 net/mac802154/main.c:229
>>   mcr20a_probe+0xaaa/0xcb1 drivers/net/ieee802154/mcr20a.c:1316
>>
>> ieee802154_if_add() allocates wpan_dev as netdev's private data, but not
>> init the list in struct wpan_dev. cfg802154_netdev_notifier_call() manage
>> the list when device register/unregister, and may lead to null-ptr-deref.
>>
>> Use INIT_LIST_HEAD() on it to initialize it correctly.
>>
>> Fixes: fcf39e6e88e9 ("ieee802154: add wpan_dev_list")
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Nice catch. :)
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
