Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CF818830B
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 13:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCQMJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 08:09:22 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41409 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgCQMJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 08:09:22 -0400
Received: by mail-ed1-f68.google.com with SMTP id v6so10944443edw.8
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 05:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CdpI6plcLqffgBOnjrXIKu3Uafpf4rcXyJ3pN99AXIc=;
        b=ShQsp79LXm5GC7td8lqoA5hp/BSeNQvRiooz2UKFzmJRaAOzkgZjn7b41Fvhmuu49M
         ZOSLn29Uj5nZ3XIkCxxwHGn2zMBaz3HEqE6LtEqOfAjivToFZCCTvMvo7J5GAXaE/lgb
         PGCme0lxaWYhE70YuoIlNnCe0UdQsRuMBaFmI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CdpI6plcLqffgBOnjrXIKu3Uafpf4rcXyJ3pN99AXIc=;
        b=LaCw+0g1z/hkEwHLP9/j3WR8DqyOgWErLzodzBOkkCrUzyVnJz5QobMf9Ddtac87tt
         fMBTzhWaG6UIbRLGTz/OtmrHt2P/VxXP0plS9UvWnMVXVWMJo3eBhnoVXmG7e8cRfC/q
         GFAC2Qzwy+KvyOtE9LWkG3pVcVRFkKARN+Rq1E4GbIG4+wxjG3dJqS2tQRIUqjz+E5Pg
         pVF5phRgnlwZ4mneeyJOQPAu7SX9Ctdt5Op7SuU0ZSaF4CMNHRSjyndTIOeIG6kO0s9Y
         hSZjeHswM2UtSfMvk11t0ZFoQzzTKKD+OqPozxQyHaVIgUjdrIHS9cY8b+lp9iCArBhC
         1yYQ==
X-Gm-Message-State: ANhLgQ2IfZxqrc53HIZhuCUw0cyqyJ9XvxBiVdugn1bmOUV6vCSfoMTD
        zzl72Rm4z+FDSbD0o6zMIzcZ07tC1Vs=
X-Google-Smtp-Source: ADFU+vt7TNrAM455nmXuZSvQyzDrNcKz83mZLGvVuBNS1c1ZgvK/q0xOYvcCY03iNh9MFPWzGv9L9w==
X-Received: by 2002:ac2:5187:: with SMTP id u7mr2264091lfi.153.1584446960058;
        Tue, 17 Mar 2020 05:09:20 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 23sm2389208lfa.28.2020.03.17.05.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 05:09:11 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 0/4] net: bridge: vlan options: add support for tunnel mapping
Date:   Tue, 17 Mar 2020 14:08:32 +0200
Message-Id: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
In order to bring the new vlan API on par with the old one and be able
to completely migrate to the new one we need to support vlan tunnel mapping
and statistics. This patch-set takes care of the former by making it a
vlan option. There are two notable issues to deal with:
 - vlan range to tunnel range mapping
   * The tunnel ids are globally unique for the vlan code and a vlan can
     be mapped to one tunnel, so the old API took care of ranges by
     taking the starting tunnel id value and incrementally mapping
     vlan id(i) -> tunnel id(i). This set takes the same approach and
     uses one new attribute - BRIDGE_VLANDB_ENTRY_TUNNEL_ID. If used
     with a vlan range then it's the starting tunnel id to map.

 - tunnel mapping removal
   * Since there are no reserved/special tunnel ids defined, we can't
     encode mapping removal within the new attribute, in order to be
     able to remove a mapping we add a vlan flag which makes the new
     tunnel option remove the mapping

The rest is pretty straight-forward, in fact we directly re-use the old
code for manipulating tunnels by just mapping the command (set/del). In
order to be able to keep detecting vlan ranges we check that the current
vlan has a tunnel and it's extending the current vlan range end's tunnel
id.

Thanks,
 Nik


Nikolay Aleksandrov (4):
  net: bridge: vlan options: rename br_vlan_opts_eq to
    br_vlan_opts_eq_range
  net: bridge: vlan tunnel: constify bridge and port arguments
  net: bridge: vlan options: add support for tunnel id dumping
  net: bridge: vlan options: add support for tunnel mapping set/del

 include/uapi/linux/if_bridge.h |  2 +
 net/bridge/br_netlink_tunnel.c | 12 +++---
 net/bridge/br_private.h        |  4 +-
 net/bridge/br_private_tunnel.h | 17 +++++---
 net/bridge/br_vlan.c           |  3 +-
 net/bridge/br_vlan_options.c   | 74 +++++++++++++++++++++++++++++++---
 net/bridge/br_vlan_tunnel.c    |  5 ++-
 7 files changed, 94 insertions(+), 23 deletions(-)

-- 
2.24.1

