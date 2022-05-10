Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F66520EB1
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbiEJHhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239435AbiEJHN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:13:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A71C62AC6FB
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 00:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652166598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=znTslfdmFvdK3fxVyAt5nB+yfBihwlJfOKZNpeLAkaM=;
        b=LLjq1Hf2eiiYb/iPsFf6ljr3J5N/43oFEXS8XhfiNJ8IvS678lWYCIBWn0nfjmogdPAzs4
        fqp3EjvSL6t4LTztzaGi6RA5j6FuCVc0qZ5CJMqlUmO+ogWeNqtePWitI4mm3TbbQ4gqbS
        yO2Sol5kZtvf7kq+zhA/A1L4wnKMHjM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-peFGKNXWMAmg52Z-KgZkwQ-1; Tue, 10 May 2022 03:09:57 -0400
X-MC-Unique: peFGKNXWMAmg52Z-KgZkwQ-1
Received: by mail-wm1-f72.google.com with SMTP id v191-20020a1cacc8000000b0038ce818d2efso4928044wme.1
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 00:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=znTslfdmFvdK3fxVyAt5nB+yfBihwlJfOKZNpeLAkaM=;
        b=NyAUbpqGtbk445AOxpvvUFKCBLWkOfEgRXXV4KwW9LfnO4Qc5mcOjV6df3IQJw/cmJ
         1XwV8Eew4meWSnkEwfh2/SeNF1VioeXDGWtCIgyauBNkFwmbCw1Cb7k/5QOemxdpIhTN
         J0LTjG5vaWE9QYJAFiOgWWgO7AA012Fk0EzjS5rL4ZxgBmHya5KJJ0lk8gbpq/bxGs6c
         SXFNstc9RKlx5f2U8ibe5WRRuSwrqRPlWK2vPwW+E/r29iPzfpKHLsHBqoVlE9OETVZd
         xED7aJa2ht3dBWmZehhl/QzwvB+ugfQej4XtEY40YikkwAr0FhswHyTvriWkM1xYzULv
         QBPw==
X-Gm-Message-State: AOAM5335VLVnc70gyz6Sj9lDSoyQo/O+UDFl5c43H0YVY0QBHYqS8jbA
        nJb3cL9dSNU9IamspogfQHdindou3iXZnM2wHKWm03f0bR4zCTZxCinX9NPMVGpGQGlCHKR3Aim
        LlHYpnFnavWLCdg8K
X-Received: by 2002:a05:600c:4f8f:b0:394:85c3:cf9 with SMTP id n15-20020a05600c4f8f00b0039485c30cf9mr13602840wmq.125.1652166595706;
        Tue, 10 May 2022 00:09:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBNeLQtsWHQ6Ur1dLDNXNzr8t3qbTWrEf7RLMNxCLHn50u1qdG8vUEnpZmbA2YPRNSHQpTxA==
X-Received: by 2002:a05:600c:4f8f:b0:394:85c3:cf9 with SMTP id n15-20020a05600c4f8f00b0039485c30cf9mr13602816wmq.125.1652166595305;
        Tue, 10 May 2022 00:09:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-89.dyn.eolo.it. [146.241.113.89])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003942a244f40sm1659279wms.25.2022.05.10.00.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 00:09:54 -0700 (PDT)
Message-ID: <0b66ddcc8428231632e7e1050045b2c282dc92d7.camel@redhat.com>
Subject: Re: [PATCH net v2] net: macsec: retrieve the XPN attributes before
 offloading
From:   Paolo Abeni <pabeni@redhat.com>
To:     Carlos Fernandez <carlos.escuin@gmail.com>,
        carlos.fernandez@technica-engineering.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 May 2022 09:09:53 +0200
In-Reply-To: <20220506105540.9868-1-carlos.fernandez@technica-engineering.de>
References: <20220506105540.9868-1-carlos.fernandez@technica-engineering.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-05-06 at 12:55 +0200, Carlos Fernandez wrote:
> When MACsec offloading is used with XPN, before mdo_add_rxsa
> and mdo_add_txsa functions are called, the key salt is not
> copied to the macsec context struct. Offloaded phys will need
> this data when performing offloading.
> 
> Fix by copying salt and id to context struct before calling the
> offloading functions.
> 
> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
> 
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>

I'm sorry for nit-picking, but you must avoid empty lines between the
the 'Fixes' and the 'Signed-off-by' tags (or any other tag).

Additionnaly you should include a summary of the changes WRT the
previous patch version, see e.g. commit cec16052d5a7.

The patch contents looks good, but it's better if you address the
above, thanks!

Paolo

