Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAA054F877
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 15:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382119AbiFQNqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 09:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382020AbiFQNqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 09:46:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D511C289AB
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 06:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655473564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ipv1gDnkD2qGhdDDoLA1cRTVHnECGK9G8ieZk2cH7q8=;
        b=QkIMoWawg/98dc0LYvGRPcZJyAXwp3g9nlPGWkCz6jD6qZ5likujhlBdYikj3p3rXngitB
        mWW3I4j6g7nZBUeI2f8DHqIuqNzTXQ9qVwQ9OjQ0Iezv6WiFIjryhaYAw1XyQxv/4WKtn2
        +ajqfHJZkUImnFxCVLrdScM1za+J8CU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-sBzuM3JMMMWtKBgB-nOLTQ-1; Fri, 17 Jun 2022 09:46:03 -0400
X-MC-Unique: sBzuM3JMMMWtKBgB-nOLTQ-1
Received: by mail-qk1-f199.google.com with SMTP id r6-20020a05620a298600b006a98e988ba4so5042594qkp.3
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 06:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ipv1gDnkD2qGhdDDoLA1cRTVHnECGK9G8ieZk2cH7q8=;
        b=lyqFl/706cVZpBYUbYwO64JXD6Q5RBy6SmeqCa/v2zmfA1sVHCsgXU2hgNhhTqLSOM
         v+KPj2m6/uJ7kk/5kktx/yj7Hj/6zvwDHl/mplEW0/Ki6JElp062Am8Xhqw6TGFJvwpb
         nCRPWJC93Hh39JQ8KPb+edQR+BM3ARWqTSska2qpEwe/P+O80E35AIXO3zBO0hglnIPV
         v78skVe+RhW2cU8Cck3yksSSTVKQB6l2E4kSRsPGwM8RItCnxJYWFubzDNjloE5sNns7
         3+tmKJp+yMhMgGQwX4rUKUowngAFrEBeSjRDTguXzFfWOvSSUBlFURpo96fnOTx7C6tm
         U7WA==
X-Gm-Message-State: AJIora85+8sWUBR51GJqZzScN5dCJg7aLQPArXnFb3PeYMMzBmdqwFPm
        FoDm4l7mS089SRphiq+wvqmMzvDGSVPW7sozzkN0421wk2yqUisLz9tCYYgm5LCJG25K3WvFj1L
        gP4D5a9hGeUljwwff
X-Received: by 2002:a05:620a:28c8:b0:6a7:7dd9:5e94 with SMTP id l8-20020a05620a28c800b006a77dd95e94mr7141927qkp.20.1655473563284;
        Fri, 17 Jun 2022 06:46:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1smZrY4FETLwRqePP3E+eTESX1SYzStN05g9v1kDH6gDgWwV824uwP/Wy9OITU/Bmf+BvRSKQ==
X-Received: by 2002:a05:620a:28c8:b0:6a7:7dd9:5e94 with SMTP id l8-20020a05620a28c800b006a77dd95e94mr7141904qkp.20.1655473563046;
        Fri, 17 Jun 2022 06:46:03 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id l12-20020a05620a28cc00b006a098381abcsm4614365qkp.114.2022.06.17.06.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 06:46:02 -0700 (PDT)
Message-ID: <44e727b8-12e8-10c8-1518-544eab36e673@redhat.com>
Date:   Fri, 17 Jun 2022 09:46:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net] bonding: ARP monitor spams NETDEV_NOTIFY_PEERS
 notifiers
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        dingtianhong <dingtianhong@huawei.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
References: <9400.1655407960@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <9400.1655407960@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/22 15:32, Jay Vosburgh wrote:
> 	 The bonding ARP monitor fails to decrement send_peer_notif, the
> number of peer notifications (gratuitous ARP or ND) to be sent. This
> results in a continuous series of notifications.
> 
> 	Correct this by decrementing the counter for each notification.
> 
> Reported-by: Jonathan Toppins <jtoppins@redhat.com>
> Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Fixes: b0929915e035 ("bonding: Fix RTNL: assertion failed at net/core/rtnetlink.c for ab arp monitor")
> Link: https://lore.kernel.org/netdev/b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com/

Jay, this works great. Thanks.

Tested-By: Jonathan Toppins <jtoppins@redhat.com>
Reviewed-By: Jonathan Toppins <jtoppins@redhat.com>

