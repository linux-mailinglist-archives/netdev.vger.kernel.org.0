Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3CC48CE83
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbiALWp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiALWpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:45:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543EAC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:45:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EA47B82092
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 22:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3143C36AE9;
        Wed, 12 Jan 2022 22:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642027551;
        bh=vnhCRZOyBJRqHEx4Y49ns5EDpjKAIJlvwIMstTvw534=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y9LO94XTr4YjmUD4hhPuieYzh22LN6c/DfRDiIhZaHoJy9zdUYMzyobnbneOJPUZS
         fsaIYaV++H8DalJWYrdveNqqunF2w39lGvPuOzmOq9rA6NXPfZAMqBCV8DhAKIwiWl
         0HY9zm2aWuVPjNwKrwfy6CfS2xA4trLvgGWWZbbkaR8vPWHxNWhFywY9A1oF6QZket
         WT/aAayai6jgtA5sTb6hd2iGfLv6McxTWupU6VF56F7K6waCJPCsg2hUUq1SvQtlrC
         LOq/48GrNn/enZRPF7X/75ih+cgeIYDoI+IL+YSKkq5xbd4EPsWkXvycwPjgNI1K/+
         GVTIJ0TtRet8Q==
Date:   Wed, 12 Jan 2022 14:45:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v6 3/8] net/funeth: probing and netdev ops
Message-ID: <20220112144550.17c38ccd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
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
> +static void fun_update_link_state(const struct fun_ethdev *ed,
> +				  const struct fun_admin_port_notif *notif)
> +{
> +	unsigned int port_idx = be16_to_cpu(notif->id);
> +	struct net_device *netdev;
> +	struct funeth_priv *fp;
> +
> +	if (port_idx >= ed->num_ports)
> +		return;
> +
> +	netdev = ed->netdevs[port_idx];
> +	fp = netdev_priv(netdev);
> +
> +	write_seqcount_begin(&fp->link_seq);
> +	fp->link_speed = be32_to_cpu(notif->speed) * 10;  /* 10 Mbps->Mbps */
> +	fp->active_fc = notif->flow_ctrl;
> +	fp->active_fec = notif->fec;
> +	fp->xcvr_type = notif->xcvr_type;
> +	fp->link_down_reason = notif->link_down_reason;
> +	fp->lp_advertising = be64_to_cpu(notif->lp_advertising);
> +
> +	if ((notif->link_state | notif->missed_events) & FUN_PORT_FLAG_MAC_DOWN)
> +		netif_carrier_off(netdev);
> +	if (notif->link_state & FUN_PORT_FLAG_MAC_UP)
> +		netif_carrier_on(netdev);
> +
> +	write_seqcount_end(&fp->link_seq);
> +	fun_report_link(netdev);
> +}
> +
> +/* handler for async events delivered through the admin CQ */
> +static void fun_event_cb(struct fun_dev *fdev, void *entry)
> +{
> +	u8 op = ((struct fun_admin_rsp_common *)entry)->op;
> +
> +	if (op == FUN_ADMIN_OP_PORT) {
> +		const struct fun_admin_port_notif *rsp = entry;
> +
> +		if (rsp->subop == FUN_ADMIN_SUBOP_NOTIFY) {
> +			fun_update_link_state(to_fun_ethdev(fdev), rsp);

Is there locking between service task and admin queue events?
