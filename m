Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A0A829E3
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 05:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbfHFDGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 23:06:21 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35013 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730974AbfHFDGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 23:06:21 -0400
Received: by mail-pg1-f195.google.com with SMTP id n4so5481078pgv.2
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 20:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FlvubqIedgeUlDz/PPiAaJ/H2Njn7iS17Qlm1S+ibcs=;
        b=ynfiagkhgmGZERUei2yzw6PnvDoOnOGKaEU+BMUJIRoWffXtOXvM7JmpSEltHxNXMA
         oYyljM/tmGwXdC30QlWHHWbcRrYE9qBwLWv7umSLx8+B/ECw6vRLRLIHMOgbn3pi46mt
         4A3L0A+DOhRb2pQbdkqq3jFUo0M2J6N8Rn5GpoEo7cWttiHS18T3tj0og3hmA6lPjzMr
         1H5xB2mVcdaFWSbiEBswqQ5jiRkhy1nkaEyR5ccR3jTCnjHxI4JKgfSa15Gn6ncXadnj
         trmN9tyDkV9ItvX2nZJGnL59ViA4Sqj8UWgo6MZ7JXNTK5w2kx2RIoBKs7hBnfU4I30G
         /Vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FlvubqIedgeUlDz/PPiAaJ/H2Njn7iS17Qlm1S+ibcs=;
        b=Z3Gf+7QjX04LAhOXvDYkcOXUc15yvFmeWNdm/J7Zbm1F2cKE+VUFmtN8imeC5C9e4Y
         qTP6kkTa/vjfwSs5iaYbSX7DEOWjkEJWJrEZsVwjQSPtf/scR4ejB4YWhTTWFxmjHJBr
         IgsGLwzpsACH+jFKrMAsdTT7/IZkw0szijD08zBMwh3aaBZrypSk8q21Iyf986z0IG8Q
         3gNMC7t9JH6HL2nnCOOlntdzcgO2DELDlv1Nwl/Toq6PJIhYUM+QRNq+cGUSOrkUCTt7
         y0mW/2SC+gruOQgaphEysBsMbsIRfMp5H2+0c0+cx7QgJs/bNPc6moKrvESUyez/oLWL
         m44A==
X-Gm-Message-State: APjAAAV1I5WNUqzY0x7hG8VCkaGgGNFb55YnObrIU0isFP90vPzLP2AB
        +fMFJWHbLYiso/9vUSKL8h2FxQ==
X-Google-Smtp-Source: APXvYqyC0NiG+dH81MgzylsXKTEOMaOlrWGlwxH0Q+mcPaNttiuDNofMxMSQSM8JshjuU5dIMYQZPA==
X-Received: by 2002:a17:90a:b312:: with SMTP id d18mr822646pjr.35.1565060780443;
        Mon, 05 Aug 2019 20:06:20 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id v14sm91912574pfm.164.2019.08.05.20.06.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 20:06:20 -0700 (PDT)
Date:   Mon, 5 Aug 2019 20:05:55 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Cc:     <davem@davemloft.net>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <leeyou.li@huawei.com>,
        <xiaowei774@huawei.com>, <nixiaoming@huawei.com>
Subject: Re: [PATCH v1 1/3] net: hisilicon: make hip04_tx_reclaim
 non-reentrant
Message-ID: <20190805200555.5a171567@cakuba.netronome.com>
In-Reply-To: <c150d41b-6f0e-ad49-e8c2-00896fc9cbe4@huawei.com>
References: <1564835501-90257-1-git-send-email-xiaojiangfeng@huawei.com>
        <1564835501-90257-2-git-send-email-xiaojiangfeng@huawei.com>
        <20190805174618.2b3b551a@cakuba.netronome.com>
        <c150d41b-6f0e-ad49-e8c2-00896fc9cbe4@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Aug 2019 10:00:52 +0800, Jiangfeng Xiao wrote:
> If hip04_tx_reclaim is interrupted while it is running, and then
> __irq_svc->gic_handle_irq->hip04_mac_interrupt->__napi_schedule->hip04_rx_poll->hip04_tx_reclaim

Ah right, obviously you can't do stuff after napi_complete_done(), 
that makes sense.

Series looks reasonable.
