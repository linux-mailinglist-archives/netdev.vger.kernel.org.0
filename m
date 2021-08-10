Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4244D3E5C2C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241956AbhHJNux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhHJNuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:50:52 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E24C0613D3;
        Tue, 10 Aug 2021 06:50:30 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so4422166pji.5;
        Tue, 10 Aug 2021 06:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=Na5r6WxMbNS8Nyf4HKx/vDqX/nZNyBc04/DnaxOLZ2Y=;
        b=Ahbyu2SQmqnDXV3uBXJSN8rqkMvO/ZJlqir0IXF1zyK/AGu22zKxz2xhsCDJEXR+uA
         3alD+uwbGXY2v84PLfKm1FBFnWPEJ5FlkFfiBLCsEGZoQa/rEuo6P4+xcZG2ez3xqKAV
         Smkq4m+LX89dPNk9wuhGd+UukuQSh1Jf6P0zH18Rei2FgLiqIHeKpZIjNvcJp68xV4O3
         fhYSl0CaINn65Ft6SpvsEyqUC37C31UkXoied8mffJyG865V09HIdKxCE1+6xH416elk
         QPi07rf45Yquu5bsMnJfsHxezsbCQ1AE4tFMeIcNY+AV7G6xg3WXhxVdjA2lGBoWz1mU
         3itw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=Na5r6WxMbNS8Nyf4HKx/vDqX/nZNyBc04/DnaxOLZ2Y=;
        b=leNr+6PHM+R2HoRrICc8Q0pqCnwIuKZpavzZ4uSo8MkRJEadqHshx5HLlgHTlhVE/N
         wc82QYRh0lj0Ce4oGFLohKskRoib41W1Xz+eZLnMJkyVWI53foEWAFvpgz3rxprhoh05
         M2JT91LwqtVHIaXVCyC9fLPU+PPs77LV0FfeHdYtHmD2q330BoLbwq/RE3y1eByg+TMj
         8fjL+gvAnysNdc+CGyoJz0yGsZmESPE4sBwLifc//HHhNxc6QoHY8hI+BOVXpjKWJZzZ
         R1XzzQ0wI2Gz5XZXSp+sQahjAJKNGYZHwgyb135FEyc2HqGf+6X+s/2amb/Cgpo0e0Bm
         /gQA==
X-Gm-Message-State: AOAM530VkHEWy86wPTLIFNh+QEw95l/V0T/nmD3CQLZhUZAsjbLAYpiB
        AYx9W/8yqmx2j86nqVimNijgLaPZs3Jov9hE
X-Google-Smtp-Source: ABdhPJwV3jkigz40brQy9FHVLtrTjI+Mefvt3ubGb4yUvVNbzWqZ6cgeEI5Ca4ZSqeMlG7am0ui1UQ==
X-Received: by 2002:a05:6a00:808:b029:3c1:15ba:ade2 with SMTP id m8-20020a056a000808b02903c115baade2mr23517872pfk.74.1628603430204;
        Tue, 10 Aug 2021 06:50:30 -0700 (PDT)
Received: from [10.178.0.62] ([85.203.23.37])
        by smtp.gmail.com with ESMTPSA id d2sm28417068pgv.87.2021.08.10.06.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 06:50:29 -0700 (PDT)
To:     stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     "baijiaju1990@gmail.com" <baijiaju1990@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Tuo Li <islituo@gmail.com>
Subject: [BUG] ipw2x00: possible null-pointer dereference in
 libipw_wx_set_encode()
Message-ID: <b9e3b7c9-59e4-7b3d-45d0-89ca006d45fc@gmail.com>
Date:   Tue, 10 Aug 2021 21:50:26 +0800
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
the ipw2x00 driver in Linux 5.14.0-rc3:

The variable (*crypt)->ops is checked in:
360:    if (*crypt != NULL && (*crypt)->ops != NULL && 
strcmp((*crypt)->ops->name, "WEP") != 0)

This indicates that (*crypt)->ops can be NULL. If so, some possible 
null-pointer dereferences will occur:
407:    (*crypt)->ops->set_key(sec.keys[key], len, NULL, (*crypt)->priv);
417:    len = (*crypt)->ops->get_key(sec.keys[key], WEP_KEY_LEN, ...)

I am not quite sure whether these possible null-pointer dereferences are 
real and how to fix them if they are real.
Any feedback would be appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Tuo Li
