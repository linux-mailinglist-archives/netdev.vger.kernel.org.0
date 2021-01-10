Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAF22F04F9
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 04:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbhAJDm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 22:42:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbhAJDm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 22:42:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C3BC22CAF;
        Sun, 10 Jan 2021 03:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610250107;
        bh=h+50fGKeFQtYlMXu/fIQnsSRsZq1Yjew4btVtGFaEBo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sVliSDJIuq0hJK5HmG9AlkAxRmd6N8M5q2h7YgOF5/5pWc71xWO7H7IL8ini1MOjT
         lQWHHkPWuTykMQiRRDlxWQfBuGhL/ZJX6JjYF7ztPrGNGwiQMbX+Lwb1U8bzA4l+bH
         9R0A0GZQ/s0DtEQI2jozdF+oaIBPltpKvPkIcDG4+rVE+tsOzW5GhXx6pbHB7BwNgY
         768MVjE8zPRiMukijJVN7i47INesHdv82vHXubUF/dCf07amSCJL2Wy3M/8DlsyN1q
         qruM4SF0d4X5m6mIEFi+af5Xfka/nf6STineZ5+r+EI+YMG05/n1rRO7PQWvVS0s8x
         bGIllS6XhGyyA==
Date:   Sat, 9 Jan 2021 19:41:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH 5/7] ibmvnic: use a lock to serialize remove/reset
Message-ID: <20210109194146.7c8ac5ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210108071236.123769-6-sukadev@linux.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
        <20210108071236.123769-6-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 23:12:34 -0800 Sukadev Bhattiprolu wrote:
> Use a separate lock to serialze ibmvnic_reset() and ibmvnic_remove()
> functions. ibmvnic_reset() schedules work for the worker thread and
> ibmvnic_remove() flushes the work before removing the adapter. We
> don't want any work to be scheduled once we start removing the
> adapter (i.e after we have already flushed the work).

Locking based on functions, not on data being accessed is questionable
IMO. If you don't want work to be scheduled isn't it enough to have a
bit / flag that you set to let other flows know not to schedule reset?

> @@ -5459,6 +5464,7 @@ static int ibmvnic_remove(struct vio_dev *dev)
>  {
>  	struct net_device *netdev = dev_get_drvdata(&dev->dev);
>  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
> +	unsigned long rmflags;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&adapter->state_lock, flags);
> @@ -5467,7 +5473,15 @@ static int ibmvnic_remove(struct vio_dev *dev)
>  		return -EBUSY;
>  	}

> +	spin_lock_irqsave(&adapter->remove_lock, rmflags);

You can just use flags again, no need for separate variables.

>  	adapter->state = VNIC_REMOVING;
> +	spin_unlock_irqrestore(&adapter->remove_lock, rmflags);
