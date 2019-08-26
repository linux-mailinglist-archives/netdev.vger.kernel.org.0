Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB7C9C8C7
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 07:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfHZFtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 01:49:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfHZFtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 01:49:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57D7115247482;
        Sun, 25 Aug 2019 22:49:13 -0700 (PDT)
Date:   Sun, 25 Aug 2019 22:49:13 -0700 (PDT)
Message-Id: <20190825.224913.1760774642952210371.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: Re: [PATCH net-next 05/14] bnxt_en: Discover firmware error
 recovery capabilities.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566791705-20473-6-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
        <1566791705-20473-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Aug 2019 22:49:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 25 Aug 2019 23:54:56 -0400

> +static int bnxt_hwrm_error_recovery_qcfg(struct bnxt *bp)
> +{
> +	struct hwrm_error_recovery_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
> +	struct bnxt_fw_health *fw_health = bp->fw_health;
> +	struct hwrm_error_recovery_qcfg_input req = {0};
> +	int rc, i;
> +
> +	if (!(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
> +		return 0;
> +
> +	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_ERROR_RECOVERY_QCFG, -1, -1);
> +	mutex_lock(&bp->hwrm_cmd_lock);
> +	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
> +	if (rc) {
> +		rc = -EOPNOTSUPP;
> +		goto err_recovery_out;
> +	}

How is this logically an unsupported operation if you're guarding it's use
with an appropriate capability check?
