Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155D76CA575
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 15:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbjC0NUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 09:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjC0NUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 09:20:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754152115
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 06:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679923192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=fp97bd4egAyMlz94O+W8oRAJLsbe6t9my51Gm91T/aM=;
        b=a6La+48uF1wwhBHmYLfNCk0mzYxOeFLRbpl738We7+ghtDeFwY4/9d0UVQb4pLDyKMxaNK
        8bpMCVmT1CpP3huJtpgGayE+qX1iQsT+CMUK3HU6MIh8KaLzg+ZpXrc3o8xPm+jA3ZM6Uu
        XJSBBxxiGgnBs2Hl/pIABbAmHbWEj6I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-4pxpSVivNRyTCo-fV1PHPA-1; Mon, 27 Mar 2023 09:19:51 -0400
X-MC-Unique: 4pxpSVivNRyTCo-fV1PHPA-1
Received: by mail-wm1-f70.google.com with SMTP id o7-20020a05600c4fc700b003edf85f6bb1so5729710wmq.3
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 06:19:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679923190;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fp97bd4egAyMlz94O+W8oRAJLsbe6t9my51Gm91T/aM=;
        b=B7h5ZLdMidoFLd5iBR06pvAP7BrdUTZChk2LZliAH8PN+mGHkhx2kfRvz234Dn50an
         1HNO6Gqw/Vq8cfbK2zBXjxnRNkntuUoGlHNibzvCEbmSfB8MG0o52LHtehVZxtG5p+kg
         9SZiR0R2LnBLpoOThhUST5tEzs6YkDMZ6QVdWnzxpwhDMore0g9wT0/lggApFOVKd5lD
         Ig/giQyeY7Zf/69nfR0brC2Sn71lwFl+z/JR0yZ2eAl7IVz/8vJD6+i3Ppps0KohD3/Z
         AjolYfeQ2F67owH5qSb0oFLyubADTz2ZPODjsPRfNQoRAEHWAGAOxGK93tGG0Xisw7NP
         Ke1w==
X-Gm-Message-State: AO0yUKXWAqVfgxTQncRxpVxd2ji7rxbGBOQRWtiqXXj12XkMxPDgIVzh
        fyJxzyHYGncxsPbdlWYn2qEz1wH3+fc8evAJpfOzERcOZqv/T5ZfECtlmQjQns2Vc+SJZm3qW/0
        PKlwFBcEsG/1IA7bi
X-Received: by 2002:a1c:7c1a:0:b0:3ee:6d88:774a with SMTP id x26-20020a1c7c1a000000b003ee6d88774amr8075074wmc.14.1679923190461;
        Mon, 27 Mar 2023 06:19:50 -0700 (PDT)
X-Google-Smtp-Source: AK7set+a3nlhZjRZvrUa3ZYlE0VCFu21NVVFHGZYCsteCubT34r2yrI5XsBkcW+x/td8mODOzUHdhw==
X-Received: by 2002:a1c:7c1a:0:b0:3ee:6d88:774a with SMTP id x26-20020a1c7c1a000000b003ee6d88774amr8075048wmc.14.1679923190202;
        Mon, 27 Mar 2023 06:19:50 -0700 (PDT)
Received: from redhat.com ([2.52.153.142])
        by smtp.gmail.com with ESMTPSA id p5-20020a05600c358500b003ef6f87118dsm2752456wmq.42.2023.03.27.06.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:19:49 -0700 (PDT)
Date:   Mon, 27 Mar 2023 09:19:47 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, mst@redhat.com
Subject: [GIT PULL] vdpa: bugfix
Message-ID: <20230327091947-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit e8d018dd0257f744ca50a729e3d042cf2ec9da65:

  Linux 6.3-rc3 (2023-03-19 13:27:55 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 8fc9ce051f22581f60325fd87a0fd0f37a7b70c3:

  vdpa/mlx5: Remove debugfs file after device unregister (2023-03-21 16:39:02 -0400)

----------------------------------------------------------------
vdpa: bugfix

An error handling fix in mlx5.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (1):
      vdpa/mlx5: Remove debugfs file after device unregister

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

