Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341B249D84F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbiA0CsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiA0CsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:48:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C981C06161C;
        Wed, 26 Jan 2022 18:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 372AA61514;
        Thu, 27 Jan 2022 02:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DC2C340E7;
        Thu, 27 Jan 2022 02:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643251693;
        bh=5ubN8J9eTXlOAhRffuZB09n0xdyHwozsE4Im9F3XpJI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qw1ms4SAHiuikXXf0p7hg0HuCWFa4DrxLBg0GA9v0kJlia9WRMp3tqy8pF/RRdXNX
         yoxHSHgwI+fqNkylOl4jhNfJ4vMnQPeb6ZEamF9yh2nOtMueZhg9fX5oRcjj7C+8Vj
         Q6j66Gj9v3NDyBtsXBqIYemCTjOV3Jy4rBx8vM0o0AC1PQptpmvQUduHUJFsQpu4v7
         RfO5j79eHRQLsx8ogkC98dl1ueB8g+l3CJ0XHT2OlFtDcirUH6wL/TYWyr18M0aaMf
         m6+vJnsjaPTgZh7VzGnJ6o6JOzqaZ/Q3IhfKYpFbco/IonAkUFRrdqBAJOPJzMkXXp
         u5Tw2WyKw8FkA==
Date:   Wed, 26 Jan 2022 18:48:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        rostedt@goodmis.org, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH v2 net-next] net: drop_monitor: support drop reason
Message-ID: <20220126184812.32510ab4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220126072306.3218272-1-imagedong@tencent.com>
References: <20220126072306.3218272-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 15:23:06 +0800 menglong8.dong@gmail.com wrote:
> @@ -606,12 +610,17 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
>  static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>  				     size_t payload_len)
>  {
> -	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
> +	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
>  	char buf[NET_DM_MAX_SYMBOL_LEN];
> +	enum skb_drop_reason reason;
>  	struct nlattr *attr;
>  	void *hdr;
> +	u64 pc;
>  	int rc;
>  
> +	pc = (u64)(uintptr_t)cb->pc;
> +	reason = cb->reason;
> +
>  	hdr = genlmsg_put(msg, 0, 0, &net_drop_monitor_family, 0,
>  			  NET_DM_CMD_PACKET_ALERT);
>  	if (!hdr)
> @@ -623,6 +632,9 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>  	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
>  		goto nla_put_failure;
>  
> +	if (nla_put_u32(msg, NET_DM_ATTR_REASON, reason))

Why the temporary variable instead of referring to cb->reason directly?

> +		goto nla_put_failure;
