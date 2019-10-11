Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFE1D41B7
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfJKNqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:46:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbfJKNqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:46:01 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E22843B72D
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 13:46:00 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id p56so9457698qtj.14
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 06:46:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=o/nkRYTONx73WsD7MC8B77Hivj8w35ee4nLVJzmSYdg=;
        b=DrBz3apBRlCFXoXs3toBkp6cYdrFKKtsmSi9pDGqfT4BuSkDK8d64j9u1oraW9hIzj
         HPub3e9wMu6ne1wmFeWsDNFXL6Wwug/v2++Z/DF8IFXmQzD79PAGvIcDr9+BWk6+CaHJ
         xZUQ58xaOad8bcF5gE7CbdNP1R1Skr0tnKTy8OV6Rzpb0baCO4sMlopkOVp1ZSRYZx2P
         bjYGedlaDAHYV1pYPT+tedKuE7RvyCCdpxjMjuUZDqVAF2uZw9XXsBp58llMGX0i3Kd+
         IU/9DXiguLR26Zw04kwuO/wm9N/7pYzBpfm6WANZWGUwjovCQfoloiso7hVGL7b3rId2
         r3OA==
X-Gm-Message-State: APjAAAUwP8YttSudeBB+oSJm5zvv08Hciu8O1KrWibbLuNS2ulDDiDNm
        geFGnmXn7xIxp2V2cZGdQmXolQfa+KqlpCJxYVu9YIRnCG1lBU6qpwTspK4oSsecUb4s6cTsWvg
        vDxU19dbefBpXpfJU
X-Received: by 2002:ac8:2e10:: with SMTP id r16mr17460323qta.62.1570801559693;
        Fri, 11 Oct 2019 06:45:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyNkV+IdP+Wd7WKMbrFt0Q607s9maou4ckQQ4vu7F/qkVJUOjLTGMKOgQL8yhEDf1yVy213sQ==
X-Received: by 2002:ac8:2e10:: with SMTP id r16mr17460293qta.62.1570801559470;
        Fri, 11 Oct 2019 06:45:59 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id w6sm3944120qkj.136.2019.10.11.06.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 06:45:58 -0700 (PDT)
Date:   Fri, 11 Oct 2019 09:45:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v1 0/2] vhost: ring format independence
Message-ID: <20191011134358.16912-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So the idea is as follows: we convert descriptors to an
independent format first, and process that converting to
iov later.

The point is that we have a tight loop that fetches
descriptors, which is good for cache utilization.
This will also allow all kind of batching tricks -
e.g. it seems possible to keep SMAP disabled while
we are fetching multiple descriptors.

And perhaps more importantly, this is a very good fit for the packed
ring layout, where we get and put descriptors in order.

This patchset seems to already perform exactly the same as the original
code already based on a microbenchmark.  More testing would be very much
appreciated.

Biggest TODO before this first step is ready to go in is to
batch indirect descriptors as well.

Integrating into vhost-net is basically
s/vhost_get_vq_desc/vhost_get_vq_desc_batch/ -
or add a module parameter like I did in the test module.



Michael S. Tsirkin (2):
  vhost: option to fetch descriptors through an independent struct
  vhost: batching fetches

 drivers/vhost/test.c  |  19 ++-
 drivers/vhost/vhost.c | 333 +++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |  20 ++-
 3 files changed, 365 insertions(+), 7 deletions(-)

-- 
MST

