Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB026D55EC
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 13:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfJMLmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 07:42:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728960AbfJMLmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 07:42:03 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A025985363
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 11:42:03 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id m19so14873514qtm.13
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 04:42:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=WhM42HnkXorw8ZktlIqV/yS0IRHKb5HISbW//fiFIIA=;
        b=ND0HRSKOr25OGGxA0mHaZgXZD+OXghnZ23EiAk8ZJ6bQ9l1SDlWBQQxKjKpPcn22zM
         Ejdd+jG3K7Nzik91WSXC1yDm0YOESCt6cjcnmQyBsADRM2ZUjMH3f8QnIgcF6PorcJ5Q
         nTxyGaLVpbQNMNMpZtz1eLRLiipiaqpzE5SnWQ7HcCeHmM5WsPvnzDH8dUGPm5bi755o
         t8a7o1mobO2KbAPvf+PM4xXX9Fb9XDG83BlshMQTWCaECBKst23LO0XnQH/IiWlcVcL0
         HUZLubW0jCUvJ1p++mCFwmd5ZGT5r/6clo8GofankHvKILvI/g4PHbhJt7PMc7HIiYgI
         6zBQ==
X-Gm-Message-State: APjAAAUudoxCNb37lb74JiOoDTCqjre10WqFP/fhZ94rGqbz5S6jPLHo
        ZkleftIj2GhNVoU9XRu/L6+3S6MTe7LL9H6cGDY95WvZNxOxDB7gHL7viPalKI/gabVe5T8UChh
        F4p14fQclTdsC0ZrQ
X-Received: by 2002:a37:a14d:: with SMTP id k74mr25294020qke.308.1570966922927;
        Sun, 13 Oct 2019 04:42:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxJbPZHmjjRtZPdn0OIP4+7Md8xReA9OfG4qhSoToCuN8Mn6p7CW5fNAnas5HTHE7lcLL2Caw==
X-Received: by 2002:a37:a14d:: with SMTP id k74mr25293998qke.308.1570966922588;
        Sun, 13 Oct 2019 04:42:02 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id d25sm1763837qtj.84.2019.10.13.04.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 04:42:01 -0700 (PDT)
Date:   Sun, 13 Oct 2019 07:41:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v4 0/5] vhost: ring format independence
Message-ID: <20191013113940.2863-1-mst@redhat.com>
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

changes from v3:
        - fixed error handling in case of indirect descriptors
        - add BUG_ON to detect buffer overflow in case of bugs
                in response to comment by Jason Wang
        - minor code tweaks

Changes from v2:
	- fixed indirect descriptor batching
                reported by Jason Wang

Changes from v1:
	- typo fixes


Michael S. Tsirkin (5):
  vhost: option to fetch descriptors through an independent struct
  vhost/test: add an option to test new code
  vhost: batching fetches
  vhost/net: add an option to test new code
  vhost: last descriptor must have NEXT clear

 drivers/vhost/net.c   |  32 ++++-
 drivers/vhost/test.c  |  19 ++-
 drivers/vhost/vhost.c | 328 +++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |  20 ++-
 4 files changed, 385 insertions(+), 14 deletions(-)

-- 
MST

