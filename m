Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B54A5A51D9
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiH2QdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiH2QdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:33:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7E2252B6;
        Mon, 29 Aug 2022 09:33:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1EE6FCE130F;
        Mon, 29 Aug 2022 16:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF56C433D6;
        Mon, 29 Aug 2022 16:32:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kNQTi4K8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1661790778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3F5bs6wEmRDmdIQe96V5iwCeWjK5YoVTeKEuPdxSfN4=;
        b=kNQTi4K8egLdu1zNarBL47SQOYWe4WMkhvHrAwskcAG/1adfCVQBMB0gvduSpWFDbav2Tj
        2LIfVOx4v++zHCwTjVPKSR+kizVUx5w5Af4coUKZm2ZWFtmVrqoa79XBz+/8OYj2RpZKfG
        GTXOi7IPk9NkM/oVEZTI4HyRLLvuSmE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1de32b3b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 29 Aug 2022 16:32:58 +0000 (UTC)
Date:   Mon, 29 Aug 2022 12:32:54 -0400
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, johannes@sipsolutions.net,
        linux-block@vger.kernel.org, osmocom-net-gprs@lists.osmocom.org,
        linux-wpan@vger.kernel.org, wireguard@lists.zx2c4.com,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-pm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        mptcp@lists.linux.dev, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        linux-security-module@vger.kernel.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net-next] genetlink: start to validate reserved header
 bytes
Message-ID: <YwzqNgj/bJoawrwh@zx2c4.com>
References: <20220825001830.1911524-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220825001830.1911524-1-kuba@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Aug 24, 2022 at 05:18:30PM -0700, Jakub Kicinski wrote:
> diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
> index d0f3b6d7f408..0c0644e762e5 100644
> --- a/drivers/net/wireguard/netlink.c
> +++ b/drivers/net/wireguard/netlink.c
> @@ -621,6 +621,7 @@ static const struct genl_ops genl_ops[] = {
>  static struct genl_family genl_family __ro_after_init = {
>  	.ops = genl_ops,
>  	.n_ops = ARRAY_SIZE(genl_ops),
> +	.resv_start_op = WG_CMD_SET_DEVICE + 1,
>  	.name = WG_GENL_NAME,
>  	.version = WG_GENL_VERSION,
>  	.maxattr = WGDEVICE_A_MAX,

FWIW, I wouldn't object to just leaving this at zero. I don't know of
any wireguard userspaces doing anything with the reserved header field.

Jason
