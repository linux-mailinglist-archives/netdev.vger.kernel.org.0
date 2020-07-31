Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631E6233CAC
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbgGaAoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730892AbgGaAoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 20:44:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7CB62074B;
        Fri, 31 Jul 2020 00:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596156284;
        bh=GbKkbu/VaSMbcgkvHfHf8svPKzGIhQa+orkjjlthAjQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MyUHWrmYMaiHfOZqwiDSvAPIYYU+0LwIfARzxa2MAwid81myzKIW4zh6bTe7S3O6L
         Ze5OnIhFudYFpRzav/Uvdb+BsZrushBL8cyaSJm01svG4FwY6uV1Id8gGqvO6xWp1z
         sv9ViKLEvQZ6zFNL/8THlMyYBlGdMXmY6ITnEMWk=
Date:   Thu, 30 Jul 2020 17:44:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 3/3] ionic: separate interrupt for Tx and Rx
Message-ID: <20200730174442.6bb9e652@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200731000058.37344-4-snelson@pensando.io>
References: <20200731000058.37344-1-snelson@pensando.io>
        <20200731000058.37344-4-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020 17:00:58 -0700 Shannon Nelson wrote:
> +	max_cnt = lif->ionic->ntxqs_per_lif;
> +	if (ch->combined_count) {
> +		if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state) &&
> +		    (ch->combined_count == lif->nxqs)) {
> +			netdev_info(netdev, "No change a\n");
> +			return 0;
> +		}
> +
> +		netdev_info(netdev, "Changing queue count from %d to %d\n",
> +			    lif->nxqs, ch->combined_count);
> +	} else {
> +		max_cnt /= 2;
> +		if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state) &&
> +		    (ch->rx_count == lif->nxqs)) {
> +			netdev_info(netdev, "No change b\n");
> +			return 0;
> +		}
> +
> +		netdev_info(netdev, "Changing queue count from %d to %d\n",
> +			    lif->nxqs, ch->rx_count);
> +	}

A little verbose there with the printin' but overall looks reasonable:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
