Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A78A67529F
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjATKgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjATKgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:36:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E458B761
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674210956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m5QZUmlRo+qr823XJoN7vqZbee518R/29hFLXb2A6I8=;
        b=ZGka1KrHo5344fP1BT+GBKtSA/JSK0sJyqUto30wO4n4qwzltfvaGD3bNkHw3ruFOfNpP0
        SBYfP/U312P5ml5w99SCh/O1/ywX50KNy4H7uQhnoGOXLIbjgY6Ogq1PRWcKkB7NJr37PT
        hfgBnyGW4lwE/qBIn0AnRw5JvKRO9G4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-54-XyGA4uC4OAy_-p3QxKev8A-1; Fri, 20 Jan 2023 05:35:54 -0500
X-MC-Unique: XyGA4uC4OAy_-p3QxKev8A-1
Received: by mail-ed1-f72.google.com with SMTP id h18-20020a05640250d200b0049e0e9382c2so3624465edb.13
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:35:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m5QZUmlRo+qr823XJoN7vqZbee518R/29hFLXb2A6I8=;
        b=xNaWbKrlUzXrl9ELWRMM3Tc01iIj6DnoptlaSUYqcUyBZfBXRm8euk+lwhY6pB+b7d
         HBtSj8v5juvlkELkUK4TRHOQWRxgFNwHVvm/XPYt9skwVEmLy/2roFd3+wdOTKnX+hwa
         KHlZpaVndT3au8XCxZWatwlwptrkXbxk8eO2uCR9Csaa2DwaQ3SkNiraDBGlfFVL65Qz
         U2XeRFKa68lqcF5Aa8Z7zkPsZODCl8TjFk0ivWWFhswWkyVXMTHPmRZwy3o12FV9sFpG
         360Im6GGkMS+UFIyjJevpgfziX55zDBIwdv6sLBQDSkC4qt4NTbrSz5rfTnk4Askofwo
         Atxw==
X-Gm-Message-State: AFqh2kpwCwwOPQ1p57UyHheailArr6AgWiG1Vnq75ESa+PZihTmJEPrV
        wN86UtPTkY/H3lJHX93QE0rl1va8Q2T6bEMgHMfSw2ZOk1BWpFc1/cidb4OFRhu4ygmgEV5uFCO
        KhCCNV6okjsLNSohh
X-Received: by 2002:a17:907:2c66:b0:7c4:f752:e959 with SMTP id ib6-20020a1709072c6600b007c4f752e959mr17469573ejc.33.1674210953255;
        Fri, 20 Jan 2023 02:35:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtcR3LluTm2DShuWhmDO8avOE+tgHAh5/WGjTifQu+fdXaQgPhvzUPP4UeQh0Lk6BqENUKbkw==
X-Received: by 2002:a17:907:2c66:b0:7c4:f752:e959 with SMTP id ib6-20020a1709072c6600b007c4f752e959mr17469556ejc.33.1674210953050;
        Fri, 20 Jan 2023 02:35:53 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id ab15-20020a170907340f00b0087329ff591esm5051139ejc.132.2023.01.20.02.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 02:35:52 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ea149da7-79fa-6d9d-831a-924e312b96a0@redhat.com>
Date:   Fri, 20 Jan 2023 11:35:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, pabeni@redhat.com,
        syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] net: fix kfree_skb_list use of
 skb_mark_not_on_list
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <167415060025.1124471.10712199130760214632.stgit@firesoul>
 <CANn89iJ8Vd2V6jqVdMYLFcs0g_mu+bTJr3mKq__uXBFg1K0yhA@mail.gmail.com>
 <d5c66d86-23e0-b786-5cba-ae9c18a97549@redhat.com>
 <cc7f2ca7-8d6e-cfcb-98f8-3e3d7152fced@redhat.com>
 <CANn89i+wzgAz8Y9Ce4rw6DkcExUW37-UKKn4eL4-umWsAJ_BKQ@mail.gmail.com>
In-Reply-To: <CANn89i+wzgAz8Y9Ce4rw6DkcExUW37-UKKn4eL4-umWsAJ_BKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20/01/2023 10.46, Eric Dumazet wrote:
> On Fri, Jan 20, 2023 at 10:30 AM Jesper Dangaard Brouer
>>
[...]
>> Let me know if you prefer that we simply remove skb_mark_not_on_list() ?
> Yes. Setting NULL here might hide another bug somewhere.

Ok, sent V2

