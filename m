Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1B29C8C6
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 07:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfHZFrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 01:47:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58730 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZFrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 01:47:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCC92152366BE;
        Sun, 25 Aug 2019 22:47:40 -0700 (PDT)
Date:   Sun, 25 Aug 2019 22:47:40 -0700 (PDT)
Message-Id: <20190825.224740.1795212985640138995.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: Re: [PATCH net-next 04/14] bnxt_en: Handle firmware reset status
 during IF_UP.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566791705-20473-5-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
        <1566791705-20473-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Aug 2019 22:47:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 25 Aug 2019 23:54:55 -0400

> @@ -7005,7 +7005,9 @@ static int __bnxt_hwrm_ver_get(struct bnxt *bp, bool silent)
>  
>  	rc = bnxt_hwrm_do_send_msg(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT,
>  				   silent);
> -	return rc;
> +	if (rc)
> +		return -ENODEV;
> +	return 0;
>  }
>  
>  static int bnxt_hwrm_ver_get(struct bnxt *bp)
 ...
> @@ -8528,26 +8533,53 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
>  		req.flags = cpu_to_le32(FUNC_DRV_IF_CHANGE_REQ_FLAGS_UP);
>  	mutex_lock(&bp->hwrm_cmd_lock);
>  	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
> -	if (!rc && (resp->flags &
> -		    cpu_to_le32(FUNC_DRV_IF_CHANGE_RESP_FLAGS_RESC_CHANGE)))
> -		resc_reinit = true;
> +	if (!rc)
> +		flags = le32_to_cpu(resp->flags);
>  	mutex_unlock(&bp->hwrm_cmd_lock);
> +	if (rc)
> +		return -EIO;

Following up to my other review comments, if _hwrm_send_message() et
al. returned consistently proper error codes instead of sometimes -1,
couldn't you avoid at least some of these 'rc' remappings?
