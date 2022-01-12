Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926B448CE8A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbiALWvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:51:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53428 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiALWvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:51:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB88BB82172
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 22:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FD9C36AE9;
        Wed, 12 Jan 2022 22:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642027871;
        bh=QGmmb1OKibMhzWKDRxBrRTjSGvqMAVNv69AClIgnfuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mz8VF4yLpnbiFHAlLM1K7Bdq7o5p8GQsoIvHUmVvtZ/YHbAz4RpPOpwTYfjClf8S6
         VX9sfc2EiIDoaJGsbU0NIGI2r4hDuxAWs0TxihOreEj0iRirgSf9QwfMjGcn2tIYbR
         vdj9JiVkEf7tVQP224BMZMIuacR0zfu4n5HyhOsoLGGexXxg48ShjWxIp8iw3WBsWS
         GPvwNUuhmYZqkfDbMlOuEEhP+subbqwVuS8j+77ZrM4E1LK0FC2gMqt9/T7Cc2NWhN
         UtYTSc4Eb3OBgyWlQfiaMYqzfbYJeNPf6kKgZlHXyky4Pgetw4nzf3AusuL9+mjXtX
         X51qT1d9fxKlQ==
Date:   Wed, 12 Jan 2022 14:51:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v6 3/8] net/funeth: probing and netdev ops
Message-ID: <20220112145110.1ba09f3c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110015636.245666-4-dmichail@fungible.com>
References: <20220110015636.245666-1-dmichail@fungible.com>
        <20220110015636.245666-4-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  9 Jan 2022 17:56:31 -0800 Dimitris Michailidis wrote:
> +static int funeth_sriov_configure(struct pci_dev *pdev, int nvfs)
> +{
> +	struct fun_dev *fdev = pci_get_drvdata(pdev);
> +	struct fun_ethdev *ed = to_fun_ethdev(fdev);
> +	int rc;
> +
> +	if (nvfs == 0) {
> +		if (pci_vfs_assigned(pdev)) {
> +			dev_warn(&pdev->dev,
> +				 "Cannot disable SR-IOV while VFs are assigned\n");
> +			return -EPERM;
> +		}
> +
> +		pci_disable_sriov(pdev);
> +		fun_free_vports(ed);
> +		return 0;
> +	}
> +
> +	rc = fun_init_vports(ed, nvfs);
> +	if (rc)
> +		return rc;

Also likely needs locking, not that sriov callback is called with
device lock held and VF configuration with rtnl_lock(), they can 
run in parallel.
