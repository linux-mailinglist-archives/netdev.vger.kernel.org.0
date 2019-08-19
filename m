Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE93A95209
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfHSX77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 19:59:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728580AbfHSX77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 19:59:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 502E4149C9232;
        Mon, 19 Aug 2019 16:59:58 -0700 (PDT)
Date:   Mon, 19 Aug 2019 16:59:55 -0700 (PDT)
Message-Id: <20190819.165955.1428577625599018007.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     jeffrey.t.kirsher@intel.com, paul.greenwalt@intel.com,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        andrewx.bowers@intel.com
Subject: Re: [net-next v2 04/14] ice: fix set pause param autoneg check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190819161142.6f4cc14d@cakuba.netronome.com>
References: <20190819161708.3763-1-jeffrey.t.kirsher@intel.com>
        <20190819161708.3763-5-jeffrey.t.kirsher@intel.com>
        <20190819161142.6f4cc14d@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 16:59:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 19 Aug 2019 16:11:42 -0700

> On Mon, 19 Aug 2019 09:16:58 -0700, Jeff Kirsher wrote:
>> +	pcaps = devm_kzalloc(&vsi->back->pdev->dev, sizeof(*pcaps),
>> +			     GFP_KERNEL);
>> +	if (!pcaps)
>> +		return -ENOMEM;
>> +
>> +	/* Get current PHY config */
>> +	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
>> +				     NULL);
>> +	if (status) {
>> +		devm_kfree(&vsi->back->pdev->dev, pcaps);
>> +		return -EIO;
>> +	}
>> +
>> +	is_an = ((pcaps->caps & ICE_AQC_PHY_AN_MODE) ?
>> +			AUTONEG_ENABLE : AUTONEG_DISABLE);
>> +
>> +	devm_kfree(&vsi->back->pdev->dev, pcaps);
> 
> Is it just me or is this use of devm_k*alloc absolutely pointless?

Yeah it looks like an overzealous use of these interfaces to me too.
