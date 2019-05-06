Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4526615418
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 21:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfEFTAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 15:00:16 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:51266 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfEFTAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 15:00:15 -0400
Received: by mail-it1-f196.google.com with SMTP id s3so9925715itk.1
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 12:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HLzd5SFscSjrDrCjhPj5uaWITAhh+zmbDPjUhQ8RDqU=;
        b=ggRVGIPnDFt73BJZflqsSDzwWRgmqJZHqGfAg+2l5tnVY8U3UWKK5cfZkyEn/seUKj
         95Nyi3A5fe3HGO5/Jy5KBLHI9QucxbHRzLJLAZ//Ed0Z17jHZZUqypfSSEw3SvkOcfi/
         gJoAJsyFwRwysCkZwxpwXdG/czLaV0UA6g8dSkNcazwi8k7+vbDX/z2QBc8dGR6xrzsR
         lD5LoSEhUo6zOgbfu83Yv2MpZnWsnFvKkHMlk6NxysUdoFVbPhtgNOHyfb0cDSFpRXOZ
         ZsoINfw74/NhNqKDK0Q1nWC9lzTfIBh6Cfca98rJbvjahkezMGDtTQ3BaIoWfO6b2fkM
         S8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HLzd5SFscSjrDrCjhPj5uaWITAhh+zmbDPjUhQ8RDqU=;
        b=GhCx/Bk8P2xpSr/Ihlx4Y/N6MWSaO9RpJaZ67OSqIk8IC1wOkX8pOsEMzGc/AcsiNs
         FF/+NRIxKYZWDClHhLmytgmanP70NyyJ5dgXDaQuApnGbKZkvpg6vn+1Ag04hfq9I094
         33W2irnmxppkRnF6VNeJ5TwzHRRK3izsfHMZ0xKUXAWrDjF1gHQVuV76hMnPYrQruVMf
         dja21ZgzlY4bLRzgFGPAscmvJuVn4c9DKgFobnL4dja3JH1clb2o3DOy8kd6Cc4gjrm0
         mp0f/Zc7rfrJAN7d5ZToxJPHEgTm1AQIsE3w/kFYr++w9id3+BgJrzFUcF9ASzfRh44O
         rkUg==
X-Gm-Message-State: APjAAAXhezPiL9Ao3PhXRVPetYOrK/bdF2RWLiO6/cW/1HpxQufrHwzi
        QLKNDKYEHSmITiKJs3iLQZMDPT0=
X-Google-Smtp-Source: APXvYqzoX9m41CbIWNdEZj5aNOqlzC+ETUuHvfnku0HANq9IzZAZyrGNhotdqrH6c3Gu8AQA0TipQQ==
X-Received: by 2002:a02:7410:: with SMTP id o16mr19439568jac.87.1557169214120;
        Mon, 06 May 2019 12:00:14 -0700 (PDT)
Received: from ubuntu.extremenetworks.com ([12.38.14.10])
        by smtp.gmail.com with ESMTPSA id c21sm2406290ioi.14.2019.05.06.12.00.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 12:00:13 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net] vrf: sit mtu should not be updated when vrf netdev is the link
Date:   Mon,  6 May 2019 15:00:01 -0400
Message-Id: <20190506190001.6567-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VRF netdev mtu isn't typically set and have an mtu of 65536. When the
link of a tunnel is set, the tunnel mtu is changed from 1480 to the link
mtu minus tunnel header. In the case of VRF netdev is the link, then the
tunnel mtu becomes 65516. So, fix it by not setting the tunnel mtu in
this case.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 net/ipv6/sit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index b2109b74857d..971d60bf9640 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1084,7 +1084,7 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 	if (!tdev && tunnel->parms.link)
 		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
 
-	if (tdev) {
+	if (tdev && !netif_is_l3_master(tdev)) {
 		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 
 		dev->hard_header_len = tdev->hard_header_len + sizeof(struct iphdr);
-- 
2.17.1

