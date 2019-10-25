Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B230AE468F
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408650AbfJYJCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:02:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30808 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2408305AbfJYJCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571994166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qyvnOyTtmihc9tF/xt9r5Q0bXWKANiskgnWCt9PFrsA=;
        b=FQsRqkJ7vlF9+DK6L9izejnIrNmtGiL5F1sVYgTkCjiCSqYVyA40q1KUFEaFDl3Xj3mMxR
        y2sTj/x1G6sfPBKNMy0uEmmdT70RKKFkxcfBMPL1elSWvt5hcE+p3I/Ne+7gBEA+Jqx47Q
        wUViDsmnhXWpAxw4Kmyd0FV5X5Xl4fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-Ul04umbTO-2FOPBourXFhA-1; Fri, 25 Oct 2019 05:02:43 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30B99476;
        Fri, 25 Oct 2019 09:02:42 +0000 (UTC)
Received: from localhost (unknown [10.43.2.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA11A57AE;
        Fri, 25 Oct 2019 09:02:38 +0000 (UTC)
Date:   Fri, 25 Oct 2019 11:02:36 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org, nbd@nbd.name,
        lorenzo.bianconi@redhat.com, oleksandr@natalenko.name,
        netdev@vger.kernel.org
Subject: Re: [PATCH wireless-drivers 2/2] mt76: dma: fix buffer unmap with
 non-linear skbs
Message-ID: <20191025090236.GB14818@redhat.com>
References: <cover.1571868221.git.lorenzo@kernel.org>
 <1f7560e10edd517bfd9d3c0dd9820e6f420726b6.1571868221.git.lorenzo@kernel.org>
 <20191024081816.GA2440@redhat.com>
 <20191024090148.GC9346@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <20191024090148.GC9346@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Ul04umbTO-2FOPBourXFhA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 11:01:48AM +0200, Lorenzo Bianconi wrote:
> > On Thu, Oct 24, 2019 at 12:23:16AM +0200, Lorenzo Bianconi wrote:
> > > mt76 dma layer is supposed to unmap skb data buffers while keep txwi
> > > mapped on hw dma ring. At the moment mt76 wrongly unmap txwi or does
> > > not unmap data fragments in even positions for non-linear skbs. This
> > > issue may result in hw hangs with A-MSDU if the system relies on IOMM=
U
> > > or SWIOTLB. Fix this behaviour properly unmapping data fragments on
> > > non-linear skbs.
> >=20
> > If we have to keep txwi mapped, before unmap fragments, when then
> > txwi is unmaped ?
>=20
> txwi are mapped when they are crated in mt76_alloc_txwi(). Whenever we ne=
ed to
> modify them we sync the DMA in mt76_dma_tx_queue_skb(). txwi are unmapped=
 in
> mt76_tx_free() at driver unload.

So not only txwi is wrongly unmapped on runtime, but we can call
dma_sync_single_for_cpu/device() after dma_unmap_single().
That serious bug, good you spotted it and fixed!

Stanislaw

