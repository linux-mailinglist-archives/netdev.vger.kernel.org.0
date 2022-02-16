Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FD44B8C27
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbiBPPND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:13:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiBPPNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:13:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E12A213405
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645024369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HUArygc3z3jke9v45QPoXmjUUF3dJL9jqq5o9c91j4k=;
        b=GcDYRn0xVJ0U4z/AvlFEL4jASKjFHPR/JJpeHmfUJ6l/KfNPLaJVjIJQX2kOKKh8nsxFLk
        OyVolnwPuJ34GueoctYby62aIJ8iwMFwWsYGcNxWZDMmmAyr5jVU3r9+jfYImkRezctyEJ
        Lo9fpt080f4eE8JVdVt+1tjQiUtLBeI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-KT5ikuDtOS-C1XBhvtariw-1; Wed, 16 Feb 2022 10:12:48 -0500
X-MC-Unique: KT5ikuDtOS-C1XBhvtariw-1
Received: by mail-qk1-f200.google.com with SMTP id t10-20020a37aa0a000000b00605b9764f71so1348050qke.22
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:12:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HUArygc3z3jke9v45QPoXmjUUF3dJL9jqq5o9c91j4k=;
        b=IitHXH5Cd9ZdZUVi/TJbSxN9fbp7WLk798+p2SHLoca1iTEoryTrWwcPS4ZeOf8oB3
         LhSlAcVOjxVBVwVxgVY9nwB7dw84utYy3jzXQCqY9qEKD+6Crj/VYR8OVSEBHByCw7FK
         0p0KKpV2PY6RXHnOVScjqElbCsWI8JyQM1YqOWWguS1/+aRXOBP67kIzVAMKhRfe8Lra
         RyvqOOqTneDu9Uxqh1+A4R75Mym4905FQQe1BssCkgkM/JdPwxmIrIie7g/qxhx+aQa6
         +ky6IVfwqhECtR3N6WM0FWbfO52SZDmWNsCeVcFScAHJ4w1yVK3lrPZAIDU8Ra3qJ6gB
         i7bw==
X-Gm-Message-State: AOAM531BGsYx1pckZv3HP6UIGKpBVRcl5FoK2+w2XDhFPCv2Lg4zg+wB
        0iqaf5a28u+8ZBuZV+DTjdjgU3Ljs8zUwhGNLRmGb5ng++kXH8rzKhsulOWL1ZaLXDgrxc5WKrF
        ZMTv93jeWPpL5fGKl
X-Received: by 2002:a05:622a:1441:b0:2d4:4afc:8409 with SMTP id v1-20020a05622a144100b002d44afc8409mr2305367qtx.460.1645024367271;
        Wed, 16 Feb 2022 07:12:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyEiDy39l6GacOJ6+Z8AsdSBMx/TkA91cKM3A5niyc94fruc6LYPCwrTWd3gkbtybNWD8KfOw==
X-Received: by 2002:a05:622a:1441:b0:2d4:4afc:8409 with SMTP id v1-20020a05622a144100b002d44afc8409mr2305346qtx.460.1645024366998;
        Wed, 16 Feb 2022 07:12:46 -0800 (PST)
Received: from [10.0.0.97] ([24.225.241.171])
        by smtp.gmail.com with ESMTPSA id i4sm20119741qkn.13.2022.02.16.07.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 07:12:46 -0800 (PST)
Message-ID: <198c2a00-5f25-7f4a-5829-517e02044626@redhat.com>
Date:   Wed, 16 Feb 2022 10:12:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [v2,net] tipc: fix wrong notification node addresses
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
References: <20220216020009.3404578-1-jmaloy@redhat.com>
 <Ygyi9rgXShc1MCoX@unreal>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <Ygyi9rgXShc1MCoX@unreal>
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



On 2/16/22 02:08, Leon Romanovsky wrote:
> On Tue, Feb 15, 2022 at 09:00:09PM -0500, jmaloy@redhat.com wrote:
>> From: Jon Maloy <jmaloy@redhat.com>
>>
>> The previous bug fix had an unfortunate side effect that broke
>> distribution of binding table entries between nodes. The updated
>> tipc_sock_addr struct is also used further down in the same
>> function, and there the old value is still the correct one.
>>
>> We fix this now.
>>
>> Fixes: 032062f363b4 ("tipc: fix wrong publisher node address in link publications")
>>
> Please don't put blank lines between Fixes and SOB lines.
>
> Thanks
Seems like somebody should update the checkpatch.pl script.

///jon

>
>> Signed-off-by: Jon Maloy <jmaloy@redhat.com>
>>
>> ---
>> v2: Copied n->addr to stack variable before leaving lock context, and
>>      using this in the notifications.
>> ---
>>   net/tipc/node.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/tipc/node.c b/net/tipc/node.c
>> index fd95df338da7..6ef95ce565bd 100644
>> --- a/net/tipc/node.c
>> +++ b/net/tipc/node.c
>> @@ -403,7 +403,7 @@ static void tipc_node_write_unlock(struct tipc_node *n)
>>   	u32 flags = n->action_flags;
>>   	struct list_head *publ_list;
>>   	struct tipc_uaddr ua;
>> -	u32 bearer_id;
>> +	u32 bearer_id, node;
>>   
>>   	if (likely(!flags)) {
>>   		write_unlock_bh(&n->lock);
>> @@ -414,6 +414,7 @@ static void tipc_node_write_unlock(struct tipc_node *n)
>>   		   TIPC_LINK_STATE, n->addr, n->addr);
>>   	sk.ref = n->link_id;
>>   	sk.node = tipc_own_addr(net);
>> +	node = n->addr;
>>   	bearer_id = n->link_id & 0xffff;
>>   	publ_list = &n->publ_list;
>>   
>> @@ -423,17 +424,17 @@ static void tipc_node_write_unlock(struct tipc_node *n)
>>   	write_unlock_bh(&n->lock);
>>   
>>   	if (flags & TIPC_NOTIFY_NODE_DOWN)
>> -		tipc_publ_notify(net, publ_list, sk.node, n->capabilities);
>> +		tipc_publ_notify(net, publ_list, node, n->capabilities);
>>   
>>   	if (flags & TIPC_NOTIFY_NODE_UP)
>> -		tipc_named_node_up(net, sk.node, n->capabilities);
>> +		tipc_named_node_up(net, node, n->capabilities);
>>   
>>   	if (flags & TIPC_NOTIFY_LINK_UP) {
>> -		tipc_mon_peer_up(net, sk.node, bearer_id);
>> +		tipc_mon_peer_up(net, node, bearer_id);
>>   		tipc_nametbl_publish(net, &ua, &sk, sk.ref);
>>   	}
>>   	if (flags & TIPC_NOTIFY_LINK_DOWN) {
>> -		tipc_mon_peer_down(net, sk.node, bearer_id);
>> +		tipc_mon_peer_down(net, node, bearer_id);
>>   		tipc_nametbl_withdraw(net, &ua, &sk, sk.ref);
>>   	}
>>   }
>> -- 
>> 2.31.1
>>

