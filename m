Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E5A23EFF0
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 17:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgHGPXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 11:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgHGPXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 11:23:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A1FF21744;
        Fri,  7 Aug 2020 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596813782;
        bh=imJrgjyBjt5OpAidbLOuS+38ud+BPX2ei0lsMtqVdSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A4X/RHy/8VCFtaGGoT6mw/GtUxl0HrSB0xNkfXYKbJs1FAB9wOhjfxj4WC/eg49Nv
         67mxaxWm4GXTlYbQbtjOUwHd83OcHizg+DEdaOUI1dlsRbnPhexpbhB275S8s0bp02
         /gPeRNx8uO0pC2Ds0KXbBcEltSKvj3RXpBWeZl88=
Date:   Fri, 7 Aug 2020 08:23:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     <netdev@vger.kernel.org>, "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] vmxnet3: use correct tcp hdr length when
 packet is encapsulated
Message-ID: <20200807082300.27876448@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200807064345.5156-1-doshir@vmware.com>
References: <20200807064345.5156-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Aug 2020 23:43:45 -0700 Ronak Doshi wrote:
> 'Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
> support")' added support for encapsulation offload. However, while

nit: no need for the quotes around commit xzy ("")

> calculating tcp hdr length, it does not take into account if the
> packet is encapsulated or not.
> 
> This patch fixes this issue by using correct reference for inner
> tcp header.
> 
> Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
> support")

Please don't wrap Fixes tags, let it overflow the line.

> Signed-off-by: Ronak Doshi <doshir@vmware.com>
> Acked-by: Guolin Yang <gyang@vmware.com>
> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c | 3 ++-
>  drivers/net/vmxnet3/vmxnet3_int.h | 4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index ca395f9679d0..2818015324b8 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -886,7 +886,8 @@ vmxnet3_parse_hdr(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
>  
>  			switch (protocol) {
>  			case IPPROTO_TCP:
> -				ctx->l4_hdr_size = tcp_hdrlen(skb);
> +				ctx->l4_hdr_size = skb->encapsulation ? inner_tcp_hdrlen(skb) :
> +						   tcp_hdrlen(skb);
>  				break;
>  			case IPPROTO_UDP:
>  				ctx->l4_hdr_size = sizeof(struct udphdr);
> diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
> index 5d2b062215a2..f99e3327a7b0 100644
> --- a/drivers/net/vmxnet3/vmxnet3_int.h
> +++ b/drivers/net/vmxnet3/vmxnet3_int.h
> @@ -69,12 +69,12 @@
>  /*
>   * Version numbers
>   */
> -#define VMXNET3_DRIVER_VERSION_STRING   "1.5.0.0-k"
> +#define VMXNET3_DRIVER_VERSION_STRING   "1.5.1.0-k"

Please don't do this.

We are working on removing all the driver version strings from the
kernel because upstream they are strictly inferior to the kernel
version alone.

For a fix like this it's especially bad to bump the version, as it
could cause a conflict during backporting. I'm not saying it will in
this case, but as a general rule fixes should be minimal in size.

>  /* Each byte of this 32-bit integer encodes a version number in
>   * VMXNET3_DRIVER_VERSION_STRING.
>   */
> -#define VMXNET3_DRIVER_VERSION_NUM      0x01050000
> +#define VMXNET3_DRIVER_VERSION_NUM      0x01050100
>  
>  #if defined(CONFIG_PCI_MSI)
>  	/* RSS only makes sense if MSI-X is supported. */

