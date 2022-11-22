Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1259633191
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiKVAs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKVAs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:48:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20B4B30
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669078049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jfWO1iPIC4YjnRVG6Jdr+VOmWa2xaarKqFD6yPIS5pU=;
        b=DcA1Wyazs757uQsaWzKFoe7mWxIbO5I1WbURsc5KqTSUAouD/c2ur7mpDJGeodB3xDi19E
        iUqtcHjEtoQvI2OOC3KGqRGVyT6KRa7eN+vj3KAvlTr1FmTcGmH3IVRdpwpHxb7KuRwDHl
        nvKOCAQEISG4KLpRYqUdZH+23hLibS0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-624-zwJ04Z64OquTkjLU3zXMmg-1; Mon, 21 Nov 2022 19:47:20 -0500
X-MC-Unique: zwJ04Z64OquTkjLU3zXMmg-1
Received: by mail-qv1-f72.google.com with SMTP id b1-20020a0cfb41000000b004c690b1dd8bso11193432qvq.6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:47:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jfWO1iPIC4YjnRVG6Jdr+VOmWa2xaarKqFD6yPIS5pU=;
        b=pHrY93RK8cizI+vnNDMRWwvXLCuAJp6Qa2gMEOdU+lvMiZ5V/VJI6Dbi7ebzHaoDGY
         jh3XDciMqxN0dBkvTQ0kxZdy+WtvvKxhoIon3tTujjj5O9Wv/cRHn01HIUBCuNWN3CWy
         5opkbYPz1vGFtYbpqLUy4Fe/VpIB9tCKwCLX1+ORCRdoDC8FDaA82+Ih/cTet1QK7CgV
         ldD8cd73TiW+MmtuJergf7CKULHCY54mov6lbk6zNXHftC3V1NVl5NvoSuBoSIUnsyyG
         11FbfiqKVmJQj4K40ljNWawtP2shd0paNqss5XH+DOTqKMQ+Oory5JpevByGq4A3hYCY
         8FiQ==
X-Gm-Message-State: ANoB5pldi5K4GnyHsrWxltPr/My40YHKGVZz6bcLmOsRapQKtF3yfi5G
        d8UWkhKg3jfNrq/C0URHE+AIyfZDed+VVzBCNJnoCVOJMAZ40jSndGKmBS0H06J448vNa+jF+TE
        A+v1D4jy2Xiqe2L1t
X-Received: by 2002:ae9:df07:0:b0:6fa:12b5:8d2f with SMTP id t7-20020ae9df07000000b006fa12b58d2fmr19338734qkf.60.1669078039962;
        Mon, 21 Nov 2022 16:47:19 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4TW63Ms8uylbg59YEPvwhnhMoLwoR2qsiMkV9MSgi0Fi5JclY69TTCOpxXThpuV8+vbo8ZFA==
X-Received: by 2002:ae9:df07:0:b0:6fa:12b5:8d2f with SMTP id t7-20020ae9df07000000b006fa12b58d2fmr19338713qkf.60.1669078039685;
        Mon, 21 Nov 2022 16:47:19 -0800 (PST)
Received: from [10.0.0.96] ([24.225.241.171])
        by smtp.gmail.com with ESMTPSA id de36-20020a05620a372400b006fbb4b98a25sm9261261qkb.109.2022.11.21.16.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 16:47:19 -0800 (PST)
Message-ID: <ddde1e8f-4970-cc4b-144a-647679dbd1bb@redhat.com>
Date:   Mon, 21 Nov 2022 19:47:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net 0/2] tipc: fix two race issues in tipc_conn_alloc
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Wei Chen <harperchen1110@gmail.com>
References: <cover.1668807842.git.lucien.xin@gmail.com>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <cover.1668807842.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/22 16:44, Xin Long wrote:
> The race exists beteen tipc_topsrv_accept() and tipc_conn_close(),
> one is allocating the con while the other is freeing it and there
> is no proper lock protecting it. Therefore, a null-pointer-defer
> and a use-after-free may be triggered, see details on each patch.
>
> Xin Long (2):
>    tipc: set con sock in tipc_conn_alloc
>    tipc: add an extra conn_get in tipc_conn_alloc
>
>   net/tipc/topsrv.c | 20 +++++++++++---------
>   1 file changed, 11 insertions(+), 9 deletions(-)
>
Series
Acked-by: Jon Maloy <jmaloy@redhat.com>

