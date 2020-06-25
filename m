Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E278E209818
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 03:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389029AbgFYBP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 21:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388789AbgFYBP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 21:15:27 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E917C061573;
        Wed, 24 Jun 2020 18:15:27 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id a8so1677099edy.1;
        Wed, 24 Jun 2020 18:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=X9JRDW8ZaY5gXK7oQX1lpYNKjj/ewNKbuEue189awZY=;
        b=Bp2zP10GJB9271NeICjDCfVeh+REf5iLd7/5t2x6CTA2oQaVYd7UKwphYLiBHY3TYk
         2vnZI3GGnmDplmNSYmpTuvvVrp4gZ+TG/55F9X2p+kRO/x9vbwwGhLy/I6sdCNcaE1cm
         JUa+PxPIF8hH7zQ19fwNv3Ne6SJSzKm1tkSoleK9va4h5C/VshO9E8baUUOWzx4xPIEx
         M6dyqWJjTZoyEE6qXO51iAR/dU84idDTBkEttxZRqoZvPPcwvjJd9wBBv/xpxB6ucCXH
         X6js6Z2+uhRNehaSDMRHLYJhnxXLmfHG3/9XJOkowuGny53ibkD7pez75wOV4TmUngZj
         NYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=X9JRDW8ZaY5gXK7oQX1lpYNKjj/ewNKbuEue189awZY=;
        b=YazakwnqJNSkxy3+u3KW7Fyr/7jXhOQm5uGgTrG3EjyQe6XU3ua581DazIbMQyFgdj
         BZqWXKzNpP9eWyAkMA2ygbA9ZnP8iCPwD4MvmVRe7OCW/sMfPh+U4qy207JjRJfpyUVY
         RBoKIW+VlC8KN39VY4aWn7MhS5egYYboqYjFEVfu7YMYcTt1PWi2WCkwnZ6+INICTOXz
         Wb+voQxFEczucv0fUQHT+QqIRkkf41VdfErWQJc+HNvzgl1Q5kiS09yyjqlTRGayg+dY
         W/pcBnrx0xjyIAdKFotP9WZc2xBIEtDr1S9+xacrYVJbNsFJTv6qnRcIBI9N1hAYR+3E
         rtyA==
X-Gm-Message-State: AOAM5330u3f8gN3oVaND9ihCtyR/70HyVh8tGcOC3+3LlkFjzXcEqVoH
        S5jC52cBs0wl3fy7S2Cr7N53+1qJ
X-Google-Smtp-Source: ABdhPJxKnOgjfJ8dz2JT7jQRYsVE6zfmT+f+qwBbDBC2kpXg3psQbPiyNzFBby2/u1FhVf9lIVSEGA==
X-Received: by 2002:a50:e0ca:: with SMTP id j10mr30234992edl.313.1593047725678;
        Wed, 24 Jun 2020 18:15:25 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l24sm16080423ejb.5.2020.06.24.18.15.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jun 2020 18:15:24 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 0/3] net: bcmgenet: use hardware padding of runt frames
Date:   Wed, 24 Jun 2020 18:14:52 -0700
Message-Id: <1593047695-45803-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that scatter-gather and tx-checksumming are enabled by default
it revealed a packet corruption issue that can occur for very short
fragmented packets.

When padding these frames to the minimum length it is possible for
the non-linear (fragment) data to be added to the end of the linear
header in an SKB. Since the number of fragments is read before the
padding and used afterward without reloading, the fragment that
should have been consumed can be tacked on in place of part of the
padding.

The third commit in this set corrects this by removing the software
padding and allowing the hardware to add the pad bytes if necessary.

The first two commits resolve warnings observed by the kbuild test
robot and are included here for simplicity of application.

Doug Berger (3):
  net: bcmgenet: re-remove bcmgenet_hfb_add_filter
  net: bcmgenet: use __be16 for htons(ETH_P_IP)
  net: bcmgenet: use hardware padding of runt frames

 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 88 ++------------------------
 1 file changed, 5 insertions(+), 83 deletions(-)

-- 
2.7.4

