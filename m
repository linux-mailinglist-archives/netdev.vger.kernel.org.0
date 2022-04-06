Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB324F5F6B
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiDFNSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbiDFNSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:18:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CBCF612667
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 02:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649238909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ybPMGpSVgGbhE0vIjl+GYydz1+5CdicGEBsupFU3sOg=;
        b=E925UgEZqoOOyVbsYt01Oa574ilB7mx/pDxR75PpXBXa3cOwmBk3yy/DcTiLJd17sxzpeO
        AmyeeOcHhOS9EQFWGIZIXzcpgf3ev9Oy8m/hKIv0hUISgHV9+/0t0ZAtNOP3eeIDvaaYlF
        +ZCq3VZ1GhPUWfacPcgE3taP9pxZqH8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-nx9nCfOnOFyTXH4DGXTpYg-1; Wed, 06 Apr 2022 05:37:09 -0400
X-MC-Unique: nx9nCfOnOFyTXH4DGXTpYg-1
Received: by mail-pg1-f197.google.com with SMTP id t204-20020a635fd5000000b0039ba3f42ba0so1175853pgb.13
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 02:37:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ybPMGpSVgGbhE0vIjl+GYydz1+5CdicGEBsupFU3sOg=;
        b=Y2rpfFuIHIOqtXG+7WPHOiWQ1Wo0r/afOo6GPZ3v1gaenP7fYTTXcvofenM6rjUcVx
         HYBiI6vRUrX2z4JfKghIRYsSPSpm3jV79rZbQRgiKp2r0hb2QIX/WVO/ym95Ht0aG4FK
         Yqlo/R8wtI12cz1tyBDS1XST4GH4iEz2GwFpW5iDfGHUi8MxmMXY46drJINSaOhmVD+M
         /7buhqq4UCab9YUCI/mPIAmnvpXGcYU6ry7Pdk8e6AZLmehpGw/OBPiHknTKq4jeQY3R
         4o3tZrvc73RzzKBWQVid/e4bGr80dMgQO4/XTpLJiY32+qJ345kqySKWBA8+Ao0Anu63
         DIxw==
X-Gm-Message-State: AOAM530JiV0WHxcOu9G+Oc4T8ubJtdoB1A4f4cCjvZn13m+653KASfaa
        lAkhC09uq3ObXEBtIafVVu9F8UnmxPojA9MH5uXw/Svr8vGZQcZrIcRSht+EkUU7ftcwM1fbtNn
        Z2t5IRSfEzV5y59Cg1kciRp3H6Gah6erB++zMOb9dFBpXtsRMKyFL/9f08eFCsYkTszhD
X-Received: by 2002:a05:6a00:2386:b0:4fa:e772:ebac with SMTP id f6-20020a056a00238600b004fae772ebacmr8106662pfc.75.1649237827780;
        Wed, 06 Apr 2022 02:37:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWZkCTeZnOkM6UY9by48MAOhnnl1h/ug05QuFfe6g5moX/X4bllYOK2Rm2clXaB9pY0DWAMQ==
X-Received: by 2002:a05:6a00:2386:b0:4fa:e772:ebac with SMTP id f6-20020a056a00238600b004fae772ebacmr8106637pfc.75.1649237827402;
        Wed, 06 Apr 2022 02:37:07 -0700 (PDT)
Received: from fedora19.redhat.com (2403-5804-6c4-aa-7079-8927-5a0f-bb55.ip6.aussiebb.net. [2403:5804:6c4:aa:7079:8927:5a0f:bb55])
        by smtp.gmail.com with ESMTPSA id l18-20020a056a00141200b004f75395b2cesm18407626pfu.150.2022.04.06.02.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 02:37:06 -0700 (PDT)
From:   Ian Wienand <iwienand@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Tom Gundersen <teg@jklm.no>,
        David Herrmann <dh.herrmann@gmail.com>,
        Ian Wienand <iwienand@redhat.com>
Subject: [PATCH v3] net/ethernet : set default assignment identifier to NET_NAME_ENUM
Date:   Wed,  6 Apr 2022 19:36:36 +1000
Message-Id: <20220406093635.1601506-1-iwienand@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405204758.3ebfa82d@kernel.org>
References: <20220405204758.3ebfa82d@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in the original commit 685343fc3ba6 ("net: add
name_assign_type netdev attribute")

  ... when the kernel has given the interface a name using global
  device enumeration based on order of discovery (ethX, wlanY, etc)
  ... are labelled NET_NAME_ENUM.

That describes this case, so set the default for the devices here to
NET_NAME_ENUM.  Current popular network setup tools like systemd use
this only to warn if you're setting static settings on interfaces that
might change, so it is expected this only leads to better user
information, but not changing of interfaces, etc.

Signed-off-by: Ian Wienand <iwienand@redhat.com>
---
 net/ethernet/eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index ebcc812735a4..62b89d6f54fd 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -391,7 +391,7 @@ EXPORT_SYMBOL(ether_setup);
 struct net_device *alloc_etherdev_mqs(int sizeof_priv, unsigned int txqs,
 				      unsigned int rxqs)
 {
-	return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_UNKNOWN,
+	return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_ENUM,
 				ether_setup, txqs, rxqs);
 }
 EXPORT_SYMBOL(alloc_etherdev_mqs);
-- 
2.35.1

