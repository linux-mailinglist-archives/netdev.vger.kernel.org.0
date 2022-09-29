Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666115EF8B1
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiI2P2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiI2P2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:28:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4371D155409
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664465328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BWdtBthhznDnqjUu3vrXZ37rQDG7v0SPEu95AzFm5Vw=;
        b=XmsHp8Gayl2B209Iudez23m965sKEC9wgpJ/kOAY7Fx9tXTQjXdtV2Ili+O66F/p3WBfD8
        hzTWJlRoUBdcS7tWCmSPjK7Q1sS4+kusN4CGIlxOGPFtJtSunp3ZeeWOMO/q26ReBbLIU5
        tfSbl0n1/IHERb1HGVK0Z0Ggvz1EskA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-439-erArk1_DOpi42YV3dxGXmw-1; Thu, 29 Sep 2022 11:28:47 -0400
X-MC-Unique: erArk1_DOpi42YV3dxGXmw-1
Received: by mail-ed1-f70.google.com with SMTP id r11-20020a05640251cb00b004516feb8c09so1542947edd.10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=BWdtBthhznDnqjUu3vrXZ37rQDG7v0SPEu95AzFm5Vw=;
        b=L/qvpUNDjhNhxEQr0EFd8daDRCHS+RwyQ13zSG6x0hh/k8lFLOJGHRVP3yA1XVJZwV
         GG0rTJPhcreuHXE3taCk5Z9vmn0GTt78s0Q/vsDmwrgRkR9fJY83KcaXhcHUwm2PFXu0
         Z+hH6zd4SCUIgv77EWcYVl2vjnPfW//YDyBjN7712cD8Fer/jQLhfhVL9HRFopeQaDBn
         /ju3ayYXmQ9laBBLMLC8mz/+1YcxJft4qnyf+qLpp4yd+cxwdIV0eRmFzvD6+ip6HU2S
         IoI/UPTOfqozzHBrQ6MlnVZTPTzmPdmTs26q8SMNkBvRN8le4qX/lqcDIomacu3W9m3R
         B2IA==
X-Gm-Message-State: ACrzQf3UMbhJ3/VD6QI3TwfzqskGL+F/Bet5CxD+Hx9EORXYxG0i3fZY
        /C0E/aylriTooYku2AkWAghUD9unzdflNnU+zt5XbDzT8OogQm/vxUPOZPn+h/L659U9vcz8k/J
        2AjRJhCRcO+x3vzCg
X-Received: by 2002:a17:906:974f:b0:780:4a3c:d179 with SMTP id o15-20020a170906974f00b007804a3cd179mr3306991ejy.289.1664465326158;
        Thu, 29 Sep 2022 08:28:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM74/4NIsoCqtX6lSUOGXbmSxQA8hkyoxpaGVA5PqFDA+efJZxNcgUXt81Okw0Aqu121kZMQmQ==
X-Received: by 2002:a17:906:974f:b0:780:4a3c:d179 with SMTP id o15-20020a170906974f00b007804a3cd179mr3306957ejy.289.1664465325887;
        Thu, 29 Sep 2022 08:28:45 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id d4-20020a1709061f4400b00783c545544fsm4150990ejk.215.2022.09.29.08.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 08:28:45 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ae658987-8763-c6de-7198-1a418e4728b4@redhat.com>
Date:   Thu, 29 Sep 2022 17:28:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Cc:     brouer@redhat.com, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
To:     Shenwei Wang <shenwei.wang@nxp.com>, Andrew Lunn <andrew@lunn.ch>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <YzT2An2J5afN1w3L@lunn.ch>
 <PAXPR04MB9185141B58499FD00C43BB6889579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <YzWcI+U1WYJuZIdk@lunn.ch>
 <PAXPR04MB918545B92E493CB57CDE612B89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
Content-Language: en-US
In-Reply-To: <PAXPR04MB918545B92E493CB57CDE612B89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/09/2022 15.26, Shenwei Wang wrote:
> 
>> From: Andrew Lunn <andrew@lunn.ch>
>> Sent: Thursday, September 29, 2022 8:23 AM
[...]
>>
>>> I actually did some compare testing regarding the page pool for normal
>>> traffic.  So far I don't see significant improvement in the current
>>> implementation. The performance for large packets improves a little,
>>> and the performance for small packets get a little worse.
>>
>> What hardware was this for? imx51? imx6? imx7 Vybrid? These all use the FEC.
> 
> I tested on imx8qxp platform. It is ARM64.

On mvneta driver/platform we saw huge speedup replacing:

   page_pool_release_page(rxq->page_pool, page);
with
   skb_mark_for_recycle(skb);

As I mentioned: Today page_pool have SKB recycle support (you might have 
looked at drivers that didn't utilize this yet), thus you don't need to 
release the page (page_pool_release_page) here.  Instead you could 
simply mark the SKB for recycling, unless driver does some page refcnt 
tricks I didn't notice.

On the mvneta driver/platform the DMA unmap (in page_pool_release_page) 
was very expensive. This imx8qxp platform might have faster DMA unmap in 
case is it cache-coherent.

I would be very interested in knowing if skb_mark_for_recycle() helps on 
this platform, for normal network stack performance.

>> By small packets, do you mean those under the copybreak limit?
>>
>> Please provide some benchmark numbers with your next patchset.
> 
> Yes, the packet size is 64 bytes and it is under the copybreak limit.
> As the impact is not significant, I would prefer to remove the
> copybreak  logic.

+1 to removing this logic if possible, due to maintenance cost.

--Jesper

