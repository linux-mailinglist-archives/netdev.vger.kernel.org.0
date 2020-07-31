Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE2B233C5C
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgGaAB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgGaABZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:01:25 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506F7C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:01:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k1so5639676pjt.5
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xGeRYh0geXlxNaZZInJy4WHwQd/fafzqKjbriawyrxM=;
        b=PkW4fqAy9TUw7FIPXvLj29bYki5bL8U4RI0C6BkmjmKVDgfZkn288qNiWgTkl2ieSP
         SyzohQRDEDSSCrsyomDYQuAXYcGSRxc70VkAo19juyjDpNUsY3YQbL0AdfQt4g+vzRsw
         o1Mx6zFBuIdfa0MW/uuboEcMLDcDCQ6jJ0L889fE8dNqm6PhQwCIRwDtqIEe4ElS3AHc
         AknGzHQavKlF1GpZ5A5/RQegAjFfbRmkx/r1oEN2ckFc5HW0KyUGvRReCMb/UYNfnfi/
         uii8YsZs1+Knh16k1t6nE5ynKRdXlJfgiVlVMqX2hLrj89773QRmS9zW5o03L2r4R5xE
         HsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xGeRYh0geXlxNaZZInJy4WHwQd/fafzqKjbriawyrxM=;
        b=XUgNlese/PnixeU8Isph0tKVqS7/h8YXEorPYJrLTtzLixWgcx+mIAfCQ2mMLbY6gm
         gEMYgsMCM79yCmHmHxlEftxhJYNxNYNmEpx0q2IycIpA7LWX/IKLf6OhFK757thR9Dex
         jKKANTDfRdaQLl+Qn5CyHZcf+49MwVNZC+y56lJiXe1eAU30OL+cKxOcOnMJJkxse3GL
         XUpSoM7yWTzx/4BWZTTJJA5hZNdY+QlRPz1XivVLGVLi6MCYL88lCAmgMOfAz8wQX+tE
         vDPYO8p8Wpozi5bKWY517hC97oeKAJV0SCmNHq3dE6x3jVL2FapO0zMkii/Bl0zNObAP
         jVRA==
X-Gm-Message-State: AOAM531jg0kl452M9PfdynZsce0+Rmo2C1JPArk3xNeblHPjQavdgDxI
        WgUxm2eCySHB5ARO735aBgYIaTIXXdI=
X-Google-Smtp-Source: ABdhPJzXpTznKWDn0zDHJz1aFCi9KlvHG1nma9Y7sqio1b+fBcyMQwptHEiRvGpEDpPkGtoWXtYpEw==
X-Received: by 2002:a62:1713:: with SMTP id 19mr1299160pfx.115.1596153684373;
        Thu, 30 Jul 2020 17:01:24 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm7592436pgf.53.2020.07.30.17.01.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 17:01:23 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/3] ionic txrx updates
Date:   Thu, 30 Jul 2020 17:00:55 -0700
Message-Id: <20200731000058.37344-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few patches to do some cleanup in the packet
handling and give us more flexibility in tuning performance
by allowing us to put Tx handling on separate interrupts
when it makes sense for particular traffic loads.

v2: dropped the original patch 2 for ringsize change
    changed the separated tx/rx interrupts to use ethtool -L

Shannon Nelson (3):
  ionic: use fewer firmware doorbells on rx fill
  ionic: tx separate servicing
  ionic: separate interrupt for Tx and Rx

 .../ethernet/pensando/ionic/ionic_ethtool.c   | 109 ++++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  42 +++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   5 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 188 ++++++++++++------
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   2 +
 5 files changed, 253 insertions(+), 93 deletions(-)

-- 
2.17.1

