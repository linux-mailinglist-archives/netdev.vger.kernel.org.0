Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141B42CC05B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgLBPIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgLBPIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 10:08:22 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB85C0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 07:07:36 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b10so1426516pfo.4
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 07:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0rMG30bUe2+z4/9iFnHktL0Dc4qw/SCIVrJgeuTjN1Q=;
        b=OW5N8Q3FyvFiL1aYcnUlYaZc+UjlQ3OwENcmuDhmFV14Y2Pt4gA6HpWKSM2QhnUX/T
         UPq8H+sr5ovSUXH93KVQ6lpoaL9mwTUw8zOjNECp/4vhNytzjdxxbgUNDiV+qjU083im
         7qR9Y6jlpDdY/8EM3b+lJdLoNTFQo2yXa/7FZULWgbzaRihCQ2rRgM45I2BtIiKUzAuh
         iVtoBYZ2IzY0aYqXYgS6mEstuJiUPKgCKO5yCEA5E55JNQ+YDYPLIcE3OAYZlmfayhHn
         6gNpZULWloHamNLbArymMraVOtZmf6x6jtGf3fLFIkWywierTTWfK40nVXPYr3y8yhs8
         Z8LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0rMG30bUe2+z4/9iFnHktL0Dc4qw/SCIVrJgeuTjN1Q=;
        b=Jt7a8uEz746fwnpkDX01XF6LA57UDCwRYTcK9n4AD0a0dFm7+n43LeTlCgfLTYaC0t
         f5sZokQXp2zwY7c9DKp+5nB+pHQgk5TFpCBvARhQMF/LoT+tu2HtsIn8NOMJ21w16o44
         6kwC5GQLJM1SumHn7Gh4OZnEtiw6FZCVT/U4w7OeYFlUf7Yk/2GfPmBlBLaQxatuapgr
         h970466TXfei/vYIBt5a5P7chpCShyoSO8Xa9lHwYYlAZfflnBP7ufXvefuzsB3xEOHd
         D5+I7SpGOady2V1/hqDefQslTsZgYTFWLw5PMxC9vcBpqtDK19Z9Q89csGdrmOg75Qvg
         VcdQ==
X-Gm-Message-State: AOAM531umPxHB307fz9uAKetHbZ8WtoGcJ0QPxPCLClafQM+DU+IVNMh
        Wrw7Q9jAGvOYuaGGyenKXa3C8rlzccWkPoDysw0=
X-Google-Smtp-Source: ABdhPJxPK3j35QfSAo7mL6R8ea+T9nKJPhAXDRb5gFADB7Dh28KPkLC2QE06iDZCYVuqriokcFG7uw==
X-Received: by 2002:a63:d50a:: with SMTP id c10mr256061pgg.217.1606921656204;
        Wed, 02 Dec 2020 07:07:36 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id p21sm148537pfn.87.2020.12.02.07.07.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Dec 2020 07:07:35 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH net-next 0/3] i40e, ice, ixgbe: optimize for XDP_REDIRECT in xsk path
Date:   Wed,  2 Dec 2020 16:07:21 +0100
Message-Id: <20201202150724.31439-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Optimize run_xdp_zc() for the XDP program verdict being XDP_REDIRECT
in the zsk zero-copy path. This path is only used when having AF_XDP
zero-copy on and in that case most packets will be directed to user
space. This provides around 100k extra packets in throughput on my
server when running l2fwd in xdpsock.

Thanks: Magnus

Magnus Karlsson (3):
  i40: optimize for XDP_REDIRECT in xsk path
  ixgbe: optimize for XDP_REDIRECT in xsk path
  ice: optimize for XDP_REDIRECT in xsk path

 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 11 +++++++----
 drivers/net/ethernet/intel/ice/ice_xsk.c     | 12 ++++++++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 11 +++++++----
 3 files changed, 22 insertions(+), 12 deletions(-)


base-commit: 6b4f503186b73e3da24c6716c8c7ea903e6b74d4
--
2.29.0
