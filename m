Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C5F3FE647
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhIBAIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232490AbhIBAH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 20:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BBC561074;
        Thu,  2 Sep 2021 00:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630541221;
        bh=r8KhmDSfcNY9XJ0GmBDaGFAhw9qUTpabBfAaqeJDixI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AHHV7WGwxSSUPDfj0jOgREUS3e2e/APGEiazHuhgcdVh3sQqjHz+ecT4DbVrKEoTf
         LJ/7kuSqdQissTgba4VxQMqD+zk9W058kpRbw2wE2Isxo9znah+LV4hoLtlpy0YHiW
         l1VlZkdeph8RnCiOf11IFg1UzTsONn6M9b8baXvaxuvwt7oJwAO655Mc28/Pg2z4Dy
         Dev3LsLP5SE3C6btuiML+Iyydd+/p77kCQMQ7UDiTuMJHk1r48qf22IXch9nVSBF6U
         t9pbToVVnOKw7ODYkNBKJDY3FAbegzKCJGyDxN25aKA9y3DeanjjEuIIdhCT7O/mKK
         7Tqw1n9Tb1lAA==
Date:   Wed, 1 Sep 2021 17:07:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: Re: [PATCH net-next 10/11] ptp: ocp: Add IRIG-B output mode control
Message-ID: <20210901170700.4ad3c3fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830235236.309993-11-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
        <20210830235236.309993-11-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 16:52:35 -0700 Jonathan Lemon wrote:
> +	err = kstrtou8(buf, 0, &val);
> +	if (err)
> +		return err;
> +	if (val > 7)
> +		return -EINVAL;
> +
> +	reg = ((val & 0x7) << 16);
> +
> +	spin_lock_irqsave(&bp->lock, flags);
> +	iowrite32(0, &bp->irig_out->ctrl);		/* disable */
> +	iowrite32(reg, &bp->irig_out->ctrl);		/* change mode */
> +	iowrite32(reg | IRIG_M_CTRL_ENABLE, &bp->irig_out->ctrl);
> +	spin_unlock_irqrestore(&bp->lock, flags);

locking
