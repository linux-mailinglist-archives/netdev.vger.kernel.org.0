Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC6630EF45
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 10:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhBDJK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 04:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234475AbhBDJDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 04:03:15 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B334C0613D6;
        Thu,  4 Feb 2021 01:02:35 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id r23so578939ljh.1;
        Thu, 04 Feb 2021 01:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/TSLfTImrRe23/NrG2l7vYhOdNAwie8O/O5xzxImUdU=;
        b=aG7+gHoq99GRCPDOwzPcfhr8S30YhEU4o8OfSI3+lqtqJizRr+J4xUM03W/Zpow0Up
         wtp+D2JmFy9cydwabTgGXXL6H2Hcd1dsHJpz3KOVhheLHGHZpyeqErMXCppLckjb8mcV
         VOLfdfVSkhCNSzP3g5RobY+5ANGIyj7+iecEXo+PENz83Yt4YPPMVNcy9owZqL62iIs7
         fNyUSMnuaOLCJrfn3+Jhz64W2Cj/NqxX5Vm/9RNe7boHVI2ph1e1Vxz2y+TAsret2gBj
         8wbppLU/33jziFOhjSigLtGHH1FxiYhV/dyL1EJRvdk692+1hUfH6fUQWk6K8eJs+xan
         K8aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/TSLfTImrRe23/NrG2l7vYhOdNAwie8O/O5xzxImUdU=;
        b=acs8yaJWrR7QY+ey6mJ9WDhHwnF/PBIkdTQeDdF87Bs4p047aDFddFwS0NStKwW7Ws
         Esa0ZJDiq6ZV21eMeZQkFYM7YsHmoqNjRhK+zO6IH2KEyUxelVlu8/U2+T4/ldsOm2G6
         /7jGZgLVfBVSNMKLTmB4oP2fjdxLLXWQ2SHZfGWZkeRUdbdQBffUQ0GNNSkGDMDuB/Tu
         /1t8QQ09euulZ+gF98WzpxyFiyR+Tn9S1aYOQo/FK0FTp8QF5rFDcpevAInX+mLz8KhU
         ZkwO1Q0MFpSxo+wiu0XergvAir16W0SArLVA59OZptS36Lz4cqlJ0J665geKxTaxFeRt
         GSkw==
X-Gm-Message-State: AOAM532TeEQ52oLAKPebnIhsfK0CLcI1pIqPFiT37v5y0h0C6TLLyxPj
        kDLMU/2SpMrg7ECQF4AydrU=
X-Google-Smtp-Source: ABdhPJxdCYKvUeTjW+84dAsnfdjxULW94PrUvOI4idUHZpRhBUNMIF77CoMBIjMEMqNeF43srEasYg==
X-Received: by 2002:a2e:7a18:: with SMTP id v24mr4132393ljc.55.1612429353981;
        Thu, 04 Feb 2021 01:02:33 -0800 (PST)
Received: from localhost.localdomain ([146.158.65.224])
        by smtp.googlemail.com with ESMTPSA id m78sm533479lfa.270.2021.02.04.01.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 01:02:33 -0800 (PST)
From:   Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, snovitoll@gmail.com,
        syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
Subject: [PATCH] net/qrtr: replaced useless kzalloc with kmalloc in qrtr_tun_write_iter()
Date:   Thu,  4 Feb 2021 15:02:30 +0600
Message-Id: <20210204090230.1794169-1-snovitoll@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203162846.56a90288@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210203162846.56a90288@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replaced kzalloc() with kmalloc(), there is no need for zeroed-out
memory for simple void *kbuf.

>For potential, separate clean up - this is followed 
>by copy_from_iter_full(len) kzalloc() can probably 
>be replaced by kmalloc()?
>
>>  	if (!kbuf)
>>  		return -ENOMEM;

Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 net/qrtr/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
index b238c40a9984..9b607c7614de 100644
--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -86,7 +86,7 @@ static ssize_t qrtr_tun_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (len > KMALLOC_MAX_SIZE)
 		return -ENOMEM;
 
-	kbuf = kzalloc(len, GFP_KERNEL);
+	kbuf = kmalloc(len, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
 
-- 
2.25.1

