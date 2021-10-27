Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7164D43D693
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhJ0WbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhJ0WbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 18:31:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33D83610CA;
        Wed, 27 Oct 2021 22:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635373721;
        bh=2MWgc9xFJRquKdCnmaoqSNxkbFX03ApCi5nyauPyOmc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=cBdBzfdAdAkINzIgbrXaO5y9l2A+BINrDk7mb2q4gy2VVb7IeswvNWiznzS9b16kU
         w8QJTrNU+X7HHj8YmbAqp1bXVkdC8A9568J/e9QHNqcsPqcXxf7UZLK/jyDH3N5h/j
         e9P+imTe94dnr2jS//Kg+ogY1e4MmZLaXlWzEbK3t8k8q5XwQb0VEimyqdyUNnSMRd
         c4yG6gkw8MkBzpradbuwGKNe9di2GvXAVt0mIFqNfU+BeA/W1h0RPfztQeIBctzHEb
         m4r0dtUnWjW7IKS1ofXGsTprat02WqXE1Fsi+uOeEsyHQ9WtLSwAfgdVPiyxvFjh0d
         dNZLq6I3YAwjw==
Date:   Wed, 27 Oct 2021 17:28:39 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V10 4/8] PCI/sysfs: Add a 10-Bit Tag sysfs file PCIe
 Endpoint devices
Message-ID: <20211027222839.GA252933@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211009104938.48225-5-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 06:49:34PM +0800, Dongdong Liu wrote:
> PCIe spec 5.0 r1.0 section 2.2.6.2 says:
> 
>   If an Endpoint supports sending Requests to other Endpoints (as
>   opposed to host memory), the Endpoint must not send 10-Bit Tag
>   Requests to another given Endpoint unless an implementation-specific
>   mechanism determines that the Endpoint supports 10-Bit Tag Completer
>   capability.
> 
> Add a 10bit_tag sysfs file, write 0 to disable 10-Bit Tag Requester
> when the driver does not bind the device. The typical use case is for
> p2pdma when the peer device does not support 10-Bit Tag Completer.
> Write 1 to enable 10-Bit Tag Requester when RC supports 10-Bit Tag
> Completer capability. The typical use case is for host memory targeted
> by DMA Requests. The 10bit_tag file content indicate current status of
> 10-Bit Tag Requester Enable.

Don't we have a hole here?  We're adding knobs to control 10-Bit Tag
usage, but don't we have basically the same issues with Extended
(8-bit) Tags?

I wonder if we should be adding a more general "tags" file that can
manage both 8-bit and 10-bit tag usage.

> +static struct device_attribute dev_attr_10bit_tag = __ATTR(10bit_tag, 0644,
> +							   pci_10bit_tag_show,
> +							   pci_10bit_tag_store);

I think this should use DEVICE_ATTR().  Or even better, if the name
doesn't start with a digit, DEVICE_ATTR_RW().
