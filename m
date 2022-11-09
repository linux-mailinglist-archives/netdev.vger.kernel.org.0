Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142F862286D
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiKIK0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiKIK0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:26:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFC912606
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667989509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=auSM+70YRosWZy5ukGqkwDOs/DSEICJ2nlPZ92XyH9s=;
        b=BnDZAUeON/xQMq3k5byEAzPn9XtTL22O3KhWgUy+Y/TDje5gPefHqy3UMFjPh0n8Cjfadb
        ppmV3fxw1wl0A3Hhque/tEA9iLwY4ESFz2jRUMMoRaovycGYeWNxESo9h3BkfIT3xIFi4r
        dfxVGNVcbSHpduqVo+Ymxg7rbmy8T7c=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-sfsCbliINXqoCGf6yCPvBg-1; Wed, 09 Nov 2022 05:25:08 -0500
X-MC-Unique: sfsCbliINXqoCGf6yCPvBg-1
Received: by mail-qk1-f198.google.com with SMTP id v7-20020a05620a0f0700b006faffce43b2so5100072qkl.9
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 02:25:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=auSM+70YRosWZy5ukGqkwDOs/DSEICJ2nlPZ92XyH9s=;
        b=PfchMwWaas1Q8mVchyGdSyhZNI/3ufETNppwBJM8gS2BjPDD/+ROuXrmM7FjQMdozb
         axhzPhnnkDPkBr+sZseZh1c8UY36w5OmrY3nGwsgkjyPGpPOxnevhlnycou5bTDvmpKL
         QUt32Bv2Pcbb6wDwoEC8gQKLM68h+bkI96mUI5efpCGjLbbfEt7uL2enZ37ydljd69wV
         JsrXHUSRN+Duv6qnRDvRDk+ObJjlYETsUdWgYiAkezEtAYPEvC/13xNdCbA8LRk4Fmbq
         1+Jbp0p44fGDq/QLAbQ/trSB0/bY8JiitIUaS/k7w58xpphKkIYcBtrvX9t2p1DKw0FV
         t8iQ==
X-Gm-Message-State: ACrzQf0g1RI1k6ePJQFGFQF0xOb9di6cMcnNHnVrK8gd0ert6Q7fi7DP
        QElbjI07ZfqcHAgR+dUWznSPfih9j8SeCBnJMTZydu7bY/3XT+RIexK9GeU659JYrFvzi8nPB+c
        33QS0J7NZWmK49sPH
X-Received: by 2002:a05:620a:e11:b0:6fa:7435:a409 with SMTP id y17-20020a05620a0e1100b006fa7435a409mr23294690qkm.51.1667989508200;
        Wed, 09 Nov 2022 02:25:08 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7kIiD5hF1VgY+01R04+NKJB6TMPdY1YIPB/qSgWreKxEVuImtPVMcdEaGEZOnk3bJsKCVWaA==
X-Received: by 2002:a05:620a:e11:b0:6fa:7435:a409 with SMTP id y17-20020a05620a0e1100b006fa7435a409mr23294682qkm.51.1667989507953;
        Wed, 09 Nov 2022 02:25:07 -0800 (PST)
Received: from step1.redhat.com (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id bj10-20020a05620a190a00b006fa313bf185sm10827522qkb.8.2022.11.09.02.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 02:25:07 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 0/2] vhost: fix ranges when call vhost_iotlb_itree_first()
Date:   Wed,  9 Nov 2022 11:25:01 +0100
Message-Id: <20221109102503.18816-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
- Patch 2: Replaced Fixes tag with the right one [Jason]

v1: https://lore.kernel.org/virtualization/20221108103437.105327-1-sgarzare@redhat.com/

While I was working on vringh to support VA in vringh_*_iotlb()
I saw that the range we use in iotlb_translate() when we call
vhost_iotlb_itree_first() was not correct IIUC.
So I looked at all the calls and found that in vhost.c as well.

I didn't observe a failure and I don't have a reproducer because
I noticed the problem by looking at the code.

Maybe we didn't have a problem, because a shorter range was being
returned anyway and the loop stopped taking into account the total
amount of bytes translated, but I think it's better to fix.

Thanks,
Stefano

Stefano Garzarella (2):
  vringh: fix range used in iotlb_translate()
  vhost: fix range used in translate_desc()

 drivers/vhost/vhost.c  | 4 ++--
 drivers/vhost/vringh.c | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

-- 
2.38.1

