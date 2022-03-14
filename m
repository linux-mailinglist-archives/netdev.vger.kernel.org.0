Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E344D8255
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240208AbiCNMDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240619AbiCNMDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:03:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFFC04B1EF
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 05:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647259197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=DTumIzkUVMCDvmMhaJUDyMiG+aNJUlziXvFqILOQYsI=;
        b=Fx8sD/JbdyLzP94A+V1xfdOotmYcIHm5ISvnQ1T6ndEogXzV7TyfCtDPGRf0p6VsegfNy3
        bsIYugzTUMz0IuHNj+aJqTOdh7hc3YIRq0GfcMbMz2X9Lov5XQZX8WQYcB7+3myGY8KD6t
        oMsYqiKDn0QvQOa0h6KBhlk3n/P0HXs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-p0B88E7vMxqHhlEbm3uXdQ-1; Mon, 14 Mar 2022 07:59:56 -0400
X-MC-Unique: p0B88E7vMxqHhlEbm3uXdQ-1
Received: by mail-wr1-f70.google.com with SMTP id p18-20020adfba92000000b001e8f7697cc7so4274477wrg.20
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 04:59:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=DTumIzkUVMCDvmMhaJUDyMiG+aNJUlziXvFqILOQYsI=;
        b=J91IlriyppOofICopznRKMsTABaE/2UszqJkiozsVx5C+cHGDiWpsUt7tX6BIOhcWf
         sIpTnQ8oGD5PcgVr+LbMfbqpfoKklccLLIhFF6HBvSty6xzcC5Z8Y90TNfT+z3beKD+t
         pvPCtASppEml8xktYu27qJt/lS9JzMpP+5C4TTGi8NW+3SjaUrV2sjImXrM6dJlZgOqv
         V3AOer5LlMXIo8qSKcGUBYPf66JnjHrJT5ZljMegMQvDnu8I872oa1Wob22gQfALPsBl
         px5iN5icUGkjyWQW1L5/l+WuwtEIK7NKI7XiA6Yk4wukyjr0s4I0Og5LFWxRRgRyrhPz
         gs3w==
X-Gm-Message-State: AOAM530Gcer0+u4WQNNyviEoCmzGgGq0m2KGdJ4N4twwy9JReH3doYC4
        ArQgHwxBY+ZjO7d6BGuEkhAYwAR+cqCYVITM+/cTITo6syu9dt2+nEA8hwbKdV9XomdfM/HkxMK
        aOJkXu/AvV/oRCJcs
X-Received: by 2002:a05:600c:4f09:b0:389:cf43:eaf8 with SMTP id l9-20020a05600c4f0900b00389cf43eaf8mr17160225wmq.201.1647259194500;
        Mon, 14 Mar 2022 04:59:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp7ZJAVv6i97GoEYXJTrh4j1WEgqWNchpszO38kLqkQtDsjqJCu3h0XIEDXpnWhcBdQ3hpYw==
X-Received: by 2002:a05:600c:4f09:b0:389:cf43:eaf8 with SMTP id l9-20020a05600c4f0900b00389cf43eaf8mr17160208wmq.201.1647259194258;
        Mon, 14 Mar 2022 04:59:54 -0700 (PDT)
Received: from redhat.com ([2.55.183.53])
        by smtp.gmail.com with ESMTPSA id w6-20020a5d6806000000b002036515dda7sm13416882wru.33.2022.03.14.04.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:59:53 -0700 (PDT)
Date:   Mon, 14 Mar 2022 07:59:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mail@anirudhrb.com,
        mst@redhat.com
Subject: [GIT PULL] virtio: a last minute regression fix
Message-ID: <20220314075951-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 3dd7d135e75cb37c8501ba02977332a2a487dd39:

  tools/virtio: handle fallout from folio work (2022-03-06 06:06:50 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 95932ab2ea07b79cdb33121e2f40ccda9e6a73b5:

  vhost: allow batching hint without size (2022-03-10 08:12:04 -0500)

----------------------------------------------------------------
virtio: a last minute regression fix

I thought we did a lot of testing, but a regression still
managed to sneak in. The fix seems trivial.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jason Wang (1):
      vhost: allow batching hint without size

 drivers/vhost/vhost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

