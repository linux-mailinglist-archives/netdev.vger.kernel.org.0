Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F52324852
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhBYBJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhBYBJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 20:09:51 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D45C061574;
        Wed, 24 Feb 2021 17:09:11 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id q204so1450597pfq.10;
        Wed, 24 Feb 2021 17:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K+ylZ/A8FURhFeq5ZT6qg+0uXN/hVUfX31ZKJHfA8MY=;
        b=bcthP8Vbm9plI5E3VfP9cGTzVIMvc69QotKx6vYGUmt+4lphbu8Lf6jCIJFNM2X8n9
         O/IKufYaPCeIPA3U1mBP4TWo0HQtMqNRnUUEMZDWqPjmXiCGHCh1b1SU2FEVJOA7V0hy
         4Arze4E26T3HOVnWvosCaB+Kl0c/MqWZ7pH0XarvOFT3r2oBXKJGUYVezMAeJ05eRdnr
         pcyBSZKi7alORs5yolv10d+qdlbLW2x5Vax5ur9gvDVGG86vOjg6l6JOoNFpXsMWorR3
         NaVBmBMBVK/i9a6p+Xw6j0eEmsvBpiqIhEaymId8nxKPqNH4aJ+exE9LDcLwZABdShWr
         kOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K+ylZ/A8FURhFeq5ZT6qg+0uXN/hVUfX31ZKJHfA8MY=;
        b=NMCFlMGU+5dxYVjcWqTHtUgHHZJmPvmup8vnW2EY+ZN6xoF2CE/HDgs91SOF2buMFh
         wCzSBzdCVeVObBDD7vUDA2sVrkbFgooy0Ls55hLtZDo5rrwZtFv1XQG8Yf6yvA3FBG2S
         En9G0Cr8vaNX3PJbdLPVu0KIMtJWGOqUj3a23WcfYS+VcqjfQorxF06b8m5en8l6CngX
         QkXQfCkhomW+bLs0tRgVtQZJNt6HPExpbnDA75THCksXAoo1303q01iJBL7k3lrz2Kd/
         +Wn+kYwmTSa5ft5beMm+Twvmpz/tU8juOjeOb8ChHyuOXee5mxXrtGS/k8XjMcd9LLM4
         HRXw==
X-Gm-Message-State: AOAM53326gF5QKcVN4ZqIEPl08u9I+Do7ETbuJGwUW4u576SiqqRJkyI
        feD/KMGhM/LpLkGR7mTPXLi9CnGCG50=
X-Google-Smtp-Source: ABdhPJwfKcJmbgA0phmVpv5rRuM6IOpUAJVZ+LqCH22yF4XdSlBiO8nICANRoKSwU4RFndBo9FqyBw==
X-Received: by 2002:a05:6a00:847:b029:1b3:b9c3:11fb with SMTP id q7-20020a056a000847b02901b3b9c311fbmr724161pfk.44.1614215350036;
        Wed, 24 Feb 2021 17:09:10 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a23sm4132866pfl.29.2021.02.24.17.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 17:09:09 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <florian.fainelli@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), stable@vger.kernel.org,
        gregkh@linuxfoundation.org, olteanv@gmail.com, sashal@kernel.org
Subject: [PATCH stable 0/8] net: dsa: b53: Correct learning for standalone ports
Date:   Wed, 24 Feb 2021 17:08:53 -0800
Message-Id: <20210225010853.946338-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <florian.fainelli@broadcom.com>

Hi Greg, Sasha, Jaakub and David,

This patch series contains backports for a change that recently made it
upstream as:

commit f3f9be9c58085d11f4448ec199bf49dc2f9b7fb9
Merge: 18755e270666 f9b3827ee66c
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Tue Feb 23 12:23:06 2021 -0800

    Merge branch 'net-dsa-learning-fixes-for-b53-bcm_sf2'

The way this was fixed in the netdev group's net tree is slightly
different from how it should be backported to stable trees which is why
you will find a patch for each branch in the thread started by this
cover letter.

Let me know if this does not apply for some reason. The changes from 4.9
through 4.19 are nearly identical and then from 5.4 through 5.11 are
about the same.

Thank you very much!

-- 
2.25.1

