Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054C34FE286
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355822AbiDLN3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356753AbiDLN2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:28:09 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1D01E3C9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:16 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bg10so37339699ejb.4
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s2jkzw31rfRz/k9DcMuKTznzONYusXn07ORCMc42hSk=;
        b=Y0/saCT3p2F3jNeeNUQ5DmmY/+oty+yJdhMzI8AAkNptlg2goIT2Qmu/8ITBuKDVdC
         50ApMxf6at+JIlhbPnIVG4XRafnh+ts/mU1vy9C+qC260OVZUU5RN7mj5DxDSZJTNM3M
         EE9V0/eH8ulP0vOzQJGYCboCPycaYHDW24gNL4NvK1r5A1FOJ/gkG0kYrbYe7n/PBTrC
         VKnAWiCf04u1ednj5pg0foDHteVpT1R4t6a5l89ekxsqvUNFODYB6odafqzDEKMh1IJr
         hJSjDkemm+2Jd4zwRd861bjh+ipS1RKQQEBLWUXKktX63Nb91LGeVhDNxcI4XADHDelH
         aN/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s2jkzw31rfRz/k9DcMuKTznzONYusXn07ORCMc42hSk=;
        b=rmahCkBB766b+hurzkvP+2m8RLUSLRlpDINiOBncQzSPidcluxUeRXSd0nLFPovziX
         +WVykXGNutMaYHcm2ul9nsTJQoAg0cLtInrBcUciuxBCgyYD3KYxzXoo3WLlCFk6QP/I
         y2h/y0Ho6HC50c4AFNLbac7r8Eym6s/A7VUciAHSPWjLCMyE8iiGE104RRm9Y+H+AE4x
         al4x6G7Py9yQ+mWft870NJ484ReraZqAVAh0STIuwFG4y4IscVZFesW3AoN7wA2dJJbL
         h2XZZ2unhwa6b5fhahHd01+Q+HaL+LVxlneGsEfb/vWI2t2LBChX5nZ1aVoNn/pFYMYr
         7RkA==
X-Gm-Message-State: AOAM53036rirfCVaNqP4F2hrXQ9MXxFG25qisOQnpv+Rf2C3ZXSIWgmz
        6CDLFglm6F/y5+rjyScuiIqlOm0LS+D9Nz+Q
X-Google-Smtp-Source: ABdhPJxymhyozSIwTIWgxQWczj3VDphYNOb83vSG9VlLeBxUFk+AEsKRP/Rlp67MnutbZvwgbjD1fQ==
X-Received: by 2002:a17:907:6d96:b0:6e8:6d68:478 with SMTP id sb22-20020a1709076d9600b006e86d680478mr14479281ejc.331.1649769795132;
        Tue, 12 Apr 2022 06:23:15 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm3771301ejn.204.2022.04.12.06.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:23:14 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v3 6/8] net: rtnetlink: add ndm flags and state mask attributes
Date:   Tue, 12 Apr 2022 16:22:43 +0300
Message-Id: <20220412132245.2148794-7-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412132245.2148794-1-razor@blackwall.org>
References: <20220412132245.2148794-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ndm flags/state masks which will be used for bulk delete filtering.
All of these are used by the bridge and vxlan drivers. Also minimal attr
policy validation is added, it is up to ndo_fdb_del_bulk implementers to
further validate them.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/neighbour.h | 2 ++
 net/core/rtnetlink.c           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index db05fb55055e..39c565e460c7 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -32,6 +32,8 @@ enum {
 	NDA_NH_ID,
 	NDA_FDB_EXT_ATTRS,
 	NDA_FLAGS_EXT,
+	NDA_NDM_STATE_MASK,
+	NDA_NDM_FLAGS_MASK,
 	__NDA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 824963aa57b1..9118523b328f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4170,6 +4170,8 @@ EXPORT_SYMBOL(ndo_dflt_fdb_del);
 static const struct nla_policy fdb_del_bulk_policy[NDA_MAX + 1] = {
 	[NDA_VLAN]	= { .type = NLA_U16 },
 	[NDA_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
+	[NDA_NDM_STATE_MASK]	= { .type = NLA_U16  },
+	[NDA_NDM_FLAGS_MASK]	= { .type = NLA_U8 },
 };
 
 static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.35.1

