Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2C0EA396
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 19:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbfJ3Sqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 14:46:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44346 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbfJ3Sqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 14:46:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E85D6146D1209;
        Wed, 30 Oct 2019 11:46:41 -0700 (PDT)
Date:   Wed, 30 Oct 2019 11:46:41 -0700 (PDT)
Message-Id: <20191030.114641.2012853455550097455.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, venkatkumar.duvvuru@broadcom.com
Subject: Re: [PATCH net-next 1/7] bnxt_en: Add support for L2 rewrite
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572422375-7269-2-git-send-email-michael.chan@broadcom.com>
References: <1572422375-7269-1-git-send-email-michael.chan@broadcom.com>
        <1572422375-7269-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 11:46:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Wed, 30 Oct 2019 03:59:29 -0400

> +static int
> +bnxt_fill_l2_rewrite_fields(struct bnxt_tc_actions *actions,
> +			    u8 *eth_addr, u8 *eth_addr_mask)
> +{
 ...
> +		/* FW expects dmac to be in u16 array format */
> +		p = (u16 *)&eth_addr[0];
> +		for (j = 0; j < 3; j++)
> +			actions->l2_rewrite_dmac[j] = cpu_to_be16(*(p + j));

Assumes 16-bit alignment.

>  static int bnxt_tc_parse_actions(struct bnxt *bp,
>  				 struct bnxt_tc_actions *actions,
>  				 struct flow_action *flow_action)
>  {
> +	/* Used to store the L2 rewrite mask for dmac (6 bytes) followed by
> +	 * smac (6 bytes) if rewrite of both is specified, otherwise either
> +	 * dmac or smac
> +	 */
> +	u8 eth_addr_mask[ETH_ALEN * 2] = { 0 };
> +	/* Used to store the L2 rewrite key for dmac (6 bytes) followed by
> +	 * smac (6 bytes) if rewrite of both is specified, otherwise either
> +	 * dmac or smac
> +	 */
> +	u8 eth_addr[ETH_ALEN * 2] = { 0 };
 ...
> +	if (actions->flags & BNXT_TC_ACTION_FLAG_L2_REWRITE) {
> +		rc = bnxt_fill_l2_rewrite_fields(actions, eth_addr,
> +						 eth_addr_mask);

And yet...

If you explicitly align the local ethernet address variable(s) and
this is the only path into that bnxt_fill_l2_rewrite_fields() code,
then this can work properly and portably.

But as-is, it needs to be adjusted somehow.

Thank you.
