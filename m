Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6EB33E2DB
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhCQAgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhCQAgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:36:04 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7D0C06174A;
        Tue, 16 Mar 2021 17:35:53 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 16so17331033pgo.13;
        Tue, 16 Mar 2021 17:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QDip3SzBtHzcBDdUiV2HefgqfnF/uiPbWhDoegjjzjs=;
        b=U1oRg+lgWozXtxGxSLYAWo57Jao8dAAw0GvDtmeY2FQfTfBXGh75mTW5glhD4lDVOG
         9PPhB6dihOrHiiPfAxDVdZovmc+fXV0fgg7OFE/T+QRdjmYRITvKbyQJ36r+n8+qSr4E
         A6nQ6feR3P4DDe2OQx67UZ+hSFztxSOBku1hx2naxIrUS/7kl+iB5aQT43T5DDWsKrt5
         OTa925SETzr1OWJvHwva4uLwBZLJ7TSICeTuSBzbwlcvKNRz1TsJMbql3KpPALROsIuA
         jp6uOy689J275NMDt/C2Ip5ItluzWSSqrdJ7JPPANRmfUEO4VfQcpy/MMYEeTSW2voYw
         6cBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QDip3SzBtHzcBDdUiV2HefgqfnF/uiPbWhDoegjjzjs=;
        b=MngxIp8FPAv/VoPfzNrAyFiBT3n+4wF9AX2a38DJ81PcEAC/2luC/vU1Rnpep+oFGY
         57WlkP08a7lIHLaxFeWqCob47rQuOg1S4dduy973WQ5PID/6hIDYRzZpXb7pCTf13WQe
         mlA7aBgTPeE42TsHVa3TWfviq0lq7+bFtxouNzsn1OqowVdb9RkdWz4BLT8sZ4NFIVG+
         hHQENiHkVlnpwr64G7LRIQQh6sfa4fvp6OUxMHwflw+Jsr8ko/GKe2UrbuczzeRAhsmi
         tZd3nU7aURJkFLELCAs1d4yCRRzchSjzh3Wnt7mvFwrOyWeKaTD8z68NXZiLPGtx/4hu
         hdwg==
X-Gm-Message-State: AOAM530Lg7ipK2pDvVwqMv5cAebHgYC0O804IOn1pp/1Hfh4YZqhqVYG
        jk5tYwZL9oDhTPt65kdueN8ltL9PppY=
X-Google-Smtp-Source: ABdhPJxHDVLlyo+nnwRrrS/KdYlyUzATX7Pd+M+m0InfH7zfC9TNwryqK0lLHTVpoZJfsXCUM3z4kA==
X-Received: by 2002:a65:6a4b:: with SMTP id o11mr347888pgu.138.1615941352479;
        Tue, 16 Mar 2021 17:35:52 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k63sm18796512pfd.48.2021.03.16.17.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:35:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list), stable@vger.kernel.org,
        gregkh@linuxfoundation.org, sashal@kernel.org
Subject: [PATCH stable 0/6] net: dsa: b53: Correct learning for standalone ports
Date:   Tue, 16 Mar 2021 17:35:43 -0700
Message-Id: <20210317003549.3964522-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg, Sasha, Jaakub and David,

This patch series contains backports for a change that recently made it
upstream as f9b3827ee66cfcf297d0acd6ecf33653a5f297ef ("net: dsa: b53:
Support setting learning on port") however that commit depends on
infrastructure that landed in v5.12-rc1.

The way this was fixed in the netdev group's net tree is slightly
different from how it should be backported to stable trees which is why
you will find a patch for each branch in the thread started by this
cover letter. The commit used as a Fixes: base dates back from when the
driver was first introduced into the tree since this should have been
fixed from day one ideally.

Let me know if this does not apply for some reason. The changes from 4.9
through 4.19 are nearly identical and then from 5.4 through 5.11 are
about the same.

Thank you very much!
-- 
2.25.1

