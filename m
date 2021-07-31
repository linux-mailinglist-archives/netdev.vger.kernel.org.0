Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3803DC31E
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 06:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhGaENz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 00:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhGaENz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 00:13:55 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9097DC06175F;
        Fri, 30 Jul 2021 21:13:48 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t3so11286992plg.9;
        Fri, 30 Jul 2021 21:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=1GinwmTZ6p1ZyLvkmIYCrplYFGZWc23PDJonSjEXc+Y=;
        b=lrTUsK1a4TAXLwOJbnjXVYINibE0UkQouroDryetct3Mx6Wrpl0JRuMz6LHJ80bfmE
         UUEXCWQP3cHOzCRz7BaPbuRf9HsDYGcBEB/bBmHh1Frcy5WhmETxhFrfC9cpFcyWcajn
         eQ3KY8jmqR1sdYO+ZQ7LyxYf6TQK9vfx3tZHDwGTBN+fntqW+NPVvDeZQ428UDu+A5hW
         ZBfgcNKoazGstkNeS8IBuSEAQZ0UlfXH1UaYbBFKK0GLGQj1xGyEOZDkw6t+BK6ly/Fa
         IH5ccS4ypNzEKPwWm13t2y/FFKJBS3Hfp2g9Wg2PPN7SsubwRoV8Ou13Pott0IzlpGP3
         LcCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=1GinwmTZ6p1ZyLvkmIYCrplYFGZWc23PDJonSjEXc+Y=;
        b=EalSlwqTAr5m3iv7RHPorDFxzGhp8nmlglQoElSWnKfviBg0N4iXw6IyxNWtNVyq6m
         DdCRFXfi/wZaGfhf/RsMssCIpV7/QVsIW0sW1icJx18S5AVj1ozC/m192ZN5tIUJT90n
         fsl1IrZ56/g+wVv5KRtAu8g4jdzWRYoCbBF+UExhw7lNzU70Kt0j9iG7I2h2rjV6dX+O
         Y5PBDr5gqATKUZF2xYxfdt/AHX0iS9onAnVDb7lnyYpPP+cAxaL0+aakhElonvjlNKut
         dchbbSq93ENY9MDAUOt9IfWG4RL7nrB9397YKobJeJAPzf7avFYWAeZMelq7U4grkWjm
         CKUg==
X-Gm-Message-State: AOAM532ujBQ6ZB6j87ipLBlKiC+A+QCRtvxK8+Z8HRaASqXD5CJ6HZRM
        er+Kz0wCMvnHtxLZTwhgEIQ=
X-Google-Smtp-Source: ABdhPJxh1URjLRxx/MADF1nHo/octUYF4390gZQLE9oTEpF5OT5m8hG55tKx5HD9QtOf+0EBVVW8Aw==
X-Received: by 2002:a17:902:f68d:b029:12c:4619:c63a with SMTP id l13-20020a170902f68db029012c4619c63amr4724967plg.66.1627704828165;
        Fri, 30 Jul 2021 21:13:48 -0700 (PDT)
Received: from [10.106.0.50] ([45.135.186.29])
        by smtp.gmail.com with ESMTPSA id s5sm3976860pfk.114.2021.07.30.21.13.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 21:13:47 -0700 (PDT)
To:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
From:   Li Tuo <islituo@gmail.com>
Subject: [BUG] mwifiex: possible null-pointer dereference in
 mwifiex_dnld_cmd_to_fw()
Message-ID: <968036b8-df27-3f22-074b-3aeed7c7bbf2@gmail.com>
Date:   Sat, 31 Jul 2021 12:13:46 +0800
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
the mwifiex driver in Linux 5.14.0-rc3:

The variable cmd_node->cmd_skb->data is assigned to the variable 
host_cmd, and host_cmd is checked in:
190:    if (host_cmd == NULL || host_cmd->size == 0)

This indicates that host_cmd can be NULL.
If so, the function mwifiex_recycle_cmd_node() will be called with the 
argument cmd_node:
196:    mwifiex_recycle_cmd_node(adapter, cmd_node);

In this called function, the variable cmd_node->cmd_skb->data is 
assigned to the variable host_cmd, too.
Thus the variable host_cmd in the function mwifiex_recycle_cmd_node() 
can be also NULL.
However, it is dereferenced when calling le16_to_cpu():
144:    le16_to_cpu(host_cmd->command)

I am not quite sure whether this possible null-pointer dereference is 
real and how to fix it if it is real.
Any feedback would be appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Tuo Li
