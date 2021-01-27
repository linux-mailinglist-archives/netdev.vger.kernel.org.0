Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634D730647D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 20:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhA0T4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 14:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhA0T4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 14:56:32 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8AEC061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:55:51 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id p21so4367930lfu.11
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=km6g.us; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=Gmjn/q/Wwn3nkfj0rIvweePVh+TAnjwUdDd1tqGniIU=;
        b=m9g77dk9J++t2LwXanzZNZbK2H0DLG90kmoTqXId3C0duZLVgU6LNh+Pw+eKTWpe7p
         N5yZu9LLfFkPycI79ese6ZQhxNxjGpDZH3AIj+HqrXbUsAnI++kTtrHILpcDZUi1HZLV
         QJR9/T+OZWUS0JkNj5nqcwTA4ra7/kkwtfLqamuaJekFwFSsDZips/egsFkqb/HupSSF
         17sSynJuxJe9j5LhvL03TjLY8SVmSzz/bhfCqZxt7IS3LeD9TMOemwQm9azpCjSf6Sh3
         TibyqRX0kaR25NTQ63/LAJNoD2t78aYJeCTm6yGd9RYiEBiQ9iYS5uVSdgHiCUIOdoqu
         0Mig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Gmjn/q/Wwn3nkfj0rIvweePVh+TAnjwUdDd1tqGniIU=;
        b=XKeiex+0RVCvx9MZMRKZ4AkJdMGutcRNsf+q8s7RN63uKEQi0PsKdsQo7Eec1xzp4F
         w+ZWX3O73Wu0V/pg7bs/7jU7tTCCLh9vH/dOwrKFmP1e0oGFRwc05Y/9HQjc7JZUKh/v
         N6OlBMggsTpwiRz2uHyDxAdLCz1MdQdXo4Ifz0U2axWjVXljOVukZhWGmMCcaM35h/Fm
         DPFu/U5NsA0DTQxM/FzPjkta1DETy70sWTO4mXXhTsEq/NOggovpP9oNDf3Vg/CNvfxt
         c/1rsvhwDNQfv8dUxAUUifL2V8zDMz7r7nWqIJfDsmjYbnqY8kpZKnAXLL2jDLMfYodu
         wVIQ==
X-Gm-Message-State: AOAM531H+G/tRvnfm/uip+BIIQUuo7HmgWQhEWU4j5XbuxaySs2xiTxj
        LwoXjZ0sVRzyzLZlrF6DyXCcIqLpAze126E0bM4TiFCaSyeBsQ==
X-Google-Smtp-Source: ABdhPJxIpxbBNIwDi02PPajoMkqqeVhmqYklxhj8q7GV7iUPVojTL8k1mve+aodMdYN8WWZciyubVWVsgTGtcJloAFE=
X-Received: by 2002:a05:6512:49b:: with SMTP id v27mr6157254lfq.220.1611777349527;
 Wed, 27 Jan 2021 11:55:49 -0800 (PST)
MIME-Version: 1.0
From:   "Kevin P. Fleming" <kevin@km6g.us>
Date:   Wed, 27 Jan 2021 14:55:38 -0500
Message-ID: <CAE+Udoq9+90g-AE5wr_UVZ1RjsxBSyQ6RirjtWaZ0CSeNpck-A@mail.gmail.com>
Subject: Which interface events will remove IPv6 Proxy NDP addresses from the interface?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm trying to track down a problem with systemd-networkd; on three of
my machines, I have 'IPv6ProxyNDPAddress' configured in the network
configuration file so that additional addresses will be added when the
interface comes up.

Unfortunately, even though systemd-networkd is adding the addresses,
they disappear from the interface shortly afterward. It appears that
an interface event is occurring which removes them, and
systemd-networkd is not aware that it needs to re-add the addresses
when this event occurs.

An example is in the log below; 'eno1' (using the ixgbe driver in
kernel 5.10) is configured with five IPv6 Proxy NDP addresses. In the
log lines which include 'KPF' there is evidence that systemd-networkd
sent the requisite netlink messages to add them, and did not receive
any indication of failure. Yet, when I connect to the machine
immediately after bootup, the addresses are not in the table (as
displayed by 'ip neigh show proxy'). I can manually add them and the
system works as expected.

Can anyone indicate which event(s) in the log (this is a
systemd-networkd debug log, not a dmesg log) below could result in the
neighbor handling code removing the proxy addresses from the
interface?

