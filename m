Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D323DC3EA
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 08:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhGaGY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 02:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhGaGY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 02:24:59 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643C3C06175F;
        Fri, 30 Jul 2021 23:24:52 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso23954651pjq.2;
        Fri, 30 Jul 2021 23:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=0J1QVKkgklkLICVrzPaGGde/KCg/fKpr9RDO1P2Thlo=;
        b=AwWlPYuWWGW8RQoZiUmLo0psAaRuXuU52lVTG5wcJcOmWv/rGX7ds9lHDUZ9cpOTI4
         B8QBiwAnazRH0nAdKJPxtRUmMzJ1GkzmIw+jeDEgHrOkROoZIZnND8kdmcilqz3+mDbK
         rjIWpgqo+e/SVb4d+2k+V1sH6xU8FdCHRyu4ZEPCdai8u6nukm9wrI481PUZg1mt9OyG
         ZG8WDuQNtHA0QmerO60xx3K4y2OQ3JGmxgZ6feX04YViLMByJuSeemU1NnUHJSErBS5t
         sIvmX4Ad+dK7FZgjTtHhAJsPEB6apjsKDcJeXRLr79OIZzWyuKcOijcOUzdMh7gQo2oE
         2eAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=0J1QVKkgklkLICVrzPaGGde/KCg/fKpr9RDO1P2Thlo=;
        b=Wt4gMNrJn+iXERFlTaJF7SvD4jNUG4B3U0xyZHIAyIoyabE51UbDpMhQbOhdU/j74d
         haeo4dL2H97CMcUsme3rTyImPpMha6GVUbcTcKarANZI07eCUAg2jFgLixn0/L4hgf5f
         LXadS0GaeJqEZv9TIRXDVE4vGLQaJYF9r/Mp/hW1Pr5XMQl3FotHDJUomwWIq6NGNDiI
         DsMWcK9u5qURWEduf37eH/KbwvCGS3fjp9bhkqB58MhOZZMdbqpPlYpe6r8OZEhpRTG6
         dktjVbqzyAfCstCIDz4HN0ipeNG8io73I+7hV1ERgE+cH8+lexALaowCWdi+PueTt0jS
         O5vw==
X-Gm-Message-State: AOAM530fdOXR3gBkJB17xhV98M6wC0C+o6BCXmDLnsnZyYclMGm59VfU
        athzWMeyRy69IKv/URZzSWcTeDHZOCN2bQ==
X-Google-Smtp-Source: ABdhPJzxrdXdE9E7hmpkhu23mqihI+pu5eI/wOTuzqNi79CknSao9sAiidTY3OyITvR4GXPzO8HOxg==
X-Received: by 2002:a17:902:8c83:b029:11b:3f49:f88c with SMTP id t3-20020a1709028c83b029011b3f49f88cmr5611075plo.63.1627712691761;
        Fri, 30 Jul 2021 23:24:51 -0700 (PDT)
Received: from [10.106.0.50] ([45.135.186.29])
        by smtp.gmail.com with ESMTPSA id e12sm5206397pgv.51.2021.07.30.23.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 23:24:51 -0700 (PDT)
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Li Tuo <islituo@gmail.com>
Subject: [BUG] atm: firestream: possible uninitialized-variable access in
 fs_open()
Message-ID: <c83abdb6-440e-3fff-b7d8-f70d89343be9@gmail.com>
Date:   Sat, 31 Jul 2021 14:24:48 +0800
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

Our static analysis tool finds a possible uninitialized-variable access 
in the firestream driver in Linux 5.14.0-rc3:

In the function fs_open(), a memory block is allocated through 
kmalloc(), and its return value is assigned to the pointer vcc.
883:    vcc = kmalloc(sizeof(struct fs_vcc), GFP_KERNEL);

If the following condition is false, vcc->channo will remain uninitialized.
898:    if (!test_bit(ATM_VF_PARTIAL, &atm_vcc->flags))

However, it is accessed in some statements such as:
1036:    submit_command (... , QE_CMD_CONFIG_TX | QE_CMD_IMM_INQ | 
vcc->channo, ...);
1040:    submit_command (... , QE_CMD_TX_EN | QE_CMD_IMM_INQ | 
vcc->channo, ...);
1043:    set_bit (vcc->channo, dev->tx_inuse);
1047:    dev->atm_vccs[vcc->channo] = atm_vcc;
1057:    dev->atm_vccs[vcc->channo] = NULL;
1065:    submit_command (... , QE_CMD_CONFIG_RX | QE_CMD_IMM_INQ | 
vcc->channo, ...);
1072:    submit_command (... , QE_CMD_CONFIG_RX | QE_CMD_IMM_INQ | 
vcc->channo, ...);
1085:    submit_command (... , QE_CMD_RX_EN | QE_CMD_IMM_INQ | 
vcc->channo, ...);

I am not quite sure whether this possible uninitialized-variable access 
is real and how to fix it if it is real.
Any feedback would be appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Tuo Li
