Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C65CC164EE3
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgBST21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:28:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBST20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 14:28:26 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 383D5208E4;
        Wed, 19 Feb 2020 19:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582140506;
        bh=FOmORJhVmV3KE0+llUTjTXD7btcekZwPY5GgW59XA2U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YPX4MtPtQKbgShixaAcw3sNi+oWFEtd6PCTW+1ASEAQXcVsVV2gQu/DDN4foAnDLA
         SEL5RwqzsxFKo6JsqYUSl9MmlJot9xNQfVhwqQq6gYL1NdFtCTXONl/+6hl4FDB+8R
         Ha96KTiuv4vmgVnKPZ73hk3eJssdqXcj8ZJ+PxJ8=
Date:   Wed, 19 Feb 2020 11:28:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, manojmalviya@chelsio.com
Subject: Re: [PATCH net v4] net/tls: Fix to avoid gettig invalid tls record
Message-ID: <20200219112824.4c7e31fc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200219041022.22701-1-rohitm@chelsio.com>
References: <20200219041022.22701-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 09:40:22 +0530 Rohit Maheshwari wrote:
> Current code doesn't check if tcp sequence number is starting from (/after)
> 1st record's start sequnce number. It only checks if seq number is before
> 1st record's end sequnce number. This problem will always be a possibility
> in re-transmit case. If a record which belongs to a requested seq number is
> already deleted, tls_get_record will start looking into list and as per the
> check it will look if seq number is before the end seq of 1st record, which
> will always be true and will return 1st record always, it should in fact
> return NULL.
> As part of the fix, start looking each record only if the sequence number
> lies in the list else return NULL.
> There is one more check added, driver look for the start marker record to
> handle tcp packets which are before the tls offload start sequence number,
> hence return 1st record if the record is tls start marker and seq number is
> before the 1st record's starting sequence number.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

FWIW you could have kept the review tag from Boris, the change to v4 
was minor.

Thanks!
