Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C735513953D
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAMPxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:53:03 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:45602 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMPxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:53:03 -0500
Received: by mail-lj1-f181.google.com with SMTP id j26so10625380ljc.12
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 07:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4rdU00h44ADnRjwhROIBI7M9jhhbUlXeokwBcuNYYk=;
        b=cr+VGPpHAr8l9krM9sHZurZ49IsvLCXFch3eN3kk2yc8W9bBXDK9G2iNiGdXEoEtM8
         gKGupx014qx98PMJpUlbQW6lzGa7UkcyN6NiyEkv3CnOIGuNRRg9wogJc8klCuAPLpY8
         6i8qWfaMIXpq0+ioWLGDnmaNXrkhInMbkZAlk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4rdU00h44ADnRjwhROIBI7M9jhhbUlXeokwBcuNYYk=;
        b=PbgsVWfddgL9wQy39DsQ92LrRsWqxWa5AbJycRXd9xKiBjZSl6RfzkynN91XtRI6L6
         Wl5wNDaMZfWFg2lSwwiJSIp4uiET1g6VtW1uIYQzDnpHIPvPhxvWRx7CDR5+mrJFbymB
         MTkILSHpndmpavw53TEncUygU7KQuG8ObmlWDtMXBDvxXlo1PRv3a4qhLvhG/+6HAWBk
         Qc703ItLSJcvRF988U6H/03U75J3VzWvD8MSbj8J5e6cxDF0DWDqreXxASMB0QKKhnuK
         VWgcwNtj2wnEjWPYE69s/tNrwgB7vi9i+DfZW3FSCsNgkjwWiGSSDpbA3gknoPHJSF/+
         k+dQ==
X-Gm-Message-State: APjAAAVFBbMk968CujYwQe0uXFUzCb5c14lWfkQTUjYGjFZyCZtGe3ng
        +njnCT/UXCHohxkBELNPrWSqcMJOSiE=
X-Google-Smtp-Source: APXvYqxgL6QmUVV4q/T/Sm8PLTDq9uum3Mf4Vc7TCvryO0nlUpOeNiOCQcj2z77e81VKrWL8Y6/wTQ==
X-Received: by 2002:a2e:7405:: with SMTP id p5mr10578531ljc.34.1578930780991;
        Mon, 13 Jan 2020 07:53:00 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e20sm6175658ljl.59.2020.01.13.07.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 07:53:00 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 0/8] net: bridge: add vlan notifications and rtm support
Date:   Mon, 13 Jan 2020 17:52:25 +0200
Message-Id: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
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

