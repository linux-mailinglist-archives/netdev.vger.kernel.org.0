Return-Path: <netdev+bounces-8651-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B05EE725113
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 02:16:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B6122810F3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 00:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC2C368;
	Wed,  7 Jun 2023 00:16:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB847C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 00:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86E9C433EF;
	Wed,  7 Jun 2023 00:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686096967;
	bh=CWFasZaJOed9oYdPj/iRxWloXiVd+HoiWc32ZvjGn6M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QJ6o6XBP1+rKTs0mr+FNRRl9AfnoHx2AQ6hfFsukq6JktBEkaeeUZusc93iTSG5/E
	 9X6nho+NYjfMMm4MXXUktFhM3DjojpG230V5REgbnYqzSTe6WKznZDJVy9Se6Xo9bx
	 7m6kWQaNMFVnBPvMnGc3ZKTxZmmzUmwPhhKNyZycVtSSpSkmbgkfkiWgedZPPj3Vjl
	 7XNtKYxhjZsP79OcL0uRfJORRPs5EQDCh7P8IVoWFRTQYThZx0L271g/UF/NvCmLRM
	 9t+PsjoPAXGeqPZnXF2+ETihM+O4FcsQ6fzWTqUZKVqjQ2yjuzvwrc03WjYvbH764j
	 2Rq0f8pfS86vg==
Date: Tue, 6 Jun 2023 17:16:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 bcm-kernel-feedback-list@broadcom.com, florian.fainelli@broadcom.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 opendmb@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, richardcochran@gmail.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v6 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <20230606171605.3c20ae79@kernel.org>
In-Reply-To: <956dc20f-386c-f4fe-b827-1a749ee8af02@broadcom.com>
References: <1685657551-38291-1-git-send-email-justin.chen@broadcom.com>
	<1685657551-38291-4-git-send-email-justin.chen@broadcom.com>
	<20230602235859.79042ff0@kernel.org>
	<956dc20f-386c-f4fe-b827-1a749ee8af02@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jun 2023 15:58:21 -0700 Justin Chen wrote:
> On 6/2/23 11:58 PM, Jakub Kicinski wrote:
> > On Thu,  1 Jun 2023 15:12:28 -0700 Justin Chen wrote:  
> >> +	/* general stats */
> >> +	STAT_NETDEV(rx_packets),
> >> +	STAT_NETDEV(tx_packets),
> >> +	STAT_NETDEV(rx_bytes),
> >> +	STAT_NETDEV(tx_bytes),
> >> +	STAT_NETDEV(rx_errors),
> >> +	STAT_NETDEV(tx_errors),
> >> +	STAT_NETDEV(rx_dropped),
> >> +	STAT_NETDEV(tx_dropped),
> >> +	STAT_NETDEV(multicast),  
> > 
> > please don't report standard interface stats in ethtool -S
> >   
> 
> These are not netdev statistics but MAC block counters. Guess it is not 
> clear with the naming here, will fix this. We have a use case where the 
> MAC traffic may be redirected from the associated net dev, so the 
> counters may not be the same.

You seem to be dumping straight from the stats member of struct
net_device:

+		if (s->type == BCMASP_STAT_NETDEV)
+			p = (char *)&dev->stats;

No?

Also - can you describe how you can have multiple netdevs for 
the same MAC?

