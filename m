Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487484818FF
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbhL3Dkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhL3Dkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 22:40:39 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F8CC061574;
        Wed, 29 Dec 2021 19:40:38 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u16so17326253plg.9;
        Wed, 29 Dec 2021 19:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :mime-version:content-transfer-encoding;
        bh=AjLyuNsjSkcxBsI7bCMuvwVvw4Y0qlQatpuvIXcy3Kk=;
        b=crCMEm7NDXpTQioGzoQieK0UTcMozv4itUqcHdavgIyIEBTaXYt7B7BRKajIsuRsVy
         GWKWOgdgLDW2farUuRGsSVr7LUsPh68X2TKqJwxacUE3109syDWvsBQSrRS/KknmvSnl
         dCvVXo35Dx1vuV31SmSr2Gp3jN5r/ky8oQHigCx96fjhyNI6AKnXYYfQfFROiRJ31OQg
         EBkitECO30kPC9YT6h2AzX0dkZYuGoWcX75QeIWM7yack12IgwDaGNpt8/sJsIZ9UBUg
         VNXsQWlaTqmRcOjIOwSb1FcSkUfF9aRB3rykrcRsMi4KarcP+y9mPNM/b6wsgDyCIpso
         4voA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:mime-version:content-transfer-encoding;
        bh=AjLyuNsjSkcxBsI7bCMuvwVvw4Y0qlQatpuvIXcy3Kk=;
        b=WwIyfC7msEkyDYuhYpb8PZSWO3B8Y8biKE/D1fgiIq4HnKLYzcIfP98737XRZ17gj7
         DSOqNeRxKmlO2OYrHPutTufjRzK7r/XCy6B0WDX6uFVYnDKONFdE68nT64Uocr5/9Avj
         TSki7oC6izIId/urvs7pyty9j9NGbXGGxOFnNCMbjvSPD3GbPetV9PTtVKde0osliuMJ
         Ret9V9ftwfg1E82YLP5Gon6G9BDS5aTpDkSVI2PI9OHfLyHjsQAz0sNUblcT//kvS/3N
         kYLTINoIh8WydYryvfIHJYYWlBquY2D8oczg741R9ymA2sHaQ1221jAbQTKCWeDpVLES
         4dMg==
X-Gm-Message-State: AOAM531r8nWI7KWljOb9rr+C3xUB3HM/2AkRLrsp4SYixd/53ztMIeYx
        y0WRxdjIXMUPCnn8dnQbrSI=
X-Google-Smtp-Source: ABdhPJyOC2DzOzyuHQGzjTa521Jkf/8vNZ41bG2ZTK6xK9zW559ZYUl/yipl8Z2wqzLPfLIKgrgTBg==
X-Received: by 2002:a17:902:ee52:b0:149:60fd:3358 with SMTP id 18-20020a170902ee5200b0014960fd3358mr25276107plo.6.1640835638112;
        Wed, 29 Dec 2021 19:40:38 -0800 (PST)
Received: from [30.135.82.251] ([23.98.35.75])
        by smtp.gmail.com with ESMTPSA id h5sm20060951pjc.27.2021.12.29.19.40.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Dec 2021 19:40:37 -0800 (PST)
User-Agent: Microsoft-MacOutlook/16.56.21121100
Date:   Thu, 30 Dec 2021 11:40:33 +0800
Subject: [Resource Leak] Missing closing files in tools/bpf/bpf_asm.c
From:   Ryan Cai <ycaibb@gmail.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <ADAFDE41-E3FC-4D96-A8D8-1DAEC56211E9@gmail.com>
Thread-Topic: [Resource Leak] Missing closing files in tools/bpf/bpf_asm.c
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kernel maintainers,
              1. In tools/bpf/bpf_asm.c, the file opened at Line 40 may not closed within the function?
              Location: https://github.com/torvalds/linux/blob/5bfc75d92efd494db37f5c4c173d3639d4772966/tools/bpf/bpf_asm.c#L40-L49
 
              Should it be a bug? I can send patches for these.
 
Best,
Ryan


