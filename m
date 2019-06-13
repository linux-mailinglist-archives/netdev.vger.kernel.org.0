Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9DC4382A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732805AbfFMPD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:03:56 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44522 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732481AbfFMOUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 10:20:11 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so31431936edr.11
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 07:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=WwF+R4Lrs6HkJMUvOOkA/vlqjdor9u8SE8zxnPHP64g=;
        b=YlW4j9MiK43UaPPNp3NcnSbwoouWOaR5Tt1J1uSyLaCtOSGU7wNQkYQ+u36ShXbFgs
         4jix3t87R4H4jdPR/24G35HTJrWTFACeaeQwwZ9fhwg9W0NT639UwqePoagPMrQXXsse
         hMHFWTHYO/E9uSyRcEFVRmvfAQ/Z5bqeX2pPTp5u35qTiNBmpqSemN8n5lwhvQz2uvBY
         UagS8DRqx6+RRfq716VVrujv85WVXDDpLCavczHzVPRM9V26garys8KQBywm0+Ff9pOt
         M+1b5Y1YoFH9A6u1DrbvmM8aKxrKQZxUdqu1VzO070TNGOFjFhzXe8kalXYX3YACcIkK
         l08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WwF+R4Lrs6HkJMUvOOkA/vlqjdor9u8SE8zxnPHP64g=;
        b=ShOzBe59Lgda+m11JDm3D62SHlrI9B9ssiZRup2BVTl1iBmaAtt8PiXOqxPMg80XA2
         hfyIE8s9OwXvUvvzQTZMPcNhDm/hBVQ0wkJjQBu5KXsVwCC97aXpnd4hXvdPjEB5GzoX
         WD2iV/U5O/QwQ+8sXvWulsDL4hTjYGV53n34RuflwuRKE7HnZzxor8VGYUchMYhVq4KK
         WeKTQoIyf4dO5WI0SeaaqIXcELiCBMrFWFCBVBxllCKhL8+im2DI9UoGOdLLXFV8uE2d
         iA4+fMtNE5dxW8BTsWgsDiNlShXI3D9ZQAd9Xm2VfmqsTpvuGsJu0vIn1mIZE/1NwiSP
         rrZw==
X-Gm-Message-State: APjAAAWRp075aB3LYxGI1gs1LlsUsx3lGdbQszYlBi/cYQLGCBcUjQB2
        ottKLVLtLta/2/4jt3XbNltdHw==
X-Google-Smtp-Source: APXvYqwO9PywANz7atN1rsYR8nc0F1gYU6Knxg6dvs1rRl85CPqOVEmsFwigyaGm9ONRLxA9TcuExA==
X-Received: by 2002:a50:cb04:: with SMTP id g4mr83562162edi.181.1560435609787;
        Thu, 13 Jun 2019 07:20:09 -0700 (PDT)
Received: from tegmen.arch.suse.de (charybdis-ext.suse.de. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id s57sm931939edd.54.2019.06.13.07.20.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 13 Jun 2019 07:20:09 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     davem@davemloft.net, dledford@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH 1/2] ipoib: correcly show a VF hardware address
Date:   Thu, 13 Jun 2019 16:20:00 +0200
Message-Id: <20190613142003.129391-1-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in the case of IPoIB with SRIOV enabled hardware
ip link show command incorrecly prints
0 instead of a VF hardware address. To correcly print the address
add a new field to specify an address length.

Before:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0 MAC 00:00:00:00:00:00, spoof checking off, link-state disable,
trust off, query_rss off
...
After:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0     link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
checking off, link-state disable, trust off, query_rss off

v1->v2: just copy an address without modifing ifla_vf_mac

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