---
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: New device has no
master, continuing without
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Flags change:
+MULTICAST +BROADCAST
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Link 2 added
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: udev initialized link
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: State changed:
pending -> initialized
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Saved original MTU: 1500
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Link state is up-to-date
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: found matching
network '/etc/systemd/network/eno1.network'
Jan 26 09:09:16 net20 systemd-networkd[2584]: Setting
'/proc/sys/net/ipv6/conf/eno1/disable_ipv6' to '0'
Jan 26 09:09:16 net20 systemd-networkd[2584]: Setting
'/proc/sys/net/ipv6/conf/eno1/use_tempaddr' to '0'
Jan 26 09:09:16 net20 systemd-networkd[2584]: Setting
'/proc/sys/net/ipv6/conf/eno1/accept_ra' to '0'
Jan 26 09:09:16 net20 systemd-networkd[2584]: Setting
'/proc/sys/net/ipv6/conf/eno1/proxy_ndp' to '1'
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: KPF: Configuring
proxy NDP address 2607:5300:203:5215:1::1
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: KPF: Configuring
proxy NDP address 2607:5300:203:5215:4::1
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: KPF: Configuring
proxy NDP address 2607:5300:203:5215:5::1
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: KPF: Configuring
proxy NDP address 2607:5300:203:5215:3::1
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: KPF: Configuring
proxy NDP address 2607:5300:203:5215:2::1
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Setting nomaster
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1:
promote_secondaries is unset, setting it
Jan 26 09:09:16 net20 systemd-networkd[2584]: Setting
'net/ipv4/conf/eno1/promote_secondaries' to '1'.
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Setting address
genmode for link
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Failed to read
sysctl property stable_secret: Input/output error
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Setting nomaster done.
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Setting address
genmode done.
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: State changed:
initialized -> configuring
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Bringing link up
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Flags change: +UP
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Link UP
Jan 26 09:09:16 net20 systemd-networkd[2584]: eno1: Started LLDP.
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: ff00::/8, src: n/a, gw: n/a, prefsrc: n/a, scope: global, table:
local, proto: boot, type: unicast
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: fe80::/64, src: n/a, gw: n/a, prefsrc: n/a, scope: global, table:
main, proto: kernel, type: unicast
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Flags change:
+LOWER_UP +RUNNING
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Gained carrier
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Acquiring DHCPv4 lease
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Configuring
address: 66.70.129.136
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Configuring
address: 66.70.129.142
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Configuring
address: 66.70.129.143
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Configuring
address: 2607:5300:203:5215::1
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Setting addresses
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Remembering
updated address: 66.70.129.136/32 (valid forever)
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 66.70.129.136/32, src: n/a, gw: n/a, prefsrc: 66.70.129.136,
scope: host, table: local, proto: kernel, type: local
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Remembering
updated address: 66.70.129.142/32 (valid forever)
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 66.70.129.142/32, src: n/a, gw: n/a, prefsrc: 66.70.129.142,
scope: host, table: local, proto: kernel, type: local
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Remembering
updated address: 66.70.129.143/32 (valid forever)
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 66.70.129.143/32, src: n/a, gw: n/a, prefsrc: 66.70.129.143,
scope: host, table: local, proto: kernel, type: local
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 2607:5300:203:5215::/64, src: n/a, gw: n/a, prefsrc: n/a, scope:
global, table: main, proto: kernel, type: unicast
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Remembering
updated address: 2607:5300:203:5215::1/64 (valid forever)
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: Addresses set
Jan 26 09:09:27 net20 systemd-networkd[2584]: eno1: an address
2607:5300:203:5215::1/64 is not ready
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Flags change:
-LOWER_UP -RUNNING
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Lost carrier
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Removing address
66.70.129.136
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Removing address
66.70.129.143
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Removing address
66.70.129.142
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Removing address
2607:5300:203:5215::1
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: State is
configuring, dropping config
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Forgetting
address: 66.70.129.136/32 (valid forever)
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Forgetting route:
dst: 66.70.129.136/32, src: n/a, gw: n/a, prefsrc: 66.70.129.136,
scope: host, table: local, proto: kernel, type: local
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Forgetting
address: 66.70.129.143/32 (valid forever)
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Forgetting route:
dst: 66.70.129.143/32, src: n/a, gw: n/a, prefsrc: 66.70.129.143,
scope: host, table: local, proto: kernel, type: local
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Forgetting
address: 66.70.129.142/32 (valid forever)
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Forgetting route:
dst: 66.70.129.142/32, src: n/a, gw: n/a, prefsrc: 66.70.129.142,
scope: host, table: local, proto: kernel, type: local
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Forgetting
address: 2607:5300:203:5215::1/64 (valid forever)
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static routes are not configured.
Jan 26 09:09:28 net20 systemd-networkd[2584]: eno1: Forgetting route:
dst: 2607:5300:203:5215::/64, src: n/a, gw: n/a, prefsrc: n/a, scope:
global, table: main, proto: kernel, type: unicast
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Flags change:
+LOWER_UP +RUNNING
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Started LLDP.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Gained carrier
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Acquiring DHCPv4 lease
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Configuring
address: 66.70.129.136
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Configuring
address: 66.70.129.142
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Configuring
address: 66.70.129.143
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Configuring
address: 2607:5300:203:5215::1
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Setting addresses
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering
updated address: 66.70.129.136/32 (valid forever)
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 66.70.129.136/32, src: n/a, gw: n/a, prefsrc: 66.70.129.136,
scope: host, table: local, proto: kernel, type: local
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering
updated address: 66.70.129.142/32 (valid forever)
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 66.70.129.142/32, src: n/a, gw: n/a, prefsrc: 66.70.129.142,
scope: host, table: local, proto: kernel, type: local
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering
updated address: 66.70.129.143/32 (valid forever)
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 66.70.129.143/32, src: n/a, gw: n/a, prefsrc: 66.70.129.143,
scope: host, table: local, proto: kernel, type: local
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 2607:5300:203:5215::/64, src: n/a, gw: n/a, prefsrc: n/a, scope:
global, table: main, proto: kernel, type: unicast
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering
updated address: 2607:5300:203:5215::1/64 (valid forever)
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static addresses are not configured.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Addresses set
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: an address
2607:5300:203:5215::1/64 is not ready
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: DHCPv4 address
51.79.18.21/24 via 51.79.18.254
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Updating address:
51.79.18.21
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering
updated address: 51.79.18.21/24 (valid for 1d)
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1:
link_check_ready(): an address 2607:5300:203:5215::1/64 is not ready.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 51.79.18.21/32, src: n/a, gw: n/a, prefsrc: 51.79.18.21, scope:
host, table: local, proto: kernel, type: local
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 51.79.18.255/32, src: n/a, gw: n/a, prefsrc: 51.79.18.21, scope:
link, table: local, proto: kernel, type: broadcast
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 51.79.18.0/24, src: n/a, gw: n/a, prefsrc: 51.79.18.21, scope:
link, table: main, proto: kernel, type: unicast
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 51.79.18.0/32, src: n/a, gw: n/a, prefsrc: 51.79.18.21, scope:
link, table: local, proto: kernel, type: broadcast
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: DHCP: No routes
received from DHCP server: No data available
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Configuring route:
dst: 51.79.18.254/32, src: n/a, gw: n/a, prefsrc: 51.79.18.21, scope:
link, table: main, proto: dhcp, type: unicast
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Configuring route:
dst: n/a, src: n/a, gw: 51.79.18.254, prefsrc: 51.79.18.21, scope:
global, table: main, proto: dhcp, type: unicast
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Received
remembered route: dst: 51.79.18.254/32, src: n/a, gw: n/a, prefsrc:
51.79.18.21, scope: link, table: main, proto: dhcp, type: unicast
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Received
remembered route: dst: n/a, src: n/a, gw: 51.79.18.254, prefsrc:
51.79.18.21, scope: global, table: main, proto: dhcp, type: unicast
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1:
link_check_ready(): an address 2607:5300:203:5215::1/64 is not ready.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering
foreign address: fe80::d250:99ff:fed4:2aca/64 (valid forever)
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1:
link_check_ready(): an address 2607:5300:203:5215::1/64 is not ready.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Gained IPv6LL
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1:
link_check_ready(): an address 2607:5300:203:5215::1/64 is not ready.
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: fe80::d250:99ff:fed4:2aca/128, src: n/a, gw: n/a, prefsrc: n/a,
scope: global, table: local, proto: kernel, type: local
Jan 26 09:09:29 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: fe80::/128, src: n/a, gw: n/a, prefsrc: n/a, scope: global,
table: local, proto: kernel, type: anycast
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1: Remembering
updated address: 2607:5300:203:5215::1/64 (valid forever)
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1:
link_check_ready(): static routes are not configured.
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1: Configuring route:
dst: 2607:5300:203:52ff:ff:ff:ff:ff/128, src: n/a, gw: n/a, prefsrc:
n/a, scope: global, table: main, proto: static, type: unicast
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1: Configuring route:
dst: n/a, src: n/a, gw: 2607:5300:203:52ff:ff:ff:ff:ff, prefsrc: n/a,
scope: global, table: main, proto: static, type: unicast
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1: Setting routes
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 2607:5300:203:5215::1/128, src: n/a, gw: n/a, prefsrc: n/a,
scope: global, table: local, proto: kernel, type: local
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1: Remembering route:
dst: 2607:5300:203:5215::/128, src: n/a, gw: n/a, prefsrc: n/a, scope:
global, table: local, proto: kernel, type: anycast
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1: Received
remembered route: dst: 2607:5300:203:52ff:ff:ff:ff:ff/128, src: n/a,
gw: n/a, prefsrc: n/a, scope: global, table: main, proto: static,
type: unicast
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1: Received
remembered route: dst: n/a, src: n/a, gw:
2607:5300:203:52ff:ff:ff:ff:ff, prefsrc: n/a, scope: global, table:
main, proto: static, type: unicast
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1: Routes set
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1:
link_check_ready(): dhcp4:yes dhcp6_addresses:no dhcp_routes:no
dhcp_pd_addresses:no dhcp_pd_routes:no ndisc_addresses:no
ndisc_routes:no
Jan 26 09:09:30 net20 systemd-networkd[2584]: eno1: State changed:
configuring -> configured
