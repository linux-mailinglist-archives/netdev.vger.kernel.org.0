Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B8025DCAB
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgIDPBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730220AbgIDPBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 11:01:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1492073B;
        Fri,  4 Sep 2020 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599231692;
        bh=x7Uz1wo0AnOwROnBkDUJMp7U+rADv+5/ZghVeKySSi0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U9q72NIEAPA+Vffj16VmYPcvqAY7QPHTC0mr+5AdEbczeU+MeSCAto99sPQPj4OHC
         Es7aEMybUWwVieDU3ifPa3LaN0ewsZTKvz5fe2IlStXJ6n2BveEeJPWUj8Zmnv7jX4
         QZ9ZTRK0xgAs4tVMuy+bYzItLS5Z61BIIgXHLj4Y=
Date:   Fri, 4 Sep 2020 08:01:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 0/2] ionic: add devlink dev flash support
Message-ID: <20200904080130.53a66f32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904000534.58052-1-snelson@pensando.io>
References: <20200904000534.58052-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Sep 2020 17:05:32 -0700 Shannon Nelson wrote:
> Add support for using devlink's dev flash facility to update the
> firmware on an ionic device.  This is a simple model of pushing the
> firmware file to the NIC, asking the NIC to unpack and install the file
> into the device, and then selecting it for the next boot.  If any of
> these steps fail, the whole transaction is failed.
> 
> We don't currently support doing these steps individually.  In the future
> we want to be able to list the FW that is installed and selectable but
> don't yet have the API to fully support that.
> 
> v2: change "Activate" to "Select" in status messages

Thanks!

Slightly off-topic for these patches but every new C file in ionic adds
a set of those warnings (from sparse, I think, because it still builds):

../drivers/net/ethernet/pensando/ionic/ionic_debugfs.c: note: in included file (through ../drivers/net/ethernet/pensando/ionic/ionic.h):
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:37:1: error: static assertion failed: "sizeof(union ionic_dev_regs) == 4096"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:39:1: error: static assertion failed: "sizeof(union ionic_dev_cmd_regs) == 2048"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:55:1: error: static assertion failed: "sizeof(struct ionic_dev_getattr_comp) == 16"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:56:1: error: static assertion failed: "sizeof(struct ionic_dev_setattr_cmd) == 64"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:57:1: error: static assertion failed: "sizeof(struct ionic_dev_setattr_comp) == 16"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:67:1: error: static assertion failed: "sizeof(struct ionic_port_getattr_comp) == 16"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:77:1: error: static assertion failed: "sizeof(struct ionic_lif_getattr_comp) == 16"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:78:1: error: static assertion failed: "sizeof(struct ionic_lif_setattr_cmd) == 64"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:79:1: error: static assertion failed: "sizeof(struct ionic_lif_setattr_comp) == 16"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:81:1: error: static assertion failed: "sizeof(struct ionic_q_init_cmd) == 64"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:118:1: error: static assertion failed: "sizeof(struct ionic_vf_setattr_cmd) == 64"
../drivers/net/ethernet/pensando/ionic/ionic_dev.h:121:1: error: static assertion failed: "sizeof(struct ionic_vf_getattr_comp) == 16"

Any ideas on why?
