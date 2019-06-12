Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91F04240D
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 13:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409013AbfFLLd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 07:33:58 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46590 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406355AbfFLLd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 07:33:57 -0400
Received: by mail-ed1-f68.google.com with SMTP id d4so1871953edr.13
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 04:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TsABUyr6czjxkgVPVlQz/+LV8vXRq4YLo2VkQCGdbrI=;
        b=aRcMzt/DiOaPSx7zsRGguao3JcN6luewaLiYoXTY/Tid7U/gioJSfzG7aqvCIglu+S
         MhSm1avGDRO0qVyfwdNXAzxJFbJuN44Ha/NDEnxe6Uqy/469wHTViOcMPGzSkwWDCZVH
         M4gVn+PdROOGHU6/WhhN2UketiJkSwvApE2jAU8xvr0xtzr5Oa7KRmOACHyJVIHsvONA
         FETc6mrPGQNW8bxaeGVU8WQdGX7ZSnZjhmGkKQSVK97FZDZxPrNu/mHh1yR4sDo6k7Zc
         mW1R+ictO0vWOl5vyT9rTsG7g9ShYy8sBz9CoI7+vwCg3kc+CxsPq/jgdp/WjMResQee
         omAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TsABUyr6czjxkgVPVlQz/+LV8vXRq4YLo2VkQCGdbrI=;
        b=Qi2XqTDkSI/cQFh/BuPIswAp+tXyqwbgppdCeqsrjoF4Dtd7aVKXjuGUgAglO4sBA/
         a1kWlFZa3gKuiiKORgjJ0SG//84LGAiBjkJVB9oYjQdo3piXrL4i+Tpdpo0lZ6LO97kz
         LS3Qhvd4bFIBtauQonaBDRFQD6fx0mxlw26xxPOFPjffU6Fk7nYRpGA6BZols55Wzuji
         G3fVMzo2Zt75g4gomLtB16kmN/3/rnJQwgwncECpUJVUof822d8AP5sGhU5olEynACbI
         KtYi0C6tcCfsQbGrZrSM/o6ZR8phkJlH9RHEyqjwqIAOw8tn/IAFSyNPx+1fRzRhhx9S
         619g==
X-Gm-Message-State: APjAAAUE5VPP8P7lkiyDjBq/O7//o6oTkJPXVeBGUBXDKWtGgoD1Qh53
        7TbeaYWKUCeriJkKCRY3PkKS0O5cVBnYmA==
X-Google-Smtp-Source: APXvYqyUXzAFkZpGpzj35SrPGn+8SbHQ03MMgRfmsKa25zTAeRMgrlFeacBw13d3yMBeAAVpr26CRQ==
X-Received: by 2002:a17:906:4948:: with SMTP id f8mr22533651ejt.79.1560339235927;
        Wed, 12 Jun 2019 04:33:55 -0700 (PDT)
Received: from tegmen.arch.suse.de (charybdis-ext.suse.de. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id i21sm2752934ejd.76.2019.06.12.04.33.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 04:33:55 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     davem@davemloft.net, dledford@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH net-next 1/2] ipoib: correcly show a VF hardware address
Date:   Wed, 12 Jun 2019 13:33:47 +0200
Message-Id: <20190612113348.59858-3-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20190612113348.59858-1-dkirjanov@suse.com>
References: <20190612113348.59858-1-dkirjanov@suse.com>
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
...

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
 include/uapi/linux/if_link.h              | 1 +
 net/core/rtnetlink.c                      | 1 +
 3 files changed, 3 insertions(+)

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
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5b225ff63b48..904ee1a7330b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -702,6 +702,7 @@ enum {
 struct ifla_vf_mac {
 	__u32 vf;
 	__u8 mac[32]; /* MAX_ADDR_LEN */
+	__u8 addr_len;
 };
 
 struct ifla_vf_vlan {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index cec60583931f..2e1b9ffbe602 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1230,6 +1230,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		vf_rss_query_en.vf =
 		vf_trust.vf = ivi.vf;
 
+	vf_mac.addr_len = dev->addr_len;
 	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
 	vf_vlan.vlan = ivi.vlan;
 	vf_vlan.qos = ivi.qos;
-- 
2.12.3

