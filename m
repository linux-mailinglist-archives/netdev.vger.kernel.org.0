Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E87440C48
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhJ3XRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231556AbhJ3XRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:17:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6DDB60EFF;
        Sat, 30 Oct 2021 23:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635713;
        bh=EVeElz31ONRZOfi4Vg1QD7QP9/eOpLPzmYgxFc9QW5s=;
        h=From:To:Cc:Subject:Date:From;
        b=GA5t6t2rmlv/AnShndTvrlfksMXO1Ok7TyZ0ND2/ksBHV3JmGw1W2AtCFKRuFyoKY
         zMHN6sMOfccMFBmtnc9k+uwz4hgyJaw16oenemtJA11IRPdDyDd5P2B6T1uA8aVB7u
         mvbEP+t2+dK0AKCj/UxsZq1Gb2lGUMesQ7t//YVHObXq6F/5f9eGFtOt14JPRBfSmN
         YyXob/vLkssnUb52a8RZV7IkRtjLHNWk4hjIu2PjnY41DToYZPLhguWKapiZIqwfVo
         JGcB7HxbMRLJVYKjIhiFJqm6x+SNuH+JrB8Hg4BF9gML/rAtvljNxBS5XPwwea0YzY
         4olKdRZVKVndg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/5] netdevsim: improve separation between device and bus
Date:   Sat, 30 Oct 2021 16:15:00 -0700
Message-Id: <20211030231505.2478149-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VF config falls strangely in between device and bus
responsibilities today. Because of this bus.c sticks fingers
directly into struct nsim_dev and we look at nsim_bus_dev
in many more places than necessary.

Make bus.c contain pure interface code, and move
the particulars of the logic (which touch on eswitch,
devlink reloads etc) to dev.c. Rename the functions
at the boundary of the interface to make the separation
clearer.

v2: add missing statics after functions were un-exposed

Jakub Kicinski (5):
  netdevsim: take rtnl_lock when assigning num_vfs
  netdevsim: move vfconfig to nsim_dev
  netdevsim: move details of vf config to dev
  netdevsim: move max vf config to dev
  netdevsim: rename 'driver' entry points

 drivers/net/netdevsim/bus.c       | 155 ++----------------------
 drivers/net/netdevsim/dev.c       | 188 ++++++++++++++++++++++++++----
 drivers/net/netdevsim/netdev.c    |  72 ++++++------
 drivers/net/netdevsim/netdevsim.h |  55 ++++-----
 4 files changed, 235 insertions(+), 235 deletions(-)

-- 
2.31.1

