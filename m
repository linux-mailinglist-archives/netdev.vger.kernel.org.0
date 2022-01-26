Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1F149C234
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiAZDi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiAZDi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:38:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C8FC06161C;
        Tue, 25 Jan 2022 19:38:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7C93616F7;
        Wed, 26 Jan 2022 03:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB66C340E3;
        Wed, 26 Jan 2022 03:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643168308;
        bh=YrT0X0ihycvNsGpgFSU6siPAt6t2EfDiz6/xejc9MkA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=udilF3BWz+9QtxaxXyqQTW5IlTYnNzT3MqygYePWn3uKgxKLWkDXscTzrwAtGXTpN
         QIABQ9RHUZm/wfstzEg7l2eL8hGTVGsrD8ZBB8vfg1yppxMNpI4tc0xCCGDeePP1DP
         70K8y8lY7mEyYGLi6uOin0AY+OOGBYL0Poc7f7HOedRnZiQQ4g5V78ucWDiCDOE8QS
         9kQ3/VzsPjHsunO5Spzmrt3S4wAdqjnZzV5Z9BGJRusb+UtfYcuj1pSHumZsWVTCEp
         84dBypcNXaiKkmIwdNi3Zie3Qsy28PBfdyGTCyAzs6EYfwI7poXLeYdf33XMOGxyP7
         zc6CcSKi/FpFw==
Date:   Tue, 25 Jan 2022 19:38:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        rostedt@goodmis.org, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH net-next] net: drop_monitor: support drop reason
Message-ID: <20220125193826.58ee023f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124075955.1232426-1-imagedong@tencent.com>
References: <20220124075955.1232426-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 15:59:55 +0800 menglong8.dong@gmail.com wrote:
> @@ -606,6 +608,7 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
>  static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>  				     size_t payload_len)
>  {
> +	enum skb_drop_reason reason = NET_DM_SKB_CB(skb)->reason;
>  	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;

nit: maybe it's better to get a pointer to struct net_dm_skb_cb here
instead of local var for each field?

>  	char buf[NET_DM_MAX_SYMBOL_LEN];
>  	struct nlattr *attr;
> @@ -623,6 +626,9 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>  	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
>  		goto nla_put_failure;
>  
> +	if (nla_put_u32(msg, NET_DM_ATTR_REASON, reason))
> +		goto nla_put_failure;
