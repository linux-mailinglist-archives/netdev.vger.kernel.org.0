Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F56D9059B
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfHPQQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:16:21 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:41874 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfHPQQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:16:20 -0400
Received: by mail-wr1-f46.google.com with SMTP id j16so2059316wrr.8
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 09:16:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aXOWm885zlSQjaOTNsiB6ixyEYYi9R71KVEE87CvUak=;
        b=EvJjF9fmRCRaYF7XxJChHPaRWs1MZcfz3b0xqF0DiwM5t+IUcillPmXobbM29QLj4j
         JtRiWllU/dZ3dXY1d5Lt8CEcR6g49+YnIdaYx01dsnzipvlDhDpwvOf15vDh0YKwV3tZ
         25n2GryB4SHHP2wq2dvAfbSRzI18bVhqCNDoNuDZpDywgcZSLNEyHangtqmp9bPxpA2I
         6+2GjAnn8uF1bV6UYb3JuNLt8RIQIMdGxRkWxJmau+xvCdZ5KZSPo70MYBpPbu3TBHxw
         Xt9wAt4Gkcg7JE5mL+QghKorabHQBf83F4gzjEXZzDeD8RywMnNPvkrA8AHMzIiinyG2
         8yDw==
X-Gm-Message-State: APjAAAUG5yZtrq0ec6lwLRkHc5O60jGuz2gJVzC2qDud4QNaAaU0UveN
        lFxQPiK6ZhguhzzyKTQ8+4hvJczkS+Q=
X-Google-Smtp-Source: APXvYqy6B4y9yrIXuG+5Spcygji8YfnMrNZIuzappqSMix4ReJs2eJshqSyIxnLvZ0v0kauGmsdKjg==
X-Received: by 2002:a5d:6b84:: with SMTP id n4mr12261415wrx.118.1565972178874;
        Fri, 16 Aug 2019 09:16:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f70sm8693222wme.22.2019.08.16.09.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 09:16:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sashal\@kernel.org" <sashal@kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "leon\@kernel.org" <leon@kernel.org>,
        "eranbe\@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi\@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv\@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next, 2/6] PCI: hv: Add a Hyper-V PCI mini driver for software backchannel interface
In-Reply-To: <DM6PR21MB13375FA0BA0220A91EF448E1CAAF0@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com> <1565809632-39138-3-git-send-email-haiyangz@microsoft.com> <878srt8fd8.fsf@vitty.brq.redhat.com> <DM6PR21MB13375FA0BA0220A91EF448E1CAAF0@DM6PR21MB1337.namprd21.prod.outlook.com>
Date:   Fri, 16 Aug 2019 18:16:17 +0200
Message-ID: <871rxl84ry.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Haiyang Zhang <haiyangz@microsoft.com> writes:

>
> The pci_hyperv can only be loaded on VMs on Hyper-V and Azure. Other 
> drivers like MLX5e will have symbolic dependency of pci_hyperv if they 
> use functions exported by pci_hyperv. This dependency will cause other 
> drivers fail to load on other platforms, like VMs on KVM. So we created 
> this mini driver, which can be loaded on any platforms to provide the 
> symbolic dependency.

(/me wondering is there a nicer way around this, by using __weak or
something like that...)

In case this stub is the best solution I'd suggest to rename it to
something like PCI_HYPERV_INTERFACE to make it clear it is not a
separate driver (_MINI makes me think so).

-- 
Vitaly
