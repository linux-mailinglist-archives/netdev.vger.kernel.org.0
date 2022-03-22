Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3678B4E3A52
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiCVIN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiCVINZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:13:25 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D167DF03;
        Tue, 22 Mar 2022 01:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647936714;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=hNp8yDlEQPqE3EPVW7S4rvLP+Xs41OUZDqDWILoqWac=;
    b=Z1OxvbJImZM9vEF6DtdMG0izZkkovQFkCOZihvbk2u8Uuv0cSW+77NTa4E+0eIgRuJ
    +25fEPG7wjVjV3UERRV4Of9zEycMcdQ7iGeqEAJCwvjAjuJUW3e2d43PmAPgeC3q29TP
    MLN91212ZPiOS/vofXrPTGM988zOV5uDQR5K/bQp03soEASrKGS0yXvxPFeuu8ZBG4tx
    E5WpTw/CJrBVF5x5QbLLSpC65WgdXSnZIxiDwPuuLD+XqQsr4aqVyDa6za7V9r58edZx
    lIMsUP2TeBIGpOceKfP8l7H8hW6Fbe22rjqDYhLKXbfG2oXsIfMXht8Reob6XpiCgaBz
    eq/g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.41.1 AUTH)
    with ESMTPSA id cc2803y2M8BsDgH
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 22 Mar 2022 09:11:54 +0100 (CET)
Message-ID: <5d550eea-21ae-c495-6936-1747b9619304@hartkopp.net>
Date:   Tue, 22 Mar 2022 09:11:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v2] net: remove noblock parameter from
 skb_recv_datagram()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
References: <20220319094138.84637-1-socketcan@hartkopp.net>
 <20220321145613.5ebd85ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220321145613.5ebd85ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.03.22 22:56, Jakub Kicinski wrote:
> On Sat, 19 Mar 2022 10:41:38 +0100 Oliver Hartkopp wrote:
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
> 
> net/vmw_vsock/vmci_transport.c: In function ‘vmci_transport_dgram_dequeue’:
> net/vmw_vsock/vmci_transport.c:1735:13: warning: unused variable ‘noblock’ [-Wunused-variable]
>   1735 |         int noblock;
>        |             ^~~~~~~

Sorry. Double checked that really all touched files are now built on my 
machine.

(Except in af_iucv.c which depends on S390 - but double checked the 
changes 4 times).

v3 is already posted:
https://lore.kernel.org/netdev/20220322080317.54887-1-socketcan@hartkopp.net/T/#u

Best regards,
Oliver
