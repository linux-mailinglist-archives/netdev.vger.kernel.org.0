Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8CC4BA2D5
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241844AbiBQOV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:21:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiBQOV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:21:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E941294132
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645107702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yXN5F+ooe6b2t/Xr4kJDkxE+1pWxiPGo1/gBjMgkN0A=;
        b=cgl7ncJLsL8NAsjFiWT9cOQs7KyhiW9buwtuPFG9YiBqN12+Y5VN0HiM7WgLQ/M0VI3Bcp
        Z0D0wxIpAChB3i/uOfySE0KdQcyE8K1YGenpM+jXWJh50F5y3c4YjvKTbU1KuKbtN6DDxS
        WMM8n1zC9wZNbRVOFCh/lmsjm3gJ4ys=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-TmcYEJZ9Pm217uqNLybcTw-1; Thu, 17 Feb 2022 09:21:41 -0500
X-MC-Unique: TmcYEJZ9Pm217uqNLybcTw-1
Received: by mail-qk1-f197.google.com with SMTP id 199-20020a3703d0000000b005f17c5b0356so964217qkd.16
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:21:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yXN5F+ooe6b2t/Xr4kJDkxE+1pWxiPGo1/gBjMgkN0A=;
        b=loyAoOT9PnbR/IAuvbpYP9pHO7HJK8ECfgnJxMijzRhgAr5YRr63Tz3fpcRbufsHp4
         aviviWFNJIENUgV5nqV9V51Bk4+KlgIjI5sHj7d13iWJ64VMNC8pmAI+J/Q65qIzRrFu
         57OHpSw2cnTX+ifucEWiZ9AEl7Opl+uRmWqPViifwI8c28NG6zU1WaFAewvOrUeLKMR7
         sNFnS1AyQe5mxstVKaLQSx/TWtHDCG2/YDCQjiRqZr+hBl/FaLs0VVSErjrZ5sX4QF1f
         obGCA+jAGV4gNExZ/C5xHr3FJv/LaD8IDU4DkzoahVjTqxQ0stSoCWmeNZljteEWovqu
         5VIw==
X-Gm-Message-State: AOAM531Kwg7WKHIz59YbxVtnNMVxibL9f9UzUPnbvmB/GHd9vWv1eOK5
        wSy2l8fvU05tKZxk/aP0GL/BJCXhThDx+Cl4BspxoakK3LcShUuXC4e79/zAN3tR+uIGVVi35r0
        trNZc9DSsOu1QadvN
X-Received: by 2002:a05:622a:54e:b0:2d1:83db:25e1 with SMTP id m14-20020a05622a054e00b002d183db25e1mr2569992qtx.110.1645107700141;
        Thu, 17 Feb 2022 06:21:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzL/RZk+0fFAsnd+v9xbm711adt4oAWd6BHxYDJ8cJelbBU7jzOrgS5JVFbOFGT7lSgyZpXpQ==
X-Received: by 2002:a05:622a:54e:b0:2d1:83db:25e1 with SMTP id m14-20020a05622a054e00b002d183db25e1mr2569980qtx.110.1645107699978;
        Thu, 17 Feb 2022 06:21:39 -0800 (PST)
Received: from [192.168.98.18] ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id z23sm3700957qtn.40.2022.02.17.06.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 06:21:39 -0800 (PST)
Message-ID: <244dccd3-9c9d-0433-c341-ae17ee741a4e@redhat.com>
Date:   Thu, 17 Feb 2022 09:21:38 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 5/5] bonding: add new option ns_ip6_target
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20220216080838.158054-1-liuhangbin@gmail.com>
 <20220216080838.158054-6-liuhangbin@gmail.com>
 <c13d92e2-3ac5-58cb-2b21-ebe03e640983@gmail.com> <Yg2kGkGKRTVXObYh@Laptop-X1>
 <cc2e5a64-b53e-b501-4a08-92e087d52dda@gmail.com> <8863.1645071997@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <8863.1645071997@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 23:26, Jay Vosburgh wrote:
> David Ahern <dsahern@gmail.com> wrote:
> 
>> On 2/16/22 6:25 PM, Hangbin Liu wrote:
>>> For Bonding I think yes. Bonding has disallowed to config via
>> module_param.
>>> But there are still users using sysfs for bonding configuration.
>>>
>>> Jay, Veaceslav, please correct me if you think we can stop using sysfs.
>>>
>>
>> new features, new API only?
> 
> 	I'm in agreement with this.  I see no reason not to encourage
> standardization on iproute / netlink.
> 

It was generally customary to include the iproute2 updates with the 
series as well. That way they all got merged at the same time. I do not 
see the needed iproute2 changes, is this still done?
Seems like it would be a requirement now if no other configuration 
method is supported.

-Jon

