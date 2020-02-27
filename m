Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A5017170A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgB0MXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:23:35 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44992 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729010AbgB0MXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 07:23:34 -0500
Received: by mail-pf1-f193.google.com with SMTP id y5so1541140pfb.11
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 04:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RQ1R3TRDtNYXVBosYqMikPWgjTItHvzcC5WgHnEGuak=;
        b=dLFD1l6JiwHRyb/ynEK/YbeTMQlCg53EW23Zy8ieIjzOLg74QbgS4PUkFL3AVSPt7y
         oj67Iku6nydycI2uNp4ZmZLfpLredoEi5JBYMNJLeU/IN+tTE3eZmMOKONwC/2KVDRaC
         iBhF9zLQmkyN5qHmdb0QUtRbp5kwKwLgEaLr9qR+R+xnF22kiCf0Ag73VmsoqUJgjuRn
         p0OyHrUVZarwkytwkn3b0bf0WPbolgox9fybh9PW2I5dpuy9WJk9gmFBVGFiyRCwDwcv
         OK7J9PtTtY5+PmxEGFiGN0ykByieK4G3RRCIDVByUgMJnma64L5j3Mb15T9icom1iXn7
         qWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RQ1R3TRDtNYXVBosYqMikPWgjTItHvzcC5WgHnEGuak=;
        b=ohjman502TK3cePFhV+mxJwm5sS3O2ONr/ymUGPBl6rJYy44BDqs9H7fioMWJKZdSU
         roGbvreoED3jCQwFNR4jxki5KYuheNA2hBlvxe7sQWM+AKBJ5KHoyWeMDw5lWHSj3eNm
         UdoNb45aE8DkrHaEv8fFJv1R0z1/phqjKVkJfwrxFUAnyrKs5yJukkbZ4wFRC4Upo1jp
         b+yHk9lhaNzLHgVx9aQYnubsV5IQ8G/F1Nnb1aIjPy3wg/6MtNvwTMjhEWIeEs3j1ZAb
         9L13yyIehVuvQbc5AbkWhcMwU1pDOHLTHdyL+VXcDbuSqnBpdHMpxXnbW4aGPDBlbil0
         RuAA==
X-Gm-Message-State: APjAAAXRp6AzHUFSF2Ty+AqxeWYy1Qyq+8K6u/IThx4V0HkiUiW1r9DV
        MB4uKtyjDXKSGNoIRxsdz+s=
X-Google-Smtp-Source: APXvYqxUotUU/EFzN6tOX6humQnn/0Uua6Q1OgKxEjJBWgvd3RR5TWRG4J1U/bxGWdE1JVxtk8+yiw==
X-Received: by 2002:a63:7d59:: with SMTP id m25mr3739852pgn.356.1582806213556;
        Thu, 27 Feb 2020 04:23:33 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id r66sm7485562pfc.74.2020.02.27.04.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 04:23:32 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 0/8] net: rmnet: fix several bugs
Date:   Thu, 27 Feb 2020 12:23:24 +0000
Message-Id: <20200227122324.18855-1-ap420073@gmail.com>
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

2. The second patch fixes NULL-ptr-deref in rmnet_changelink().
To get real device in rmnet_changelink(), it uses IFLA_LINK.
But, IFLA_LINK should not be used in rmnet_changelink().

3. The third patch fixes suspicious RCU usage in rmnet_get_port().
rmnet_get_port() uses rcu_dereference_rtnl().
But, rmnet_get_port() is used by datapath.
So, rcu_dereference_bh() should be used instead of rcu_dereference_rtnl().

4. The fourth patch fixes suspicious RCU usage in
rmnet_force_unassociate_device().
RCU critical section should not be scheduled.
But, unregister_netdevice_queue() in the rmnet_force_unassociate_device()
would be scheduled.
So, the RCU warning occurs.
In this patch, the rcu_read_lock() in the rmnet_force_unassociate_device()
is removed because it's unnecessary.

5. The fifth patch fixes duplicate MUX ID case.
RMNET MUX ID is unique.
So, rmnet interface isn't allowed to be created, which have
a duplicate MUX ID.
But, only rmnet_newlink() checks this condition, rmnet_changelink()
doesn't check this.
So, duplicate MUX ID case would happen.

6. The sixth patch fixes upper/lower interface relationship problems.
When IFLA_LINK is used, the upper/lower infrastructure should be used.
Because it checks the maximum depth of upper/lower interfaces and it also
checks circular interface relationship, etc.
In this patch, netdev_upper_dev_link() is used.

7. The seventh patch fixes bridge related problems.
a) ->ndo_del_slave() doesn't work.
b) It couldn't detect circular upper/lower interface relationship.
c) It couldn't prevent stack overflow because of too deep depth
of upper/lower interface
d) It doesn't check the number of lower interfaces.
e) Panics because of several reasons.
These problems are actually the same problem.
So, this patch fixes these problems.

8. The eighth patch fixes packet forwarding issue in bridge mode
Packet forwarding is not working in rmnet bridge mode.
Because when a packet is forwarded, skb_push() for an ethernet header
is needed. But it doesn't call skb_push().
So, the ethernet header will be lost.

Change log:
 - update commit logs.
 - drop two patches in this patchset because of wrong target branch.
   - ("net: rmnet: add missing module alias")
   - ("net: rmnet: print error message when command fails")
 - remove unneessary rcu_read_lock() in the third patch.
 - use rcu_dereference_bh() instead of rcu_dereference in third patch.
 - do not allow to add a bridge device if rmnet interface is already
   bridge mode in the seventh patch.

Taehee Yoo (8):
  net: rmnet: fix NULL pointer dereference in rmnet_newlink()
  net: rmnet: fix NULL pointer dereference in rmnet_changelink()
  net: rmnet: fix suspicious RCU usage
  net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()
  net: rmnet: do not allow to change mux id if mux id is duplicated
  net: rmnet: use upper/lower device infrastructure
  net: rmnet: fix bridge mode bugs
  net: rmnet: fix packet forwarding in rmnet bridge mode

 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 186 +++++++++---------
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |   3 +-
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |   7 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |   8 -
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   1 -
 5 files changed, 98 insertions(+), 107 deletions(-)

-- 
2.17.1

