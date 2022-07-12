Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DC9571AEB
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiGLNP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiGLNP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:15:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45765283
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 06:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657631756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5tXsbw00YLQ7NqzC3JsrbPgngk5MuP+VNykR9IFuRR4=;
        b=HEPXQXQmGYHIPB9S5ftFkz4vctL56Lo6IDjv9RSxgZvfhH2qFx2w9q4829w79DX5A2c5eP
        4EhSHIR643JxUZ3th59lY2GgRKjnRd3fRgbEX/faQTHs9tOfXDiK8RchmyxnD7ev5SMhN1
        D7A0PKQTpAUmR0y9+xcuPI5wanyO1QY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-YnxbJUV_O7WRd1-OxnnjJQ-1; Tue, 12 Jul 2022 09:15:54 -0400
X-MC-Unique: YnxbJUV_O7WRd1-OxnnjJQ-1
Received: by mail-wm1-f70.google.com with SMTP id a6-20020a05600c348600b003a2d72b7a15so6705331wmq.9
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 06:15:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=5tXsbw00YLQ7NqzC3JsrbPgngk5MuP+VNykR9IFuRR4=;
        b=s7uAkuq+6VLVKVJgtc4vONYP0nUK7QsgeMvmHI28dhf/2VoUsTVRhckA269v4/zIdB
         T43Ju6gdlNjjO55SesZN9bABc4qdxABk2yjbvZHf/Ij4TkQ7crmPrKyBH0RhyXg25kWu
         sPr8v7yL5RtZjkc/tI5/NQYSOBCWFNFZ6RK3tjtDc82SN6sN42Q4Ed5scjUGuO06Oo3w
         DphO6wLUm+Ojdfam3XYTP5o+nWNxrYugupHgmHCeT/ZsWjNbg5n0dlPLmL+ML5BvdmC+
         toPGmE7zUMVI00MS4xRGQhebprVey/SCaNzAJO5fF2RKNTLyEblTzU4FgdNxkS9RsJXp
         yonA==
X-Gm-Message-State: AJIora8WA2Tww0K/TCE/LzkLbAkF2eJGLIitYT4QbDO6UQ519xx+/boA
        iSbrq9hWXWaccXNEoyP9L+DcERgJmaY38zR1xDMVJrk5SW7LRkTiK586sZVxzLsBFYyqgPxL20O
        DdnoWNu57Q8MWypqy
X-Received: by 2002:a1c:ed14:0:b0:3a2:b91b:dce4 with SMTP id l20-20020a1ced14000000b003a2b91bdce4mr3861364wmh.22.1657631751414;
        Tue, 12 Jul 2022 06:15:51 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1udfPIvfYSRDHa2X53wdgF/K4XHrOFPPC3TZ6BRydnjwQOBvHnS4V/0/5VLuQ5I3LCk20yyRA==
X-Received: by 2002:a1c:ed14:0:b0:3a2:b91b:dce4 with SMTP id l20-20020a1ced14000000b003a2b91bdce4mr3861346wmh.22.1657631751166;
        Tue, 12 Jul 2022 06:15:51 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id k1-20020a05600c0b4100b003a2d45472b6sm12729950wmr.28.2022.07.12.06.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 06:15:50 -0700 (PDT)
Message-ID: <5668b7b52b1bd9714312042f0b19d01ba30246b1.camel@redhat.com>
Subject: Re: [PATCH v2] net: macsec: fix potential resource leak in
 macsec_add_rxsa() and macsec_add_txsa()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jianglei Nie <niejianglei2021@163.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 15:15:49 +0200
In-Reply-To: <20220711072851.2319308-1-niejianglei2021@163.com>
References: <20220711072851.2319308-1-niejianglei2021@163.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-07-11 at 15:28 +0800, Jianglei Nie wrote:
> init_rx_sa() allocates relevant resource for rx_sa->stats and rx_sa->
> key.tfm with alloc_percpu() and macsec_alloc_tfm(). When some error
> occurs after init_rx_sa() is called in macsec_add_rxsa(), the function
> released rx_sa with kfree() without releasing rx_sa->stats and rx_sa->
> key.tfm, which will lead to a resource leak.
> 
> We should call macsec_rxsa_put() instead of kfree() to decrease the ref
> count of rx_sa and release the relevant resource if the refcount is 0.
> The same bug exists in macsec_add_txsa() for tx_sa as well. This patch
> fixes the above two bugs.
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>

uhmmm.... this is getting weird. I already asked you 2 times to please
add a suitable Fixes tag to your commit message, and this patch has
been reposted unmodified...

Please, read every document under Documentation/process/ carefully, and
please really add the required tag next time.

If the above is not clear, please ask questions, but _do not repost_
your patch unmodified,

thanks!

Paolo

