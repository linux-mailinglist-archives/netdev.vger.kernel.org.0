Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB48A6D0BBA
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjC3Qrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbjC3QrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:47:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AE8CC38
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680194785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSrEF7cqODyWnyCjhhcsQo9bSQi/F4kHLA/OEWW8pqo=;
        b=JhMysy1rLXA0hL9Pv+dWLsP6Rf7yqE9Z1vDZYpQlin5mu+co2iZUu82d5ZQ/lQnbuRIlP1
        5q1KxF0FvqvQDaZzUR/NQ6ZYWAmmMasmo+fYrDP6PTJSzYCqldhV47IQMG0If1UHifQ821
        0aiiCcR+RERO09JXdy0gmio+0K9by+8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118--7OLBGkHPAi-Iz7r5ChJHg-1; Thu, 30 Mar 2023 12:46:22 -0400
X-MC-Unique: -7OLBGkHPAi-Iz7r5ChJHg-1
Received: by mail-qv1-f71.google.com with SMTP id f3-20020a0cc303000000b005c9966620daso8453674qvi.4
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:46:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680194778;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BSrEF7cqODyWnyCjhhcsQo9bSQi/F4kHLA/OEWW8pqo=;
        b=5Uv0+Jpw25FMZiFHoNzkSuEX7ZNljb4Yfqz+ZfteYC1yLbNojyLmcGbBbI4LpTEglL
         0wBENEh91KHPM2YlHUDOzkkk13/r1WJJUWRz7iHjIZMrW4Ap8kwAvwVl2EqssbcDSW69
         ych6xEs2hUoLZhMLxmDp+uieSYIasGL+0lcOabMmXaBnMzu9my9FYQ4UaKF2Hv3keLH9
         p+9QktOmUFxR1guUwdjYlQuUXMlTUR0JmoQJBOTBhodhTDb4O8L9WURw/g1mTg9LcbyF
         b+7hQMu7hRdikehRSNCXjsXqu2R6Ao10uf+KxV4BmhMAXBK724+PAvAGQvZjBTc+Y8Gj
         ussQ==
X-Gm-Message-State: AAQBX9dtfVNsTYQCIa7aYfRKpM3tQVr0MwwPF5NTvzU5jAa+pQOE4700
        TV0hyOww0ONpBjqecWU1qXe1DS+LsDF/SfQGlOowQS/2CfOmAWmYveIrPVF4F8epod8HtWZnpKO
        KdXeGU0y4sE7VEFdp
X-Received: by 2002:a05:6214:1c07:b0:5df:d208:8b7c with SMTP id u7-20020a0562141c0700b005dfd2088b7cmr8214966qvc.15.1680194778275;
        Thu, 30 Mar 2023 09:46:18 -0700 (PDT)
X-Google-Smtp-Source: AKy350bJ2dGD5zL3RN5gEcOf6A03QFQXJmJLYiYgxkh3V+5FCLoH5f6klZ007eE0ygmGPTy00OgkoQ==
X-Received: by 2002:a05:6214:1c07:b0:5df:d208:8b7c with SMTP id u7-20020a0562141c0700b005dfd2088b7cmr8214936qvc.15.1680194778036;
        Thu, 30 Mar 2023 09:46:18 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id u15-20020a0cee8f000000b005dd8b9345d5sm5503703qvr.109.2023.03.30.09.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 09:46:17 -0700 (PDT)
Message-ID: <aef7b9ca-a351-de95-6c50-565f8678066e@redhat.com>
Date:   Thu, 30 Mar 2023 12:46:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 1/3] bonding: fix ns validation on backup slaves
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Liang Li <liali@redhat.com>
References: <20230329101859.3458449-1-liuhangbin@gmail.com>
 <20230329101859.3458449-2-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20230329101859.3458449-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/23 06:18, Hangbin Liu wrote:
> When arp_validate is set to 2, 3, or 6, validation is performed for
> backup slaves as well. As stated in the bond documentation, validation
> involves checking the broadcast ARP request sent out via the active
> slave. This helps determine which slaves are more likely to function in
> the event of an active slave failure.
> 
> However, when the target is an IPv6 address, the NS message sent from
> the active interface is not checked on backup slaves. Additionally,
> based on the bond_arp_rcv() rule b, we must reverse the saddr and daddr
> when checking the NS message.
> 
> Note that when checking the NS message, the destination address is a
> multicast address. Therefore, we must convert the target address to
> solicited multicast in the bond_get_targets_ip6() function.
> 
> Prior to the fix, the backup slaves had a mii status of "down", but
> after the fix, all of the slaves' mii status was updated to "UP".
> 
> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>

