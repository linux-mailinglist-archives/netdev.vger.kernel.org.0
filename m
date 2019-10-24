Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25464E29BD
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437443AbfJXFDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:03:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:32846 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfJXFDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:03:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D11CF60DEA; Thu, 24 Oct 2019 05:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571893401;
        bh=vYRU+bM5JuL4RITs+SLUICptP4u3V+UStBVyN02aLUw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RWwbs03Ne47c4LigpsA9MtG3IVJ8M9D/Q5mU+dOTEYDIHHP3rc+m7UQCfZdYlfovL
         U1M2Thsw9jhkjYuS9SdUqGwH0jdofLNsogcoTIXOx8zXPTyeALvWvhm/pGMftejcWm
         NAOzIVcMxAfQlWxsPLH1FQ05HfS+rxqCGMHCBqCA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5293A60F78;
        Thu, 24 Oct 2019 05:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571893401;
        bh=vYRU+bM5JuL4RITs+SLUICptP4u3V+UStBVyN02aLUw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RWwbs03Ne47c4LigpsA9MtG3IVJ8M9D/Q5mU+dOTEYDIHHP3rc+m7UQCfZdYlfovL
         U1M2Thsw9jhkjYuS9SdUqGwH0jdofLNsogcoTIXOx8zXPTyeALvWvhm/pGMftejcWm
         NAOzIVcMxAfQlWxsPLH1FQ05HfS+rxqCGMHCBqCA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5293A60F78
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, oleksandr@natalenko.name,
        netdev@vger.kernel.org
Subject: Re: [PATCH wireless-drivers 1/2] mt76: mt76x2e: disable pcie_aspm by default
References: <cover.1571868221.git.lorenzo@kernel.org>
        <fec60f066bab1936d58b2e69bae3f20e645d1304.1571868221.git.lorenzo@kernel.org>
Date:   Thu, 24 Oct 2019 08:03:16 +0300
In-Reply-To: <fec60f066bab1936d58b2e69bae3f20e645d1304.1571868221.git.lorenzo@kernel.org>
        (Lorenzo Bianconi's message of "Thu, 24 Oct 2019 00:23:15 +0200")
Message-ID: <87eez2u44r.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> On same device (e.g. U7612E-H1) PCIE_ASPM causes continuous mcu hangs and
> instability and so let's disable PCIE_ASPM by default. This patch has
> been successfully tested on U7612E-H1 mini-pice card
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

[...]

> +void mt76_mmio_disable_aspm(struct pci_dev *pdev)
> +{
> +	struct pci_dev *parent = pdev->bus->self;
> +	u16 aspm_conf, parent_aspm_conf = 0;
> +
> +	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &aspm_conf);
> +	aspm_conf &= PCI_EXP_LNKCTL_ASPMC;
> +	if (parent) {
> +		pcie_capability_read_word(parent, PCI_EXP_LNKCTL,
> +					  &parent_aspm_conf);
> +		parent_aspm_conf &= PCI_EXP_LNKCTL_ASPMC;
> +	}
> +
> +	if (!aspm_conf && (!parent || !parent_aspm_conf)) {
> +		/* aspm already disabled */
> +		return;
> +	}
> +
> +	dev_info(&pdev->dev, "disabling ASPM %s %s\n",
> +		 (aspm_conf & PCI_EXP_LNKCTL_ASPM_L0S) ? "L0s" : "",
> +		 (aspm_conf & PCI_EXP_LNKCTL_ASPM_L1) ? "L1" : "");
> +
> +#ifdef CONFIG_PCIEASPM
> +	pci_disable_link_state(pdev, aspm_conf);
> +
> +	/* Double-check ASPM control.  If not disabled by the above, the
> +	 * BIOS is preventing that from happening (or CONFIG_PCIEASPM is
> +	 * not enabled); override by writing PCI config space directly.
> +	 */
> +	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &aspm_conf);
> +	if (!(aspm_conf & PCI_EXP_LNKCTL_ASPMC))
> +		return;
> +#endif /* CONFIG_PCIEASPM */

A minor comment, but 'if IS_ENABLED(CONFIG_PCIEASPM)' is preferred over
#ifdef. Better compiler coverage and so on.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
