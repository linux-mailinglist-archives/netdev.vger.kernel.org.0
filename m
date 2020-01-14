Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A82F13B17A
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 18:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgANR6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 12:58:32 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:39442 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgANR6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 12:58:32 -0500
Received: by mail-lj1-f174.google.com with SMTP id l2so15360123lja.6
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 09:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4lvd4hONF4LwQ0KcHPfRvvqYGPQNzQBVH0ylqHglG+U=;
        b=e8DEKRPlXoM8gE2YiOrEiUZdNFMy7q5S9RzC5clSP9ltor8zYOx2W+bpxhhMh5HVvE
         VEH41BXSLrhXK03uKplOQv461L4yaga18aLv8a9ptQixB3KgJc0rvOgAI5IryIW+3KQ6
         x3kbwh+QO8uJGSVzHvASIz78omT7bW35QViXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4lvd4hONF4LwQ0KcHPfRvvqYGPQNzQBVH0ylqHglG+U=;
        b=R2Romrj87+vVLQT1CB5xyqQcJC7EEJXb/l3kmxv9MnIV5JWDhcL74kOQJsjO3JaOuc
         JjZOaLyk6+/hs7u3/ilHDzyFa6FGO9MOShHpAwI0/y2COdIan3EcDLh3VgHdxBXH9/Kb
         xT10ej17n7KuWbwRUg9jsWzlW1f5ldcv0hSxr0h7T1UOM/HayR0J9j7EFSiqaCLMkSn3
         mQzPhwurzrcgvdgjoZDKLB+rHjctLLPtydX17XKyaO1EyExSRQpEE5lI8hw5mPpBe+fQ
         TNvuq3U7Y/VuNchG3SY/huSJqYbfJNq0DTWfqF4I5IB7CNhvyMWcx9gHeTVTLNPBn/3m
         f2lg==
X-Gm-Message-State: APjAAAX5auOhSnxQfQhRjZu3FvzqJE3AQ4X4ITF0Y1xoq1T9eR4Ryyxk
        cSTlyCkxsbwMbngeevq4HWw9N0ONhTQ=
X-Google-Smtp-Source: APXvYqyat+OPBi6KKdRfQCuLD6z6EVJdbn86ar77Psvojs+Mp+Wfs56qHEsMQBumL14GQp9iZkjjIQ==
X-Received: by 2002:a2e:86d6:: with SMTP id n22mr15168541ljj.77.1579024708985;
        Tue, 14 Jan 2020 09:58:28 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a15sm7685655lfi.60.2020.01.14.09.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 09:58:27 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 0/8] net: bridge: add vlan notifications and rtm support
Date:   Tue, 14 Jan 2020 19:56:06 +0200
Message-Id: <20200114175614.17543-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This patch-set is a prerequisite for adding per-vlan options support
because we need to be able to send vlan-only notifications and do larger
vlan netlink dumps. Per-vlan options are needed as we move the control
more to vlans and would like to add per-vlan state (needed for per-vlan
STP and EVPN), per-vlan multicast options and control, and I'm sure
there would be many more per-vlan options coming.
Now we create/delete/dump vlans with the device AF_SPEC attribute which is
fine since we support vlan ranges or use a compact bridge_vlan_info
structure, but that cannot really be extended to support per-vlan options
well. The biggest issue is dumping them - we tried using the af_spec with
a new vlan option attribute but that led to insufficient message size
quickly, also another minor problem with that is we have to dump all vlans
always when notifying which, with options present, can be huge if they have
different options set, so we decided to add new rtm message types
specifically for vlans and register handlers for them and a new bridge vlan
notification nl group for vlan-only notifications.
The new RTM NEW/DEL/GETVLAN types introduced match the current af spec
bridge functionality and in fact use the same helpers.
The new nl format is:
 [BRIDGE_VLANDB_ENTRY]
    [BRIDGE_VLANDB_ENTRY_INFO] - bridge_vlan_info (either 1 vlan or
                                                   range start)
    [BRIDGE_VLANDB_ENTRY_RANGE] - range end

This allows to encapsulate a range in a single attribute and also to
create vlans and immediately set options on all of them with a single
attribute. The GETVLAN dump can span multiple messages and dump all the
necessary information. The vlan-only notifications are sent on
NEW/DELVLAN events or when vlan options change (currently only flags),
we try hard to compress the vlans into ranges in the notifications as
well. When the per-vlan options are added we'll add helpers to check for
option equality between neighbor vlans and will keep compressing them
when possible.

Note patch 02 is not really required, it's just a nice addition to have
human-readable error messages from the different vlan checks.

iproute2 changes and selftests will be sent with the next set which adds
the first per-vlan option - per-vlan state similar to the port state.

v2: changed patch 03 and patch 04 to use nlmsg_parse() in order to
    strictly validate the msg and make sure there are no remaining bytes


Thank you,
 Nik


Nikolay Aleksandrov (8):
  net: bridge: vlan: add helpers to check for vlan id/range validity
  net: bridge: netlink: add extack error messages when processing vlans
  net: bridge: vlan: add rtm definitions and dump support
  net: bridge: vlan: add new rtm message support
  net: bridge: vlan: add del rtm message support
  net: bridge: vlan: add rtm range support
  net: bridge: vlan: add rtnetlink group and notify support
  net: bridge: vlan: notify on vlan add/delete/change flags

 include/uapi/linux/if_bridge.h |  29 ++
 include/uapi/linux/rtnetlink.h |   9 +
 net/bridge/br_netlink.c        |  61 +++--
 net/bridge/br_private.h        |  90 +++++++
 net/bridge/br_vlan.c           | 473 +++++++++++++++++++++++++++++++--
 security/selinux/nlmsgtab.c    |   5 +-
 6 files changed, 632 insertions(+), 35 deletions(-)

-- 
2.21.0

