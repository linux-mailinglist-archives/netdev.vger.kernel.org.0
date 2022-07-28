Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C81583C07
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 12:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiG1K3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 06:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbiG1K3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 06:29:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C8E250193
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659004168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AH5AHXQpKW9TM4hLyxgQDgxfcLQzOb+ZHRHzNnKNRlI=;
        b=VQXkJAUjqodZM3UTdYJsV6p7DJvtRNEc9nHpOs9eBIfTGXAHknlPvE3/wPf0JC4b0FBYxu
        dbfiM4U7dDL4aI3qIC0gXjsNwbfbyATjZJ2vH4jkKxfo5vNg11qng+7r6nykxnAoLO2cqV
        VqjyDOclu1JxmhnA62q8CELtzIKWaaM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-_ZNVHvjxPEmevWYQZM1hRw-1; Thu, 28 Jul 2022 06:29:27 -0400
X-MC-Unique: _ZNVHvjxPEmevWYQZM1hRw-1
Received: by mail-wm1-f70.google.com with SMTP id m4-20020a7bce04000000b003a386063752so296669wmc.1
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:29:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AH5AHXQpKW9TM4hLyxgQDgxfcLQzOb+ZHRHzNnKNRlI=;
        b=b7PaRPZ2XSP2mMqpYr/uL15rzd1XmCJVupB7OgrsM3Y7RawXP1dr2+SuyYemzX54lm
         vh/Vrdxpcqb6OrIKAWdGGBnlfQUdfGY616eT6VA6Qb9Tjz3c5lkizIuCqVVupGAMr4Oy
         ZzoUuRWyoj7eB8Qp7rtykqYyaIVmQ0YCxYmD/QoMjQEtR/2fv+znKEK+Wf9WtLKS990T
         oYA0ztXOhknbgWtTyULcVf5Vxqrc8HKmA30cJ093lD+YAoRLRSXujeIp2y/lxNgWCWri
         W+8dW9SybJQovVQV7U6JflpEtmaidKs1T8SCUnHjBsDnmxIVjaNOeK8xRNp3b/PI5tLi
         /0tQ==
X-Gm-Message-State: AJIora9svEYKQHS+o/2CdwXvm1tGfwi4T8EKIgd5MOz/vWo2uYQgBnLs
        skW8/RX55IMWby/Xahig68RuPIKsQ1yigYy2No3c2ZxzA/QTZvDZQq8m45XqCvm7uGx5TKUR3th
        XY2iXoPfC52qMqA50
X-Received: by 2002:a5d:6da4:0:b0:21d:7e96:c040 with SMTP id u4-20020a5d6da4000000b0021d7e96c040mr16711401wrs.417.1659004166390;
        Thu, 28 Jul 2022 03:29:26 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s5deH9Gfj4ORlIhYT/45d+PL+yGHBjETUQY6Hznd2ejWLj2s3cfl/et+/hO0t4l2bqS+dOYA==
X-Received: by 2002:a5d:6da4:0:b0:21d:7e96:c040 with SMTP id u4-20020a5d6da4000000b0021d7e96c040mr16711378wrs.417.1659004166067;
        Thu, 28 Jul 2022 03:29:26 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id e6-20020a5d65c6000000b0021d888e1132sm582945wrw.43.2022.07.28.03.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 03:29:25 -0700 (PDT)
Message-ID: <912fa3cd876d6f385043cea4e94de7ab7fed109d.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] net: cdns,macb: use correct xlnx prefix for
 Xilinx
From:   Paolo Abeni <pabeni@redhat.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Date:   Thu, 28 Jul 2022 12:29:23 +0200
In-Reply-To: <8a043e89-0ac8-52ad-d935-3c43d1c41592@linaro.org>
References: <20220726070802.26579-1-krzysztof.kozlowski@linaro.org>
         <20220726070802.26579-2-krzysztof.kozlowski@linaro.org>
         <87d8327b85ae54e4c9d080d0ef6645eda6f92e98.camel@redhat.com>
         <8a043e89-0ac8-52ad-d935-3c43d1c41592@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-07-28 at 10:45 +0200, Krzysztof Kozlowski wrote:
> On 28/07/2022 09:49, Paolo Abeni wrote:
> > Hello,
> > 
> > On Tue, 2022-07-26 at 09:08 +0200, Krzysztof Kozlowski wrote:
> > > Use correct vendor for Xilinx versions of Cadence MACB/GEM Ethernet
> > > controller.  The Versal compatible was not released, so it can be
> > > changed. 
> > 
> > I'm keeping this in PW a little extra time to allow for xilinx's
> > review.
> > 
> > @Harini, @Radhey: could you please confirm the above?
> 
> The best would be if it still get merged for v5.20 to replace the
> cdns,versal-gem with xlnx (as it is not released yet), 

Makes sense. Also I misread the commit message in a very dumb way.

> so we are a bit
> tight here on timing. 

It should make it.

Cheers,

Paolo

