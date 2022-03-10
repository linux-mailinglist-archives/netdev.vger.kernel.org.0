Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFBF4D3EFB
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 02:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbiCJByo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 20:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiCJByn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 20:54:43 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45629127D71;
        Wed,  9 Mar 2022 17:53:43 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id z16so3839648pfh.3;
        Wed, 09 Mar 2022 17:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dLb2n0RcDsJQsrbzpWVQ2xqxk5FmoVIUuzbwO80ccoo=;
        b=maI1PORr7yUNN7F+N6qrHT/tZYOhkPl4ZDm+KQKIQZFYcNzAW95ZVwxKv//10DGIl7
         g3o7u+xjnH+lf4EIBJtZ6LZ+4xMBlO5hVj5rSYsl+a/YmxBPhnkhnN6nvNRq6TQR6dib
         mIFWdzquoNNUR4wyy5caPEc3GQp9NjkSGNRhoX6eEwqvwcvdBBUfuC8lGGSuKVg+Jh+n
         R8hyx7WTrHZZZ6HPeWBWYyeXFmQwLZnfLN8T2B3I1Subn4XWYslpqknKhTKTg4m2c8so
         nPtQhQUXjXAY7jye+Sj7yN54pHfdL/5ICrbUzXK781lz8qFvzxIGzcdq+x0oyzZzZNV1
         gZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dLb2n0RcDsJQsrbzpWVQ2xqxk5FmoVIUuzbwO80ccoo=;
        b=mssy/48u5MRx5k4N5kaKPZHW1Jg2x1iUcER/NyxdvRQmZGXVPbL4DR9LpUvlzIeCwA
         OD2uCb8ks/CD1w6wFHG+JjWdpP+1KIXP7QJtOMmj60gzHz4cisiBEVrtFSr57hBrs1RX
         W5zSNT4WOw4otCV9xcLclvHXRmJdRc2pEbuPfLW9ON3e+VpH2xaPix2fbIDkfcFlqW9w
         RaXDuJPK3SuCYtVGkIEk0UrkYCXtjkU+I5yAxv4p1kzBFwq1Dzvu0NFZigZY/aigMOZB
         n89giypcE19tE1YqPoR3u48tlNQn1nhotUY9C14CAykc9tN88HnWuYzvG73EFUKeqPdX
         ZU2Q==
X-Gm-Message-State: AOAM531Jr94IKiQm2bUMwyA5Sf3taI4utyunsgTQ0zv1KT7W1heJwNkh
        hqBU35pMSuiAzQo4ofiNK8Q=
X-Google-Smtp-Source: ABdhPJyumqgNWoQ7hfqeItdHDUxdMX3gau9P7t5NL5NiPUXNs7T98fAdH1ZRgLljOFNhXsVGgyjAvA==
X-Received: by 2002:a63:8049:0:b0:380:b83e:9550 with SMTP id j70-20020a638049000000b00380b83e9550mr2113464pgd.97.1646877222798;
        Wed, 09 Mar 2022 17:53:42 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id w23-20020a627b17000000b004f6cf170070sm4292637pfc.186.2022.03.09.17.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 17:53:42 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH net v2] gianfar: ethtool: Fix refcount leak in gfar_get_ts_info
Date:   Thu, 10 Mar 2022 01:53:13 +0000
Message-Id: <20220310015313.14938-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <e68aa1f1-233f-6e5b-21a6-0443d565ca65@intel.com>
References: <e68aa1f1-233f-6e5b-21a6-0443d565ca65@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The of_find_compatible_node() function returns a node pointer with
refcount incremented, We should use of_node_put() on it when done
Add the missing of_node_put() to release the refcount.

Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index through drvdata")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
changes in v2:
- Fix the subject
---
 drivers/net/ethernet/freescale/gianfar_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index ff756265d58f..9a2c16d69e2c 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1464,6 +1464,7 @@ static int gfar_get_ts_info(struct net_device *dev,
 	ptp_node = of_find_compatible_node(NULL, NULL, "fsl,etsec-ptp");
 	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
+		of_node_put(ptp_node);
 		if (ptp_dev)
 			ptp = platform_get_drvdata(ptp_dev);
 	}
-- 
2.17.1

