Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC459333B80
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhCJLem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:34:42 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:52390 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhCJLeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:34:16 -0500
Received: by mail-wm1-f48.google.com with SMTP id n22so6895307wmc.2;
        Wed, 10 Mar 2021 03:34:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7J7s2ULlckxPGV45ObvNHeMFlnciPOBmL4sFeKxQRrY=;
        b=f+hF+pFH0HAizt2JQ2xgYBt5+SCWy5rWFtjiPaAHluZDlhNTVAFfW3YyvrG8WtjjkE
         gzybpQUkYL9piVr/2mU8hhKJfTZitAxv6ju4K+sFKPUm80F90AocMyXQVBJl//tG9rjA
         JGwrnkuE7P9ZEQJHQ3koboVUHoezYIlEl8gsjKo4Gm3vZ+8R3fEGWDCxvFZZiL8xRu3E
         JppUwYvQCEhXuqFpAKeIbupK7tFUySZgLLJV1uKiQTJj9etpe0kDz4VUHLu4o3GtwaeG
         Rg3rfIYd5sZxtIYtCdV19hBiCEZJPJoIFClAfNsT5AWndbShOEnZtRaVblkDoLRnGKYn
         832w==
X-Gm-Message-State: AOAM530ywGmQCXDobx4UaQCGDsEFT/pGvcCVMahMEHRVWyB0meaU1qU0
        pkelFlQl5+I4e6c8nsAR+Go=
X-Google-Smtp-Source: ABdhPJykSDTXQb6rMzAJxlIEs15qvYEmGaFG3pm37E2tlVeGACX4zqvLUH6j+7SC5v6ZH9AFK3lxiA==
X-Received: by 2002:a7b:ce19:: with SMTP id m25mr2938803wmc.74.1615376055056;
        Wed, 10 Mar 2021 03:34:15 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id m3sm8770402wmc.48.2021.03.10.03.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:34:14 -0800 (PST)
Date:   Wed, 10 Mar 2021 11:34:13 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [patch 12/14] PCI: hv: Use tasklet_disable_in_atomic()
Message-ID: <20210310113413.cuvmnrd3vhyhzi4c@liuwe-devbox-debian-v2>
References: <20210309084203.995862150@linutronix.de>
 <20210309084242.516519290@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309084242.516519290@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 09:42:15AM +0100, Thomas Gleixner wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> The hv_compose_msi_msg() callback in irq_chip::irq_compose_msi_msg is
> invoked via irq_chip_compose_msi_msg(), which itself is always invoked from
> atomic contexts from the guts of the interrupt core code.
> 
> There is no way to change this w/o rewriting the whole driver, so use
> tasklet_disable_in_atomic() which allows to make tasklet_disable()
> sleepable once the remaining atomic users are addressed.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Wei Liu <wei.liu@kernel.org>
