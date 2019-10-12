Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1DDD520E
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 21:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbfJLTSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 15:18:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729426AbfJLTSv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 15:18:51 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB7D746671
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 19:18:50 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id m19so13343380qtm.13
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 12:18:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=XSSfcNJSuQK6tbBIRVqD8nyyhs8/n5qs+oek7V16gWg=;
        b=Ocwa87czsxRl2wzFPsisH24KfmJwDS/VWlW1RXVL9T6mgLDFM6StYlxc8OoO0XVVcT
         i4GzsmbhgfNAODXr+9nF8ZCngDCLpA6f14320FexLJq13409OV83UYIYaRobCwqTWbuB
         W3mPYJngscFW4+5N0JClCtaPqfobJo/iUrJGCHsoJ4cqLVSdqm52zFwih+SRjG5ATrBJ
         +bGKfgx/ogE08D87nqnUMY1DvRujIa8HWF2loDalA32sOwvDPm8tM2to9ReY/4OxBSly
         HQDP2K3rt//ZvQo+sNwzers2Lpu3AgG1oxKCbN3dpeqfBBhUFREyBzKFB6H67EX8i6M0
         8FaA==
X-Gm-Message-State: APjAAAXh5LanL1OYPoeYy5wlBOvc2vmA5COa2tENiFKDPVS9NiCh6bZR
        dXkvCX4K86SYfQcRN7QiJzbW6BSlxxAdR72/0SO1YKL2mCQPpRgSLzGFwgbHEt+KDECCslZhY2w
        KvsG+L4RR926STmZK
X-Received: by 2002:a37:b8f:: with SMTP id 137mr21665698qkl.466.1570907930052;
        Sat, 12 Oct 2019 12:18:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyYVcRWvZEcwbiX5JXr6fNk4W01ojqCtNq7uXnEznHUo/iukXYBpKClYnD6en9lTNPNSsx0Ow==
X-Received: by 2002:a37:b8f:: with SMTP id 137mr21665681qkl.466.1570907929802;
        Sat, 12 Oct 2019 12:18:49 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id x55sm7350774qta.74.2019.10.12.12.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 12:18:48 -0700 (PDT)
Date:   Sat, 12 Oct 2019 15:18:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v2 0/2] vhost: ring format independence
Message-ID: <20191012191820.8050-1-mst@redhat.com>
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
More testing would be very much appreciated.

Biggest TODO before this first step is ready to go in is to
batch indirect descriptors as well.

Integrating into vhost-net is basically
s/vhost_get_vq_desc/vhost_get_vq_desc_batch/ -
or add a module parameter like I did in the test module.


Changes from v1:
	- typo fixes

Michael S. Tsirkin (2):
  vhost: option to fetch descriptors through an independent struct
  vhost: batching fetches

 drivers/vhost/test.c  |  19 ++-
 drivers/vhost/vhost.c | 333 +++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |  20 ++-
 3 files changed, 365 insertions(+), 7 deletions(-)

-- 
MST

