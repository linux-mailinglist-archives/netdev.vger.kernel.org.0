Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5077945A72A
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238670AbhKWQJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhKWQJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 11:09:53 -0500
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BB6C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 08:06:45 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id n6so44835900uak.1
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 08:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V/uq4zFiKGt/Y2S5RetNr9AIiGsp8Nu+Xz+xdcQz7cs=;
        b=A+HA+HLXWjv3zSyIian7TF/GbjkPSXRZU3SPMXa75mGzAyjE0DBoo12ea11khZva5H
         tHcz6IcyNxOTd3g9T6Q/3npMIFB5wZVdAmiAXYJnsorO1zGNgmRrlBxNcgCfy7F8q+K9
         oQT/qgqeyr4ueLDkE5fBTKRrALVcVCluoY9Kbm1brLtk/5N9sW7FpIzmUpamoMAv8aVO
         7shNE/NgOlME7O0spHHf3M9wmivN7luzMbY/CFeIVxz4GRQFtny0HXT/PaIl70rKsuIq
         GKkFIMqAnU26hrMLH5EnIGjv63ACa+dOvzZtOv9JZWfKlzVaHykDvo5DKf45NT27h6Qk
         qiUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V/uq4zFiKGt/Y2S5RetNr9AIiGsp8Nu+Xz+xdcQz7cs=;
        b=GPCo4ucQNY9LLgZTQqyq9Vn2nmdemd3fARVVmnXZ56Z7xxvMOsejS1qQ/WxD5HbHl+
         mtjMRxJMFT32JoJFSLSfz4FDo+7JH1v92vWx+aAUVbm2EZmGZ61Yu3h+Wi0/1kpSNhIE
         i/SM8kaZGSGpTQ+/DZrLu5bA9t0zSwuu1zHkpL3Zy0Szcs8jvgn8YptRGFUF6O2BFKc2
         TXefW8CVUkCzUbBRZ/myMbhGkN+wJDZa5YVlPxaL7WhjukheKa3fB3sz/vb5ZkqzXD3d
         n/3QIUTExWwGq6bSLAmOAFDIgBBftUtfYXNxCmns9VgZm7u7Vrscr6PVIYMe16kq9/vG
         GAOA==
X-Gm-Message-State: AOAM53068lW3SH2s05kNn1bm6kAbgxGhN9GfjOC8foIEQ+yulfZDUIw6
        JUoeDIr+rEl9Qms5RqfuZIU=
X-Google-Smtp-Source: ABdhPJyBFjSEBuCgRI1GwiKntfNn7RshmbvnJfzTonmuUVd1fQzzOLM25aoN59waWtiNLnzOPig55Q==
X-Received: by 2002:a05:6102:1354:: with SMTP id j20mr9606812vsl.41.1637683601664;
        Tue, 23 Nov 2021 08:06:41 -0800 (PST)
Received: from work ([187.105.166.74])
        by smtp.gmail.com with ESMTPSA id l190sm6896647vsc.26.2021.11.23.08.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 08:06:41 -0800 (PST)
Date:   Tue, 23 Nov 2021 13:06:34 -0300
From:   Alessandro B Maurici <abmaurici@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] phy: fix possible double lock calling link changed
 handler
Message-ID: <20211123130634.14fa4972@work>
In-Reply-To: <YZz2irnGkrVQPjTb@lunn.ch>
References: <20211122235548.38b3fc7c@work>
        <YZxrhhm0YdfoJcAu@lunn.ch>
        <20211123014946.1ec2d7ee@work>
        <017ea94f-7caf-3d4e-5900-aa23a212aa26@gmail.com>
        <YZz2irnGkrVQPjTb@lunn.ch>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 15:11:22 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> Yes, that is the change i would make. When adding the extra locks i
> missed that a driver was doing something like this. I will check all
> other callers to see if they are using it in odd contexts.
> 
>      Andrew

Andrew, this kinda of implementation is really hard to get in a fast review, 
fortunately I happen to be testing one lan743x board with a 5.10.79 kernel
that had the new locks in place, and noticed that really fast, but I wrongly 
assumed that call was okayish since the driver was on stable.
If you need to do some testing I will still have the hardware with me for 
some time.

Alessandro
