Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D95432A2F
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhJRXRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233672AbhJRXRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 19:17:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B32E860FDA;
        Mon, 18 Oct 2021 23:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634598934;
        bh=RTtOcBjn9UVPJ9ZFTRIJPVSoOaxi+gyDBG8UHF2l1Bk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jrVzVHCccp7jd+oV5wbcVkVhXwn65h26wCNH5HhSvOCyOyyJ7BuEw17UAJ+y9mwzp
         MVYv7Ln4jpGpTO7/7c88TIvVgpoFLd32eMYGe/hR4I/5T5Nds2cUtenBoZ8l3DMfit
         Wa6vA8CCzggPP5GijDDrqBGyxGoUB4mAbKxRG4iazjjhLav719n/VKNL0inyVmFbg8
         F4is5rLj6iM9QWrMNl837j9LevyOL3Y4mU1TEdMj65Q4Yvtcfs1zSJETwPjMtL9ta8
         zD3J+CHjUSsGw5Jgu1kgJERvGUFORCIozN8r0g1nRlJVUqLjoK1hKTPyCWXSd+5bCb
         no4UB4yWdNe7g==
Date:   Mon, 18 Oct 2021 16:15:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <dkirjanov@suse.de>
Cc:     Zheyu Ma <zheyuma97@gmail.com>, isdn@linux-pingi.de,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN: Fix return values of the probe function
Message-ID: <20211018161533.55691170@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <02fe8f6c-e332-5286-a759-750f47c3512a@suse.de>
References: <1634566838-3804-1-git-send-email-zheyuma97@gmail.com>
        <02fe8f6c-e332-5286-a759-750f47c3512a@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 20:06:51 +0300 Denis Kirjanov wrote:
> 10/18/21 5:20 PM, Zheyu Ma =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > During the process of driver probing, the probe function should return =
< 0
> > for failure, otherwise, the kernel will treat value > 0 as success. =20
>=20
> setup_card() checks for the return value.
> Thus it makes sense to submit the patch with net-next tag

setup_card() propagates the value returned by setup_hw() which in turn
gets propagated by hfc_probe() and hits local_pci_probe():

	/*
	 * Probe function should return < 0 for failure, 0 for success
	 * Treat values > 0 as success, but warn.
	 */
	pci_warn(pci_dev, "Driver probe function unexpectedly returned %d\n",
		 rc);
	return 0;

But you're right, this is a minor bug, hfc_remove_pci() checks if
driver data is already NULL so there will be no crash. Just a driver
bound to a device even though probe failed. Still net material tho.
