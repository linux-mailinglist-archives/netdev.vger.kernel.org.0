Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92704569BDE
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbiGGHir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbiGGHih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:38:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A9769E
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657179489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WX46C6SaiFZW6Bz+qhhwBvhSeitlVtlZ6EC1ewTE/2o=;
        b=QQw20igDtLWpevGMAGk2ViEIia9g2BiOaFI/8zDMoPbdF0jExwRep+cXcV3DaWwNrh4Pze
        yNXcBN7mOvcNCRCA3iSsOyoj8P+f9n5DUoCh14LL1xUeTmGwbgWVw7ayvuSExqGEiqIMA0
        ScKCZJ9+SCWJwS3ryCAUQnH6JIEnQP0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-FgBD4aaNN6eR91aA-TcblA-1; Thu, 07 Jul 2022 03:38:08 -0400
X-MC-Unique: FgBD4aaNN6eR91aA-TcblA-1
Received: by mail-wm1-f72.google.com with SMTP id bg6-20020a05600c3c8600b003a03d5d19e4so9203097wmb.1
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 00:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WX46C6SaiFZW6Bz+qhhwBvhSeitlVtlZ6EC1ewTE/2o=;
        b=Fi2oW9NSk8ok6olGIsXskZl/SC5OSchx80VFSz2v6DyjTENJLWIydp5JL+C5qx0UcN
         Obttw1DmLNEd3tg6CTeJotYdF8O2rv0NcA+Z/ykmkY+dI4dJ0VwUoyxrm/I92ZSvsEnu
         k9cqSXwQZM8ImNDbouRGpfBNjoHafel6e9+FskQQyjJa2qcqQEOIphhUC1pOagB9TJgo
         LQAlfOpUBAk3LB4dZXEB60T223J31MAGkYQuknVaXxOwPIyWYVTq56HiGKwKg/1MmseH
         +wLy2b9fIJDSpwJoIRC8Qu53VZpsEjbzznTYWpanbpdck5zOaEksMKIRta7ntyi1UuYN
         WVTQ==
X-Gm-Message-State: AJIora8W7olxkFBHsG71FzCFfc7pd6hlAiia5+TDSMeCHZR7jBds2X5+
        RRIU6Cvx3h04A8q7/XU8pMic1oqN6G6MgKdXYHeTBJTcVf5M3U1FaZVGMIk9nr40ZA++XmDf3c9
        LtlyePLbqeeGvaFwW
X-Received: by 2002:adf:ed41:0:b0:210:20a5:26c2 with SMTP id u1-20020adfed41000000b0021020a526c2mr39547896wro.603.1657179487515;
        Thu, 07 Jul 2022 00:38:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v/vqSfo20QsMtEQluvvlGkr+1eY0n28mvYI0x+egb5SCvFuJKh+4akuhj0vO3QUCQmshva3A==
X-Received: by 2002:adf:ed41:0:b0:210:20a5:26c2 with SMTP id u1-20020adfed41000000b0021020a526c2mr39547879wro.603.1657179487310;
        Thu, 07 Jul 2022 00:38:07 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id r23-20020a05600c321700b003a03564a005sm23001766wmp.10.2022.07.07.00.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:38:06 -0700 (PDT)
Message-ID: <4a66c4b6e6d5147b7545ff3e725f76d0169d96d1.camel@redhat.com>
Subject: Re: [PATCH] net: macsec: fix potential resource leak in
 macsec_add_rxsa() and macsec_add_txsa()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jianglei Nie <niejianglei2021@163.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 07 Jul 2022 09:38:05 +0200
In-Reply-To: <20220706074826.2254689-1-niejianglei2021@163.com>
References: <20220706074826.2254689-1-niejianglei2021@163.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

On Wed, 2022-07-06 at 15:48 +0800, Jianglei Nie wrote:
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

This looks exactly alike the previous version: it still lacks the
target tree and more importantly the Fixes tag.

Additionally, we new post a new revision of a previously posted patch,
you should include a version number into the subj line.

Please read carefully the documentation under Documentation/process/
(including maintainer-netdev.rst) before your next attempt,

Thanks!

Paolo

