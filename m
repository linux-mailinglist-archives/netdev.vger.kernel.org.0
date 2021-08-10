Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239A03E5C19
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241846AbhHJNqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240192AbhHJNqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:46:39 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E146C0613D3;
        Tue, 10 Aug 2021 06:46:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso5483138pjb.1;
        Tue, 10 Aug 2021 06:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=XFUNA2K8RC/kl0wQXbCSDrKlNYmt5rM3BINLrAhJq1c=;
        b=s6eSd1dzbwC1oLaT5aMLhUtowX+ptX+xsKfsqY4FA/cU7RPoVCwYEann6j3VVIgHm6
         9ggfLdyB0oGZdua8y2TEyXYx0xHNiW/TzPpRXjLK+td4QNoN6g3KJWKZt9c0izJIvXI9
         ROkJnlS3M4YSpAMGiGc7YYBGHVNCxv8RLgYcz7QRym2xgsL7DZebRGo1ygUYJl10F/YK
         PCvfg3AE0VMn7xwVjv7MIPtjxe5mUCPHzcnfaaAQHTc3HvFuiaH5mjLhdTeA05ycpc8C
         R/ZSljpx578YVKD8us6qdkhSZuBukKLTuq9PU0HI+JWt8Kc56hNSj/rC/Ssq7AP2JUQQ
         QRmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=XFUNA2K8RC/kl0wQXbCSDrKlNYmt5rM3BINLrAhJq1c=;
        b=NhOxyLxPnE3rC2Uq0xg0QsTpYzltwXq7Y3SVRtweOroYKEXOMTDN5QKrJel5YLDnQR
         +gYn3+nFYJyr49KbvtPiUoRqmEGlditOCdxQ/RYQpdUvYQHuaIxU81iae4o7rmW7wiHd
         NOUlc1pm3sEgNNfG+TBn731HGkskyrDSy2rmWTi1r3NNEnhMGQX1brgjMdjqhQN3EMNP
         ZMnWfi6bbR4Yarhj/ORvL/1SyU1FAM9YC4/p8M15q0G0XWa3y8zsLY+q+5up+aJ55ixb
         WMQb4MdPM2IX7tdgMqVBYoMZM6UFZhxe2qxUsxs2fQTTfPKf/3ceQx+d+ZWo2eV2hWig
         wkKw==
X-Gm-Message-State: AOAM533xuS/veJY4CjoGOuPWSXP+7fB1UzX6Db9Ty/R55eUW5gdq2VYu
        r9H9m6DTJPMHc/FCVa0T7j0=
X-Google-Smtp-Source: ABdhPJwpeexrI/iUcVe4J3dmfabPO7nLubQ0FfxghPxqL5jwVtDmeY+c3dOrQ9eVBPPX0LAwnoq4Pg==
X-Received: by 2002:aa7:90c9:0:b029:307:49ca:dedd with SMTP id k9-20020aa790c90000b029030749cadeddmr23549200pfk.9.1628603176698;
        Tue, 10 Aug 2021 06:46:16 -0700 (PDT)
Received: from [10.178.0.62] ([85.203.23.37])
        by smtp.gmail.com with ESMTPSA id 129sm19692587pfg.50.2021.08.10.06.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 06:46:16 -0700 (PDT)
To:     john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, baijiaju1990@gmail.com
From:   Tuo Li <islituo@gmail.com>
Subject: [BUG] ipv6: possible null-pointer dereference in ip6_xmit()
Message-ID: <2c434d4d-934f-f8d2-7f1f-af085fcfad26@gmail.com>
Date:   Tue, 10 Aug 2021 21:46:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Our static analysis tool finds a possible null-pointer dereference in 
ip6_output.c in Linux 5.14.0-rc3:

The variable n is checked in:
314:    if (np)

This indicates that it can be NULL. If so, a null-pointer dereference 
will occur
in the called function ip6_autoflowlabel() at Line 320:
252:    if (!np->autoflowlabel_set)

I am not quite sure whether this possible null-pointer dereference is 
real and how to fix it if it is real.
Any feedback would be appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Tuo Li
