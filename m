Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1DF45A709
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 16:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhKWQB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbhKWQB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 11:01:27 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4578C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 07:58:19 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id a14so1206986uak.0
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 07:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D30q2TZL/7XzJpTAfs+OQYRWUemoFFpISlu453B9ihg=;
        b=II+5buF1Cy6pWB4hxN6wIgNiIrv8yKtHhkVe34seABQu9uNqlIULjIMl7NhO4yviV4
         +zJO5sWVpLVReWPK+4V5hhjYJDh8b4ZRPLqrrhK9j4vLVQ3nl956gU9R8utcUAdGEr0z
         5093bk5sXxdHe9KlQIF7rYebX6KFa4rBnpUg1lviDuyzcXHqAEM2Mv3oYtykPqaKrkyf
         1HX6hsPD8pc6GmEp8aCHi6t/AmxCwPWYrwW3h5dJmRgCoI4Yl1K0lUpTQkXkKGzc24+6
         vUb94LoatSLBrz3IkyFWyAOQyMR7w8ITojAVmCJWNIABrriVH9Z9kpDyR9+UcnHJEnD7
         vkBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D30q2TZL/7XzJpTAfs+OQYRWUemoFFpISlu453B9ihg=;
        b=QUmNjnVcLkAwSZ+yRMtzfL6kiQWHJo3kJzfPSsX8Jyx4FAqPoesdh2a4z5pSUOWdwp
         aGES7TnE418zx5BfwzEinN8Jv49WZfaAiluwZruQ6wQmgYtdvpkkzA1/buWnsk2EuGbj
         mMSmKbuBHNzdLn1yCmhZPuxHqviQ6KdoSIRlg3b+crL4rFDIIeLcx5ySOa85cw2pCCKb
         /pOjkmx+1rY0uFnSG07xdfv246A+/4amRatJQ5yMk3ozRHq2+8SNycPqQrBLYsIsiMFL
         F/FI/1USdIaw7h0pLZgelxHr4qgN0r1ADNyErBZJW1oVTMWQMfdY1HWBDKS7uRRMPzDU
         F5Iw==
X-Gm-Message-State: AOAM533j6gXn6kQO7v9Wk27DLgwohMssOrdxswLxu1QlAoQVra0tbawN
        1KFFwbsU/9VceFYu02YiSq4=
X-Google-Smtp-Source: ABdhPJyf0IYEyE4T+0MFq+rWq/OlTZQYgXJF0zWtiuLcMEc9jHbtV+ZZazs9Pmq0d/XrLgsv0sYGsg==
X-Received: by 2002:a67:f1d8:: with SMTP id v24mr10178430vsm.8.1637683098856;
        Tue, 23 Nov 2021 07:58:18 -0800 (PST)
Received: from work ([187.105.166.74])
        by smtp.gmail.com with ESMTPSA id u14sm6336371vkk.12.2021.11.23.07.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 07:58:18 -0800 (PST)
Date:   Tue, 23 Nov 2021 12:58:11 -0300
From:   Alessandro B Maurici <abmaurici@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] phy: fix possible double lock calling link changed
 handler
Message-ID: <20211123125811.066d0680@work>
In-Reply-To: <YZz2AJ+wqasknw2p@lunn.ch>
References: <20211122235548.38b3fc7c@work>
        <YZxrhhm0YdfoJcAu@lunn.ch>
        <20211123014946.1ec2d7ee@work>
        <YZz2AJ+wqasknw2p@lunn.ch>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 15:09:04 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> The callback has always had the lock held, so is safe. However,
> recently a few bugs have been reported and fixed for functions like
> phy_ethtool_get_link_ksettings() and phy_ethtool_set_link_ksettings()
> where they have accessed phydev members without the lock and got
> inconsistent values in race condition. These are hard race conditions
> to reproduce, but a deadlock like this is very obvious, easy to fix. I
> would also say that _ethtool_ in the function name is also a good hit
> this is intended to be used for an ethtool callback.
> 
> Lets remove the inappropriate use of phy_ethtool_get_link_ksettings()
> here.
> 
>      Andrew

Yes, I was under the impression because the lan743x driver used that way, 
this was an expected use case, and that why the patch, but you are 100% 
correct that the phy_dev information sent to the call back would be 
unprotected if used with that patch. My mistake.

Alessandro
