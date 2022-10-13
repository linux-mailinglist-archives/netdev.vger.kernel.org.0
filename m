Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49845FDB1C
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 15:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiJMNkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 09:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJMNka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 09:40:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD513B1DF5
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 06:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665668428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=DcJvD5vzFcxsS07jGH2XZzGBqICBqV6Tq7siAWkTRL0=;
        b=JA/b1vqgEzVvXm4o73GPeC01eXhNksIUnHJMMcAoF8ckUPjurCrIwa9C8P9MifQ4ZF16u+
        f7eKCbuQmOxp4j2b9/19+ZRU5AWfVQOdBeoyGiJUkS3KK7oHvcRwu1Gvefm9ox9WU75bTr
        lVvecaSftpgWUEr3tdwpH5m3inwUHIU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-156-LMIZqv3YP_i8SmUIEP5shw-1; Thu, 13 Oct 2022 09:40:26 -0400
X-MC-Unique: LMIZqv3YP_i8SmUIEP5shw-1
Received: by mail-wm1-f72.google.com with SMTP id q14-20020a7bce8e000000b003c6b7debf22so850478wmj.0
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 06:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DcJvD5vzFcxsS07jGH2XZzGBqICBqV6Tq7siAWkTRL0=;
        b=EocE26cXafg607Re33h3UfQzCwo4ifat7jYlC2eoAd8JYv7lHXZEMeicvvI/gbmS77
         ZYGAjBKiIi/2RpFvbq1yQaVEINJXhpwvIJgXzkze4P6O7DxzD3AusrCfqo2SdrZ5gDc3
         xJsLi5mj7ClCNUVG9FSASD6hCKFoJh38zlBjB81Ls9xkCXuXoeGIqTd3+osW68xdb/ni
         mhhroAK9TjBEds8LzKWFeuNn3heemUGJFzSQc9wdtTLaYPvsN98EBc1Sz8Kizxxi4wkd
         jr+k6XTt5OSUtRBSIkxAkom5mPIiwf1pEYDRgLEca6YO+cVUcU7mtaeHMpoPC3/QR5FM
         ZKMA==
X-Gm-Message-State: ACrzQf0HIKzDL4RI6ZjQQ1TzMB7VN4dggI9dtfEFeIgnWaR1TadW61lt
        +UcGsv0fo2aTVf8iqEZ0MD8w6zukxbapz+j+Y+edoOegLG7TqGrJt/G6IRoiQZJ8ceHhdmUcgTL
        759IMuyK0xi119PLF
X-Received: by 2002:a05:600c:88a:b0:3c5:c9e3:15cc with SMTP id l10-20020a05600c088a00b003c5c9e315ccmr6622895wmp.67.1665668425602;
        Thu, 13 Oct 2022 06:40:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6TnPZr5gSOifctojxkDFUAx5X0RgYRQuKniGc+MNA0UHK/ABnoPNo2kwVXsSINExlzellCjg==
X-Received: by 2002:a05:600c:88a:b0:3c5:c9e3:15cc with SMTP id l10-20020a05600c088a00b003c5c9e315ccmr6622877wmp.67.1665668425410;
        Thu, 13 Oct 2022 06:40:25 -0700 (PDT)
Received: from redhat.com ([2.54.162.123])
        by smtp.gmail.com with ESMTPSA id bl13-20020adfe24d000000b00230b3a0f461sm2065542wrb.33.2022.10.13.06.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 06:40:24 -0700 (PDT)
Date:   Thu, 13 Oct 2022 09:40:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        angus.chen@jaguarmicro.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, mpe@ellerman.id.au, mst@redhat.com
Subject: [GIT PULL] virtio: bugfix, reviewer
Message-ID: <20221013094021-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 041bc24d867a2a577a06534d6d25e500b24a01ef:

  Merge tag 'pci-v6.1-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci (2022-10-11 11:08:18 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to be8ddea9e75e65b05837f6d51dc5774b866d0bcf:

  vdpa/ifcvf: add reviewer (2022-10-13 09:37:30 -0400)

----------------------------------------------------------------
virtio: bugfix, reviewer

Fix a regression in virtio pci on power.
Add a reviewer for ifcvf.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (2):
      virtio_pci: use irq to detect interrupt support
      vdpa/ifcvf: add reviewer

 MAINTAINERS                        | 4 ++++
 drivers/virtio/virtio_pci_common.c | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

