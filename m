Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6780620D69
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiKHKfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiKHKfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:35:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656361BE91
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667903683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8hI+VXGlNsYpteEY2VwbFWoOIdKQL0RxnupFV92rerk=;
        b=epzOvsoxtaYpFwwpn9GS7ofak1cBb/+kkumudaR0g44M062gX7Xf5orvIvfyc4iXlZ1YhN
        /H5nrE2AGFefvB7nqHNTW92VscrGKwrlcB+NDN/yMncYIoEn0DZM96Zs9LCzY9hFXgyMKM
        zEXAiJIkEHO7JioslfF1KGPTSbAKKnc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-124-E4W_zQ6rNqK592q3nlukZA-1; Tue, 08 Nov 2022 05:34:40 -0500
X-MC-Unique: E4W_zQ6rNqK592q3nlukZA-1
Received: by mail-wm1-f69.google.com with SMTP id l1-20020a7bc341000000b003bfe1273d6cso3697485wmj.4
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 02:34:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8hI+VXGlNsYpteEY2VwbFWoOIdKQL0RxnupFV92rerk=;
        b=6+uo9WxJKOgaA3z0b3EiGFLVktUsDWxC0bAnh9F4sEZCWgvylXzn+BSN/p0q9smBKZ
         6SUvW+14VWFL1fSUbURHFsbpJh7I+zUammUnq8das59fmhbccLirOjYPyoYeItv6GJW0
         RSkEjaUoVtR3cPWzr9z4CIoprCUaKk9WX3VUPtqFBs06J5dQ/rhsDBO7j1Izn8JsSI78
         Q9jNNmdI94+6bCMDVyylp51zcL6ryyyJTDnGZ0PMLDKtYtCV6pj6EhE5O2znjV5DXcHe
         sjN4ysBGpx8/BVsaht4TXjnRL48Hx3ibtTHxAJhk90OzYhMQZLew7fbvPxJrntuKdkOI
         ZufQ==
X-Gm-Message-State: ACrzQf1tKNIqtD9kUXkWo+iZCtqERr/HN/B/a+MgM7e/Lz52Kn1vdGxa
        3NBALMezSVqwhEH6sWVKRQ/pAGzQo/S02fQUS+J/zmqC34Q9y+ElK2OuEy0W0enNHp6KC/Ijw4g
        Vuj73/pVNPrtJeet9
X-Received: by 2002:a7b:c3d8:0:b0:3cf:9b7b:b96c with SMTP id t24-20020a7bc3d8000000b003cf9b7bb96cmr14185207wmj.113.1667903679370;
        Tue, 08 Nov 2022 02:34:39 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6RD9d9dmQiyq7sLWytIU3odBHdl1zaUxi78OJvddMLj7UOQAvMCdSY9vUfUFobQvSSZ7B9AA==
X-Received: by 2002:a7b:c3d8:0:b0:3cf:9b7b:b96c with SMTP id t24-20020a7bc3d8000000b003cf9b7bb96cmr14185199wmj.113.1667903679190;
        Tue, 08 Nov 2022 02:34:39 -0800 (PST)
Received: from step1.redhat.com (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id m11-20020a5d4a0b000000b0022ca921dc67sm9632802wrq.88.2022.11.08.02.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:34:38 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH 0/2] vhost: fix ranges when call vhost_iotlb_itree_first()
Date:   Tue,  8 Nov 2022 11:34:35 +0100
Message-Id: <20221108103437.105327-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

