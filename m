Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1734E17065A
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgBZRmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:42:39 -0500
Received: from mail-pl1-f171.google.com ([209.85.214.171]:42450 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgBZRmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:42:39 -0500
Received: by mail-pl1-f171.google.com with SMTP id u3so1555407plr.9
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CEf4Ufq3lBxy2eankSEkIOQ4MVNaWiF1Gx1hHqWhxO0=;
        b=tVttDRLSqCTri9yrcWnKHgB6HVH6dBKdIO1hOt5diXVl0m8hOc/mzISnN9LDePOf0P
         0RdKiT0657eil22TcZJWMMndtcgre1gIn8URzHyapBigkVn+a6oR1qkA99/U6Y6CbSI1
         aCE2rwGJhDjk/mPpJlYRQqmpUzoDinHw9ckYMPUJZJuUBAoAq8CM1jZ0lqjqXvltfkpo
         TiOru5NXaD0j8aQx06XVPgQRXecYKtWQHgJ9VP9JmY839VGy4/kMlufkl2jQZ+nk9jIz
         cgFBeRE2V6BlINVexo2RgKj9EdjhmrgHj9WkrXxrWK12mKF8aBLufXbmTxqu8d0kHYAe
         j0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CEf4Ufq3lBxy2eankSEkIOQ4MVNaWiF1Gx1hHqWhxO0=;
        b=BebCdnGX51rX0kUlx4qGOI4P6ywjdJRoVspuwoFMYucRpKPVcEFYuDhb98ZTKPzn6X
         GhgbovXOpcQi+Ib7Fa6iwJHo2l8plEaY3Ogg3DlYWfW+BUr5dhQi/gYh9K+bODyUmljs
         yjfBRawYB4pvidKT/qUxUxmHAdF8qqBn7ifYPTAkoLizakFhTm34C0eyyLcnvcNrXeVC
         PzRE2PTgg2hNsiILj7a/ClEzAb62iyD/J+dMNSl+iE3lUWQ5m6KRCeof3HWQa3EHOp+D
         /Lt8rSDDmy5CuJWoJ/UXT2Wiz7ZFFs29oi9dWEQ+qfQ3R3DzSVSrwgIAqkhiIkfxbH6i
         tDqg==
X-Gm-Message-State: APjAAAWjf4m0TDiCArWeJlN7s9OBVaQuq8VEIzMFHjwNqMDbknRm5MIj
        1PkDN1+4gdTawkUHn4D1fuM=
X-Google-Smtp-Source: APXvYqyoGlxIkhmBTkQcM/jNVCLsAx2wMYVY0qUlcxFJiCfAllvCkfBkY9zIyJ50WBnYoLZhzIXPjw==
X-Received: by 2002:a17:90b:3115:: with SMTP id gc21mr231200pjb.54.1582738957892;
        Wed, 26 Feb 2020 09:42:37 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id y2sm3973193pff.139.2020.02.26.09.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:42:36 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 00/10] net: rmnet: fix several bugs
Date:   Wed, 26 Feb 2020 17:41:59 +0000
Message-Id: <20200226174159.3769-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to fix several bugs in RMNET module.

1. The first patch fixes NULL-ptr-deref in rmnet_newlink().
When rmnet interface is being created, it uses IFLA_LINK
without checking NULL.
So, if userspace doesn't set IFLA_LINK, panic will occur.
In this patch, checking NULL pointer code is added.

2. The second patch adds module alias.
In the current rmnet code, there is no module alias.
So, RTNL couldn't load rmnet module automatically.

3. The third patch fixes NULL-ptr-deref in rmnet_changelink().
To get real device in rmnet_changelink(), it uses IFLA_LINK.
But, IFLA_LINK should not be used in rmnet_changelink().

4. The fourth patch fixes suspicious RCU usage in rmnet_get_port().
rmnet_get_port() uses rcu_dereference_rtnl().
But, rmnet_get_port() is used by datapath.
So, rcu_dereference() should be used instead of rcu_dereference_rtnl().

5. The fifth patch fixes suspicious RCU usage in
rmnet_force_unassociate_device().
RCU critical section should not be scheduled.
But, unregister_netdevice_queue() in the rmnet_force_unassociate_device()
would be scheduled.
So, the RCU warning occurs.
In this patch, the rcu_read_lock() in the rmnet_force_unassociate_device()
is removed because it's unnecessary.

6. The sixth patch adds extack error messages when command fails
When rmnet netlink command fails, it doesn't print any error message.
So, users couldn't know the exact reason.

7. The seventh patch fixes duplicate MUX ID case.
RMNET MUX ID is unique.
So, rmnet interface isn't allowed to be created, which have
a duplicate MUX ID.
But, only rmnet_newlink() checks this condition, rmnet_changelink()
doesn't check this.
So, duplicate MUX ID case would happen.

8. The eighth patch fixes upper/lower interface relationship problems.
When IFLA_LINK is used, the upper/lower infrastructure should be used.
Because it checks the maximum depth of upper/lower interfaces and it also
checks circular interface relationship, etc.
In this patch, netdev_upper_dev_link() is used.

9. The ninth patch fixes bridge related problems.
a) ->ndo_del_slave() doesn't work.
b) It couldn't detect circular upper/lower interface relationship.
c) It couldn't prevent stack overflow because of too deep depth
of upper/lower interface
d) It doesn't check the number of lower interfaces.
e) Panics because of several reasons.
These problems are actually the same problem.
So, this patch fixes these problems.

10. The tenth patch fixes packet forwarding issue in bridge mode
Packet forwarding is not working in rmnet bridge mode.
Because when a packet is forwarded, skb_push() for an ethernet header
is needed. But it doesn't call skb_push().
So, the ethernet header will be lost.

Taehee Yoo (10):
  net: rmnet: fix NULL pointer dereference in rmnet_newlink()
  net: rmnet: add missing module alias
  net: rmnet: fix NULL pointer dereference in rmnet_changelink()
  net: rmnet: fix suspicious RCU usage
  net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()
  net: rmnet: print error message when command fails
  net: rmnet: do not allow to change mux id if mux id is duplicated
  net: rmnet: use upper/lower device infrastructure
  net: rmnet: fix bridge mode bugs
  net: rmnet: fix packet forwarding in rmnet bridge mode

 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 210 +++++++++---------
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |   3 +-
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |   7 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  20 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   4 +-
 5 files changed, 122 insertions(+), 122 deletions(-)

-- 
2.17.1

