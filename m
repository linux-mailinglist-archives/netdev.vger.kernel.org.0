Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7D957293A
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 00:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiGLWXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 18:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbiGLWXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 18:23:45 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138EE23BD8;
        Tue, 12 Jul 2022 15:23:42 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4LjFdl14b1z9sWq;
        Wed, 13 Jul 2022 00:23:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1657664619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d7YJrCRe6Qm+TNwSONhJxOu2TbaYcoyAuYI4xAstAgs=;
        b=szCc/tQXdia86kD3Bd4zptVYoGWn/sl7IiefRsRaIpMSSu4fecKS0isj5rJLxBsTg8xGK/
        zYuogQ2zobNLLjgxH/iMcgRPFm727G9d54zHfcKJCtnNiTd3s8CzOSdvk/exNxijgZw0O3
        ohvCOehMxn0H2Ylx+rZm4H5zv1Wcu9M0WJcgJSi4LEp7Fez+tUzxmmHD0h3RHl0b3xIwzb
        NGGKUM0xGLhhKB8OZQ15qf/0alQikapg4X2kYgF0RApI8KlHOswqXKENRYH5b0MilyeGtW
        GYnFPTN9ybhXyzXOH2+PlleILMcCPswRJ+xtmFW+KaOmDC3e4WVsduwBF6CBlw==
Message-ID: <d1568f0b-0972-5e52-ed63-042a625060e9@hauke-m.de>
Date:   Wed, 13 Jul 2022 00:23:37 +0200
MIME-Version: 1.0
Subject: Re: [PATCH net-next] net: lantiq_xrx200: use skb cache
Content-Language: en-US
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220712181456.3398-1-olek2@wp.pl>
From:   Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <20220712181456.3398-1-olek2@wp.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/22 20:14, Aleksander Jan Bajkowski wrote:
> napi_build_skb() reuses NAPI skbuff_head cache in order to save some
> cycles on freeing/allocating skbuff_heads on every new Rx or completed
> Tx.
> Use napi_consume_skb() to feed the cache with skbuff_heads of completed
> Tx. The budget parameter is added to indicate NAPI context, as a value
> of zero can be passed in the case of netpoll.
> 
> NAT performance results on BT Home Hub 5A (kernel 5.15.45, mtu 1500):
> 
> Fast path (Software Flow Offload):
> 	Up	Down
> Before	702.4	719.3
> After	707.3	739.9
> 
> Slow path:
> 	Up	Down
> Before	91.8	184.1
> After	92.0	185.7
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
