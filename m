Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD8D22D4FB
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 06:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGYEoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 00:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGYEoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 00:44:11 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0305C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:44:10 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x9so5625647plr.2
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mqpL2IkD7U0yjOoMM4/u6ETisC0E6D383nLDj70DidY=;
        b=bsnRqk7yA/YMeDLGPohxbBJoZF5Ww/A32ndx5H39sPvU6FcpdIdYixdSrUZ47Q9h0j
         mrv1RUUPc+HFgIBCvr3vsRSJvGnDA3tnrRGp46kBnQTeQozhLY0+aEFXbp6dClVjnAhb
         usgSPBPGXJ04gKntjRoDXOwZnbxOvUTB4lYahKQiAZmW5sf6v7vrjb+c5gmc1dDAGuUc
         6yj4EZSEAvfPLzwNw7iUeG8lbeTr/ZGW9cgcpF2XD2JIz4T2EFu/61mQmBZhhsSZNJR+
         ZJe2NNpp/EdFalWMmb1tGg7kcS6/QBVIs3mrmygvOsh6txavZ5iTCn7E06SA/5fP630x
         NOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mqpL2IkD7U0yjOoMM4/u6ETisC0E6D383nLDj70DidY=;
        b=CJxlhk264FUUQ9CAjSU4/tLOZt2gIXGjdUHFdIMYJmHrEnplWLXRFlHFFSixaHOOCg
         vl4eM0W8j2vqLUAP4hIol9Xjd7LgUInBFQ8RkeTOj9kQfm1W/cM81GK5sy+Vy7W4l+o+
         h4m+3y5E3M46eND/U9gnNU+kZcf3NSJbKHBuWByPReouuV4oVma4G1jGHYTPSCoAWcMV
         8/4Hjr9c0TH0s5OHbfqRCr7cVNoFBm3CEdDnhIZK+BiIWw657THn7UMSrbz8DzywFaAm
         qwGV7eKgrugik1ijP5tZ05z8AKvpOmOmot7APNxQVUCWdsI432LszvpMGpt/nfFmiuA7
         0AAQ==
X-Gm-Message-State: AOAM5327WJJU9RuYlNWq+Xw0FDuairU0hMpIlaRoXIecocMxyXmLVEbG
        LhlLjHH377PaJrAFWylgjFA=
X-Google-Smtp-Source: ABdhPJwpxYvSjF6arg53EYtCRog0/62/COBSLcuGrw1D6hY0YRhpC/mNO6g01Ajzieo9fMKPx/Nf5g==
X-Received: by 2002:a17:90b:f11:: with SMTP id br17mr8641870pjb.158.1595652250248;
        Fri, 24 Jul 2020 21:44:10 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id e18sm7906618pff.37.2020.07.24.21.44.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 21:44:09 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     sgoutham@marvell.com, sbhatta@marvell.com
Subject: [PATCH net v2 0/3] Fix bugs in Octeontx2 netdev driver
Date:   Sat, 25 Jul 2020 10:13:51 +0530
Message-Id: <1595652234-29834-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Hi,

There are problems in the existing Octeontx2
netdev drivers like missing cancel_work for the
reset task, missing lock in reset task and
missing unergister_netdev in driver remove.
This patch set fixes the above problems.

Thanks,
Sundeep


Subbaraya Sundeep (3):
  octeontx2-pf: Fix reset_task bugs
  octeontx2-pf: cancel reset_task work
  octeontx2-pf: Unregister netdev at driver remove

 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 3 +++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 ++
 2 files changed, 5 insertions(+)

-- 
2.7.4

