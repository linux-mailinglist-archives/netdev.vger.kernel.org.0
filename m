Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F061AD551E
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 10:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbfJMIIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 04:08:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbfJMIH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 04:07:59 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 335A98535D
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 08:07:59 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id m6so14457589qtk.23
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 01:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=yhYWl1Umy/1VTjIbbiNd2BN64NH6epCZE/mb8RSLaXM=;
        b=cX7HJns1qvSAIMnlb1blGlQHkdVo220lDo62YWPWFPZ3cEmZTC2CoRFEH1hbtVscoD
         H1mmk1RnZQYKSaNplc5PRtc/mF6XiUCo4VKWvST5ZxyDOcMs5C78A4ZWyqmcF9uPaBsl
         WkJe6QKn2hoE9CSM7e7CYasZp+8qR5vYX0f6/yo0ihsJTzGtL/JzYdw2qQsxauVf2FWL
         /01epOBYlgQn2tZwt/XrdgaozDKaajPjmPjniwqV8KhhEe0nqdS/bJPumA6uEBpZa/XM
         phIAaoUHxdIJsIU7u5wugzf2/xcGQ056xHyfEtNN/f9cope0eI8XOPn6xAoo9lb4L8Ql
         ShkQ==
X-Gm-Message-State: APjAAAXARzuyxjhav7FYEgdSDycKW1KhsIoP+EbEtQHPBkBcE2pRQqkF
        0tzO4SatqbLyi3e6odFkvfWHlz7PsRFaG0ZZad3qBUKjkPulyzi54WMWAnr1WXupDPUipBp6CnG
        pqC6LwppqhKgURDev
X-Received: by 2002:a37:9a05:: with SMTP id c5mr23746937qke.98.1570954078377;
        Sun, 13 Oct 2019 01:07:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxdHllinWFJ1shL2L0dscS9heDbinJBHlNcirUbgmYpZ/ksUyJvF3jXeQkMuv9YmookTDp0DQ==
X-Received: by 2002:a37:9a05:: with SMTP id c5mr23746919qke.98.1570954078076;
        Sun, 13 Oct 2019 01:07:58 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id q8sm7301621qtj.76.2019.10.13.01.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 01:07:57 -0700 (PDT)
Date:   Sun, 13 Oct 2019 04:07:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v3 0/4] vhost: ring format independence
Message-ID: <20191013080742.16211-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds infrastructure required for supporting
multiple ring formats.

The idea is as follows: we convert descriptors to an
independent format first, and process that converting to
iov later.

The point is that we have a tight loop that fetches
descriptors, which is good for cache utilization.
This will also allow all kind of batching tricks -
e.g. it seems possible to keep SMAP disabled while
we are fetching multiple descriptors.

This seems to perform exactly the same as the original
code already based on a microbenchmark.
Lightly tested.
More testing would be very much appreciated.

To use new code:
	echo 1 > /sys/module/vhost_test/parameters/newcode
or
	echo 1 > /sys/module/vhost_net/parameters/newcode

Changes from v2:
	- fixed indirect descriptor batching

Changes from v1:
	- typo fixes


Michael S. Tsirkin (4):
  vhost: option to fetch descriptors through an independent struct
  vhost/test: add an option to test new code
  vhost: batching fetches
  vhost/net: add an option to test new code

 drivers/vhost/net.c   |  32 +++-
 drivers/vhost/test.c  |  19 ++-
 drivers/vhost/vhost.c | 340 +++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |  20 ++-
 4 files changed, 397 insertions(+), 14 deletions(-)

-- 
MST

