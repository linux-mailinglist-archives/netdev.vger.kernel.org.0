Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5233E525D
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237191AbhHJElY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236469AbhHJElX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 00:41:23 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DFDC0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 21:41:02 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id n17so13588802lft.13
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 21:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=efM2azY1GAvdk/UvUuz5kJMAAN4U4q/U85YcIAgQ+ME=;
        b=lMw7+lN7Usqhku94n2XtHEsY/VysmPxQvlS/cwl7nBd3+UIkFC0TNiVyqq5g3ExNnv
         i7CGs6aKJboxrCIDWGYsB8bYdn2x7gcwGajHuAy4gzm4yFpwVMqh/QTcAXvhSgUL1F7M
         dMSjDrYuW7Z5e8W2Ai6Su1zoPp4FWLWAKtwLGq4x92fMNExfFh6hnCDJ4LofqUnJbl6G
         HIdYM4GjzPi4SAXU6UrF9LNXR1JY1ifTxjD6rm2vIeybNwS+GZ0AFhkBlVjICZx3pStU
         l4ao4yRaHQhjDfI801J3dLy4oEhDTLNkEfxauC1kBkbO+WCI0EZ0YeKzCt8WwKD5yZ7y
         T+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=efM2azY1GAvdk/UvUuz5kJMAAN4U4q/U85YcIAgQ+ME=;
        b=HOWQGiWZHvIj66yWCxLmrj1uZWBWbtwPVekVTCTZ3T9vPwnJRNSvcZedO8ZXycj5az
         5C+HQRIk/u5JIN6HPgZyqWWBrCq41ENP8OtOB25I/m+1xuz7WG845CR8EFyObD/rwNgg
         RgP24bdGNmrcIEnaJe+LB0NRT05hgXE/GV2bHVZhkR1OxVQEoKnCBhBZHOrcyyGss9pO
         3FNqevXHUxurFRU5/Z2Wsw+YfscU+c7aiQYZNtyLHBB6pHs9z/fvOfXrGkui8b30JkCI
         v/12EW4bIeIBM+bX2bIhhSYwUxfpXprfxHHJVialrbca3nE5Csi84BGA1fPReXJqO0IT
         VJug==
X-Gm-Message-State: AOAM533F2Uqmj+1zJJibsGeJBxB5Eyd6/rPVIhDvwQJ7MQeUgKxc7XcG
        m/n4VcdfQs9i2i7dak72fZmihDUrlI8HcGdHYhU=
X-Google-Smtp-Source: ABdhPJyH8Vr4DzBoD8z26laVLCMFLBVErlR+3N/+YJIuvQaPmAiEfFwve6ySAZQCVhwJFcfylVmgjOz5XWtiu31Zbu8=
X-Received: by 2002:a05:6512:33c4:: with SMTP id d4mr20918769lfg.618.1628570460592;
 Mon, 09 Aug 2021 21:41:00 -0700 (PDT)
MIME-Version: 1.0
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 10 Aug 2021 12:40:49 +0800
Message-ID: <CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com>
Subject: Bridge port isolation offload
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Bridge port isolation flag (BR_ISOLATED) was added in commit
7d850abd5f4e. But switchdev does not offload it currently.
It should be easy to implement in drivers, just like bridge offload
but prevent isolated ports to communicate with each other.

Your thoughts?

Regards,
  Qingfang
