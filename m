Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9B31CE1CE
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 19:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbgEKRfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 13:35:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56351 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729698AbgEKRfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 13:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589218529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DkERDwbu60qawRTAg04gZYIhFHJzw+aEIsFm2MJGBKs=;
        b=JtEcZS8aYLUgh7T52Qobo3nJ6l1Dayd+1bw28fAc0RhOIIWsHroMr7zMcOl04zRoDTScr/
        eaqdObBfW5FeeDDBxsF8Gmc3weEyhgEB0l9SiZ1/XB7uiQwNzTKJwpP+FYuk3gHm+Tvxos
        YE4/EMIBBG4ZCNVKUB41Q0Cc5qYwuMc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-YHV2K2eLP6ybwZwC3InEmw-1; Mon, 11 May 2020 13:35:25 -0400
X-MC-Unique: YHV2K2eLP6ybwZwC3InEmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB12C107ACF2;
        Mon, 11 May 2020 17:35:23 +0000 (UTC)
Received: from ovpn-114-155.ams2.redhat.com (ovpn-114-155.ams2.redhat.com [10.36.114.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4309B5C1D3;
        Mon, 11 May 2020 17:35:22 +0000 (UTC)
Message-ID: <6b0594845f7787b9bc82c845321e23b6bc3bca38.camel@redhat.com>
Subject: Re: [MPTCP] [PATCH net] mptcp: Initialize map_seq upon subflow
 establishment
From:   Paolo Abeni <pabeni@redhat.com>
To:     Christoph Paasch <cpaasch@apple.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Mon, 11 May 2020 19:35:21 +0200
In-Reply-To: <20200511162442.78382-1-cpaasch@apple.com>
References: <20200511162442.78382-1-cpaasch@apple.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-05-11 at 09:24 -0700, Christoph Paasch wrote:
> When the other MPTCP-peer uses 32-bit data-sequence numbers, we rely on
> map_seq to indicate how to expand to a 64-bit data-sequence number in
> expand_seq() when receiving data.
> 
> For new subflows, this field is not initialized, thus results in an
> "invalid" mapping being discarded.
> 
> Fix this by initializing map_seq upon subflow establishment time.
> 
> Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>
> ---
>  net/mptcp/protocol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index e1f23016ed3f..32ea8d35489a 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -1629,6 +1629,8 @@ bool mptcp_finish_join(struct sock *sk)
>  
>  	ret = mptcp_pm_allow_new_subflow(msk);
>  	if (ret) {
> +		subflow->map_seq = msk->ack_seq;
> +
>  		/* active connections are already on conn_list */
>  		spin_lock_bh(&msk->join_list_lock);
>  		if (!WARN_ON_ONCE(!list_empty(&subflow->node)))

Reviewed-by: Paolo Abeni <pabeni@redhat.com>

