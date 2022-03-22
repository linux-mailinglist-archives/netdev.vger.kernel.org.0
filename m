Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899B04E3BC3
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 10:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiCVJe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 05:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiCVJe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 05:34:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0C265E778
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647941577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BKy1pLQQjXRDKusWXgTNYmpYZevqtGteKrlHtGJM80o=;
        b=eYxz81IyTkL5Fp4CeIa37pNF/cR02TU2lGmxraWil0s3LJWE1YRcY3XbBgmz12sfWImk+L
        oU36QsffXo6L/UCU+Mz7d1FEIy9UOcK638A42kR5BSjHg4HqdxJ2y8AKo8G+oBA1qawGbC
        8FTlCMBFcKrgpUOVM1P+/i/GcWmkqpw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-Eo3OMCkBOq2lnAEr6ckUSA-1; Tue, 22 Mar 2022 05:32:56 -0400
X-MC-Unique: Eo3OMCkBOq2lnAEr6ckUSA-1
Received: by mail-qk1-f197.google.com with SMTP id i2-20020a05620a248200b0067b51fa1269so11385135qkn.19
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=BKy1pLQQjXRDKusWXgTNYmpYZevqtGteKrlHtGJM80o=;
        b=xzWkjypswcBURXjwQg6r4jKZDekeiQl3W3uYCjoPogRPVhKDt7hyuWS567+f7sayfU
         gpTe2Vzb4KZ/9Zu+TGTospbIdA30PGUJllJyS4tOdw6B2MJAK0N06k88Mhzj8gGp0FJh
         OWMCzNwc0oy6o6kGRw7ckpzcJRBBiRwWIfjdZxLE9U0EhKx+tRafmVjztiLYOu8uc6J+
         PVNTbg+xAkbvsoPhft+eMYmFdGu3cwS2KX2tFIJuWfgtvvoN8pYpT67jDvsxnYVGwRb/
         L11uxvJ0jcAFcreEcJhgJA3M32fiLFh1PGINyYhL38h9fWytcqQgwrJz3qea7OgNrSLu
         MIQg==
X-Gm-Message-State: AOAM531eIhyr5H4MO+vYGjk0yusBNirSYy8S0YyE6Nt4veJV//eaww71
        uL2tAziK/ojQuB1D0lABH2NgUhwSMYCx8rpKYT2b2borLzuLYXY5oFJM5idLLosrBXamvDdGt7G
        ddFUaoMYEylyHCzDi
X-Received: by 2002:a05:620a:24d3:b0:67d:1e2c:7a90 with SMTP id m19-20020a05620a24d300b0067d1e2c7a90mr14843449qkn.12.1647941576181;
        Tue, 22 Mar 2022 02:32:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzC0nq374AV74jYWo7nKv1tW4SGQEsSlf6rWi1tdBYu16iKC3eEb41G1RI3d2/kGcM55rD4qw==
X-Received: by 2002:a05:620a:24d3:b0:67d:1e2c:7a90 with SMTP id m19-20020a05620a24d300b0067d1e2c7a90mr14843437qkn.12.1647941575929;
        Tue, 22 Mar 2022 02:32:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id c10-20020ac87dca000000b002e1db1b7b10sm13540695qte.25.2022.03.22.02.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 02:32:55 -0700 (PDT)
Message-ID: <4eb1bcc28e00aeedfe767d3b6afcb864bcdb03b4.camel@redhat.com>
Subject: Re: [PATCH v2] myri10ge: remove an unneeded NULL check
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, christopher.lee@cspi.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jakobkoschel@gmail.com
Date:   Tue, 22 Mar 2022 10:32:52 +0100
In-Reply-To: <20220320044457.13734-1-xiam0nd.tong@gmail.com>
References: <20220320044457.13734-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2022-03-20 at 12:44 +0800, Xiaomeng Tong wrote:
> The define of skb_list_walk_safe(first, skb, next_skb) is:
>   for ((skb) = (first), (next_skb) = (skb) ? (skb)->next : NULL; (skb);  \
>      (skb) = (next_skb), (next_skb) = (skb) ? (skb)->next : NULL)
> 
> Thus, if the 'segs' passed as 'first' into the skb_list_walk_safe is NULL,
> the loop will exit immediately. In other words, it can be sure the 'segs'
> is non-NULL when we run inside the loop. So just remove the unnecessary
> NULL check. Also remove the unneeded assignmnets.
> 
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>

This is pure net-next material, and we are now into the merge window -
only fixes allowed. Please repost in 2w, thanks!

Paolo

