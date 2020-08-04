Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE2F23B26B
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgHDBne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbgHDBnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:43:33 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF8BC06174A;
        Mon,  3 Aug 2020 18:43:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s15so9682149pgc.8;
        Mon, 03 Aug 2020 18:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UYIgsFrNPPhMCYJ23fMrg1YVDSPjRtE8skKBO2jSpIM=;
        b=QepAHo2wyBuH1Zq6QTrRz8xOWBmq4OSK4bPGW9tEHC+xRUZFe4A3RePjY042+TwyEp
         PsLanhCY7G2+wasqzZ/HED/RWkczqqDlyZ+eLS0faNar8y8AWeo2HGYRsIe6aIUmQUm/
         4eZNj5hgNq1t7+4qcL5Ve485hiAabOmgyIrghsIpIa/GJwcvaPVgHrt9EkGzNZaLPE8f
         7ZlyH1oROUL8Xa1AMCPeCfG5I/VY5wHEew4EuEZZak+f01D18TRpsBd76c4o65dBjW9o
         k8Y3EWNPDti/wuwr+7vzupDj/Fq2TOcAF+/9EvqlrivKMOpHbDZBTbGZX74pclQVTvtT
         GJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UYIgsFrNPPhMCYJ23fMrg1YVDSPjRtE8skKBO2jSpIM=;
        b=mPy2WiYsvRNBuhcAVKfWj2J2nLlQTlHojHwTFrbOHvQ3XDoWFY85b4Pesi9S/N32K4
         aD2ib+sLvTxbSMUeGqhVHSYez7X54fWfpYWe0SpeC3BLljinGErLBFy6qQ883ZqK02SN
         Cbk/UCwShZor6J3GQT2cXR3zkvDdJRD87dI+qKOMG+8KdOzf7w0pUCCKN49yZ+W+rgQV
         IHdT5s/09PqVDfUUu7TQOkULfZ6fHKBPaXOhYl55nHivcYJ4LveWnqMqsOOg1vQjR4Xx
         KdFDYzcmPV9PD2B8CSW52NqebZPPl2DqkgPh5FAZrHSSNwSJ8AiIgilIU2q5M2XO9hYp
         JEnw==
X-Gm-Message-State: AOAM532D/eNhe28LaW0qgEG/UE8XAz8w7mEF7q/Rb0ep2IKx4Pw5frPk
        FQYt4UbcA4U17pBrX/AJNyxLG4EF4znHxg==
X-Google-Smtp-Source: ABdhPJyD9bSoMqDbejgGliOlCgOw0EeSw5C8TCE266FtFUj6WhtffPanbhdzxp3fFdOSKHSEWYK2EQ==
X-Received: by 2002:a63:5b55:: with SMTP id l21mr17841040pgm.348.1596505413084;
        Mon, 03 Aug 2020 18:43:33 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p127sm20473494pfb.17.2020.08.03.18.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 18:43:32 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Andreas Karis <akaris@redhat.com>, stable@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 0/2] Add IP_DSCP_MASK and fix vxlan tos value before xmit
Date:   Tue,  4 Aug 2020 09:43:10 +0800
Message-Id: <20200804014312.549760-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200803080217.391850-1-liuhangbin@gmail.com>
References: <20200803080217.391850-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is aim to update the old IP_TOS_MASK to new IP_DSCP_MASK
as tos value has been obsoleted for a long time. But to make sure we don't
break any existing behaviour, we can't just replease all IP_TOS_MASK
to new IP_DSCP_MASK.

So let's update it case by case. The first issue we will fix is that vxlan
is unable to take the first 3 bits from DSCP field before xmit. Use the
new RT_DSCP() would resolve this.

v2: Remove IP_DSCP() definition as it's duplicated with RT_DSCP().
    Post the patch to net instead of net-next as we need fix the vxlan issue

Hangbin Liu (2):
  net: add IP_DSCP_MASK
  vxlan: fix getting tos value from DSCP field

 drivers/net/vxlan.c           | 4 ++--
 include/uapi/linux/in_route.h | 1 +
 include/uapi/linux/ip.h       | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.25.4

