Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889B1905B8
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfHPQ1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:27:31 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:48390 "EHLO
        mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfHPQ1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:27:31 -0400
X-Greylist: delayed 1134 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 12:27:30 EDT
Received: from mx2.fh-giessen.de ([212.201.18.41])
        by mout2.fh-giessen.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <tobias.johannes.klausmann@mni.thm.de>)
        id 1hyemB-0003t1-8u; Fri, 16 Aug 2019 18:08:27 +0200
Received: from mailgate-2.its.fh-giessen.de ([212.201.18.14])
        by mx2.fh-giessen.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <tobias.johannes.klausmann@mni.thm.de>)
        id 1hyemB-006LjD-4G; Fri, 16 Aug 2019 18:08:27 +0200
Received: from p2e561b42.dip0.t-ipconnect.de ([46.86.27.66] helo=[192.168.1.24])
        by mailgate-2.its.fh-giessen.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <tobias.johannes.klausmann@mni.thm.de>)
        id 1hyemA-000UF7-Qz; Fri, 16 Aug 2019 18:08:26 +0200
To:     kvalo@codeaurora.org, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicoleotsuka@gmail.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org
From:   Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Subject: regression in ath10k dma allocation
Cc:     tobias.klausmann@freenet.de
Message-ID: <8fe8b415-2d34-0a14-170b-dcb31c162e67@mni.thm.de>
Date:   Fri, 16 Aug 2019 18:08:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:70.0) Gecko/20100101
 Thunderbird/70.0a1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

within the current development cycle i noted the ath10k driver failing 
to setup:

[    3.185660] ath10k_pci 0000:02:00.0: failed to alloc CE dest ring 1: -12
[    3.185664] ath10k_pci 0000:02:00.0: failed to allocate copy engine 
pipe 1: -12
[    3.185667] ath10k_pci 0000:02:00.0: failed to allocate copy engine 
pipes: -12
[    3.185669] ath10k_pci 0000:02:00.0: failed to setup resource: -12
[    3.185692] ath10k_pci: probe of 0000:02:00.0 failed with error -12

the actual failure comes from [1] and indeed bisecting brought me to a 
related commit "dma-contiguous: add dma_{alloc,free}_contiguous() 
helpers" [2]. Reverting the commit fixes the problem, yet this might 
just be the driver abusing the dma infrastructure, so hopefully someone 
can have a look at it, as i'm not familiar with the code!


[1]: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/wireless/ath/ath10k/ce.c?h=v5.3-rc4#n1650

[2]: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b1d2dc009dece4cd7e629419b52266ba51960a6b


Greetings,

Tobias

