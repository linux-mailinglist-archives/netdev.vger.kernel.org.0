Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E4723AAB7
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgHCQnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:43:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43578 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727044AbgHCQm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:42:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596472977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pPK2wcTB1Ryz7AOqV0SyPoYd10D2phGLwGSDlki7OQ8=;
        b=fZIIPoGCy8wE+MTm45Qf6RV5EagtW4QWGkj6QjGSqxTnhgb5hnNMTShsAhKaGC3konzF2R
        yj7frANsHcWO+3jKZjUoAwF9tdkDEEkYT8fkz+ImZ3I/nFcYYFiRvdQpnkD8oUj1THCj3G
        ccB6dKgYG944+B0RrI4eSCLYTXFpz8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-4OtiSIiIO6i-aXbkaJW6SQ-1; Mon, 03 Aug 2020 12:42:53 -0400
X-MC-Unique: 4OtiSIiIO6i-aXbkaJW6SQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E35678064AC;
        Mon,  3 Aug 2020 16:42:51 +0000 (UTC)
Received: from ovpn-112-170.ams2.redhat.com (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C267C8AD1C;
        Mon,  3 Aug 2020 16:42:49 +0000 (UTC)
Message-ID: <23193e12ae89515e3044862a5596576b02766378.camel@redhat.com>
Subject: Re: [PATCH net-next] mptcp: use mptcp_for_each_subflow in
 mptcp_stream_accept
From:   Paolo Abeni <pabeni@redhat.com>
To:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 03 Aug 2020 18:42:48 +0200
In-Reply-To: <fe531e58a52eae5aa46dd93d30d623f8862c3d09.1596459430.git.geliangtang@gmail.com>
References: <fe531e58a52eae5aa46dd93d30d623f8862c3d09.1596459430.git.geliangtang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-08-03 at 21:00 +0800, Geliang Tang wrote:
> Use mptcp_for_each_subflow in mptcp_stream_accept instead of
> open-coding.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
>  net/mptcp/protocol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index d3fe7296e1c9..400824eabf73 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -2249,7 +2249,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
>  		 * This is needed so NOSPACE flag can be set from tcp stack.
>  		 */
>  		__mptcp_flush_join_list(msk);
> -		list_for_each_entry(subflow, &msk->conn_list, node) {
> +		mptcp_for_each_subflow(msk, subflow) {
>  			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
>  
>  			if (!ssk->sk_socket)

Acked-by: Paolo Abeni <pabeni@redhat.com>

