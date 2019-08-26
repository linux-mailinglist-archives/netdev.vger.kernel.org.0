Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7922E9C8B3
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 07:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbfHZFgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 01:36:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbfHZFgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 01:36:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D142151397A0;
        Sun, 25 Aug 2019 22:36:04 -0700 (PDT)
Date:   Sun, 25 Aug 2019 22:36:03 -0700 (PDT)
Message-Id: <20190825.223603.2113058192469260500.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: Re: [PATCH net-next 03/14] bnxt_en: Refactor bnxt_sriov_enable().
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566791705-20473-4-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
        <1566791705-20473-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Aug 2019 22:36:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 25 Aug 2019 23:54:54 -0400

> @@ -687,6 +687,32 @@ static int bnxt_func_cfg(struct bnxt *bp, int num_vfs)
>  		return bnxt_hwrm_func_cfg(bp, num_vfs);
>  }
>  
> +int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
> +{
> +	int rc;
> +
> +	/* Register buffers for VFs */
> +	rc = bnxt_hwrm_func_buf_rgtr(bp);
> +	if (rc)
> +		return rc;
> +
> +	/* Reserve resources for VFs */
> +	rc = bnxt_func_cfg(bp, *num_vfs);
> +	if (rc != *num_vfs) {

I notice that these two operations are reversed here from where they were in the
bnxt_sriov_enable() function.  Does the BUF_RGTR operation have to be undone if
the bnxt_func_cfg() fails?

When it's not a straight extraction of code into a helper function one really
should do one of two things in my opinion:

1) Explain the differences in the commit message.

2) Do a straight extration in one commit, change the ordering in another.
