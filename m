Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B51A6DF17F
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 12:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjDLKDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 06:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjDLKDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 06:03:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40F576AE;
        Wed, 12 Apr 2023 03:03:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5723D62AF6;
        Wed, 12 Apr 2023 10:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABB7C4339E;
        Wed, 12 Apr 2023 10:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681293819;
        bh=tEpNk+OfBlpzjfw7+X3xFjLc7iWcYLC+okDPMAZ5S8E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=j4vi955Im0u3442ZSdiXtcvq3q4XLPHy5S8sO5xupwMzU9LBAJb2K7uv25yw8DEJY
         n6pPjs4Zq1uW/F/0o4SaHjBzLO66/C9dxcYVm7cmBNPUbKFLJZZFBnaRwR7w0O/XSC
         Ro4U0XKjCqi3Wqa4/8d0vFMOGC77bFWw50msOjDqrIvt2cel8xAbP4oPaz21rpbcjS
         mOFVeg+CcbJt5MvIbAHnmXgd/2y6p0GgJRbCdcej0FcWWTY0MiHtD7DFtz9e04z3Ry
         cmtXeDmRgVkhI/tRtOEXNYy+KW7boYNAPjchqm6FeiZrpzY8WI1uL+t5hRQq+CnrDR
         Q8erlwVwUQvfA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/5] wifi: ath11k: Remove redundant pci_clear_master
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230323112613.7550-1-cai.huoqing@linux.dev>
References: <20230323112613.7550-1-cai.huoqing@linux.dev>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     cai.huoqing@linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168129381469.14673.15764454080204541798.kvalo@kernel.org>
Date:   Wed, 12 Apr 2023 10:03:36 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cai Huoqing <cai.huoqing@linux.dev> wrote:

> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
>         u16 pci_command;
> 
>         pci_read_config_word(dev, PCI_COMMAND, &pci_command);
>         if (pci_command & PCI_COMMAND_MASTER) {
>                 pci_command &= ~PCI_COMMAND_MASTER;
>                 pci_write_config_word(dev, PCI_COMMAND, pci_command);
>         }
> 
>         pcibios_disable_device(dev);
> }.
> And dev->is_busmaster is set to 0 in pci_disable_device.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

3 patches applied to ath-next branch of ath.git, thanks.

f812e2a9f85d wifi: ath11k: Remove redundant pci_clear_master
76008fc13b09 wifi: ath10k: Remove redundant pci_clear_master
b9235aef8492 wifi: ath12k: Remove redundant pci_clear_master

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230323112613.7550-1-cai.huoqing@linux.dev/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

