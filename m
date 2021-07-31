Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1813DC301
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 05:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhGaDpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 23:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhGaDpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 23:45:53 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59836C06175F;
        Fri, 30 Jul 2021 20:45:47 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nh14so6209834pjb.2;
        Fri, 30 Jul 2021 20:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=1GinwmTZ6p1ZyLvkmIYCrplYFGZWc23PDJonSjEXc+Y=;
        b=dcr+q9ixLa0ovEJA8HC10Veel2PT4jKqbEfSTxFxs7u+1QL9T98tv0LWNe/JKu6DCS
         DiNJmFITVubvdUmMQBe4OySSbEDN8Rvenp7AXlei5CZyMWfoFd9tzuOXsTLb56JqB+j7
         TEeSMagi2uyx477HlBEWFJeTGIF3s/6cKlYM0knOHjWO0AWF/0fLuqAUnICyW70CvjGl
         lS6PZXxYQNJyvks5nAZ+7v3EP/XaBFf0T9baae1mIfxmwrYuZu5/s/a1NWptWvrlOaw6
         bkMAIlsJevRUM70QG6OyWngX9Iyy2VvUOWhNCvJdBzFqinVdq9KI3Gl1ccfoZ0W0r/XP
         y04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=1GinwmTZ6p1ZyLvkmIYCrplYFGZWc23PDJonSjEXc+Y=;
        b=SMXeuQc8rIAL47M0zK+yj0w7yTozZ/2kF4q7yEI7tAiuoHvwU3MHH4hWM8Ej3pa7/H
         ZANdpMLOERIxLLd4A1eDV0qs2FGbJjpdSeGDZQJBxlPCjS69Cjqyk3+IX6gxawlNFcgj
         bcYF1IAMKvg6BGs4oOjxrInAb0y71atNaYr8az4qsB57DZI8LjSByRQOHR79sJ2i11Rt
         XnB5k+AmgOmeOX6DRsJbJUbQsow48QdTJKnBXaWThowq2IfXwL/sx4Co3gZcvw7qvrgZ
         1GEM1jBL+pCtm7Vq8nqrmlcnyJe+cyZlKDu9EmkEmxvBIEMhd+97GfTCnFkqz8L45yBI
         JfJQ==
X-Gm-Message-State: AOAM530VvWgmauerNvSqkNkl1RsQKrwbuv66ucFE2D37kVk7IuiXNJrF
        q7728AL5dTeoPTcAnV1jKiKYAiqGsglziQ==
X-Google-Smtp-Source: ABdhPJyL2ozSqTKcYN/obzp11aUvsU41m/GJ5i3xFwj8vbYn37+vYg+cAG8Re7kO3q6IOkmJcQKkqw==
X-Received: by 2002:a17:902:a9c7:b029:12b:349:b318 with SMTP id b7-20020a170902a9c7b029012b0349b318mr5137210plr.13.1627703146894;
        Fri, 30 Jul 2021 20:45:46 -0700 (PDT)
Received: from [10.106.0.42] ([45.135.186.29])
        by smtp.gmail.com with ESMTPSA id z11sm3742109pjq.13.2021.07.30.20.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 20:45:46 -0700 (PDT)
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
From:   Li Tuo <islituo@gmail.com>
Subject: [BUG] mwifiex: possible null-pointer dereference in
 mwifiex_dnld_cmd_to_fw()
Message-ID: <790f9160-f549-2788-cd37-13924883d5c1@gmail.com>
Date:   Sat, 31 Jul 2021 11:45:46 +0800
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
