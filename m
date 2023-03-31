Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBD36D22EE
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjCaOtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjCaOtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:49:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D901C1C4;
        Fri, 31 Mar 2023 07:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F660622E4;
        Fri, 31 Mar 2023 14:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39ACC433EF;
        Fri, 31 Mar 2023 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680274157;
        bh=nwc5YPzwUATML1zglVwWiNR73nsURuoCmDlBMPRIh8Y=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=i5BirXI10C+WP67AGxYbXoGuzImzyfv7lkGdaXASDjYmzlIqR7xZkKK9cmBYuL62l
         xV5KplyHb8fc45zfaP22QaeDtzV2J+yUX36hoJqF/LzJ70zTuse+0F3s5Dg6gyCazE
         ZhcfO24xV9BdOQIg2mSqF/ZnfWKeqELg9eCG1cOl+r8nFsBpovy3qBQ17R0DQlTc53
         i0euRVEG6uKQAPPFRk3PNoFnS0y3+TKW5yJKqCTHkreKaTe8TT2WEu4ktJgN6vZ0dg
         WwFMrOkXvatdH99kpswLnY3JO687UJSBz1yBZe9KQWKebWpFztIf3F4EO3LH4s11m7
         tH5idFt/LBDpw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/5] wifi: rtw88: Remove redundant pci_clear_master
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230323112613.7550-4-cai.huoqing@linux.dev>
References: <20230323112613.7550-4-cai.huoqing@linux.dev>
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
Message-ID: <168027415284.32751.5288169344605905589.kvalo@kernel.org>
Date:   Fri, 31 Mar 2023 14:49:14 +0000 (UTC)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
> 	u16 pci_command;
> 
> 	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
> 	if (pci_command & PCI_COMMAND_MASTER) {
> 		pci_command &= ~PCI_COMMAND_MASTER;
> 		pci_write_config_word(dev, PCI_COMMAND, pci_command);
> 	}
> 
> 	pcibios_disable_device(dev);
> }.
> And dev->is_busmaster is set to 0 in pci_disable_device.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

e665c6d67e54 wifi: rtw88: Remove redundant pci_clear_master

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230323112613.7550-4-cai.huoqing@linux.dev/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

