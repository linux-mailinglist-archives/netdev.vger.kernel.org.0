Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB4833A24A
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 03:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhCNCAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 21:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbhCNCAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 21:00:05 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A2FC061574;
        Sat, 13 Mar 2021 18:00:05 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q5so5680927pgk.5;
        Sat, 13 Mar 2021 18:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qs2UgpNHrs9qIOZOqKSGGqFmmr2tm9Rf+HF/JQPX6rg=;
        b=JCANjpJP+PSwE6nrZCgLfG3qg7hPxPu7DbwxIQaDZt6QwRdc5nCYjCsoWGwtP1nHjN
         DwHK78zzo0uKy2y71O2YeKHGMHtHivAvry5Ci45KJKMF+Y5sbLmnvzNZo2gAvVPEMUwl
         U9brCTm0M5h7qzmQEK0cz+iELqKbOii8x0xr9BDHLSC+ptdXxLhLuRSILTUrJJ5QIoPy
         5jR6kL2f5hNVgVYFUDmqGEVOP6iTNkSntTlN0dqaLo/6Xzo5qQBnSWsKstt4mDfaPQ8M
         xjM7c6598kE4VR89Dg9jWgWXpK9eVqCjnNYcK4xyVeZgDWREdzuO7nPs/2qBjLfqDong
         0lNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qs2UgpNHrs9qIOZOqKSGGqFmmr2tm9Rf+HF/JQPX6rg=;
        b=FWRdTvk09Yg90Bz0YCd0ovvOUwfl+TjhWG5rMeEA3E/hsyz+JT//iSjXgddwKrrbtm
         k8RiwdYPkYhykjSIeUnZVFXEuYuw5vmXQ0cyQcTRn+IkhNT2duaczqozbQaGrylbYisG
         2GoMuvhKnyskzJS/HxvlsS2A/2/9unTF7ImmOn09EPePmgfaAajPm9F5pwZqY2bkJkqU
         Q2ISTUlPHw9sZewl3xV3WLXhy4gZ35BRD419lRbhr+OjdiNDFKWpuynXVvqTG8gdLfq1
         Bswi36jhKQJT0mbvaGyEp4lTBvxoOZlJaEs+WGoAyGQE1IvhCvdAP93xEtGgQm7rPZ2V
         IIVw==
X-Gm-Message-State: AOAM531iKmnqaNbkv6P4NJX1BL4BkGLTvaQokZpXKw3Q+h+TX+9oVOqz
        XRrFUPE0l5NpTPEnDbKva59N3LUwxBsl+/ZA/wraLE2T
X-Google-Smtp-Source: ABdhPJwtzByi22xHUluOzkCy53Fqneo/9ax19XO3BoAWTJrwEhm8ACoDiyZsi/Z/2rZk3NOoAFbDhNBhbB3FsdS/Sdg=
X-Received: by 2002:a62:e10f:0:b029:1f5:42b6:7113 with SMTP id
 q15-20020a62e10f0000b02901f542b67113mr4929157pfh.63.1615687204977; Sat, 13
 Mar 2021 18:00:04 -0800 (PST)
MIME-Version: 1.0
References: <20210311072311.2969-1-xie.he.0141@gmail.com>
In-Reply-To: <20210311072311.2969-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 13 Mar 2021 17:59:54 -0800
Message-ID: <CAJht_ENT6E4pekdTJ8YKntKdH94e-1H6Tf6iBr-=Vbxj5rCs+A@mail.gmail.com>
Subject: Re: [PATCH net] net: lapbether: Prevent racing when checking whether
 the netif is running
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

Could you ack? Thanks!
