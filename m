Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CD135E657
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347681AbhDMS2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231793AbhDMS2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 14:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58C43613BD;
        Tue, 13 Apr 2021 18:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618338472;
        bh=Fzsk7f5RmKzPeMZiMbTfnwtDcusg+yxYojO3PgnnePQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aiDBNiHOmHNausp3CLpyVOP2n54aHvfrqJvBarKeJScoH5Hp3iJfhK0CBMvYGH5Mi
         Kr2MZ8xntpn7OD8rbhWrvvF8zB88qTb1RkFGcaxOj58IV2hOs+fVVfFy3b77ZdSuSU
         hmqkcaCcWFukqr5ecvQnEz5VXw8zI5+DDjElb0FPc6UUI7O86PfjjSpJ7q/F08J0a6
         2r+St6p3rwIgkdiGvDXQoNs3OuPHNrov9CDWJUP/l5kLfVd+ZOInjrzP30Ytmquiws
         SLlZW4PL/jx+BPeqcgPsXKAr/PeHrO3sZWc1qgJQXRPRufpZ2S/NOoDxvsD2FZud64
         y+2WqgkFI/LKg==
Date:   Tue, 13 Apr 2021 11:27:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     gregkh@linuxfoundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        aleksander@aleksander.es, dcbw@redhat.com
Subject: Re: [PATCH net-next v10 1/2] net: Add a WWAN subsystem
Message-ID: <20210413112751.71621bb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1618255387-13532-1-git-send-email-loic.poulain@linaro.org>
References: <1618255387-13532-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Apr 2021 21:23:06 +0200 Loic Poulain wrote:
> This change introduces initial support for a WWAN framework. Given the
> complexity and heterogeneity of existing WWAN hardwares and interfaces,
> there is no strict definition of what a WWAN device is and how it should
> be represented. It's often a collection of multiple devices that perform
> the global WWAN feature (netdev, tty, chardev, etc).
> 
> One usual way to expose modem controls and configuration is via high
> level protocols such as the well known AT command protocol, MBIM or
> QMI. The USB modems started to expose them as character devices, and
> user daemons such as ModemManager learnt to use them.
> 
> This initial version adds the concept of WWAN port, which is a logical
> pipe to a modem control protocol. The protocols are rawly exposed to
> user via character device, allowing straigthforward support in existing
> tools (ModemManager, ofono...). The WWAN core takes care of the generic
> part, including character device management, and relies on port driver
> operations to receive/submit protocol data.
> 
> Since the different devices exposing protocols for a same WWAN hardware
> do not necessarily know about each others (e.g. two different USB
> interfaces, PCI/MHI channel devices...) and can be created/removed in
> different orders, the WWAN core ensures that all WAN ports contributing
> to the 'whole' WWAN feature are grouped under the same virtual WWAN
> device, relying on the provided parent device (e.g. mhi controller,
> USB device). It's a 'trick' I copied from Johannes's earlier WWAN
> subsystem proposal.
> 
> This initial version is purposely minimalist, it's essentially moving
> the generic part of the previously proposed mhi_wwan_ctrl driver inside
> a common WWAN framework, but the implementation is open and flexible
> enough to allow extension for further drivers.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

> +/**
> + * enum wwan_port_type - WWAN port types
> + * @WWAN_PORT_AT: AT commands
> + * @WWAN_PORT_MBIM: Mobile Broadband Interface Model control
> + * @WWAN_PORT_QMI: Qcom modem/MSM interface for modem control
> + * @WWAN_PORT_QCDM: Qcom Modem diagnostic interface
> + * @WWAN_PORT_FIREHOSE: XML based command protocol
> + * @WWAN_PORT_MAX
> + */
> +enum wwan_port_type {
> +	WWAN_PORT_AT,
> +	WWAN_PORT_MBIM,
> +	WWAN_PORT_QMI,
> +	WWAN_PORT_QCDM,
> +	WWAN_PORT_FIREHOSE,
> +	WWAN_PORT_MAX,
> +};

include/linux/wwan.h:28: warning: Enum value 'WWAN_PORT_MAX' not described in enum 'wwan_port_type'
