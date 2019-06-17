Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3671A47DA4
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfFQIxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:53:50 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38754 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfFQIxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 04:53:49 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so12833998edo.5
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 01:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=tVdybmwcrudt9c/Fjr6ik4Y4QWR2zx2XxazxsJ9Os08=;
        b=FgMRwUPbuEvJzbL8PBS5vNGvEhcMXLT3jMfxRuwMUz069Fb+j7se/WTJ3z9LVnjbG6
         98Y7N7aHskNgVPoVoIgwWL9SEEIgySDn0Y3Ur9PkQkJeqMHNRSMUn/kf5aXqKBUd58Cu
         hOtpiKGPLWCoS5YD3dk4HsTl1lW+dgDdlc49AX/mf5jUnvXV+FaL3Gu3qurNd428A3NV
         Vi3JfbZA4mopUsqmyJGa4Wgefr2/Y8tmGWn0qKXmQYswCfspBS2TWuTOOIdbHwrG0kP0
         IQ1zA2o6YKURf7muC7i9llEAKZ9ZFY5fJt8C0+lIwQFsk+a091YUQ9503gVgDtxV3EcN
         4uUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tVdybmwcrudt9c/Fjr6ik4Y4QWR2zx2XxazxsJ9Os08=;
        b=sWy1J1WMO6Ee755ZJMyynk25vF65vvgXefWJ2o2mxa7EA5NB7v7vLDpHxiVC/DmU1c
         c1iGkXKNpKgVwXuxgwmGoaghIXCqrld2s/ZsHxMfyHw6ZnU689UGD4VD+3FbuAVvHxgi
         /0YVkdPcjiYlLws8oBYzza2dcezxaa3d0xuRMrlxYBSFexNchmt7/OMw6pl8ob2MsiK2
         RWOQOs/dOxGWISEhabrXW2h868dP7AWw54WJwFx+hDV20Rcnbs9f2WQZMUs+RdpvItdD
         AhjOtYNdNMU+2prD/nSF47GlSG7wPyU3h+Iq04uQ0df5WzjieIH4LvjA9kIzCz68wqWd
         t19w==
X-Gm-Message-State: APjAAAURdMsJkPEz6gVFigO1rg+SJ/c3mY8PsCKDPctQyC9CEfkWVZMS
        e/5PCRYTE9oh4OcKrKjr08kvCA==
X-Google-Smtp-Source: APXvYqx/ZK+CJMvgB9VVxuWljmLEpBD7Y1zlCGUtpeu2PX2nLWMIOqMtyw4ZmxucdIEf+1EtiIeF/A==
X-Received: by 2002:a17:906:3452:: with SMTP id d18mr74122016ejb.24.1560761627751;
        Mon, 17 Jun 2019 01:53:47 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id y11sm2075735ejb.54.2019.06.17.01.53.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Jun 2019 01:53:47 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     davem@davemloft.net, dledford@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH 1/2] ipoib: correcly show a VF hardware address
Date:   Mon, 17 Jun 2019 10:53:38 +0200
Message-Id: <20190617085341.51592-1-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in the case of IPoIB with SRIOV enabled hardware
ip link show command incorrecly prints
0 instead of a VF hardware address.

Before:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0 MAC 00:00:00:00:00:00, spoof checking off, link-state disable,
trust off, query_rss off
...
After with iproute2 patch[0]
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0     link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
checking off, link-state disable, trust off, query_rss off

[0]: https://patchwork.kernel.org/patch/10997111/

v1->v2: just copy an address without modifing ifla_vf_mac
v2->v3: update the changelog
v3->v4: update the changelog: add a link to the patch for iproute2

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9b5e11d3fb85..04ea7db08e87 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1998,6 +1998,7 @@ static int ipoib_get_vf_config(struct net_device *dev, int vf,
 		return err;
 
 	ivf->vf = vf;
+	memcpy(ivf->mac, dev->dev_addr, dev->addr_len);
 
 	return 0;
 }
-- 
2.12.3

