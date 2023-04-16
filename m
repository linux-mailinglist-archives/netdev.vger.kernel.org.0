Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE50F6E3BF7
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 22:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjDPUqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 16:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjDPUqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 16:46:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFED1BF6
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 13:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681677928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/oEdPmorOX8xiHI6aIlzUXoimXi6nlh8J6/c2SPzObI=;
        b=IRLZyUKwUehu7mV5j/ZpHpT+x9x0o2MPZAXItOGEvgSgAlRpFryASbqGuineIUCAngws1A
        af8p1io5r1oYrIoav5tE5ACvk2Myp4ZwVMfblmlUByaUsEgl0exZRZRXnx1COkAP/XvTLl
        u9QAia8AZdm/f/h7Lvsam50VU6QhMRg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-KaiKgffFO6WiTOOBE7Q9kw-1; Sun, 16 Apr 2023 16:45:27 -0400
X-MC-Unique: KaiKgffFO6WiTOOBE7Q9kw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f0b0c85c4fso15032455e9.0
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 13:45:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681677926; x=1684269926;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/oEdPmorOX8xiHI6aIlzUXoimXi6nlh8J6/c2SPzObI=;
        b=HEwmRt6guAavBtoePM8KxOBd5Ybe3COchmpkKfogkmUifRjqoDl8aP8ifmcZ2QGihh
         G2l7QshM4FuyKxyrXgKCzh9kreOL4yOxJ+/4AUesM6iqd5NNY3lbGfhr/dIU0W5/3dQL
         V8ItwdCuHgIFGDVMBZjy5AS1QrAv+iJC2AtQqneW6/Y9BsZwekmMi6bJ1JXSrGYAK4+p
         E10KpCuSfbswf1gJ5SCmvGzGQz9HKD9LJrgvBr73PML+BOq5iEn3OOmwHoAgSXl+fw5c
         GLN5YfpdZc8GM1J62QKsfAQspXRGESq7/fSgPeKv7DWhZRlcZx+B1EvOQ7ehlrH1A910
         LLsg==
X-Gm-Message-State: AAQBX9cQzBmp28P9rCevtVdsuiBVStRWmjn8M1ykXIQvpDQLNe9C8Op/
        KuUT3EtPsmaEMGArXJFir7DM+20YE4F8JxKazFPFTKium72cJ2Uk5U4jEs77RzlFUPGB+HJdpbW
        OWRi2Ah1h412lRdnEzb4cJExj
X-Received: by 2002:adf:fe8b:0:b0:2f0:2d96:1c5a with SMTP id l11-20020adffe8b000000b002f02d961c5amr4138809wrr.32.1681677926212;
        Sun, 16 Apr 2023 13:45:26 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZDl/2JrZl6WsLaTRzcyBgmzO98oVO5tAjDcD6uIrGp34aJUzDZmevyT0zIoSMohrF91ayUKg==
X-Received: by 2002:adf:fe8b:0:b0:2f0:2d96:1c5a with SMTP id l11-20020adffe8b000000b002f02d961c5amr4138799wrr.32.1681677925915;
        Sun, 16 Apr 2023 13:45:25 -0700 (PDT)
Received: from redhat.com ([2.52.136.129])
        by smtp.gmail.com with ESMTPSA id g17-20020adff3d1000000b002f777345d21sm6099498wrp.95.2023.04.16.13.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 13:45:25 -0700 (PDT)
Date:   Sun, 16 Apr 2023 16:45:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230416164453-mutt-send-email-mst@kernel.org>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 04:54:57PM +0000, Alvaro Karsz wrote:
> After further consideration, other virtio drivers need a minimum limit to the vring size too.
> 
> Maybe this can be more general, for example a new virtio_driver callback that is called (if implemented) during virtio_dev_probe, before drv->probe.
> 
> What do you think?
> 
> Thanks,
> Alvaro

Let's start with what you did here, when more than 2 drivers do it we'll
move it to core.

-- 
MST

