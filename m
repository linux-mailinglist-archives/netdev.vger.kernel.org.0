Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507385B3B67
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 17:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiIIPET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 11:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiIIPES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 11:04:18 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AE79FAA0;
        Fri,  9 Sep 2022 08:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1662735853;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Luc36XRm6buQs3XXIJk3KbOcuPIEp2J/433bdIOlqi0=;
    b=qxYbh3JjvhJQRoySG1IlFuHAPpdsHOwdkfsK86x/jmTm6nJTTC5flrx5ip4zltUJ8f
    tTr1yYIUMZ8oaIkjPYOQZ1uidUE7HHn2FLnqWFJMOF0ygXxVqKoz/56Gvd1ILMgVdjTn
    p7nAaqspEluwR74Euc4ec+AfFLYTLCoi/qtGTGkBszOnvXVDZRkyopMSRCDP8noiA8zw
    IOb5oM3HB6zVDFg5iUiUdFa77Iyd5tAdoJsmb0HWaQyK0AHTaKYz1WJ/DHxZ5jExWbtq
    7Q0xn3AFBMShlzmVCSYfCEAErnIxg23al+H7YnYUkOmmy1+AsMquDNxt/0CQc0qXexDf
    YDPA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6hZqJAw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::923]
    by smtp.strato.de (RZmta 48.0.2 AUTH)
    with ESMTPSA id wfa541y89F4CB2f
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 9 Sep 2022 17:04:12 +0200 (CEST)
Message-ID: <d392c1f4-7ad3-59a4-1358-2c216c498402@hartkopp.net>
Date:   Fri, 9 Sep 2022 17:04:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/2] can: bcm: registration process optimization in
 bcm_module_init()
Content-Language: en-US
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        mkl@pengutronix.de, edumazet@google.com, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
 <823cff0ebec33fa9389eeaf8b8ded3217c32cb38.1662606045.git.william.xuanziyang@huawei.com>
 <381dd961-f786-2400-0977-9639c3f7006e@hartkopp.net>
 <c480bdd7-e35e-fbf9-6767-801e04703780@hartkopp.net>
 <7b063d38-311c-76d6-4e31-02f9cccc9bcb@huawei.com>
 <053c7de3-c76c-82fd-2d44-2e7c1673ae98@hartkopp.net>
 <9228b20a-3baa-32ad-6059-5cf0ffdb97a3@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <9228b20a-3baa-32ad-6059-5cf0ffdb97a3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.09.22 05:58, Ziyang Xuan (William) wrote:
>>
>>
>> On 9/8/22 13:14, Ziyang Xuan (William) wrote:
>>>> Just another reference which make it clear that the reordering of function calls in your patch is likely not correct:
>>>>
>>>> https://elixir.bootlin.com/linux/v5.19.7/source/net/packet/af_packet.c#L4734
>>>>
>>>> static int __init packet_init(void)
>>>> {
>>>>           int rc;
>>>>
>>>>           rc = proto_register(&packet_proto, 0);
>>>>           if (rc)
>>>>                   goto out;
>>>>           rc = sock_register(&packet_family_ops);
>>>>           if (rc)
>>>>                   goto out_proto;
>>>>           rc = register_pernet_subsys(&packet_net_ops);
>>>>           if (rc)
>>>>                   goto out_sock;
>>>>           rc = register_netdevice_notifier(&packet_netdev_notifier);
>>>>           if (rc)
>>>>                   goto out_pernet;
>>>>
>>>>           return 0;
>>>>
>>>> out_pernet:
>>>>           unregister_pernet_subsys(&packet_net_ops);
>>>> out_sock:
>>>>           sock_unregister(PF_PACKET);
>>>> out_proto:
>>>>           proto_unregister(&packet_proto);
>>>> out:
>>>>           return rc;
>>>> }
>>>>

> Yes，all these socket operations need time, most likely, register_netdevice_notifier() and register_pernet_subsys() had been done.
> But it maybe not for some reasons, for example, cpu# that runs {raw,bcm}_module_init() is stuck temporary,
> or pernet_ops_rwsem lock competition in register_netdevice_notifier() and register_pernet_subsys().
> 
> If the condition which I pointed happens, I think my solution can solve.
> 

No, I don't think so.

We need to maintain the exact order which is depicted in the af_packet.c 
code from above as the notifier call references the sock pointer.

Regards,
Oliver


