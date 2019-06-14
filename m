Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C1C45E40
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfFNNdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:33:03 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44364 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbfFNNdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:33:01 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so3490534edr.11
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 06:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Xbwbd2FuvWF2sMTKfN6EsRdJUe6Rnva9AqWY64EVH9E=;
        b=mMHAIVILyEzmd/2hn5+xJfuaWVuaRCbm1KKd9XNW43R8/66RbxRFojT5JnpV94eDZ/
         fQSKu3TfymGTALN67az64hyLpO4ImdKPAj43x01M/PmHrKd0AnpdBfEZ3kzoesX1PBx1
         77KszRV35/3k06QTNq3EvJVn2dvSMJNd5zXtd6zEr4kdyd4fgookBDn0hYE3vdEPFBp+
         3/105m0K8hIMoxt1V7ZBJDbASgVGv0kTkZblRbMxVgsW7D1vVX9Y/hQ0jzohY9MWtlbe
         KhM23x/eq2tNiEp8puqkcjzljq787M6ouqySRPOnfO6kM1tNFiW/HcLINt4hs+5WAq+V
         DxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Xbwbd2FuvWF2sMTKfN6EsRdJUe6Rnva9AqWY64EVH9E=;
        b=Uqac+uwGxQ0/rII21Af+vn352yEeKhIKFVa51mhcrmY3wPWfI4K90D9bsvjwxzcwJL
         T0AnZRHfbrhZRiiAyan4OkGTfZtXqUKuOQy8iPsNgjqXPj41dbXCj3nDe18H0lfgxval
         5laZfJtkdu3KcfX3uNLyAuMD6EHy2MR/rjhY11h5bKyL7hjeah9gVIqeI0oNQMxsHSId
         KtBLIPEDQk0kaqLjn8z26SXW7MzCUGg+CbWELL7ETZXuiDgjJxTCBv5tlwmKuFrU1sYq
         b0e2PsJGD+r1c4uAbCRzeqeZ4GJ9rJi8Hv6N6C/9BwuLfub8DSZFBR3v3vHhXQQf5Zl3
         iOuQ==
X-Gm-Message-State: APjAAAX7vh+8ImQMvziYw9q40RJF4SqZBJ+du/flbr7UKrxj19TFuaT5
        RkfWrWjb3dFhKvIvn+01mzdzEn4NKbh++Q==
X-Google-Smtp-Source: APXvYqwIzcn/Ris84AexD3WELkohB8HV5X12s6hJgBc9nrBL0HsswW8UJlrbpqXLMoZRKqj3OOj72A==
X-Received: by 2002:a17:906:4482:: with SMTP id y2mr22534624ejo.201.1560519179364;
        Fri, 14 Jun 2019 06:32:59 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id r11sm320509ejr.57.2019.06.14.06.32.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 14 Jun 2019 06:32:58 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     davem@davemloft.net, dledford@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH net-next v3 1/2] ipoib: correcly show a VF hardware address
Date:   Fri, 14 Jun 2019 15:32:48 +0200
Message-Id: <20190614133249.18308-3-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20190614133249.18308-1-dkirjanov@suse.com>
References: <20190614133249.18308-1-dkirjanov@suse.com>
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
v2->v3: update the changelog

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

