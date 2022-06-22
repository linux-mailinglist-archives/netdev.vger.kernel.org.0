Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DE755424E
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356091AbiFVFdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiFVFdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:33:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C3F205E4;
        Tue, 21 Jun 2022 22:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9032E61986;
        Wed, 22 Jun 2022 05:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD118C34114;
        Wed, 22 Jun 2022 05:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655875997;
        bh=6Mr/dzeGOUef4ZuCzLFtq0MrZ+HZv3O4fRtN/qhvNbw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ERRkcK5KaKK3L/TS2dsaqX1dQ5UupOiyG9AN42ihFk2Jr/kN3xHSg/etCYf5dWTmC
         4jVV0Jo3IbvadH3UCc9riD0DswNkeFIEW8+i2z05KCdsR6MTxB7mdgLwiS92uw3djX
         hAtA/BIstxMEEkAMyzPhSacnBFQLmgCK3A8wnVls9APO2TxvC5zssZuWOZIBuLuIfR
         3r/eMT/NBqEwOs6OHsiGqRuJZVN3NfEF/vSbml6DEXkrjKRJuG3fd89vLdtgHtCWCB
         V5UsiogWTRQpZCpvGulomrWWvitNRhy2/uDBK3os+PAYWl3BOHoOAvZmAWJoFu9Ill
         5Y+Brtcy10tOQ==
Date:   Tue, 21 Jun 2022 22:33:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     bhelgaas@google.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH net-next v7] net: txgbe: Add build support for txgbe
Message-ID: <20220621223315.60b657f4@kernel.org>
In-Reply-To: <20220621023209.599386-1-jiawenwu@trustnetic.com>
References: <20220621023209.599386-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jun 2022 10:32:09 +0800 Jiawen Wu wrote:
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -5942,3 +5942,18 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56b1, aspm_l1_acceptable_latency
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56c0, aspm_l1_acceptable_latency);
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x56c1, aspm_l1_acceptable_latency);
>  #endif
> +
> +static void quirk_wangxun_set_read_req_size(struct pci_dev *pdev)
> +{
> +	u16 ctl;
> +
> +	pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &ctl);
> +
> +	if (((ctl & PCI_EXP_DEVCTL_READRQ) != PCI_EXP_DEVCTL_READRQ_128B) &&
> +	    ((ctl & PCI_EXP_DEVCTL_READRQ) != PCI_EXP_DEVCTL_READRQ_256B))
> +		pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
> +						   PCI_EXP_DEVCTL_READRQ,
> +						   PCI_EXP_DEVCTL_READRQ_256B);
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID,
> +			 quirk_wangxun_set_read_req_size);

Hi Bjorn! Other than the fact that you should obviously have been CCed
on the patch [1] - what are the general rules on the quirks? Should
this be sent separately to your PCI tree?

[1]
https://lore.kernel.org/all/20220621023209.599386-1-jiawenwu@trustnetic.com/
