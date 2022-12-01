Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC5F63F0ED
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 13:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLAMxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 07:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLAMxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 07:53:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B2D94570
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 04:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669899146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KX7ZgKnKmftxfER1/7x229HjmVmAjL/J0cNOAMkyjzU=;
        b=fc/wXM/L6rf01AhIYBvV/RdFs8oXlM2lsS0vk7S1on2QK7i7IlJkFrU0GDkO3yA3o42gLl
        kNvNDTRH+oY6Fwi3RQdQ69jML6Xe5VXodyxfzFkpo4Kj87NShd9sSnV2YAprHWF6uJfHpK
        A4d0EfqwyWdDFtjesoAUQQbQqP01+Qs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-YcrMBom5N-eL7THbpd3LXQ-1; Thu, 01 Dec 2022 07:52:25 -0500
X-MC-Unique: YcrMBom5N-eL7THbpd3LXQ-1
Received: by mail-wm1-f69.google.com with SMTP id v188-20020a1cacc5000000b003cf76c4ae66so2499724wme.7
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 04:52:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KX7ZgKnKmftxfER1/7x229HjmVmAjL/J0cNOAMkyjzU=;
        b=gpj5qWhtVO3sS5NmZ8cwHJT+rZQSWSwAPPkZngemR/j8p/k/qp7WpOba1WkXgmMkzK
         E92it8ojqE+je3Hop4s4uiGpTokSY6New5Du+a06DNT2zC65en0p/ZhG6TCFgPB+6Tke
         Q5mR4eEh6zaMg1WI3tyvizr2fX8qTW0vUlkF9Px3hkXs9RD+SeX7DvZXxPZ38vVjtx+l
         Wvu+2ILUxF2fdUDP4MtcyRWCenQORzT5hEmNIdCIIKvCu2aJSLs16dRsIXrXVnd0MYjc
         EajQ4ZssE7Bcp7CK5EbJH7MO+6GKzvGZCrsKBj5ySZyZood1exvPnaqxauG7YHpXNMYs
         Wl+w==
X-Gm-Message-State: ANoB5pnOdvvnjfug/++weXsRbGNL+Dd+rzRK119vyWzZYXGcCE7Q0is/
        yEGjvrzAI1dROQQNNN4BhgnTpFnyMmjlHg+1iCD2virYmuAZyNHgL5ROBSK+MRm/YnAlLYp6erj
        7t3BqqSPyxDeqahk3
X-Received: by 2002:a5d:5a95:0:b0:241:65d4:8b41 with SMTP id bp21-20020a5d5a95000000b0024165d48b41mr39503359wrb.470.1669899143922;
        Thu, 01 Dec 2022 04:52:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6Sg+DcQkYoi4np2dM5zcwejMd8n6MfCsURlgx5SaFB6lFEzMiJlNe6Hi+4IEo9IqhbBB2MXw==
X-Received: by 2002:a5d:5a95:0:b0:241:65d4:8b41 with SMTP id bp21-20020a5d5a95000000b0024165d48b41mr39503346wrb.470.1669899143730;
        Thu, 01 Dec 2022 04:52:23 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id w6-20020adfec46000000b0022efc4322a9sm4597741wrn.10.2022.12.01.04.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 04:52:23 -0800 (PST)
Message-ID: <754ebf6db6955795f628d9a887adf4577a8d9041.camel@redhat.com>
Subject: Re: [PATCH v2 net] net: microchip: sparx5: correctly free skb in
 xmit
From:   Paolo Abeni <pabeni@redhat.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Date:   Thu, 01 Dec 2022 13:52:21 +0100
In-Reply-To: <20221129152635.15362-1-casper.casan@gmail.com>
References: <20221129152635.15362-1-casper.casan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-11-29 at 16:26 +0100, Casper Andersson wrote:
> consume_skb on transmitted, kfree_skb on dropped, do not free on
> TX_BUSY.
> 
> Previously the xmit function could return -EBUSY without freeing, which
> supposedly is interpreted as a drop. And was using kfree on successfully
> transmitted packets.
> 
> sparx5_fdma_xmit and sparx5_inject returns error code, where -EBUSY
> indicates TX_BUSY and any other error code indicates dropped.
> 
> Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>

Minor nit: please remote the empty line between the Fixes and SoB tags,
thanks!

Paolo

