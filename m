Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676D228E94F
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732093AbgJNXzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgJNXzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:55:12 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9A020704;
        Wed, 14 Oct 2020 23:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602719712;
        bh=inl9rGGBsXiQj0KfmL/vEuhEcstZGazKvgv9Sglb54g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gB0s1vVgtjlRBmb29SLqvcT+xk0sCUHmTbpC8/aZqKjYQVavPwWLktHjhrrbIQL2f
         GLKrasnvrxWfHTPLjMjl2DjN77pTsIKk1/bkul3rso/nMMXVedYz6MUdVM4GsWaaSU
         2MOjRrnq+eeIdF4sOhDirduYWRstCVO+ClNFXA5E=
Date:   Wed, 14 Oct 2020 16:55:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>
Subject: Re: [PATCH v7,net-next,03/13] octeontx2-af: add debugfs entries for
 CPT block
Message-ID: <20201014165510.47fa70b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012105719.12492-4-schalla@marvell.com>
References: <20201012105719.12492-1-schalla@marvell.com>
        <20201012105719.12492-4-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 16:27:09 +0530 Srujana Challa wrote:
> +static ssize_t rvu_dbg_cpt_cmd_parser(struct file *filp,
> +				      const char __user *buffer, size_t count,
> +				      loff_t *ppos)
> +{
> +	struct seq_file *s = filp->private_data;
> +	struct rvu *rvu = s->private;
> +	char *cmd_buf;
> +	int ret = 0;
> +
> +	if ((*ppos != 0) || !count)
> +		return -EINVAL;
> +
> +	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
> +	if (!cmd_buf)
> +		return -ENOSPC;
> +
> +	if (parse_cpt_cmd_buffer(cmd_buf, &count, buffer,
> +				 rvu->rvu_dbg.cpt_ctx.e_type) < 0)
> +		ret = -EINVAL;
> +
> +	kfree(cmd_buf);
> +
> +	if (ret)
> +		return -EINVAL;
> +
> +	return count;
> +}

No command parsers in debugfs, please. 

Expose read only files for objects you want to be able to dump.
