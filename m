Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A285065E3
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 09:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349398AbiDSHcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 03:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349367AbiDSHcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 03:32:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1586D31DFE
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 00:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650353373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qvQQnX3WJ1O+c8AM33EECNVK+BAhJ0ReCydNRlwYc0w=;
        b=SoQp0oeGKRWtUPo0LM2dtI85P41Gnuk9R1ZUKHXqeWXgglYZqkLaYA0VDkKiz+JERhDzSv
        jZyXlvkAtcP/kSJp6vnKmATyR5XltA1t+YcwYlhfa0OJgPBUVKUU65sQnlkDyuXt8N5Gi3
        aZTzIuKDJfmVv0h0OGOcLlpKBGo5064=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-_XpXlxw_OLiWS3Qrrya2jQ-1; Tue, 19 Apr 2022 03:29:32 -0400
X-MC-Unique: _XpXlxw_OLiWS3Qrrya2jQ-1
Received: by mail-wm1-f69.google.com with SMTP id k16-20020a7bc310000000b0038e6cf00439so830744wmj.0
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 00:29:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qvQQnX3WJ1O+c8AM33EECNVK+BAhJ0ReCydNRlwYc0w=;
        b=xmnK0u+diDyyYz7oJswvDalXHaiVf3yCv+EpCBHL/oK+tqJsQDLa7OENk+IJFqxjt+
         gek0M2hFTD/5M/Alt8YAr6K+0wID+So+Hpo1C6JJXbdZrFYjyZQYq401R7iL573xjxfx
         CMgmzJNm4wqmeiqvXeP3eM+nZniBwbClBepJCWcgU8mX99DgbHyYS67zQcmnOLatTxn+
         +PM3/PwHeh1h+xVjKYDgAJy/s5OtkF5oAz7e+OgoQQCly3y84zGvn/8ViAtQ7rD7PFwH
         oDA/kCENkyweaXUo8kA0pw4X2VUKlZ0Yl9+0hkDAL0y4hbi4VbapkTqSg15l1x5f3FSf
         pjSA==
X-Gm-Message-State: AOAM5314hAx0uJrA1RCLnlWBTbDzXTZK4kcuM3jBLJyUr1OkZpCnS084
        q0cwYWW16J6FEY7x2qlRxkpLmx0NF8sPZ83jhWmVAsGM2W1/GZKAIDTtju/0wAhScFDX2pvO/pz
        kYjPRbjPNNWEhIzTU
X-Received: by 2002:a05:600c:206:b0:38e:b6b4:a2d6 with SMTP id 6-20020a05600c020600b0038eb6b4a2d6mr14574507wmi.156.1650353371117;
        Tue, 19 Apr 2022 00:29:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5Pu8g2po/QIskvpzd7OvuvOxSUOCn0SycUJ5J0RTseeEDBVjkgZR3umgRDnf8T3fQmpCg6Q==
X-Received: by 2002:a05:600c:206:b0:38e:b6b4:a2d6 with SMTP id 6-20020a05600c020600b0038eb6b4a2d6mr14574496wmi.156.1650353370939;
        Tue, 19 Apr 2022 00:29:30 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id g8-20020a05600c4ec800b0039290a5b827sm7990169wmq.24.2022.04.19.00.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 00:29:30 -0700 (PDT)
Message-ID: <5f5be1321b5ba6b721f9d0aab563d36133328d33.camel@redhat.com>
Subject: Re: [PATCH net-next v2] sungem: Prepare cleanup of powerpc's
 asm/prom.h
From:   Paolo Abeni <pabeni@redhat.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 19 Apr 2022 09:29:29 +0200
In-Reply-To: <11d54e799ff339f9d4aa00a741dc1e04755db7a7.1650012142.git.christophe.leroy@csgroup.eu>
References: <11d54e799ff339f9d4aa00a741dc1e04755db7a7.1650012142.git.christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-04-15 at 10:43 +0200, Christophe Leroy wrote:
> powerpc's asm/prom.h brings some headers that it doesn't
> need itself.
> 
> In order to clean it up in a further step, first clean all
> files that include asm/prom.h
> 
> Some files don't need asm/prom.h at all. For those ones,
> just remove inclusion of asm/prom.h
> 
> Some files don't need any of the items provided by asm/prom.h,
> but need some of the headers included by asm/prom.h. For those
> ones, add the needed headers that are brought by asm/prom.h at
> the moment, then remove asm/prom.h
> 
> Some files really need asm/prom.h but also need some of the
> headers included by asm/prom.h. For those one, leave asm/prom.h
> but also add the needed headers so that they can be removed
> from asm/prom.h in a later step.

This commit message is a little confusing, as this patch covers only a
single case of the above. I suggest to replace re-phrase the commit
message to be more specific. You could also explcitly mention which
symbols from linux/of.h sungem_phy.c needs, if the list is short.

Thanks,

Paolo

