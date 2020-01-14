Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7434013AA7F
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 14:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgANNR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 08:17:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbgANNR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 08:17:28 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B223F24670;
        Tue, 14 Jan 2020 13:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579007847;
        bh=BWHcpNWsqWLrn1wqZgWuRyQzlrOFcXydfK+Ksfe9wOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eFcFChwW3JaeU9SJvM7vuHE+s/fzFEk0p7HDyEZBYh+Fw9Rxr2vSF3vaF8eDJvluQ
         S24I+4NaJnou47wbDCRNi2Ksy++V2SZDxmzbV9BLGgrgIeqUGIGYDNIdE8//TGj7lw
         Q6XNsU+wKn4cbzHuzvR7TiDB/3wYRhbW+VOYK5P4=
Date:   Tue, 14 Jan 2020 05:17:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v2 14/17] octeontx2-pf: Add basic ethtool support
Message-ID: <20200114051726.298ca7ad@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1578985340-28775-15-git-send-email-sunil.kovvuri@gmail.com>
References: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
        <1578985340-28775-15-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jan 2020 12:32:17 +0530, sunil.kovvuri@gmail.com wrote:
> +static const struct otx2_stat otx2_dev_stats[] = {
> +	OTX2_DEV_STAT(rx_bytes),
> +	OTX2_DEV_STAT(rx_frames),

> +	OTX2_DEV_STAT(rx_mcast_frames),
> +	OTX2_DEV_STAT(rx_drops),
> +
> +	OTX2_DEV_STAT(tx_bytes),
> +	OTX2_DEV_STAT(tx_frames),

> +	OTX2_DEV_STAT(tx_drops),

Why are these still here?

You are exposing the exact same stats via netlink:

+	stats->rx_bytes = dev_stats->rx_bytes;
+	stats->rx_packets = dev_stats->rx_frames;
+	stats->rx_dropped = dev_stats->rx_drops;
+	stats->multicast = dev_stats->rx_mcast_frames;
+
+	stats->tx_bytes = dev_stats->tx_bytes;
+	stats->tx_packets = dev_stats->tx_frames;
+	stats->tx_dropped = dev_stats->tx_drops;

We have been requiring that standard statistics are not duplicated in
ethtool since at least 2017. Example:

https://lore.kernel.org/netdev/20171006153059.193688a5@xeon-e3/

Please don't make me say this to you a third time :/

Also you have to provide a change long so reviewers know what changed
between v1 and v2. It's best to keep the changelog in the commit
messages (rather than hidden under ---) so the history is preserved.
